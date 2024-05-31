
const PI = 3.14159265358532374;

// fn square(x: f32) -> f32 {
//   return x * x;
// }

fn product(a: vec2f, b: vec2f) -> vec2f {
  return vec2f(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

fn conjugate(a: vec2f) -> vec2f {
  return vec2f(a.x, - a.y);
}

fn divide(a: vec2f, b: vec2f) -> vec2f {
  let l_square_inverse = 1. / b.x * b.x + b.y * b.y;
  return vec2f(((a.x * b.x + a.y * b.y) * l_square_inverse), ((a.y * b.x - a.x * b.y) * l_square_inverse));
}

const MAGIC_NUMBER: f32 = 43758.5453123;

fn rand11(n: f32) -> f32 { return fract(sin(n) * MAGIC_NUMBER); }

/// check perpendicular point of point P at line P1-P2
fn perpendicular(p: vec2f, p1: vec2f, p2: vec2f) -> vec2f {
  let x = p.x;
  let y = p.y;
  let a = p1.x;
  let b = p1.y;
  let c = p2.x;
  let d = p2.y;
    // corrected with https://blog.csdn.net/qq_32867925/article/details/114294753
  let k = - ((a - x) * (c - a) + (b - y) * (d - b)) / ((a - c) * (a - c) + (b - d) * (b - d));
  return vec2f(a + (c - a) * k, b + (d - b) * k);
}

/// for 2d
fn length_square(a: vec2f) -> f32 {
  return a.x * a.x + a.y * a.y;
}

/// check if point P is on different side of line P1-P2 as origin point
fn is_outside_line(p: vec2f, p1: vec2f, p2: vec2f) -> bool {
  let perp = perpendicular(p, p1, p2);
  let l_sq = length_square(perp);
  return product(p, conjugate(perp)).x > l_sq;
}

/// axis is luckily a unit vector
fn rotate_vec3(v: vec3<f32>, center: vec3<f32>, axis: vec3<f32>, angle: f32) -> vec3<f32> {
  let a = v - center;
  let a_along_axis = dot(a, axis);
  let a_perp = a - a_along_axis;
  let a_next = a_perp * cos(angle) + normalize(cross(axis, a_perp)) * length(a_perp) * sin(angle) + a_along_axis;
  return a_next;
  // return v;
}
