
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


@group(2) @binding(0) var mySampler : sampler;
@group(2) @binding(1) var myTexture : texture_2d<f32>;

@compute @workgroup_size(8, 8, 1)
fn compute_main(@builtin(global_invocation_id) global_id: vec3u) {
}

fn rotate_segment(segment: Segment, center: vec3<f32>, axis: vec3<f32>, angle: f32) -> Segment {
  let next_start = rotate_vec3(segment.start, center, axis, angle);
  let next_end = rotate_vec3(segment.end, center, axis, angle);
  return Segment(next_start, next_end);
}

fn move_segment(segment: Segment, shifts: vec3f) -> Segment {
  let next_start = segment.start + shifts;
  let next_end = segment.end + shifts;
  return Segment(next_start, next_end);
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

  let angle = params.time * 0.0008;

  let image_center = vec3f(20. * cos(angle * 0.7), 20. * sin(angle * 0.7), -120.);
  let image_y = vec3f(0., 1., 0.);
  let image_x = rotate_vec3(vec3f(1., 0., 0.), vec3(0., 0., 0.), image_y, angle);
  let image_z = rotate_vec3(vec3f(0., 0., 1.), vec3(0., 0., 0.), image_y, angle);
  let image_radius = 40.0; // but rect

  let width = 20.;
  let shift_z = 50.0;

  let p1 = vec3f(width, .1, -shift_z);
  let p2 = vec3f(.1, width, -shift_z);
  let p3 = vec3f(-width, 0.1, -shift_z);
  let p4 = vec3f(0.1, - width, -shift_z);

  let segments_size = 4u;
  let scale = 3.;
  let segments = array<Segment, 4>(
    Segment(scale * p1, scale * p2),
    Segment(scale * p2, scale * p3),
    Segment(scale * p3, scale * p4),
    Segment(scale * p4, scale * p1),
    // Segment(vec3(0., 0., 100.), vec3(0., 0., -160.)),
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

    let size = arrayLength(&base_points);
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

    // let view_to_image = image_center - current_viewer;
    // if dot(view_to_image, current_ray_unit) > 0. { // backface culling
    //   let view_to_image_surface_distance = dot(image_z, view_to_image);
    //   let view_hit_image_length = view_to_image_surface_distance / dot(image_z, current_ray_unit);
    //   let hit_image_surface = current_viewer + view_hit_image_length * current_ray_unit - image_center;
    //   let hit_image_surface_x = dot(hit_image_surface, image_x);
    //   let hit_image_surface_y = dot(hit_image_surface, image_y);
    //   let image_coord = vec2f(hit_image_surface_x, hit_image_surface_y) / image_radius;
    //   if abs(image_coord.x) < 1.0 && abs(image_coord.y) < 1.0 {
    //     if view_hit_image_length < nearest.travel { // image is closer than mirror
    //       hit_image = true;
    //       hit_image_at = image_coord * 0.5 + 0.5;
    //       break;
    //     }
    //   }
    // }

    let t = params.time * 0.0008;

    for (var i = 0u; i < segments_size; i = i + 1u) {
      var segment = segments[i];
      segment = rotate_segment(segment, vec3(0., 0., - shift_z), vec3(0., 1., 0.), t);
      segment = move_segment(segment, vec3(2. * sin(t * 0.9), 10. * sin(t * 0.7), 2. * sin(t * 0.6)));
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



  let img_pixel = textureSample(myTexture, mySampler, hit_image_at);

  if hit_image {
    return img_pixel;
  }

  return total_color;
}
