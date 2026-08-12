import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./tetra-octa.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";

// Regular tetrahedron + regular octahedron on independent orbits.
// Rays bounce between surfaces; near-edge rays glow white.

let store = { startedAt: performance.now() };

const ZERO: Number4 = [0, 0, 0, 0];

export const tetraOctaConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(1, () => ({ position: ZERO, velocity: ZERO, arm: ZERO }));
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => [performance.now() - store.startedAt, 0, 0],
};
