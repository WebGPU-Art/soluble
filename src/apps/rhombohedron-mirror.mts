import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./polyhedra-color-mirror.wgsl";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";
import { buildPolyhedronCells, Cell, createZonotopeVertices, scaleVerticesToRadius, V3 } from "./polyhedra-builder.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

// A rhombohedron is a skewed cube-like parallelohedron with 6 congruent rhombus faces.
// Here it is built from 3 equal-length generators, then triangulated into mirror cells.
const theta = (72 * Math.PI) / 180;
const c = Math.cos(theta);
const s = Math.sin(theta);
const e3y = (c - c * c) / s;
const e3z = Math.sqrt(1 - c * c - e3y * e3y);

// These 3 generators define one oblique rhombohedral cell.
const baseVectors: V3[] = [
  [1, 0, 0],
  [c, s, 0],
  [c, e3y, e3z],
];

const vertices = scaleVerticesToRadius(createZonotopeVertices(baseVectors), 190);
const geometry = buildPolyhedronCells(vertices);

const dist2 = (a: V3, b: V3): number => {
  const dx = a[0] - b[0];
  const dy = a[1] - b[1];
  const dz = a[2] - b[2];
  return dx * dx + dy * dy + dz * dz;
};

const toSegmentCell = (a: V3, b: V3): Cell => {
  return {
    position: [a[0], a[1], a[2], 0],
    velocity: [b[0], b[1], b[2], 0],
    arm: [0, 0, 0, 0],
  };
};

// Add the 4 opposite-vertex body diagonals so the inner rhombohedral structure is visible.
const createLongDiagonalSegments = (points: V3[]): Cell[] => {
  const pairs = new Set<string>();

  for (let i = 0; i < points.length; i++) {
    let best = -1;
    let bestDist = -1;

    for (let j = 0; j < points.length; j++) {
      if (i === j) {
        continue;
      }
      const d2 = dist2(points[i], points[j]);
      if (d2 > bestDist) {
        bestDist = d2;
        best = j;
      }
    }

    if (best >= 0) {
      const key = [i, best].sort((a, b) => a - b).join(":");
      pairs.add(key);
    }
  }

  return [...pairs].map((key) => {
    const [ia, ib] = key.split(":").map(Number);
    return toSegmentCell(points[ia], points[ib]);
  });
};

const baseSegments = geometry.segments.concat(createLongDiagonalSegments(vertices));

let store = {
  startedAt: performance.now(),
  maxReflections: 5,
  angleY: 0,
  lastTickAt: performance.now(),
};

export const rhombohedronMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(geometry.mirrors.length, (idx) => geometry.mirrors[idx]);
    createSecondaryDataBuffer(baseSegments.length, (idx) => baseSegments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    updateHeldYRotation(store, geometry.mirrors, baseSegments);
    // Warm amber tint: emphasises the rhombohedron's angular, gem-like character.
    return [performance.now() - store.startedAt, store.maxReflections, 0.022, 0.013, 0.002, 0.016, 0.009, 0.001];
  },
};
