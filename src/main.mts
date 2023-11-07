/// <reference types="vite/client" />

import {
  loadTouchControl,
  setupRemoteControl,
  initializeContext,
  paintLagopusTree,
  renderLagopusTree,
  resetCanvasHeight,
  computeBasePoints,
} from "./index.mjs";

import { useRemoteControl } from "./config.mjs";
import { Atom } from "./atom.mjs";

import appConfigs from "./app.mjs";

let canvas = document.querySelector("canvas");
let timeoutState: NodeJS.Timeout;
let rafState = 0;

let computeShaderState = new Atom(appConfigs.computeShader);

let loopPaint = () => {
  if (computeShaderState.value) {
    computeBasePoints(computeShaderState.value);
  }
  paintLagopusTree();
  timeoutState = setTimeout(() => {
    rafState = requestAnimationFrame(loopPaint);
  }, 80);
  // rafState = requestAnimationFrame(loopPaint);
};

window.onload = async () => {
  await initializeContext();
  appConfigs.initPointsBuffer();
  renderLagopusTree(appConfigs.renderShader);
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

import.meta.hot?.accept("./app.mts", (app) => {
  let newAppConfigs = app.default as typeof appConfigs;
  newAppConfigs.initPointsBuffer();

  renderLagopusTree(newAppConfigs.renderShader);
  computeShaderState.value = newAppConfigs.computeShader;

  console.log("reloaded");
});
