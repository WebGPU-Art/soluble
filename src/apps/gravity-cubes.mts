import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./gravity-cubes.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";

// 4 rotating cubes (OBBs) on elliptical orbits.
// After first cube hit, reflected ray bends under gravity (semi-implicit Euler).

let store = { startedAt: performance.now() };

const ZERO: Number4 = [0, 0, 0, 0];

export const gravityCubesConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(1, () => ({ position: ZERO, velocity: ZERO, arm: ZERO }));
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => [performance.now() - store.startedAt, 0, 0],
};
