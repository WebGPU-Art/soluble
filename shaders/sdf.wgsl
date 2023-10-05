struct UBO {
  screen_wh: vec2<f32>,
  scale: f32,
  forward: vec3<f32>,
  // direction up overhead, better unit vector
  upward: vec3<f32>,
  rightward: vec3<f32>,
  viewer_position: vec3<f32>,
};

struct BaseCell {
  position: vec4<f32>,
  velocity: vec4<f32>,
  p1: f32,
  p2: f32,
  p3: f32,
  p4: f32,
};

@group(0) @binding(0) var<uniform> uniforms: UBO;
@group(0) @binding(1) var<storage, read_write> base_points: array<BaseCell>;

fn ndot(a: vec2<f32>, b: vec2<f32>) -> f32 {
  return a.x * b.x - a.y * b.y;
}

// utils

// https://iquilezles.org/articles/normalsSDF
// fn calc_normal_direction(pos: vec3<f32>) -> vec3<f32> {
//   let e: vec2<f32> = vec2(1.0,-1.0)*0.5773;
//   let eps: f32 = 0.05;
//   return normalize( e.xyy*map( pos + e.xyy*eps ) +
//           e.yyx*map( pos + e.yyx*eps ) +
//           e.yxy*map( pos + e.yxy*eps ) +
//           e.xxx*map( pos + e.xxx*eps ) );
// }

fn calc_normal_direction(p: vec3<f32>) -> vec3<f32> {
  let eps: f32 = 0.002;
  let v1: vec3<f32> = vec3(1.0, -1.0, -1.0);
  let v2: vec3<f32> = vec3(-1.0, -1.0, 1.0);
  let v3: vec3<f32> = vec3(-1.0, 1.0, -1.0);
  let v4: vec3<f32> = vec3(1.0, 1.0, 1.0);
  return normalize(v1 * map(p + v1 * eps) + v2 * map(p + v2 * eps) +
                   v3 * map(p + v3 * eps) + v4 * map(p + v4 * eps));
}

const sqrt2: f32 = 1.4142135623730950488016887242096980785696718753769480731766797379;
const sqrt3: f32 = 1.7320508075688772935274463415058723669428052538103806280558069794;

/// turn xyz into compact abc
fn resolve_axis(p: vec3<f32>) -> vec3<f32> {
  let b: f32 = sqrt3 * p.y / sqrt2;
  let c: f32 = (p.z - 0.5 * b / sqrt3) * 2.0 / sqrt3;
  let a: f32 = p.x - 0.5 * c - 0.5 * b;
  return vec3(a, b, c);
}

/// turn compact abc into compact xyz
fn transform_axis(p: vec3<f32>) -> vec3<f32> {
  let x: f32 = p.x + 0.5 * p.y + 0.5 * p.z;
  let y: f32 = p.y * sqrt2 / sqrt3;
  let z: f32 = 0.5 * sqrt3 * p.z + 0.5 * p.y / sqrt3;
  return vec3(x, y, z);
}

fn round_up(a: f32) -> f32 {
  return floor(a + 0.5);
}

// shapes

// la,lb=semi axis, h=height, ra=corner
fn sd_rhombus(p0: vec3<f32>, la: f32, lb: f32, h: f32, ra: f32) -> f32 {
  let p = abs(p0);
  let b: vec2<f32> = vec2(la, lb);
  let f: f32 = clamp((ndot(b, b - 2.0 * p.xz)) / dot(b, b), -1.0, 1.0);
  let q = vec2(length(p.xz - 0.5 * b * vec2(1.0 - f, 1.0 + f)) *
                        sign(p.x * b.y + p.z * b.x - b.x * b.y) -
                    ra,
                p.y - h);
  return min(max(q.x, q.y), 0.0) + length(max(q, vec2(0.0, 0.0)));
}

fn sd_box_frame(p: vec3<f32>, b: vec3<f32>, e: f32) -> f32 {
  let q = abs(p) - b;
  let w = abs(q + e) - e;
  return min(min(
      length(max(vec3<f32>(q.x, w.y, w.z), vec3<f32>(0.))) + min(max(q.x, max(w.y, w.z)), 0.),
      length(max(vec3<f32>(w.x, q.y, w.z), vec3<f32>(0.))) + min(max(w.x, max(q.y, w.z)), 0.)),
      length(max(vec3<f32>(w.x, w.y, q.z), vec3<f32>(0.))) + min(max(w.x, max(w.y, q.z)), 0.));
}

fn sd_sphere(p: vec3<f32>, r: f32) -> f32 {
  return length(p) - r;
}

fn sd_box(p: vec3<f32>, b: vec3<f32>) -> f32 {
  let q = abs(p) - b;
  return length(max(q, vec3<f32>(0.))) + min(max(q.x, max(q.y, q.z)), 0.);
}

fn sd_octahedron(p: vec3<f32>, s: f32) -> f32 {
  var q: vec3<f32> = abs(p);
  let m = q.x + q.y + q.z - s;
  if (3. * q.x < m) {q = q.xyz;}
  else {if (3. * q.y < m) {q = q.yzx;}
        else {if (3. * q.z < m) {q = q.zxy;}
              else {return m * 0.57735027;}}}
  let k = clamp(0.5 * (q.z - q.y + s), 0., s);
  return length(vec3<f32>(q.x, q.y - s + k, q.z - k));
}


fn map_2(pos: vec3<f32>) -> f32 {
  // return sd_sphere(pos, 200.);
  // return sd_box(pos, vec3(200.,200.,200.));
  return sd_box_frame(pos, vec3(100.0,100.0,100.0), 10.);
}

fn map_old(pos: vec3<f32>) -> f32 {
  // return min(
  //   min(sdRhombus(pos, 0.6, 0.2, 0.02, 0.02 ) - 0.01,
  //   sdBoxFrame(pos - vec3(2.0, 0.0, 0.0), vec3(0.6, 0.2, 0.02), 0.02)
  //   ),
  //   sdBox(pos - vec3(4.0, 0.0, 0.0), vec3(0.4, 0.2, 0.2))
  // );
  // return sdBoxFrame(pos, vec3(0.6, 0.2, 0.02), 0.02);
  let c: f32 = 4.0;
  // let l: vec3<f32> = vec3(20.0, 0.0, 0.0);
  let limit: f32 = 40.0;
  var pos_c: vec3<f32> = pos / c;
  pos_c = vec3(clamp(round_up(pos_c.x), -limit, limit),
                 clamp(round_up(pos_c.y), -limit, limit),
                 clamp(round_up(pos_c.z), -limit, limit));
  // let q: vec3<f32> = pos - c * clamp(mp, -l, l);
  let q: vec3<f32> = pos - c * pos_c;
  // vec3 replicated_position = fract(pos * 10.0) * 0.1;
  return sd_sphere(q, 0.1);
  // return sd_sphere(pos, 1.0);
  // return sd_octahedron(q, 0.22);
}


fn map(pos: vec3<f32>) -> f32 {
  let c: f32 = 2.0;

  let limit: f32 = 40.0 / c;
  let low: vec3<f32> = vec3(-limit,-limit,-limit);
  let high: vec3<f32> = vec3(limit,limit,limit);

  let pos_c: vec3<f32> = pos / c;

  let q: vec3<f32> = resolve_axis(pos_c);

  var r1: vec3<f32> = vec3(floor(q.x), floor(q.y), floor(q.z));
  r1 = clamp(r1, low, high);
  let p1: vec3<f32> = transform_axis(r1);

  var r2: vec3<f32> = vec3(floor(q.x), floor(q.y), ceil(q.z));
  r2 = clamp(r2, low, high);
  let p2: vec3<f32> = transform_axis(r2);

  var r3: vec3<f32> = vec3(floor(q.x), ceil(q.y), floor(q.z));
  r3 = clamp(r3, low, high);
  let p3: vec3<f32> = transform_axis(r3);

  var r4: vec3<f32> = vec3(floor(q.x), ceil(q.y), ceil(q.z));
  r4 = clamp(r4, low, high);
  let p4: vec3<f32> = transform_axis(r4);

  var r5: vec3<f32> = vec3(ceil(q.x), floor(q.y), floor(q.z));
  r5 = clamp(r5, low, high);
  let p5: vec3<f32> = transform_axis(r5);

  var r6: vec3<f32> = vec3(ceil(q.x), floor(q.y), ceil(q.z));
  r6 = clamp(r6, low, high);
  let p6: vec3<f32> = transform_axis(r6);

  var r7: vec3<f32> = vec3(ceil(q.x), ceil(q.y), floor(q.z));
  r7 = clamp(r7, low, high);
  let p7: vec3<f32> = transform_axis(r7);

  var r8: vec3<f32> = vec3(ceil(q.x), ceil(q.y), ceil(q.z));
  r8 = clamp(r8, low, high);
  let p8: vec3<f32> = transform_axis(r8);


  var l: f32 = distance(p1, pos_c);
  var qq: vec3<f32> = p1;

  var ll: f32 = distance(p2, pos_c);
  if (ll < l) { qq = p2; l = ll; }

  ll = distance(p3, pos_c);
  if (ll < l) { qq = p3; l = ll; }

  ll = distance(p4, pos_c);
  if (ll < l) { qq = p4; l = ll; }

  ll = distance(p5, pos_c);
  if (ll < l) { qq = p5; l = ll; }

  ll = distance(p6, pos_c);
  if (ll < l) { qq = p6; l = ll; }

  ll = distance(p7, pos_c);
  if (ll < l) { qq = p7; l = ll; }

  ll = distance(p8, pos_c);
  if (ll < l) { qq = p8; l = ll; }

  let qqq: vec3<f32> = pos - c * qq;
  return sd_sphere(qqq, 0.01);
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

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  let viewer_position: vec3<f32> = uniforms.viewer_position;
  let forward: vec3<f32> = uniforms.forward;
  let upward: vec3<f32> = uniforms.upward;
  let uv = vx_out.uv;
  let screen_wh= uniforms.screen_wh;

  let rightward: vec3<f32> = normalize(cross(forward, upward)); // rightward

  var total: vec3<f32> = vec3(0.0,0.0,0.0);

  // pixel coordinates
  let coord: vec2<f32> = uv * screen_wh;
  let p: vec2<f32> = coord * 0.0005 / uniforms.scale;

  // create view ray
  let ray_direction = normalize(p.x * rightward + p.y * upward + 1.5 * forward);

  // raymarch
  var tmax: f32 = 2000.0;
  var t: f32 = 0.0;
  var nearest: f32 = 100.0;
  var base_size = arrayLength(&base_points);
  for (var i: u32 = 0u; i < 200u; i++) {
    let pos: vec3<f32> = viewer_position + t * ray_direction;
    // let h: f32 = map_old(pos); // <---- map
    var h: f32 = 1000000.0;
    for (var j: u32 = 0u; j < base_size; j++) {
      let base_point = base_points[j];
      let relative = pos - base_point.position.xyz;
      let h1 = sd_sphere(relative, 6.);
      if (h1 < h) {
        h = h1;
      }
    }
    if (h < nearest) {
      nearest = h;
    }
    if (h < 0.02 || t > tmax) {
      break;
    }
    t += h;
  }

  // shading/lighting
  var color: vec3<f32> = vec3(0.0);
  if (t < tmax) {
    // let position: vec3<f32> = viewer_position + t * ray_direction;
    // let normal: vec3<f32> = calc_normal_direction(position);
    // let dif: f32 = clamp(dot(normal, vec3(0.57703)), 0.0, 1.0);
    // let ambient: f32 = 0.6 + 0.4 * dot(normal, vec3(0.0, 1.0, 0.0));
    // color = vec3(0.6, 0.4, 0.2) * ambient + vec3(0.5, 0.8, 0.3) * dif;
    color = vec3(0.8, 0.1, 0.8);
  }
  let l: f32 = 0.1 / (nearest * 0.1 + 0.001);
  color += vec3(l*0.8, l*0.1, l*0.8);

  // gamma
  color = sqrt(color);
  total += color;

  return vec4(total, 1.0);
  // return vec4(uv.y/1000.0,0,0.0,1.0);
  // return vec4(viewer_position/1000.0, 1.0);
}
