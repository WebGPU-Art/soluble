import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./orbit-spheres-mirror.wgsl";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";

// 4 spheres on different elliptical orbits, computed entirely in WGSL.
// CPU side only needs to pass time; no secondary buffer required.
// We still create a minimal (1-element) points buffer because the binding slot
// must be present (WGSL declares @group(1) @binding(0)).

let store = {
  startedAt: performance.now(),
  maxReflections: 20,
};

const ZERO: Number4 = [0, 0, 0, 0];

export const orbitSpheresMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    // dummy 1-cell buffer — orbit positions are computed in the shader
    createGlobalPointsBuffer(1, () => ({ position: ZERO, velocity: ZERO, arm: ZERO }));
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => [performance.now() - store.startedAt, 0, store.maxReflections],
};
