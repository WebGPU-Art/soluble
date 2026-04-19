import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./tetrahedron-mirror.wgsl";
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
  let a: Number4 = [100, 100, 100, 0];
  let b: Number4 = [100, -100, -100, 0];
  let c: Number4 = [-100, 100, -100, 0];
  let d: Number4 = [-100, -100, 100, 0];
  return [makeCell(a, b, c), makeCell(a, d, b), makeCell(a, c, d), makeCell(c, b, d)];
};

let createLightSegments = (): Cell[] => {
  const zero: Number4 = [0, 0, 0, 0];
  // outer tetrahedron vertices
  let a: Number4 = [100, 100, 100, 0];
  let b: Number4 = [100, -100, -100, 0];
  let c: Number4 = [-100, 100, -100, 0];
  let d: Number4 = [-100, -100, 100, 0];
  // inner tetrahedron: same orientation, scaled to r=0.3
  const r = 0.3;
  let ia: Number4 = [100 * r, 100 * r, 100 * r, 0];
  let ib: Number4 = [100 * r, -100 * r, -100 * r, 0];
  let ic: Number4 = [-100 * r, 100 * r, -100 * r, 0];
  let id: Number4 = [-100 * r, -100 * r, 100 * r, 0];
  return [
    // 6 edges of the inner tetrahedron
    makeCell(ia, ib, zero),
    makeCell(ia, ic, zero),
    makeCell(ia, id, zero),
    makeCell(ib, ic, zero),
    makeCell(ib, id, zero),
    makeCell(ic, id, zero),
    // 4 connecting segments: outer vertex -> inner vertex
    makeCell(a, ia, zero),
    makeCell(b, ib, zero),
    makeCell(c, ic, zero),
    makeCell(d, id, zero),
  ];
};

export const tetrahedronMirrorConfigs: SolubleApp = {
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
