
#import soluble::perspective

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
  // var index = global_id.x + global_id.y * 8u;
  // base_points[index].position.y += params.dt * 0.03 * base_points[index].velocity.y;
  // if base_points[index].position.y > 200. {
  //   base_points[index].position.y = -200.;
  // }
  // base_points[index].position.x = base_points[index].position.x;
  // base_points[index].p3 = sin(base_points[index].offset + base_points[index].duration * 0.001 * params.time) * 0.4 + 0.6;
  // base_points[index].time = params.time;
}

// shapes

const PI = 3.14159265358532374;

// fn square(x: f32) -> f32 {
//   return x * x;
// }

fn product(a: vec2f, b: vec2f) -> vec2f {
  return vec2f(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

fn conjugate(a: vec2f) -> vec2f {
  return vec2f(a.x, - a.y);
}

fn divide(a: vec2f, b: vec2f) -> vec2f {
  let l_square_inverse = 1. / b.x * b.x + b.y * b.y;
  return vec2f(((a.x * b.x + a.y * b.y) * l_square_inverse), ((a.y * b.x - a.x * b.y) * l_square_inverse));
}

fn perpendicular(p: vec2f, p1: vec2f, p2: vec2f) -> vec2f {
  let x = p.x;
  let y = p.y;
  let a = p1.x;
  let b = p1.y;
  let c = p2.x;
  let d = p2.y;
    // corrected with https://blog.csdn.net/qq_32867925/article/details/114294753
  let k = - ((a - x) * (c - a) + (b - y) * (d - b)) / ((a - c) * (a - c) + (b - d) * (b - d));
  return vec2f(a + (c - a) * k, b + (d - b) * k);
}

fn is_outside_line(p: vec2f, p1: vec2f, p2: vec2f) -> bool {
  let perp = perpendicular(p, p1, p2);
  let l = length(perp);
  return product(p, conjugate(perp)).x > (l * l);
}


fn reflection_line(p: vec2f, p1: vec2f, p2: vec2f, skip: f32, regress: f32) -> vec2f {
  let perp = perpendicular(p, p1, p2);
  let d = perp - p;
  let ld = length(d);
  return perp + (d + (-skip * d / ld)) * regress;
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

fn rand11(n: f32) -> f32 { return fract(sin(n) * 43758.5453123); }

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  // pixel coordinates
  var coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;

  // apply kaleidoscope

    // divide circle by 6 segments
  let parts = 2.5;

    // radius of the circle containing the shape
  let radius = 500.;
  let unit = 2.0 * PI / parts;
  let spin = 0.0;

  let shape_spin = 0.0;
  let move_x = 0.0;
  let scale = 1.0;
  // let shift = vec2(0., 0.);


  // raymarch
  var opacity = 1.0;

  let disableLens = params.disableLens > 0.5;
  if length(coord) < radius * 22.0 {
    for (var i = 0u; i < 6u; i++) {
      let point_angle = atan2(coord.y, coord.x);
      let at_part = floor(point_angle / unit);
      let p1 = vec2(cos(at_part * unit), sin(at_part * unit)) * radius;

      let p2 = vec2(cos((at_part + 1.0) * unit), sin((at_part + 1.0) * unit)) * radius;

      let perp = perpendicular(coord, p1, p2);

      if is_outside_line(coord, p1, p2) {
        if disableLens {
          opacity = 0.5;
        } else {
          coord = reflection_line(coord, p1, p2, 0.0, 1.);
        }
        continue;
      } else {
        // let spin_rot = vec2(cos(spin), sin(spin));
        // coord = product((coord / scale), spin_rot);
        break;
      }
    }
  }


  // paint

  let p: vec2<f32> = coord * 0.0005 / uniforms.scale;

  var base_size = arrayLength(&base_points);

  // create view ray
  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  // return vec4f(1., 1., 0.7, 2.) - textureSample(myTexture, mySampler, vtx_out.uv);

  let viewer_position = uniforms.viewer_position;
  for (var j: u32 = 0u; j < base_size; j++) {
    let base_point = base_points[j];
    // let scale = 1.;
    // base_position.x *= scale;
    // base_position.z *= scale;
    let a = base_point.position.xyz - viewer_position;


    // display ciecles

    let n1 = cross(a, ray_unit);
    let n2 = normalize(cross(ray_unit, n1));
    let d = abs(dot(n2, a));

    let r = 400.;
    if d < r && d > (r * pow(params.maskRadius, 0.5)) {
      let idx = base_point.idx;
      let light = vec3<f32>(rand11(idx + 1.0), rand11(idx + 2.0), rand11(idx + 3.0));
      return vec4(light * opacity, 1.0);
    } else {
      continue;
    }


    // // display lines

    // // find perp direction and projection length on it
    // let arm = base_point.arm.xyz;
    // let n = cross(arm, ray_unit);

    // let n0 = normalize(n);
    // let d_min = abs(dot(n0, a));

    // if d_min > 16.0 * params.maskRadius {
    //   // too far from ray, contribute no light
    //   continue;
    // }

    // let idx = base_point.idx;
    // let light = vec3<f32>(rand11(idx + 1.0), rand11(idx + 2.0), rand11(idx + 3.0));
    // return vec4(light * opacity, 1.0);
  }

  if opacity > 0.9 {
    return vec4(0.0, 0.0, 0.0, 0.0);
  } else {
    return vec4(0.2, 0.2, 0.2, 1.0);
  }
}