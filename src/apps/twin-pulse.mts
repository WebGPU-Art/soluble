import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./twin-pulse.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";

// Axis-aligned cube + sphere at origin, alternating size via sin/cos.
// Rays bounce between surfaces; near-edge rays turn white.

let store = { startedAt: performance.now() };

const ZERO: Number4 = [0, 0, 0, 0];

export const twinPulseConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(1, () => ({ position: ZERO, velocity: ZERO, arm: ZERO }));
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => [performance.now() - store.startedAt, 0, 0],
};
