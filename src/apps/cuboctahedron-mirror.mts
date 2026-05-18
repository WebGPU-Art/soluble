import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./polyhedra-color-mirror.wgsl";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";
import { buildPolyhedronCells, V3 } from "./polyhedra-builder.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

// Cuboctahedron (rectified cube / rectified octahedron): 14 faces (8 equilateral triangles +
// 6 squares), 12 vertices, 24 edges.  All vertices lie on a sphere of radius R.
// Vertex set: all permutations of (0, ±s, ±s) with s = R/√2.
// buildPolyhedronCells fan-triangulates each face from its centre, giving
//   8 × 3 + 6 × 4 = 48 mirror triangles and 24 edge-segments.

const R = 100;
const s = R / Math.sqrt(2);

const vertices: V3[] = [
  [0, s, s],
  [0, s, -s],
  [0, -s, s],
  [0, -s, -s],
  [s, 0, s],
  [s, 0, -s],
  [-s, 0, s],
  [-s, 0, -s],
  [s, s, 0],
  [s, -s, 0],
  [-s, s, 0],
  [-s, -s, 0],
];

const geometry = buildPolyhedronCells(vertices);

let store = {
  startedAt: performance.now(),
  maxReflections: 5,
  angleY: 0,
  lastTickAt: performance.now(),
};

export const cuboctahedronMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(geometry.mirrors.length, (idx) => geometry.mirrors[idx]);
    createSecondaryDataBuffer(geometry.segments.length, (idx) => geometry.segments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    updateHeldYRotation(store, geometry.mirrors, geometry.segments);
    // Warm amber/golden glow — reflects the cuboctahedron's dual cube+octahedron heritage.
    return [performance.now() - store.startedAt, store.maxReflections, 0.022, 0.016, 0.005, 0.016, 0.011, 0.003];
  },
};
