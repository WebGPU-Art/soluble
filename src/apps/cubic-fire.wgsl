
#import soluble::perspective

struct Params {
  time: f32,
  dt: f32,
  offset: f32,
  p2: f32,
}

@group(0) @binding(1) var<uniform> params: Params;



struct BaseCell {
  position: vec4<f32>,
  velocity: vec4<f32>,
  arm: vec4<f32>,
  // offset
  offset: f32,
  // duration
  duration: f32,
  p3: f32,
  time: f32,

  // extend params
  p5: f32,
  p6: f32,
  p7: f32,
  p8: f32,
};

@group(1) @binding(0) var<storage, read_write> base_points: array<BaseCell>;


@compute @workgroup_size(8, 8, 1)
fn compute_main(@builtin(global_invocation_id) global_id: vec3u) {
  var index = global_id.x + global_id.y * 8u;
  base_points[index].position.y += params.dt * 0.03 * base_points[index].velocity.y;
  if base_points[index].position.y > 200. {
    base_points[index].position.y = -200.;
  }
  base_points[index].position.x = base_points[index].position.x;
  // base_points[index].p3 = sin(base_points[index].offset + base_points[index].duration * 0.001 * params.time) * 0.4 + 0.6;
  // base_points[index].time = params.time;
}

// shapes

fn sd_sphere(p: vec3<f32>, r: f32) -> f32 {
  return length(p) - r;
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

const PI = 3.14159265368932374;

fn my_reflect(a: vec3<f32>, b: vec3<f32>) -> vec3<f32> {
  let b0 = normalize(b);
  let v_ = dot(a, b0) * b0;
  let v_p = a - v_;
  return v_ - v_p;
}

/// rotate 2/3*PI
fn rotate_120(p: vec3<f32>) -> vec3<f32> {
  let a = my_reflect(p, vec3<f32>(0., 0., -1.));
  let b = my_reflect(a, vec3<f32>(-0.5 * sqrt(3.), 0., -0.5));
  return b;
}

struct Segment {
  start: vec3<f32>,
  end: vec3<f32>,
}

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  // pixel coordinates
  let coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;
  let p: vec2<f32> = coord * 0.0005 / uniforms.scale;

  var base_size = arrayLength(&base_points);

  // create view ray
  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  // raymarch
  var total: vec3<f32> = vec3(0.0, 0.0, 0.0);

  for (var j: u32 = 0u; j < base_size; j++) {
    let base_point = base_points[j];
    var base_position = base_point.position.xyz; // + vec3(0., dh + d2, 0.);
    let scale = 0.2 + 0.8 * (base_point.position.y + 200.) / 400.;
    base_position.x *= scale;
    base_position.z *= scale;
    let arm = base_point.arm.xyz * scale;
    let l0 = length(arm);
    let arm0 = vec3(arm.x, 0.0, arm.z) + vec3<f32>(0.0, 0.5 * sqrt(2.) * l0, 0.);
    let arm1 = rotate_120(arm0);
    let arm2 = rotate_120(arm1);


    let p0 = base_position.xyz;
    let p1 = p0 + arm0;
    let p3 = p0 + arm1;
    let p4 = p0 + arm2;
    let p2 = p1 + arm1;
    let p5 = p1 + arm2;
    let p6 = p2 + arm2;
    let p7 = p3 + arm2;

    let center = (p0 + p7) * 0.5;
    let direct = center - uniforms.viewer_position;
    let reach_arm = dot(direct, ray_unit) * ray_unit;
    let distance = center - (uniforms.viewer_position + reach_arm);
    if length(distance) > (l0 * 2.4) {
      // too far from ray, contribute no light
      continue;
    }

    var segments = array<Segment, 12>(
      Segment(p0, p1),
      Segment(p1, p2),
      Segment(p2, p3),
      Segment(p3, p0),
      Segment(p0, p4),
      Segment(p1, p5),
      Segment(p2, p6),
      Segment(p3, p7),
      Segment(p4, p5),
      Segment(p5, p6),
      Segment(p6, p7),
      Segment(p7, p4),
    );

    for (var i = 0u; i < 12u; i++) {
      let s = segments[i];
      let a = s.start - uniforms.viewer_position;
      let b = s.end - uniforms.viewer_position;

      if dot(a, ray_unit) <= 0.0 || dot(b, ray_unit) <= 0.0 {
        // outside of the view
        continue;
      }

      // find perp direction and projection length on it
      let n = cross(b - a, ray_unit);

      let n0 = normalize(n);
      let d_min = abs(dot(n0, a));

      if d_min > 8.0 {
        // too far from ray, contribute no light
        continue;
      }

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

      let idx = base_point.p5;
      let light = vec3<f32>(fract(idx * 0.011), fract(idx * 0.037) * 0.3, fract(idx * 0.43) * 0.1) * clamp(4.0 / pow(nearest, 1.0) - 0.1, 0.0, 8.0) * pow((1. - scale), 0.6);
      total = max(total, light);
      // total += light;
    }
  }

  return vec4(total, 1.0);
}
