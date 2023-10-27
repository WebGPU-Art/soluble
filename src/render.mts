import { SolubleAttribute, SolubleObjectData } from "./primes.mjs";
import { atomDepthTexture, atomContext, atomDevice, atomLagopusTree, wLog } from "./global.mjs";
import { createBuffer } from "./utils.mjs";
import { newBufferFormatLength, u32buffer } from "./alias.mjs";

/** init canvas context */
export const initializeContext = async (): Promise<any> => {
  // ~~ INITIALIZE ~~ Make sure we can initialize WebGPU
  if (!navigator.gpu) {
    console.error("WebGPU cannot be initialized - navigator.gpu not found");
    return null;
  }
  const adapter = await navigator.gpu.requestAdapter();
  if (!adapter) {
    console.error("WebGPU cannot be initialized - Adapter not found");
    return null;
  }
  const device = await adapter.requestDevice();
  device.lost.then(() => {
    console.error("WebGPU cannot be initialized - Device has been lost");
    return null;
  });

  // set as a shared device
  atomDevice.reset(device);

  const canvas = document.getElementById("canvas-container") as HTMLCanvasElement;
  const context = canvas.getContext("webgpu");
  if (!context) {
    console.error("WebGPU cannot be initialized - Canvas does not support WebGPU");
    return null;
  }

  // ~~ CONFIGURE THE SWAP CHAIN ~~
  const devicePixelRatio = window.devicePixelRatio || 1;
  const presentationFormat = window.navigator.gpu.getPreferredCanvasFormat();

  canvas.width = window.innerWidth * devicePixelRatio;
  canvas.height = window.innerHeight * devicePixelRatio;

  context.configure({
    device,
    format: presentationFormat,
    usage: GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.COPY_SRC,
    alphaMode: "premultiplied",
  });

  // set as a shared context
  atomContext.reset(context);

  const depthTexture = device.createTexture({
    size: [window.innerWidth * devicePixelRatio, window.innerHeight * devicePixelRatio],
    // format: "depth24plus",
    // usage: GPUTextureUsage.RENDER_ATTACHMENT,
    dimension: "2d",
    format: "depth24plus-stencil8",
    usage: GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.COPY_SRC,
  });

  atomDepthTexture.reset(depthTexture);
};

/** prepare vertex buffer from object */
export let createRenderer = (
  shaderCode: string,
  topology: GPUPrimitiveTopology,
  attrsList: {
    field: string;
    format: GPUVertexFormat;
    size: number;
    /** defaults to 4 for `float32` since 32=8*4, would change for other types */
    unitSize?: number;
  }[],
  verticesLength: number,
  vertices: (Float32Array | Uint32Array)[],
  indices: Uint32Array
): SolubleObjectData => {
  // load shared device
  let device = atomDevice.deref();

  let vertexBuffers = vertices.map((v) => createBuffer(v, GPUBufferUsage.VERTEX | GPUBufferUsage.COPY_DST, device));
  let indecesBuffer = indices ? createBuffer(indices, GPUBufferUsage.INDEX | GPUBufferUsage.COPY_DST, device) : null;

  const vertexBuffersDescriptors = attrsList.map((info, idx) => {
    let stride = info.size * (info.unitSize || 4);
    return {
      attributes: [{ shaderLocation: idx, offset: 0, format: info.format }],
      arrayStride: stride,
      stepMode: "vertex" as GPUVertexStepMode,
    } as GPUVertexBufferLayout;
  });

  // ~~ DEFINE BASIC SHADERS ~~
  const shaderModule = device.createShaderModule({
    code: shaderCode,
  });

  shaderModule.getCompilationInfo().then((e) => {
    // a dirty hook to expose build messages
    globalThis.__lagopusHandleCompilationInfo?.(e, shaderCode);
  });

  return {
    type: "object",
    topology: topology,
    shaderModule: shaderModule,
    vertexBuffersDescriptors: vertexBuffersDescriptors,
    vertexBuffers,
    length: verticesLength,
    indices: indecesBuffer,
  };
};

/** track tree, internally it calls `paintLagopusTree` to render */
export function renderLagopusTree(strokeWgsl: string) {
  let data: Record<string, number[]>[] = [
    {
      position: [-1, -1],
    },
    { position: [-1, 1] },
    { position: [1, -1] },
    { position: [1, 1] },
  ];
  let attrsList: SolubleAttribute[] = [{ field: "position", format: "float32x2", size: 2 }];

  let buffers = attrsList.map((attr) => {
    var buffer = newBufferFormatLength(attr.format, data.length);

    var pointer = 0;
    for (let i = 0; i < data.length; i++) {
      let v = data[i][attr.field];
      for (let j = 0; j < v.length; j++) {
        buffer[pointer] = v[j];
        pointer += 1;
      }
    }

    return buffer;
  });

  let indices = u32buffer([0, 1, 2, 1, 2, 3]);

  /** create a render object */
  let tree = createRenderer(strokeWgsl, "triangle-list", attrsList, data.length, buffers, indices);
  atomLagopusTree.reset(tree);
}
