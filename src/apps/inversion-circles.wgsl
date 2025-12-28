#import soluble::perspective

struct BaseCell {
  position: vec4<f32>,
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

const PI = 3.14159265358979323846;

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {
  // pixel coordinates
  let coord: vec2<f32> = vx_out.uv * uniforms.screen_wh;
  let p: vec2<f32> = coord * 0.001 / uniforms.scale;

  var base_size = arrayLength(&base_points);

  // If no spheres, show red for debugging
  if base_size == 0u {
    return vec4<f32>(1.0, 0.0, 0.0, 1.0);
  }

  // create view ray
  let ray_unit = normalize(
    p.x * uniforms.rightward + p.y * uniforms.upward + 1.5 * uniforms.forward
  );

  var total_color = vec4<f32>(0.02, 0.01, 0.05, 1.0); // Very dark background

  // 3D perspective projection from viewer position
  let viewer_pos = uniforms.viewer_position;

  // Render each sphere using ray-sphere intersection
  for (var i: u32 = 0u; i < base_size; i++) {
    let sphere = base_points[i];
    let sphere_center = sphere.position.xyz;
    let sphere_radius = max(sphere.position.w, 1.0);

    // Calculate vector from viewer to sphere center
    let viewer_to_center = sphere_center - viewer_pos;
    let distance_to_center = length(viewer_to_center);

    // Skip spheres that are too far away
    if distance_to_center > 2000.0 {
      continue;
    }

    // Calculate projection of sphere center onto ray
    let projection = dot(viewer_to_center, ray_unit);

    // Skip spheres that are behind the viewer
    if projection < 0.0 {
      continue;
    }

    // Calculate distance from ray to sphere center
    let closest_point = viewer_pos + projection * ray_unit;
    let distance_to_ray = length(sphere_center - closest_point);

    // Calculate apparent radius based on distance for perspective
    let perspective_scale = 200.0 / max(projection, 10.0);
    let apparent_radius = sphere_radius * perspective_scale;

    // Simple circle outline rendering for visibility
    let distance_to_ray_scaled = distance_to_ray * perspective_scale;
    let line_thickness = max(0.8, apparent_radius * 0.06);
    let distance_to_edge = abs(distance_to_ray_scaled - apparent_radius);

    if distance_to_edge < line_thickness {
      let intensity = 1.0 - smoothstep(0.0, line_thickness, distance_to_edge);

      // Color by generation (stored in p1 parameter)
      let generation = sphere.p1;
      var r: f32;
      var g: f32;
      var b: f32;

      if generation == 0.0 {
        // Original spheres: bright white/cyan
        r = 0.8; g = 1.0; b = 1.0;
      } else if generation == 1.0 {
        // First generation: bright green
        r = 0.2; g = 1.0; b = 0.4;
      } else if generation == 2.0 {
        // Second generation: bright yellow
        r = 1.0; g = 1.0; b = 0.2;
      } else if generation == 3.0 {
        // Third generation: bright magenta
        r = 1.0; g = 0.3; b = 0.8;
      } else if generation == 4.0 {
        // Fourth generation: bright orange
        r = 1.0; g = 0.6; b = 0.1;
      } else {
        // Higher generations: bright red
        r = 1.0; g = 0.2; b = 0.2;
      }

      let circle_color = vec3<f32>(r, g, b) * intensity;
      total_color += vec4<f32>(circle_color * 0.8, 0.0);
    }
  }

  // Add some brightness to ensure visibility
  total_color += vec4<f32>(0.05, 0.05, 0.05, 0.0);

  // Clamp colors
  total_color = min(total_color, vec4<f32>(1.0, 1.0, 1.0, 1.0));

  return total_color;
}