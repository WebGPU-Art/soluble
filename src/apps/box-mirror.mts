import { createGlobalPointsBuffer } from "../index.mjs";

import mirrors from "./box-mirror.wgsl";
import { Number4, rand, randBalance, randBetween, range } from "../math.mjs";
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
  arm: Number4;
};

let makeCell = (a: Number4, b: Number4, c: Number4) => {
  return { position: a, velocity: b, arm: c } as Cell;
};

let createBox = () => {
  let a = 80;
  // a bube
  let p0: Number4 = [-a, -a, a, 0];
  let p1: Number4 = [a, -a, a, 0];
  let p2: Number4 = [a, -a, -a, 0];
  let p3: Number4 = [-a, -a, -a, 0];
  let p4: Number4 = [-a, a, a, 0];
  let p5: Number4 = [a, a, a, 0];
  let p6: Number4 = [a, a, -a, 0];
  let p7: Number4 = [-a, a, -a, 0];

  return [
    makeCell(p0, p1, p2),
    makeCell(p0, p2, p3),
    makeCell(p0, p1, p5),
    makeCell(p0, p4, p5),
    makeCell(p0, p7, p3),
    makeCell(p0, p7, p4),
    makeCell(p1, p6, p2),
    makeCell(p1, p6, p5),
    makeCell(p2, p7, p3),
    makeCell(p2, p7, p6),
    makeCell(p4, p6, p5),
    makeCell(p4, p6, p7),
  ] as Cell[];
};

export const boxMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    let items = createBox();

    createGlobalPointsBuffer(items.length, (idx) => items[idx]);
  },
  useCompute: false,
  renderShader: mirrors,
  // onButtonEvent: (events: ButtonEvents) => { },
  getParams: () => {
    return [performance.now() - store.startedAt];
  },
  // getTextures: (obj) => {
  //   return [obj["bubbles"]].filter(Boolean);
  // },
};
