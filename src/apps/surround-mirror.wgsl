
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

// shapes

fn reflection_line(p: vec2f, p1: vec2f, p2: vec2f, skip: f32, regress: f32) -> vec2f {
  let perp = perpendicular(p, p1, p2);
  let d = perp - p;
  let ld = length(d);
  return perp + (d + (-skip * d / ld)) * regress;
}


/// reflect line A upon the part that is parrallel to B
fn reflect_on_direction(a: vec3<f32>, b: vec3<f32>) -> vec3<f32> {
  let b0 = normalize(b);
  let v_ = dot(a, b0) * b0;
  let v_p = a - v_;
  return v_ - v_p;
}

/// result holding information how ray is close to segment line
struct RayReachSegment {
  distance: f32,
  point: vec3<f32>,
}


struct Segment {
  start: vec3<f32>,
  end: vec3<f32>,
}

/// find out closest point of ray to the segment
fn ray_closest_point_to_line(ray_unit: vec3f, s: Segment, viewer_position: vec3f) -> RayReachSegment {
  let a = s.start - viewer_position;
  let b = s.end - viewer_position;

  // find perp direction and projection length on it
  let n = cross(b - a, ray_unit);

  let n0 = normalize(n);

  /// smaller distance to segments ends
  let d_min = min(abs(dot(n0, a)), abs(dot(n0, b)));

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

  var nearest: f32;
  if same_side {
    let a_distance_min = sqrt(dot(a, a) - a_proj * a_proj);
    let b_distance_min = sqrt(dot(b, b) - b_proj * b_proj);
    nearest = min(a_distance_min, b_distance_min);
  } else {
    nearest = d_min;
  };

  return RayReachSegment(nearest, viewer_position + ray_unit * a_proj);
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

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  // pixel coordinates
  let coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;
  let p: vec2<f32> = coord * 0.0005 / uniforms.scale;

  // var base_size = arrayLength(&base_points);
  let segments = array<Segment, 2>(
    Segment(vec3<f32>(0.0, 0.0, 0.0), vec3<f32>(20.0, 100.0, 0.0)),
    Segment(vec3<f32>(0.0, 0.0, 0.0), vec3<f32>(-20.0, 100.0, 0.0))
  );

  // create view ray
  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  for (var i = 0u; i < 2u; i = i + 1u) {
    let segment = segments[i];
    let reach = ray_closest_point_to_line(ray_unit, segment, uniforms.viewer_position);
    let distance = reach.distance;
    // let point = reach.point;

    if distance < 1.0 {
      return vec4<f32>(1.0, 0.0, 0.0, 1.0);
    }
  }



  return vec4<f32>(0.2, 0.0, 0.3, 1.0);
}
