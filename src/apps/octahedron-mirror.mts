import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./octahedron-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

let store = {
  startedAt: performance.now(),
  maxReflections: 4,
  angleY: 0,
  lastTickAt: performance.now(),
};

type Cell = { position: Number4; velocity: Number4; arm: Number4 };

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
    makeCell(n_x, n_y, n_z),
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

  return [makeCell(p_x, n_x, zero), makeCell(p_y, n_y, zero), makeCell(p_z, n_z, zero)];
};

const baseMirrors = createMirrors();
const baseSegments = createLightSegments();

export const octahedronMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(baseMirrors.length, (idx) => baseMirrors[idx]);
    createSecondaryDataBuffer(baseSegments.length, (idx) => baseSegments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    updateHeldYRotation(store, baseMirrors, baseSegments);
    return [performance.now() - store.startedAt, store.maxReflections];
  },
};
