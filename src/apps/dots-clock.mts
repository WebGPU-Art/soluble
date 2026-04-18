import { createGlobalPointsBuffer, writePointsBufferRaw } from "../index.mjs";
import { atomViewerPosition, atomViewerUpward, newLookatPoint } from "../perspective.mjs";
import { vNormalize, vCross } from "../quaternion.mjs";

import dotsClockShader from "./dots-clock.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { BaseCellParams } from "../paint.mjs";

// 七段显示器数字编码 (7个位对应7个线段: 上、右上、右下、下、左下、左上、中间)
const SEVEN_SEGMENT_DIGITS = [
  0b1111110, // 0: 上右上右下下左下左上
  0b0110000, // 1: 右上右下
  0b1101101, // 2: 上右上中下左下
  0b1111001, // 3: 上右上右下下中
  0b0110011, // 4: 右上右下左上中
  0b1011011, // 5: 上右下下左上中
  0b1011111, // 6: 上右下下左下左上中
  0b1110000, // 7: 上右上右下
  0b1111111, // 8: 全部
  0b1111011, // 9: 上右上右下下左上中
];

// 线段定义 (相对坐标) - 使用完全直线的七段显示器布局
const SEGMENTS = [
  { start: [-0.4, 0.8], end: [0.4, 0.8] }, // 上
  { start: [0.4, 0.8], end: [0.4, 0.0] }, // 右上
  { start: [0.4, 0.0], end: [0.4, -0.8] }, // 右下
  { start: [-0.4, -0.8], end: [0.4, -0.8] }, // 下
  { start: [-0.4, -0.8], end: [-0.4, 0.0] }, // 左下
  { start: [-0.4, 0.0], end: [-0.4, 0.8] }, // 左上
  { start: [-0.4, 0.0], end: [0.4, 0.0] }, // 中间
];

// 数字位置 (6个数字: HH:MM:SS)
const DIGIT_POSITIONS = [
  [-3.0, 0],
  [-1.8, 0], // 小时
  [0, 0],
  [1.2, 0], // 分钟
  [2.8, 0],
  [4.0, 0], // 秒
];

let lastUpdateTime = 0;
let animationProgress = 1.0; // 0-1, 1表示动画完成
const TOTAL_POINTS = 192;
const ACTIVE_POINT_BUDGET = 160;
const ANIMATION_DURATION = 400;
const DOT_SIZE = 4.25;
const IDLE_BLOCK_COLUMNS = 8;
const IDLE_BLOCK_SPACING_X = 28;
const IDLE_BLOCK_SPACING_Y = 18;
const IDLE_BLOCK_CENTER_X = 40;
const IDLE_BLOCK_TOP_Y = -118;
const FLOATS_PER_POINT = 8; // matches BaseCell struct: vec4 + 4×f32

// ── 预分配 GPU 数据缓冲 ──
const gpuData = new Float32Array(TOTAL_POINTS * FLOATS_PER_POINT);

type ClockPoint = { pos: Number4; oldPos?: Number4 };
type ActiveSegment = {
  digitPos: number[];
  start: number[];
  dx: number;
  dy: number;
};

// 获取当前时间的数字数组
function getCurrentTimeDigits(): number[] {
  const now = new Date();
  const h = now.getHours();
  const m = now.getMinutes();
  const s = now.getSeconds();

  return [Math.floor(h / 10), h % 10, Math.floor(m / 10), m % 10, Math.floor(s / 10), s % 10];
}

// 计算某个数字的所有活跃线段
function getActiveSegments(digit: number): boolean[] {
  const code = SEVEN_SEGMENT_DIGITS[digit];
  return SEGMENTS.map((_, i) => (code & (1 << (6 - i))) !== 0);
}

function pseudoRandom(seed: number): number {
  const value = Math.sin(seed * 12.9898 + 78.233) * 43758.5453;
  return value - Math.floor(value);
}

function createIdlePosition(idx: number): Number4 {
  const column = idx % IDLE_BLOCK_COLUMNS;
  const row = Math.floor(idx / IDLE_BLOCK_COLUMNS);
  const jitterX = (pseudoRandom(idx + 11) - 0.5) * 6;
  const jitterY = (pseudoRandom(idx + 29) - 0.5) * 5;
  const x = IDLE_BLOCK_CENTER_X + (column - (IDLE_BLOCK_COLUMNS - 1) * 0.5) * IDLE_BLOCK_SPACING_X + jitterX;
  const y = IDLE_BLOCK_TOP_Y - row * IDLE_BLOCK_SPACING_Y + jitterY;
  const z = -10 - pseudoRandom(idx + 47) * 12;
  return [x, y, z, 1];
}

const IDLE_POSITIONS: Number4[] = Array.from({ length: TOTAL_POINTS }, (_, idx) => createIdlePosition(idx));

function getActiveSegmentEntries(digits: number[]): ActiveSegment[] {
  const activeEntries: ActiveSegment[] = [];

  for (let digitIdx = 0; digitIdx < 6; digitIdx++) {
    const activeSegments = getActiveSegments(digits[digitIdx]);
    const digitPos = DIGIT_POSITIONS[digitIdx];

    for (let segIdx = 0; segIdx < 7; segIdx++) {
      if (!activeSegments[segIdx]) {
        continue;
      }

      const seg = SEGMENTS[segIdx];
      activeEntries.push({
        digitPos,
        start: seg.start,
        dx: seg.end[0] - seg.start[0],
        dy: seg.end[1] - seg.start[1],
      });
    }
  }

  return activeEntries;
}

// 为点分配位置
function distributePoints(digits: number[], totalPoints: number): ClockPoint[] {
  const points: ClockPoint[] = [];
  const activeSegments = getActiveSegmentEntries(digits);

  if (activeSegments.length === 0) {
    return IDLE_POSITIONS.slice(0, totalPoints).map((pos) => ({ pos }));
  }

  const activePointBudget = Math.min(totalPoints, ACTIVE_POINT_BUDGET);
  const basePointsPerSegment = Math.max(1, Math.floor(activePointBudget / activeSegments.length));
  const remainder = activePointBudget - basePointsPerSegment * activeSegments.length;

  for (let segIdx = 0; segIdx < activeSegments.length; segIdx++) {
    const seg = activeSegments[segIdx];
    const pointsInSegment = basePointsPerSegment + (segIdx < remainder ? 1 : 0);

    for (let i = 0; i < pointsInSegment; i++) {
      const t = (i + 0.5) / pointsInSegment;
      const x = seg.start[0] + seg.dx * t + seg.digitPos[0];
      const y = seg.start[1] + seg.dy * t + seg.digitPos[1];

      points.push({
        pos: [x * 100, y * 100, 0, 1],
      });
    }
  }

  while (points.length < totalPoints) {
    points.push({ pos: IDLE_POSITIONS[points.length] });
  }

  return points;
}

let pointPositions: ClockPoint[] = [];

function ensurePointPositions() {
  if (pointPositions.length > 0) return;
  pointPositions = distributePoints(getCurrentTimeDigits(), TOTAL_POINTS);
  lastCheckedSecond = new Date().getSeconds();
  lastUpdateTime = Date.now();
}

// ── GPU 数据填充：CPU 端做投影，shader 只需 2D 距离 ──
function fillGpuData() {
  const lookAt = newLookatPoint();
  const fwd = vNormalize(lookAt);
  const up = atomViewerUpward.deref();
  const right = vCross(fwd, up);
  const vp = atomViewerPosition.deref();

  const t = animationProgress;
  const smoothT = t * t * (3 - 2 * t);

  for (let i = 0; i < TOTAL_POINTS; i++) {
    const pd = pointPositions[i];
    const off = i * FLOATS_PER_POINT;

    if (!pd) {
      gpuData[off] = 1e5;
      gpuData[off + 1] = 1e5;
      gpuData[off + 2] = 0;
      continue;
    }

    const pos = pd.pos;
    const old = pd.oldPos || pos;

    // 插值 world 坐标
    const wx = old[0] + (pos[0] - old[0]) * smoothT;
    const wy = old[1] + (pos[1] - old[1]) * smoothT;
    const wz = old[2] + (pos[2] - old[2]) * smoothT;

    // view vector
    const vx = wx - vp[0];
    const vy = wy - vp[1];
    const vz = wz - vp[2];

    // depth = dot(view, forward)
    const depth = vx * fwd[0] + vy * fwd[1] + vz * fwd[2];

    if (depth <= 1.0) {
      gpuData[off] = 1e5;
      gpuData[off + 1] = 1e5;
      gpuData[off + 2] = 0;
      continue;
    }

    const inv = 2.0 / depth;
    gpuData[off] = (vx * right[0] + vy * right[1] + vz * right[2]) * inv;
    gpuData[off + 1] = (vx * up[0] + vy * up[1] + vz * up[2]) * inv;
    gpuData[off + 2] = DOT_SIZE * inv;
    // gpuData[off+3..7] 留 0
  }
}

// 添加一个全局变量来跟踪上次检查的秒数
let lastCheckedSecond = -1;
let forceUpdate = true;
let updateTimer: ReturnType<typeof setTimeout> | null = null;
let isActive = false;

function stopUpdateTimer() {
  if (updateTimer) {
    clearTimeout(updateTimer);
    updateTimer = null;
  }
  isActive = false;
}

function queueNextTick() {
  if (!isActive) return;
  const delay = Math.max(16, 1020 - (Date.now() % 1000));
  updateTimer = setTimeout(() => {
    updateTimer = null;
    if (!isActive) return;
    updatePointPositions();
    queueNextTick();
  }, delay);
}

function startUpdateTimer() {
  stopUpdateTimer();
  isActive = true;
  queueNextTick();
}

(globalThis as any).stopDotsClockTimer = stopUpdateTimer;

function updatePointPositions() {
  ensurePointPositions();
  const sec = new Date().getSeconds();

  if (sec !== lastCheckedSecond || forceUpdate) {
    const newDigits = getCurrentTimeDigits();
    const oldPositions = pointPositions.map((p) => ({ ...p }));
    pointPositions = distributePoints(newDigits, TOTAL_POINTS);

    for (let i = 0; i < pointPositions.length; i++) {
      pointPositions[i].oldPos = i < oldPositions.length ? oldPositions[i].pos : pointPositions[i].pos;
    }

    lastUpdateTime = Date.now();
    animationProgress = 0;
    lastCheckedSecond = sec;
    forceUpdate = false;
    return true;
  }
  return false;
}

function syncPointsBuffer() {
  ensurePointPositions();

  if (animationProgress < 1.0) {
    animationProgress = Math.min((Date.now() - lastUpdateTime) / ANIMATION_DURATION, 1.0);
  }

  fillGpuData();
  writePointsBufferRaw(gpuData);
}

// 初始化用的简单回调 (仅用于 createGlobalPointsBuffer 建正确大小的 buffer)
let initCreatePoint = (_idx: number): BaseCellParams => {
  return { position: [0, 0, 0, 0], params: [0, 0, 0, 0] };
};

export const dotsClockConfigs: SolubleApp = {
  initPointsBuffer: () => {
    updatePointPositions();
    // 创建正确大小的 GPU buffer (数据随后覆写)
    createGlobalPointsBuffer(TOTAL_POINTS, initCreatePoint);
    // 立即填充实际投影数据
    fillGpuData();
    writePointsBufferRaw(gpuData);
    startUpdateTimer();
  },
  useCompute: false,
  renderShader: dotsClockShader,
  getParams: () => {
    syncPointsBuffer();
    return [animationProgress < 1.0 ? 1 : 0, ACTIVE_POINT_BUDGET, TOTAL_POINTS];
  },
  onDestroy: () => {
    stopUpdateTimer();
  },
};
