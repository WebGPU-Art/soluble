import { createGlobalPointsBuffer } from "../index.mjs";

import mirrors from "./box-mirror.wgsl";
import { Number4, rand, randBalance, randBetween, range } from "../math.mjs";
import { type ButtonEvents } from "../control.mjs";
import { SolubleApp } from "../primes.mjs";
import { BaseCellParams, createSecondaryDataBuffer } from "../paint.mjs";

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
  // a cube
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

let createSegments = () => {
  let d = 26.4;
  let zero: Number4 = [0, 0, 0, 0];
  let p0: Number4 = [-d, -d, d, 0];
  let p1: Number4 = [d, -d, d, 0];
  let p2: Number4 = [d, -d, -d, 0];
  let p3: Number4 = [-d, -d, -d, 0];
  let p4: Number4 = [-d, d, d, 0];
  let p5: Number4 = [d, d, d, 0];
  let p6: Number4 = [d, d, -d, 0];
  let p7: Number4 = [-d, d, -d, 0];
  return [
    makeCell(p0, p1, zero),
    makeCell(p1, p2, zero),
    makeCell(p2, p3, zero),
    makeCell(p3, p0, zero),
    makeCell(p4, p5, zero),
    makeCell(p5, p6, zero),
    makeCell(p6, p7, zero),
    makeCell(p7, p4, zero),
    makeCell(p0, p4, zero),
    makeCell(p1, p5, zero),
    makeCell(p2, p6, zero),
    makeCell(p3, p7, zero),
    makeCell(p0, [3 * p0[0], 3 * p0[1], 3 * p0[2], 0], zero),
    makeCell(p1, [3 * p1[0], 3 * p1[1], 3 * p1[2], 0], zero),
    makeCell(p2, [3 * p2[0], 3 * p2[1], 3 * p2[2], 0], zero),
    makeCell(p3, [3 * p3[0], 3 * p3[1], 3 * p3[2], 0], zero),
    makeCell(p4, [3 * p4[0], 3 * p4[1], 3 * p4[2], 0], zero),
    makeCell(p5, [3 * p5[0], 3 * p5[1], 3 * p5[2], 0], zero),
    makeCell(p6, [3 * p6[0], 3 * p6[1], 3 * p6[2], 0], zero),
    makeCell(p7, [3 * p7[0], 3 * p7[1], 3 * p7[2], 0], zero),
  ] as Cell[];
};

export const boxMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    let items = createBox();
    let secondary = createSegments();

    createGlobalPointsBuffer(items.length, (idx) => items[idx]);
    createSecondaryDataBuffer(secondary.length, (idx) => secondary[idx]);
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
