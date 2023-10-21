import { SolubleObjectData } from "./primes.mjs";
import { Atom } from "./atom.mjs";

export var atomDevice: Atom<GPUDevice> = new Atom(null);
export var atomContext: Atom<GPUCanvasContext> = new Atom(null);
/** TODO depth texture is shared by now, not sure which is better */
export var atomDepthTexture: Atom<GPUTexture> = new Atom(null);

export var atomBufferNeedClear: Atom<boolean> = new Atom(true);

export var atomLagopusTree: Atom<SolubleObjectData> = new Atom(null);

export function wLog<T extends any>(message: string, a: T): T {
  console.warn(message, a);
  return a;
}

// prepare shared array called `base_points`

export let atomPointsBuffer: Atom<GPUBuffer> = new Atom(null);
