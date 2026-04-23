import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./polyhedra-color-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

// Rhombic dodecahedron: 12 congruent rhombus faces, 14 vertices (6 axis + 8 cube corners).
// It is the dual of the cuboctahedron and a space-filling zonohedron.
// This demo focuses on the 7 symmetric long diagonals:
//   - 3 axis-to-axis diagonals (±x, ±y, ±z pairs)
//   - 4 body diagonals of the inner cube (each connecting a pair of antipodal cube corners)

type Cell = { position: Number4; velocity: Number4; arm: Number4 };

const makeCell = (a: Number4, b: Number4, c: Number4): Cell => ({
  position: a,
  velocity: b,
  arm: c,
});

const makeSegment = (a: Number4, b: Number4): Cell => makeCell(a, b, [0, 0, 0, 0]);

const u = 100;

// 6 axis vertices (degree-4 in the rhombic dodecahedron), distance 2u from center
const pTop: Number4 = [0, 2 * u, 0, 0];
const pBottom: Number4 = [0, -2 * u, 0, 0];
const pLeft: Number4 = [-2 * u, 0, 0, 0];
const pRight: Number4 = [2 * u, 0, 0, 0];
const pFront: Number4 = [0, 0, 2 * u, 0];
const pBack: Number4 = [0, 0, -2 * u, 0];

// 8 cube-corner vertices (degree-3), distance √3·u from center
const p1: Number4 = [-u, u, u, 0]; // top-left-front
const p2: Number4 = [u, u, u, 0]; // top-right-front
const p3: Number4 = [u, u, -u, 0]; // top-right-back
const p4: Number4 = [-u, u, -u, 0]; // top-left-back
const p5: Number4 = [-u, -u, u, 0]; // bottom-left-front
const p6: Number4 = [u, -u, u, 0]; // bottom-right-front
const p7: Number4 = [u, -u, -u, 0]; // bottom-right-back
const p8: Number4 = [-u, -u, -u, 0]; // bottom-left-back

// Each rhombus face is split into 2 mirror triangles (same structure as the original rhombic demo).
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

// 7 symmetric long diagonals: 3 axis pairs + 4 cube-corner body diagonals.
// Each axis pair spans 4u; each cube-corner pair spans 2√3·u ≈ 3.46u.
const segments: Cell[] = [
  makeSegment(pTop, pBottom), // y-axis span
  makeSegment(pLeft, pRight), // x-axis span
  makeSegment(pFront, pBack), // z-axis span
  makeSegment(p1, p7), // cube body diagonal: (-u,u,u) ↔ (u,-u,-u)
  makeSegment(p2, p8), // cube body diagonal: (u,u,u) ↔ (-u,-u,-u)
  makeSegment(p3, p5), // cube body diagonal: (u,u,-u) ↔ (-u,-u,u)
  makeSegment(p4, p6), // cube body diagonal: (-u,u,-u) ↔ (u,-u,u)
];

let store = {
  startedAt: performance.now(),
  maxReflections: 5,
  angleY: 0,
  lastTickAt: performance.now(),
};

// Indigo/violet tint — distinct from the warm amber of the rhombohedron demo.
const LR = 0.009;
const LG = 0.005;
const LB = 0.026;
const BR = 0.006;
const BG = 0.003;
const BB = 0.019;

export const rhombicDodecahedronDiagonalsMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(mirrors.length, (idx) => mirrors[idx]);
    createSecondaryDataBuffer(segments.length, (idx) => segments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    updateHeldYRotation(store, mirrors, segments);
    return [performance.now() - store.startedAt, store.maxReflections, LR, LG, LB, BR, BG, BB];
  },
};
