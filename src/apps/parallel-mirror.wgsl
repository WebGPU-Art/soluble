
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
};

@group(1) @binding(0) var<storage, read_write> base_points: array<BaseCell>;


@compute @workgroup_size(8, 8, 1)
fn compute_main(@builtin(global_invocation_id) global_id: vec3u) {
  // not doint things
}


// fn move_segment(segment: Segment, shifts: vec3f) -> Segment {
//   let next_start = segment.start + shifts;
//   let next_end = segment.end + shifts;
//   return Segment(next_start, next_end);
// }


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

/// maximum number of reflections
const max_relect_times = 20u;

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

  let shift_z = 8.0;

  let m_base = 100.;
  let m1 = vec3f(m_base * 2., m_base, 1. * shift_z);
  let m2 = vec3f(-m_base * 2., m_base, 1. * shift_z);
  let m3 = vec3f(m_base * 2., -m_base, 1. * shift_z);
  let m4 = vec3f(-m_base * 2., -m_base, 1. * shift_z);

  let m5 = vec3f(m_base * 2., m_base, -1. * shift_z);
  let m6 = vec3f(-m_base * 2., m_base, -1. * shift_z);
  let m7 = vec3f(m_base * 2., -m_base, -1. * shift_z);
  let m8 = vec3f(-m_base * 2., -m_base, -1. * shift_z);

  let mirrors_size = 4u;
  let mirrors = array<MirrorTriangle, 4>(
    MirrorTriangle(m1, m2, m3),
    MirrorTriangle(m2, m3, m4),
    MirrorTriangle(m5, m6, m7),
    MirrorTriangle(m6, m7, m8),
  );

  var current_viewer = uniforms.viewer_position;
  var current_ray_unit = ray_unit;
  var traveled = 0.0;
  var in_mirror = 0u;

  var hit_image_at = vec2<f32>(0.0, 0.0);
  var hit_image = false;

  for (var times = 0u; times < max_relect_times + 1u; times++) {

    var hit_mirror = false;
    var nearest = RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 1000000., vec3<f32>(0.0, 0.0, 0.0));


    for (var mi = 0u; mi < mirrors_size; mi = mi + 1u) {
      let mirror = mirrors[mi];
      let hit = try_reflect_ray_with_mirror(current_viewer, current_ray_unit, mirror);

      if hit.hit && hit.travel > .01 {
        hit_mirror = true;

        if hit.travel < nearest.travel {
          nearest = hit;
          traveled = hit.travel;
        }
      }
    }

    // let t = params.time * 0.0008;

    let s_size = arrayLength(&base_points);
    for (var i = 0u; i < s_size; i = i + 1u) {
      var segment = Segment(
        base_points[i].a.xyz,
        base_points[i].b.xyz
      );
      // segment = move_segment(segment, vec3(10. * sin(t * 0.9), 10. * sin(t * 0.7), 10. * sin(t * 0.6)));
      let reach = ray_closest_point_to_line(current_viewer, current_ray_unit, segment);

      if !reach.positive_side && in_mirror < 1u {
        // I want to reduce light from back of camera,
        // however, it does not apply to in-mirror world
        continue;
      }

      if hit_mirror {
        if reach.traveled > traveled {
          continue;
        }
      }

      let distance = max(0., reach.distance - 0.6);
      let f = pow(f32(in_mirror) / 2. + 2.0, 3.);
      total_color += vec4<f32>(0.01, 0.02, 0.01, 0.0) * 1.2 / pow(distance * 0.07 + 0.01, 1.8) / f;
      total_color = min(total_color, vec4<f32>(0.4, 1.0, 0., 1.0));
    }

    if hit_mirror {
      total_color += vec4<f32>(0.01, 0.006, .2, 0.) ;
      current_viewer = nearest.point;
      current_ray_unit = nearest.next_ray_unit;
      in_mirror += 1u;
    } else {
      break;
    }
  }

  return total_color;
}
