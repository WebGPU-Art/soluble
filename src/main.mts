/// <reference types="vite/client" />

import {
  loadTouchControl,
  setupRemoteControl,
  initializeContext,
  paintLagopusTree,
  renderLagopusTree,
  resetCanvasHeight,
  computeBasePoints,
  createGlobalPointsBuffer,
  BaseCellParams,
} from "./index.mjs";

import movePoints from "../shaders/move-points.wgsl";
import { compContainer } from "./app/container.mjs";
import { useBaseSize, useRemoteControl } from "./config.mjs";
import { Number4, rand, randBalance } from "./math.mjs";

let canvas = document.querySelector("canvas");
let timeoutState: NodeJS.Timeout;
let rafState = 0;

let loopPaint = () => {
  computeBasePoints(movePoints);
  paintLagopusTree();
  timeoutState = setTimeout(() => {
    rafState = requestAnimationFrame(loopPaint);
  }, 20);
  // rafState = requestAnimationFrame(loopPaint);
};

let createBasePoint = (idx: number): BaseCellParams => {
  let offset = 1200;
  let armOffset = 1000;
  let position: Number4 = [randBalance(offset), randBalance(offset), randBalance(offset), 1];
  let velocity: Number4 = [0, 0, 0, 0];
  let arm: Number4 = [randBalance(armOffset), randBalance(armOffset), randBalance(armOffset), 1];
  // let arm: Number4 = [20, 20, 0, 1];
  let params: Number4 = [rand(10), 2 + rand(2), 0, 0];
  let extendParams: Number4 = [idx, idx, idx, idx];
  return { position, arm, velocity, params, extendParams };
};

window.onload = async () => {
  await initializeContext();
  createGlobalPointsBuffer(useBaseSize, createBasePoint);
  renderLagopusTree(compContainer());
  loadTouchControl();

  loopPaint();

  resetCanvasHeight(canvas);
  window.onresize = () => {
    resetCanvasHeight(canvas);
    paintLagopusTree();
  };

  if (useRemoteControl) {
    setupRemoteControl();
  }
};

import.meta.hot?.accept("./app/container", (container) => {
  createGlobalPointsBuffer(useBaseSize, createBasePoint);
  clearTimeout(timeoutState);
  cancelAnimationFrame(rafState);

  renderLagopusTree(container.compContainer());
  loopPaint();

  console.log("reloaded");
});
