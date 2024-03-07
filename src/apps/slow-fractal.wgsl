
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

struct FoldRet {
  length: f32,
  step: u32,
}

fn fold(v0: vec4<f32>) -> FoldRet {
  let offset = vec4<f32>(0.35, 0.0, 0.0, 0.66);
  var v = v0.xwzy;
  for (var i = 0u; i < 600u; i = i + 1u) {
    v = quaternion_multiply(v, v) - offset;
    let l = length(v);
    if l > 100. {
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

  // let t = uniforms.time;
  // let theta = t * 0.0000 + 0.7;

  // create view ray
  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  let connect = -uniforms.viewer_position;
  let close_ratio = dot(ray_unit, connect);
  let ray_close = close_ratio * ray_unit;
  let close_length = length(ray_close - connect);
  if close_length > 200.0 {
    return vec4<f32>(0.0, 0.0, 0.0, 1.0);
  }
  let delta = sqrt(200.0 * 200.0 - close_length * close_length);

  // return vec4<f32>(0.0, 0.3, 0.0, 1.0);

  var reach = close_ratio - delta;
  for (var idx = 0u; idx < 200u; idx++) {
    // return vec4(1.0, 1.0, 0.0, 1.0);
    reach += 1.2;

    if reach > close_ratio + delta {
      break;
    }

    // let pr = length(point);

    let point = ray_unit * reach + uniforms.viewer_position;
    let v = vec4<f32>(point, 1.0) * 0.005;
    let ret = fold(v);
    if ret.length < 1.0 {
      return vec4(1.0, 1.0, 0.0, 1.0);
      // let l = 0.6 + 0.4 * fract(pr * 0.1);
      // return vec4(l, l, l, 1.0);
    }
  }


  return vec4<f32>(0.0, 0.0, 0.3, 1.0);
}
