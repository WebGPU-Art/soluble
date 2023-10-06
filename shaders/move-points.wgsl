
struct BaseCell {
  position: vec4<f32>,
  velocity: vec4<f32>,
  // offset
  p1: f32,
  // duration
  p2: f32,
  p3: f32,
  p4: f32,
};

@group(0) @binding(0)
var<storage, read_write> base_points: array<BaseCell>;

struct Params {
  time: f32,
  dt: f32,
  p1: f32,
  p2: f32,
}

@group(0) @binding(1)
var<uniform> params: Params;

@compute @workgroup_size(256, 1, 1)
fn main(@builtin(global_invocation_id) global_id : vec3u) {
  var index = global_id.x + global_id.y * 8u;
  // base_points[index].position.x = base_points[index].position.x;
  base_points[index].p3 = sin(base_points[index].p1 + base_points[index].p2 * 0.001 * params.time) * 0.4 + 0.6;
  base_points[index].p4 = params.time;
}