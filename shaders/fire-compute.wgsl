
struct BaseCell {
  position: vec4<f32>,
  velocity: vec4<f32>,
  arm: vec4<f32>,
  // offset
  offset: f32,
  // duration
  duration: f32,
  p3: f32,
  time: f32,

  // extend params
  p5: f32,
  p6: f32,
  p7: f32,
  p8: f32,
};

@group(0) @binding(0)
var<storage, read_write> base_points: array<BaseCell>;

struct Params {
  time: f32,
  dt: f32,
  offset: f32,
  p2: f32,
}

@group(0) @binding(1)
var<uniform> params: Params;

@compute @workgroup_size(8, 8, 1)
fn main(@builtin(global_invocation_id) global_id: vec3u) {
  var index = global_id.x + global_id.y * 8u;
  base_points[index].position.y += params.dt * 0.03 * base_points[index].velocity.y;
  if base_points[index].position.y > 200. {
    base_points[index].position.y = -200.;
  }
  base_points[index].position.x = base_points[index].position.x;
  // base_points[index].p3 = sin(base_points[index].offset + base_points[index].duration * 0.001 * params.time) * 0.4 + 0.6;
  // base_points[index].time = params.time;
}