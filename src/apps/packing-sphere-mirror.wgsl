#import soluble::perspective
#import soluble::math
#import soluble::mirror

struct Params {
  time: f32,
  dt: f32,
  max_reflections: f32,
}

@group(0) @binding(1) var<uniform> params: Params;

struct BaseCell {
  a: vec4<f32>,
  b: vec4<f32>,
};

@group(1) @binding(0) var<storage, read> base_points: array<BaseCell>;

/// the sphere mirror
struct SphereMirror {
  center: vec3f,
  radius: f32,
  outside: bool,
}

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
  let coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;
  let p: vec2<f32> = coord * 0.0005 / uniforms.scale;

  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  var current_viewer = uniforms.viewer_position;
  var current_ray_unit = ray_unit;
  var in_mirror = 0u;
  var total_color = vec4<f32>(0.0, 0.0, 0.0, 1.0);
  
  let max_relect_times = u32(params.max_reflections);

  let mirrors_size = 8u;
  let gap = 120.0;
  let r = 100.0;

  let mirrors = array<SphereMirror, 8>(
    SphereMirror(vec3f(-gap, -gap, -gap), r, true),
    SphereMirror(vec3f( gap, -gap, -gap), r, true),
    SphereMirror(vec3f(-gap,  gap, -gap), r, true),
    SphereMirror(vec3f( gap,  gap, -gap), r, true),
    SphereMirror(vec3f(-gap, -gap,  gap), r, true),
    SphereMirror(vec3f( gap, -gap,  gap), r, true),
    SphereMirror(vec3f(-gap,  gap,  gap), r, true),
    SphereMirror(vec3f( gap,  gap,  gap), r, true)
  );

  for (var times = 0u; times < max_relect_times + 1u; times++) {
    var hit_mirror = false;
    var nearest = RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 1000000., vec3<f32>(0.0, 0.0, 0.0));
    var mirror_idx = 0u;

    for (var i = 0u; i < mirrors_size; i = i + 1u) {
      let mirror = mirrors[i];
      let hit_sphere = reflect_ray_with_sphere(current_viewer, current_ray_unit, mirror.center, mirror.radius, mirror.outside);
      if hit_sphere.hit && hit_sphere.travel > .01 {
        if hit_sphere.travel < nearest.travel {
          nearest = hit_sphere;
          hit_mirror = true;
          mirror_idx = i;
        }
      }
    }

    if hit_mirror {
      let bounce_fade = 0.8;
      let color_base = 0.5 + 0.5 * cos(params.time * 0.001 + f32(mirror_idx) + vec3(0.0, 2.0, 4.0));
      total_color += vec4(color_base * pow(bounce_fade, f32(in_mirror)), 0.0);
      
      current_viewer = nearest.point;
      current_ray_unit = nearest.next_ray_unit;
      in_mirror += 1u;
      
      if rand11(current_ray_unit.xy + f32(times)) < 0.15 {
        break;
      }
    } else {
      let background = vec4(0.05, 0.05, 0.1, 1.0);
      total_color += background * pow(0.8, f32(in_mirror));
      break;
    }
  }

  return vec4(total_color.rgb, 1.0);
}
