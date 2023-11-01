import { SolubleObjectData } from "./primes.mjs";
import { atomDepthTexture, atomContext, atomDevice, atomBufferNeedClear, atomLagopusTree, wLog, atomPointsBuffer } from "./global.mjs";
import { atomViewerPosition, atomViewerScale, atomViewerUpward, newLookatPoint } from "./perspective.mjs";
import { vNormalize, vCross } from "./quaternion.mjs";
import { createBuffer } from "./utils.mjs";

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

/** don't know why, but fixes, https://programmer.ink/think/several-best-practices-of-webgpu.html */
let emptyBuffer = {};

let buildCommandBuffer = (info: SolubleObjectData, t: number): GPUCommandBuffer => {
  let { topology, shaderModule, vertexBuffersDescriptors, vertexBuffers, indices } = info;

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

  // console.log("uniformData", uniformData);

  let device = atomDevice.deref();

  let uniformBuffer = createBuffer(uniformData, GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST, device);
  let uniformBindGroupLayout = device.createBindGroupLayout({
    entries: [
      { binding: 0, visibility: GPUShaderStage.VERTEX | GPUShaderStage.FRAGMENT, buffer: emptyBuffer },
      { binding: 1, visibility: GPUShaderStage.FRAGMENT, buffer: { type: "storage" } },
    ],
  });

  let uniformBindGroup = device.createBindGroup({
    layout: uniformBindGroupLayout,
    entries: [
      { binding: 0, resource: { buffer: uniformBuffer } },
      { binding: 1, resource: { buffer: atomPointsBuffer.deref() } },
    ],
  });

  // ~~ CREATE RENDER PIPELINE ~~

  const pipelineLayoutDesc = { bindGroupLayouts: [uniformBindGroupLayout] };
  let renderLayout = device.createPipelineLayout(pipelineLayoutDesc);

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
  let tree = atomLagopusTree.deref();
  let bufferList: GPUCommandBuffer[] = [buildCommandBuffer(tree as SolubleObjectData, lifetime)];
  device.queue.submit(bufferList);
}

export function resetCanvasHeight(canvas: HTMLCanvasElement) {
  // canvas height not accurate on Android Pad, use innerHeight
  canvas.style.height = `${window.innerHeight}px`;
}
