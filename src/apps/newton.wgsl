
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

fn complex_multiply(a: vec2<f32>, b: vec2<f32>) -> vec2<f32> {
  return vec2<f32>(
    a.x * b.x - a.y * b.y,
    a.x * b.y + a.y * b.x
  );
}

fn complex_divide(a: vec2<f32>, b: vec2<f32>) -> vec2<f32> {
  let d = b.x * b.x + b.y * b.y;
  return vec2<f32>(
    (a.x * b.x + a.y * b.y) / d,
    (a.y * b.x - a.x * b.y) / d
  );
}

fn complex_power(a: vec2<f32>, n: f32) -> vec2<f32> {
  let r = length(a);
  let theta = atan2(a.y, a.x);
  return vec2<f32>(
    pow(r, n) * cos(n * theta),
    pow(r, n) * sin(n * theta)
  );
}

struct FoldRet {
  length: f32,
  step: u32,
  value: vec2<f32>,
}

fn rect_distance(b: vec2<f32>) -> f32 {
  return max(abs(b.x), abs(b.y));
}

const PI = 3.1415926535897932384626433832795;

/// built in cosh(complex) does not work as expected
fn cosh_complex(a: vec2<f32>) -> vec2<f32> {
  return vec2<f32>(
    cosh(a.x) * cos(a.y),
    sinh(a.x) * sin(a.y)
  );
}

/// built in sinh(complex) does not work as expected
fn sinh_complex(a: vec2<f32>) -> vec2<f32> {
  return vec2<f32>(
    sinh(a.x) * cos(a.y),
    cosh(a.x) * sin(a.y)
  );
}

/// stops when iteration reaches a fixed point(<0.001) or iteration steps reaches 200
fn fold_approach(v0: vec2f) -> FoldRet {
  let offset = vec2<f32>(1.0, 0.);
  let TAU = 2. * PI;
  var v = v0 * 10.1;
  for (var i = 0u; i < 100u; i = i + 1u) {
    // use z^3 - 1
    // let p_next = complex_power(v, 3.) - offset;
    // let p_diff = 3. * complex_power(v, 2.);

    // z8 + 15z4 − 16
    // let p_next = complex_power(v, 8.) + 15. * complex_power(v, 4.) - 16.;
    // let p_diff = 8. * complex_power(v, 7.) + 60. * complex_power(v, 3.);

    // z^4 * sin(z) - 1
    // let p_next = complex_multiply(complex_power(v, 4.), sin(v)) - vec2(1.0, 0.);
    // let p_diff = complex_multiply(4. * complex_power(v, 3.), sin(v)) + complex_multiply(complex_power(v, 4.), cos(v));

    // cosh(z) - 1
    let p_next = cosh_complex(v) - offset;
    let p_diff = sinh_complex(v);
    let v_next = v - complex_divide(p_next, p_diff);
    // if distance(v_next, v) < 0.01 {
    let near_attractor = vec2<f32>(0., round(v_next.y / TAU) * TAU);
    if rect_distance(v_next - near_attractor) < 0.001 {
      return FoldRet(length(v_next), i, near_attractor);
    }
    v = v_next;
  }
  return FoldRet(2000.0, 10u, vec2<f32>(0.0, 0.0));
}


@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  // pixel coordinates
  let coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;
  let p: vec2<f32> = coord * 0.0005 / uniforms.scale;

  let t = uniforms.time;
  let theta = t * 0.0;

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
    let base1 = dot(arm, v1);
    let base2 = dot(arm, v2);
    if abs(base1) <= 4000. && abs(base2) <= 4000. {
      let value = vec4(join_point * 0.0002, 1.0);
      let ret = fold_approach(value.xy);
      let c = fract(f32(ret.step) / 10.0);
      return vec4f(
        fract(ret.value.y * 20.0 + c * 10. + 0.5),
        fract(ret.value.y * 20. + 0.5),
        fract(c * 5.0 + 0.5),
        1.
      );
    }
  }

  return vec4<f32>(0.0, 0.0, 0.0, 0.0);
}
