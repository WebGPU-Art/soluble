#import soluble::perspective
#import soluble::math
#import soluble::mirror

struct Params {
  time: f32,
  dt: f32,
  lifetime: f32,
  max_reflections: f32,
  lr: f32,
  lg: f32,
  lb: f32,
  br: f32,
  bg: f32,
  bb: f32,
  eta: f32,
  transmit: f32,
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
fn compute_main(@builtin(global_invocation_id) global_id: vec3u) {}

struct VertexOut {
  @builtin(position) position: vec4<f32>,
  @location(1) uv: vec2<f32>,
};

struct GlassHit {
  hit: bool,
  point: vec3<f32>,
  travel: f32,
  normal: vec3<f32>,
  reflected: vec3<f32>,
  refracted: vec3<f32>,
  fresnel: f32,
  tir: bool,
};

@vertex
fn vertex_main(@location(0) position: vec2<f32>) -> VertexOut {
  var output: VertexOut;
  output.position = vec4(position, 0.0, 1.0);
  output.uv = vec2<f32>(position.x, position.y);
  return output;
}

fn schlick(cos_theta: f32, n1: f32, n2: f32) -> f32 {
  let r0 = pow((n1 - n2) / (n1 + n2), 2.0);
  return r0 + (1.0 - r0) * pow(1.0 - cos_theta, 5.0);
}

fn try_hit_glass(viewer_position: vec3f, ray_unit: vec3f, mirror: MirrorTriangle, eta_glass: f32) -> GlassHit {
  let raw_normal = normalize(cross(mirror.b - mirror.a, mirror.c - mirror.a));
  let denom = dot(raw_normal, ray_unit);
  if abs(denom) < 0.0001 {
    return GlassHit(false, vec3<f32>(0.0), 0.0, vec3<f32>(0.0), vec3<f32>(0.0), vec3<f32>(0.0), 0.0, false);
  }

  let t = dot(raw_normal, mirror.a - viewer_position) / denom;
  if t < 0.01 {
    return GlassHit(false, vec3<f32>(0.0), 0.0, vec3<f32>(0.0), vec3<f32>(0.0), vec3<f32>(0.0), 0.0, false);
  }

  let hit_point = viewer_position + t * ray_unit;
  let spin_a = cross(hit_point - mirror.a, mirror.b - mirror.a);
  let spin_b = cross(hit_point - mirror.b, mirror.c - mirror.b);
  let spin_c = cross(hit_point - mirror.c, mirror.a - mirror.c);
  let inside = dot(spin_a, spin_b) > 0.0 && dot(spin_b, spin_c) > 0.0 && dot(spin_c, spin_a) > 0.0;
  if !inside {
    return GlassHit(false, vec3<f32>(0.0), 0.0, vec3<f32>(0.0), vec3<f32>(0.0), vec3<f32>(0.0), 0.0, false);
  }

  var normal = raw_normal;
  var n1 = 1.0;
  var n2 = eta_glass;
  if dot(ray_unit, normal) > 0.0 {
    normal = -normal;
    n1 = eta_glass;
    n2 = 1.0;
  }

  let eta = n1 / n2;
  let reflected = normalize(reflect_on_direction(ray_unit, normal));
  let raw_refracted = refract(ray_unit, normal, eta);
  let tir = dot(raw_refracted, raw_refracted) < 0.00001;
  let refracted = normalize(select(raw_refracted, reflected, tir));
  let fresnel = select(schlick(abs(dot(-ray_unit, normal)), n1, n2), 1.0, tir);
  return GlassHit(true, hit_point, t, normal, reflected, refracted, fresnel, tir);
}

fn sample_segments(origin: vec3f, ray_unit: vec3f, stop_at: f32, attenuation: f32, require_front: bool, offset: f32) -> f32 {
  var glow = 0.0;
  let segments_size = arrayLength(&secondary_points);
  for (var i = 0u; i < segments_size; i = i + 1u) {
    if rand11(f32(i) * 17.31 + dot(origin.xy, vec2f(0.031, 0.047)) + dot(ray_unit.xy, vec2f(11.7, 5.3))) < 0.15 {
      continue;
    }

    let segment = Segment(secondary_points[i].a.xyz, secondary_points[i].b.xyz);
    let reach = ray_closest_point_to_line(origin, ray_unit, segment);

    if require_front && !reach.positive_side { continue; }
    if stop_at > 0.0 && reach.traveled > stop_at { continue; }

    let distance = max(0.001, reach.distance - offset);
    let core = 0.85 / pow(distance * 0.16 + 0.012, 2.25);
    let halo = 0.18 / pow(distance * 0.055 + 0.04, 1.45);
    glow += (core + halo) / attenuation;
  }
  return glow;
}

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {
  let coord = vx_out.uv * uniforms.screen_wh;
  let p = coord * 0.0005 / uniforms.scale;
  let ray_unit = normalize(p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward);

  let base_light = vec3<f32>(params.lr, params.lg, params.lb);
  let bounce_tint = vec3<f32>(params.br, params.bg, params.bb);
  let color_cap = vec3<f32>(0.82, 0.92, 1.0);

  var total_color = vec3<f32>(0.006, 0.010, 0.024);
  total_color += vec3<f32>(0.004, 0.006, 0.010) * (0.5 + 0.5 * vx_out.uv.y);

  var current_viewer = uniforms.viewer_position;
  var current_ray_unit = ray_unit;

  let max_reflect_times = u32(params.max_reflections);
  let size = arrayLength(&base_points);

  for (var times = 0u; times < max_reflect_times + 1u; times++) {
    if all(total_color >= color_cap) { break; }

    var nearest = GlassHit(false, vec3<f32>(0.0), 1000000.0, vec3<f32>(0.0), vec3<f32>(0.0), vec3<f32>(0.0), 0.0, false);
    for (var mi = 0u; mi < size; mi = mi + 1u) {
      let cell = base_points[mi];
      let mirror = MirrorTriangle(cell.a.xyz, cell.b.xyz, cell.c.xyz);
      let hit = try_hit_glass(current_viewer, current_ray_unit, mirror, params.eta);
      if hit.hit && hit.travel < nearest.travel {
        nearest = hit;
      }
    }

    let attenuation = pow(f32(times) / 2.0 + 1.45, 2.05);
    let line_glow = sample_segments(current_viewer, current_ray_unit, select(-1.0, nearest.travel, nearest.hit), attenuation, times == 0u, 0.22);
    total_color += base_light * line_glow;

    if !nearest.hit { break; }

    let reflect_weight = clamp(nearest.fresnel + (1.0 - params.transmit) * 0.55, 0.06, 0.96);
    let transmit_weight = (1.0 - reflect_weight) * params.transmit;

    let reflected_probe = sample_segments(nearest.point + nearest.reflected * 0.18, nearest.reflected, -1.0, attenuation * 1.35, true, 0.22);
    let refracted_probe = sample_segments(nearest.point + nearest.refracted * 0.18, nearest.refracted, -1.0, attenuation * 1.45, true, 0.22);

    total_color += base_light * (reflected_probe * 0.26 * reflect_weight + refracted_probe * 0.38 * transmit_weight);
    total_color += bounce_tint * (0.12 + 0.18 * reflect_weight);
    total_color = min(total_color, color_cap);

    let reflect_score = reflected_probe * reflect_weight;
    let refract_score = refracted_probe * max(0.05, transmit_weight);
    let choose_reflect = nearest.tir || reflect_score >= refract_score;
    current_ray_unit = select(nearest.refracted, nearest.reflected, choose_reflect);
    current_viewer = nearest.point + current_ray_unit * 0.35;
  }

  return vec4(total_color, 1.0);
}