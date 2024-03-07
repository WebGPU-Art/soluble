
struct UniformsData {
  screen_wh: vec2<f32>,
  scale: f32,
  time: f32,
  forward: vec3<f32>,
  // direction up overhead, better unit vector
  upward: vec3<f32>,
  rightward: vec3<f32>,
  viewer_position: vec3<f32>,
};

@group(0) @binding(0) var<uniform> uniforms: UniformsData;
