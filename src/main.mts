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
} from "./index.mjs";

import movePoints from "../shaders/move-points.wgsl";
import { compContainer } from "./app/container.mjs";
import { useBaseSize, useRemoteControl } from "./config.mjs";

let canvas = document.querySelector("canvas");
let timeoutState: NodeJS.Timeout;
let rafState = 0;

let loopPaint = () => {
  computeBasePoints(movePoints);
  paintLagopusTree();
  timeoutState = setTimeout(() => {
    requestAnimationFrame(loopPaint);
  }, 50);
  // rafState = requestAnimationFrame(loopPaint);
};

window.onload = async () => {
  await initializeContext();
  createGlobalPointsBuffer(useBaseSize, 800);
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
  clearTimeout(timeoutState);
  cancelAnimationFrame(rafState);

  renderLagopusTree(container.compContainer());
  loopPaint();

  console.log("reloaded");
});
