import { createGlobalPointsBuffer } from "../index.mjs";

import mirrors from "./kaleidoscope-mirror.wgsl";
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

let createAwl = () => {
  let a = 80;
  let d = 2000;

  let cells = [] as Cell[];
  let sides = 5;
  let unit = (Math.PI * 2) / 5;
  let p0: Number4 = [0, 0, -d, 0];
  for (let i = 0; i < sides; i++) {
    let angle1 = i * unit;
    let angle2 = (i + 1) * unit;
    let p1: Number4 = [a * Math.cos(angle1), a * Math.sin(-angle1), d, 0];
    let p2: Number4 = [a * Math.cos(angle2), a * Math.sin(-angle2), d, 0];
    cells.push(makeCell(p0, p1, p2));
  }
  return cells;
};

export const kaleidoscopeMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    // let items = createOctahedron();
    // let items = createCube();
    // let items = createCone();
    let items = createAwl();
    // let items = createAngle();
    // let items = createRegularIcosahedron();
    // let items = createRegularTetrahedron();
    // let items = createRegularDodecahedron();

    createGlobalPointsBuffer(items.length, (idx) => items[idx]);
  },
  useCompute: false,
  renderShader: mirrors,
  // onButtonEvent: (events: ButtonEvents) => { },
  getParams: () => {
    return [performance.now() - store.startedAt];
  },
  getTextures: (obj) => {
    return [obj["stripes"]].filter(Boolean);
    // candy bubbles pigment stripes
  },
};
