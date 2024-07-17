import { createGlobalPointsBuffer } from "../index.mjs";

import mirrors from "./hollow-mirror.wgsl?raw";
import { Number2, Number3, Number4, rand, randBalance, randBetween, range } from "../math.mjs";
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

let makeCell = (a: Number3, b: Number3) => {
  let base = 100;
  return { position: [a[0] * base, a[1] * base, a[2] * base, 0] as Number4, velocity: [b[0] * base, b[1] * base, b[2] * base, 0] as Number4 } as Cell;
};

let createAwl = () => {
  return [
    // V
    makeCell([0, -20, 0], [0, 20, 0]),
    // makeCell([-40, 0, 0], [40, , 0]),
    makeCell([0, 0, -20], [0, 0, 20]),
    // makeCell([-100, 0, -20], [100, 0, 20]),
  ] as Cell[];
};

export const hollowMirrorConfigs: SolubleApp = {
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
    // console.log(obj["bubbles"]);
    return [obj["bubbles"]].filter(Boolean);
  },
};
