import { createGlobalPointsBuffer, BaseCellParams } from "../index.mjs";

import sphereFractalRender from "./sphere-fractal.wgsl";
import { Number4, rand, randBalance } from "../math.mjs";

import { useBaseSize } from "../config.mjs";
import { SolubleApp } from "../primes.mjs";

let createCubicFireBasePoint = (idx: number): BaseCellParams => {
  let offset = 400;
  let armOffset = 440;
  let angle = idx * 0.7;
  let r = Math.pow(idx, 0.6) * 40 + 20;
  let position: Number4 = [r * Math.cos(angle), r * Math.sin(angle), 0, 1];
  let velocity: Number4 = [0, 3 + randBalance(3), 0, 0];
  // let arm: Number4 = [randBalance(armOffset), randBalance(armOffset), randBalance(armOffset), 1];
  // let arm: Number4 = [100, 0, 0, 0];
  let arm: Number4 = [randBalance(armOffset), 0, randBalance(armOffset), 0];
  let params: Number4 = [rand(10), 2 + rand(2), 0, 0];
  let extendParams: Number4 = [idx, idx, idx, idx];
  return { position, arm, velocity, params, extendParams };
};

export const sphereFractalConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(20, createCubicFireBasePoint);
  },
  useCompute: false,
  renderShader: sphereFractalRender,
};
