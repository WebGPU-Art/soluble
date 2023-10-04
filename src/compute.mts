import { atomDevice, getPointsBuffer } from "./global.mjs";
import movePoints from "../shaders/move-points.wgsl";
import { createBuffer } from "./utils.mjs";

let shaderModule: GPUShaderModule;

function getShaderModule(device: GPUDevice) {
  if (shaderModule) {
    return shaderModule;
  }
  shaderModule = device.createShaderModule({
    code: movePoints,
  });
  return shaderModule;
}

let prevTime = Date.now();

export function computeBasePoints() {
  let device = atomDevice.deref();
  const commandEncoder = device.createCommandEncoder();
  const passEncoder = commandEncoder.beginComputePass();

  const shaderModule = getShaderModule(device);

  let basePointsBuffer = getPointsBuffer();
  let now = Date.now();
  let uniformBuffer = createBuffer(new Float32Array([now, now - prevTime, 0, 0]), GPUBufferUsage.UNIFORM, device);
  prevTime = now;

  const bindGroupLayout = device.createBindGroupLayout({
    entries: [
      {
        binding: 0,
        visibility: GPUShaderStage.COMPUTE,
        buffer: {
          type: "storage",
        },
      },
      {
        binding: 1,
        visibility: GPUShaderStage.COMPUTE,
        buffer: {
          type: "uniform",
        },
      },
    ],
  });

  const bindGroup = device.createBindGroup({
    layout: bindGroupLayout,
    entries: [
      {
        binding: 0,
        resource: {
          buffer: basePointsBuffer,
        },
      },
      {
        binding: 1,
        resource: {
          buffer: uniformBuffer,
        },
      },
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
