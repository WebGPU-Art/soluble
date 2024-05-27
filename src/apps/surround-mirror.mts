import { createGlobalPointsBuffer } from "../index.mjs";

import mirrors from "./surround-mirror.wgsl";
import { Number4, rand, randBalance, range } from "../math.mjs";
import { type ButtonEvents } from "../control.mjs";
import { SolubleApp } from "../primes.mjs";
import { BaseCellParams } from "../paint.mjs";

let store = {
  disableLens: 0, // or 1
  radius: 0.98,
  startedAt: performance.now(),
};

let a = 400;

type Cell = {
  position: Number4;
  velocity: Number4;
  arm: Number4;
};

let createCube = () => {
  let p1 = [-a, -a, a, 0];
  let p2 = [a, -a, a, 0];
  let p3 = [a, -a, -a, 0];
  let p4 = [-a, -a, -a, 0];
  let p5 = [-a, a, a, 0];
  let p6 = [a, a, a, 0];
  let p7 = [a, a, -a, 0];
  let p8 = [-a, a, -a, 0];

  return [
    { position: p1, velocity: p2, arm: p3 },
    { position: p1, velocity: p3, arm: p4 },
    { position: p1, velocity: p2, arm: p6 },
    { position: p1, velocity: p5, arm: p6 },
    { position: p1, velocity: p8, arm: p4 },
    { position: p1, velocity: p8, arm: p5 },
    { position: p2, velocity: p7, arm: p3 },
    { position: p2, velocity: p7, arm: p6 },
    { position: p3, velocity: p8, arm: p4 },
    { position: p3, velocity: p8, arm: p7 },
    { position: p5, velocity: p7, arm: p6 },
    { position: p5, velocity: p7, arm: p8 },
  ] as Cell[];
};

let createOctahedron = () => {
  let p1 = [-a, 0, a, 0];
  let p2 = [a, 0, a, 0];
  let p3 = [a, 0, -a, 0];
  let p4 = [-a, 0, -a, 0];
  let p5 = [0, a * Math.SQRT2, 0, 0];
  let p6 = [0, -a * Math.SQRT2, 0, 0];

  return [
    { position: p1, velocity: p2, arm: p5 },
    { position: p2, velocity: p3, arm: p5 },
    { position: p3, velocity: p4, arm: p5 },
    { position: p4, velocity: p1, arm: p5 },
    { position: p1, velocity: p2, arm: p6 },
    { position: p2, velocity: p3, arm: p6 },
    { position: p3, velocity: p4, arm: p6 },
    { position: p4, velocity: p1, arm: p6 },
  ] as Cell[];
};

let createCone = () => {
  let cells: Cell[] = [];
  let n = 8;
  range(n).forEach((idx) => {
    let angle = (idx / n) * 2 * Math.PI;
    let angleNext = ((idx + 1) / n) * 2 * Math.PI;
    let r = 400;
    let h = 400;
    let p1: Number4 = [r * Math.cos(angle), r * Math.sin(angle), 0, 0];
    let p2: Number4 = [r * Math.cos(angleNext), r * Math.sin(angleNext), 0, 0];
    let p3: Number4 = [0, 0, h, 0];
    let p4: Number4 = [0, 0, -0.1, 0];
    cells.push({ position: p1, velocity: p2, arm: p3 });
    cells.push({ position: p1, velocity: p2, arm: p4 });
  });

  return cells;
};

export const surroundMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    // let items = createOctahedron();
    // let items = createCube();
    let items = createCone();
    createGlobalPointsBuffer(items.length, (idx) => items[idx]);
  },
  useCompute: false,
  renderShader: mirrors,
  // onButtonEvent: (events: ButtonEvents) => { },
  getParams: () => {
    return [performance.now() - store.startedAt];
  },
};
