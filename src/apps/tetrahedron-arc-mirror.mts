import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./arc-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

// Regular tetrahedron — circular-arc demo.
//
// Unlike the parabola demo (which samples 96 points per mirror per bounce),
// arc-mirror.wgsl uses the closed-form solution of  A·cos θ + B·sin θ = C
// to find the arc-plane intersection in O(1) per mirror: just atan2 + acos.
//
// Arc radius: with edge ≈ 283 units and a half-edge traversal (≈140 units),
// arc-length θ ≈ 140/600 ≈ 0.23 rad  →  perpendicular deflection
// ≈ 600 * (1 − cos 0.23) ≈ 16 units — clearly visible but not chaotic.
// The sin oscillation alternates bend direction so the paths curve both ways.

const ARC_RADIUS = 600;

let store = {
  startedAt: performance.now(),
  maxReflections: 6,
  angleY: 0,
  lastTickAt: performance.now(),
};

type Cell = { position: Number4; velocity: Number4; arm: Number4 };
const makeCell = (a: Number4, b: Number4, c: Number4): Cell => ({ position: a, velocity: b, arm: c });

const u = 100;
const baseMirrors: Cell[] = [
  makeCell([u, u, u, 0], [u, -u, -u, 0], [-u, u, -u, 0]),
  makeCell([u, u, u, 0], [-u, -u, u, 0], [u, -u, -u, 0]),
  makeCell([u, u, u, 0], [-u, u, -u, 0], [-u, -u, u, 0]),
  makeCell([-u, u, -u, 0], [u, -u, -u, 0], [-u, -u, u, 0]),
];

const baseSegments: Cell[] = (() => {
  const zero: Number4 = [0, 0, 0, 0];
  const a: Number4 = [u, u, u, 0];
  const b: Number4 = [u, -u, -u, 0];
  const c: Number4 = [-u, u, -u, 0];
  const d: Number4 = [-u, -u, u, 0];
  return [makeCell(a, b, zero), makeCell(a, c, zero), makeCell(a, d, zero), makeCell(b, c, zero), makeCell(b, d, zero), makeCell(c, d, zero)];
})();

export const tetrahedronArcMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(baseMirrors.length, (idx) => baseMirrors[idx]);
    createSecondaryDataBuffer(baseSegments.length, (idx) => baseSegments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    updateHeldYRotation(store, baseMirrors, baseSegments);
    // [lifetime, maxReflections, LR, LG, LB, BR, BG, BB, arc_radius, gx, gy, gz]
    // Teal/cyan palette — distinct from the amber tetrahedron-parabola demo.
    return [
      (performance.now() - store.startedAt) / 128,
      store.maxReflections,
      0.01,
      0.024,
      0.028, // LR, LG, LB — teal light
      0.006,
      0.016,
      0.02, // BR, BG, BB — bounce tint
      ARC_RADIUS,
      0,
      -1,
      0, // gravity downward
    ];
  },
};
