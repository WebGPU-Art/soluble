import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./rt-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { BaseCellParams, createSecondaryDataBuffer } from "../paint.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

// Rhombic triacontahedron (RT) — 30 rhombic faces split into 60 triangular mirrors.
// Icosahedral (5-fold) symmetry; dual of the icosidodecahedron.
//
// Two vertex types:
//   ICO  (12, outer radius R_ico): corners of an icosahedron
//   DOD  (20, inner radius R_dod = R_ico/φ): face-centroids of that icosahedron,
//        normalized and re-scaled — these become dodecahedron vertices of the RT.
//
// Each RT rhombus = (ico_a, dod_i, ico_b, dod_j) where the edge (a,b) is shared
// by icosahedron faces i and j.  Split into 2 triangles along the short diagonal
// (dod_i → dod_j): (ico_a, dod_i, dod_j) + (ico_b, dod_i, dod_j).

const phi = (1 + Math.sqrt(5)) / 2; // ≈ 1.6180

const R_ico = 200; // outer vertices radius
const R_dod = R_ico / phi; // inner vertices radius ≈ 123.6
const icoNorm = Math.sqrt(1 + phi * phi); // normalisation factor ≈ 1.902

type V3 = [number, number, number];
type N4 = [number, number, number, number];

function v4(v: V3): N4 {
  return [v[0], v[1], v[2], 0];
}

// 12 icosahedron vertices (outer, at R_ico)
const icoRaw: V3[] = [
  [0, 1, phi], // 0
  [0, -1, phi], // 1
  [0, 1, -phi], // 2
  [0, -1, -phi], // 3
  [1, phi, 0], // 4
  [-1, phi, 0], // 5
  [1, -phi, 0], // 6
  [-1, -phi, 0], // 7
  [phi, 0, 1], // 8
  [-phi, 0, 1], // 9
  [phi, 0, -1], // 10
  [-phi, 0, -1], // 11
];
const ico: V3[] = icoRaw.map((v) => v.map((x) => (x / icoNorm) * R_ico) as V3);

// 20 icosahedron faces (top cap, bottom cap, equatorial)
// — these become the 20 DOD vertices when centroids are normalised to R_dod
const icoFaces: [number, number, number][] = [
  [0, 1, 8], // 0  top cap
  [0, 8, 4], // 1
  [0, 4, 5], // 2
  [0, 5, 9], // 3
  [0, 9, 1], // 4
  [3, 2, 10], // 5  bottom cap
  [3, 10, 6], // 6
  [3, 6, 7], // 7
  [3, 7, 11], // 8
  [3, 11, 2], // 9
  [1, 6, 8], // 10 equatorial
  [1, 6, 7], // 11
  [1, 7, 9], // 12
  [2, 4, 5], // 13
  [2, 4, 10], // 14
  [2, 5, 11], // 15
  [4, 8, 10], // 16
  [5, 9, 11], // 17
  [6, 8, 10], // 18
  [7, 9, 11], // 19
];

// 20 DOD vertices: normalised face centroids at R_dod
const dod: V3[] = icoFaces.map(([a, b, c]) => {
  const va = ico[a],
    vb = ico[b],
    vc = ico[c];
  const cx = (va[0] + vb[0] + vc[0]) / 3;
  const cy = (va[1] + vb[1] + vc[1]) / 3;
  const cz = (va[2] + vb[2] + vc[2]) / 3;
  const r = Math.sqrt(cx * cx + cy * cy + cz * cz);
  return [(cx / r) * R_dod, (cy / r) * R_dod, (cz / r) * R_dod];
});

// 30 icosahedron edges: [ico_a, ico_b, face_i, face_j]
// face_i/face_j are the indices into icoFaces (= dod vertex indices) of the
// two triangular faces sharing edge (a,b).
const rtEdges: [number, number, number, number][] = [
  // top cap edges
  [0, 1, 0, 4],
  [0, 4, 1, 2],
  [0, 5, 2, 3],
  [0, 8, 0, 1],
  [0, 9, 3, 4],
  // bottom cap edges
  [2, 3, 5, 9],
  [3, 6, 6, 7],
  [3, 7, 7, 8],
  [3, 10, 5, 6],
  [3, 11, 8, 9],
  // cross edges (upper ↔ lower ring)
  [1, 6, 10, 11],
  [1, 7, 11, 12],
  [1, 8, 0, 10],
  [1, 9, 4, 12],
  [2, 4, 13, 14],
  [2, 5, 13, 15],
  [2, 10, 5, 14],
  [2, 11, 9, 15],
  [4, 5, 2, 13],
  [4, 8, 1, 16],
  [4, 10, 14, 16],
  [5, 9, 3, 17],
  [5, 11, 15, 17],
  [6, 7, 7, 11],
  [6, 8, 10, 18],
  [6, 10, 6, 18],
  [7, 9, 12, 19],
  [7, 11, 8, 19],
  [8, 10, 16, 18],
  [9, 11, 17, 19],
];

type Cell = { position: N4; velocity: N4; arm: N4 };
const makeCell = (a: N4, b: N4, c: N4): Cell => ({ position: a, velocity: b, arm: c });

// 60 mirror triangles: split each RT rhombus along its short diagonal (dod_i → dod_j)
const createMirrors = (): Cell[] => {
  const cells: Cell[] = [];
  for (const [ia, ib, fi, fj] of rtEdges) {
    const a = v4(ico[ia]);
    const b = v4(ico[ib]);
    const d1 = v4(dod[fi]);
    const d2 = v4(dod[fj]);
    cells.push(makeCell(a, d1, d2));
    cells.push(makeCell(b, d1, d2));
  }
  return cells;
};

// 30 icosahedron edge segments — one segment per RT rhombus long diagonal.
// Restores the full wireframe density of the original pattern.
const createSegments = (): Cell[] => {
  const zero: N4 = [0, 0, 0, 0];
  return rtEdges.map(([ia, ib]) => makeCell(v4(ico[ia]), v4(ico[ib]), zero));
};

let store = {
  startedAt: performance.now(),
  maxReflections: 6,
  angleY: 0,
  lastTickAt: performance.now(),
};

const baseMirrors = createMirrors();
const baseSegments = createSegments();

export const rtMirrorConfigs: SolubleApp = {
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
