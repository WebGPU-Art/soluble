struct UBO {
  screen_wh: vec2<f32>,
  scale: f32,
  forward: vec3<f32>,
  // direction up overhead, better unit vector
  upward: vec3<f32>,
  rightward: vec3<f32>,
  viewer_position: vec3<f32>,
};

struct BaseCell {
  position: vec4<f32>,
  velocity: vec4<f32>,
  arm: vec4<f32>,
  p1: f32, p2: f32, p3: f32, p4: f32,

  // extend params
  p5: f32,
  p6: f32,
  p7: f32,
  p8: f32,
};

@group(0) @binding(0) var<uniform> uniforms: UBO;
@group(0) @binding(1) var<storage, read_write> base_points: array<BaseCell>;

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

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  // pixel coordinates
  let coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;
  let p: vec2<f32> = coord * 0.0005 / uniforms.scale;

  var base_size = arrayLength(&base_points);

  // create view ray
  let ray_unit = normalize(
    p.x * uniforms.rightward
    + p.y * uniforms.upward
    + 2.0 * uniforms.forward
  );

  // raymarch
  var total: vec3<f32> = vec3(0.0,0.0,0.0);

  for (var j: u32 = 0u; j < base_size; j++) {
    let base_point = base_points[j];
    // let dh = sin(base_point.p4 * base_point.p1 * 0.000008) * 100.0;
    let base_position = base_point.position.xyz + vec3(0., 0.0, 0.);
    let arm_position = base_position + base_point.arm.xyz;

    /// from viewer to base
    let a = base_position.xyz - uniforms.viewer_position;
    /// from viewer to arm
    let b = arm_position.xyz - uniforms.viewer_position;

    if (dot(a, ray_unit) <= 0.0 || dot(b, ray_unit) <= 0.0) {
      // outside of the view
      continue;
    }

    // find perp direction and projection length on it
    let n = cross(base_point.arm.xyz, ray_unit);

    let n0 = normalize(n);
    let d_min = abs(dot(n0, a));

    if (d_min > 8.0) {
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
    if (same_side) {
      let a_distance_min = sqrt(dot(a,a) - a_proj * a_proj);
      let b_distance_min = sqrt(dot(b,b) - b_proj * b_proj);
      nearest = min(a_distance_min, b_distance_min);
    } else {
      nearest = d_min;
    };

    let idx = base_point.p5;
    total += vec3<f32>(fract(idx * 0.011), fract(idx *0.037), fract(idx * 0.43)) * clamp(2.0 / pow(nearest, 1.2) - 0.1, 0.0, 2.0);
  }

  return vec4(total, 0.9);
}
