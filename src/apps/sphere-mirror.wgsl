
#import soluble::perspective

#import soluble::math

struct Params {
  time: f32,
  dt: f32,
  /// 1 to disable
  // disableLens: f32,
  // maskRadius: f32,
  lifetime: f32,
}

@group(0) @binding(1) var<uniform> params: Params;


struct BaseCell {
  a: vec4<f32>,
  b: vec4<f32>,
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
  return a - 2. * v_ ;
}

/// result holding information how ray is close to segment line
struct RayReachSegment {
  distance: f32,
  positive_side: bool,
  traveled: f32,
}


struct Segment {
  start: vec3<f32>,
  end: vec3<f32>,
}

/// find out closest point of ray to the segment
fn ray_closest_point_to_line(viewer_position: vec3f, ray_unit: vec3f, s: Segment) -> RayReachSegment {
  let a = s.start - viewer_position;
  let b = s.end - viewer_position;

  // find perp direction and projection length on it
  let n = cross(b - a, ray_unit);

  // find projection of a of segment on ray direction, and use the Pythagorean theorem for another distance
  let a_proj = dot(ray_unit, a);
  let shadow_a = a - ray_unit * a_proj;

  let b_proj = dot(ray_unit, b);
  let shadow_b = b - ray_unit * b_proj;

  let direct_an = cross(shadow_a, n);
  let direct_bn = cross(shadow_b, n);
      // a and b on the same side of N
  let same_side = dot(direct_an, direct_bn) >= 0.0;

  if same_side {
    let a_distance_min = sqrt(dot(a, a) - a_proj * a_proj);
    let b_distance_min = sqrt(dot(b, b) - b_proj * b_proj);
    if a_distance_min < b_distance_min {
      return RayReachSegment(a_distance_min, a_proj > 0., a_proj);
    } else {
      return RayReachSegment(b_distance_min, b_proj > 0., b_proj);
    }
  } else {
    let n0 = normalize(n);
    /// smaller distance to segments ends
    let d_min = abs(dot(n0, a));

    // let travel = min(a_proj, b_proj); // very rough approximation
    let ab_unit = normalize(s.end - s.start);
    let ac = (viewer_position - s.start);

    let perp_reach: vec3f = dot(ac, n0) * n0;

    /// tricky math to find out traveled distance before closest point
    /// https://cos-sh.tiye.me/cos-up/342e0f6b7e3a7b1b4d18dad16cd84f79/IMG_20240601_113231.jpg
    /// https://g.co/gemini/share/dbf766e185a7
    let k = dot(
      cross(s.start + perp_reach - viewer_position, ab_unit),
      cross(ray_unit, ab_unit)
    ) + .0;

    let front = dot(a, ray_unit) >= 0.0 && dot(b, ray_unit) >= 0.0;
    return RayReachSegment(d_min, front, k);
  };
}

// fn move_segment(segment: Segment, shifts: vec3f) -> Segment {
//   let next_start = segment.start + shifts;
//   let next_end = segment.end + shifts;
//   return Segment(next_start, next_end);
// }

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

fn try_reflect_ray_with_sphere(viewer_position: vec3f, ray_unit: vec3f, center: vec3f, radius: f32) -> RayMirrorHit {

  // sphere center to viewer
  let center_to_viewer = center - viewer_position;
  // distance from center to ray direction
  let projection = dot(center_to_viewer, ray_unit);
  let distance_to_ray = center_to_viewer - projection * ray_unit;

  if projection < 0.0 {
    // viewer is behind the sphere
    return RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 0.0, vec3<f32>(0.0, 0.0, 0.0));
  }

  if length(distance_to_ray) > radius {
    // viewer is outside the sphere
    return RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 0.0, vec3<f32>(0.0, 0.0, 0.0));
  }

  let distance_to_hit = sqrt(radius * radius - dot(distance_to_ray, distance_to_ray));
  let further_hit_point = viewer_position + (projection + distance_to_hit) * ray_unit;

  return RayMirrorHit(true, further_hit_point, projection + distance_to_hit, reflect_on_direction(ray_unit, further_hit_point - center));
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

  // create view ray
  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  var total_color = vec4<f32>(0.2, 0.0, 0.3, 1.0);

  let shift_z = 8.0;

  let m_base = 100.;
  let m1 = vec3f(m_base * 2., m_base, 1. * shift_z);
  let m2 = vec3f(-m_base * 2., m_base, 1. * shift_z);
  let m3 = vec3f(m_base * 2., -m_base, 1. * shift_z);
  let m4 = vec3f(-m_base * 2., -m_base, 1. * shift_z);

  let m5 = vec3f(m_base * 2., m_base, -1. * shift_z);
  let m6 = vec3f(-m_base * 2., m_base, -1. * shift_z);
  let m7 = vec3f(m_base * 2., -m_base, -1. * shift_z);
  let m8 = vec3f(-m_base * 2., -m_base, -1. * shift_z);

  var current_viewer = uniforms.viewer_position;
  var current_ray_unit = ray_unit;
  var traveled = 0.0;
  var in_mirror = 0u;

  var hit_image_at = vec2<f32>(0.0, 0.0);
  var hit_image = false;

  let sphere_center = vec3f(0., 0., 0.);
  let sphere_radius = 100.;

  for (var times = 0u; times < max_relect_times + 1u; times++) {

    var hit_mirror = false;
    var nearest = RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 1000000., vec3<f32>(0.0, 0.0, 0.0));

    let hit_sphere = try_reflect_ray_with_sphere(current_viewer, current_ray_unit, sphere_center, sphere_radius);
    if hit_sphere.hit && abs(hit_sphere.travel) > .01 {
      hit_mirror = true;

      if hit_sphere.travel < nearest.travel {
        nearest = hit_sphere;
        traveled = hit_sphere.travel;
      }
      // return vec4<f32>(1.0, .0, 1.0, 1.0);
    }

    // let t = params.time * 0.0008;

    let s_size = arrayLength(&base_points);
    for (var i = 0u; i < s_size; i = i + 1u) {
      var segment = Segment(
        base_points[i].a.xyz,
        base_points[i].b.xyz
      );
      // segment = move_segment(segment, vec3(10. * sin(t * 0.9), 10. * sin(t * 0.7), 10. * sin(t * 0.6)));
      let reach = ray_closest_point_to_line(current_viewer, current_ray_unit, segment);

      if !reach.positive_side && in_mirror < 1u {
        // I want to reduce light from back of camera,
        // however, it does not apply to in-mirror world
        continue;
      }

      if hit_mirror {
        if reach.traveled > traveled {
          continue;
        }
      }

      let distance = max(0., reach.distance - 0.6);
      let f = pow(f32(in_mirror) / 2. + 2.0, 3.);
      total_color += vec4<f32>(0.01, 0.02, 0.01, 0.0) * 1.2 / pow(distance * 0.07 + 0.01, 1.8) / f;
      total_color = min(total_color, vec4<f32>(0.4, 1.0, 0., 1.0));
    }

    if hit_mirror {
      total_color += vec4<f32>(0.01, 0.006, .2, 0.) ;
      current_viewer = nearest.point;
      current_ray_unit = nearest.next_ray_unit;
      in_mirror += 1u;
    } else {
      break;
    }
  }

  return total_color;
}
