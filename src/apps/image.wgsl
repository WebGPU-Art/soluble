
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


@group(2) @binding(0) var mySampler : sampler;
@group(2) @binding(1) var myTexture : texture_2d<f32>;
@group(2) @binding(2) var image2 : texture_2d<f32>;
@group(2) @binding(3) var image_bubbles : texture_2d<f32>;
@group(2) @binding(4) var image_rugs : texture_2d<f32>;

@compute @workgroup_size(8, 8, 1)
fn compute_main(@builtin(global_invocation_id) global_id: vec3u) {}

// shapes

const PI = 3.14159265358532374;

fn product(a: vec2f, b: vec2f) -> vec2f {
  return vec2f(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

fn conjugate(a: vec2f) -> vec2f {
  return vec2f(a.x, -a.y);
}

fn divide(a: vec2f, b: vec2f) -> vec2f {
  let l_square_inverse = 1. / (b.x * b.x + b.y * b.y);
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
  // let parts = 2.286;
  let parts = 2.333;

    // radius of the circle containing the shape
  let radius = 800.;
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
    for (var i = 0u; i < 32u; i++) {
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

  let viewer_position = uniforms.viewer_position;

  let image_at = vec3(0., 0., -100.);
  let image_normal = vec3(0., 0., 1.);
  let cos_theta = dot(ray_unit, image_normal);
  let connect = image_at - viewer_position;
  let distance_to_hit = dot(connect, image_normal) / cos_theta;
  let hit = viewer_position + distance_to_hit * ray_unit;


  let small_coord = hit.xy / 500.0;

  let pixel = textureSample(myTexture, mySampler, small_coord);
  let pixel2 = textureSample(image2, mySampler, small_coord - vec2f(1., 1.));
  let pixel3 = textureSample(image_bubbles, mySampler, small_coord - vec2f(1., 0.));
  let pixel4 = textureSample(image_rugs, mySampler, small_coord - vec2f(0., 1.));

  let inside_image = small_coord.x > 0.0 && small_coord.y > 0. && small_coord.x < 1. && small_coord.y < 1.;
  let inside_image2 = small_coord.x > 1.0 && small_coord.y > 1. && small_coord.x < 2. && small_coord.y < 2.;
  let inside_image3 = small_coord.x > 1.0 && small_coord.y > 0. && small_coord.x < 2. && small_coord.y < 1.;
  let inside_image4 = small_coord.x > 0.0 && small_coord.y > 1. && small_coord.x < 1. && small_coord.y < 2.;

  if disableLens {
    if inside_image {
      return pixel * opacity;
    } else if inside_image2 {
      return pixel2 * opacity;
    } else if inside_image3 {
      return pixel3 * opacity;
    } else if inside_image4 {
      return pixel4 * opacity;
    } else {
      return  vec4(0.2, 0.2, 0.2, 1.0) * opacity;
    }
  }

  if inside_image {
    return pixel;
  } else if inside_image2 {
    return pixel2;
  } else if inside_image3 {
    return pixel3;
  } else if inside_image4 {
    return pixel4;
  } else {
    return vec4(0.0, 0.0, 0.0, 0.0);
  }
}
