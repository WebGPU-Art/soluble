import { SolubleObjectData } from "./primes.mjs";
import { Atom } from "./atom.mjs";

export var atomDevice = new Atom<GPUDevice | null>(null);
export var atomContext = new Atom<GPUCanvasContext | null>(null);
/** TODO depth texture is shared by now, not sure which is better */
export var atomDepthTexture = new Atom<GPUTexture | null>(null);

export var atomBufferNeedClear: Atom<boolean> = new Atom(true);

export var atomSolubleTree = new Atom<SolubleObjectData | null>(null);

export function wLog<T>(message: string, a: T): T {
  console.warn(message, a);
  return a;
}

// prepare shared array called `base_points`

export let atomPointsBuffer = new Atom<GPUBuffer | null>(null);

/** optional buffer for another sets of data */
export let atomSecondaryBuffer = new Atom<GPUBuffer | null>(null);

export var atomSharedTextures: Atom<Record<string, GPUTexture>> = new Atom({});
