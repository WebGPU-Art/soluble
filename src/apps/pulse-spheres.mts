import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./pulse-spheres.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";

// 4 spheres on slow elliptical orbits.
// Gravity coefficient pulses as sin(time) × 2.0 — allows repulsion when negative.

let store = { startedAt: performance.now() };

const ZERO: Number4 = [0, 0, 0, 0];

export const pulseSpheresConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(1, () => ({ position: ZERO, velocity: ZERO, arm: ZERO }));
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => [performance.now() - store.startedAt, 0, 0],
};
