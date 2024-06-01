import { createGlobalPointsBuffer } from "../index.mjs";

import mirrors from "./parallel-mirror.wgsl?raw";
import { Number2, Number4, rand, randBalance, randBetween, range } from "../math.mjs";
import { type ButtonEvents } from "../control.mjs";
import { SolubleApp } from "../primes.mjs";
import { BaseCellParams } from "../paint.mjs";

let store = {
  disableLens: 0, // or 1
  radius: 0.98,
  startedAt: performance.now(),
};

type Cell = {
  position: Number4;
  velocity: Number4;
};

let makeCell = (a: Number2, b: Number2) => {
  let base = 20;
  return { position: [a[0] * base, a[1] * base, 0, 0] as Number4, velocity: [b[0] * base, b[1] * base, 0, 0] as Number4 } as Cell;
};

let createAwl = () => {
  return [
    // V
    makeCell([-5, 2], [-3, -2]),
    makeCell([-3, -2], [-1, 2]),
    // u
    makeCell([-1, 0], [-1, -1]),
    makeCell([-1, -1], [-0.5, -2]),
    makeCell([-0.5, -2], [1, -2]),
    makeCell([1, -2], [1, 0]),
    // e
    makeCell([2, -1], [4, -1]),
    makeCell([4, -1], [3.5, 0]),
    makeCell([3.5, 0], [2.5, 0]),
    makeCell([2.5, 0], [2, -1]),
    makeCell([2, -1], [2.5, -2]),
    makeCell([2.5, -2], [3.5, -2]),
  ] as Cell[];
};

export const parallelMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    let items = createAwl();

    createGlobalPointsBuffer(items.length, (idx) => items[idx]);
  },
  useCompute: false,
  renderShader: mirrors,
  // onButtonEvent: (events: ButtonEvents) => { },
  getParams: () => {
    return [performance.now() - store.startedAt];
  },
  getTextures: (obj) => {
    return [obj["bubbles"]].filter(Boolean);
  },
};
