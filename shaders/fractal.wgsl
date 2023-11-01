struct UBO {
  screen_wh: vec2<f32>,
  scale: f32,
  time: f32,
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


fn quaternion_multiply(a: vec4<f32>, b: vec4<f32>) -> vec4<f32> {
  // scalar part at end
  let x = a.x * b.w + a.y * b.z - a.z * b.y + a.w * b.x;
  let y = -a.x * b.z + a.y * b.w + a.z * b.x + a.w * b.y;
  let z = a.x * b.y - a.y * b.x + a.z * b.w + a.w * b.z;
  let w = -a.x * b.x - a.y * b.y - a.z * b.z + a.w * b.w;
  return vec4<f32>(x, y, z, w);
}

fn fold(v0: vec4<f32>) -> vec4<f32> {
  let offset = vec4<f32>(0.0, 0.48, 0.0, 0.59);
  var v = v0.xyzw * 0.3;
  for (var i = 0u; i < 60u; i = i + 1u) {
    v = quaternion_multiply(v, v) - offset;
  }
  return v;
}


@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  // pixel coordinates
  let coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;
  let p: vec2<f32> = coord * 0.0005 / uniforms.scale;

  let t = uniforms.time;
  let theta = t * 0.0002;

  // create view ray
  let ray_unit = normalize(
    p.x * uniforms.rightward
    + p.y * uniforms.upward
    + 2.0 * uniforms.forward
  );

  var total = vec4<f32>(0.0, 0.0, 0.0, 0.0);

  for (var idx = -0i; idx < 1i; idx = idx + 1i) {
    let p0 = vec3<f32>(0.0, 0.0, f32(idx) * 60.0);
    let v1 = normalize(vec3<f32>(0.0, 1.0, 0.0));
    let v2 = normalize(vec3<f32>(cos(theta), 0.0, sin(theta)));

    let n = normalize(cross(v1, v2));
    let connect = uniforms.viewer_position - p0;
    let distance_to_surface = abs(dot(connect, n));
    let look_direction = dot(ray_unit, -connect);
    if (look_direction > 0.) {
      let cos_value = abs(dot(ray_unit, n));
      let join_point = uniforms.viewer_position + ray_unit * distance_to_surface / cos_value;
      let arm = join_point - p0;
      let base_v1 = dot(arm, v1);
      let base_v2 = dot(arm, v2);
      if (abs(base_v1) <= 2000. && abs(base_v2) <= 2000.) {
        // if (abs(fract(base_v1 * 0.0008)) < 0.01) {
        //   return vec4(0.4, 0.4, 0.4, 1.0);
        // }
        // if (abs(fract(base_v2 * 0.0008)) < 0.01) {
        //   return vec4(0.4, 0.4, 0.4, 1.0);
        // }
        let value = vec4(join_point * 0.002, 1.0);
        let q4_result = fold(value);
        if (length(q4_result) < 100.0)  {
          total += vec4(1.0, 1.0, 0.0, 1.0);
        } else {
          total += vec4(0.0, 0.0, 0.0, 1.0);
        }
        continue;
        // return vec4(fract(value.xyz), 1.0);
        // return vec4(fract(q4_result.xyz), 1.0);
      }
    }
  }

  return total;
}
