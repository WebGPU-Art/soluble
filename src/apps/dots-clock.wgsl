#import soluble::perspective

struct Params {
  animating: f32,
  active_count: f32,
  total_count: f32,
}

@group(0) @binding(1) var<uniform> params: Params;

struct BaseCell {
  position: vec4<f32>,
  p1: f32, p2: f32, p3: f32, p4: f32,
};

@group(1) @binding(0) var<storage, read> base_points: array<BaseCell>;

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

const PI = 3.14159265368932374;
const CLOCK_MIN = vec2<f32>(-1.22, -0.36);
const CLOCK_MAX = vec2<f32>(1.55, 0.34);
const IDLE_MIN = vec2<f32>(-0.34, -0.61);
const IDLE_MAX = vec2<f32>(0.50, -0.33);
const ANIMATION_MIN = vec2<f32>(-1.22, -0.64);
const ANIMATION_MAX = vec2<f32>(1.55, 0.34);

fn in_rect(p: vec2<f32>, min_p: vec2<f32>, max_p: vec2<f32>) -> bool {
  return p.x >= min_p.x && p.x <= max_p.x && p.y >= min_p.y && p.y <= max_p.y;
}

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  // pixel coordinates
  let coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;
  let p: vec2<f32> = coord * 0.0005 / uniforms.scale;
  let background = vec3(0.05, 0.05, 0.08);
  let in_clock = in_rect(p, CLOCK_MIN, CLOCK_MAX);
  let in_idle = in_rect(p, IDLE_MIN, IDLE_MAX);
  let is_animating = params.animating > 0.5;

  if is_animating {
    if !in_rect(p, ANIMATION_MIN, ANIMATION_MAX) {
      return vec4(background, 1.0);
    }
  } else if !in_clock && !in_idle {
    return vec4(background, 1.0);
  }

  var base_size = arrayLength(&base_points);
  let active_count = min(u32(params.active_count), base_size);
  var point_start = 0u;
  var point_end = base_size;

  if !is_animating {
    if in_clock {
      point_end = active_count;
    } else {
      point_start = active_count;
    }
  }

  // raymarch
  var total: vec3<f32> = vec3(0.0, 0.0, 0.0);
  let base_color = vec3(0.18, 1.0, 0.58);
  let pulse = sin(uniforms.time * 1.5) * 0.04 + 0.96;
  let color_factor = 0.77 * pulse; // DOT_BRIGHTNESS(7) * 0.11 * pulse

  for (var j: u32 = point_start; j < point_end; j++) {
    // position.xy = pre-projected screen coords, position.z = screen radius
    let pt = base_points[j].position;
    let delta = pt.xy - p;
    let r = pt.z;
    let dist2 = dot(delta, delta);
    let r2 = r * r;

    if dist2 > r2 {
      continue;
    }

    let distance_factor = 1.0 - dist2 / r2;
    total += base_color * (distance_factor * color_factor);
  }

  total = total + background;

  return vec4(total, 1.0);
}