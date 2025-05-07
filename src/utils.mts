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

let shaderModule: GPUShaderModule;
let cacgedShaderCode: string;

export function getComputeShaderModule(device: GPUDevice, shaderCode: string) {
  if (shaderModule && shaderCode === cacgedShaderCode) {
    return shaderModule;
  }
  cacgedShaderCode = shaderCode;

  shaderModule = device.createShaderModule({
    code: shaderCode,
  });
  return shaderModule;
}

export let createTextureFromSource = (device: GPUDevice, source: { w: number; h: number; source: GPUImageCopyExternalImageSource }) => {
  let texture = device.createTexture({
    size: { width: source.w, height: source.h },
    format: "rgba8unorm",
    usage: GPUTextureUsage.TEXTURE_BINDING | GPUTextureUsage.COPY_DST | GPUTextureUsage.RENDER_ATTACHMENT,
  });
  device.queue.copyExternalImageToTexture(source, { texture }, { width: source.w, height: source.h });
  return texture;
};

export let loadImageAsTexture = async (device: GPUDevice, url: string): Promise<GPUTexture> => {
  const response = await fetch(url);
  const imageBitmap = await createImageBitmap(await response.blob());
  let texture = createTextureFromSource(device, {
    source: imageBitmap,
    w: imageBitmap.width,
    h: imageBitmap.height,
  });
  return texture;
};

// create an input element, trigger a click, and remove it.
// main feature is to load image, and put into texture
export let loadImageFromInputEl = (device: GPUDevice): Promise<GPUTexture> => {
  return new Promise((resolve) => {
    let input = document.createElement("input");
    input.type = "file";
    input.accept = "image/*";
    input.onchange = async (e) => {
      let file = (e.target as HTMLInputElement).files?.[0];
      if (!file) {
        console.error("No file selected");
        return;
      }
      let url = URL.createObjectURL(file);
      let texture = await loadImageAsTexture(device, url);
      resolve(texture);
    };
    input.click();
  });
};
