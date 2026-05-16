// ShaderToy export of the crystal refraction demo.
// Uses iResolution and iTime only.

#define MAX_REFLECTIONS 14
#define MIRROR_COUNT 24
#define SEGMENT_COUNT 12

struct GlassHit {
  bool hit;
  vec3 point;
  float travel;
  vec3 normal;
  vec3 reflected;
  vec3 refracted;
  float fresnel;
  bool tir;
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

const vec3 V0 = vec3(0.0, 150.0, 0.0);
const vec3 V1 = vec3(0.0, -150.0, 0.0);
const vec3 V2 = vec3(-150.0, 0.0, 0.0);
const vec3 V3 = vec3(150.0, 0.0, 0.0);
const vec3 V4 = vec3(0.0, 0.0, 150.0);
const vec3 V5 = vec3(0.0, 0.0, -150.0);

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

vec3 rotateCrystal(vec3 p, float time) {
  vec3 rotated = rotateY(p, time * 0.26);
  return rotateX(rotated, 0.22 + 0.08 * sin(time * 0.37));
}

vec3 faceCenter(vec3 a, vec3 b, vec3 c) {
  return (a + b + c) / 3.0;
}

mat3 lookAt(vec3 eye, vec3 target) {
  vec3 forward = normalize(target - eye);
  vec3 worldUp = vec3(0.0, 1.0, 0.0);
  vec3 right = normalize(cross(forward, worldUp));
  vec3 up = cross(right, forward);
  return mat3(right, up, forward);
}

float schlick(float cosTheta, float n1, float n2) {
  float r0 = pow((n1 - n2) / (n1 + n2), 2.0);
  return r0 + (1.0 - r0) * pow(1.0 - cosTheta, 5.0);
}

MirrorTriangle getMirror(int index, float time) {
  vec3 c0 = rotateCrystal(faceCenter(V0, V4, V3), time);
  vec3 c1 = rotateCrystal(faceCenter(V0, V3, V5), time);
  vec3 c2 = rotateCrystal(faceCenter(V0, V5, V2), time);
  vec3 c3 = rotateCrystal(faceCenter(V0, V2, V4), time);
  vec3 c4 = rotateCrystal(faceCenter(V1, V3, V4), time);
  vec3 c5 = rotateCrystal(faceCenter(V1, V5, V3), time);
  vec3 c6 = rotateCrystal(faceCenter(V1, V2, V5), time);
  vec3 c7 = rotateCrystal(faceCenter(V1, V4, V2), time);

  vec3 p0 = rotateCrystal(V0, time);
  vec3 p1 = rotateCrystal(V1, time);
  vec3 p2 = rotateCrystal(V2, time);
  vec3 p3 = rotateCrystal(V3, time);
  vec3 p4 = rotateCrystal(V4, time);
  vec3 p5 = rotateCrystal(V5, time);

  if (index == 0) return MirrorTriangle(c0, p0, p4);
  if (index == 1) return MirrorTriangle(c0, p4, p3);
  if (index == 2) return MirrorTriangle(c0, p3, p0);
  if (index == 3) return MirrorTriangle(c1, p0, p3);
  if (index == 4) return MirrorTriangle(c1, p3, p5);
  if (index == 5) return MirrorTriangle(c1, p5, p0);
  if (index == 6) return MirrorTriangle(c2, p0, p5);
  if (index == 7) return MirrorTriangle(c2, p5, p2);
  if (index == 8) return MirrorTriangle(c2, p2, p0);
  if (index == 9) return MirrorTriangle(c3, p0, p2);
  if (index == 10) return MirrorTriangle(c3, p2, p4);
  if (index == 11) return MirrorTriangle(c3, p4, p0);
  if (index == 12) return MirrorTriangle(c4, p1, p3);
  if (index == 13) return MirrorTriangle(c4, p3, p4);
  if (index == 14) return MirrorTriangle(c4, p4, p1);
  if (index == 15) return MirrorTriangle(c5, p1, p5);
  if (index == 16) return MirrorTriangle(c5, p5, p3);
  if (index == 17) return MirrorTriangle(c5, p3, p1);
  if (index == 18) return MirrorTriangle(c6, p1, p2);
  if (index == 19) return MirrorTriangle(c6, p2, p5);
  if (index == 20) return MirrorTriangle(c6, p5, p1);
  if (index == 21) return MirrorTriangle(c7, p1, p4);
  if (index == 22) return MirrorTriangle(c7, p4, p2);
  return MirrorTriangle(c7, p2, p1);
}

Segment getSegment(int index, float time) {
  vec3 p0 = rotateCrystal(V0, time);
  vec3 p1 = rotateCrystal(V1, time);
  vec3 p2 = rotateCrystal(V2, time);
  vec3 p3 = rotateCrystal(V3, time);
  vec3 p4 = rotateCrystal(V4, time);
  vec3 p5 = rotateCrystal(V5, time);

  if (index == 0) return Segment(p0, p4);
  if (index == 1) return Segment(p4, p3);
  if (index == 2) return Segment(p3, p0);
  if (index == 3) return Segment(p3, p5);
  if (index == 4) return Segment(p5, p0);
  if (index == 5) return Segment(p5, p2);
  if (index == 6) return Segment(p2, p0);
  if (index == 7) return Segment(p2, p4);
  if (index == 8) return Segment(p1, p3);
  if (index == 9) return Segment(p1, p4);
  if (index == 10) return Segment(p1, p5);
  return Segment(p1, p2);
}

GlassHit makeGlassMiss() {
  return GlassHit(false, vec3(0.0), 0.0, vec3(0.0), vec3(0.0), vec3(0.0), 0.0, false);
}

GlassHit tryHitGlass(vec3 viewerPosition, vec3 rayUnit, MirrorTriangle mirror, float etaGlass) {
  vec3 rawNormal = normalize(cross(mirror.b - mirror.a, mirror.c - mirror.a));
  float denom = dot(rawNormal, rayUnit);
  if (abs(denom) < 0.0001) {
    return makeGlassMiss();
  }

  float t = dot(rawNormal, mirror.a - viewerPosition) / denom;
  if (t < 0.01) {
    return makeGlassMiss();
  }

  vec3 hitPoint = viewerPosition + t * rayUnit;
  vec3 spinA = cross(hitPoint - mirror.a, mirror.b - mirror.a);
  vec3 spinB = cross(hitPoint - mirror.b, mirror.c - mirror.b);
  vec3 spinC = cross(hitPoint - mirror.c, mirror.a - mirror.c);
  bool inside = dot(spinA, spinB) > 0.0 && dot(spinB, spinC) > 0.0 && dot(spinC, spinA) > 0.0;
  if (!inside) {
    return makeGlassMiss();
  }

  vec3 normal = rawNormal;
  float n1 = 1.0;
  float n2 = etaGlass;
  if (dot(rayUnit, normal) > 0.0) {
    normal = -normal;
    n1 = etaGlass;
    n2 = 1.0;
  }

  float eta = n1 / n2;
  vec3 reflected = normalize(reflect(rayUnit, normal));
  vec3 rawRefracted = refract(rayUnit, normal, eta);
  bool tir = dot(rawRefracted, rawRefracted) < 0.00001;
  vec3 refracted = normalize(tir ? reflected : rawRefracted);
  float fresnel = tir ? 1.0 : schlick(abs(dot(-rayUnit, normal)), n1, n2);
  return GlassHit(true, hitPoint, t, normal, reflected, refracted, fresnel, tir);
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

  float nLen = length(n);
  if (nLen < 0.00001) {
    float endpointDist = min(length(shadowA), length(shadowB));
    float frontTravel = max(aProj, bProj);
    return RayReachSegment(endpointDist, frontTravel > 0.0, frontTravel);
  }

  vec3 n0 = n / nLen;
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

float sampleSegments(vec3 origin, vec3 rayUnit, float stopAt, float attenuation, bool requireFront, float offset, float time) {
  float glow = 0.0;
  for (int i = 0; i < SEGMENT_COUNT; ++i) {
    Segment segment = getSegment(i, time);
    RayReachSegment reach = rayClosestPointToLine(origin, rayUnit, segment);

    if (requireFront && !reach.positiveSide) {
      continue;
    }
    if (stopAt > 0.0 && reach.traveled > stopAt) {
      continue;
    }

    float distance = max(0.001, reach.distance - offset);
    float core = 0.85 / pow(distance * 0.16 + 0.012, 2.25);
    float halo = 0.18 / pow(distance * 0.055 + 0.04, 1.45);
    glow += (core + halo) / attenuation;
  }
  return glow;
}

vec3 traceCrystal(vec3 viewerPosition, vec3 rayUnit, float time) {
  vec3 baseLight = vec3(0.006, 0.03, 0.04);
  vec3 bounceTint = vec3(0.01, 0.018, 0.034);
  vec3 colorCap = vec3(0.82, 0.92, 1.0);
  float etaGlass = 1.49;
  float transmit = 0.78;

  vec3 totalColor = vec3(0.006, 0.010, 0.024);
  totalColor += vec3(0.004, 0.006, 0.010) * (0.5 + 0.5 * rayUnit.y);

  vec3 currentViewer = viewerPosition;
  vec3 currentRayUnit = rayUnit;

  for (int bounce = 0; bounce <= MAX_REFLECTIONS; ++bounce) {
    if (all(greaterThanEqual(totalColor, colorCap))) {
      break;
    }

    GlassHit nearest = makeGlassMiss();
    nearest.travel = 1000000.0;

    for (int mi = 0; mi < MIRROR_COUNT; ++mi) {
      MirrorTriangle mirror = getMirror(mi, time);
      GlassHit hit = tryHitGlass(currentViewer, currentRayUnit, mirror, etaGlass);
      if (hit.hit && hit.travel < nearest.travel) {
        nearest = hit;
      }
    }

    float attenuation = pow(float(bounce) / 2.0 + 1.45, 2.05);
    float lineGlow = sampleSegments(currentViewer, currentRayUnit, nearest.hit ? nearest.travel : -1.0, attenuation, bounce == 0, 0.22, time);
    totalColor += baseLight * lineGlow;

    if (!nearest.hit) {
      break;
    }

    float reflectWeight = clamp(nearest.fresnel + (1.0 - transmit) * 0.55, 0.06, 0.96);
    float transmitWeight = (1.0 - reflectWeight) * transmit;

    float reflectedProbe = sampleSegments(nearest.point + nearest.reflected * 0.18, nearest.reflected, -1.0, attenuation * 1.35, true, 0.22, time);
    float refractedProbe = sampleSegments(nearest.point + nearest.refracted * 0.18, nearest.refracted, -1.0, attenuation * 1.45, true, 0.22, time);

    totalColor += baseLight * (reflectedProbe * 0.26 * reflectWeight + refractedProbe * 0.38 * transmitWeight);
    totalColor += bounceTint * (0.12 + 0.18 * reflectWeight);
    totalColor = min(totalColor, colorCap);

    float reflectScore = reflectedProbe * reflectWeight;
    float refractScore = refractedProbe * max(0.05, transmitWeight);
    bool chooseReflect = nearest.tir || reflectScore >= refractScore;
    currentRayUnit = chooseReflect ? nearest.reflected : nearest.refracted;
    currentViewer = nearest.point + currentRayUnit * 0.35;
  }

  return totalColor;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
  float time = iTime;

  vec3 focus = vec3(0.0, 0.0, 0.0);
  float orbitAngle = time * 0.34;
  float radialPulse = 1.08 + 0.36 * sin(time * 0.89) + 0.16 * sin(time * 1.57);
  vec3 orbitOffset = vec3(
    cos(orbitAngle) * 520.0 + sin(orbitAngle * 0.91) * 85.0,
    sin(orbitAngle * 0.57) * 170.0 + sin(orbitAngle * 1.43) * 60.0,
    sin(orbitAngle) * 430.0 + cos(orbitAngle * 1.19) * 110.0
  );
  vec3 cameraPosition = focus + orbitOffset * radialPulse;

  mat3 cameraBasis = lookAt(cameraPosition, focus);
  vec3 rayUnit = normalize(cameraBasis * vec3(uv, 2.0));

  vec3 color = traceCrystal(cameraPosition, rayUnit, time);
  color *= 0.92;
  color = color / (1.0 + color * 0.32);
  color = pow(color, vec3(0.4545));

  fragColor = vec4(color, 1.0);
}