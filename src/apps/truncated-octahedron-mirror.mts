import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./polyhedra-color-mirror.wgsl";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";
import { buildPolyhedronCells, V3 } from "./polyhedra-builder.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

// Truncated octahedron: an Archimedean solid with 8 hexagons and 6 squares.
// It is also one of Fedorov's 5 parallelohedra, so translated copies tile 3D space.
const vertices: V3[] = [
  [0, -80.49844718999242, -160.99689437998484],
  [0, -80.49844718999242, 160.99689437998484],
  [0, 80.49844718999242, -160.99689437998484],
  [0, 80.49844718999242, 160.99689437998484],
  [0, -160.99689437998484, -80.49844718999242],
  [0, -160.99689437998484, 80.49844718999242],
  [0, 160.99689437998484, -80.49844718999242],
  [0, 160.99689437998484, 80.49844718999242],
  [-80.49844718999242, 0, -160.99689437998484],
  [-80.49844718999242, 0, 160.99689437998484],
  [80.49844718999242, 0, -160.99689437998484],
  [80.49844718999242, 0, 160.99689437998484],
  [-80.49844718999242, -160.99689437998484, 0],
  [-80.49844718999242, 160.99689437998484, 0],
  [80.49844718999242, -160.99689437998484, 0],
  [80.49844718999242, 160.99689437998484, 0],
  [-160.99689437998484, 0, -80.49844718999242],
  [-160.99689437998484, 0, 80.49844718999242],
  [160.99689437998484, 0, -80.49844718999242],
  [160.99689437998484, 0, 80.49844718999242],
  [-160.99689437998484, -80.49844718999242, 0],
  [-160.99689437998484, 80.49844718999242, 0],
  [160.99689437998484, -80.49844718999242, 0],
  [160.99689437998484, 80.49844718999242, 0],
];

// Face order is explicit here to keep buffer generation stable at runtime.
const faces: number[][] = [
  [10, 0, 8, 2],
  [16, 8, 0, 4, 12, 20],
  [14, 4, 0, 10, 18, 22],
  [3, 9, 1, 11],
  [12, 5, 1, 9, 17, 20],
  [19, 11, 1, 5, 14, 22],
  [13, 6, 2, 8, 16, 21],
  [18, 10, 2, 6, 15, 23],
  [17, 9, 3, 7, 13, 21],
  [15, 7, 3, 11, 19, 23],
  [12, 4, 14, 5],
  [15, 6, 13, 7],
  [21, 16, 20, 17],
  [19, 22, 18, 23],
];

// Each polygon face is fan-triangulated into mirror cells; unique polygon edges become light segments.
const geometry = buildPolyhedronCells(vertices, faces);

let store = {
  startedAt: performance.now(),
  maxReflections: 6,
  angleY: 0,
  lastTickAt: performance.now(),
};

export const truncatedOctahedronMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(geometry.mirrors.length, (idx) => geometry.mirrors[idx]);
    createSecondaryDataBuffer(geometry.segments.length, (idx) => geometry.segments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    updateHeldYRotation(store, geometry.mirrors, geometry.segments);
    // Emerald green tint: suits the truncated octahedron's organic hexagonal symmetry.
    return [performance.now() - store.startedAt, store.maxReflections, 0.004, 0.022, 0.013, 0.003, 0.016, 0.009];
  },
};
