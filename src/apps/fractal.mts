import { createGlobalPointsBuffer, BaseCellParams } from "../index.mjs";

import movePoints from "../../shaders/move-points.wgsl";
import strokeWgsl from "../../shaders/stroke.wgsl";

import fireCompute from "../../shaders/fire-compute.wgsl";
import cubicFire from "../../shaders/cubic-fire.wgsl";
import { useBaseSize } from "../config.mjs";
import { Number4, rand, randBalance } from "../math.mjs";

let createCubicFireBasePoint = (idx: number): BaseCellParams => {
  let offset = 200;
  let armOffset = 120;
  let position: Number4 = [randBalance(offset), randBalance(offset), randBalance(offset), 1];
  let velocity: Number4 = [0, 3 + randBalance(3), 0, 0];
  // let arm: Number4 = [randBalance(armOffset), randBalance(armOffset), randBalance(armOffset), 1];
  // let arm: Number4 = [100, 0, 0, 0];
  let arm: Number4 = [randBalance(armOffset), 0, randBalance(armOffset), 0];
  let params: Number4 = [rand(10), 2 + rand(2), 0, 0];
  let extendParams: Number4 = [idx, idx, idx, idx];
  return { position, arm, velocity, params, extendParams };
};

export const fractalConfigs = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(20, createCubicFireBasePoint);
  },
  computeShader: fireCompute,
  // computeShader: undefined as string,
  renderShader: cubicFire,
};
