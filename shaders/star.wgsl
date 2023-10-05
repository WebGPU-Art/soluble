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
  let ray_direction = normalize(
    p.x * uniforms.rightward
    + p.y * uniforms.upward
    + 1.5 * uniforms.forward
  );

  // raymarch
  var tmax: f32 = 2000.0;
  var t: f32 = 0.0;
  var nearest: f32 = 100.0;
  var total: vec3<f32> = vec3(0.0,0.0,0.0);

  for (var i: u32 = 0u; i < 200u; i++) {
    let pos: vec3<f32> = uniforms.viewer_position + t * ray_direction;
    // let h: f32 = map_old(pos); // <---- map
    var h: f32 = 1000000.0;
    for (var j: u32 = 0u; j < base_size; j++) {
      let base_point = base_points[j];
      let relative = pos - base_point.position.xyz;
      let h1 = sd_sphere(relative, 6.);
      if (h1 < h) {
        h = h1;
      }
    }
    if (h < nearest) {
      nearest = h;
    }
    if (h < 0.02 || t > tmax) {
      break;
    }
    t += h;
  }

  // shading/lighting
  var color: vec3<f32> = vec3(0.0);
  if (t < tmax) {
    color = vec3(0.8, 0.1, 0.8);
  }
  let l: f32 = 0.1 / (nearest * 0.1 + 0.001);
  color += vec3(l*0.8, l*0.1, l*0.8);

  // gamma
  color = sqrt(color);
  total += color;

  return vec4(total, 1.0);
}
