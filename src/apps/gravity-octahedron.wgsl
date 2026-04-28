#import soluble::perspective

// 3 rotating octahedra on elliptical orbits.
// After the first straight-ray octahedron hit, the reflected ray bends under
// gravity of all 3 centers (semi-implicit Euler, 500 steps).
// Phase 1 uses SDF sphere-march for accurate hit detection.

struct Params { time: f32, dt: f32, max_reflections: f32 }
@group(0) @binding(1) var<uniform> params: Params;

struct BaseCell { a: vec4<f32>, b: vec4<f32>, c: vec4<f32> }
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

struct Oct {
  center: vec3f,
  s: f32,        // vertex-to-center distance (|x|+|y|+|z| <= s in local frame)
  color: vec3f,
  gm: f32,
  ax: vec3f,
  ay: vec3f,
  az: vec3f,
}

fn ellipse_pos(a: f32, b: f32, omega: f32, phase: f32, t: f32, u: vec3f, v: vec3f) -> vec3f {
  let angle = omega * t + phase;
  return a * cos(angle) * u + b * sin(angle) * v;
}

fn make_frame(spin: f32) -> mat3x3<f32> {
  let ax = normalize(vec3f(cos(spin), sin(spin * 0.7) * 0.35, sin(spin)));
  let helper = normalize(vec3f(sin(spin * 1.1) * 0.25, 1.0, cos(spin * 0.9) * 0.2));
  let az = normalize(cross(ax, helper));
  let ay = cross(az, ax);
  return mat3x3<f32>(ax, ay, az);
}

fn make_octs(t: f32) -> array<Oct, 3> {
  let ms = t * 0.05;
  let c0 = ellipse_pos(260., 160., 0.0013, 0.00, ms, vec3f(1., 0., 0.), vec3f(0., 1., 0.));
  let c1 = ellipse_pos(220., 180., 0.0009, 1.57, ms, vec3f(1., 0., 0.), vec3f(0., 0., 1.));
  let c2 = ellipse_pos(240., 140., 0.0007, 3.14, ms, normalize(vec3f(0., 1., 1.)), normalize(vec3f(1., 0., 0.)));

  let f0 = make_frame(ms * 0.0021);
  let f1 = make_frame(ms * 0.0017 + 1.3);
  let f2 = make_frame(ms * 0.0025 + 2.6);

  return array<Oct, 3>(
    Oct(c0, 100., vec3f(1.0, 0.28, 0.04), 280., f0[0], f0[1], f0[2]),
    Oct(c1,  90., vec3f(0.08, 0.38, 1.00), 250., f1[0], f1[1], f1[2]),
    Oct(c2,  95., vec3f(0.08, 1.00, 0.20), 260., f2[0], f2[1], f2[2]),
  );
}

// Exact SDF for octahedron |x|+|y|+|z| <= s (oriented)
// 1/sqrt(3) ≈ 0.57735027
fn sdf_oct(p: vec3f, oct: Oct) -> f32 {
  let d = p - oct.center;
  let lp = vec3f(dot(d, oct.ax), dot(d, oct.ay), dot(d, oct.az));
  let q = abs(lp);
  return (q.x + q.y + q.z - oct.s) * 0.57735027;
}

// Octahedron outward surface normal — power-weighted smooth blend near edges
fn oct_normal(p: vec3f, oct: Oct) -> vec3f {
  let d = p - oct.center;
  let lp = vec3f(dot(d, oct.ax), dot(d, oct.ay), dot(d, oct.az));
  let q = abs(lp);
  let s = oct.s * 0.57735027;  // face-to-center distance
  // Weight each axis by its distance from the plane; higher power → sharper corners
  let k = 4.0;
  let wx = pow(clamp(q.x / s, 0.0, 1.0), k);
  let wy = pow(clamp(q.y / s, 0.0, 1.0), k);
  let wz = pow(clamp(q.z / s, 0.0, 1.0), k);
  let n_local = normalize(vec3f(sign(lp.x + 1e-5) * wx, sign(lp.y + 1e-5) * wy, sign(lp.z + 1e-5) * wz));
  return normalize(n_local.x * oct.ax + n_local.y * oct.ay + n_local.z * oct.az);
}

// Gravity from the centroid of all octahedra — single pull point, keeps it simple
fn gravity_at(p: vec3f, octs: array<Oct, 3>) -> vec3f {
  let cm = (octs[0].center + octs[1].center + octs[2].center) / 3.0;
  let diff = cm - p;
  let r2 = max(dot(diff, diff), 2500.0);
  return normalize(diff) * 260.0 / r2;
}

const GRAV_STEPS: u32 = 500u;
const STEP: f32 = 1.5;
const GLOW_CUTOFF: f32 = 700.0;

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {
  let coord = vx_out.uv * uniforms.screen_wh;
  let p = coord * 0.0005 / uniforms.scale;
  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  var color = vec4f(0.02, 0.01, 0.09, 1.0);
  let octs = make_octs(params.time);

  // ── Phase 1: SDF sphere-march for first octahedron hit ───────────────────
  var march_t = 0.0;
  var hit_t = -1.0;
  var hit_idx = 0u;
  for (var step = 0u; step < 200u; step++) {
    let p3 = uniforms.viewer_position + ray_unit * march_t;
    var min_d = 1e9;
    var min_i = 0u;
    for (var i = 0u; i < 3u; i++) {
      let d = sdf_oct(p3, octs[i]);
      if d < min_d { min_d = d; min_i = i; }
    }
    if min_d < 0.8 { hit_t = march_t; hit_idx = min_i; break; }
    march_t += max(min_d * 0.8, 3.0);
    if march_t > 2200.0 { break; }
  }
  if hit_t < 0.0 { return color; }

  let oct0 = octs[hit_idx];
  let hit_pt = uniforms.viewer_position + ray_unit * hit_t;
  let normal0 = oct_normal(hit_pt, oct0);
  color += vec4f(oct0.color * 0.18, 0.0);

  // ── Phase 2: gravity-bent ray march ──────────────────────────────────────
  var pos = hit_pt + normal0 * 1.5;
  var vel = reflect(ray_unit, normal0);

  for (var step = 0u; step < GRAV_STEPS; step++) {
    let accel = gravity_at(pos, octs);
    vel = normalize(vel + accel * STEP);
    pos = pos + vel * STEP;

    // Slower fade — bent path stays visible longer
    let fade = exp(-f32(step) * STEP * 0.00018);

    for (var i = 0u; i < 3u; i++) {
      let diff = pos - octs[i].center;
      if dot(diff, diff) > GLOW_CUTOFF * GLOW_CUTOFF { continue; }

      let d = sdf_oct(pos, octs[i]);
      if d < 0.0 {
        let n = oct_normal(pos, octs[i]);
        vel = reflect(vel, n);
        pos = pos + n * (-d + 1.5);
        color += vec4f(octs[i].color * 0.18 * fade, 0.0);
      } else {
        // Dual-layer glow: sharp neon edge + wide soft halo
        let norm_d = d / octs[i].s;
        let sharp = exp(-norm_d * norm_d * 7.0) * 0.0014;
        let halo  = exp(-norm_d * norm_d * 0.45) * 0.000022;
        color += vec4f(octs[i].color * (sharp + halo) * fade, 0.0);
      }
    }
  }

  // Reinhard per-channel tone-map — no hard white clipping
  let c = color.rgb;
  return vec4f(c / (1.0 + c), 1.0);
}
