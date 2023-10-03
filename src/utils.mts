// 👋 Helper function for creating GPUBuffer(s) out of Typed Arrays
export const createBuffer = (arr: Float32Array | Uint32Array, usage: number, device: GPUDevice) => {
  // 📏 Align to 4 bytes (thanks @chrimsonite)
  let desc = {
    size: (arr.byteLength + 3) & ~3,
    // size: 64,
    usage,
    mappedAtCreation: true,
  };
  let buffer = device.createBuffer(desc);

  const writeArray = arr instanceof Uint32Array ? new Uint32Array(buffer.getMappedRange()) : new Float32Array(buffer.getMappedRange());
  writeArray.set(arr);
  buffer.unmap();
  return buffer;
};
