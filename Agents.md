# Soluble — Agent Guide

本项目包含两层：Calcit/Respo 管理标签、UI 和 Reel；TypeScript/WGSL 管理 GPU 渲染和输入。

## Calcit 源码与类型

- 唯一源码快照为 `calcit.cirru`，依赖声明为 `deps.cirru`；不恢复 `compact.cirru` 或 `package.cirru`。
- 开始修改前读 `calcit docs agents --contract`；首次使用或超出紧凑契约时读 `calcit docs agents --full`。
- 只用官方 query/tree/edit/config 读取和修改快照。多步事务先 dry-run，再传返回的 scoped revision。
- API 事实以当前固定 CLI 的 `--help`、`query def/type/context` 为准，不复制过期 cr/libs 命令。
- Respo 文档：`calcit docs read docs/Respo-Agent.md --module respo.calcit --full`；示例仍须按当前严格合同核实。
- Store、Op、Tab、TabGroup 位于 `app.schema`；5 组、59 个标签为唯一导航/URL 校验数据源。
- RuntimeAPI 声明具体宿主方法与回调合同；不要用裸 Fn、伪 JsObject 或 unsafe 隐藏开放输入。
- `src/calcit-runtime.mts` 持有 Promise/GPU 对象，不把它们传回应用状态。
- Reel 保留开发历史；状态树只更新 Store.states，避免重复嵌套 store。watcher 接受新、旧值并返回 Unit。
- 标签通过 URL 持久化；旧 workflow localStorage 存档不再读写，不要为升级删除用户数据。

## 开发和检查

固定配对 Calcit/procs 0.30.1-alpha.5、Node 24、Yarn 4.18.0。正式 0.30.1 资产未齐备前不混用运行时。

```bash
caps --strict --ci
yarn install --immutable
calcit --check-only --all-defs
calcit fix --workflow strict --verify
calcit test --require-match
yarn build
```

遵守用户对本地 Caps 的额外限制；CI 独立解析依赖。`yarn dev` 初次编译后启动 Vite，另一个终端
`yarn watch` 监听 Calcit。`yarn build` 顺序编译 Calcit、TypeScript 和前端；不添加 concurrently。
js-out/、lib/、dist/ 和 .calcit/ 都是忽略的生成/临时目录，不能手工修改生成代码或提交它们。
大快照 diff 用 `calcit analyze program-diff <base-ref>` 先审阅语义分类，再验证真实行为。

## TypeScript / WGSL

- src/index.mts 保留公开渲染 API；src/primes.mts 定义 SolubleApp、V2/V3/V4 等类型。
- 新场景在 src/apps/ 添加 .mts / .wgsl，加入 runtime 的配置表和 app.schema/tab-groups。
  参数、名称和 ID 保持一一对应；不要编辑 js-out/app.main.mjs。
- 单独检查 TypeScript：`yarn exec tsc -d --project tsconfig.json --outDir lib/`。
- shader 的 perspective/math/mirror 导入由现有构建链处理；不要改资源路径来掩盖类型问题。
- BaseCell.a/b/c 对应 position/velocity/arm；mirror 三角面存三个顶点，segment 存两端与 zeros。
- getParams() 数组顺序必须与 WGSL Params 字段一致，不能只按 JS 调用成功推断布局正确。
- points 与 secondary buffer 缓存大小独立维护，切换时销毁旧 buffer；先 waitForRenderIdle 再重建。
- 使用 callFramePaint 串行提交帧，避免叠加渲染循环。渲染源更新刷新 GPU context，Calcit UI 有独立 HMR。
- 手柄 ButtonEvents、轴变换、threshold 和镜面 shader 参数沿用原约定，不在迁移中偷偷更改算法。

## 部署与验收

- VITE_BASE_URL=https://cos-sh.tiye.me/WebGPU-Art/soluble/ 只配置前端构建资源。
- 保留原图片 URL、COS action 内置校验、main 新鲜度保护、串行生产队列及 rsync 原路径。
- PR 只检查和构建，不上传或部署。不增加重复上传验证器、质量基线或逐项目规则脚本。
- 区分 Calcit 类型检查、TS 编译、真实 WebGPU 出帧、URL/标签切换和物理手柄输入。
  构建、mock 或 synthetic 证据不等于真实 GPU/手柄验收。
