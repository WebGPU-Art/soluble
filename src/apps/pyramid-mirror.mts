import { createGlobalPointsBuffer } from "../index.mjs";

import pyramidShader from "./pyramid-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";

let store = {
  startedAt: performance.now(),
  maxReflections: 6,
};

type Cell = {
  position: Number4;
  velocity: Number4;
  arm: Number4;
};

let makeCell = (a: Number4, b: Number4, c: Number4): Cell => {
  return { position: a, velocity: b, arm: c };
};

/**
 * Create 6 mirror triangles: 4 triangular side faces + 1 square base (split into 2 triangles).
 * Pyramid: apex at (0, 120, 0), base corners at (±100, -100, ±100).
 */
let createPyramid = (): Cell[] => {
  const apex: Number4 = [0, 120, 0, 0];
  const p0: Number4 = [-100, -100, 100, 0]; // front-left base
  const p1: Number4 = [100, -100, 100, 0]; // front-right base
  const p2: Number4 = [100, -100, -100, 0]; // back-right base
  const p3: Number4 = [-100, -100, -100, 0]; // back-left base
  const zero: Number4 = [0, 0, 0, 0];

  return [
    // 4 triangular side faces (normals pointing inward so reflections work)
    makeCell(apex, p1, p0), // front face
    makeCell(apex, p2, p1), // right face
    makeCell(apex, p3, p2), // back face
    makeCell(apex, p0, p3), // left face
    // base (2 triangles)
    makeCell(p0, p1, p2),
    makeCell(p0, p2, p3),
  ];
};

/**
 * Light source: a vertical line segment near the center of the pyramid,
 * plus a couple of diagonal ones for visual variety.
 */
let createLightSegments = (): Cell[] => {
  const zero: Number4 = [0, 0, 0, 0];
  return [
    // main vertical segment through the pyramid interior
    makeCell([0, 120, 0, 0], [0, -100, 0, 0], zero),
    // diagonal warm accent segments
    // makeCell([-30, 40, 30, 0], [30, -20, -30, 0], zero),
    // makeCell([30, 40, -30, 0], [-30, -20, 30, 0], zero),
  ];
};

export const pyramidMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    const mirrors = createPyramid();
    const segments = createLightSegments();

    createGlobalPointsBuffer(mirrors.length, (idx) => mirrors[idx]);
    createSecondaryDataBuffer(segments.length, (idx) => segments[idx]);
  },
  useCompute: false,
  renderShader: pyramidShader,
  getParams: () => {
    return [performance.now() - store.startedAt, store.maxReflections];
  },
};
