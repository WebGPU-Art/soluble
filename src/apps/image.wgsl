
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


@group(2) @binding(0) var mySampler : sampler;
@group(2) @binding(1) var image_1 : texture_2d<f32>;
@group(2) @binding(2) var image_2 : texture_2d<f32>;
@group(2) @binding(3) var image_3 : texture_2d<f32>;
@group(2) @binding(4) var image_4 : texture_2d<f32>;
@group(2) @binding(5) var image_5 : texture_2d<f32>;
@group(2) @binding(6) var image_6 : texture_2d<f32>;
@group(2) @binding(7) var image_7 : texture_2d<f32>;
@group(2) @binding(8) var image_8 : texture_2d<f32>;
@group(2) @binding(9) var image_9 : texture_2d<f32>;

@compute @workgroup_size(8, 8, 1)
fn compute_main(@builtin(global_invocation_id) global_id: vec3u) {}

// shapes

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

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  // pixel coordinates
  var coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;

  // apply kaleidoscope

  // divide circle by 6 segments
  let parts = 2 + 20. / 60.;
  // let parts = 2. + 1. / 4.;
  // let parts = 2. + 1. / 5.;
  // let parts = 2. + 2. / 3.;
  // let parts = 2. + 2. / 7.;
  // let parts = 2. + 3. / 4.;

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

  let pixel1 = textureSample(image_1, mySampler, fract(small_coord));
  let pixel2 = textureSample(image_2, mySampler, fract(small_coord));
  let pixel3 = textureSample(image_3, mySampler, fract(small_coord));
  let pixel4 = textureSample(image_4, mySampler, fract(small_coord));
  let pixel5 = textureSample(image_5, mySampler, fract(small_coord));
  let pixel6 = textureSample(image_6, mySampler, fract(small_coord));

  let pixel7 = textureSample(image_7, mySampler, small_coord - vec2f(0., 2.));
  let pixel8 = textureSample(image_8, mySampler, small_coord - vec2f(1., 2.));
  let pixel9 = textureSample(image_9, mySampler, small_coord - vec2f(2., 2.));


  let inside_image1 = small_coord.x > 0.0 && small_coord.y > 0. && small_coord.x < 1. && small_coord.y < 1.;
  let inside_image2 = small_coord.x > 1.0 && small_coord.y > 0. && small_coord.x < 2. && small_coord.y < 1.;
  let inside_image3 = small_coord.x > 2.0 && small_coord.y > 0. && small_coord.x < 3. && small_coord.y < 1.;

  let inside_image4 = small_coord.x > 0.0 && small_coord.y > 1. && small_coord.x < 1. && small_coord.y < 2.;
  let inside_image5 = small_coord.x > 1.0 && small_coord.y > 1. && small_coord.x < 2. && small_coord.y < 2.;
  let inside_image6 = small_coord.x > 2.0 && small_coord.y > 1. && small_coord.x < 3. && small_coord.y < 2.;

  let inside_image7 = small_coord.x > 0.0 && small_coord.y > 2. && small_coord.x < 1. && small_coord.y < 3.;
  let inside_image8 = small_coord.x > 1.0 && small_coord.y > 2. && small_coord.x < 2. && small_coord.y < 3.;
  let inside_image9 = small_coord.x > 2.0 && small_coord.y > 2. && small_coord.x < 3. && small_coord.y < 3.;

  if disableLens {
    if inside_image1 {
      return pixel1 * opacity;
    } else if inside_image2 {
      return pixel2 * opacity;
    } else if inside_image3 {
      return pixel3 * opacity;
    } else if inside_image4 {
      return pixel4 * opacity;
    } else if inside_image5 {
      return pixel5 * opacity;
    } else if inside_image6 {
      return pixel6 * opacity;
    } else if inside_image7 {
      return pixel7 * opacity;
    } else if inside_image8 {
      return pixel8 * opacity;
    } else if inside_image9 {
      return pixel9 * opacity;
    } else {
      return  vec4(0.2, 0.2, 0.2, 1.0) * opacity;
    }
  }

  if inside_image1 {
    return pixel1;
  } else if inside_image2 {
    return pixel2;
  } else if inside_image3 {
    return pixel3;
  } else if inside_image4 {
    return pixel4;
  } else if inside_image5 {
    return pixel5;
  } else if inside_image6 {
    return pixel6;
  } else if inside_image7 {
    return pixel7;
  } else if inside_image8 {
    return pixel8;
  } else if inside_image9 {
    return pixel9;
  } else {
    return vec4(0.0, 0.0, 0.0, 0.0);
  }
}
