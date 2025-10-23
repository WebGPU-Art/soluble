import { createGlobalPointsBuffer } from "../index.mjs";

import dotsClockShader from "./dots-clock.wgsl";
import { useBaseSize } from "../config.mjs";
import { Number4, rand } from "../math.mjs";
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

// 线段定义 (相对坐标)
const SEGMENTS = [
  { start: [-0.4, 0.8], end: [0.4, 0.8] }, // 上
  { start: [0.4, 0.8], end: [0.4, 0.0] }, // 右上
  { start: [0.4, 0.0], end: [0.4, -0.8] }, // 右下
  { start: [0.4, -0.8], end: [-0.4, -0.8] }, // 下
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

let currentTime = { h: 0, m: 0, s: 0 };
let lastUpdateTime = 0;
let animationProgress = 1.0; // 0-1, 1表示动画完成

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

// 计算所有活跃线段的总长度
function getTotalActiveLength(digits: number[]): number {
  let total = 0;
  for (let digitIdx = 0; digitIdx < 6; digitIdx++) {
    const activeSegments = getActiveSegments(digits[digitIdx]);
    for (let segIdx = 0; segIdx < 7; segIdx++) {
      if (activeSegments[segIdx]) {
        const seg = SEGMENTS[segIdx];
        const dx = seg.end[0] - seg.start[0];
        const dy = seg.end[1] - seg.start[1];
        total += Math.sqrt(dx * dx + dy * dy);
      }
    }
  }
  return total;
}

// 为点分配位置
function distributePoints(digits: number[], totalPoints: number): Array<{ pos: Number4; oldPos?: Number4 }> {
  const points: Array<{ pos: Number4; oldPos?: Number4 }> = [];
  const totalLength = getTotalActiveLength(digits);
  let pointIndex = 0;

  for (let digitIdx = 0; digitIdx < 6; digitIdx++) {
    const activeSegments = getActiveSegments(digits[digitIdx]);
    const digitPos = DIGIT_POSITIONS[digitIdx];

    for (let segIdx = 0; segIdx < 7; segIdx++) {
      if (activeSegments[segIdx]) {
        const seg = SEGMENTS[segIdx];
        const dx = seg.end[0] - seg.start[0];
        const dy = seg.end[1] - seg.start[1];
        const segLength = Math.sqrt(dx * dx + dy * dy);

        // 根据线段长度分配点数
        const pointsInSegment = Math.round((segLength / totalLength) * totalPoints);

        for (let i = 0; i < pointsInSegment && pointIndex < totalPoints; i++) {
          const t = (i + 0.5) / pointsInSegment; // 在线段上的位置
          const x = seg.start[0] + dx * t + digitPos[0];
          const y = seg.start[1] + dy * t + digitPos[1];
          const z = 0;

          points.push({
            pos: [x * 100, y * 100, z, 1], // 放大坐标
          });
          pointIndex++;
        }
      }
    }
  }

  // 如果点数不够，随机填充
  while (points.length < totalPoints) {
    points.push({
      pos: [0, 0, 0, 1],
    });
  }

  return points.slice(0, totalPoints);
}

let pointPositions: Array<{ pos: Number4; oldPos?: Number4 }> = [];

let createPoint = (idx: number): BaseCellParams => {
  const now = Date.now();

  // 检查是否需要更新时间
  if (now - lastUpdateTime > 1000) {
    // 每秒更新
    const newDigits = getCurrentTimeDigits();
    const oldPositions = pointPositions.map((p) => p.pos);

    pointPositions = distributePoints(newDigits, useBaseSize);

    // 设置旧位置用于动画
    for (let i = 0; i < pointPositions.length; i++) {
      if (i < oldPositions.length) {
        pointPositions[i].oldPos = oldPositions[i];
      } else {
        pointPositions[i].oldPos = pointPositions[i].pos;
      }
    }

    lastUpdateTime = now;
    animationProgress = 0;
  }

  // 更新动画进度
  const timeSinceUpdate = now - lastUpdateTime;
  animationProgress = Math.min(timeSinceUpdate / 400, 1.0); // 0.4秒动画

  // 如果还没有初始化位置，先初始化
  if (pointPositions.length === 0) {
    const initialDigits = getCurrentTimeDigits();
    pointPositions = distributePoints(initialDigits, useBaseSize);
  }

  const pointData = pointPositions[idx] || { pos: [0, 0, 0, 1] };
  const currentPos = pointData.pos;
  const oldPos = pointData.oldPos || currentPos;

  // 插值计算当前位置
  const t = animationProgress;
  const smoothT = t * t * (3 - 2 * t); // 平滑插值

  const x = oldPos[0] + (currentPos[0] - oldPos[0]) * smoothT;
  const y = oldPos[1] + (currentPos[1] - oldPos[1]) * smoothT;
  const z = oldPos[2] + (currentPos[2] - oldPos[2]) * smoothT;

  const position: Number4 = [x, y, z, 1];
  const params: Number4 = [8, 1, 10, idx]; // 大小、频率、亮度、索引

  return { position, params };
};

export const dotsClockConfigs = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(useBaseSize, createPoint);
  },
  useCompute: false,
  renderShader: dotsClockShader,
};
