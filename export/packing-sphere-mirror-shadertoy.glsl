// ShaderToy export of the packing sphere mirror demo.
// Uses iResolution and iTime only.

#define MAX_REFLECTIONS 24
#define MIRROR_COUNT 9

struct RayMirrorHit {
  bool hit;
  vec3 point;
  float travel;
  vec3 nextRayUnit;
};

struct SphereMirror {
  vec3 center;
  float radius;
  bool outside;
};

float hash11(float n) {
  return fract(sin(n) * 43758.5453123);
}

bool isInsideSphere(vec3 point, SphereMirror mirror) {
  vec3 delta = point - mirror.center;
  return dot(delta, delta) < mirror.radius * mirror.radius;
}

vec3 palette(float t) {
  float phaseA = 0.5 + 0.5 * cos(t);
  float phaseB = 0.5 + 0.5 * cos(t + 1.7);
  float phaseC = 0.5 + 0.5 * cos(t + 3.4);
  vec3 darkPurple = vec3(0.07, 0.0, 0.12);
  vec3 brightPurple = vec3(0.72, 0.36, 0.92);
  vec3 whiteGlow = vec3(0.95, 0.95, 0.98);
  vec3 purpleBand = mix(darkPurple, brightPurple, phaseA);
  return mix(purpleBand, whiteGlow, phaseB * 0.45 + phaseC * 0.2);
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

RayMirrorHit reflectRayWithSphere(
  vec3 viewerPosition,
  vec3 rayUnit,
  vec3 center,
  float radius,
  bool outside
) {
  vec3 centerToViewer = center - viewerPosition;
  bool viewerInside = dot(centerToViewer, centerToViewer) < radius * radius;

  if (outside) {
    if (viewerInside) {
      return makeMiss();
    }

    float projection = dot(centerToViewer, rayUnit);
    if (projection < 0.0) {
      return makeMiss();
    }

    vec3 distanceToRay = centerToViewer - projection * rayUnit;
    float distanceSq = dot(distanceToRay, distanceToRay);
    if (distanceSq > radius * radius) {
      return makeMiss();
    }

    float distanceToHit = sqrt(radius * radius - distanceSq);
    float traveled = projection - distanceToHit;
    vec3 hitPoint = viewerPosition + traveled * rayUnit;
    vec3 nextRay = reflect(rayUnit, normalize(hitPoint - center));
    return RayMirrorHit(true, hitPoint, traveled, nextRay);
  }

  float projection = dot(centerToViewer, rayUnit);
  if (projection < 0.0) {
    return makeMiss();
  }

  vec3 distanceToRay = centerToViewer - projection * rayUnit;
  float distanceSq = dot(distanceToRay, distanceToRay);
  if (distanceSq > radius * radius) {
    return makeMiss();
  }

  float distanceToHit = sqrt(radius * radius - distanceSq);
  float traveled = projection + distanceToHit;
  vec3 hitPoint = viewerPosition + traveled * rayUnit;
  vec3 nextRay = reflect(rayUnit, normalize(hitPoint - center));
  return RayMirrorHit(true, hitPoint, traveled, nextRay);
}

SphereMirror getMirror(int index) {
  float largeRadius = 200.0;
  float centerRadius = largeRadius * (sqrt(3.0) - 1.0);
  if (index == 0) return SphereMirror(vec3(  0.0,   0.0,   0.0), largeRadius, true);
  if (index == 1) return SphereMirror(vec3(400.0,   0.0,   0.0), largeRadius, true);
  if (index == 2) return SphereMirror(vec3(  0.0, 400.0,   0.0), largeRadius, true);
  if (index == 3) return SphereMirror(vec3(400.0, 400.0,   0.0), largeRadius, true);
  if (index == 4) return SphereMirror(vec3(  0.0,   0.0, 400.0), largeRadius, true);
  if (index == 5) return SphereMirror(vec3(400.0,   0.0, 400.0), largeRadius, true);
  if (index == 6) return SphereMirror(vec3(  0.0, 400.0, 400.0), largeRadius, true);
  if (index == 7) return SphereMirror(vec3(400.0, 400.0, 400.0), largeRadius, true);
  return SphereMirror(vec3(200.0, 200.0, 200.0), centerRadius, true);
}

int findContainingSphere(vec3 point) {
  for (int i = 0; i < MIRROR_COUNT; ++i) {
    SphereMirror mirror = getMirror(i);
    if (isInsideSphere(point, mirror)) {
      return i;
    }
  }
  return -1;
}

vec3 tracePackingSphereMirror(vec3 viewerPosition, vec3 rayUnit, float time) {
  vec3 currentViewer = viewerPosition;
  vec3 currentRayUnit = rayUnit;
  vec3 totalColor = vec3(0.0);
  float attenuation = 0.92;
  int initialInteriorSphere = findContainingSphere(viewerPosition);
  bool startedInsideCenter = initialInteriorSphere == MIRROR_COUNT - 1;

  for (int bounce = 0; bounce <= MAX_REFLECTIONS; ++bounce) {
    RayMirrorHit nearest = makeMiss();
    float nearestTravel = 1e9;
    int mirrorIndex = -1;

    for (int i = 0; i < MIRROR_COUNT; ++i) {
      SphereMirror mirror = getMirror(i);
      if (bounce == 0 && i == initialInteriorSphere) {
        continue;
      }
      if (startedInsideCenter && i == MIRROR_COUNT - 1 && isInsideSphere(currentViewer, mirror)) {
        continue;
      }

      RayMirrorHit hit = reflectRayWithSphere(
        currentViewer,
        currentRayUnit,
        mirror.center,
        mirror.radius,
        mirror.outside
      );

      if (hit.hit && hit.travel > 0.01 && hit.travel < nearestTravel) {
        nearest = hit;
        nearestTravel = hit.travel;
        mirrorIndex = i;
      }
    }

    if (mirrorIndex < 0) {
      vec3 skyA = vec3(0.015, 0.025, 0.04);
      vec3 skyB = vec3(0.08, 0.045, 0.025);
      float horizon = clamp(0.5 + 0.5 * currentRayUnit.y, 0.0, 1.0);
      totalColor += mix(skyA, skyB, horizon) * attenuation * 0.45;
      break;
    }

    vec3 bounceColor = palette(time * 0.9 + float(mirrorIndex) * 0.85 + float(bounce) * 0.12);
    vec3 hitNormal = normalize(nearest.point - getMirror(mirrorIndex).center);
    float viewDot = max(0.0, dot(-currentRayUnit, hitNormal));
    float fresnel = pow(1.0 - viewDot, 3.0);
    float rim = pow(1.0 - viewDot, 6.0);
    float bounceBoost = mix(0.95, 1.55, smoothstep(1.0, 10.0, float(bounce)));
    float deepBounceLift = 1.0 + smoothstep(4.0, 14.0, float(bounce)) * 0.45;
    vec3 sharpenedColor = mix(bounceColor * 0.18, bounceColor * bounceColor * 1.55, 0.45);
    totalColor += (sharpenedColor * mix(0.34, 0.82, fresnel) + bounceColor * rim * 0.22) * attenuation * bounceBoost * deepBounceLift;

    currentViewer = nearest.point + nearest.nextRayUnit * 0.02;
    currentRayUnit = nearest.nextRayUnit;
    attenuation *= 0.9;
  }

  return totalColor;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
  float time = iTime;

  vec3 focus = vec3(200.0, 200.0, 200.0);
  float orbitAngle = time * 0.28;
  float radialPulse = 1.0 + 0.42 * sin(time * 0.83) + 0.2 * sin(time * 1.71);
  vec3 orbitOffset = vec3(
    cos(orbitAngle) * 620.0 + sin(orbitAngle * 0.93) * 90.0,
    sin(orbitAngle * 0.61) * 170.0 + sin(orbitAngle * 1.73) * 55.0,
    sin(orbitAngle) * 460.0 + cos(orbitAngle * 1.21) * 110.0
  );
  vec3 cameraPosition = focus + orbitOffset * radialPulse;

  mat3 cameraBasis = lookAt(cameraPosition, focus);
  vec3 rayUnit = normalize(cameraBasis * vec3(uv, 1.9));

  vec3 color = tracePackingSphereMirror(cameraPosition, rayUnit, time);
  color *= 0.68;
  color = color / (1.0 + color * 0.38);

  float vignette = smoothstep(1.55, 0.15, length(uv));
  color *= mix(0.82, 1.0, vignette);
  color = pow(color, vec3(0.4545));

  fragColor = vec4(color, 1.0);
}
