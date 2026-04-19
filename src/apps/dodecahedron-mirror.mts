import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./dodecahedron-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

// Regular dodecahedron — 12 pentagonal faces, 20 vertices, 30 edges.
// Each pentagon is split into 5 triangles from its face centre → 60 mirror triangles.
// Light segments follow the 30 dodecahedron edges.
//
// Vertex coordinates use the standard form with φ = (1+√5)/2:
//   (±1, ±1, ±1)         — 8 cube vertices
//   (0, ±1/φ, ±φ)        — and 4 permutations of this cyclic set (12 more)
// Total 20 vertices; scale to radius R.

const phi = (1 + Math.sqrt(5)) / 2;
const R = 180; // outer sphere radius

type N4 = [number, number, number, number];
type V3 = [number, number, number];

function scale(v: V3, r: number): N4 {
  const len = Math.sqrt(v[0] ** 2 + v[1] ** 2 + v[2] ** 2);
  return [(v[0] / len) * r, (v[1] / len) * r, (v[2] / len) * r, 0];
}

// 20 dodecahedron vertices normalised to radius R
const raw: V3[] = [
  // cube corners
  [1, 1, 1],
  [1, 1, -1],
  [1, -1, 1],
  [1, -1, -1],
  [-1, 1, 1],
  [-1, 1, -1],
  [-1, -1, 1],
  [-1, -1, -1],
  // (0, ±1/φ, ±φ)  and cyclic permutations
  [0, 1 / phi, phi],
  [0, 1 / phi, -phi],
  [0, -1 / phi, phi],
  [0, -1 / phi, -phi],
  [1 / phi, phi, 0],
  [1 / phi, -phi, 0],
  [-1 / phi, phi, 0],
  [-1 / phi, -phi, 0],
  [phi, 0, 1 / phi],
  [phi, 0, -1 / phi],
  [-phi, 0, 1 / phi],
  [-phi, 0, -1 / phi],
];
const V: N4[] = raw.map((v) => scale(v, R));

function dist(a: N4, b: N4) {
  return Math.sqrt((a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2 + (a[2] - b[2]) ** 2);
}

const edgeLen = dist(V[0], V[8]); // edge between cube vertex and adjacent phi vertex
const EPS = edgeLen * 0.05;

function adjacent(i: number, j: number) {
  return Math.abs(dist(V[i], V[j]) - edgeLen) < EPS;
}

// Build adjacency list
const adj: number[][] = Array.from({ length: 20 }, () => []);
for (let i = 0; i < 20; i++) {
  for (let j = i + 1; j < 20; j++) {
    if (adjacent(i, j)) {
      adj[i].push(j);
      adj[j].push(i);
    }
  }
}

// Build the 30 edges
const edges: [number, number][] = [];
for (let i = 0; i < 20; i++) {
  for (const j of adj[i]) {
    if (j > i) edges.push([i, j]);
  }
}

// Reconstruct 12 pentagonal faces by walking directed edges.
// Dodecahedron has girth 5: no two adjacent vertices share a common neighbour,
// so the "next" vertex is simply the first neighbour of cur that is neither
// prev nor already in the face.  Both choices produce valid 5-cycles; dedup
// ensures we collect exactly 12 unique faces from all 60 directed edges.
const faceList: number[][] = [];
const faceSet = new Set<string>();

function faceKey(f: number[]) {
  return [...f].sort((a, b) => a - b).join(",");
}

for (let i = 0; i < 20; i++) {
  for (const j of adj[i]) {
    const face: number[] = [i, j];
    let prev = i,
      cur = j;
    let valid = true;
    for (let step = 0; step < 3; step++) {
      const next = adj[cur].find((x) => x !== prev && !face.includes(x));
      if (next === undefined) {
        valid = false;
        break;
      }
      face.push(next);
      prev = cur;
      cur = next;
    }
    if (valid && face.length === 5) {
      const k = faceKey(face);
      if (!faceSet.has(k)) {
        faceSet.add(k);
        faceList.push(face);
      }
    }
  }
}

// face centroid (NOT normalised — for mirror placement)
function centroid(f: number[]): N4 {
  const cx = f.reduce((s, i) => s + V[i][0], 0) / f.length;
  const cy = f.reduce((s, i) => s + V[i][1], 0) / f.length;
  const cz = f.reduce((s, i) => s + V[i][2], 0) / f.length;
  return [cx, cy, cz, 0];
}

type Cell = { position: N4; velocity: N4; arm: N4 };
const makeCell = (a: N4, b: N4, c: N4): Cell => ({ position: a, velocity: b, arm: c });

// 60 mirror triangles: each pentagon → 5 triangles from centroid
const createMirrors = (): Cell[] => {
  const cells: Cell[] = [];
  for (const face of faceList) {
    const cen = centroid(face);
    for (let k = 0; k < 5; k++) {
      const a = V[face[k]];
      const b = V[face[(k + 1) % 5]];
      cells.push(makeCell(cen, a, b));
    }
  }
  return cells;
};

// 30 dodecahedron edge segments — one per edge, restoring full wireframe pattern.
const createSegments = (): Cell[] => {
  const zero: N4 = [0, 0, 0, 0];
  return edges.map(([i, j]) => makeCell(V[i], V[j], zero));
};

let store = {
  startedAt: performance.now(),
  maxReflections: 6,
  angleY: 0,
  lastTickAt: performance.now(),
};

const baseMirrors = createMirrors();
const baseSegments = createSegments();

export const dodecahedronMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(baseMirrors.length, (i) => baseMirrors[i]);
    createSecondaryDataBuffer(baseSegments.length, (i) => baseSegments[i]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    updateHeldYRotation(store, baseMirrors, baseSegments);
    return [performance.now() - store.startedAt, store.maxReflections];
  },
};
