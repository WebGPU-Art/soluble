/// <reference types="vite/client" />

import queryString from "query-string";

import { initializeContext, paintLagopusTree, renderLagopusTree, resetCanvasHeight } from "./render.mjs";

import { compContainer } from "./app/container.mjs";
import { renderControl, startControlLoop } from "@triadica/touch-control";
import { onControlEvent } from "./control.mjs";
import { setupMouseEvents } from "./events.mjs";
import { Atom } from "./atom.mjs";
import { V3 } from "./primes.mjs";
import { setupRemoteControl } from "./remote-control.mjs";

let store = new Atom({
  position: [180, 80, 80] as V3,
});

let dispatch = (op: string, data: any) => {
  if (op === "drag") {
    store.deref().position = data;
    renderApp();
  } else {
    console.warn("dispatch", op, data);
  }
};

/** for HMR */
let mainComponent = compContainer;

function renderApp() {
  let tree = mainComponent(store.deref());

  renderLagopusTree(tree, dispatch);
}

window.onload = async () => {
  await initializeContext();
  renderApp();
  console.log("loaded");

  renderControl();
  startControlLoop(10, onControlEvent);

  let canvas = document.querySelector("canvas");

  window.onresize = () => {
    resetCanvasHeight(canvas);
    paintLagopusTree();
  };
  resetCanvasHeight(canvas);

  window.__lagopusHandleCompilationInfo = (e, code) => {
    if (e.messages.length) {
      console.error(e);
    }
  };
  setupMouseEvents(canvas);

  const parsed = queryString.parse(location.search);

  if (parsed["remote-control"]) {
    setupRemoteControl();
  }
};

declare global {
  /** dirty hook for extracting error messages */
  var __lagopusHandleCompilationInfo: (info: GPUCompilationInfo, code: string) => void;
}

import.meta.hot.accept("./app/container", (container) => {
  console.log("reloading");
  mainComponent = container.compContainer;
  renderApp();
});
