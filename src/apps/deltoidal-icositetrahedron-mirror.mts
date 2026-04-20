import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./polyhedra-color-mirror.wgsl";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";
import { buildPolyhedronCells, V3 } from "./polyhedra-builder.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

// Deltoidal icositetrahedron: a Catalan solid with 24 congruent kite faces.
// It is the dual of the rhombicuboctahedron, so this version uses explicit dual vertices and faces.
const vertices: V3[] = [
  [0, 0, -190],
  [-134.350288425444, 0, -134.350288425444],
  [0, -134.350288425444, -134.350288425444],
  [-103.91445052882518, -103.91445052882518, -103.91445052882518],
  [0, 0, 190],
  [-134.350288425444, 0, 134.350288425444],
  [0, -134.350288425444, 134.350288425444],
  [-103.91445052882518, -103.91445052882518, 103.91445052882518],
  [0, 134.350288425444, -134.350288425444],
  [-103.91445052882518, 103.91445052882518, -103.91445052882518],
  [0, 134.350288425444, 134.350288425444],
  [-103.91445052882518, 103.91445052882518, 103.91445052882518],
  [134.350288425444, 0, -134.350288425444],
  [103.91445052882518, -103.91445052882518, -103.91445052882518],
  [134.350288425444, 0, 134.350288425444],
  [103.91445052882518, -103.91445052882518, 103.91445052882518],
  [103.91445052882518, 103.91445052882518, -103.91445052882518],
  [103.91445052882518, 103.91445052882518, 103.91445052882518],
  [0, -190, 0],
  [-134.350288425444, -134.350288425444, 0],
  [0, 190, 0],
  [-134.350288425444, 134.350288425444, 0],
  [134.350288425444, -134.350288425444, 0],
  [134.350288425444, 134.350288425444, 0],
  [-190, 0, 0],
  [190, 0, 0],
];

// Every face here is a kite; the index list is fixed instead of reconstructed on the fly.
const faces: number[][] = [
  [1, 0, 2, 3],
  [8, 0, 1, 9],
  [2, 0, 12, 13],
  [12, 0, 8, 16],
  [24, 1, 3, 19],
  [21, 9, 1, 24],
  [19, 3, 2, 18],
  [18, 2, 13, 22],
  [6, 4, 5, 7],
  [5, 4, 10, 11],
  [14, 4, 6, 15],
  [10, 4, 14, 17],
  [19, 7, 5, 24],
  [24, 5, 11, 21],
  [18, 6, 7, 19],
  [22, 15, 6, 18],
  [20, 8, 9, 21],
  [23, 16, 8, 20],
  [21, 11, 10, 20],
  [20, 10, 17, 23],
  [22, 13, 12, 25],
  [25, 12, 16, 23],
  [25, 14, 15, 22],
  [23, 17, 14, 25],
];

// Mirror rendering still works on triangles, so each kite face is split by buildPolyhedronCells().
const geometry = buildPolyhedronCells(vertices, faces);

let store = {
  startedAt: performance.now(),
  maxReflections: 6,
  angleY: 0,
  lastTickAt: performance.now(),
};

export const deltoidalIcositetrahedronMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(geometry.mirrors.length, (idx) => geometry.mirrors[idx]);
    createSecondaryDataBuffer(geometry.segments.length, (idx) => geometry.segments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    updateHeldYRotation(store, geometry.mirrors, geometry.segments);
    // Crimson/magenta tint: matches the Catalan solid's ornate, jewel-like kite faces.
    return [performance.now() - store.startedAt, store.maxReflections, 0.024, 0.004, 0.017, 0.018, 0.003, 0.012];
  },
};
