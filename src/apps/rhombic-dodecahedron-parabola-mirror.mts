import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./rhombic-dodecahedron-parabola-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

type Cell = { position: Number4; velocity: Number4; arm: Number4 };

const makeCell = (a: Number4, b: Number4, c: Number4): Cell => ({
  position: a,
  velocity: b,
  arm: c,
});

const makeSegment = (a: Number4, b: Number4): Cell => makeCell(a, b, [0, 0, 0, 0]);

const u = 100;
const pTop: Number4 = [0, 2 * u, 0, 0];
const pBottom: Number4 = [0, -2 * u, 0, 0];
const pLeft: Number4 = [-2 * u, 0, 0, 0];
const pRight: Number4 = [2 * u, 0, 0, 0];
const pFront: Number4 = [0, 0, 2 * u, 0];
const pBack: Number4 = [0, 0, -2 * u, 0];
const p1: Number4 = [-u, u, u, 0];
const p2: Number4 = [u, u, u, 0];
const p3: Number4 = [u, u, -u, 0];
const p4: Number4 = [-u, u, -u, 0];
const p5: Number4 = [-u, -u, u, 0];
const p6: Number4 = [u, -u, u, 0];
const p7: Number4 = [u, -u, -u, 0];
const p8: Number4 = [-u, -u, -u, 0];

const mirrors: Cell[] = [
  makeCell(pTop, p1, p2),
  makeCell(pTop, p2, p3),
  makeCell(pTop, p3, p4),
  makeCell(pTop, p4, p1),
  makeCell(pBottom, p5, p6),
  makeCell(pBottom, p6, p7),
  makeCell(pBottom, p7, p8),
  makeCell(pBottom, p8, p5),
  makeCell(pLeft, p1, p4),
  makeCell(pLeft, p4, p8),
  makeCell(pLeft, p8, p5),
  makeCell(pLeft, p5, p1),
  makeCell(pRight, p2, p3),
  makeCell(pRight, p3, p7),
  makeCell(pRight, p7, p6),
  makeCell(pRight, p6, p2),
  makeCell(pFront, p1, p2),
  makeCell(pFront, p2, p6),
  makeCell(pFront, p6, p5),
  makeCell(pFront, p5, p1),
  makeCell(pBack, p4, p3),
  makeCell(pBack, p3, p7),
  makeCell(pBack, p7, p8),
  makeCell(pBack, p8, p4),
];

const segments: Cell[] = [
  makeSegment(pTop, pBottom),
  makeSegment(pLeft, pRight),
  makeSegment(pFront, pBack),
  makeSegment(p1, p7),
  makeSegment(p2, p8),
  makeSegment(p3, p5),
  makeSegment(p4, p6),
];

let store = {
  startedAt: performance.now(),
  maxReflections: 5,
  angleY: 0,
  lastTickAt: performance.now(),
};

const LR = 0.01;
const LG = 0.013;
const LB = 0.03;
const BR = 0.008;
const BG = 0.01;
const BB = 0.022;
// Peak downward acceleration inside the polyhedron. The shader oscillates
// continuously between 0 and this value, so at the trough the picture matches
// the straight-line `rhombic-dodecahedron-diagonals-mirror` exactly and at the
// crest interior legs bend into visible parabolas.
const CURVE_MAX = 0.00192;

export const rhombicDodecahedronParabolaMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(mirrors.length, (idx) => mirrors[idx]);
    createSecondaryDataBuffer(segments.length, (idx) => segments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    updateHeldYRotation(store, mirrors, segments);
    return [(performance.now() - store.startedAt) / 512, store.maxReflections, LR, LG, LB, BR, BG, BB, CURVE_MAX];
  },
};
