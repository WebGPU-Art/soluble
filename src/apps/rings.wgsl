
#import soluble::perspective

struct BaseCell {
  position: vec4<f32>,
  arm1: vec4<f32>,
  arm2: vec4<f32>,
  p1: f32, p2: f32, p3: f32, p4: f32,
};

@group(1) @binding(0) var<storage, read_write> base_points: array<BaseCell>;

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

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  // pixel coordinates
  let coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;
  let p: vec2<f32> = coord * 0.0005 / uniforms.scale;

  var base_size = arrayLength(&base_points);

  // create view ray
  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 2.0 * uniforms.forward
  );

  // raymarch
  var nearest: f32 = 10000.0;
  var total: vec3<f32> = vec3(0.0, 0.0, 0.0);

  for (var j: u32 = 0u; j < base_size; j++) {
    let base_point = base_points[j];
    let base_position = base_point.position.xyz;

    let view = base_position - uniforms.viewer_position;
    let view_unit = normalize(view);
    let view_length = length(view);
    let cos_value = dot(view_unit, ray_unit);
    if cos_value < 0. {
      continue; // at back
    }
    let hard_radius = base_point.p1; // TODO variable

    let sin_value = sqrt(1.0 - cos_value * cos_value);
    if abs(view_length * sin_value) > hard_radius * 1.5 {
      continue;
    }

    // perpendicular to ring plane
    let arm3 = normalize(cross(base_point.arm1.xyz, base_point.arm2.xyz));
    // distance from viewer to ring plane
    let distance_to_ring_plane = dot(view_unit, arm3) * view_length;
    let ray_plane_cos = dot(ray_unit, arm3);

    // on ring plane, but perp to ray
    let perp_direct = cross(ray_unit, arm3);
    // on ring plane, close to ray direction
    let far_direct = cross(perp_direct, arm3);

    let length_ray_to_ring_plane = distance_to_ring_plane / ray_plane_cos;
    let hit_ring_plane = length_ray_to_ring_plane * ray_unit;
    // distance from hit point to ring center
    var hit_ring_offset = uniforms.viewer_position + hit_ring_plane - base_position;

    let flat_distance_to_ring = abs(length(hit_ring_offset) - hard_radius);

    total += 2. * vec3(1.0, 1.0, 0.5) / pow(flat_distance_to_ring + 0.01, 1.6);
  }

  return vec4(total, 1.);
}
