import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./prism-mirror.wgsl";
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
  const r = 100;
  const h = 200;
  const p0: Number4 = [0, r, h, 0];
  const p1: Number4 = [-r * 0.866, -r * 0.5, h, 0];
  const p2: Number4 = [r * 0.866, -r * 0.5, h, 0];

  const p3: Number4 = [0, r, -h, 0];
  const p4: Number4 = [-r * 0.866, -r * 0.5, -h, 0];
  const p5: Number4 = [r * 0.866, -r * 0.5, -h, 0];

  return [
    makeCell(p0, p1, p4),
    makeCell(p0, p4, p3),
    makeCell(p1, p2, p5),
    makeCell(p1, p5, p4),
    makeCell(p2, p0, p3),
    makeCell(p2, p3, p5),
    makeCell(p0, p2, p1),
    makeCell(p3, p4, p5),
  ];
};

let createLightSegments = (): Cell[] => {
  const zero: Number4 = [0, 0, 0, 0];
  const r = 100;
  const h = 200;
  const p0: Number4 = [0, r, h, 0];
  const p1: Number4 = [-r * 0.866, -r * 0.5, h, 0];
  const p2: Number4 = [r * 0.866, -r * 0.5, h, 0];

  const p3: Number4 = [0, r, -h, 0];
  const p4: Number4 = [-r * 0.866, -r * 0.5, -h, 0];
  const p5: Number4 = [r * 0.866, -r * 0.5, -h, 0];

  return [makeCell(p0, p4, zero), makeCell(p1, p5, zero), makeCell(p2, p3, zero)];
};

const baseMirrors = createMirrors();
const baseSegments = createLightSegments();

export const prismMirrorConfigs: SolubleApp = {
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
