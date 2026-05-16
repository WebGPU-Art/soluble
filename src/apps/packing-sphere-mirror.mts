import { createGlobalPointsBuffer } from "../index.mjs";
import shader from "./packing-sphere-mirror.wgsl?raw";
import { Number4 } from "../math.mjs";
import { SolubleApp } from "../primes.mjs";
import { atomViewerPosition, atomViewerForward, atomViewerUpward } from "../perspective.mjs";
import { vAdd, vScale, vNormalize, vSub } from "../quaternion.mjs";

let store = {
  startedAt: performance.now(),
  maxReflections: 20,
};

const ZERO: Number4 = [0, 0, 0, 0];

export const packingSphereMirrorConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(1, () => ({ position: ZERO, velocity: ZERO, arm: ZERO }));
  },
  useCompute: false,
  renderShader: shader,
  getParams: () => {
    const time = performance.now() - store.startedAt;
    
    // Move camera in a circle
    const angle = time * 0.0005;
    const dist = 600;
    const px = Math.cos(angle) * dist;
    const pz = Math.sin(angle) * dist;
    const py = Math.sin(angle * 0.7) * 200; // floating up and down a bit
    
    const pos: [number, number, number] = [px, py, pz];
    atomViewerPosition.reset(pos);
    
    // Look at center [0,0,0]
    const center: [number, number, number] = [0, 0, 0];
    const forward = vNormalize(vSub(center, pos));
    atomViewerForward.reset(forward);
    
    // Keep upward vector mostly stable
    atomViewerUpward.reset([0, 1, 0]);

    return [time, 0, store.maxReflections];
  },
};
