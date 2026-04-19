import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./octahedron-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";

let store = {
  startedAt: performance.now(),
  maxReflections: 4,
};

type Cell = { position: Number4; velocity: Number4; arm: Number4; };

let makeCell = (a: Number4, b: Number4, c: Number4): Cell => {
  return { position: a, velocity: b, arm: c };
};

let createMirrors = (): Cell[] => {
  const R = 120;
  const p_x: Number4 = [R, 0, 0, 0];
  const n_x: Number4 = [-R, 0, 0, 0];
  const p_y: Number4 = [0, R, 0, 0];
  const n_y: Number4 = [0, -R, 0, 0];
  const p_z: Number4 = [0, 0, R, 0];
  const n_z: Number4 = [0, 0, -R, 0];

  return [
    makeCell(p_x, p_y, p_z),
    makeCell(n_x, p_y, p_z),
    makeCell(p_x, n_y, p_z),
    makeCell(n_x, n_y, p_z),
    makeCell(p_x, p_y, n_z),
    makeCell(n_x, p_y, n_z),
    makeCell(p_x, n_y, n_z),
    makeCell(n_x, n_y, n_z)
  ];
};

let createLightSegments = (): Cell[] => {
  const zero: Number4 = [0, 0, 0, 0];
  const R = 120;
  const p_x: Number4 = [R, 0, 0, 0];
  const n_x: Number4 = [-R, 0, 0, 0];
  const p_y: Number4 = [0, R, 0, 0];
  const n_y: Number4 = [0, -R, 0, 0];
  const p_z: Number4 = [0, 0, R, 0];
  const n_z: Number4 = [0, 0, -R, 0];

  return [
    makeCell(p_x, p_y, zero),
    makeCell(n_x, n_y, zero),
    makeCell(p_y, p_z, zero)
  ];
};

export const octahedronMirrorConfigs: SolubleApp = {
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
