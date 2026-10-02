# Soluble — Agent Guide

This project is a **WebGPU art renderer** with two code layers:

- **Calcit/Respo** (UI, tab switching, state) — source in `calcit.cirru`, compiled to ignored `js-out/` via `calcit` (the default entry targets JavaScript in the browser).
- **TypeScript + WGSL** (WebGPU rendering, mirror/fractal demos) — source in `src/`, compiled to `lib/` via `tsc`.

---

## Calcit 层：必读前置

在任何 `cr edit` / `cr tree` 修改之前，先获取最新的 Calcit Agent 指南：

```bash
cr docs agents --full
# 保存在 ~/.config/calcit/Agents.md，后续可直接读该文件
```

如需 Respo 组件写法，读库文档：

```bash
cr libs readme respo.calcit -f docs/Respo-Agent.md
```

### Calcit 工具链

```bash
cr --version
corepack enable && corepack prepare yarn@4.18.0 --activate
yarn --version
```

### 常用开发命令

```bash
calcit                          # 把 calcit.cirru 编译到 js-out/，生成文件不入库
yarn vite                       # 启动开发服务器（HMR）
yarn build                     # Calcit、TypeScript 和前端构建到 dist/
```

### Calcit 编辑规则

- **永远不要直接编辑 `js-out/`**——由 `calcit` 自动生成，手动改会被覆盖。
- 优先用结构化编辑：`cr tree target-replace` / `cr tree replace` / `cr tree insert-*`。
- 整段重写才用 `cr edit def --overwrite`。
- 改之前先 `cr query search <keyword> -f <ns/def>` 拿路径，`cr tree show` 确认上下文。

### Calcit 查询速查

```bash
cr query defs app.comp.container    # 列出命名空间定义
cr query peek app.comp.container/comp-nav   # 轻看定义轮廓
cr query def  app.comp.container/comp-nav   # 看完整定义
cr query search on-click -f app.comp.container/comp-nav  # 拿路径
cr tree show app.comp.container/comp-nav -p '3.2'        # 查子树
```

### 依赖管理

```bash
caps outdated --yes   # 更新 deps.cirru（无交互）
caps                  # 下载/同步模块
yarn install --immutable
```

- `deps.cirru` 的 `:calcit-version` 与 `package.json` 的 `@calcit/procs` 保持同版本链路。

---

## TypeScript / WGSL 层

### 文件结构

```
src/
  index.mts           # 公开 API（createRenderer, paintSolubleTree, createGlobalPointsBuffer 等）
  render.mts          # WebGPU 初始化、pipeline 创建
  paint.mts           # 每帧绘制、buffer 管理（createGlobalPointsBuffer / createSecondaryDataBuffer）
  global.mts          # 全局 atoms（atomDevice, atomPointsBuffer, atomSecondaryBuffer 等）
  primes.mts          # 核心类型（SolubleApp, SolubleObjectData, V3/V4）
  math.mts            # 数学工具（Number4, rand, randBalance 等）
  perspective.mts     # 相机位置（atomViewerPosition, atomViewerScale 等）
  control.mts         # 按钮/手柄事件（ButtonEvents）
  atom.mts            # 响应式 Atom<T>
  apps/               # 每个 demo 对应一对 .mts + .wgsl 文件
shaders/
  soluble-perspective.wgsl   # UniformsData（screen_wh, scale, forward/upward/rightward, viewer_position）
  soluble-math.wgsl          # rand11, perpendicular, product/conjugate/divide 等
  soluble-mirror.wgsl        # ray_closest_point_to_line, try_reflect_ray_with_mirror, MirrorTriangle, Segment
  sdf.wgsl                   # SDF 工具函数
  stroke.wgsl                # 笔触相关
```

### TypeScript 编译

```bash
yarn exec tsc -d --project tsconfig.json --outDir lib/
```

输出到 `lib/`，供 Vite 打包。`tsconfig.json` 的 `target: es2015`，`moduleResolution: Bundler`。

### SolubleApp 接口（每个 demo 必须实现）

```typescript
type SolubleApp = {
  initPointsBuffer: () => void; // 初始化 mirror buffer 和 segment buffer
  useCompute: boolean; // 通常 false（不用 compute shader）
  renderShader: string; // 导入的 .wgsl 字符串
  getParams?: () => number[]; // 传给 WGSL Params uniform，索引 [0]=time 等
  onButtonEvent?: (events: ButtonEvents) => void;
  onDestroy?: () => void;
  getTextures?: (obj: Record<string, GPUTexture>) => GPUTexture[];
};
```

### Buffer 管理

```typescript
// Mirror 三角面（base_points）
createGlobalPointsBuffer(count, (idx) => mirrors[idx]); // position=a, velocity=b, arm=c

// 发光线段（secondary_points）
createSecondaryDataBuffer(count, (idx) => segments[idx]);
// segment: { position: start, velocity: end, arm: zero }
```

- `cachedPointsBaseSize` / `cachedSecondaryBaseSize` 各自独立——切换 demo 时 size 不一致会触发重建，记得 `.destroy()` 旧 buffer。

### WGSL 基础结构（mirror demo 模板）

```wgsl
#import soluble::perspective   // UniformsData uniforms
#import soluble::math          // rand11, PI 等
#import soluble::mirror        // MirrorTriangle, Segment, try_reflect_ray_with_mirror, ray_closest_point_to_line

struct Params { time: f32, dt: f32, lifetime: f32, max_reflections: f32 }
@group(0) @binding(1) var<uniform> params: Params;

struct BaseCell { a: vec4<f32>, b: vec4<f32>, c: vec4<f32> }
@group(1) @binding(0) var<storage, read_write> base_points:      array<BaseCell>;  // mirrors
@group(1) @binding(1) var<storage, read_write> secondary_points: array<BaseCell>;  // segments
```

- `BaseCell.a.xyz` / `.b.xyz` / `.c.xyz` = 三角面三顶点（mirror）或线段两端 + zeros（segment）。
- **WGSL `#import` 通过 `vite-plugin-glsl` 处理。**

### WGSL 光线追踪循环（标准模式）

```wgsl
// fragment_main 中：
for (var times = 0u; times < max_reflect_times + 1u; times++) {
  // 1) 找最近 mirror 碰撞
  // 2) 对 secondary_points 里每条线段计算 color 贡献
  //    let seg_len = length(segment.end - segment.start);
  //    let distance = max(0.001, reach.distance - offset);
  //    var color_scale = C / pow(distance * k + 0.01, 1.8) / f;
  // 3) 随机丢弃（降噪）：if rand11(...) < 0.15 { break; }
  // 4) 更新 current_viewer / current_ray_unit
}
```

### Params buffer 约定

`getParams()` 返回值按顺序映射到 `Params` struct 字段：

```typescript
getParams: () => [performance.now() - store.startedAt, store.maxReflections];
// → time=params[0], max_reflections=params[1]（或 dt/lifetime 视 shader 定义）
```

### Mirror demo 新建流程

1. 在 `src/apps/` 新增 `<name>-mirror.mts` 和 `<name>-mirror.wgsl`。
2. `.mts` 中用 `makeCell(a, b, c)` 构造 mirror 和 segment，实现 `SolubleApp`。
3. 使用 Calcit 结构化工具修改 `calcit.cirru` 中的 `app.main` 导入与注册，以及 `app.comp.container/tab-groups`；不要修改生成的 JavaScript。
4. 运行 `yarn build`，编译 Calcit、TypeScript 并验证前端打包；生成文件不入库。

---

## 验证清单（推荐顺序）

```bash
yarn install --immutable
yarn build  # 检查 Calcit、TypeScript、WGSL 和前端 bundle
```

CI 使用同一构建链路（`.github/workflows/upload.yaml`），通过 `VITE_BASE_URL` 指定 COS CDN 路径，部署 `dist/*`。本地复现生产资源路径时可运行：

```bash
VITE_BASE_URL=https://cos-sh.tiye.me/WebGPU-Art/soluble/ yarn build
```

---

## 项目特定注意事项

- `calcit.cirru` 是 Calcit 源码的唯一真相，依赖由 `deps.cirru` 管理；**不要手动编辑或提交 `js-out/`**。
- `deps.cirru` 的 `:calcit-version` 与 `package.json` `@calcit/procs` 保持一致。
- `app.comp.container/on-keydown` 使用 `read-string`（来自 `cljs.reader`）。
- Yarn Berry，`nodeLinker: node-modules`。
- URL tab 持久化：tab 切换调用 `history.replaceState`，写入 `?tab=` 参数；`app.schema/store` 初始化时读取 `URLSearchParams`。
- `paint.mts` 中 `cachedPointsBaseSize` 和 `cachedSecondaryBaseSize` 独立管理，避免内存泄漏。
- 所有 mirror demo 的 `bounce_tint` 约为原始值的 3×，rand drop 阈值 `< 0.15`。
