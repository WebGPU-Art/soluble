import { createGlobalPointsBuffer } from "../index.mjs";

import kaleidoscope from "./kaleidoscope.wgsl";
import { Number4, rand, randBalance } from "../math.mjs";
import { type ButtonEvents } from "../control.mjs";
import { SolubleApp } from "../primes.mjs";
import { BaseCellParams } from "../paint.mjs";

let store = {
  disableLens: 0, // or 1
  radius: 0.98,
};

let createKaleidoscopeBasePoint = (idx: number): BaseCellParams => {
  let offset = 8000;
  let armOffset = 8000;
  let position: Number4 = [randBalance(offset), randBalance(offset), randBalance(offset), 1];
  // let arm: Number4 = [randBalance(armOffset), randBalance(armOffset), randBalance(armOffset), 1];
  // let arm: Number4 = [100, 0, 0, 0];
  // let arm: Number4 = [randBalance(armOffset), randBalance(armOffset), randBalance(armOffset), 0];
  let arm = [1000, 0, 0, 0] as Number4;
  let params: Number4 = [idx, rand(20), 2 + rand(2), 0];
  return { position, arm, params };
};

export const kaleidoscopeConfigs: SolubleApp = {
  initPointsBuffer: () => {
    createGlobalPointsBuffer(160, createKaleidoscopeBasePoint);
  },
  useCompute: false,
  renderShader: kaleidoscope,
  onButtonEvent: (events: ButtonEvents) => {
    if (events.face1) {
      store.disableLens = store.disableLens < 0.5 ? 1 : 0;
      console.log("face1 tapped", store.disableLens);
    }
    if (events.face2) {
      store.radius = store.radius - 0.1;
      if (store.radius < 0) {
        store.radius += 1;
      }
      console.log("face2 tapped", store.radius);
    }
  },
  getParams: () => {
    return [store.disableLens, store.radius];
  },
};
