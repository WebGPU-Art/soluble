import { createGlobalPointsBuffer, BaseCellParams } from "../index.mjs";

import kaleidoscope from "./kaleidoscope.wgsl";
import { Number4, rand, randBalance } from "../math.mjs";

let createKaleidoscopeBasePoint = (idx: number): BaseCellParams => {
  let offset = 2000;
  let armOffset = 8000;
  let position: Number4 = [randBalance(offset), randBalance(offset), randBalance(offset), 1];
  // let arm: Number4 = [randBalance(armOffset), randBalance(armOffset), randBalance(armOffset), 1];
  // let arm: Number4 = [100, 0, 0, 0];
  // let arm: Number4 = [randBalance(armOffset), randBalance(armOffset), randBalance(armOffset), 0];
  let arm = [1000, 0, 0, 0] as Number4;
  let params: Number4 = [idx, rand(20), 2 + rand(2), 0];
  return { position, arm, params };
};

export const kaleidoscopeConfigs = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(120, createKaleidoscopeBasePoint);
  },
  useCompute: false,
  renderShader: kaleidoscope,
};
