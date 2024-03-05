export { createRenderer, initializeContext, renderLagopusTree } from "./render.mjs";

export { paintLagopusTree, resetCanvasHeight } from "./paint.mjs";
export { computeBasePoints, createGlobalPointsBuffer, type BaseCellParams } from "./paint.mjs";

export { onControlEvent, registerShaderResult, loadTouchControl, loadGamepadControl } from "./control.mjs";

export { setupRemoteControl } from "./remote-control.mjs";
