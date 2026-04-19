import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./hex-prism-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { createSecondaryDataBuffer } from "../paint.mjs";

let store = {
  startedAt: performance.now(),
  maxReflections: 4,
};

type Cell = { position: Number4; velocity: Number4; arm: Number4 };

let makeCell = (a: Number4, b: Number4, c: Number4): Cell => {
  return { position: a, velocity: b, arm: c };
};

let createMirrors = (): Cell[] => {
  const R = 100;
  const H = 200;
  const topPts: Number4[] = [];
  const botPts: Number4[] = [];
  for (let i = 0; i < 6; i++) {
    const angle = (i * Math.PI) / 3;
    topPts.push([R * Math.cos(angle), R * Math.sin(angle), H, 0]);
    botPts.push([R * Math.cos(angle), R * Math.sin(angle), -H, 0]);
  }

  let cells: Cell[] = [];
  // Side faces
  for (let i = 0; i < 6; i++) {
    let j = (i + 1) % 6;
    cells.push(makeCell(topPts[i], botPts[i], botPts[j]));
    cells.push(makeCell(topPts[i], botPts[j], topPts[j]));
  }

  // Caps (triangulated from center)
  const centerTop: Number4 = [0, 0, H, 0];
  const centerBot: Number4 = [0, 0, -H, 0];
  for (let i = 0; i < 6; i++) {
    let j = (i + 1) % 6;
    cells.push(makeCell(centerTop, topPts[j], topPts[i]));
    cells.push(makeCell(centerBot, botPts[i], botPts[j]));
  }

  return cells;
};

let createLightSegments = (): Cell[] => {
  const zero: Number4 = [0, 0, 0, 0];
  const R = 100;
  const H = 200;
  const ptsTop: Number4[] = [];
  const ptsBot: Number4[] = [];
  for (let i = 0; i < 6; i++) {
    const angle = (i * Math.PI) / 3;
    ptsTop.push([R * Math.cos(angle), R * Math.sin(angle), H, 0]);
    ptsBot.push([R * Math.cos(angle), R * Math.sin(angle), -H, 0]);
  }

  // Full-diameter diagonals: top[i] to opposite bottom[i+3], evenly spaced (every 2 vertices)
  return [makeCell(ptsTop[0], ptsBot[3], zero), makeCell(ptsTop[2], ptsBot[5], zero), makeCell(ptsTop[4], ptsBot[1], zero)];
};

export const hexPrismMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    const mirrors = createMirrors();
    const segments = createLightSegments();
    createGlobalPointsBuffer(mirrors.length, (idx) => mirrors[idx]);
    createSecondaryDataBuffer(segments.length, (idx) => segments[idx]);
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    return [performance.now() - store.startedAt, store.maxReflections];
  },
};
