import { createGlobalPointsBuffer } from "../index.mjs";
// Reuse the geometry-agnostic parabola shader.
import shader from "./rhombic-dodecahedron-parabola-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

// Regular tetrahedron inscribed in a cube of side 2u.
// Vertices: alternate corners of the cube so every edge = 2u√2.
//   a = ( u, u, u)
//   b = ( u,-u,-u)
//   c = (-u, u,-u)
//   d = (-u,-u, u)

type Cell = { position: Number4; velocity: Number4; arm: Number4 };
const makeCell = (a: Number4, b: Number4, c: Number4): Cell => ({ position: a, velocity: b, arm: c });
const makeSegment = (a: Number4, b: Number4): Cell => makeCell(a, b, [0, 0, 0, 0]);

const u = 100;
const a: Number4 = [u, u, u, 0];
const b: Number4 = [u, -u, -u, 0];
const c: Number4 = [-u, u, -u, 0];
const d: Number4 = [-u, -u, u, 0];

// 4 faces (normals handled in shader by dot-product sign check)
const mirrors: Cell[] = [
  makeCell(a, b, c),
  makeCell(a, d, b),
  makeCell(a, c, d),
  makeCell(c, b, d),
];

// Segments = 6 edges of the tetrahedron. These are the light-emitting lines that
// appear as glowing streaks inside the mirror cavity.
const segments: Cell[] = [
  makeSegment(a, b),
  makeSegment(a, c),
  makeSegment(a, d),
  makeSegment(b, c),
  makeSegment(b, d),
  makeSegment(c, d),
];

let store = {
  startedAt: performance.now(),
  maxReflections: 6,
  angleY: 0,
  lastTickAt: performance.now(),
};

// Warm amber/gold palette — visually distinct from the green tetrahedron-mirror.
const LR = 0.025;
const LG = 0.015;
const LB = 0.006;
const BR = 0.018;
const BG = 0.010;
const BB = 0.004;

// Peak downward acceleration inside the tetrahedron. With edge ~283 units a
// ray traversing half an edge (≈140 units) drops 0.5 * 0.0004 * 140² ≈ 4 units
// at the peak — clearly visible but not chaotic.
const CURVE_MAX = 0.0004;

export const tetrahedronParabolaMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(mirrors.length, (idx) => mirrors[idx]);
    createSecondaryDataBuffer(segments.length, (idx) => segments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    updateHeldYRotation(store, mirrors, segments);
    return [performance.now() - store.startedAt, store.maxReflections, LR, LG, LB, BR, BG, BB, CURVE_MAX];
  },
};
