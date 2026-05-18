import { createGlobalPointsBuffer } from "../index.mjs";

import apollonianMobiusRender from "./apollonian-mobius.wgsl";

import { SolubleApp } from "../primes.mjs";
import { BaseCellParams } from "../paint.mjs";

let createDummyBasePoint = (): BaseCellParams => {
  return {
    position: [0, 0, 0, 1],
    velocity: [0, 0, 0, 0],
    arm: [0, 0, 0, 0],
    params: [0, 0, 0, 0],
    extendParams: [0, 0, 0, 0],
  };
};

export const apollonianMobiusConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(1, createDummyBasePoint);
  },
  useCompute: false,
  renderShader: apollonianMobiusRender,
};
