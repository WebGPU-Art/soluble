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
  p1: f32, p2: f32, p3: f32, p4: f32,

  // extend params
  p5: f32,
  p6: f32,
  p7: f32,
  p8: f32,
};

@group(1) @binding(0) var<storage, read_write> base_points: array<BaseCell>;

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

struct FoldRet {
  length: f32,
  step: u32,
}

fn fold(v0: vec4<f32>) -> FoldRet {
  let offset = vec4<f32>(0.7, 0.0, 0.0, 0.5);
  var v = v0.wxyz * 0.4;
  for (var i = 0u; i < 200u; i = i + 1u) {
    v = quaternion_multiply(v, v) - offset;
    let l = length(v);
    if l > 100.4 {
      return FoldRet(l, i);
    }
  }
  return FoldRet(0.0, 300u);
}


@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  // pixel coordinates
  let coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;
  let p: vec2<f32> = coord * 0.0005 / uniforms.scale;

  let t = uniforms.time;
  let theta = t * 0.0000 + 0.7;

  // create view ray
  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  let p0 = vec3<f32>(0.0, 0.0, 0.0);
  let v1 = normalize(vec3<f32>(0.0, 1.0, 0.0));
  let v2 = normalize(vec3<f32>(cos(theta), 0.0, sin(theta)));

  let n = cross(v1, v2);
  let cos_value = dot(ray_unit, n);
  let connect = p0 - uniforms.viewer_position;
  let distance_to_surface = dot(connect, n);
  let join_point = uniforms.viewer_position + ray_unit * distance_to_surface / cos_value;
  let view_direction = dot(ray_unit, join_point - uniforms.viewer_position);
  if view_direction > 0. {
    let arm = join_point - p0;
    if abs(dot(arm, v1)) <= 2000. && abs(dot(arm, v2)) <= 2000. {
      let value = vec4(join_point * 0.002, 1.0);
      let ret = fold(value);
      if ret.length < 100.0 {
        return vec4(0.0, 0.0, 0.0, 1.0);
      } else {
        return vec4(1. * fract(f32(ret.step) * 0.045), 1. * fract(f32(ret.step) * 0.073), 1. * fract(f32(ret.step) * 0.08), 1.0);
      }
      // return vec4(fract(value.xyz), 1.0);
      // return vec4(fract(q4_result.xyz), 1.0);
    }
  }

  return vec4<f32>(0.0, 0.0, 0.0, 0.0);
}
