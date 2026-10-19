import { initializeContext, renderSolubleTree } from "./render.mjs";
import { callFramePaint, clearPointsBuffer, waitForRenderIdle, resetCanvasHeight } from "./paint.mjs";
import { loadGamepadControl } from "./control.mjs";
import { atomDevice, atomSolubleTree, atomSharedTextures } from "./global.mjs";
import { loadImageAsTexture, loadImageFromInputEl } from "./utils.mjs";
import type { SolubleApp } from "./primes.mjs";
import { cubicFireConfigs } from "./apps/cubic-fire.mjs";
import { quaternionFractalConfigs } from "./apps/quaternion-fractal.mjs";
import { complexFractalConfigs } from "./apps/complex-fractal.mjs";
import { newtonFractalConfigs } from "./apps/newton.mjs";
import { newtonCoshFractalConfigs } from "./apps/newton-cosh.mjs";
import { spaceFractalConfigs } from "./apps/space-fractal.mjs";
import { sphereFractalConfigs } from "./apps/sphere-fractal.mjs";
import { slowFractalConfigs } from "./apps/slow-fractal.mjs";
import { apollonianTwistConfigs } from "./apps/apollonian-twist.mjs";
import { apollonianMobiusConfigs } from "./apps/apollonian-mobius.mjs";
import { apollonianHelixConfigs } from "./apps/apollonian-helix.mjs";
import { apollonianMobiusHelixConfigs } from "./apps/apollonian-mobius-helix.mjs";
import { orbitsConfigs } from "./apps/orbits.mjs";
import { kaleidoscopeConfigs } from "./apps/kaleidoscope.mjs";
import { kaleidoscopeMirrorConfigs } from "./apps/kaleidoscope-mirror.mjs";
import { imageConfigs } from "./apps/image.mjs";
import * as stars from "./apps/stars.mjs";
import * as rings from "./apps/rings.mjs";
import * as circles from "./apps/circles.mjs";
import { clockingConfigs } from "./apps/clocking.mjs";
import { rippleConfigs } from "./apps/ripple.mjs";
import { surroundMirrorConfigs } from "./apps/surround-mirror.mjs";
import { parallelMirrorConfigs } from "./apps/parallel-mirror.mjs";
import { sphereMirrorConfigs } from "./apps/sphere-mirror.mjs";
import { packingSphereMirrorConfigs } from "./apps/packing-sphere-mirror.mjs";
import { hollowMirrorConfigs } from "./apps/hollow-mirror.mjs";
import { boxMirrorConfigs } from "./apps/box-mirror.mjs";
import { pyramidMirrorConfigs } from "./apps/pyramid-mirror.mjs";
import { tetrahedronMirrorConfigs } from "./apps/tetrahedron-mirror.mjs";
import { octahedronMirrorConfigs } from "./apps/octahedron-mirror.mjs";
import { truncatedOctahedronMirrorConfigs } from "./apps/truncated-octahedron-mirror.mjs";
import { cuboctahedronMirrorConfigs } from "./apps/cuboctahedron-mirror.mjs";
import { prismMirrorConfigs } from "./apps/prism-mirror.mjs";
import { hexPrismMirrorConfigs } from "./apps/hex-prism-mirror.mjs";
import { icosahedronMirrorConfigs } from "./apps/icosahedron-mirror.mjs";
import { wedgeMirrorConfigs } from "./apps/wedge-mirror.mjs";
import { rhombohedronMirrorConfigs } from "./apps/rhombohedron-mirror.mjs";
import { rhombicMirrorConfigs } from "./apps/rhombic-mirror.mjs";
import { rhombicDodecahedronDiagonalsMirrorConfigs } from "./apps/rhombic-dodecahedron-diagonals-mirror.mjs";
import { tetrahedronParabolaMirrorConfigs } from "./apps/tetrahedron-parabola-mirror.mjs";
import { tetrahedronArcMirrorConfigs } from "./apps/tetrahedron-arc-mirror.mjs";
import { cubeParabolaMirrorConfigs } from "./apps/cube-parabola-mirror.mjs";
import { octahedronParabolaMirrorConfigs } from "./apps/octahedron-parabola-mirror.mjs";
import { rhombicDodecahedronParabolaMirrorConfigs } from "./apps/rhombic-dodecahedron-parabola-mirror.mjs";
import { rhombicDodecahedronRotatingMirrorConfigs } from "./apps/rhombic-dodecahedron-rotating-mirror.mjs";
import { rtMirrorConfigs } from "./apps/rt-mirror.mjs";
import { deltoidalIcositetrahedronMirrorConfigs } from "./apps/deltoidal-icositetrahedron-mirror.mjs";
import { dodecahedronMirrorConfigs } from "./apps/dodecahedron-mirror.mjs";
import { crystalRefractionConfigs } from "./apps/crystal-refraction.mjs";
import { orbitSpheresMirrorConfigs } from "./apps/orbit-spheres-mirror.mjs";
import { gravitySpheresMirrorConfigs } from "./apps/gravity-spheres.mjs";
import { pulseSpheresConfigs } from "./apps/pulse-spheres.mjs";
import { gravityCubesConfigs } from "./apps/gravity-cubes.mjs";
import { gravityOctahedraConfigs } from "./apps/gravity-octahedron.mjs";
import { twinPulseConfigs } from "./apps/twin-pulse.mjs";
import { twinCubesConfigs } from "./apps/twin-cubes.mjs";
import { tetraOctaConfigs } from "./apps/tetra-octa.mjs";
import { dotsClockConfigs } from "./apps/dots-clock.mjs";
import { inversionCirclesConfigs } from "./apps/inversion-circles.mjs";

const apps = new Map<string, SolubleApp>([
  ["cubic-fire", cubicFireConfigs],
  ["quaternion-fractal", quaternionFractalConfigs],
  ["complex-fractal", complexFractalConfigs],
  ["newton-fractal", newtonFractalConfigs],
  ["newton-cosh-fractal", newtonCoshFractalConfigs],
  ["space-fractal", spaceFractalConfigs],
  ["sphere-fractal", sphereFractalConfigs],
  ["slow-fractal", slowFractalConfigs],
  ["apollonian-twist", apollonianTwistConfigs],
  ["apollonian-mobius", apollonianMobiusConfigs],
  ["apollonian-helix", apollonianHelixConfigs],
  ["apollonian-mobius-helix", apollonianMobiusHelixConfigs],
  ["orbits", orbitsConfigs],
  ["stars", stars.configs],
  ["rings", rings.configs],
  ["circles", circles.configs],
  ["kaleidoscope", kaleidoscopeConfigs],
  ["kaleidoscope-mirror", kaleidoscopeMirrorConfigs],
  ["clocking", clockingConfigs],
  ["image", imageConfigs],
  ["ripple", rippleConfigs],
  ["surround-mirror", surroundMirrorConfigs],
  ["parallel-mirror", parallelMirrorConfigs],
  ["sphere-mirror", sphereMirrorConfigs],
  ["packing-sphere-mirror", packingSphereMirrorConfigs],
  ["orbit-spheres-mirror", orbitSpheresMirrorConfigs],
  ["gravity-spheres", gravitySpheresMirrorConfigs],
  ["pulse-spheres", pulseSpheresConfigs],
  ["gravity-cubes", gravityCubesConfigs],
  ["gravity-octahedron", gravityOctahedraConfigs],
  ["twin-pulse", twinPulseConfigs],
  ["twin-cubes", twinCubesConfigs],
  ["tetra-octa", tetraOctaConfigs],
  ["hollow-mirror", hollowMirrorConfigs],
  ["box-mirror", boxMirrorConfigs],
  ["pyramid-mirror", pyramidMirrorConfigs],
  ["tetrahedron-mirror", tetrahedronMirrorConfigs],
  ["octahedron-mirror", octahedronMirrorConfigs],
  ["truncated-octahedron-mirror", truncatedOctahedronMirrorConfigs],
  ["cuboctahedron-mirror", cuboctahedronMirrorConfigs],
  ["prism-mirror", prismMirrorConfigs],
  ["hex-prism-mirror", hexPrismMirrorConfigs],
  ["icosahedron-mirror", icosahedronMirrorConfigs],
  ["wedge-mirror", wedgeMirrorConfigs],
  ["rhombohedron-mirror", rhombohedronMirrorConfigs],
  ["rhombic-mirror", rhombicMirrorConfigs],
  ["rhombic-dodecahedron-diagonals-mirror", rhombicDodecahedronDiagonalsMirrorConfigs],
  ["tetrahedron-parabola-mirror", tetrahedronParabolaMirrorConfigs],
  ["tetrahedron-arc-mirror", tetrahedronArcMirrorConfigs],
  ["cube-parabola-mirror", cubeParabolaMirrorConfigs],
  ["octahedron-parabola-mirror", octahedronParabolaMirrorConfigs],
  ["rhombic-dodecahedron-parabola-mirror", rhombicDodecahedronParabolaMirrorConfigs],
  ["rhombic-dodecahedron-rotating-mirror", rhombicDodecahedronRotatingMirrorConfigs],
  ["rt-mirror", rtMirrorConfigs],
  ["deltoidal-icositetrahedron-mirror", deltoidalIcositetrahedronMirrorConfigs],
  ["dodecahedron-mirror", dodecahedronMirrorConfigs],
  ["crystal-refraction", crystalRefractionConfigs],
  ["inversion-circles", inversionCirclesConfigs],
  ["dots-clock", dotsClockConfigs],
]);

const textureSources: [string, string][] = [
  ["tiye", "https://cdn.tiye.me/logo/tiye.jpg"],
  ["candy", "https://cos-sh.tiye.me/cos-up/c7367e21405d602c5ef5a8c55c35d512/candy.jpeg"],
  ["bubbles", "https://cos-sh.tiye.me/cos-up/20b39957d952bd189e4253369db30335/pasted-2024-04-17T17:00:49.301Z.png"],
  ["rugs", "https://cos-sh.tiye.me/cos-up/ceec218462f81744323e22dd2d04e94b/pasted-2024-04-17T17:12:29.234Z.png"],
  ["stripes", "https://cos-sh.tiye.me/cos-up/d090a685f03af9d31988a2a92b3b8a19/stripes.jpg"],
  ["pigment", "https://cos-sh.tiye.me/cos-up/4a932a1d8eaf46b4d9d8ec07538e8ee1/pigment.jpg"],
  ["circles", "https://cos-sh.tiye.me/cos-up/80e5932494210d46c600b402a029f973/circles.jpg"],
  ["sparks", "https://cos-sh.tiye.me/cos-up/3fd6b05f2f9b9a1985224ac39e7b3aee/sparks.jpg"],
  ["yulan", "https://cos-sh.tiye.me/cos-up/309de8ad40b61cb865b32adedf1b2dc4/rhombic-mirror.png"],
];

let revision = 0;
let raf = 0;
let timeout = 0;
let interval = 40;
let initialized = false;
let imageSlot = 0;
let onError: (message: string) => void = message => console.error(message);

function reportError(error: unknown): void {
  onError(error instanceof Error ? error.message : String(error));
}

function stopLoop(): number {
  revision++;
  window.cancelAnimationFrame(raf);
  window.clearTimeout(timeout);
  return revision;
}

async function paintNext(current: number): Promise<void> {
  if (current !== revision) return;
  await callFramePaint();
  if (current !== revision) return;
  const scheduleFrame = () => {
    raf = window.requestAnimationFrame(() => {
      void paintNext(current).catch(error => {
        if (current === revision) {
          stopLoop();
          reportError(error);
        }
      });
    });
  };
  if (interval > 10) timeout = window.setTimeout(scheduleFrame, interval);
  else scheduleFrame();
}

function renderTab(id: string): void {
  let app = apps.get(id);
  if (!app) {
    console.warn("Unknown tab", id);
    app = cubicFireConfigs;
  }
  clearPointsBuffer();
  app.initPointsBuffer();
  renderSolubleTree(app);
}

async function loadTextures(transformURL: (url: string) => string): Promise<void> {
  const device = atomDevice.deref();
  const loaded = await Promise.all(textureSources.map(async ([key, url]) => {
    const texture = await loadImageAsTexture(device, transformURL(url));
    return [key, texture] as const;
  }));
  const shared = atomSharedTextures.deref();
  for (const [key, texture] of loaded) shared[key] = texture;
}

function resize(): void {
  const canvas = document.querySelector<HTMLCanvasElement>("canvas");
  if (!canvas) throw new Error("Soluble canvas is missing");
  resetCanvasHeight(canvas);
}

function resized(): void {
  resize();
  void callFramePaint().catch(reportError);
}

function keydown(event: KeyboardEvent): void {
  if (!(event.metaKey || event.ctrlKey) || event.key !== "b") return;
  void loadImageFromInputEl(atomDevice.deref()).then(texture => {
    atomSharedTextures.deref()[imageSlot] = texture;
    imageSlot = imageSlot < 8 ? imageSlot + 1 : 0;
  }).catch(reportError);
}

/** A synchronous host boundary; all promises/devices remain in TypeScript. */
function initialize(
  id: string,
  frameInterval: number,
  transformURL: (url: string) => string,
  onReady: () => void,
  failed: (message: string) => void,
): void {
  interval = frameInterval;
  onError = failed;
  const current = stopLoop();
  void (async () => {
    const context = await initializeContext();
    if (context === null) throw new Error("WebGPU context is unavailable");
    const textures = loadTextures(transformURL);
    if (id === "image" || id === "surround-mirror") {
      await textures;
      window.addEventListener("keydown", keydown);
    } else {
      void textures.catch(reportError);
    }
    if (current !== revision) return;
    initialized = true;
    renderTab(id);
    onReady();
    await paintNext(current);
    resize();
    window.addEventListener("resize", resized);
    loadGamepadControl(events => {
      atomSolubleTree.deref()?.onButtonEvent?.(events);
    });
  })().catch(reportError);
}

/** Wait for the old frame before rebuilding; a newer selection wins. */
function selectTab(id: string): void {
  if (!initialized) return;
  const current = stopLoop();
  void (async () => {
    await waitForRenderIdle();
    if (current !== revision) return;
    renderTab(id);
    await paintNext(current);
  })().catch(reportError);
}

function getUrlTab(): string {
  return new URLSearchParams(window.location.search).get("tab") ?? "";
}

if (import.meta.hot) {
  // Renderer source changes require a fresh GPU context; Calcit UI has its own HMR.
  import.meta.hot.accept(() => window.location.reload());
  import.meta.hot.dispose(() => {
    stopLoop();
    window.removeEventListener("resize", resized);
    window.removeEventListener("keydown", keydown);
  });
}

export default { initialize, selectTab, reload: selectTab, getUrlTab };
