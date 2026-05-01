#import soluble::perspective

// Pulse-gravity spheres: 4 spheres on slow elliptical orbits.
// Gravity coefficient oscillates as sin(time) × 2.0:
//   sin = 0.5 → current strength, sin = 1.0 → 2× stronger, sin < 0 → repulsion.
// Phase 1: straight ray finds first sphere hit and reflects.
// Phase 2: reflected ray bends under pulsing gravity (semi-implicit Euler).

struct Params {
  time: f32,
  dt: f32,
  max_reflections: f32,
}

@group(0) @binding(1) var<uniform> params: Params;

struct BaseCell {
  a: vec4<f32>,
  b: vec4<f32>,
  c: vec4<f32>,
};

@group(1) @binding(0) var<storage, read> base_points: array<BaseCell>;

@compute @workgroup_size(8, 8, 1)
fn compute_main(@builtin(global_invocation_id) global_id: vec3u) {}

struct VertexOut {
  @builtin(position) position: vec4<f32>,
  @location(1) uv: vec2<f32>,
};

@vertex
fn vertex_main(@location(0) position: vec2<f32>) -> VertexOut {
  var output: VertexOut;
  output.position = vec4(position, 0.0, 1.0);
  output.uv = vec2<f32>(position.x, position.y);
  return output;
}

struct Sphere {
  center: vec3f,
  radius: f32,
  color:  vec3f,
  gm:     f32,
}

fn ellipse_pos(a: f32, b: f32, omega: f32, phase: f32, t: f32, u: vec3f, v: vec3f) -> vec3f {
  let angle = omega * t + phase;
  return a * cos(angle) * u + b * sin(angle) * v;
}

// Slower orbits: ms uses 0.02 instead of 0.05
fn make_spheres(t: f32) -> array<Sphere, 4> {
  let ms = t * 0.02;
  let c0 = ellipse_pos(220., 140., 0.0013, 0.00, ms,
      vec3f(1., 0., 0.), vec3f(0., 1., 0.));
  let c1 = ellipse_pos(190., 160., 0.0009, 1.57, ms,
      vec3f(1., 0., 0.), vec3f(0., 0., 1.));
  let c2 = ellipse_pos(200., 120., 0.0007, 3.14, ms,
      normalize(vec3f(0., 1., 1.)), normalize(vec3f(1., 0., 0.)));
  let c3 = ellipse_pos(170., 150., 0.0011, 4.71, ms,
      normalize(vec3f(1., 0., 1.)), normalize(vec3f(0., 1., 0.)));

  return array<Sphere, 4>(
    Sphere(c0, 90., vec3f(1.0, 0.45, 0.10), 190.),
    Sphere(c1, 80., vec3f(0.15, 0.50, 1.00), 170.),
    Sphere(c2, 85., vec3f(0.20, 0.95, 0.35), 180.),
    Sphere(c3, 75., vec3f(0.90, 0.20, 0.80), 160.),
  );
}

fn ray_sphere_t(origin: vec3f, dir: vec3f, center: vec3f, radius: f32) -> f32 {
  let oc = origin - center;
  let b  = dot(oc, dir);
  let c  = dot(oc, oc) - radius * radius;
  let disc = b * b - c;
  if disc < 0.0 { return -1.0; }
  let sq = sqrt(disc);
  var t  = -b - sq;
  if t > 0.001 { return t; }
  t = -b + sq;
  if t > 0.001 { return t; }
  return -1.0;
}

// Gravity from all 4 spheres, scaled by gm_scale (can be negative = repulsion).
fn gravity_at(p: vec3f, spheres: array<Sphere, 4>, gm_scale: f32) -> vec3f {
  var a = vec3f(0.);
  for (var i = 0u; i < 4u; i++) {
    let diff = spheres[i].center - p;
    let r2 = max(dot(diff, diff), spheres[i].radius * spheres[i].radius * 0.16);
    a += normalize(diff) * spheres[i].gm * gm_scale / r2;
  }
  return a;
}

const GRAV_STEPS: u32 = 180u;
const STEP:       f32 = 4.0;
const GLOW_CUTOFF: f32 = 600.0;

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  let coord    = vx_out.uv * uniforms.screen_wh;
  let p        = coord * 0.0005 / uniforms.scale;
  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  var color   = vec4f(0.02, 0.01, 0.09, 1.0);
  let spheres = make_spheres(params.time);

  // Pulsing gravity scale: sin(t * 0.0004) * 2.0
  // At sin = 0.5 → scale = 1.0 (current strength)
  // At sin = 1.0 → scale = 2.0 (double), sin = -1.0 → scale = -2.0 (repulsion)
  let gm_scale = sin(params.time * 0.0004) * 2.0;

  // ── Phase 1: straight ray cast, find nearest sphere ──────────────────────
  var hit_t   = -1.0;
  var hit_idx = 0u;
  for (var i = 0u; i < 4u; i++) {
    let t = ray_sphere_t(uniforms.viewer_position, ray_unit,
                         spheres[i].center, spheres[i].radius);
    if t > 0.0 && (hit_t < 0.0 || t < hit_t) {
      hit_t   = t;
      hit_idx = i;
    }
  }
  if hit_t < 0.0 { return color; }

  let sp0     = spheres[hit_idx];
  let hit_pt  = uniforms.viewer_position + ray_unit * hit_t;
  let normal0 = normalize(hit_pt - sp0.center);

  color += vec4f(sp0.color * 0.30, 0.0);

  // ── Phase 2: gravity-bent ray march ──────────────────────────────────────
  var pos = hit_pt + normal0 * 1.2;
  var vel = reflect(ray_unit, normal0);

  for (var step = 0u; step < GRAV_STEPS; step++) {
    let accel = gravity_at(pos, spheres, gm_scale);
    vel = normalize(vel + accel * STEP);
    pos = pos + vel * STEP;

    let fade = 1.0 / (1.0 + f32(step) * 0.018);

    for (var i = 0u; i < 4u; i++) {
      let sp    = spheres[i];
      let diff  = pos - sp.center;
      let dist2 = dot(diff, diff);
      if dist2 > GLOW_CUTOFF * GLOW_CUTOFF { continue; }

      let dist = sqrt(dist2);
      if dist < sp.radius {
        let n = diff / dist;
        vel = reflect(vel, n);
        pos = sp.center + n * (sp.radius + 1.2);
        color += vec4f(sp.color * 0.20 * fade, 0.0);
      } else {
        let excess = dist - sp.radius;
        let glow = (sp.radius * sp.radius) / (excess * excess + sp.radius * 12.0);
        color   += vec4f(sp.color * glow * 0.00008 * fade, 0.0);
      }
    }
  }

  return clamp(color, vec4f(0.0), vec4f(1.0));
}
