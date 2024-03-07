import { SolubleObjectData } from "./primes.mjs";
import { atomDepthTexture, atomContext, atomDevice, atomBufferNeedClear, atomLagopusTree, wLog, atomPointsBuffer } from "./global.mjs";
import { atomViewerPosition, atomViewerScale, atomViewerUpward, newLookatPoint } from "./perspective.mjs";
import { vNormalize, vCross } from "./quaternion.mjs";

import { Number4, rand } from "./math.mjs";
import { createBuffer, getComputeShaderModule } from "./utils.mjs";
import solublePerspective from "../shaders/soluble-perspective.wgsl?raw";

let prevTime = Date.now();

export type BaseCellParams = {
  position: Number4;
  velocity?: Number4;
  arm?: Number4;
  params?: Number4;
  extendParams?: Number4;
};

let cachedBaseSize = 0;
export const createGlobalPointsBuffer = (baseSize: number, f: (idx: number) => BaseCellParams): GPUBuffer => {
  if (atomPointsBuffer.deref() && baseSize === cachedBaseSize) {
    return atomPointsBuffer.deref();
  }
  cachedBaseSize = baseSize;
  let device = atomDevice.deref();
  let items: number[] = [];
  for (let i = 0; i < baseSize; i++) {
    let info = f(i);
    items.push(...info.position);
    if (info.velocity) {
      items.push(...info.velocity);
    }
    if (info.arm) {
      items.push(...info.arm);
    }
    if (info.params) {
      items.push(...info.params);
    }
    if (info.extendParams) {
      items.push(...info.extendParams);
    }
  }
  atomPointsBuffer.reset(createBuffer(new Float32Array(items), GPUBufferUsage.STORAGE, device));
  return atomPointsBuffer.deref();
};

export function clearPointsBuffer() {
  atomPointsBuffer.reset(null);
}

export function computeBasePoints() {
  let device = atomDevice.deref();
  const commandEncoder = device.createCommandEncoder();
  const passEncoder = commandEncoder.beginComputePass();
  let { shaderModule } = atomLagopusTree.deref();

  let basePointsBuffer = atomPointsBuffer.deref();
  let now = Date.now();
  let uniformBuffer = getUniformBuffer(now); // TODO t
  let paramsBuffer = createBuffer(new Float32Array([now, now - prevTime, 0, 0]), GPUBufferUsage.UNIFORM, device);
  prevTime = now;

  const uniformsBindGroupLayout = device.createBindGroupLayout({
    entries: [
      { binding: 0, visibility: GPUShaderStage.COMPUTE, buffer: { type: "uniform" } },
      { binding: 1, visibility: GPUShaderStage.COMPUTE, buffer: { type: "uniform" } },
    ],
  });

  const uniformsBindGroup = device.createBindGroup({
    layout: uniformsBindGroupLayout,
    entries: [
      { binding: 0, resource: { buffer: uniformBuffer } },
      { binding: 1, resource: { buffer: paramsBuffer } },
    ],
  });

  const particlesBindGroupLayout = device.createBindGroupLayout({
    entries: [{ binding: 0, visibility: GPUShaderStage.COMPUTE, buffer: { type: "storage" } }],
  });
  const particlesUniformsBindGroup = device.createBindGroup({
    layout: particlesBindGroupLayout,
    entries: [{ binding: 0, resource: { buffer: basePointsBuffer } }],
  });

  const computePipeline = device.createComputePipeline({
    layout: device.createPipelineLayout({
      bindGroupLayouts: [uniformsBindGroupLayout, particlesBindGroupLayout],
    }),
    compute: {
      module: shaderModule,
      entryPoint: "compute_main",
    },
  });

  passEncoder.setPipeline(computePipeline);
  passEncoder.setBindGroup(0, uniformsBindGroup);
  passEncoder.setBindGroup(1, particlesUniformsBindGroup);
  passEncoder.dispatchWorkgroups(8, 8);
  passEncoder.end();

  device.queue.submit([commandEncoder.finish()]);
}

const presentationFormat = window.navigator.gpu.getPreferredCanvasFormat();

// ~~ CREATE RENDER PASS DESCRIPTOR ~~
var renderPassDescriptor = {
  colorAttachments: [
    {
      clearValue: { r: 0.0, g: 0.0, b: 0.0, a: 1.0 },
      loadOp: "clear" as GPULoadOp,
      storeOp: "store" as GPUStoreOp,
      view: null as GPUTextureView,
    },
  ],
  depthStencilAttachment: {
    view: null as GPUTextureView,
    depthClearValue: 1,
    depthLoadOp: "clear" as GPULoadOp,
    depthStoreOp: "store" as GPUStoreOp,
    stentialClearValue: 0,
    stencilLoadOp: "clear" as GPULoadOp,
    stencilStoreOp: "store" as GPUStoreOp,
  },
};

/** from global states */
let getUniformBuffer = (t: number): GPUBuffer => {
  // create uniforms
  // based on code from https://alain.xyz/blog/raw-webgpu

  let lookAt = newLookatPoint();
  let forward = vNormalize(lookAt);
  let upward = atomViewerUpward.deref();
  let rightward = vCross(forward, atomViewerUpward.deref());
  let viewerPosition = atomViewerPosition.deref();
  // 👔 Uniform Data
  const uniformData = new Float32Array([
    window.innerWidth * window.devicePixelRatio,
    window.innerHeight * window.devicePixelRatio,
    atomViewerScale.deref(),
    t,
    // lookpoint
    ...forward,
    // alignment
    0,
    // upwardDirection
    ...upward,
    // alignment
    0,
    ...rightward,
    // alignment
    0,
    // cameraPosition
    ...viewerPosition,
    // alignment
    0,
  ]);
  let device = atomDevice.deref();

  let uniformBuffer = createBuffer(uniformData, GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST, device);
  return uniformBuffer;
};

let buildCommandBuffer = (t: number): GPUCommandBuffer => {
  let { topology, shaderModule, vertexBuffersDescriptors, vertexBuffers, indices } = atomLagopusTree.deref();

  // console.log("uniformData", uniformData);

  let device = atomDevice.deref();
  let now = Date.now();

  let uniformBuffer = getUniformBuffer(t);
  let paramsBuffer = createBuffer(new Float32Array([now, now - prevTime, 0, 0]), GPUBufferUsage.UNIFORM, device);
  prevTime = now;

  let uniformBindGroupLayout = device.createBindGroupLayout({
    entries: [
      { binding: 0, visibility: GPUShaderStage.VERTEX | GPUShaderStage.FRAGMENT, buffer: { type: "uniform" } },
      { binding: 1, visibility: GPUShaderStage.VERTEX | GPUShaderStage.FRAGMENT, buffer: { type: "uniform" } },
    ],
  });

  let uniformBindGroup = device.createBindGroup({
    layout: uniformBindGroupLayout,
    entries: [
      { binding: 0, resource: { buffer: uniformBuffer } },
      { binding: 1, resource: { buffer: paramsBuffer } },
    ],
  });

  let particlesBindGroupLayout = device.createBindGroupLayout({
    entries: [{ binding: 0, visibility: GPUShaderStage.FRAGMENT, buffer: { type: "storage" } }],
  });

  let particlesBindGroup = device.createBindGroup({
    layout: particlesBindGroupLayout,
    entries: [{ binding: 0, resource: { buffer: atomPointsBuffer.deref() } }],
  });

  // ~~ CREATE RENDER PIPELINE ~~

  let renderLayout = device.createPipelineLayout({ bindGroupLayouts: [uniformBindGroupLayout, particlesBindGroupLayout] });

  let pipeline = device.createRenderPipeline({
    layout: renderLayout,
    vertex: { module: shaderModule, entryPoint: "vertex_main", buffers: vertexBuffersDescriptors },
    fragment: { module: shaderModule, entryPoint: "fragment_main", targets: [{ format: presentationFormat }] },
    primitive: {
      topology,
    },
    depthStencil: { depthWriteEnabled: true, depthCompare: "less", format: "depth24plus-stencil8" },
  });

  let needClear = atomBufferNeedClear.deref();
  atomBufferNeedClear.reset(false);

  let loadOpValue = (needClear ? "clear" : "load") as GPULoadOp;

  let context = atomContext.deref();
  let depthTexture = atomDepthTexture.deref();

  renderPassDescriptor.colorAttachments[0].loadOp = loadOpValue;
  renderPassDescriptor.depthStencilAttachment.depthLoadOp = loadOpValue;
  renderPassDescriptor.colorAttachments[0].view = context.getCurrentTexture().createView();
  renderPassDescriptor.depthStencilAttachment.view = depthTexture.createView();

  const commandEncoder = device.createCommandEncoder();
  const passEncoder = commandEncoder.beginRenderPass(renderPassDescriptor);

  passEncoder.setBindGroup(0, uniformBindGroup);
  passEncoder.setBindGroup(1, particlesBindGroup);

  passEncoder.setPipeline(pipeline);
  vertexBuffers.forEach((vertexBuffer, idx) => {
    passEncoder.setVertexBuffer(idx, vertexBuffer);
  });

  // just use uint32, skip uint16
  passEncoder.setIndexBuffer(indices, "uint32");
  passEncoder.drawIndexed(indices.size / 4);

  passEncoder.end();

  return commandEncoder.finish();
};

let startTime = Date.now();

/** send command buffer to device and render */
export function paintLagopusTree() {
  // console.log("paint");
  atomBufferNeedClear.reset(true);
  let device = atomDevice.deref();

  let lifetime = Date.now() - startTime;

  let bufferList: GPUCommandBuffer[] = [buildCommandBuffer(lifetime)];
  device.queue.submit(bufferList);
}

export function resetCanvasHeight(canvas: HTMLCanvasElement) {
  // canvas height not accurate on Android Pad, use innerHeight
  canvas.style.height = `${window.innerHeight}px`;
}

export let interpolateShader = (shader: string) => {
  return shader.replace("#import soluble::perspective", solublePerspective);
};
