struct UBO {
  screen_wh: vec2<f32>,
  forward: vec3<f32>,
  // direction up overhead, better unit vector
  upward: vec3<f32>,
  rightward: vec3<f32>,
  viewer_position: vec3<f32>,
};

@group(0) @binding(0)
var<uniform> uniforms: UBO;

fn ndot(a: vec2<f32>, b: vec2<f32>) -> f32 {
  return a.x * b.x - a.y * b.y;
}

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


fn fake_round(a: f32) -> f32 {
  let b: f32 = fract(a);
  if (b < 0.5) {
    return floor(a);
  } else {
    return floor(a) + 1.0;
  }
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
  let limit: f32 = 60.0;
  let pos_c: vec3<f32> = pos / c;
  let mp: vec3<f32> = vec3(clamp(fake_round(pos_c.x), -limit, limit),
                 clamp(fake_round(pos_c.y), -limit, limit),
                 clamp(fake_round(pos_c.z), -limit, limit));
  // let q: vec3<f32> = pos - c * clamp(mp, -l, l);
  let q: vec3<f32> = pos - c * mp;
  // vec3 replicated_position = fract(pos * 10.0) * 0.1;
  return sd_sphere(q, 0.01);
  // return sd_sphere(pos, 1.0);
  // return sd_octahedron(q, 0.22);
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

@vertex
fn vertex_main(
    @location(0) position: vec2<f32>,
) -> VertexOut {
  var output: VertexOut;
  output.position = vec4(position, 0.0, 1.0);
  output.uv = vec2<f32>(position.x, position.y);
  output.screen_wh = uniforms.screen_wh;
  output.viewer_position = uniforms.viewer_position;
  output.forward = uniforms.forward;
  output.upward = uniforms.upward;
  return output;
}

struct VertexOut {
    @builtin(position) position: vec4<f32>,
    @location(0) uv: vec2<f32>,
    @location(1) viewer_position: vec3<f32>,
    @location(2) forward: vec3<f32>,
    @location(3) upward: vec3<f32>,
    @location(4) screen_wh: vec2<f32>,
};

@fragment
fn fragment_main_1(vx_out: VertexOut) -> @location(0) vec4<f32> {
  return vec4(1,1,1,1);
}

@fragment
fn fragment_main(vx_out: VertexOut) -> @location(0) vec4<f32> {

  let viewer_position: vec3<f32> = vx_out.viewer_position;
  let forward: vec3<f32> = vx_out.forward;
  let upward: vec3<f32> = vx_out.upward;
  let uv = vx_out.uv;
  let screen_wh= vx_out.screen_wh;

  let rightward: vec3<f32> = normalize(cross(forward, upward)); // rightward

  var total: vec3<f32> = vec3(0,0.0,0.0);

  // pixel coordinates
  let coord: vec2<f32> = uv * screen_wh;
  let p: vec2<f32> = coord / 2000.0;

  // create view ray
  let ray_direction = normalize(p.x * rightward + p.y * upward + 1.5 * forward);

  // raymarch
  var tmax: f32 = 2000.0;
  var t: f32 = 0.0;
  var nearest: f32 = 1000.0;
  for (var i: u32 = 0; i < 400; i++) {
    let pos: vec3<f32> = viewer_position + t * ray_direction;
    let h: f32 = map_2(pos); // <---- map
    if (h < nearest) {
      nearest = h;
    }
    if (h < 0.01 || t > tmax) {
      break;
    }
    t += h;
  }

  // shading/lighting
  var color: vec3<f32> = vec3(0.0);
  if (t < tmax) {
    let position: vec3<f32> = viewer_position + t * ray_direction;
    let normal: vec3<f32> = calc_normal_direction(position);
    let dif: f32 = clamp(dot(normal, vec3(0.57703)), 0.0, 1.0);
    let ambient: f32 = 0.6 + 0.4 * dot(normal, vec3(0.0, 1.0, 0.0));
    color = vec3(0.3, 0.2, 0.1) * ambient + vec3(0.4, 0.5, 0.2) * dif;
  } else {
    let l: f32 = 0.1 / (nearest + 0.01);
    color = vec3(l*0.3, l*0.2, l*0.8);
  }

  // gamma
  color = sqrt(color);
  total += color;

  return vec4(total, 1.0);
  // return vec4(uv.y/1000.0,0,0.0,1.0);
  // return vec4(viewer_position/1000.0, 1.0);
}
