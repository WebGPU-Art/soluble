import { createGlobalPointsBuffer } from "../index.mjs";

import mirrors from "./rhombic-mirror.wgsl";
import { Number4, rand, randBalance, randBetween, range } from "../math.mjs";
import { type ButtonEvents } from "../control.mjs";
import { SolubleApp } from "../primes.mjs";
import { BaseCellParams, createSecondaryDataBuffer } from "../paint.mjs";
import { updateHeldYRotation } from "./polyhedra-rotation.mjs";

// This demo uses the rhombic dodecahedron: 12 rhombus faces and 14 vertices.
// It is one of the classic space-filling rhombic polyhedra and matches the old hand-built mirror style.
let store = {
  disableLens: 0, // or 1
  radius: 0.98,
  startedAt: performance.now(),
  angleY: 0,
  lastTickAt: performance.now(),
};

type Cell = {
  position: Number4;
  velocity: Number4;
  arm: Number4;
};

let makeCell = (a: Number4, b: Number4, c: Number4) => {
  return { position: a, velocity: b, arm: c } as Cell;
};

// The 6 axis points and 8 cube-corner points are enough to describe all 12 rhombic faces.
let u = 100;

// use z axis positive to decide front direction

let pTop: Number4 = [0, 2 * u, 0, 0];
let pBottom: Number4 = [0, -2 * u, 0, 0];
let pLeft: Number4 = [-2 * u, 0, 0, 0];
let pRight: Number4 = [2 * u, 0, 0, 0];
let pFront: Number4 = [0, 0, 2 * u, 0];
let pBack: Number4 = [0, 0, -2 * u, 0];
// top left back
let p1: Number4 = [-1 * u, 1 * u, 1 * u, 0];
// top right back
let p2: Number4 = [1 * u, 1 * u, 1 * u, 0];
let p3: Number4 = [1 * u, 1 * u, -1 * u, 0];
let p4: Number4 = [-1 * u, 1 * u, -1 * u, 0];
// bottom
let p5: Number4 = [-1 * u, -1 * u, 1 * u, 0];
let p6: Number4 = [1 * u, -1 * u, 1 * u, 0];
let p7: Number4 = [1 * u, -1 * u, -1 * u, 0];
let p8: Number4 = [-1 * u, -1 * u, -1 * u, 0];

// Each rhombus face is split into 2 mirror triangles.
let createRhombic = () => {
  return [
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
  ] as Cell[];
};

// Segments trace the visible edge skeleton of the rhombic dodecahedron.
let createSegments = () => {
  let d = u;
  /** as placeholder */
  let zero: Number4 = [0, 0, 0, 0];
  return [
    // makeCell(p0, p1, zero),
    // makeCell(p1, p2, zero),
    makeCell(pTop, p1, zero),
    makeCell(pTop, p2, zero),
    makeCell(pTop, p3, zero),
    makeCell(pTop, p4, zero),
    makeCell(pBottom, p5, zero),
    makeCell(pBottom, p6, zero),
    makeCell(pBottom, p7, zero),
    makeCell(pBottom, p8, zero),
    makeCell(pLeft, p1, zero),
    makeCell(pLeft, p4, zero),
    makeCell(pLeft, p8, zero),
    makeCell(pLeft, p5, zero),
    makeCell(pRight, p2, zero),
    makeCell(pRight, p3, zero),
    makeCell(pRight, p7, zero),
    makeCell(pRight, p6, zero),
    makeCell(pFront, p1, zero),
    makeCell(pFront, p2, zero),
    makeCell(pFront, p6, zero),
    makeCell(pFront, p5, zero),
    makeCell(pBack, p4, zero),
    makeCell(pBack, p3, zero),
    makeCell(pBack, p7, zero),
    makeCell(pBack, p8, zero),
  ] as Cell[];
};

const baseMirrors = createRhombic();
const baseSegments = createSegments();

export const rhombicMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(baseMirrors.length, (idx) => baseMirrors[idx]);
    createSecondaryDataBuffer(baseSegments.length, (idx) => baseSegments[idx]);
  },
  useCompute: false,
  renderShader: mirrors,
  // onButtonEvent: (events: ButtonEvents) => { },
  getParams: () => {
    updateHeldYRotation(store, baseMirrors, baseSegments);
    return [performance.now() - store.startedAt];
  },
  // getTextures: (obj) => {
  //   return [obj["bubbles"]].filter(Boolean);
  // },
};
