import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./rhombic-dodecahedron-parabola-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

// Cube with vertices at (±u, ±u, ±u). Each of the 6 faces is split into 2
// triangles, giving 12 mirror triangles total. Segments are the 12 edges.

type Cell = { position: Number4; velocity: Number4; arm: Number4 };
const makeCell = (a: Number4, b: Number4, c: Number4): Cell => ({ position: a, velocity: b, arm: c });
const makeSegment = (a: Number4, b: Number4): Cell => makeCell(a, b, [0, 0, 0, 0]);

const u = 100;
const p000: Number4 = [-u, -u, -u, 0];
const p001: Number4 = [-u, -u, u, 0];
const p010: Number4 = [-u, u, -u, 0];
const p011: Number4 = [-u, u, u, 0];
const p100: Number4 = [u, -u, -u, 0];
const p101: Number4 = [u, -u, u, 0];
const p110: Number4 = [u, u, -u, 0];
const p111: Number4 = [u, u, u, 0];

// 6 faces × 2 triangles = 12 mirrors
const mirrors: Cell[] = [
  // -x face
  makeCell(p000, p001, p011),
  makeCell(p000, p011, p010),
  // +x face
  makeCell(p100, p110, p111),
  makeCell(p100, p111, p101),
  // -y face
  makeCell(p000, p100, p101),
  makeCell(p000, p101, p001),
  // +y face
  makeCell(p010, p011, p111),
  makeCell(p010, p111, p110),
  // -z face
  makeCell(p000, p010, p110),
  makeCell(p000, p110, p100),
  // +z face
  makeCell(p001, p101, p111),
  makeCell(p001, p111, p011),
];

// 12 edges of the cube
const segments: Cell[] = [
  // bottom ring (y = -u)
  makeSegment(p000, p100),
  makeSegment(p100, p101),
  makeSegment(p101, p001),
  makeSegment(p001, p000),
  // top ring (y = +u)
  makeSegment(p010, p110),
  makeSegment(p110, p111),
  makeSegment(p111, p011),
  makeSegment(p011, p010),
  // verticals
  makeSegment(p000, p010),
  makeSegment(p100, p110),
  makeSegment(p101, p111),
  makeSegment(p001, p011),
];

let store = {
  startedAt: performance.now(),
  maxReflections: 6,
  angleY: 0,
  lastTickAt: performance.now(),
};

// Cool teal/cyan palette
const LR = 0.006;
const LG = 0.02;
const LB = 0.028;
const BR = 0.004;
const BG = 0.014;
const BB = 0.02;

// Same amplitude as tetrahedron; cube edge = 2u = 200, interior paths similar length.
const CURVE_MAX = 0.0256;

export const cubeParabolaMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(mirrors.length, (idx) => mirrors[idx]);
    createSecondaryDataBuffer(segments.length, (idx) => segments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    updateHeldYRotation(store, mirrors, segments);
    // Gravity along the body diagonal normalize(1,1,1) ≈ 0.5774
    const D = 0.5773502692;
    return [(performance.now() - store.startedAt) / 128, store.maxReflections, LR, LG, LB, BR, BG, BB, CURVE_MAX, D, D, D];
  },
};
