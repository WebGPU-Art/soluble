/// <reference types="vite/client" />

import {
  loadTouchControl,
  setupRemoteControl,
  initializeContext,
  paintLagopusTree,
  renderLagopusTree,
  resetCanvasHeight,
  computeBasePoints,
  registerShaderResult,
} from "./index.mjs";

import { useGamepad, useRemoteControl } from "./config.mjs";
import { Atom } from "./atom.mjs";

import appConfigs from "./app.mjs";
import { loadGamepadControl } from "./control.mjs";
import { atomLagopusTree } from "./global.mjs";

let canvas = document.querySelector("canvas");
let timeoutState: NodeJS.Timeout;
let rafState = 0;

let loopPaint = () => {
  let tree = atomLagopusTree.deref();
  console.log("compute", tree);
  if (tree.useCompute) {
    computeBasePoints();
  }
  paintLagopusTree();
  // timeoutState = setTimeout(() => {
  rafState = requestAnimationFrame(loopPaint);
  // }, 40);
  // rafState = requestAnimationFrame(loopPaint);
};

window.onload = async () => {
  await initializeContext();
  appConfigs.initPointsBuffer();
  renderLagopusTree(appConfigs.renderShader, appConfigs.useCompute);
  loadTouchControl();

  loopPaint();

  resetCanvasHeight(canvas);
  registerShaderResult((e, code) => {
    if (e.messages.length) {
      console.error(e);
    }
  });

  window.onresize = () => {
    resetCanvasHeight(canvas);
    paintLagopusTree();
  };

  if (useRemoteControl) {
    setupRemoteControl();
  }

  if (useGamepad) {
    loadGamepadControl();
  }
};

import.meta.hot?.accept("./app.mts", (app) => {
  let newAppConfigs = app.default as typeof appConfigs;
  newAppConfigs.initPointsBuffer();

  renderLagopusTree(newAppConfigs.renderShader, newAppConfigs.useCompute);

  console.log("reloaded");
});
