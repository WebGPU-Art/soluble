import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./icosahedron-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";

let store = {
  startedAt: performance.now(),
  maxReflections: 4,
};

type Cell = { position: Number4; velocity: Number4; arm: Number4 };

let makeCell = (a: Number4, b: Number4, c: Number4): Cell => {
  return { position: a, velocity: b, arm: c };
};

let createMirrors = (): Cell[] => {
  const t = (1.0 + Math.sqrt(5.0)) / 2.0;
  const s = 60;
  const pts = [
    [-1, t, 0],
    [1, t, 0],
    [-1, -t, 0],
    [1, -t, 0],
    [0, -1, t],
    [0, 1, t],
    [0, -1, -t],
    [0, 1, -t],
    [t, 0, -1],
    [t, 0, 1],
    [-t, 0, -1],
    [-t, 0, 1],
  ].map((p) => [p[0] * s, p[1] * s, p[2] * s, 0] as Number4);

  const indices = [
    0, 11, 5, 0, 5, 1, 0, 1, 7, 0, 7, 10, 0, 10, 11, 1, 5, 9, 5, 11, 4, 11, 10, 2, 10, 7, 6, 7, 1, 8, 3, 9, 4, 3, 4, 2, 3, 2, 6, 3, 6, 8, 3, 8, 9, 4, 9, 5, 2,
    4, 11, 6, 2, 10, 8, 6, 7, 9, 8, 1,
  ];

  let cells: Cell[] = [];
  for (let i = 0; i < indices.length; i += 3) {
    cells.push(makeCell(pts[indices[i]], pts[indices[i + 1]], pts[indices[i + 2]]));
  }
  return cells;
};

let createLightSegments = (): Cell[] => {
  const zero: Number4 = [0, 0, 0, 0];
  const t = (1.0 + Math.sqrt(5.0)) / 2.0;
  const s = 60;
  const pts = [
    [-1, t, 0],
    [1, t, 0],
    [-1, -t, 0],
    [1, -t, 0],
    [0, -1, t],
    [0, 1, t],
    [0, -1, -t],
    [0, 1, -t],
    [t, 0, -1],
    [t, 0, 1],
    [-t, 0, -1],
    [-t, 0, 1],
  ].map((p) => [p[0] * s, p[1] * s, p[2] * s, 0] as Number4);

  // antipodal pairs: longest diagonals through center (~228 vs ~120 for edge-adjacent)
  return [makeCell(pts[0], pts[3], zero), makeCell(pts[5], pts[6], zero), makeCell(pts[9], pts[10], zero)];
};

export const icosahedronMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    const mirrors = createMirrors();
    const segments = createLightSegments();
    createGlobalPointsBuffer(mirrors.length, (idx) => mirrors[idx]);
    createSecondaryDataBuffer(segments.length, (idx) => segments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    return [performance.now() - store.startedAt, store.maxReflections];
  },
};
