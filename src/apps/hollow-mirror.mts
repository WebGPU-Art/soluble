import { createGlobalPointsBuffer } from "../index.mjs";

import mirrors from "./hollow-mirror.wgsl?raw";
import { Number2, Number3, Number4, rand, randBalance, randBetween, range } from "../math.mjs";
import { type ButtonEvents } from "../control.mjs";
import { SolubleApp } from "../primes.mjs";
import { BaseCellParams } from "../paint.mjs";

let store = {
  startedAt: performance.now(),
};

type Cell = {
  position: Number4;
  velocity: Number4;
};

let makeCell = (base: number, a: Number3, b: Number3) => {
  return { position: [a[0] * base, a[1] * base, a[2] * base, 0] as Number4, velocity: [b[0] * base, b[1] * base, b[2] * base, 0] as Number4 } as Cell;
};

let createLines = () => {
  return [
    // lines
    makeCell(100, [0, -20, 0], [0, 20, 0]),
    makeCell(100, [0, 0, -20], [0, 0, 20]),
  ] as Cell[];
};

export const hollowMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    let items = createLines();

    createGlobalPointsBuffer(items.length, (idx) => items[idx]);
  },
  useCompute: false,
  renderShader: mirrors,
  getParams: () => {
    return [performance.now() - store.startedAt];
  },
  getTextures: (obj) => {
    // console.log(obj["bubbles"]);
    return [obj["bubbles"]].filter(Boolean);
  },
};
