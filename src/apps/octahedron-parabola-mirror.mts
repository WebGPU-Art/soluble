import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./rhombic-dodecahedron-parabola-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

// Regular octahedron: 8 triangular faces, 6 vertices at (±R, 0, 0), (0, ±R, 0), (0, 0, ±R).
// Segments: 12 edges of the octahedron (each axis vertex connects to 4 equatorial vertices).

type Cell = { position: Number4; velocity: Number4; arm: Number4 };
const makeCell = (a: Number4, b: Number4, c: Number4): Cell => ({ position: a, velocity: b, arm: c });
const makeSegment = (a: Number4, b: Number4): Cell => makeCell(a, b, [0, 0, 0, 0]);

const R = 120;
const px: Number4 = [R, 0, 0, 0];
const nx: Number4 = [-R, 0, 0, 0];
const py: Number4 = [0, R, 0, 0];
const ny: Number4 = [0, -R, 0, 0];
const pz: Number4 = [0, 0, R, 0];
const nz: Number4 = [0, 0, -R, 0];

// 8 faces — vertex order chosen so cross(b-a, c-a) points outward from origin.
const mirrors: Cell[] = [
  makeCell(px, py, pz),  // +++ outward (+,+,+) ✓
  makeCell(nx, pz, py),  // -++ outward (-,+,+) — swapped py/pz to fix winding
  makeCell(px, pz, ny),  // +-+ outward (+,-,+) — swapped ny/pz to fix winding
  makeCell(nx, ny, pz),  // --+ outward (-,-,+) ✓
  makeCell(px, nz, py),  // ++- outward (+,+,-) — swapped py/nz to fix winding
  makeCell(nx, py, nz),  // -+- outward (-,+,-) ✓
  makeCell(px, ny, nz),  // +-- outward (+,-,-) ✓
  makeCell(nx, nz, ny),  // --- outward (-,-,-) — swapped ny/nz to fix winding
];

// 12 edges: each of the 6 vertices connects to the 4 vertices not on the same axis
const segments: Cell[] = [
  makeSegment(px, py),
  makeSegment(px, ny),
  makeSegment(px, pz),
  makeSegment(px, nz),
  makeSegment(nx, py),
  makeSegment(nx, ny),
  makeSegment(nx, pz),
  makeSegment(nx, nz),
  makeSegment(py, pz),
  makeSegment(py, nz),
  makeSegment(ny, pz),
  makeSegment(ny, nz),
];

let store = {
  startedAt: performance.now(),
  maxReflections: 6,
  angleY: 0,
  lastTickAt: performance.now(),
};

// Rose/magenta palette — distinct from the other demos
const LR = 0.028;
const LG = 0.008;
const LB = 0.02;
const BR = 0.02;
const BG = 0.005;
const BB = 0.014;

// Octahedron edge = R√2 ≈ 170 units; interior path ≈ half edge ≈ 85 units.
// Peak drop = 0.5 * CURVE_MAX * 85² ≈ 16 units — clearly visible.
const CURVE_MAX = 0.0045;

export const octahedronParabolaMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(mirrors.length, (idx) => mirrors[idx]);
    createSecondaryDataBuffer(segments.length, (idx) => segments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    updateHeldYRotation(store, mirrors, segments);
    return [(performance.now() - store.startedAt) / 128, store.maxReflections, LR, LG, LB, BR, BG, BB, CURVE_MAX, 0, -1, 0];
  },
};
