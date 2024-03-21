import { createGlobalPointsBuffer, BaseCellParams } from "../index.mjs";

import ringsShader from "./rings.wgsl";
import { useBaseSize } from "../config.mjs";
import { Number4, rand, randBalance, normalize } from "../math.mjs";

let createPoint = (idx: number): BaseCellParams => {
  let offset = 600;
  let position: Number4 = [randBalance(offset), randBalance(offset), randBalance(offset), 1];
  let velocity: Number4 = normalize([randBalance(1), randBalance(1), randBalance(1), 0]);
  let arm: Number4 = normalize([randBalance(1), randBalance(1), randBalance(1), 0]);
  let params: Number4 = [rand(40), 2 + rand(2), 10, 10];

  return { position, params, velocity, arm };
};

console.log("size", useBaseSize);

export const configs = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(useBaseSize, createPoint);
  },
  useCompute: false,
  renderShader: ringsShader,
};
