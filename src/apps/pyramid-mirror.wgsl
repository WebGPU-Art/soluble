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
fn compute_main(@builtin(global_invocation_id) global_id: vec3u) {
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

  // create view ray
  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  var total_color = vec4<f32>(0.05, 0.0, 0.12, 1.0);

  let max_seg_len = 300.0;
  // warm golden tones for pyramid interior
  let color_cap = vec4<f32>(0.9, 0.7, 0.3, 1.0);

  var current_viewer = uniforms.viewer_position;
  var current_ray_unit = ray_unit;
  var in_mirror = 0u;

  let max_reflect_times = u32(params.max_reflections);
  let size = arrayLength(&base_points);
  let segments_size = arrayLength(&secondary_points);

  for (var times = 0u; times < max_reflect_times + 1u; times++) {

    // Early exit: color already saturated
    if all(total_color.rgb >= color_cap.rgb) {
      break;
    }

    var hit_mirror = false;
    var nearest = RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 1000000., vec3<f32>(0.0, 0.0, 0.0));

    for (var mi = 0u; mi < size; mi = mi + 1u) {
      let ceil = base_points[mi];
      let mirror = MirrorTriangle(ceil.a.xyz, ceil.b.xyz, ceil.c.xyz);
      let hit = try_reflect_ray_with_mirror(current_viewer, current_ray_unit, mirror);

      if hit.hit && hit.travel > 0.01 && hit.travel < nearest.travel {
        hit_mirror = true;
        nearest = hit;
      }
    }

    // loop-invariant: whether back-facing cull is needed this bounce
    let first_bounce = in_mirror == 0u;
    let f = pow(f32(in_mirror) / 2.0 + 2.0, 3.0);

    for (var i = 0u; i < segments_size; i = i + 1u) {
      var segment = Segment(secondary_points[i].a.xyz, secondary_points[i].b.xyz);
      let reach = ray_closest_point_to_line(current_viewer, current_ray_unit, segment);

      // cheapest checks first:
      // 1. traveled-distance cull (single float compare)
      if hit_mirror && reach.traveled > nearest.travel { continue; }
      // 2. back-of-camera cull (only outside mirror world)
      if first_bounce && !reach.positive_side { continue; }

      let seg_len = length(segment.end - segment.start);
      let distance = max(0.001, reach.distance - 0.5);
      var color_scale = 1.4 / pow(distance * 0.06 + 0.01, 1.8) / f;
      if seg_len > max_seg_len {
        color_scale *= 0.1;
      }

      // warm golden glow: red channel dominant, then green
      total_color += vec4<f32>(0.02, 0.014, 0.004, 0.0) * color_scale;
      total_color = min(total_color, color_cap);
    }

    if hit_mirror {
      if rand11(dot(vx_out.uv, vec2f(127.1, 311.7)) + f32(times) * 43.7) < 0.15 { break; }
      // add a slight warm tint on each reflection
      total_color += vec4<f32>(0.024, 0.012, 0.003, 0.0);
      current_viewer = nearest.point;
      current_ray_unit = nearest.next_ray_unit;
      in_mirror += 1u;
    } else {
      break;
    }
  }

  return total_color;
}
