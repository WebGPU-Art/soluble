import { Number4, rand } from "./math.mjs";
import { atomDevice, atomPointsBuffer } from "./global.mjs";
import { createBuffer, getComputeShaderModule } from "./utils.mjs";

let prevTime = Date.now();

export type BaseCellParams = {
  position: Number4;
  velocity: Number4;
  arm: Number4;
  params: Number4;
  extendParams: Number4;
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
    items.push(...info.velocity);
    items.push(...info.arm);
    items.push(...info.params);
    items.push(...info.extendParams);
  }
  atomPointsBuffer.reset(createBuffer(new Float32Array(items), GPUBufferUsage.STORAGE, device));
  return atomPointsBuffer.deref();
};

export function computeBasePoints(shaderCode: string) {
  let device = atomDevice.deref();
  const commandEncoder = device.createCommandEncoder();
  const passEncoder = commandEncoder.beginComputePass();

  const shaderModule = getComputeShaderModule(device, shaderCode);

  let basePointsBuffer = atomPointsBuffer.deref();
  let now = Date.now();
  let uniformBuffer = createBuffer(new Float32Array([now, now - prevTime, 0, 0]), GPUBufferUsage.UNIFORM, device);
  prevTime = now;

  const bindGroupLayout = device.createBindGroupLayout({
    entries: [
      { binding: 0, visibility: GPUShaderStage.COMPUTE, buffer: { type: "storage" } },
      { binding: 1, visibility: GPUShaderStage.COMPUTE, buffer: { type: "uniform" } },
    ],
  });

  const bindGroup = device.createBindGroup({
    layout: bindGroupLayout,
    entries: [
      { binding: 0, resource: { buffer: basePointsBuffer } },
      { binding: 1, resource: { buffer: uniformBuffer } },
    ],
  });

  const computePipeline = device.createComputePipeline({
    layout: device.createPipelineLayout({
      bindGroupLayouts: [bindGroupLayout],
    }),
    compute: {
      module: shaderModule,
      entryPoint: "main",
    },
  });

  passEncoder.setPipeline(computePipeline);
  passEncoder.setBindGroup(0, bindGroup);
  passEncoder.dispatchWorkgroups(8, 8);
  passEncoder.end();

  device.queue.submit([commandEncoder.finish()]);
}
