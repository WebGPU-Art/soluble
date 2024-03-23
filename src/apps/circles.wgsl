
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
  var total: vec3<f32> = vec3(0.0, 0.0, 0.0);

  for (var j: u32 = 0u; j < base_size; j++) {
    let base_point = (base_points[j]);
    let base_position = vec3(base_point.position.xy, 0.);
    let hard_radius = base_point.position.z; // TODO variable


    let p0 = vec3<f32>(0.0, 0.0, 0.0);
    let v1 = normalize(vec3<f32>(0.0, 1.0, 0.0));
    let v2 = normalize(vec3<f32>(1.0, 0.0, 0.0));

    let n = cross(v1, v2);
    let cos_value = dot(ray_unit, n);
    let connect = p0 - uniforms.viewer_position;
    let distance_to_surface = dot(connect, n);
    let join_point = uniforms.viewer_position + ray_unit * distance_to_surface / cos_value;

    // let view = base_position - join_point;
    // let view_unit = normalize(view);
    // let view_length = length(view);
    // let cos_value = dot(view_unit, ray_unit);
    // if cos_value < 0.9 {
    //   continue; // at back
    // }

    // let sin_value = sqrt(1.0 - cos_value * cos_value);
    // if abs(view_length * sin_value) > hard_radius * 1.3 {
    //   continue;
    // }


    // let near_point = join_point + ray_unit * view_length * cos_value;
    // let near_offset = near_point - base_position;
    let offset = join_point - base_position;

    if abs(length(offset) - hard_radius) < 0.4 {
      total += vec3(1.0, 1.0, 0.5);
    }

    // total += 2. * vec3(1.0, 1.0, 0.5) / pow(d_to_ring + 0.01, 1.6);
    // if d_to_ring < 10. {
    // total += 2. * vec3(1.0, 1.0, 0.5) / pow(d_to_ring + 0.01, 2.);
      // total += vec3(1.0, 1.0, 0.5);
    // }
  }

  return vec4(total, 1.);
}
