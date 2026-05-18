#import soluble::perspective
#import soluble::mirror

const MAX_BRANCH_RAYS = 96u;
const MIN_BRANCH_WEIGHT = 0.0005;
const SURFACE_EPSILON = 0.12;
const STOP_MARGIN = 0.25;

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

@group(1) @binding(0) var<storage, read> base_points: array<BaseCell>;
@group(1) @binding(1) var<storage, read> secondary_points: array<BaseCell>;

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

struct RayState {
  origin: vec3<f32>,
  direction: vec3<f32>,
  throughput: vec3<f32>,
  inside: bool,
  depth: u32,
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

fn max_component(v: vec3<f32>) -> f32 {
  return max(v.x, max(v.y, v.z));
}

fn glass_transmittance(distance: f32) -> vec3<f32> {
  let absorb = vec3<f32>(0.00055, 0.00035, 0.00022);
  return exp(-absorb * max(distance, 0.0));
}

fn sample_segments(origin: vec3f, ray_unit: vec3f, stop_at: f32, attenuation: f32, throughput: vec3<f32>, inside: bool, depth: u32, offset: f32) -> vec3<f32> {
  var glow = vec3<f32>(0.0);
  // Approximate the camera pixel footprint so high-order virtual images do not collapse below one sample.
  let footprint = offset + min(0.035 + 0.075 * f32(depth), 0.42);
  let visibility_boost = 1.0 + min(0.4 * f32(depth), 2.8);
  let segments_size = arrayLength(&secondary_points);
  for (var i = 0u; i < segments_size; i = i + 1u) {
    let segment = Segment(secondary_points[i].a.xyz, secondary_points[i].b.xyz);
    let reach = ray_closest_point_to_line(origin, ray_unit, segment);

    if !reach.positive_side { continue; }
    if stop_at > 0.0 && reach.traveled > stop_at + STOP_MARGIN { continue; }

    let distance = max(0.001, reach.distance - footprint);
    let core = 0.64 / pow(distance * 0.17 + 0.016, 2.0);
    let halo = 0.08 / pow(distance * 0.06 + 0.052, 1.32);
    let medium = select(vec3<f32>(1.0), glass_transmittance(reach.traveled), inside);
    glow += throughput * medium * visibility_boost * ((core + halo) / attenuation);
  }
  return glow;
}

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {
  let coord = vx_out.uv * uniforms.screen_wh;
  let p = coord * 0.0005 / uniforms.scale;
  let ray_unit = normalize(p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward);

  let base_light = vec3<f32>(params.lr, params.lg, params.lb);
  let color_cap = vec3<f32>(0.82, 0.92, 1.0);

  var total_color = vec3<f32>(0.006, 0.010, 0.024);
  total_color += vec3<f32>(0.004, 0.006, 0.010) * (0.5 + 0.5 * vx_out.uv.y);

  let max_reflect_times = u32(params.max_reflections);
  let size = arrayLength(&base_points);

  var rays: array<RayState, MAX_BRANCH_RAYS>;
  var queued_count = 1u;
  rays[0] = RayState(uniforms.viewer_position, ray_unit, vec3<f32>(1.0), false, 0u);

  for (var ray_idx = 0u; ray_idx < MAX_BRANCH_RAYS; ray_idx = ray_idx + 1u) {
    if ray_idx >= queued_count { break; }
    if all(total_color >= color_cap) { break; }

    let state = rays[ray_idx];
    if state.depth > max_reflect_times { continue; }
    if max_component(state.throughput) < MIN_BRANCH_WEIGHT { continue; }

    var nearest = GlassHit(false, vec3<f32>(0.0), 1000000.0, vec3<f32>(0.0), vec3<f32>(0.0), vec3<f32>(0.0), 0.0, false);
    for (var mi = 0u; mi < size; mi = mi + 1u) {
      let cell = base_points[mi];
      let mirror = MirrorTriangle(cell.a.xyz, cell.b.xyz, cell.c.xyz);
      let hit = try_hit_glass(state.origin, state.direction, mirror, params.eta);
      if hit.hit && hit.travel < nearest.travel {
        nearest = hit;
      }
    }

    let attenuation = pow(f32(state.depth) / 4.2 + 1.08, 1.22);
    let stop = select(-1.0, nearest.travel, nearest.hit);
    total_color += base_light * sample_segments(state.origin, state.direction, stop, attenuation, state.throughput, state.inside, state.depth, 0.18);
    total_color = min(total_color, color_cap);

    if !nearest.hit { continue; }
    if state.depth == max_reflect_times { continue; }

    let reflect_weight = select(nearest.fresnel, 1.0, nearest.tir);
    let transmit_weight = select((1.0 - nearest.fresnel) * params.transmit, 0.0, nearest.tir);
    let reflected_throughput = state.throughput * reflect_weight;
    let refracted_throughput = state.throughput * transmit_weight;
    let prefer_reflected = max_component(reflected_throughput) >= max_component(refracted_throughput);

    let primary_direction = select(nearest.refracted, nearest.reflected, prefer_reflected);
    let primary_throughput = select(refracted_throughput, reflected_throughput, prefer_reflected);
    let primary_inside = select(!state.inside, state.inside, prefer_reflected);
    let secondary_direction = select(nearest.reflected, nearest.refracted, prefer_reflected);
    let secondary_throughput = select(reflected_throughput, refracted_throughput, prefer_reflected);
    let secondary_inside = select(state.inside, !state.inside, prefer_reflected);

    if max_component(primary_throughput) >= MIN_BRANCH_WEIGHT && queued_count < MAX_BRANCH_RAYS {
      rays[queued_count] = RayState(nearest.point + primary_direction * SURFACE_EPSILON, primary_direction, primary_throughput, primary_inside, state.depth + 1u);
      queued_count = queued_count + 1u;
    }

    if max_component(secondary_throughput) >= MIN_BRANCH_WEIGHT && queued_count < MAX_BRANCH_RAYS {
      rays[queued_count] = RayState(nearest.point + secondary_direction * SURFACE_EPSILON, secondary_direction, secondary_throughput, secondary_inside, state.depth + 1u);
      queued_count = queued_count + 1u;
    }
  }

  return vec4(total_color, 1.0);
}