import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./wedge-mirror.wgsl";
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
  const angle = (36 * Math.PI) / 180;
  const c = Math.cos(angle);
  const s = Math.sin(angle);
  const R = 200;
  const H = 200;

  const p0: Number4 = [0, 0, H, 0];
  const p1: Number4 = [R, 0, H, 0];
  const p2: Number4 = [R * c, R * s, H, 0];

  const p3: Number4 = [0, 0, -H, 0];
  const p4: Number4 = [R, 0, -H, 0];
  const p5: Number4 = [R * c, R * s, -H, 0];

  return [
    makeCell(p0, p4, p1),
    makeCell(p0, p3, p4),
    makeCell(p0, p2, p5),
    makeCell(p0, p5, p3),
    makeCell(p1, p4, p5),
    makeCell(p1, p5, p2),
    makeCell(p0, p1, p2),
    makeCell(p3, p5, p4),
  ];
};

let createLightSegments = (): Cell[] => {
  const zero: Number4 = [0, 0, 0, 0];
  const angle = (36 * Math.PI) / 180;
  const c = Math.cos(angle);
  const s = Math.sin(angle);
  const R = 200;
  const H = 200;

  const p0: Number4 = [0, 0, H, 0];
  const p2: Number4 = [R * c, R * s, H, 0];

  const p3: Number4 = [0, 0, -H, 0];
  const p4: Number4 = [R, 0, -H, 0];

  return [makeCell(p0, p4, zero), makeCell(p3, p2, zero)];
};

export const wedgeMirrorConfigs: SolubleApp = {
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
