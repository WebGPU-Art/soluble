
#import soluble::perspective

#import soluble::math

struct Params {
  time: f32,
  dt: f32,
  /// 1 to disable
  disableLens: f32,
  maskRadius: f32,
}

@group(0) @binding(1) var<uniform> params: Params;



struct BaseCell {
  position: vec4<f32>,
  arm: vec4<f32>,
  // offset
  idx: f32,
  offset: f32,
  // duration
  duration: f32,
  time: f32,
};

@group(1) @binding(0) var<storage, read_write> base_points: array<BaseCell>;


@compute @workgroup_size(8, 8, 1)
fn compute_main(@builtin(global_invocation_id) global_id: vec3u) {
  // not doint things
}

/// reflect line A upon the part that is parrallel to B
fn reflect_on_direction(a: vec3<f32>, b: vec3<f32>) -> vec3<f32> {
  let b0 = normalize(b);
  let v_ = dot(a, b0) * b0;
  let v_p = a - v_;
  return v_p - v_ ;
}

/// result holding information how ray is close to segment line
struct RayReachSegment {
  distance: f32,
  positive_side: bool,
}


struct Segment {
  start: vec3<f32>,
  end: vec3<f32>,
}

/// find out closest point of ray to the segment
/// TODO remove hits behind the camera
fn ray_closest_point_to_line(viewer_position: vec3f, ray_unit: vec3f, s: Segment) -> RayReachSegment {
  let a = s.start - viewer_position;
  let b = s.end - viewer_position;



  // find perp direction and projection length on it
  let n = cross(b - a, ray_unit);

  // find projection of a of segment on ray direction, and use the Pythagorean theorem for another distance
  let a_proj = dot(ray_unit, a);
  let a_proj_at = ray_unit * a_proj;
  let shadow_a = a - a_proj_at;

  let b_proj = dot(ray_unit, b);
  let b_proj_at = ray_unit * b_proj;
  let shadow_b = b - b_proj_at;

  let direct_an = cross(shadow_a, n);
  let direct_bn = cross(shadow_b, n);
      // a and b on the same side of N
  let same_side = dot(direct_an, direct_bn) >= 0.0;

  if same_side {
    let a_distance_min = sqrt(dot(a, a) - a_proj * a_proj);
    let b_distance_min = sqrt(dot(b, b) - b_proj * b_proj);
    if a_distance_min < b_distance_min {
      return RayReachSegment(a_distance_min, a_proj > 0.);
    } else {
      return RayReachSegment(b_distance_min, b_proj > 0.);
    }
  } else {
    let n0 = normalize(n);
    /// smaller distance to segments ends
    let d_min = abs(dot(n0, a));
    let nearest = d_min;

    let front = dot(a, ray_unit) >= 0.0 && dot(b, ray_unit) >= 0.0;
    return RayReachSegment(nearest, front);
  };
}

/// holding information about ray reflection
struct RayMirrorHit {
  hit: bool,
  point: vec3<f32>,
  travel: f32,
  next_ray_unit: vec3<f32>,
}

struct MirrorTriangle {
  a: vec3f,
  b: vec3f,
  c: vec3f,
}

/// to find out if ray hits mirror, return RayMirrorHit.
fn try_reflect_ray_with_mirror(viewer_position: vec3f, ray_unit: vec3f, mirror: MirrorTriangle) -> RayMirrorHit {
  /// normal of the mirror
  let n = normalize(cross(mirror.b - mirror.a, mirror.c - mirror.a));

  /// distance from the mirror surface to the viewer
  let d = dot(n, mirror.a - viewer_position);
  let cos_v = dot(n, ray_unit);
  let t = d / cos_v;

  let hit_point = viewer_position + abs(t) * ray_unit;


  /// need to skip case viewer and origin point on different sides of the mirror
  let viewer_side = dot(n, ray_unit);
  let ray_side = dot(n, hit_point);
  if viewer_side * ray_side < 0.0 {
    return RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 0.0, vec3<f32>(0.0, 0.0, 0.0));
  }
  if t < 1.0 {
    return RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 0.0, vec3<f32>(0.0, 0.0, 0.0));
  }

  let spin_a = cross(hit_point - mirror.a, mirror.b - mirror.a);
  let spin_b = cross(hit_point - mirror.b, mirror.c - mirror.b);
  let spin_c = cross(hit_point - mirror.c, mirror.a - mirror.c);
  let inside = dot(spin_a, spin_b) >= 0.0 && dot(spin_b, spin_c) >= 0.0 && dot(spin_c, spin_a) >= 0.0;

  if inside {
    let reflection = reflect_on_direction(ray_unit, n);
    return RayMirrorHit(true, hit_point, abs(t), reflection);
  } else {
    return RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), t, vec3<f32>(0.0, 0.0, 0.0));
  }
}

// Render Pass

struct VertexOut {
  @builtin(position) position: vec4<f32>,
  @location(1) uv: vec2<f32>,
};

@vertex
fn vertex_main(
  @location(0) position: vec2<f32>,
) -> VertexOut {
  var output: VertexOut;
  output.position = vec4(position, 0.0, 1.0);
  output.uv = vec2<f32>(position.x, position.y);
  return output;
}

/// maximum number of reflections
const max_relect_times = 20u;

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  // pixel coordinates
  let coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;
  let p: vec2<f32> = coord * 0.0005 / uniforms.scale;

  // var base_size = arrayLength(&base_points);
  let segments = array<Segment, 3>(
    Segment(vec3<f32>(0.0, 0.0, 0.0), vec3<f32>(20.0, 300.0, 0.0)),
    Segment(vec3<f32>(0.0, 0.0, 0.0), vec3<f32>(-20.0, 300.0, 0.0)),
    Segment(vec3<f32>(-200.0, 0.0, 0.0), vec3<f32>(-220.0, 300.0, 0.0))
  );

  let height = 200.;
  let mirrors = array<MirrorTriangle, 4>(
    MirrorTriangle(
      vec3<f32>(120.0, -height, -400.0),
      vec3<f32>(120.0, -height, 400.),
      vec3<f32>(120.0, height, 400.),
    ),
    MirrorTriangle(
      vec3<f32>(120.0, -height, -400.0),
      vec3<f32>(120.0, height, 400.),
      vec3<f32>(120.0, height, -400.),
    ),
    MirrorTriangle(
      vec3<f32>(-120.0, -height, -400.0),
      vec3<f32>(-120.0, -height, 400.),
      vec3<f32>(-120.0, height, 400.),
    ),
    MirrorTriangle(
      vec3<f32>(-120.0, -height, -400.0),
      vec3<f32>(-120.0, height, 400.),
      vec3<f32>(-120.0, height, -400.),
    ),
  );

  // create view ray
  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  var total_color = vec4<f32>(0.2, 0.0, 0.3, 1.0);


  var current_viewer = uniforms.viewer_position;
  var current_ray_unit = ray_unit;

  for (var times = 0u; times < max_relect_times + 1u; times++) {
    for (var i = 0u; i < 3u; i = i + 1u) {
      let segment = segments[i];
      let reach = ray_closest_point_to_line(current_viewer, current_ray_unit, segment);
      let distance = reach.distance;
      // let point = reach.point;

      if distance < 1.0 && reach.positive_side {
        return vec4<f32>(1.0, 0.0, 0.0, 1.0);
      }
    }

    var hit_mirror = false;
    var nearest = RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 1000000., vec3<f32>(0.0, 0.0, 0.0));

    for (var mi = 0u; mi < 4u; mi = mi + 1u) {
      let mirror = mirrors[mi];
      let hit = try_reflect_ray_with_mirror(current_viewer, current_ray_unit, mirror);

      if hit.hit && hit.travel > 1.0 {
        hit_mirror = true;

        if hit.travel < nearest.travel {
          nearest = hit;
        }
      }
    }

    if hit_mirror {
      total_color += vec4<f32>(0.04, 0.0, .0, 0.);
      current_viewer = nearest.point;
      current_ray_unit = nearest.next_ray_unit;
    } else {
      break;
    }
  }

  return total_color;
}
