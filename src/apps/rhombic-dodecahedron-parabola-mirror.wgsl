#import soluble::perspective
#import soluble::math
#import soluble::mirror

// Parabolic light inside a rhombic dodecahedron.
//
// Semantics: outside the polyhedron the ray is a straight line. The first mirror
// bounce marks the moment the ray enters the interior; from there on a downward
// gravity-like acceleration bends every subsequent leg into a parabola. When the
// acceleration tends to 0 the parabola degenerates smoothly back to a straight
// line, so the whole picture morphs continuously as the acceleration oscillates.
struct Params {
  time: f32,
  dt: f32,
  lifetime: f32,
  max_reflections: f32,
  lr: f32,
  lg: f32,
  lb: f32,
  br: f32,
  bg: f32,
  bb: f32,
  curve_max: f32,
}

@group(0) @binding(1) var<uniform> params: Params;

struct BaseCell {
  a: vec4<f32>,
  b: vec4<f32>,
  c: vec4<f32>,
};

@group(1) @binding(0) var<storage, read_write> base_points: array<BaseCell>;
@group(1) @binding(1) var<storage, read_write> secondary_points: array<BaseCell>;

@compute @workgroup_size(8, 8, 1)
fn compute_main(@builtin(global_invocation_id) global_id: vec3u) {}

struct VertexOut {
  @builtin(position) position: vec4<f32>,
  @location(1) uv: vec2<f32>,
};

struct ReachResult {
  distance: f32,
  positive_side: bool,
  traveled: f32,
};

struct MirrorHit {
  hit: bool,
  point: vec3<f32>,
  travel: f32,
  next_velocity: vec3<f32>,
};

@vertex
fn vertex_main(@location(0) position: vec2<f32>) -> VertexOut {
  var output: VertexOut;
  output.position = vec4(position, 0.0, 1.0);
  output.uv = vec2<f32>(position.x, position.y);
  return output;
}

fn point_to_segment_distance(p: vec3<f32>, s: Segment) -> f32 {
  let ab = s.end - s.start;
  let ap = p - s.start;
  let denom = max(dot(ab, ab), 0.0001);
  let h = clamp(dot(ap, ab) / denom, 0.0, 1.0);
  let nearest = s.start + ab * h;
  return length(p - nearest);
}

// Parabolic kinematics, parameterized by travel parameter t. With gravity == 0
// these degenerate to a straight ray, so the same routines work both for the
// outside leg and for interior legs with arbitrarily small acceleration.
fn parabola_point(origin: vec3<f32>, velocity: vec3<f32>, t: f32, gravity: vec3<f32>) -> vec3<f32> {
  return origin + velocity * t + 0.5 * gravity * t * t;
}

fn parabola_velocity(velocity: vec3<f32>, t: f32, gravity: vec3<f32>) -> vec3<f32> {
  return velocity + gravity * t;
}

// Linear fast-path reach for the outside-to-first-mirror leg.
fn linear_reach(origin: vec3<f32>, velocity: vec3<f32>, s: Segment) -> ReachResult {
  let speed = max(length(velocity), 0.0001);
  let unit = velocity / speed;
  let linear = ray_closest_point_to_line(origin, unit, s);
  return ReachResult(linear.distance, linear.positive_side, linear.traveled / speed);
}

// Parabolic reach: uniform-sample the parabola on [0, max_travel] to find the
// closest approach to a finite segment, then take a single quadratic-interpolation
// refinement around the discrete minimum for sub-step accuracy. Uniform sampling
// (instead of a linear-seed plus local refine) avoids any bias that would make the
// result discontinuous as gravity grows from 0.
fn curved_reach(origin: vec3<f32>, velocity: vec3<f32>, gravity: vec3<f32>, s: Segment, max_travel: f32) -> ReachResult {
  if max_travel <= 0.0 {
    let p = origin;
    return ReachResult(point_to_segment_distance(p, s), false, 0.0);
  }
  let steps = 96u;
  var best_distance = 1e30;
  var best_i = 1u;
  for (var i = 1u; i <= steps; i = i + 1u) {
    let t = max_travel * f32(i) / f32(steps);
    let p = parabola_point(origin, velocity, t, gravity);
    let d = point_to_segment_distance(p, s);
    if d < best_distance {
      best_distance = d;
      best_i = i;
    }
  }
  let step = max_travel / f32(steps);
  let best_t = f32(best_i) * step;
  let t_minus = max(0.0, best_t - step);
  let t_plus = min(max_travel, best_t + step);
  let d_minus = point_to_segment_distance(parabola_point(origin, velocity, t_minus, gravity), s);
  let d_plus = point_to_segment_distance(parabola_point(origin, velocity, t_plus, gravity), s);
  var refined_t = best_t;
  var refined_d = best_distance;
  let denom = d_minus - 2.0 * best_distance + d_plus;
  if abs(denom) > 1e-6 {
    let offset = 0.5 * (d_minus - d_plus) / denom * step;
    let t_ref = clamp(best_t + offset, t_minus, t_plus);
    let d_ref = point_to_segment_distance(parabola_point(origin, velocity, t_ref, gravity), s);
    if d_ref < refined_d {
      refined_t = t_ref;
      refined_d = d_ref;
    }
  }
  return ReachResult(refined_d, refined_t > 0.01, refined_t);
}

// Linear mirror intersection (outside leg). We re-use the shared helper and
// convert its unit-ray travel back into our velocity parameterization so all
// travel values in the main loop share the same "t" meaning.
fn try_reflect_linear_with_mirror(origin: vec3<f32>, velocity: vec3<f32>, mirror: MirrorTriangle) -> MirrorHit {
  let speed = max(length(velocity), 0.0001);
  let unit = velocity / speed;
  let hit = try_reflect_ray_with_mirror(origin, unit, mirror);
  if !hit.hit { return MirrorHit(false, vec3<f32>(0.0), 0.0, vec3<f32>(0.0)); }
  return MirrorHit(true, hit.point, hit.travel / speed, hit.next_ray_unit * speed);
}

// Parabolic mirror intersection: solve 0.5*dot(n,g)*t^2 + dot(n,v)*t + dot(n,p0-a) = 0
// for the supporting plane of the mirror triangle, keep the smallest positive root
// that lands inside the triangle, and reflect the instantaneous velocity at impact
// to preserve the parabolic physics across the bounce.
fn try_reflect_parabola_with_mirror(origin: vec3<f32>, velocity: vec3<f32>, gravity: vec3<f32>, mirror: MirrorTriangle) -> MirrorHit {
  let normal0 = normalize(cross(mirror.b - mirror.a, mirror.c - mirror.a));

  let qa = 0.5 * dot(normal0, gravity);
  let qb = dot(normal0, velocity);
  let qc = dot(normal0, origin - mirror.a);

  var best_t = 1e30;
  let eps = 1e-6;

  if abs(qa) < eps {
    if abs(qb) < eps {
      return MirrorHit(false, vec3<f32>(0.0), 0.0, vec3<f32>(0.0));
    }
    let t = -qc / qb;
    if t > 0.01 { best_t = t; }
  } else {
    let disc = qb * qb - 4.0 * qa * qc;
    if disc < 0.0 {
      return MirrorHit(false, vec3<f32>(0.0), 0.0, vec3<f32>(0.0));
    }
    let root = sqrt(disc);
    let t1 = (-qb - root) / (2.0 * qa);
    let t2 = (-qb + root) / (2.0 * qa);
    if t1 > 0.01 { best_t = min(best_t, t1); }
    if t2 > 0.01 { best_t = min(best_t, t2); }
  }

  if best_t > 1e29 {
    return MirrorHit(false, vec3<f32>(0.0), 0.0, vec3<f32>(0.0));
  }

  let hit_point = parabola_point(origin, velocity, best_t, gravity);
  let spin_a = cross(hit_point - mirror.a, mirror.b - mirror.a);
  let spin_b = cross(hit_point - mirror.b, mirror.c - mirror.b);
  let spin_c = cross(hit_point - mirror.c, mirror.a - mirror.c);
  let inside = dot(spin_a, spin_b) > 0.0 && dot(spin_b, spin_c) > 0.0 && dot(spin_c, spin_a) > 0.0;
  if !inside {
    return MirrorHit(false, vec3<f32>(0.0), 0.0, vec3<f32>(0.0));
  }

  let velocity_at_hit = parabola_velocity(velocity, best_t, gravity);
  var normal = normal0;
  if dot(velocity_at_hit, normal) > 0.0 { normal = -normal; }
  let reflected = reflect_on_direction(velocity_at_hit, normal);
  return MirrorHit(true, hit_point, best_t, reflected);
}

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {
  let coord = vx_out.uv * uniforms.screen_wh;
  let p = coord * 0.0005 / uniforms.scale;
  let ray_unit = normalize(p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward);

  var total_color = vec4<f32>(0.03, 0.03, 0.07, 1.0);
  let color_cap = vec4<f32>(0.78, 0.93, 0.96, 1.0);
  let base_light = vec4<f32>(params.lr, params.lg, params.lb, 0.0);
  let bounce_tint = vec4<f32>(params.br, params.bg, params.bb, 0.0);

  // Continuous acceleration envelope: 0 -> curve_max -> 0 over a slow cosine wave.
  // The whole picture sees exactly one gravity vector per frame and the kinematics
  // reduce to straight lines when curve_accel == 0, so the morph is continuous.
  let accel_phase = 0.5 - 0.5 * cos(params.lifetime * 0.00035);
  let curve_accel = params.curve_max * accel_phase;
  let gravity_inside = vec3<f32>(0.0, -curve_accel, 0.0);

  var current_viewer = uniforms.viewer_position;
  var current_velocity = ray_unit;
  var in_mirror = 0u;

  let max_reflect_times = u32(params.max_reflections);
  let size = arrayLength(&base_points);
  let segments_size = arrayLength(&secondary_points);

  for (var times = 0u; times < max_reflect_times + 1u; times++) {
    if all(total_color.rgb >= color_cap.rgb) { break; }

    let first_bounce = in_mirror == 0u;
    // Gravity only applies to legs that are already inside the polyhedron.
    let gravity = select(gravity_inside, vec3<f32>(0.0), first_bounce);

    var hit_mirror = false;
    var nearest = MirrorHit(false, vec3<f32>(0.0), 1e30, vec3<f32>(0.0));

    for (var mi = 0u; mi < size; mi = mi + 1u) {
      let cell = base_points[mi];
      let mirror = MirrorTriangle(cell.a.xyz, cell.b.xyz, cell.c.xyz);
      var hit: MirrorHit;
      if first_bounce {
        hit = try_reflect_linear_with_mirror(current_viewer, current_velocity, mirror);
      } else {
        hit = try_reflect_parabola_with_mirror(current_viewer, current_velocity, gravity, mirror);
      }
      if hit.hit && hit.travel > 0.01 && hit.travel < nearest.travel {
        hit_mirror = true;
        nearest = hit;
      }
    }

    let attenuation = pow(f32(in_mirror) / 2.0 + 2.0, 3.0);
    let sample_limit = select(420.0, nearest.travel, hit_mirror);

    for (var i = 0u; i < segments_size; i = i + 1u) {
      let segment = Segment(secondary_points[i].a.xyz, secondary_points[i].b.xyz);
      var reach: ReachResult;
      if first_bounce {
        reach = linear_reach(current_viewer, current_velocity, segment);
      } else {
        reach = curved_reach(current_viewer, current_velocity, gravity, segment, sample_limit);
      }

      if hit_mirror && reach.traveled > nearest.travel { continue; }
      if first_bounce && !reach.positive_side { continue; }

      let distance = max(0.001, reach.distance - 0.42);
      let color_scale = 1.5 / pow(distance * 0.06 + 0.01, 1.8) / attenuation;

      total_color += base_light * color_scale;
      total_color = min(total_color, color_cap);
    }

    if hit_mirror {
      if rand11(dot(vx_out.uv, vec2f(127.1, 311.7)) + f32(times) * 43.7) < 0.15 { break; }
      total_color += bounce_tint;
      current_viewer = nearest.point;
      current_velocity = nearest.next_velocity;
      in_mirror += 1u;
    } else {
      break;
    }
  }

  return total_color;
}