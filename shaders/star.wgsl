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
  p1: f32, p2: f32, p3: f32, p4: f32,
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
  var nearest: f32 = 10000.0;
  var total: vec3<f32> = vec3(0.0,0.0,0.0);

  for (var j: u32 = 0u; j < base_size; j++) {
    let base_point = base_points[j];
    let base_position = base_point.position.xyz;

    let view = base_position - uniforms.viewer_position;
    let view_unit = normalize(view);
    let view_length = length(view);
    let cos_value = dot(view_unit, ray_unit);
    if (cos_value < 0.0) {
      continue;
    }
    let sin_value = sqrt(1.0 - cos_value * cos_value);
    if (abs(view_length * sin_value) > 6.0) {
      continue;
    }

    let near_point = uniforms.viewer_position + ray_unit * view_length * cos_value;
    let near_offset = near_point - base_position;
    let near_unit = normalize(near_offset);
    let a = abs(dot(near_unit, uniforms.upward));
    let b = abs(dot(near_unit, uniforms.rightward));
    var ratio = pow((1. - a), 3.0) + pow((1. - b), 3.0);

    nearest = abs(view_length * sin_value);
    var l: f32 = 100.1 / (pow(nearest * 1.6, 2.4) * 2.0 + 1.1) * ratio;
    let color = vec3(l*0.8, l*0.8, l*0.1);
    total = max(total, color);
  }



  return vec4(total, 1.0);
}
