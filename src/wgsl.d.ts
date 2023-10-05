declare module "*.wgsl" {
  const value: string;
  export default value;
}

declare module "*.glsl" {
  const value: string;
  export default value;
}

declare module "*.vert" {
  const value: string;
  export default value;
}

declare module "*.frag" {
  const value: string;
  export default value;
}

declare var __lagopusHandleCompilationInfo: (info: GPUCompilationInfo, code: string) => void;
