
#import soluble::perspective

#import soluble::math

#import soluble::mirror

// 4 spheres on elliptical orbits, each with different semi-axes, period, and phase.
// All orbits lie in tilted planes so they spread through 3-D space.
// Spheres reflect each other up to max_reflect_times; no secondary light segments —
// the spheres themselves are the light source (additive glow on each bounce).

struct Params {
  time: f32,
  dt: f32,
  max_reflections: f32,
}

@group(0) @binding(1) var<uniform> params: Params;

struct BaseCell {
  a: vec4<f32>,
  b: vec4<f32>,
  c: vec4<f32>,
};

// base_points is present but unused here (we compute sphere positions analytically)
@group(1) @binding(0) var<storage, read_write> base_points: array<BaseCell>;


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

struct Sphere {
  center: vec3f,
  radius: f32,
  color:  vec3f,   // tint added per bounce
}

// Kepler-style ellipse in a tilted plane.
// a = semi-major, b = semi-minor, omega = angular frequency (rad/ms).
// The orbit plane is defined by two basis vectors u, v.
fn ellipse_pos(a: f32, b: f32, omega: f32, phase: f32, t: f32, u: vec3f, v: vec3f) -> vec3f {
  let angle = omega * t + phase;
  return a * cos(angle) * u + b * sin(angle) * v;
}

fn make_spheres(t: f32) -> array<Sphere, 6> {
  let ms = t * 0.05;

  let c0 = ellipse_pos(220., 140., 0.0013, 0.00, ms, vec3f(1,0,0), vec3f(0,1,0));
  let c1 = ellipse_pos(170., 160., 0.0009, 1.57, ms, vec3f(1,0,0), vec3f(0,0,1));
  let c2 = ellipse_pos(260., 110., 0.0007, 3.14, ms, normalize(vec3f(1,1,0)), normalize(vec3f(0,0,1)));
  let c3 = ellipse_pos(150., 200., 0.0011, 4.71, ms, normalize(vec3f(0,1,1)), normalize(vec3f(1,0,0)));
  let c4 = ellipse_pos(200., 130., 0.0015, 0.78, ms, normalize(vec3f(1,0,1)), normalize(vec3f(0,1,0)));
  let c5 = ellipse_pos(180., 180., 0.0008, 2.36, ms, normalize(vec3f(1,-1,0)), normalize(vec3f(0,0,1)));

  return array<Sphere, 6>(
    Sphere(c0, 100., vec3f(0.20, 0.20, 0.20)),
    Sphere(c1,  60., vec3f(0.24, 0.24, 0.24)),
    Sphere(c2, 135., vec3f(0.14, 0.14, 0.14)),
    Sphere(c3,  75., vec3f(0.22, 0.22, 0.22)),
    Sphere(c4,  90., vec3f(0.16, 0.16, 0.16)),
    Sphere(c5,  50., vec3f(0.26, 0.26, 0.26)),
  );
}

const MAX_REFLECT = 8u;

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  let coord    = vx_out.uv * uniforms.screen_wh;
  let p        = coord * 0.0005 / uniforms.scale;

  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  var total_color = vec4<f32>(0.06, 0.03, 0.10, 1.0);

  let spheres = make_spheres(params.time);

  var current_viewer   = uniforms.viewer_position;
  var current_ray_unit = ray_unit;
  var in_mirror        = 0u;

  for (var times = 0u; times < MAX_REFLECT + 1u; times++) {

    var hit_any    = false;
    var nearest    = RayMirrorHit(false, vec3f(0.), 1000000., vec3f(0.));
    var hit_tint   = vec3f(0.);

    for (var i = 0u; i < 6u; i = i + 1u) {
      let sp  = spheres[i];
      let hit = reflect_ray_with_sphere(current_viewer, current_ray_unit,
                                        sp.center, sp.radius, true);
      if hit.hit && hit.travel > 0.5 && hit.travel < nearest.travel {
        hit_any  = true;
        nearest  = hit;
        hit_tint = sp.color;
      }
    }

    if hit_any {
      let depth_factor = 1.0 / sqrt(f32(in_mirror + 1u));
      total_color    += vec4f(hit_tint * depth_factor, 0.0);
      total_color     = min(total_color, vec4f(0.95, 0.95, 0.95, 1.0));

      current_viewer   = nearest.point;
      current_ray_unit = nearest.next_ray_unit;
      in_mirror       += 1u;
    } else {
      break;
    }
  }

  return total_color;
}
