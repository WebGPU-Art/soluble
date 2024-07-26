
/// reflect line A upon the part that is parrallel to B
fn reflect_on_direction(a: vec3<f32>, b: vec3<f32>) -> vec3<f32> {
  let b0 = normalize(b);
  let v_ = dot(a, b0) * b0;
  return a - 2. * v_ ;
}

/// result holding information how ray is close to segment line
struct RayReachSegment {
  distance: f32,
  positive_side: bool,
  traveled: f32,
}


struct Segment {
  start: vec3<f32>,
  end: vec3<f32>,
}

/// find out closest point of ray to the segment
fn ray_closest_point_to_line(viewer_position: vec3f, ray_unit: vec3f, s: Segment) -> RayReachSegment {
  let a = s.start - viewer_position;
  let b = s.end - viewer_position;

  // find perp direction and projection length on it
  let n = cross(b - a, ray_unit);

  // find projection of a of segment on ray direction, and use the Pythagorean theorem for another distance
  let a_proj = dot(ray_unit, a);
  let shadow_a = a - ray_unit * a_proj;

  let b_proj = dot(ray_unit, b);
  let shadow_b = b - ray_unit * b_proj;

  let direct_an = cross(shadow_a, n);
  let direct_bn = cross(shadow_b, n);
      // a and b on the same side of N
  let same_side = dot(direct_an, direct_bn) >= 0.0;

  if same_side {
    let a_distance_min = sqrt(dot(a, a) - a_proj * a_proj);
    let b_distance_min = sqrt(dot(b, b) - b_proj * b_proj);
    if a_distance_min < b_distance_min {
      return RayReachSegment(a_distance_min, a_proj > 0., a_proj);
    } else {
      return RayReachSegment(b_distance_min, b_proj > 0., b_proj);
    }
  } else {
    let n0 = normalize(n);
    /// smaller distance to segments ends
    let d_min = abs(dot(n0, a));

    // let travel = min(a_proj, b_proj); // very rough approximation
    let ab_unit = normalize(s.end - s.start);
    let ac = (viewer_position - s.start);

    let perp_reach: vec3f = dot(ac, n0) * n0;

    /// tricky math to find out traveled distance before closest point
    /// https://cos-sh.tiye.me/cos-up/342e0f6b7e3a7b1b4d18dad16cd84f79/IMG_20240601_113231.jpg
    /// https://g.co/gemini/share/dbf766e185a7
    let k = dot(
      cross(s.start + perp_reach - viewer_position, ab_unit),
      cross(ray_unit, ab_unit)
    ) + .0;

    // let front = dot(a, ray_unit) >= 0.0 && dot(b, ray_unit) >= 0.0;
    return RayReachSegment(d_min, k > 0., k);
  };
}



/// holding information about ray reflection
struct RayMirrorHit {
  hit: bool,
  point: vec3<f32>,
  travel: f32,
  next_ray_unit: vec3<f32>,
}


fn reflect_ray_with_sphere(viewer_position: vec3f, ray_unit: vec3f, center: vec3f, radius: f32, outside: bool) -> RayMirrorHit {

  // sphere center to viewer
  let center_to_viewer = center - viewer_position;

  let viewer_inside = dot(center_to_viewer, center_to_viewer) < radius * radius;

  if outside {
    if viewer_inside {
      return RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 0.0, vec3<f32>(0.0, 0.0, 0.0));
    } else {

      // distance from center to ray direction
      let projection = dot(center_to_viewer, ray_unit);

      if projection < 0.0 {
        // viewer is behind the sphere
        return RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 0.0, vec3<f32>(0.0, 0.0, 0.0));
      }
      let distance_to_ray = center_to_viewer - projection * ray_unit;

      if length(distance_to_ray) > radius {
        // viewer is outside the sphere
        return RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 0.0, vec3<f32>(0.0, 0.0, 0.0));
      }

      let distance_to_hit = sqrt(radius * radius - dot(distance_to_ray, distance_to_ray));
      let traveled = projection - distance_to_hit;
      let nearer_hit_point = viewer_position + traveled * ray_unit;

      return RayMirrorHit(true, nearer_hit_point, traveled, reflect_on_direction(ray_unit, nearer_hit_point - center));
    }
  } else {
      // distance from center to ray direction
    let projection = dot(center_to_viewer, ray_unit);

    if projection < 0.0 {
        // viewer is behind the sphere
      return RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 0.0, vec3<f32>(0.0, 0.0, 0.0));
    }
    let distance_to_ray = center_to_viewer - projection * ray_unit;

    if length(distance_to_ray) > radius {
        // viewer is outside the sphere
      return RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 0.0, vec3<f32>(0.0, 0.0, 0.0));
    }

    let distance_to_hit = sqrt(radius * radius - dot(distance_to_ray, distance_to_ray));
    let traveled = projection + distance_to_hit;
    let further_hit_point = viewer_position + traveled * ray_unit;

    return RayMirrorHit(true, further_hit_point, traveled, reflect_on_direction(ray_unit, further_hit_point - center));
  }
}



struct MirrorTriangle {
  a: vec3f,
  b: vec3f,
  c: vec3f,
}

/// to find out if ray hits mirror, return RayMirrorHit.
fn try_reflect_ray_with_mirror(viewer_position: vec3f, ray_unit: vec3f, mirror: MirrorTriangle) -> RayMirrorHit {
  /// normal of the mirror
  let n = normalize(cross(mirror.b - mirror.a, mirror.c - mirror.a));

  /// distance from the mirror surface to the viewer
  let d = dot(n, mirror.a - viewer_position);
  let cos_v = dot(n, ray_unit);
  let t = d / cos_v;

  let hit_point = viewer_position + abs(t) * ray_unit;


  /// need to skip case viewer and origin point on different sides of the mirror
  let viewer_side = dot(n, ray_unit);
  let ray_side = dot(n, hit_point);
  if viewer_side * ray_side < 0.0 {
    return RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 0.0, vec3<f32>(0.0, 0.0, 0.0));
  }
  if t < 0.0001 {
    return RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), 0.0, vec3<f32>(0.0, 0.0, 0.0));
  }

  let spin_a = cross(hit_point - mirror.a, mirror.b - mirror.a);
  let spin_b = cross(hit_point - mirror.b, mirror.c - mirror.b);
  let spin_c = cross(hit_point - mirror.c, mirror.a - mirror.c);
  let inside = dot(spin_a, spin_b) >= 0.0 && dot(spin_b, spin_c) >= 0.0 && dot(spin_c, spin_a) >= 0.0;

  if inside {
    let reflection = reflect_on_direction(ray_unit, n);
    return RayMirrorHit(true, hit_point, t, reflection);
  } else {
    return RayMirrorHit(false, vec3<f32>(0.0, 0.0, 0.0), t, vec3<f32>(0.0, 0.0, 0.0));
  }
}