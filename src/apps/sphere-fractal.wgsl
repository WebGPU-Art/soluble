
#import soluble::perspective


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
  let offset = vec4<f32>(0.7, 0.0, 0.0, 0.12);
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

  var color = vec4<f32>(0.0, 0.0, 0.0, 1.0);
  /// distance to the nearest point
  var depth = 100000.0;

  for (var idx = 0u; idx < arrayLength(&base_points); idx++) {

    let p0 = base_points[idx].position.xyz;
    // let v1 = base_points[idx].arm.xyz;
    let d = 40.;
    let direct = p0 - uniforms.viewer_position;
    let direct0 = normalize(direct);
    let base_distance = dot(direct, ray_unit);
    if base_distance < 0.0 {
      continue;
    }
    let near_point = uniforms.viewer_position + ray_unit * base_distance;
    let distance = length(near_point - p0);

    if distance <= d {
      let delta = sqrt(d * d - distance * distance);
      let display_point = uniforms.viewer_position + ray_unit * (base_distance - delta);
      let ret = fold(vec4(display_point * 0.01, 1.0));
      let this_depth = base_distance - delta;
      if ret.length < 100.0 {
        if this_depth < depth {
          depth = this_depth;
          color = vec4(1.0, 1.0, 0.0, 1.0);
        }
      } else {
        if this_depth < depth {
          depth = this_depth;
          color = vec4(1. * fract(f32(ret.step) * 0.045), 1. * fract(f32(ret.step) * 0.073), 1. * fract(f32(ret.step) * 0.08), 1.0);
          // color = max(color, this_color);
        }
      }
    }
  }


  return color;
}
