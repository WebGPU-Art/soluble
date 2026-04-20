import { isGamepadButtonPressed } from "../control.mjs";
import { Number4 } from "../math.mjs";
import { updateGlobalPointsBuffer } from "../index.mjs";
import { updateSecondaryDataBuffer } from "../paint.mjs";

type RotatingCell = { position: Number4; velocity: Number4; arm: Number4 };

type RotationStore = {
  angleY: number;
  lastTickAt: number;
};

const HELD_ROTATION_SPEED = 0.00005;

let rotateY = (point: Number4, angle: number): Number4 => {
  const c = Math.cos(angle);
  const s = Math.sin(angle);
  return [point[0] * c + point[2] * s, point[1], -point[0] * s + point[2] * c, point[3] || 0];
};

let rotateCellY = (cell: RotatingCell, angle: number): RotatingCell => {
  return {
    position: rotateY(cell.position, angle),
    velocity: rotateY(cell.velocity, angle),
    arm: rotateY(cell.arm, angle),
  };
};

export let updateHeldYRotation = (store: RotationStore, mirrorsBase: RotatingCell[], segmentsBase: RotatingCell[]): void => {
  let now = performance.now();
  let delta = Math.min(50, Math.max(0, now - store.lastTickAt));
  store.lastTickAt = now;

  if (!isGamepadButtonPressed("face2")) {
    return;
  }

  store.angleY += delta * HELD_ROTATION_SPEED;
  updateGlobalPointsBuffer(mirrorsBase.length, (idx) => rotateCellY(mirrorsBase[idx], store.angleY));

  if (segmentsBase.length > 0) {
    updateSecondaryDataBuffer(segmentsBase.length, (idx) => rotateCellY(segmentsBase[idx], store.angleY));
  }
};
