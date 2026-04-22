import { createGlobalPointsBuffer } from "../index.mjs";
import { updateSecondaryDataBuffer } from "../paint.mjs";
import shader from "./polyhedra-color-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

// Rhombic dodecahedron mirrors (same geometry as the diagonals demo).
type Cell = { position: Number4; velocity: Number4; arm: Number4 };
const makeCell = (a: Number4, b: Number4, c: Number4): Cell => ({ position: a, velocity: b, arm: c });
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

// ── Rotating segments ──────────────────────────────────────────────────────────
// 3 long segments, each anchored at a slightly off-center interior point.
// Each segment has its own rotation axis so they trace independent paths.

type SegmentDef = {
  /** point on the rotation axis that the segment passes through */
  pivot: [number, number, number];
  /** unit rotation axis */
  axis: [number, number, number];
  /** half-vector from pivot to one endpoint (the other is the opposite direction) */
  arm: [number, number, number];
  /** angular speed in radians per millisecond */
  speed: number;
  /** per-segment phase offset so they start staggered */
  phase: number;
};

// Segment 1: pivots near the top, rotates around the x axis.  Warm rose glow.
// Segment 2: pivots near the center-right, rotates around a tilted axis.  Cyan glow.
// Segment 3: pivots slightly below center-front, rotates around a Z-tilted axis.  Lime glow.
const SEG_DEFS: SegmentDef[] = [
  {
    pivot: [18, 55, -12],
    axis: [1, 0, 0],
    arm: [0, 155, 20],
    speed: 0.00028,
    phase: 0,
  },
  {
    pivot: [-22, -10, 28],
    axis: [0.57, 0.74, -0.36],
    arm: [130, -60, 30],
    speed: 0.00021,
    phase: Math.PI * 0.6,
  },
  {
    pivot: [12, -38, 15],
    axis: [-0.41, 0.31, 0.86],
    arm: [-40, 120, -110],
    speed: 0.00016,
    phase: Math.PI * 1.3,
  },
];

/** Rotate vector v around unit axis by angle (Rodrigues' rotation). */
const rotateAroundAxis = (v: [number, number, number], axis: [number, number, number], angle: number): [number, number, number] => {
  const c = Math.cos(angle);
  const s = Math.sin(angle);
  const [ax, ay, az] = axis;
  const [vx, vy, vz] = v;
  // dot(axis, v)
  const d = ax * vx + ay * vy + az * vz;
  // cross(axis, v)
  const cx = ay * vz - az * vy;
  const cy = az * vx - ax * vz;
  const cz = ax * vy - ay * vx;
  return [vx * c + cx * s + ax * d * (1 - c), vy * c + cy * s + ay * d * (1 - c), vz * c + cz * s + az * d * (1 - c)];
};

/** Build the current Cell for a segment definition at time t (ms). */
const evalSegment = (def: SegmentDef, t: number): Cell => {
  const angle = t * def.speed + def.phase;
  const rotatedArm = rotateAroundAxis(def.arm, def.axis, angle);
  const [px, py, pz] = def.pivot;
  const [rx, ry, rz] = rotatedArm;
  const start: Number4 = [px + rx, py + ry, pz + rz, 0];
  const end: Number4 = [px - rx, py - ry, pz - rz, 0];
  return makeSegment(start, end);
};

// Color per-segment: rose, cyan, lime — encoded as [lr,lg,lb, br,bg,bb]
// We pick a single averaged color for the uniform (all 3 segments share the same shader call).
// Using a warm violet base light with a soft-green secondary bounce creates a nice multi-hue blend.
const LR = 0.018;
const LG = 0.009;
const LB = 0.022;
const BR = 0.008;
const BG = 0.014;
const BB = 0.016;

let store = {
  startedAt: performance.now(),
  maxReflections: 5,
  angleY: 0,
  lastTickAt: performance.now(),
};

export const rhombicDodecahedronRotatingMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(mirrors.length, (idx) => mirrors[idx]);
    const t0 = performance.now() - store.startedAt;
    updateSecondaryDataBuffer(SEG_DEFS.length, (idx) => evalSegment(SEG_DEFS[idx], t0));
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    const t = performance.now() - store.startedAt;
    // Update each segment's position every frame.
    updateSecondaryDataBuffer(SEG_DEFS.length, (idx) => evalSegment(SEG_DEFS[idx], t));
    updateHeldYRotation(store, mirrors, []);
    return [t, store.maxReflections, LR, LG, LB, BR, BG, BB];
  },
};
