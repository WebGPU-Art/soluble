import { createGlobalPointsBuffer } from "../index.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";
import shader from "./glass-mirror.wgsl";
import { type ButtonEvents } from "../control.mjs";
import { SolubleApp } from "../primes.mjs";
import { buildPolyhedronCells, V3 } from "./polyhedra-builder.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

const vertices: V3[] = [
  [0, 150, 0],
  [0, -150, 0],
  [-150, 0, 0],
  [150, 0, 0],
  [0, 0, 150],
  [0, 0, -150],
];

const faces: number[][] = [
  [0, 4, 3],
  [0, 3, 5],
  [0, 5, 2],
  [0, 2, 4],
  [1, 3, 4],
  [1, 5, 3],
  [1, 2, 5],
  [1, 4, 2],
];

const geometry = buildPolyhedronCells(vertices, faces);

let store = {
  startedAt: performance.now(),
  maxReflections: 8,
  angleY: 0,
  lastTickAt: performance.now(),
};

export const crystalRefractionConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(geometry.mirrors.length, (idx) => geometry.mirrors[idx]);
    createSecondaryDataBuffer(geometry.segments.length, (idx) => geometry.segments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  onButtonEvent: (_events: ButtonEvents) => {},
  getParams: () => {
    const t = performance.now() - store.startedAt;
    updateHeldYRotation(store, geometry.mirrors, geometry.segments);
    return [t, store.maxReflections, 0.006, 0.030, 0.040, 0.010, 0.018, 0.034, 1.49, 0.78];
  },
};