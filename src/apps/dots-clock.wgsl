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
    let base_point = base_points[j];
    let base_position = base_point.position.xyz;

    let view = base_position - uniforms.viewer_position;
    let view_unit = normalize(view);
    let view_length = length(view);
    let cos_value = dot(view_unit, ray_unit);
    
    if cos_value < 0.7 {
      continue;
    }
    
    let sin_value = sqrt(1.0 - cos_value * cos_value);
    let distance_to_ray = abs(view_length * sin_value);
    
    // 点的大小
    let dot_size = base_point.p1;
    
    if distance_to_ray > dot_size {
      continue;
    }

    // 计算点的亮度，基于距离的衰减
    let distance_factor = 1.0 - (distance_to_ray / dot_size);
    let brightness = pow(distance_factor, 1.5) * base_point.p3 * 0.08;
    
    // 七段显示器风格的颜色：明亮的绿色/青色
    let base_color = vec3(0.2, 1.0, 0.6); // 青绿色
    
    // 添加轻微的脉动效果
    let pulse = sin(uniforms.time * 2.0 + base_point.p4 * 0.1) * 0.1 + 0.9;
    
    let color = base_color * brightness * pulse;
    total = total + color;
  }

  // 深色背景
  let background = vec3(0.05, 0.05, 0.08);
  total = total + background;

  return vec4(total, 1.0);
}