
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
 c: vec4<f32>,
};

@group(1) @binding(0) var<storage, read_write> base_points: array<BaseCell>;


@group(2) @binding(0) var mySampler : sampler;
@group(2) @binding(1) var myTexture : texture_2d<f32>;

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

    // let travel = d_min / dot(n0, ray_unit);
    let travel = min(a_proj, b_proj); // very rough approximation

    let front = dot(a, ray_unit) >= 0.0 && dot(b, ray_unit) >= 0.0;
    return RayReachSegment(d_min, front, travel);
  };
}

fn rotate_segment(segment: Segment, center: vec3<f32>, axis: vec3<f32>, angle: f32) -> Segment {
  let next_start = rotate_vec3(segment.start, center, axis, angle);
  let next_end = rotate_vec3(segment.end, center, axis, angle);
  return Segment(next_start, next_end);
}

fn move_segment(segment: Segment, shifts: vec3f) -> Segment {
  let next_start = segment.start + shifts;
  let next_end = segment.end + shifts;
  return Segment(next_start, next_end);
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
  if t < 0.0001 {
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

  // create view ray
  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  var total_color = vec4<f32>(0.2, 0.0, 0.3, 1.0);

  let angle = params.time * 0.0008;

  let image_center = vec3f(20. * cos(angle * 0.7), 20. * sin(angle * 0.7), -120.);
  let image_y = vec3f(0., 1., 0.);
  let image_x = rotate_vec3(vec3f(1., 0., 0.), vec3(0., 0., 0.), image_y, angle);
  let image_z = rotate_vec3(vec3f(0., 0., 1.), vec3(0., 0., 0.), image_y, angle);
  let image_radius = 40.0; // but rect

  let width = 20.;
  let shift_z = 100.0;

  let p1 = vec3f(-width, width, - shift_z);
  let p2 = vec3f(width, width, - shift_z);
  let p3 = vec3f(width, -width, - shift_z);
  let p4 = vec3f(-width, -width, - shift_z);

  let segments_size = 4u;
  let scale = 1.;
  let segments = array<Segment, 4>(
    Segment(scale * p1, scale * p2),
    Segment(scale * p2, scale * p3),
    Segment(scale * p3, scale * p4),
    Segment(scale * p4, scale * p1),
  );

  var current_viewer = uniforms.viewer_position;
  var current_ray_unit = ray_unit;
  var traveled = 0.0;

  var hit_image_at = vec2<f32>(0.0, 0.0);
  var hit_image = false;

  for (var times = 0u; times < max_relect_times + 1u; times++) {

    var hit_mirror = false;
    var nearest = RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 1000000., vec3<f32>(0.0, 0.0, 0.0));

    let size = arrayLength(&base_points);
    for (var mi = 0u; mi < size; mi = mi + 1u) {
      let ceil = base_points[mi];
      let mirror = MirrorTriangle(ceil.a.xyz, ceil.b.xyz, ceil.c.xyz);
      let hit = try_reflect_ray_with_mirror(current_viewer, current_ray_unit, mirror);

      if hit.hit && hit.travel > .01 {
        hit_mirror = true;

        if hit.travel < nearest.travel {
          nearest = hit;
          traveled = hit.travel;
        }
      }
    }

    let view_to_image = image_center - current_viewer;
    if dot(view_to_image, current_ray_unit) > 0. { // backface culling
      // let view_to_image_surface_distance = dot(image_z, view_to_image);
      // let view_hit_image_length = view_to_image_surface_distance / dot(image_z, current_ray_unit);
      // let hit_image_surface = current_viewer + view_hit_image_length * current_ray_unit - image_center;
      // let hit_image_surface_x = dot(hit_image_surface, image_x);
      // let hit_image_surface_y = dot(hit_image_surface, image_y);
      // let image_coord = vec2f(hit_image_surface_x, hit_image_surface_y) / image_radius;
      // if abs(image_coord.x) < 1.0 && abs(image_coord.y) < 1.0 {
      //   if view_hit_image_length < nearest.travel { // image is closer than mirror
      //     hit_image = true;
      //     hit_image_at = image_coord * 0.5 + 0.5;
      //     break;
      //   }
      // }

    }

    let t = params.time * 0.0008;

    for (var i = 0u; i < segments_size; i = i + 1u) {
      var segment = segments[i];
      segment = rotate_segment(segment, vec3(0., 0., - shift_z), vec3(0., 1., 0.), t);
      segment = move_segment(segment, vec3(10. * sin(t * 0.9), 10. * sin(t * 0.7), 10. * sin(t * 0.6)));
      let reach = ray_closest_point_to_line(current_viewer, current_ray_unit, segment);

      if !reach.positive_side {
        continue;
      }

      if hit_mirror {
        if reach.traveled > traveled {
          continue;
        }
      }

      let distance = reach.distance;
        // let factor = (0.1 + exp(-traveled));
        // if distance < 0.08 * (1. + pow(traveled * 0.3, 0.8)) && reach.positive_side {
        //   return vec4<f32>(1.0, 0.8, 0.0, 1.0);
        // }
      total_color += vec4<f32>(1., 1., 0.02, 0.0) * .2 / pow(distance, 2.);
    }

    if hit_mirror {
      total_color += vec4<f32>(0.01, 0.006, .02, 0.) ;
      current_viewer = nearest.point;
      current_ray_unit = nearest.next_ray_unit;
    } else {
      break;
    }
  }



  let img_pixel = textureSample(myTexture, mySampler, hit_image_at);

  if hit_image {
    return img_pixel;
  }

  return total_color;
}
