import { createGlobalPointsBuffer } from "../index.mjs";

import starsShader from "./stars.wgsl";
import { useBaseSize } from "../config.mjs";
import { Number4, rand, randBalance } from "../math.mjs";
import { BaseCellParams } from "../paint.mjs";

let createPoint = (idx: number): BaseCellParams => {
  let offset = 2000;
  let position: Number4 = [randBalance(offset), randBalance(offset), randBalance(offset), 1];
  let params: Number4 = [rand(10), 2 + rand(2), 10, 10];

  return { position, params };
};

export const configs = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(useBaseSize, createPoint);
  },
  useCompute: false,
  renderShader: starsShader,
};
