
#import soluble::perspective

#import soluble::math

#import soluble::mirror

struct Params {
  time: f32,
  dt: f32,
  /// 1 to disable
  // disableLens: f32,
  // maskRadius: f32,
  lifetime: f32,
}

@group(0) @binding(1) var<uniform> params: Params;

struct BaseCell {
  a: vec4<f32>,
  b: vec4<f32>,
 c: vec4<f32>,
};

@group(1) @binding(0) var<storage, read_write> base_points: array<BaseCell>;
@group(1) @binding(1) var<storage, read_write> secondary_points: array<BaseCell>;


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

  var total_color = vec4<f32>(0.2, 0.0, 0.3, 1.0);

  let width = 20.;
  let shift_z = 50.0;

  let d = 26.4;

  var current_viewer = uniforms.viewer_position;
  var current_ray_unit = ray_unit;
  var traveled = 0.0;
  var in_mirror = 0u;

  /// maximum number of reflections
  let max_relect_times = 8u;
  let size = arrayLength(&base_points);
  let segments_size = arrayLength(&secondary_points);

  for (var times = 0u; times < max_relect_times + 1u; times++) {

    var hit_mirror = false;
    var nearest = RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 1000000., vec3<f32>(0.0, 0.0, 0.0));

    for (var mi = 0u; mi < size; mi = mi + 1u) {
      let ceil = base_points[mi];
      let mirror = MirrorTriangle(ceil.a.xyz, ceil.b.xyz, ceil.c.xyz);
      let hit = try_reflect_ray_with_mirror(current_viewer, current_ray_unit, mirror);

      if hit.hit && hit.travel > .01 {
        hit_mirror = true;

        if hit.travel < nearest.travel {
          nearest = hit;
          traveled = hit.travel;
        }
      }
    }


    let t = params.time * 0.000;

    for (var i = 0u; i < segments_size; i = i + 1u) {
      var segment = Segment(secondary_points[i].a.xyz, secondary_points[i].b.xyz);
      // let ray_segment = Segment(ray_unit, ray_unit + ray_unit);
      let reach = ray_closest_point_to_line(current_viewer, current_ray_unit, segment);

      if !reach.positive_side && in_mirror < 1u {
        // I wanted to reduce light from back of camera,
        // however, it does not apply to in-mirror world
        continue;
      }

      if hit_mirror {
        if reach.traveled > traveled {
          continue;
        }
      }

      // let distance = reach.distance;
      // let factor = (0.1 + exp(-traveled));
      // if distance < 0.2 && reach.positive_side {
      //   total_color = vec4<f32>(1.0, 0.8, 0.0, 1.0);
      // }

      let seg_len = length(segment.end - segment.start);
      let distance = max(0.001, reach.distance - 0.6);
      let f = pow(f32(in_mirror) / 2. + 2.0, 3.);
      var color_scale = 1.2 / pow(distance * 0.07 + 0.01, 1.8) / f;
      if seg_len > 2.2 * d {
        color_scale *= .1;
      }

      total_color += vec4<f32>(0.01, 0.02, 0.01, 0.0) * color_scale;
      total_color = min(total_color, vec4<f32>(0.4, 0.7, 0.9, 1.0));
    }

    if hit_mirror {
      total_color += vec4<f32>(0.01, 0.006, .02, 0.);
      current_viewer = nearest.point;
      current_ray_unit = nearest.next_ray_unit;
      in_mirror += 1u;
    } else {
      break;
    }
  }

  return total_color;
}
