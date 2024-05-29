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

let makeCell = (a: Number4, b: Number4, c: Number4) => {
  return { position: a, velocity: b, arm: c } as Cell;
};

// 4 faces
let createRegularTetrahedron = () => {
  let a = 200;
  let p1: Number4 = [a, -a, -a, 0];
  let p2: Number4 = [-a, -a, a, 0];
  let p3: Number4 = [-a, a, -a, 0];
  let p4: Number4 = [a, a, a, 0];

  return [makeCell(p1, p2, p3), makeCell(p1, p2, p4), makeCell(p1, p3, p4), makeCell(p2, p3, p4)] as Cell[];
};

// 6 faces
let createCube = () => {
  let p1: Number4 = [-a, -a, a, 0];
  let p2: Number4 = [a, -a, a, 0];
  let p3: Number4 = [a, -a, -a, 0];
  let p4: Number4 = [-a, -a, -a, 0];
  let p5: Number4 = [-a, a, a, 0];
  let p6: Number4 = [a, a, a, 0];
  let p7: Number4 = [a, a, -a, 0];
  let p8: Number4 = [-a, a, -a, 0];

  return [
    makeCell(p1, p2, p3),
    makeCell(p1, p3, p4),
    makeCell(p1, p2, p6),
    makeCell(p1, p5, p6),
    makeCell(p1, p8, p4),
    makeCell(p1, p8, p5),
    makeCell(p2, p7, p3),
    makeCell(p2, p7, p6),
    makeCell(p3, p8, p4),
    makeCell(p3, p8, p7),
    makeCell(p5, p7, p6),
    makeCell(p5, p7, p8),
  ] as Cell[];
};

// 8 faces
let createOctahedron = () => {
  let p1: Number4 = [-a, 0, a, 0];
  let p2: Number4 = [a, 0, a, 0];
  let p3: Number4 = [a, 0, -a, 0];
  let p4: Number4 = [-a, 0, -a, 0];
  let p5: Number4 = [0, a * Math.SQRT2, 0, 0];
  let p6: Number4 = [0, -a * Math.SQRT2, 0, 0];

  return [
    makeCell(p1, p2, p5),
    makeCell(p2, p3, p5),
    makeCell(p3, p4, p5),
    makeCell(p4, p1, p5),
    makeCell(p1, p2, p6),
    makeCell(p2, p3, p6),
    makeCell(p3, p4, p6),
    makeCell(p4, p1, p6),
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
    cells.push(makeCell(p1, p2, p3));
    cells.push(makeCell(p1, p2, p4));
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

  return [makeCell(p1, p2, p3), makeCell(p2, p3, p4), makeCell(p1, p2, p5), makeCell(p2, p5, p6)] as Cell[];
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
    makeCell(p1, p9, p2),
    // 1 2 12
    makeCell(p1, p2, p12),
    // 2 11 12
    makeCell(p2, p11, p12),

    /// 2nd
    // 1 5 15
    makeCell(p1, p5, p15),
    // 1 9 10
    makeCell(p1, p9, p10),
    // 1 5 10
    makeCell(p1, p5, p10),

    /// 3rd
    // 9 10 2
    makeCell(p9, p10, p2),
    // 2 6 10
    makeCell(p2, p6, p10),
    // 2 6 17
    makeCell(p2, p6, p17),

    /// 4th
    // 2 3 17
    makeCell(p2, p3, p17),
    // 3 17 18
    makeCell(p3, p17, p18),
    // 2 3 11
    makeCell(p2, p3, p11),

    /// 5th
    // 3 11 12
    makeCell(p3, p11, p12),
    // 3 4 12
    makeCell(p3, p4, p12),
    // 3 4 13
    makeCell(p3, p4, p13),

    /// 6th
    // 1 4 12
    makeCell(p1, p4, p12),
    // 1 4 16
    makeCell(p1, p4, p16),
    // 1 15 16
    makeCell(p1, p15, p16),

    /// 7th
    // 7 8 14
    makeCell(p7, p8, p14),
    // 7 8 19
    makeCell(p7, p8, p19),
    // 8 19 20
    makeCell(p8, p19, p20),

    /// 8th
    // 8 14 16
    makeCell(p8, p14, p16),
    // 14 16 4
    makeCell(p14, p16, p4),
    // 13 14 4
    makeCell(p13, p14, p4),

    /// 9th
    // 13 14 7
    makeCell(p13, p14, p7),
    // 7 13 3
    makeCell(p7, p13, p3),
    // 3 7 18
    makeCell(p3, p7, p18),

    /// 10th
    // 6 7 19
    makeCell(p6, p7, p19),
    // 6 7 17
    makeCell(p6, p7, p17),
    // 7 17 18
    makeCell(p7, p17, p18),

    /// 11th
    // 6 19 20
    makeCell(p6, p19, p20),
    // 6 10 20
    makeCell(p6, p10, p20),
    // 5 10 20
    makeCell(p5, p10, p20),

    /// 12th
    // 5 8 20
    makeCell(p5, p8, p20),
    // 5 8 16
    makeCell(p5, p8, p16),
    // 5 15 16
    makeCell(p5, p15, p16),
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
    makeCell(a1, a2, a3),
    makeCell(a1, a3, a4),
    makeCell(a1, a4, a5),
    makeCell(a1, a5, a6),
    makeCell(a1, a6, a2),

    makeCell(a2, a3, a8),
    makeCell(a3, a4, a7),
    makeCell(a4, a5, a11),
    makeCell(a5, a6, a10),
    makeCell(a6, a2, a9),

    makeCell(a7, a8, a3),
    makeCell(a8, a9, a2),
    makeCell(a9, a10, a6),
    makeCell(a10, a11, a5),
    makeCell(a11, a7, a4),

    makeCell(a7, a12, a8),
    makeCell(a8, a12, a9),
    makeCell(a9, a12, a10),
    makeCell(a10, a12, a11),
    makeCell(a11, a12, a7),
  ] as Cell[];
};

export const surroundMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    // let items = createOctahedron();
    // let items = createCube();
    // let items = createCone();
    // let items = createAngle();
    // let items = createRegularIcosahedron();
    let items = createRegularTetrahedron();
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
    return [obj["pigment"]];
  },
};
