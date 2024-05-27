import { createGlobalPointsBuffer } from "../index.mjs";

import mirrors from "./surround-mirror.wgsl";
import { Number4, rand, randBalance } from "../math.mjs";
import { type ButtonEvents } from "../control.mjs";
import { SolubleApp } from "../primes.mjs";
import { BaseCellParams } from "../paint.mjs";

let store = {
  disableLens: 0, // or 1
  radius: 0.98,
  startedAt: performance.now(),
};

let a = 400;

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
  ] as {
    position: Number4;
    velocity: Number4;
    arm: Number4;
  }[];
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
  ] as {
    position: Number4;
    velocity: Number4;
    arm: Number4;
  }[];
};

export const surroundMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    // let items = createOctahedron();
    let items = createCube();
    createGlobalPointsBuffer(items.length, (idx) => items[idx]);
  },
  useCompute: false,
  renderShader: mirrors,
  // onButtonEvent: (events: ButtonEvents) => { },
  getParams: () => {
    return [performance.now() - store.startedAt];
  },
};
