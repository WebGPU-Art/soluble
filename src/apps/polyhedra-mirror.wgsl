#import soluble::perspective
#import soluble::math
#import soluble::mirror

struct Params {
  time: f32,
  dt: f32,
  lifetime: f32,
  max_reflections: f32,
}

@group(0) @binding(1) var<uniform> params: Params;

struct BaseCell {
  a: vec4<f32>,
  b: vec4<f32>,
  c: vec4<f32>,
};

@group(1) @binding(0) var<storage, read> base_points: array<BaseCell>;
@group(1) @binding(1) var<storage, read> secondary_points: array<BaseCell>;

@compute @workgroup_size(8, 8, 1)
fn compute_main(@builtin(global_invocation_id) global_id: vec3u) {}

struct VertexOut {
  @builtin(position) position: vec4<f32>,
  @location(1) uv: vec2<f32>,
};

@vertex
fn vertex_main(@location(0) position: vec2<f32>) -> VertexOut {
  var output: VertexOut;
  output.position = vec4(position, 0.0, 1.0);
  output.uv = vec2<f32>(position.x, position.y);
  return output;
}

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {
  let coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;
  let p: vec2<f32> = coord * 0.0005 / uniforms.scale;
  let ray_unit = normalize(p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward);

  var total_color = vec4<f32>(0.03, 0.03, 0.07, 1.0);
  let color_cap = vec4<f32>(0.78, 0.93, 0.96, 1.0);
  let base_light = vec4<f32>(0.009, 0.02, 0.024, 0.0);
  let bounce_tint = vec4<f32>(0.012, 0.008, 0.018, 0.0);

  var current_viewer = uniforms.viewer_position;
  var current_ray_unit = ray_unit;
  var in_mirror = 0u;

  let max_reflect_times = u32(params.max_reflections);
  let size = arrayLength(&base_points);
  let segments_size = arrayLength(&secondary_points);

  for (var times = 0u; times < max_reflect_times + 1u; times++) {
    if all(total_color.rgb >= color_cap.rgb) { break; }

    var hit_mirror = false;
    var nearest = RayMirrorHit(false, vec3<f32>(0.0), 1000000.0, vec3<f32>(0.0));

    for (var mi = 0u; mi < size; mi = mi + 1u) {
      let cell = base_points[mi];
      let mirror = MirrorTriangle(cell.a.xyz, cell.b.xyz, cell.c.xyz);
      let hit = try_reflect_ray_with_mirror(current_viewer, current_ray_unit, mirror);

      if hit.hit && hit.travel > 0.01 && hit.travel < nearest.travel {
        hit_mirror = true;
        nearest = hit;
      }
    }

    let first_bounce = in_mirror == 0u;
    let attenuation = pow(f32(in_mirror) / 2.0 + 2.0, 3.0);

    for (var i = 0u; i < segments_size; i = i + 1u) {
      let segment = Segment(secondary_points[i].a.xyz, secondary_points[i].b.xyz);
      let reach = ray_closest_point_to_line(current_viewer, current_ray_unit, segment);

      if hit_mirror && reach.traveled > nearest.travel { continue; }
      if first_bounce && !reach.positive_side { continue; }

      let distance = max(0.001, reach.distance - 0.42);
      let color_scale = 1.5 / pow(distance * 0.06 + 0.01, 1.8) / attenuation;

      total_color += base_light * color_scale;
      total_color = min(total_color, color_cap);
    }

    if hit_mirror {
      if rand11(dot(vx_out.uv, vec2f(127.1, 311.7)) + f32(times) * 43.7) < 0.15 { break; }
      total_color += bounce_tint;
      current_viewer = nearest.point;
      current_ray_unit = nearest.next_ray_unit;
      in_mirror += 1u;
    } else {
      break;
    }
  }

  return total_color;
}