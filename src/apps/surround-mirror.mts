import { createGlobalPointsBuffer } from "../index.mjs";

import mirrors from "./surround-mirror.wgsl";
import { Number4, rand, randBalance, randBetween, range } from "../math.mjs";
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

// 4 faces
let createRegularTetrahedron = () => {
  let a = 200;
  let p1: Number4 = [a, -a, -a, 0];
  let p2: Number4 = [-a, -a, a, 0];
  let p3: Number4 = [-a, a, -a, 0];
  let p4: Number4 = [a, a, a, 0];

  return [
    { position: p1, velocity: p2, arm: p3 },
    { position: p1, velocity: p2, arm: p4 },
    { position: p1, velocity: p3, arm: p4 },
    { position: p2, velocity: p3, arm: p4 },
  ] as Cell[];
};

// 6 faces
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

// 8 faces
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

let createAngle = () => {
  let ratio = 0.6;
  let p1: Number4 = [0, -a, -a, 0];
  let p2: Number4 = [0, a, -a, 0];
  let p3: Number4 = [-ratio * a, -a, a, 0];
  let p4: Number4 = [-ratio * a, a, a, 0];
  let p5: Number4 = [ratio * a, -a, a, 0];
  let p6: Number4 = [ratio * a, a, a, 0];

  return [
    { position: p1, velocity: p2, arm: p3 },
    { position: p2, velocity: p3, arm: p4 },
    { position: p1, velocity: p2, arm: p5 },
    { position: p2, velocity: p5, arm: p6 },
  ] as Cell[];
};

// 12 faces, 20 vertices, according to https://en.wikipedia.org/wiki/Regular_dodecahedron
// TODO check each points
let createRegularDodecahedron = () => {
  let a = 200;
  let phi = (1 + Math.sqrt(5)) / 2;
  let scaled = (v: Number4, s: number) => v.map((x) => x * s) as Number4;

  let p1: Number4 = scaled([-1, -1, 1, 0], a);
  let p2: Number4 = scaled([1, -1, 1, 0], a);
  let p3: Number4 = scaled([1, -1, -1, 0], a);
  let p4: Number4 = scaled([-1, -1, -1, 0], a);

  let p5: Number4 = scaled([-1, 1, 1, 0], a);
  let p6: Number4 = scaled([1, 1, 1, 0], a);
  let p7: Number4 = scaled([1, 1, -1, 0], a);
  let p8: Number4 = scaled([-1, 1, -1, 0], a);

  let p9: Number4 = scaled([0, -1 / phi, phi, 0], a);
  let p10: Number4 = scaled([0, 1 / phi, phi, 0], a);
  let p11: Number4 = scaled([1 / phi, -phi, 0, 0], a);
  let p12: Number4 = scaled([-1 / phi, -phi, 0, 0], a);

  let p13: Number4 = scaled([0, -1 / phi, -phi, 0], a);
  let p14: Number4 = scaled([0, 1 / phi, -phi, 0], a);
  let p15: Number4 = scaled([-phi, 0, 1 / phi, 0], a);
  let p16: Number4 = scaled([-phi, 0, -1 / phi, 0], a);

  let p17: Number4 = scaled([phi, 0, 1 / phi, 0], a);
  let p18: Number4 = scaled([phi, 0, -1 / phi, 0], a);
  let p19: Number4 = scaled([1 / phi, phi, 0, 0], a);
  let p20: Number4 = scaled([-1 / phi, phi, 0, 0], a);

  // 12 faces, but 36 triangles
  return [
    /// 1st
    // 1 9 2
    { position: p1, velocity: p9, arm: p2 },
    // 1 2 12
    { position: p1, velocity: p2, arm: p12 },
    // 2 11 12
    { position: p2, velocity: p11, arm: p12 },

    /// 2nd
    // 1 5 15
    { position: p1, velocity: p5, arm: p15 },
    // 1 9 10
    { position: p1, velocity: p9, arm: p10 },
    // 1 5 10
    { position: p1, velocity: p5, arm: p10 },

    /// 3rd
    // 9 10 2
    { position: p9, velocity: p10, arm: p2 },
    // 2 6 10
    { position: p2, velocity: p6, arm: p10 },
    // 2 6 17
    { position: p2, velocity: p6, arm: p17 },

    /// 4th
    // 2 3 17
    { position: p2, velocity: p3, arm: p17 },
    // 3 17 18
    { position: p3, velocity: p17, arm: p18 },
    // 2 3 11
    { position: p2, velocity: p3, arm: p11 },

    /// 5th
    // 3 11 12
    { position: p3, velocity: p11, arm: p12 },
    // 3 4 12
    { position: p3, velocity: p4, arm: p12 },
    // 3 4 13
    { position: p3, velocity: p4, arm: p13 },

    /// 6th
    // 1 4 12
    { position: p1, velocity: p4, arm: p12 },
    // 1 4 16
    { position: p1, velocity: p4, arm: p16 },
    // 1 15 16
    { position: p1, velocity: p15, arm: p16 },

    /// 7th
    // 7 8 14
    { position: p7, velocity: p8, arm: p14 },
    // 7 8 19
    { position: p7, velocity: p8, arm: p19 },
    // 8 19 20
    { position: p8, velocity: p19, arm: p20 },

    /// 8th
    // 8 14 16
    { position: p8, velocity: p14, arm: p16 },
    // 14 16 4
    { position: p14, velocity: p16, arm: p4 },
    // 13 14 4
    { position: p13, velocity: p14, arm: p4 },

    /// 9th
    // 13 14 7
    { position: p13, velocity: p14, arm: p7 },
    // 7 13 3
    { position: p7, velocity: p13, arm: p3 },
    // 3 7 18
    { position: p3, velocity: p7, arm: p18 },

    /// 10th
    // 6 7 19
    { position: p6, velocity: p7, arm: p19 },
    // 6 7 17
    { position: p6, velocity: p7, arm: p17 },
    // 7 17 18
    { position: p7, velocity: p17, arm: p18 },

    /// 11th
    // 6 19 20
    { position: p6, velocity: p19, arm: p20 },
    // 6 10 20
    { position: p6, velocity: p10, arm: p20 },
    // 5 10 20
    { position: p5, velocity: p10, arm: p20 },

    /// 12th
    // 5 8 20
    { position: p5, velocity: p8, arm: p20 },
    // 5 8 16
    { position: p5, velocity: p8, arm: p16 },
    // 5 15 16
    { position: p5, velocity: p15, arm: p16 },
  ] as Cell[];
};

// 20 faces, thanks to https://math.stackexchange.com/a/2174924/54238
let createRegularIcosahedron = () => {
  let sqrt5 = Math.sqrt(5);
  let scaled = (v: Number4, s: number) => v.map((x) => x * s) as Number4;

  let a1: Number4 = scaled([1, 0, 0, 0], a);

  let a2: Number4 = scaled([1 / sqrt5, 2 / sqrt5, 0, 0], a);
  let a3: Number4 = scaled([1 / sqrt5, (5 - sqrt5) / 10, Math.sqrt((5 + sqrt5) / 10), 0], a);
  let a4: Number4 = scaled([1 / sqrt5, (-5 - sqrt5) / 10, Math.sqrt((5 - sqrt5) / 10), 0], a);
  let a5: Number4 = scaled([1 / sqrt5, (-5 - sqrt5) / 10, -Math.sqrt((5 - sqrt5) / 10), 0], a);
  let a6: Number4 = scaled([1 / sqrt5, (5 - sqrt5) / 10, -Math.sqrt((5 + sqrt5) / 10), 0], a);

  let a7: Number4 = scaled([-1 / sqrt5, (-5 + sqrt5) / 10, Math.sqrt((5 + sqrt5) / 10), 0], a);
  let a8: Number4 = scaled([-1 / sqrt5, (5 + sqrt5) / 10, Math.sqrt((5 - sqrt5) / 10), 0], a);
  let a9: Number4 = scaled([-1 / sqrt5, (5 + sqrt5) / 10, -Math.sqrt((5 - sqrt5) / 10), 0], a);
  let a10: Number4 = scaled([-1 / sqrt5, (-5 + sqrt5) / 10, -Math.sqrt((5 + sqrt5) / 10), 0], a);
  let a11: Number4 = scaled([-1 / sqrt5, -2 / sqrt5, 0, 0], a);

  let a12: Number4 = scaled([-1, 0, 0, 0], a);
  return [
    { position: a1, velocity: a2, arm: a3 },
    { position: a1, velocity: a3, arm: a4 },
    { position: a1, velocity: a4, arm: a5 },
    { position: a1, velocity: a5, arm: a6 },
    { position: a1, velocity: a6, arm: a2 },

    { position: a2, velocity: a3, arm: a8 },
    { position: a3, velocity: a4, arm: a7 },
    { position: a4, velocity: a5, arm: a11 },
    { position: a5, velocity: a6, arm: a10 },
    { position: a6, velocity: a2, arm: a9 },

    { position: a7, velocity: a8, arm: a3 },
    { position: a8, velocity: a9, arm: a2 },
    { position: a9, velocity: a10, arm: a6 },
    { position: a10, velocity: a11, arm: a5 },
    { position: a11, velocity: a7, arm: a4 },

    { position: a7, velocity: a12, arm: a8 },
    { position: a8, velocity: a12, arm: a9 },
    { position: a9, velocity: a12, arm: a10 },
    { position: a10, velocity: a12, arm: a11 },
    { position: a11, velocity: a12, arm: a7 },
  ] as Cell[];
};

export const surroundMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    // let items = createOctahedron();
    // let items = createCube();
    // let items = createCone();
    // let items = createAngle();
    // let items = createRegularIcosahedron();
    // let items = createRegularTetrahedron();
    let items = createRegularDodecahedron();

    createGlobalPointsBuffer(items.length, (idx) => items[idx]);
  },
  useCompute: false,
  renderShader: mirrors,
  // onButtonEvent: (events: ButtonEvents) => { },
  getParams: () => {
    return [performance.now() - store.startedAt];
  },
};
