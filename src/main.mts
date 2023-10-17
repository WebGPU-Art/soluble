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
import { Number4, rand } from "./math.mjs";

let canvas = document.querySelector("canvas");
let timeoutState: NodeJS.Timeout;
let rafState = 0;

let loopPaint = () => {
  computeBasePoints(movePoints);
  paintLagopusTree();
  timeoutState = setTimeout(() => {
    requestAnimationFrame(loopPaint);
  }, 40);
  // rafState = requestAnimationFrame(loopPaint);
};

let createBasePoint = (idx: number): BaseCellParams => {
  let offset = 600;
  let position: Number4 = [rand(offset), rand(offset), rand(offset), 1];
  let velocity: Number4 = [0, 0, 0, 0];
  let arm: Number4 = [rand(offset), rand(offset), rand(offset), 1];
  let params: Number4 = [rand(10), 2 + rand(2), 0, 0];
  return { position, arm, velocity, params };
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
