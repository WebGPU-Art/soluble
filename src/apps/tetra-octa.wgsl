#import soluble::perspective

// Tetra-Octa: regular tetrahedron + regular octahedron on independent orbits.
// They alternate size: tetrahedron via sin, octahedron via cos.
// Ray bounces between surfaces; near any edge → white glow.

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

// ── Rotation helpers ─────────────────────────────────────────────────────────

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

// ── Regular Tetrahedron ───────────────────────────────────────────────────────
// 4 half-spaces: the 4 alternating sign combinations that form a tetrahedron.
// r is the "span" parameter; circumradius ≈ r * sqrt(3) / 2.

fn sdf_tetra(p: vec3f, r: f32) -> f32 {
  return (max(max(-p.x-p.y-p.z, p.x+p.y-p.z),
              max(-p.x+p.y+p.z,  p.x-p.y+p.z)) - r) * 0.57735027;
}

fn tetra_normal(p: vec3f) -> vec3f {
  let a = -p.x - p.y - p.z;
  let b =  p.x + p.y - p.z;
  let c = -p.x + p.y + p.z;
  let d =  p.x - p.y + p.z;
  if a >= b && a >= c && a >= d { return normalize(vec3f(-1., -1., -1.)); }
  if b >= c && b >= d           { return normalize(vec3f( 1.,  1., -1.)); }
  if c >= d                     { return normalize(vec3f(-1.,  1.,  1.)); }
  return normalize(vec3f(1., -1., 1.));
}

// Edge proximity: gap between highest and second-highest plane values.
// Small value means near an edge (two planes nearly tied).
fn tetra_edge_dist(p: vec3f) -> f32 {
  let a = -p.x - p.y - p.z;
  let b =  p.x + p.y - p.z;
  let c = -p.x + p.y + p.z;
  let d =  p.x - p.y + p.z;
  let m1 = max(max(a, b), max(c, d));
  let m2 = max(max(min(a, b), min(c, d)), min(max(a, b), max(c, d)));
  return (m1 - m2) * 0.57735027;
}

// ── Regular Octahedron ────────────────────────────────────────────────────────

fn sdf_octa(p: vec3f, s: f32) -> f32 {
  let q = abs(p);
  return (q.x + q.y + q.z - s) * 0.57735027;
}

fn octa_normal(p: vec3f) -> vec3f {
  return normalize(sign(p) + vec3f(1e-6));
}

// Edge proximity: minimum pairwise difference of |components|.
fn octa_edge_dist(p: vec3f) -> f32 {
  let q = abs(p);
  return min(abs(q.x - q.y), min(abs(q.y - q.z), abs(q.x - q.z)));
}

// ── Hash ──────────────────────────────────────────────────────────────────────

fn hash2(p: vec2f) -> f32 {
  let n = dot(p, vec2f(127.1, 311.7));
  return fract(sin(n) * 43758.5453);
}

// ── March ─────────────────────────────────────────────────────────────────────

struct Hit {
  pos:       vec3f,
  found:     bool,
  hit_tetra: bool,
  edge:      bool,
}

const EDGE_REL_THRESH: f32 = 0.011;  // thin lines: ~1/3 of previous

fn march(pos_in: vec3f, dir: vec3f,
         rot_a: mat3x3<f32>, ctr_a: vec3f, r_a: f32,
         rot_b: mat3x3<f32>, ctr_b: vec3f, s_b: f32,
         check_edges: bool) -> Hit {
  var pos = pos_in;
  var h: Hit;
  for (var i = 0u; i < 600u; i++) {
    let lp_a = transpose(rot_a) * (pos - ctr_a);
    let lp_b = transpose(rot_b) * (pos - ctr_b);
    let da = sdf_tetra(lp_a, r_a);
    let db = sdf_octa(lp_b, s_b);
    let d  = min(abs(da), abs(db));

    if d < 0.25 {
      h.pos       = pos;
      h.found     = true;
      h.hit_tetra = abs(da) < abs(db);
      // Edge check only at the hit surface — avoids false positives in interior
      if check_edges {
        if h.hit_tetra {
          h.edge = tetra_edge_dist(lp_a) < r_a * EDGE_REL_THRESH;
        } else {
          h.edge = octa_edge_dist(lp_b)  < s_b * EDGE_REL_THRESH;
        }
      }
      return h;
    }
    pos += dir * max(d * 0.85, 0.4);
    if length(pos) > 4000.0 { break; }
  }
  return h;
}

// ── Constants ─────────────────────────────────────────────────────────────────

const TETRA_COLOR: vec3f = vec3f(1.0, 0.40, 0.15);  // deep orange
const OCTA_COLOR:  vec3f = vec3f(0.10, 0.85, 0.75);  // cyan teal

// ── Fragment ──────────────────────────────────────────────────────────────────

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {
  let coord    = vx_out.uv * uniforms.screen_wh;
  let p        = coord * 0.0005 / uniforms.scale;
  let ray_unit = normalize(p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward);

  let ms = params.time * 0.0005;

  // Tetrahedron A: pulses, XY orbit, slow self-rotation
  let r_a   = 120.0 * (0.55 + 0.45 * sin(ms));
  let oa    = ms * 0.11;
  let ctr_a = vec3f(70.0 * cos(oa), 70.0 * sin(oa), 0.0);
  let rot_a = rot_y(ms * 0.30) * rot_z(ms * 0.20);

  // Octahedron B: pulses (offset phase), tilted orbit, different speed
  let s_b   = 100.0 * (0.55 + 0.45 * cos(ms));
  let ob    = ms * 0.08 + 2.1;
  let ctr_b = vec3f(70.0 * cos(ob), 70.0 * sin(ob) * 0.60, 70.0 * sin(ob) * 0.80);
  let rot_b = rot_z(ms * 0.15) * rot_x(ms * 0.25);

  var color     = vec3f(0.02, 0.01, 0.09);
  var edge_glow = vec3f(0.0);
  var pos       = uniforms.viewer_position;
  var vel       = ray_unit;

  let lp_a0    = transpose(rot_a) * (pos - ctr_a);
  let lp_b0    = transpose(rot_b) * (pos - ctr_b);
  let inside_a = sdf_tetra(lp_a0, r_a) < 0.0;
  let inside_b = sdf_octa(lp_b0, s_b)  < 0.0;

  if !(inside_a || inside_b) {
    let entry = march(pos, vel, rot_a, ctr_a, r_a, rot_b, ctr_b, s_b, false);
    if !entry.found { return vec4f(color / (1.0 + color), 1.0); }
    pos = entry.pos + vel * 4.0;
  }

  for (var bounce = 0u; bounce < 16u; bounce++) {
    let fade = 1.0 - f32(bounce) * 0.08;
    let h    = march(pos, vel, rot_a, ctr_a, r_a, rot_b, ctr_b, s_b, true);
    if h.edge {
      edge_glow += vec3f(max(0.8, 4.0 - f32(bounce) * 0.04));
    }
    if !h.found { break; }

    pos = h.pos;
    color += select(OCTA_COLOR, TETRA_COLOR, h.hit_tetra) * max(fade, 0.2) * 0.22;

    var raw_n: vec3f;
    if h.hit_tetra {
      let lp = transpose(rot_a) * (pos - ctr_a);
      raw_n = rot_a * tetra_normal(lp);
    } else {
      let lp = transpose(rot_b) * (pos - ctr_b);
      raw_n = rot_b * octa_normal(lp);
    }
    let n = select(raw_n, -raw_n, dot(vel, raw_n) > 0.0);
    vel = reflect(vel, n);
    pos = pos + n * 2.5;
  }

  let total = color + clamp(edge_glow, vec3f(0.0), vec3f(6.0));
  return vec4f(total / (1.0 + total), 1.0);
}
