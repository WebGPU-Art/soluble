import { threshold } from "./config.mjs";
import { GameButtons, setupGamepadControl } from "./gamepad";
import { atomViewerScale, changeScaleBy, moveViewerBy, rotateGlanceBy, spinGlanceBy } from "./perspective.mjs";
import { V2 } from "./primes.mjs";
import { ControlStates, renderControl, startControlLoop } from "@triadica/touch-control";

let lastTime = Date.now();
export let onControlEvent = (elapsed: number, states: ControlStates, delta: ControlStates) => {
  let now = Date.now();
  // let elapsed = (now - lastTime) / 100000;
  let lMove = states.leftMove.map(refineStrength) as V2;
  let rMove = states.rightMove.map(refineStrength) as V2;
  let rDelta = delta.rightMove;
  let lDelta = delta.leftMove;
  let leftA = states.leftA;
  let rightA = states.rightA || states.shift;
  let rightB = states.rightB;
  let leftB = states.leftB;
  if (lMove[1] !== 0) {
    moveViewerBy(0, 0, -2 * elapsed * lMove[1]);
  }
  if (lMove[0] !== 0) {
    rotateGlanceBy(-0.05 * elapsed * lMove[0], 0);
  }
  if (!rightA && !rightB && !isZero(rMove)) {
    moveViewerBy(2 * elapsed * rMove[0], 2 * elapsed * rMove[1], 0);
  }
  if (rightA && !rightB && rMove[1] !== 0) {
    rotateGlanceBy(0, 0.05 * elapsed * rMove[1]);
  }
  if (rightA && !rightB && rMove[0] !== 0) {
    spinGlanceBy(-0.05 * elapsed * rMove[0]);
  }
  if (!rightA && rightB && rMove[0] !== 0) {
    changeScaleBy(0.01 * elapsed * rMove[0]);
  }
  // if (!isZero(lMove) || !isZero(rMove)) {
  //   paintLagopusTree();
  // }
};

let isZero = (v: V2): boolean => {
  return v[0] === 0 && v[1] === 0;
};

let refineStrength = (x: number): number => {
  return x * Math.sqrt(Math.abs(x * 0.02));
};

/** function to catch shader compilation errors */
export function registerShaderResult(f: (e: GPUCompilationInfo, code: string) => void) {
  window.__lagopusHandleCompilationInfo = f;
}

let someValue = (x: number) => {
  return Math.abs(x) > threshold ? x : 0;
};

export function loadTouchControl() {
  renderControl();
  startControlLoop(10, onControlEvent);
}

let prevButtons: GameButtons = undefined;
/** wrapped events from GameButtons */
export type ButtonEvents = Partial<{
  face1: boolean;
  face2: boolean;
  face3: boolean;
  face4: boolean;
  l1: boolean;
  r1: boolean;
  l2: boolean;
  r2: boolean;
  select: boolean;
  start: boolean;
  l3: boolean;
  r3: boolean;
  up: boolean;
  down: boolean;
  left: boolean;
  right: boolean;
}>;
let buttonNames: (keyof GameButtons)[] = [
  "face1",
  "face2",
  "face3",
  "face4",
  "l1",
  "r1",
  "l2",
  "r2",
  "select",
  "start",
  "l3",
  "r3",
  "up",
  "down",
  "left",
  "right",
];

export let loadGamepadControl = (handleButtonEvent?: (events: ButtonEvents) => void) => {
  console.log("loading gamepad control");
  setupGamepadControl((axes, buttons) => {
    let scale = atomViewerScale.deref();
    let speedy = buttons.l1.value > 0.5 || buttons.r1.value > 0.5 ? 8 : 1;
    let faster = speedy > 4 ? 4 : 1;
    let ss = speedy / scale;
    // left/right, up/down, front/back
    moveViewerBy(someValue(axes.rightX) * 10 * ss, -someValue(axes.rightY) * 10 * ss, someValue(axes.leftY) * 10 * ss);
    rotateGlanceBy(-0.1 * faster * someValue(axes.leftX), 0.05 * faster * someValue(buttons.up.value - buttons.down.value));

    spinGlanceBy(0.1 * faster * someValue(buttons.right.value - buttons.left.value));

    if (buttons.l2.value > 0.5) {
      changeScaleBy(0.01 * speedy);
    }
    if (buttons.r2.value > 0.5) {
      changeScaleBy(-0.01 * speedy);
    }

    if (handleButtonEvent != null && prevButtons != null) {
      let events = {} as ButtonEvents;
      let hasEvent = false;
      buttonNames.forEach((b) => {
        if (buttons?.[b]?.pressed === true && prevButtons?.[b]?.pressed === false) {
          events[b] = true;
          hasEvent = true;
        }
      });
      if (hasEvent) {
        handleButtonEvent(events);
      }
    }
    prevButtons = buttons;
  });
};
