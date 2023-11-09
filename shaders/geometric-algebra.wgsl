
//! converted from https://github.com/calcit-lang/geometric/blob/main/compact.cirru
//! TODO not confirmed the correctness

/// struct holding 3D geometric algebra
struct GometricAlgebra3D {
  s: f32;
  x: f32;
  y: f32;
  z: f32;
  xy: f32;
  yz: f32;
  zx: f32;
  xyz: f32;
}

fn ga3_from_3(x: f32, y: f32, z: f32) -> GometricAlgebra3D {
  return GometricAlgebra3D(0., x, y, z, 0., 0., 0., 0.);
}

fn ga3_from_v3(v3: vec3<f32>) -> GometricAlgebra3D {
  let x = v3.x;
  let y = v3.y;
  let z = v3.z;
  return GometricAlgebra3D(0., x, y, z, 0., 0., 0., 0.);
}

fn ga3_add(a: GometricAlgebra3D, b: GometricAlgebra3D) -> GometricAlgebra3D {
  return GometricAlgebra3D(
    a.s + b.s,
    a.x + b.x,
    a.y + b.y,
    a.z + b.z,
    a.xy + b.xy,
    a.yz + b.yz,
    a.zx + b.zx,
    a.xyz + b.xyz,
  );
}

fn ga3_sub(a: GometricAlgebra3D, b: GometricAlgebra3D) -> GometricAlgebra3D {
  return GometricAlgebra3D(
    a.s - b.s,
    a.x - b.x,
    a.y - b.y,
    a.z - b.z,
    a.xy - b.xy,
    a.yz - b.yz,
    a.zx - b.zx,
    a.xyz - b.xyz,
  );
}


fn ga3_multiply(a: GometricAlgebra3D, b: GometricAlgebra3D) -> GometricAlgebra3D {
  let next_s = a.s * b.s + a.x * b.x + a.y * b.y + a.z * b.z - a.xy * b.xy - a.yz * b.yz - a.zx * b.zx - a.xyz * b.xyz;
  let next_x = a.s * b.x + a.x * b.s - a.y * b.xy + a.z * b.zx + a.xy * b.y - a.yz * b.xyz - a.zx * b.z - a.xyz * b.yz;
  let next_y = a.s * b.y + a.x * b.xy + a.y * b.s - a.z * b.yz - a.xy * b.x + a.yz * b.z - a.zx * b.xyz - a.xyz * b.zx;
  let next_z = a.s * b.z - a.x * b.zx + a.y * b.yz + a.z * b.s - a.xy * b.xyz - a.yz * b.y + a.zx * b.x - a.xyz * b.xy;
  let next_xy = a.s * b.xy + a.x * b.y - a.y * b.x + a.z * b.xyz + a.xy * b.s - a.yz * b.zx + a.zx * b.yz + a.xyz * b.z;
  let next_yz = a.s * b.yz + a.x * b.xyz + a.y * b.z - a.z * b.y + a.xy * b.zx + a.yz * b.s - a.zx * b.xy + a.xyz * b.x;
  let next_zx = a.s * b.zx - a.x * b.z + a.y * b.xyz + a.z * b.x - a.xy * b.yz + a.yz * b.xy + a.zx * b.s + a.xyz * b.y;
  let next_xyz = a.s * b.xyz + a.x * b.yz + a.y * b.zx + a.z * b.xy + a.xy * b.z + a.yz * b.x + a.zx * b.y + a.xyz * b.s;

  return GometricAlgebra3D(
    next_s,
    next_x,
    next_y,
    next_z,
    next_xy,
    next_yz,
    next_zx,
    next_xyz,
  );
}

fn ga3_conjugate(a: GometricAlgebra3D) -> GometricAlgebra3D {
  return GometricAlgebra3D(
    a.s,
    a.x,
    a.y,
    a.z,
    -a.xy,
    -a.yz,
    -a.zx,
    -a.xyz,
  );
}

fn ga3_length2(a: GometricAlgebra3D) -> f32 {
  return a.s * a.s + a.x * a.x + a.y * a.y + a.z * a.z + a.xy * a.xy + a.yz * a.yz + a.zx * a.zx + a.xyz * a.xyz;
}

fn ga3_length(a: GometricAlgebra3D) -> f32 {
  let length = ga3_length2(a);
  if length == 0. {
    return 0.;
  } else {
    return length.sqrt();
  }
}

fn ga3_scale(a: GometricAlgebra3D, f: f32) -> GometricAlgebra3D {
  return GometricAlgebra3D(
    a.s * f,
    a.x * f,
    a.y * f,
    a.z * f,
    a.xy * f,
    a.yz * f,
    a.zx * f,
    a.xyz * f,
  );
}

fn ga3_normalize(a: GometricAlgebra3D) -> GometricAlgebra3D {
  let length = ga3_length(a);
  if length == 0. {
    return GometricAlgebra3D(1., 0., 0., 0., 0., 0., 0., 0.);
  } else {
    return ga3_scale(a, 1.0 / length);
  }
}

fn ga3_reflect(a: GometricAlgebra3D, b: GometricAlgebra3D) -> GometricAlgebra3D {
  let r0 = ga3_normalize(b);
  return ga3_scale(ga3_multiply(ga3_multiply(ga3_conjugate(r0), a), r0), -1.)
}