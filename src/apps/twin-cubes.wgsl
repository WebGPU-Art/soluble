#import soluble::perspective

// Twin Cubes: two independently rotating cubes both at origin.
// They alternate size: cube A via sin, cube B via cos.
// Ray bounces between the two cubes' surfaces (straight reflections, no gravity).
// If at any step the ray passes within EDGE_THRESH of a cube edge → white pixel.

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
  var out: VertexOut;
  out.position = vec4(position, 0.0, 1.0);
  out.uv = vec2(position.x, position.y);
  return out;
}

// ── Geometry helpers ─────────────────────────────────────────────────────────

fn sdf_box(p: vec3f, hs: f32) -> f32 {
  let q = abs(p) - hs;
  return length(max(q, vec3f(0.))) + min(max(q.x, max(q.y, q.z)), 0.0);
}

// Face normal of axis-aligned cube at origin (always outward)
fn box_normal(p: vec3f, hs: f32) -> vec3f {
  let q = abs(p) - hs;
  if q.x >= q.y && q.x >= q.z { return vec3f(sign(p.x), 0., 0.); }
  if q.y >= q.z { return vec3f(0., sign(p.y), 0.); }
  return vec3f(0., 0., sign(p.z));
}

// Minimum distance from p to the nearest of the 12 cube edges (cube at origin)
// For edges along axis X: they sit at y=±hs, z=±hs, and span x ∈ [-hs,hs].
// By symmetry (q=abs(p)), nearest X-edge: d = sqrt(clamp_x² + ey² + ez²)
fn dist_to_cube_edges(p: vec3f, hs: f32) -> f32 {
  let q  = abs(p);
  let ex = q.x - hs;
  let ey = q.y - hs;
  let ez = q.z - hs;
  let dx = max(0., ex);
  let dy = max(0., ey);
  let dz = max(0., ez);
  // X-edges: clamped in x, measure to (±hs, ±hs) corners in yz
  let d_xe = sqrt(dx*dx + ey*ey + ez*ez);
  // Y-edges
  let d_ye = sqrt(ex*ex + dy*dy + ez*ez);
  // Z-edges
  let d_ze = sqrt(ex*ex + ey*ey + dz*dz);
  return min(d_xe, min(d_ye, d_ze));
}

fn rot_x(a: f32) -> mat3x3<f32> {
  let c = cos(a); let s = sin(a);
  return mat3x3<f32>(vec3f(1.,0.,0.), vec3f(0.,c,s), vec3f(0.,-s,c));
}
fn rot_y(a: f32) -> mat3x3<f32> {
  let c = cos(a); let s = sin(a);
  return mat3x3<f32>(vec3f(c,0.,-s), vec3f(0.,1.,0.), vec3f(s,0.,c));
}
fn rot_z(a: f32) -> mat3x3<f32> {
  let c = cos(a); let s = sin(a);
  return mat3x3<f32>(vec3f(c,s,0.), vec3f(-s,c,0.), vec3f(0.,0.,1.));
}

// ── March helpers ─────────────────────────────────────────────────────────────

// Simple hash for stochastic bounce drop
fn hash2(p: vec2f) -> f32 {
  var n = dot(p, vec2f(127.1, 311.7));
  n = fract(sin(n) * 43758.5453);
  return n;
}

struct Hit {
  pos:      vec3f,
  found:    bool,
  hit_cube: bool,
  edge:     bool,
}

const EDGE_THRESH: f32 = 0.9;

// March from pos_in along dir; two separate objects (union), min SDF stepping.
// hit_cube=true means hit cube A (axis-aligned), false means cube B (rotated).
fn march(pos_in: vec3f, dir: vec3f, ctr_a: vec3f, hs_a: f32, rot_b: mat3x3<f32>, ctr_b: vec3f, hs_b: f32, check_edges: bool) -> Hit {
  var pos = pos_in;
  var h: Hit;
  for (var i = 0u; i < 600u; i++) {
    let lp_a = pos - ctr_a;
    let lp_b = transpose(rot_b) * (pos - ctr_b);
    let da = sdf_box(lp_a, hs_a);
    let db = sdf_box(lp_b, hs_b);
    let d  = min(abs(da), abs(db));

    if check_edges {
      if da < 0.5 { if dist_to_cube_edges(lp_a, hs_a) < EDGE_THRESH { h.edge = true; } }
      if db < 0.5 { if dist_to_cube_edges(lp_b, hs_b) < EDGE_THRESH { h.edge = true; } }
    }

    if d < 0.25 {
      h.pos      = pos;
      h.found    = true;
      h.hit_cube = abs(da) < abs(db);
      return h;
    }
    pos += dir * max(d * 0.85, 0.4);
    if length(pos) > 4000.0 { break; }
  }
  return h;
}

// ── Constants ─────────────────────────────────────────────────────────────────

const CUBE_A_COLOR: vec3f = vec3f(1.0, 0.60, 0.12);  // warm gold
const CUBE_B_COLOR: vec3f = vec3f(0.25, 0.60, 1.0);  // cool blue

// ── Fragment ──────────────────────────────────────────────────────────────────

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {
  let coord    = vx_out.uv * uniforms.screen_wh;
  let p        = coord * 0.0005 / uniforms.scale;
  let ray_unit = normalize(p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward);

  // Alternating sizes: cube A via sin, cube B via cos — half speed
  let ms   = params.time * 0.0005;
  let hs_a = 90.0 * (0.55 + 0.45 * sin(ms));
  let hs_b = 70.0 * (0.55 + 0.45 * cos(ms));
  // Cube B rotates slowly and independently
  let rot_b = rot_z(ms * 0.4) * rot_y(ms * 0.7) * rot_x(ms * 0.3);

  // Cube A: orbit in XY plane, radius 36, slow speed
  let oa   = ms * 0.13;
  let ctr_a = vec3f(36.0 * cos(oa), 36.0 * sin(oa), 0.0);
  // Cube B: orbit in a tilted plane (XZ tilted 50° from XY), radius 36, different speed & phase
  let ob    = ms * 0.09 + 1.8;
  let ctr_b = vec3f(36.0 * cos(ob), 36.0 * sin(ob) * 0.64, 36.0 * sin(ob) * 0.77);

  var color     = vec3f(0.02, 0.01, 0.09);
  var edge_glow = vec3f(0.0);
  var pos       = uniforms.viewer_position;
  var vel       = ray_unit;

  // ── Determine starting condition ──────────────────────────────────────────
  let inside_a   = sdf_box(pos - ctr_a, hs_a) < 0.0;
  let inside_b   = sdf_box(transpose(rot_b) * (pos - ctr_b), hs_b) < 0.0;
  let inside_any = inside_a || inside_b;

  if !inside_any {
    let entry = march(pos, vel, ctr_a, hs_a, rot_b, ctr_b, hs_b, false);
    if !entry.found {
      return vec4f(color / (1.0 + color), 1.0);
    }
    pos = entry.pos + vel * 12.0;
  }
  // If observer is inside (any or both objects): start bouncing immediately.

  // ── Internal bounce reflections ───────────────────────────────────────────
  for (var bounce = 0u; bounce < 16u; bounce++) {
    let fade = 1.0 - f32(bounce) * 0.08;

    var h = march(pos, vel, ctr_a, hs_a, rot_b, ctr_b, hs_b, true);
    // Edge glow: brighter on early bounces, dimmer later
    if h.edge {
      let edge_brightness = max(0.8, 4.0 - f32(bounce) * 0.04);
      edge_glow += vec3f(edge_brightness);
    }
    if !h.found { break; }

    pos = h.pos;
    let hit_cube = h.hit_cube;
    color += select(CUBE_B_COLOR, CUBE_A_COLOR, hit_cube) * max(fade, 0.2) * 0.22;

    // Normal opposing incoming ray (works for inner and outer face)
    var raw_n: vec3f;
    if hit_cube {
      raw_n = box_normal(pos - ctr_a, hs_a);
    } else {
      let lp_b = transpose(rot_b) * (pos - ctr_b);
      raw_n = rot_b * box_normal(lp_b, hs_b);
    }
    let n = select(raw_n, -raw_n, dot(vel, raw_n) > 0.0);

    vel = reflect(vel, n);
    pos = pos + n * 6.0;
  }

  // Edge glow blended on top; capped so early bounces are bright, late are dim
  let total = color + clamp(edge_glow, vec3f(0.0), vec3f(6.0));
  return vec4f(total / (1.0 + total), 1.0);
}
