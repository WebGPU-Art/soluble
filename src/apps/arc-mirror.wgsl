#import soluble::perspective
#import soluble::math
#import soluble::mirror

// Circular-arc ray-tracing shader.
//
// Complexity advantage over the parabola shader:
//   Parabola: 96-sample scan  × n_mirrors per bounce (O(96n))
//   Arc:      atan2 + acos + 2 triangle tests × n_mirrors per bounce (O(n))
//
// The arc-plane intersection is the equation  A·cos θ + B·sin θ = C,
// which has the closed-form solution  θ = φ ± arccos(C / sqrt(A²+B²)),
// where φ = atan2(B, A).  No sampling needed.

struct Params {
  time:            f32,  // auto-prepended by paint.mts
  dt:              f32,  // auto-prepended by paint.mts
  lifetime:        f32,  // getParams()[0]  — growing counter used for sin oscillation
  max_reflections: f32,  // [1]
  lr: f32, lg: f32, lb: f32,  // [2..4]  per-ray light colour
  br: f32, bg: f32, bb: f32,  // [5..7]  bounce tint
  arc_radius:      f32,  // [8]  base arc radius (larger = gentler curve)
  gx: f32, gy: f32, gz: f32,  // [9..11]  global bend / gravity direction
}

@group(0) @binding(1) var<uniform> params: Params;

struct BaseCell { a: vec4<f32>, b: vec4<f32>, c: vec4<f32> };

@group(1) @binding(0) var<storage, read> base_points:      array<BaseCell>;
@group(1) @binding(1) var<storage, read> secondary_points: array<BaseCell>;

@compute @workgroup_size(8, 8, 1)
fn compute_main(@builtin(global_invocation_id) global_id: vec3u) { /* noop placeholder */ }

struct VertexOut {
  @builtin(position) position: vec4<f32>,
  @location(1) uv: vec2<f32>,
};

@vertex
fn vertex_main(@location(0) position: vec2<f32>) -> VertexOut {
  var out: VertexOut;
  out.position = vec4(position, 0.0, 1.0);
  out.uv       = vec2(position.x, position.y);
  return out;
}

// ---------------------------------------------------------------------------
// Arc ray representation
// ---------------------------------------------------------------------------

// A ray that follows a circular arc:
//   p(θ) = center + R·(-perp·cos θ + dir·sin θ),  θ ∈ [0, MAX_ARC]
//   p(0) = center - R·perp = origin  ✓
//   dp/dθ(0) = R·dir  →  unit tangent is dir  ✓
//   arc-length from 0 to θ = R·θ
struct ArcRay {
  origin: vec3<f32>,
  dir:    vec3<f32>,  // unit tangent at θ=0
  perp:   vec3<f32>,  // unit vector perpendicular to dir, in the plane of curvature
  radius: f32,        // arc radius
}

fn arc_point(arc: ArcRay, theta: f32) -> vec3<f32> {
  let center = arc.origin + arc.radius * arc.perp;
  return center + arc.radius * (-arc.perp * cos(theta) + arc.dir * sin(theta));
}

fn arc_tangent(arc: ArcRay, theta: f32) -> vec3<f32> {
  return normalize(arc.perp * sin(theta) + arc.dir * cos(theta));
}

// Build an ArcRay from a world-space bend vector (e.g. oscillated gravity).
// When bend_vec ≈ 0 (near a sin zero-crossing) the arc smoothly degenerates
// to a straight ray (radius = 1e6).
fn make_arc_ray(origin: vec3<f32>, dir: vec3<f32>,
                bend_vec: vec3<f32>, base_radius: f32) -> ArcRay {
  let proj     = bend_vec - dot(bend_vec, dir) * dir;
  let proj_len = length(proj);
  if proj_len < 0.001 {
    // Bend direction is nearly collinear with ray; choose arbitrary perp.
    var arb = vec3<f32>(0.0, 1.0, 0.0);
    if abs(dir.y) > 0.9 { arb = vec3(1.0, 0.0, 0.0); }
    let perp = normalize(arb - dot(arb, dir) * dir);
    return ArcRay(origin, dir, perp, 1e6);  // essentially straight
  }
  return ArcRay(origin, dir, proj / proj_len, base_radius);
}

// ---------------------------------------------------------------------------
// Arc–mirror intersection (O(1) per mirror — the key advantage over parabola)
// ---------------------------------------------------------------------------

struct ArcHit { hit: bool, theta: f32, point: vec3<f32>, next_dir: vec3<f32> }

fn arc_hit_none() -> ArcHit { return ArcHit(false, 0.0, vec3(0.0), vec3(0.0)); }

// Maximum arc angle per segment: half-circle.  Prevents the ray from wrapping
// all the way around inside the polyhedron; in practice θ is << π for any
// reasonable radius / polyhedron size combination.
const MAX_ARC: f32 = 3.14159265;

fn try_arc_reflect(arc: ArcRay, mirror: MirrorTriangle) -> ArcHit {
  var n   = normalize(cross(mirror.b - mirror.a, mirror.c - mirror.a));
  let d   = dot(n, mirror.a);
  let ctr = arc.origin + arc.radius * arc.perp;

  // n · p(θ) = d  →  A·cos θ + B·sin θ = C
  let A = -arc.radius * dot(n, arc.perp);
  let B =  arc.radius * dot(n, arc.dir);
  let C = d - dot(n, ctr);

  let R_sq = A * A + B * B;
  if R_sq < 1e-6 { return arc_hit_none(); }

  let ratio = C / sqrt(R_sq);
  if abs(ratio) > 1.0 { return arc_hit_none(); }

  let phi   = atan2(B, A);
  let delta = acos(clamp(ratio, -1.0, 1.0));
  let TWO_PI = 6.28318530718;
  let EPS    = 0.005;

  var best = 1e30;

  // Two candidate angles; normalise into (0, 2π) then filter by (EPS, MAX_ARC)
  for (var k = 0u; k < 2u; k++) {
    var th = select(phi + delta, phi - delta, k == 1u);
    th = th - TWO_PI * floor(th / TWO_PI);
    if th > EPS && th < MAX_ARC && th < best {
      // Point-in-triangle test (sign-agnostic in n orientation)
      let pt  = arc_point(arc, th);
      let d0  = dot(cross(mirror.b - mirror.a, pt - mirror.a), n);
      let d1  = dot(cross(mirror.c - mirror.b, pt - mirror.b), n);
      let d2  = dot(cross(mirror.a - mirror.c, pt - mirror.c), n);
      let inside = (d0 >= 0.0 && d1 >= 0.0 && d2 >= 0.0)
                || (d0 <= 0.0 && d1 <= 0.0 && d2 <= 0.0);
      if inside { best = th; }
    }
  }

  if best > 1e29 { return arc_hit_none(); }

  let hit_pt  = arc_point(arc, best);
  var tangent = arc_tangent(arc, best);

  // Ensure normal opposes the incoming tangent
  if dot(tangent, n) > 0.0 { n = -n; }

  let reflected = normalize(tangent - 2.0 * dot(tangent, n) * n);
  return ArcHit(true, best, hit_pt, reflected);
}

// ---------------------------------------------------------------------------
// Fragment shader
// ---------------------------------------------------------------------------

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {
  let coord   = vx_out.uv * uniforms.screen_wh;
  let p       = coord * 0.0005 / uniforms.scale;
  let ray_dir = normalize(p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward);

  // arc_phase ∈ [-1, +1]: controls both bend direction and curvature magnitude.
  // Curvature = 1/effective_radius = |arc_phase| / arc_radius, so:
  //   near zero-crossing → effective_radius → ∞ → straight ray
  //   near ±1            → effective_radius = arc_radius (tightest curve)
  // The sign of arc_phase flips which side the arc bends toward.
  let arc_phase        = sin(params.lifetime * 0.0196);
  let abs_phase        = max(abs(arc_phase), 0.004);
  let effective_radius = params.arc_radius / abs_phase;
  // bend direction is always stable (unit gravity); only radius changes.
  let bend_sign        = arc_phase / abs_phase;           // ≈ ±1 continuously
  let bend_world       = vec3<f32>(params.gx, params.gy, params.gz) * bend_sign;

  let base_light  = vec4<f32>(params.lr, params.lg, params.lb, 0.0);
  let bounce_tint = vec4<f32>(params.br, params.bg, params.bb, 0.0);
  let color_cap   = vec4<f32>(0.72, 0.92, 0.98, 1.0);

  var total_color    = vec4<f32>(0.02, 0.03, 0.05, 1.0);
  var current_pos    = uniforms.viewer_position;
  var current_dir    = ray_dir;
  var in_mirror      = 0u;

  let max_reflect_times = u32(params.max_reflections);
  let size              = arrayLength(&base_points);
  let segments_size     = arrayLength(&secondary_points);

  for (var times = 0u; times < max_reflect_times + 1u; times++) {
    if all(total_color.rgb >= color_cap.rgb) { break; }

    let first_bounce   = in_mirror == 0u;
    let f              = pow(f32(in_mirror) / 2.0 + 2.0, 3.0);
    var hit_mirror     = false;
    var nearest_travel = 1e30;
    var nearest_pt     = vec3<f32>(0.0);
    var nearest_dir    = vec3<f32>(0.0);

    if first_bounce {
      // First leg from camera: straight ray (same as parabola demo)
      for (var mi = 0u; mi < size; mi++) {
        let cell   = base_points[mi];
        let mirror = MirrorTriangle(cell.a.xyz, cell.b.xyz, cell.c.xyz);
        let hit    = try_reflect_ray_with_mirror(current_pos, current_dir, mirror);
        if hit.hit && hit.travel > 0.01 && hit.travel < nearest_travel {
          hit_mirror     = true;
          nearest_travel = hit.travel;
          nearest_pt     = hit.point;
          nearest_dir    = hit.next_ray_unit;
        }
      }
    } else {
      // Interior legs: circular arc
      let arc = make_arc_ray(current_pos, current_dir, bend_world, effective_radius);
      for (var mi = 0u; mi < size; mi++) {
        let cell   = base_points[mi];
        let mirror = MirrorTriangle(cell.a.xyz, cell.b.xyz, cell.c.xyz);
        let ah     = try_arc_reflect(arc, mirror);
        let travel = ah.theta * arc.radius;  // arc-length approximation
        if ah.hit && travel < nearest_travel {
          hit_mirror     = true;
          nearest_travel = travel;
          nearest_pt     = ah.point;
          nearest_dir    = ah.next_dir;
        }
      }
    }

    // Segment lighting — straight-line approximation from current pos+dir
    for (var i = 0u; i < segments_size; i++) {
      let segment = Segment(secondary_points[i].a.xyz, secondary_points[i].b.xyz);
      let reach   = ray_closest_point_to_line(current_pos, current_dir, segment);
      if hit_mirror && reach.traveled > nearest_travel { continue; }
      if first_bounce && !reach.positive_side { continue; }

      let distance    = max(0.001, reach.distance - 0.42);
      let color_scale = 1.5 / pow(distance * 0.06 + 0.01, 1.8) / f;
      total_color += base_light * color_scale;
      total_color  = min(total_color, color_cap);
    }

    if hit_mirror {
      if rand11(dot(vx_out.uv, vec2f(127.1, 311.7)) + f32(times) * 43.7) < 0.12 { break; }
      total_color += bounce_tint;
      current_pos  = nearest_pt;
      current_dir  = nearest_dir;
      in_mirror   += 1u;
    } else {
      break;
    }
  }

  return total_color;
}
