import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./gravity-spheres.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";

// 3 spheres on elliptical orbits.
// After the first straight-ray hit, the reflected ray is bent by the gravity
// of all spheres (semi-implicit Euler, 200 steps).
// A minimal 1-cell points buffer is created to satisfy @group(1) @binding(0).

let store = {
  startedAt: performance.now(),
};

const ZERO: Number4 = [0, 0, 0, 0];

export const gravitySpheresMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(1, () => ({ position: ZERO, velocity: ZERO, arm: ZERO }));
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => [performance.now() - store.startedAt, 0, 0],
};
