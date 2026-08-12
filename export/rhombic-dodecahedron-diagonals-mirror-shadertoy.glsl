// ShaderToy export of the rhombic dodecahedron diagonals mirror demo.
// Uses iResolution and iTime only.

#define MAX_REFLECTIONS 20
#define MIRROR_COUNT 24
#define SEGMENT_COUNT 7

struct RayMirrorHit {
  bool hit;
  vec3 point;
  float travel;
  vec3 nextRayUnit;
};

struct RayReachSegment {
  float distance;
  bool positiveSide;
  float traveled;
};

struct MirrorTriangle {
  vec3 a;
  vec3 b;
  vec3 c;
};

struct Segment {
  vec3 start;
  vec3 end;
};

const float U = 100.0;
const vec3 P_TOP = vec3(0.0, 2.0 * U, 0.0);
const vec3 P_BOTTOM = vec3(0.0, -2.0 * U, 0.0);
const vec3 P_LEFT = vec3(-2.0 * U, 0.0, 0.0);
const vec3 P_RIGHT = vec3(2.0 * U, 0.0, 0.0);
const vec3 P_FRONT = vec3(0.0, 0.0, 2.0 * U);
const vec3 P_BACK = vec3(0.0, 0.0, -2.0 * U);
const vec3 P1 = vec3(-U, U, U);
const vec3 P2 = vec3(U, U, U);
const vec3 P3 = vec3(U, U, -U);
const vec3 P4 = vec3(-U, U, -U);
const vec3 P5 = vec3(-U, -U, U);
const vec3 P6 = vec3(U, -U, U);
const vec3 P7 = vec3(U, -U, -U);
const vec3 P8 = vec3(-U, -U, -U);

vec3 rotateY(vec3 p, float angle) {
  float c = cos(angle);
  float s = sin(angle);
  return vec3(c * p.x + s * p.z, p.y, -s * p.x + c * p.z);
}

vec3 rotateX(vec3 p, float angle) {
  float c = cos(angle);
  float s = sin(angle);
  return vec3(p.x, c * p.y - s * p.z, s * p.y + c * p.z);
}

vec3 applyObjectRotation(vec3 p, float time) {
  vec3 rotated = rotateY(p, time * 0.42);
  return rotateX(rotated, 0.22 + 0.08 * sin(time * 0.31));
}

vec3 reflectOnDirection(vec3 a, vec3 b) {
  vec3 b0 = normalize(b);
  vec3 parallelPart = dot(a, b0) * b0;
  return a - 2.0 * parallelPart;
}

mat3 lookAt(vec3 eye, vec3 target) {
  vec3 forward = normalize(target - eye);
  vec3 worldUp = vec3(0.0, 1.0, 0.0);
  vec3 right = normalize(cross(forward, worldUp));
  vec3 up = cross(right, forward);
  return mat3(right, up, forward);
}

RayMirrorHit makeMiss() {
  return RayMirrorHit(false, vec3(0.0), 0.0, vec3(0.0));
}

MirrorTriangle getMirror(int index, float time) {
  if (index == 0) return MirrorTriangle(applyObjectRotation(P_TOP, time), applyObjectRotation(P1, time), applyObjectRotation(P2, time));
  if (index == 1) return MirrorTriangle(applyObjectRotation(P_TOP, time), applyObjectRotation(P2, time), applyObjectRotation(P3, time));
  if (index == 2) return MirrorTriangle(applyObjectRotation(P_TOP, time), applyObjectRotation(P3, time), applyObjectRotation(P4, time));
  if (index == 3) return MirrorTriangle(applyObjectRotation(P_TOP, time), applyObjectRotation(P4, time), applyObjectRotation(P1, time));
  if (index == 4) return MirrorTriangle(applyObjectRotation(P_BOTTOM, time), applyObjectRotation(P5, time), applyObjectRotation(P6, time));
  if (index == 5) return MirrorTriangle(applyObjectRotation(P_BOTTOM, time), applyObjectRotation(P6, time), applyObjectRotation(P7, time));
  if (index == 6) return MirrorTriangle(applyObjectRotation(P_BOTTOM, time), applyObjectRotation(P7, time), applyObjectRotation(P8, time));
  if (index == 7) return MirrorTriangle(applyObjectRotation(P_BOTTOM, time), applyObjectRotation(P8, time), applyObjectRotation(P5, time));
  if (index == 8) return MirrorTriangle(applyObjectRotation(P_LEFT, time), applyObjectRotation(P1, time), applyObjectRotation(P4, time));
  if (index == 9) return MirrorTriangle(applyObjectRotation(P_LEFT, time), applyObjectRotation(P4, time), applyObjectRotation(P8, time));
  if (index == 10) return MirrorTriangle(applyObjectRotation(P_LEFT, time), applyObjectRotation(P8, time), applyObjectRotation(P5, time));
  if (index == 11) return MirrorTriangle(applyObjectRotation(P_LEFT, time), applyObjectRotation(P5, time), applyObjectRotation(P1, time));
  if (index == 12) return MirrorTriangle(applyObjectRotation(P_RIGHT, time), applyObjectRotation(P2, time), applyObjectRotation(P3, time));
  if (index == 13) return MirrorTriangle(applyObjectRotation(P_RIGHT, time), applyObjectRotation(P3, time), applyObjectRotation(P7, time));
  if (index == 14) return MirrorTriangle(applyObjectRotation(P_RIGHT, time), applyObjectRotation(P7, time), applyObjectRotation(P6, time));
  if (index == 15) return MirrorTriangle(applyObjectRotation(P_RIGHT, time), applyObjectRotation(P6, time), applyObjectRotation(P2, time));
  if (index == 16) return MirrorTriangle(applyObjectRotation(P_FRONT, time), applyObjectRotation(P1, time), applyObjectRotation(P2, time));
  if (index == 17) return MirrorTriangle(applyObjectRotation(P_FRONT, time), applyObjectRotation(P2, time), applyObjectRotation(P6, time));
  if (index == 18) return MirrorTriangle(applyObjectRotation(P_FRONT, time), applyObjectRotation(P6, time), applyObjectRotation(P5, time));
  if (index == 19) return MirrorTriangle(applyObjectRotation(P_FRONT, time), applyObjectRotation(P5, time), applyObjectRotation(P1, time));
  if (index == 20) return MirrorTriangle(applyObjectRotation(P_BACK, time), applyObjectRotation(P4, time), applyObjectRotation(P3, time));
  if (index == 21) return MirrorTriangle(applyObjectRotation(P_BACK, time), applyObjectRotation(P3, time), applyObjectRotation(P7, time));
  if (index == 22) return MirrorTriangle(applyObjectRotation(P_BACK, time), applyObjectRotation(P7, time), applyObjectRotation(P8, time));
  return MirrorTriangle(applyObjectRotation(P_BACK, time), applyObjectRotation(P8, time), applyObjectRotation(P4, time));
}

Segment getSegment(int index, float time) {
  if (index == 0) return Segment(applyObjectRotation(P_TOP, time), applyObjectRotation(P_BOTTOM, time));
  if (index == 1) return Segment(applyObjectRotation(P_LEFT, time), applyObjectRotation(P_RIGHT, time));
  if (index == 2) return Segment(applyObjectRotation(P_FRONT, time), applyObjectRotation(P_BACK, time));
  if (index == 3) return Segment(applyObjectRotation(P1, time), applyObjectRotation(P7, time));
  if (index == 4) return Segment(applyObjectRotation(P2, time), applyObjectRotation(P8, time));
  if (index == 5) return Segment(applyObjectRotation(P3, time), applyObjectRotation(P5, time));
  return Segment(applyObjectRotation(P4, time), applyObjectRotation(P6, time));
}

RayMirrorHit tryReflectRayWithMirror(vec3 viewerPosition, vec3 rayUnit, MirrorTriangle mirror) {
  vec3 n = normalize(cross(mirror.b - mirror.a, mirror.c - mirror.a));
  float d = dot(n, mirror.a - viewerPosition);
  float cosV = dot(n, rayUnit);
  if (abs(cosV) < 0.00001) {
    return makeMiss();
  }

  float t = d / cosV;
  vec3 hitPoint = viewerPosition + abs(t) * rayUnit;

  float viewerSide = dot(n, rayUnit);
  float raySide = dot(n, hitPoint);
  if (viewerSide * raySide < 0.0) {
    return makeMiss();
  }
  if (t < 0.0001) {
    return makeMiss();
  }

  vec3 spinA = cross(hitPoint - mirror.a, mirror.b - mirror.a);
  vec3 spinB = cross(hitPoint - mirror.b, mirror.c - mirror.b);
  vec3 spinC = cross(hitPoint - mirror.c, mirror.a - mirror.c);
  bool inside = dot(spinA, spinB) > 0.0 && dot(spinB, spinC) > 0.0 && dot(spinC, spinA) > 0.0;

  if (!inside) {
    return makeMiss();
  }

  return RayMirrorHit(true, hitPoint, t, reflectOnDirection(rayUnit, n));
}

RayReachSegment rayClosestPointToLine(vec3 viewerPosition, vec3 rayUnit, Segment s) {
  vec3 a = s.start - viewerPosition;
  vec3 b = s.end - viewerPosition;
  vec3 n = cross(b - a, rayUnit);

  float aProj = dot(rayUnit, a);
  vec3 shadowA = a - rayUnit * aProj;
  float bProj = dot(rayUnit, b);
  vec3 shadowB = b - rayUnit * bProj;

  vec3 directAN = cross(shadowA, n);
  vec3 directBN = cross(shadowB, n);
  bool sameSide = dot(directAN, directBN) > 0.0;

  if (sameSide) {
    float aDistance2Min = dot(a, a) - aProj * aProj;
    float bDistance2Min = dot(b, b) - bProj * bProj;
    if (aDistance2Min < bDistance2Min) {
      return RayReachSegment(sqrt(max(0.0, aDistance2Min)), aProj > 0.0, aProj);
    }
    return RayReachSegment(sqrt(max(0.0, bDistance2Min)), bProj > 0.0, bProj);
  }

  vec3 n0 = normalize(n);
  float dMin = abs(dot(n0, a));
  vec3 abUnit = normalize(s.end - s.start);
  vec3 ac = viewerPosition - s.start;
  vec3 perpReach = dot(ac, n0) * n0;
  float k = dot(
    cross(s.start + perpReach - viewerPosition, abUnit),
    cross(rayUnit, abUnit)
  );
  return RayReachSegment(dMin, k > 0.0, k);
}

vec3 traceRhombicDemo(vec3 viewerPosition, vec3 rayUnit, float time) {
  vec3 totalColor = vec3(0.01, 0.01, 0.03);
  vec3 colorCap = vec3(0.72, 0.8, 0.92);
  vec3 baseLight = vec3(0.012, 0.008, 0.034);
  vec3 bounceTint = vec3(0.01, 0.005, 0.03);

  vec3 currentViewer = viewerPosition;
  vec3 currentRayUnit = rayUnit;
  int inMirror = 0;

  for (int bounce = 0; bounce <= MAX_REFLECTIONS; ++bounce) {
    if (all(greaterThanEqual(totalColor, colorCap))) {
      break;
    }

    bool hitMirror = false;
    RayMirrorHit nearest = RayMirrorHit(false, vec3(0.0), 1e9, vec3(0.0));

    for (int mi = 0; mi < MIRROR_COUNT; ++mi) {
      MirrorTriangle mirror = getMirror(mi, time);
      RayMirrorHit hit = tryReflectRayWithMirror(currentViewer, currentRayUnit, mirror);
      if (hit.hit && hit.travel > 0.01 && hit.travel < nearest.travel) {
        hitMirror = true;
        nearest = hit;
      }
    }

    bool firstBounce = inMirror == 0;
    float attenuation = pow(float(inMirror) / 2.0 + 2.0, 3.0);

    for (int i = 0; i < SEGMENT_COUNT; ++i) {
      Segment segment = getSegment(i, time);
      RayReachSegment reach = rayClosestPointToLine(currentViewer, currentRayUnit, segment);

      if (hitMirror && reach.traveled > nearest.travel) {
        continue;
      }
      if (firstBounce && !reach.positiveSide) {
        continue;
      }

      float distance = max(0.001, reach.distance - 0.42);
      float colorScale = 1.8 / pow(distance * 0.06 + 0.01, 1.8) / attenuation;
      totalColor += baseLight * colorScale;
      totalColor = min(totalColor, colorCap);
    }

    if (!hitMirror) {
      break;
    }

    totalColor += bounceTint / (1.0 + float(inMirror) * 0.7);
    currentViewer = nearest.point;
    currentRayUnit = nearest.nextRayUnit;
    inMirror += 1;
  }

  return totalColor;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
  float time = iTime;

  vec3 focus = vec3(0.0, 0.0, 0.0);
  float orbitAngle = time * 0.36;
  float radialPulse = 1.08 + 0.52 * sin(time * 0.91) + 0.24 * sin(time * 1.77);
  vec3 orbitOffset = vec3(
    cos(orbitAngle) * 610.0 + sin(orbitAngle * 0.79) * 110.0,
    sin(orbitAngle * 0.63) * 240.0 + sin(orbitAngle * 1.41) * 70.0,
    sin(orbitAngle) * 500.0 + cos(orbitAngle * 1.17) * 150.0
  );
  vec3 cameraPosition = focus + orbitOffset * radialPulse;

  mat3 cameraBasis = lookAt(cameraPosition, focus);
  vec3 rayUnit = normalize(cameraBasis * vec3(uv, 2.0));

  vec3 color = traceRhombicDemo(cameraPosition, rayUnit, time);
  color *= 0.95;
  color = color / (1.0 + color * 0.34);
  color = pow(color, vec3(0.4545));

  fragColor = vec4(color, 1.0);
}
