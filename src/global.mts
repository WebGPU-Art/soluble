import { LagopusElement, LagopusObjectBuffer } from "./primes.mjs";
import { Atom } from "./atom.mjs";
import { createBuffer } from "./utils.mjs";

export var atomDevice: Atom<GPUDevice> = new Atom(null);
export var atomContext: Atom<GPUCanvasContext> = new Atom(null);
/** TODO depth texture is shared by now, not sure which is better */
export var atomDepthTexture: Atom<GPUTexture> = new Atom(null);

export var atomBufferNeedClear: Atom<boolean> = new Atom(true);

export var atomLagopusTree: Atom<LagopusElement> = new Atom(null);

// proxy it for hot reloading
export let atomProxiedDispatch = new Atom<(op: string, data: any) => void>(null);

// touch events

export var atomMouseHoldingPaths = new Atom<number[][]>([]);

export let atomObjectsTree = new Atom<LagopusElement>(null);

export let atomObjectsBuffer = new Atom<LagopusObjectBuffer[]>([]);

export function wLog<T extends any>(message: string, a: T): T {
  console.warn(message, a);
  return a;
}

// prepare shared array called `base_points`

let sharedPointsBuffer: GPUBuffer;

function rand(n: number) {
  return (Math.random() - 0.5) * n;
}
export const getPointsBuffer = () => {
  if (sharedPointsBuffer) {
    return sharedPointsBuffer;
  }
  let device = atomDevice.deref();
  let items: number[] = [];
  let offset = 800;
  for (let i = 0; i < 40; i++) {
    items.push(rand(offset), rand(offset), rand(offset), 1);
    items.push(0, 0, 0, 0);
    items.push(0, 0, 0, 0);
  }
  sharedPointsBuffer = createBuffer(new Float32Array(items), GPUBufferUsage.STORAGE, device);
  return sharedPointsBuffer;
};

console.log("called");
