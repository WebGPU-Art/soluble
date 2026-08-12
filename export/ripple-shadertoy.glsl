// ShaderToy export of the ripple demo.
// Uses iResolution and iTime only.

#define BASE_POINT_COUNT 80

const float PI = 3.14159265358532374;

float rand11(float n) {
  return fract(sin(n) * 43758.5453123);
}

vec3 rand31(float n) {
  return vec3(
    rand11(n + 0.123),
    rand11(n + 1.234),
    rand11(n + 2.345)
  );
}

vec2 product(vec2 a, vec2 b) {
  return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

vec2 conjugate(vec2 a) {
  return vec2(a.x, -a.y);
}

vec2 perpendicular(vec2 p, vec2 p1, vec2 p2) {
  float x = p.x;
  float y = p.y;
  float a = p1.x;
  float b = p1.y;
  float c = p2.x;
  float d = p2.y;
  float k = -((a - x) * (c - a) + (b - y) * (d - b)) / ((a - c) * (a - c) + (b - d) * (b - d));
  return vec2(a + (c - a) * k, b + (d - b) * k);
}

float lengthSquare(vec2 a) {
  return dot(a, a);
}

bool isOutsideLine(vec2 p, vec2 p1, vec2 p2) {
  vec2 perp = perpendicular(p, p1, p2);
  float lSq = lengthSquare(perp);
  return product(p, conjugate(perp)).x > lSq;
}

vec2 reflectionLine(vec2 p, vec2 p1, vec2 p2, float skip, float regress) {
  vec2 perp = perpendicular(p, p1, p2);
  vec2 d = perp - p;
  float ld = length(d);
  return perp + (d + (-skip * d / max(ld, 0.0001))) * regress;
}

mat3 lookAt(vec3 eye, vec3 target) {
  vec3 forward = normalize(target - eye);
  vec3 worldUp = vec3(0.0, 1.0, 0.0);
  vec3 right = normalize(cross(forward, worldUp));
  vec3 up = cross(right, forward);
  return mat3(right, up, forward);
}

vec3 getBasePoint(float idx) {
  vec3 noise = rand31(idx * 7.173);
  return (noise - 0.5) * 800.0;
}

vec3 traceRipple(vec2 coord, vec3 viewerPosition, mat3 cameraBasis, float time) {
  vec2 p = coord * 0.0005;
  vec3 rayUnit = normalize(cameraBasis * vec3(p, 2.0));

  for (int j = 0; j < BASE_POINT_COUNT; ++j) {
    float idx = float(j);
    vec3 basePoint = getBasePoint(idx);
    vec3 a = basePoint - viewerPosition;

    vec3 n1 = cross(a, rayUnit);
    float n1Len = length(n1);
    if (n1Len < 0.00001) {
      continue;
    }

    vec3 n2 = normalize(cross(rayUnit, n1));
    float d = abs(dot(n2, a));

    float randV1 = rand11(idx + 0.5);
    float randV2 = rand11(idx + 0.6);
    float randV3 = rand11(idx + 0.7);

    float r = 300.0 * randV2;
    float speed = 0.00008 * randV1;
    float gap = 3.2 * randV1;

    if (d < r) {
      float v = fract(time * 1000.0 * speed) * 400.0;
      if (abs(d - v) < 0.01 + gap) {
        return vec3(randV1, randV2, randV3);
      }
    }
  }

  return vec3(-1.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 coord = (fragCoord - 0.5 * iResolution.xy) * 2.0;
  float time = iTime;

  float parts = 2.4;
  float radius = 400.0;
  float unit = 2.0 * PI / parts;

  float opacity = 1.0;

  if (length(coord) < radius * 40.0) {
    for (int i = 0; i < 10; ++i) {
      float pointAngle = atan(coord.y, coord.x);
      float atPart = floor(pointAngle / unit);
      vec2 p1 = vec2(cos(atPart * unit), sin(atPart * unit)) * radius;
      vec2 p2 = vec2(cos((atPart + 1.0) * unit), sin((atPart + 1.0) * unit)) * radius;

      if (isOutsideLine(coord, p1, p2)) {
        coord = reflectionLine(coord, p1, p2, 0.0, 1.0);
        continue;
      }
      break;
    }
  }

  vec3 focus = vec3(0.0, 0.0, 0.0);
  vec3 cameraPosition = vec3(
    sin(time * 0.37) * 140.0,
    sin(time * 0.21) * 90.0,
    600.0 + cos(time * 0.29) * 180.0 + sin(time * 0.63) * 60.0
  );
  mat3 cameraBasis = lookAt(cameraPosition, focus);

  vec3 hitColor = traceRipple(coord, cameraPosition, cameraBasis, time);

  vec3 color;
  if (hitColor.x >= 0.0) {
    color = hitColor * opacity;
  } else if (opacity > 0.9) {
    color = vec3(0.0);
  } else {
    color = vec3(0.2);
  }

  float vignette = smoothstep(1.4, 0.15, length((fragCoord - 0.5 * iResolution.xy) / iResolution.y));
  color *= mix(0.82, 1.0, vignette);
  fragColor = vec4(color, 1.0);
}