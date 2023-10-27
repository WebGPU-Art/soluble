export type NestedData<T> = NestedData<T>[] | T;

export function u32buffer(data: number[]): Uint32Array {
  let ret = new Uint32Array(data.length);
  for (let i = 0; i < data.length; i++) {
    ret[i] = data[i];
  }
  return ret;
}

export function newBufferFormatLength(format: GPUVertexFormat, size: number): Float32Array | Uint32Array {
  if (format === "float32") {
    return new Float32Array(size);
  } else if (format === "float32x2") {
    return new Float32Array(size * 2);
  } else if (format === "float32x3") {
    return new Float32Array(size * 3);
  } else if (format === "float32x4") {
    return new Float32Array(size * 4);
  } else if (format === "uint32") {
    return new Uint32Array(size);
  } else {
    throw new Error(`unsupported format ${format}`);
  }
}
