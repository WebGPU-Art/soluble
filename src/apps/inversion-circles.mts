import { createGlobalPointsBuffer } from "../index.mjs";

import inversionCircles from "./inversion-circles.wgsl?raw";
import { Number2, Number3, Number4, rand, randBalance, randBetween, range } from "../math.mjs";
import { type ButtonEvents } from "../control.mjs";
import { SolubleApp } from "../primes.mjs";
import { BaseCellParams } from "../paint.mjs";

let store = {
  startedAt: performance.now(),
  maxSpheres: 20,
  generations: 5,
};

// Sphere structure: [x, y, z, radius]
type Sphere = Number4;

// Extended sphere with generation info
type SphereWithGen = {
  sphere: Sphere;
  generation: number;
};

// Generate three initial random spheres
let generateInitialSpheres = (): SphereWithGen[] => {
  let spheres: SphereWithGen[] = [];

  // Place three spheres randomly
  for (let i = 0; i < 3; i++) {
    let x = randBetween(-80, 80);
    let y = randBetween(-60, 60);
    let z = -120;
    let radius = randBetween(20, 40);

    spheres.push({
      sphere: [x, y, z, radius],
      generation: 0
    });
  }

  return spheres;
};

// Perform sphere inversion
let invertSphere = (sphere: Sphere, inversionCenter: Number3, inversionRadius: number): Sphere | null => {
  let [x, y, z, r] = sphere;
  let [cx, cy, cz] = inversionCenter;

  // Vector from inversion center to sphere center
  let dx = x - cx;
  let dy = y - cy;
  let dz = z - cz;
  let distance = Math.sqrt(dx * dx + dy * dy + dz * dz);

  // Skip if sphere intersects or is too close to inversion center
  if (distance <= r || distance < 5.0) return null;

  let k = inversionRadius * inversionRadius;

  // Correct sphere inversion formulas
  let d1 = distance - r;  // distance to near surface
  let d2 = distance + r;  // distance to far surface

  let newD1 = k / d2;     // inverted near distance
  let newD2 = k / d1;     // inverted far distance

  let newDistance = (newD1 + newD2) / 2;
  let newRadius = Math.abs(newD2 - newD1) / 2;

  // Calculate new center position
  let scale = newDistance / distance;
  let newX = cx + dx * scale;
  let newY = cy + dy * scale;
  let newZ = cz + dz * scale;

  // More lenient filtering
  if (newRadius > 300 || newRadius < 1) return null;
  if (newDistance < 10) return null; // Too close to inversion center

  return [newX, newY, newZ, newRadius];
};

// Generate inverted spheres iteratively
let generateInvertedSpheres = (): SphereWithGen[] => {
  let initialSpheres = generateInitialSpheres();
  let allSpheres = [...initialSpheres];

  let maxSpheres = 100;
  let iterations = 0;
  let maxIterations = 8;  // More iterations for deeper recursion

  console.log(`Starting with ${allSpheres.length} initial spheres`);

  while (allSpheres.length < maxSpheres && iterations < maxIterations) {
    let startCount = allSpheres.length;
    let currentSpheres = [...allSpheres];
    let newGeneration = iterations + 1;

    // For each existing sphere, try to invert other spheres using it as inversion center
    for (let i = 0; i < currentSpheres.length && allSpheres.length < maxSpheres; i++) {
      let inversionSphere = currentSpheres[i].sphere;
      let inversionCenter: Number3 = [inversionSphere[0], inversionSphere[1], inversionSphere[2]];
      let inversionRadius = inversionSphere[3] * 2.0;  // Larger inversion radius

      for (let j = 0; j < currentSpheres.length && allSpheres.length < maxSpheres; j++) {
        if (i === j) continue;

        let targetSphere = currentSpheres[j].sphere;
        let inverted = invertSphere(targetSphere, inversionCenter, inversionRadius);

        if (inverted) {
          // Check if this sphere already exists (approximately)
          let isDuplicate = false;
          for (let existing of allSpheres) {
            let dx = inverted[0] - existing.sphere[0];
            let dy = inverted[1] - existing.sphere[1];
            let dz = inverted[2] - existing.sphere[2];
            let dr = Math.abs(inverted[3] - existing.sphere[3]);
            let distance = Math.sqrt(dx * dx + dy * dy + dz * dz);

            // More lenient duplicate detection
            if (distance < 5 && dr < 2) {
              isDuplicate = true;
              break;
            }
          }

          if (!isDuplicate) {
            allSpheres.push({
              sphere: inverted,
              generation: newGeneration
            });
          }
        }
      }
    }

    iterations++;
    console.log(`Iteration ${iterations}: generated ${allSpheres.length - startCount} new spheres (total: ${allSpheres.length})`);

    // If no new spheres were generated, break early
    if (allSpheres.length === startCount) {
      console.log('No new spheres generated, stopping iterations');
      break;
    }
  }

  console.log(`Final result: ${allSpheres.length} spheres after ${iterations} iterations`);
  return allSpheres.slice(0, maxSpheres);
};

let createSphereCell = (sphereWithGen: SphereWithGen): BaseCellParams => {
  let sphere = sphereWithGen.sphere;
  let position: Number4 = [sphere[0], sphere[1], sphere[2], sphere[3]];
  let params: Number4 = [sphereWithGen.generation, sphere[3] / 30, 0, 0]; // Pass generation as p1

  return { position, params };
};

export const inversionCirclesConfigs: SolubleApp = {
  initPointsBuffer: () => {
    // 清理其他demo可能遗留的定时器
    try {
      if ((globalThis as any).stopDotsClockTimer) {
        (globalThis as any).stopDotsClockTimer();
      }
    } catch (e) {
      // 忽略清理错误
    }

    let spheres = generateInvertedSpheres();
    console.log(`Generated ${spheres.length} spheres through inversion`);

    createGlobalPointsBuffer(spheres.length, (idx) => createSphereCell(spheres[idx]));
  },
  useCompute: false,
  renderShader: inversionCircles,
  // onButtonEvent: (events: ButtonEvents) => { }, // Camera controlled by framework
  getParams: () => {
    return [performance.now() - store.startedAt];
  },
  getTextures: (obj) => {
    return [];
  },
};