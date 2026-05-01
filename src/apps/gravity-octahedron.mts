import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./gravity-octahedron.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";

// 3 rotating octahedra on elliptical orbits.
// After first octahedron hit, reflected ray bends under gravity (semi-implicit Euler).

let store = { startedAt: performance.now() };

const ZERO: Number4 = [0, 0, 0, 0];

export const gravityOctahedraConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(1, () => ({ position: ZERO, velocity: ZERO, arm: ZERO }));
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => [performance.now() - store.startedAt, 0, 0],
};
