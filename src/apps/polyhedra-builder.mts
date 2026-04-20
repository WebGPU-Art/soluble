import { Number4 } from "../math.mjs";

export type V3 = [number, number, number];
export type Cell = { position: Number4; velocity: Number4; arm: Number4 };

const ZERO4: Number4 = [0, 0, 0, 0];

const add = (a: V3, b: V3): V3 => [a[0] + b[0], a[1] + b[1], a[2] + b[2]];

const sub = (a: V3, b: V3): V3 => [a[0] - b[0], a[1] - b[1], a[2] - b[2]];

const scale = (v: V3, factor: number): V3 => [v[0] * factor, v[1] * factor, v[2] * factor];

const dot = (a: V3, b: V3): number => a[0] * b[0] + a[1] * b[1] + a[2] * b[2];

const cross = (a: V3, b: V3): V3 => [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];

const norm = (v: V3): number => Math.sqrt(dot(v, v));

const normalize = (v: V3): V3 => {
  const length = norm(v);
  return length === 0 ? [0, 0, 0] : [v[0] / length, v[1] / length, v[2] / length];
};

const toCell = (a: V3, b: V3, c: V3): Cell => {
  return {
    position: [a[0], a[1], a[2], 0],
    velocity: [b[0], b[1], b[2], 0],
    arm: [c[0], c[1], c[2], 0],
  };
};

const faceKey = (indices: number[]): string =>
  indices
    .slice()
    .sort((a, b) => a - b)
    .join(",");

const orderFace = (vertices: V3[], indices: number[], normal: V3): number[] => {
  const points = indices.map((idx) => vertices[idx]);
  const center = scale(
    points.reduce((acc, point) => add(acc, point), [0, 0, 0] as V3),
    1 / points.length
  );
  const basisU = normalize(sub(points[0], center));
  const basisV = normalize(cross(normal, basisU));

  return indices.slice().sort((ia, ib) => {
    const pa = sub(vertices[ia], center);
    const pb = sub(vertices[ib], center);
    const angleA = Math.atan2(dot(pa, basisV), dot(pa, basisU));
    const angleB = Math.atan2(dot(pb, basisV), dot(pb, basisU));
    return angleA - angleB;
  });
};

export const uniqueVertices = (vertices: V3[], epsilon = 1e-6): V3[] => {
  const seen = new Set<string>();
  const result: V3[] = [];

  for (const vertex of vertices) {
    const key = vertex.map((value) => value.toFixed(Math.max(0, Math.round(-Math.log10(epsilon))))).join(",");
    if (!seen.has(key)) {
      seen.add(key);
      result.push(vertex);
    }
  }

  return result;
};

export const scaleVerticesToRadius = (vertices: V3[], radius: number): V3[] => {
  const maxRadius = Math.max(...vertices.map((vertex) => norm(vertex)));
  const factor = maxRadius === 0 ? 1 : radius / maxRadius;
  return vertices.map((vertex) => scale(vertex, factor));
};

export const createZonotopeVertices = (generators: V3[]): V3[] => {
  const vertices: V3[] = [];

  for (let mask = 0; mask < 1 << generators.length; mask++) {
    let point: V3 = [0, 0, 0];
    for (let i = 0; i < generators.length; i++) {
      if ((mask & (1 << i)) !== 0) {
        point = add(point, generators[i]);
      }
    }
    vertices.push(point);
  }

  const unique = uniqueVertices(vertices);
  const center = scale(
    unique.reduce((acc, point) => add(acc, point), [0, 0, 0] as V3),
    1 / unique.length
  );
  return unique.map((point) => sub(point, center));
};

export const buildConvexFaces = (vertices: V3[], epsilon = 1e-5): number[][] => {
  const faceNormals = new Map<string, V3>();

  for (let i = 0; i < vertices.length; i++) {
    for (let j = i + 1; j < vertices.length; j++) {
      for (let k = j + 1; k < vertices.length; k++) {
        const normal0 = cross(sub(vertices[j], vertices[i]), sub(vertices[k], vertices[i]));
        const length = norm(normal0);
        if (length < epsilon) {
          continue;
        }

        let normal = scale(normal0, 1 / length);
        let planeDistance = dot(normal, vertices[i]);
        let hasPositive = false;
        let hasNegative = false;
        const coplanar: number[] = [];

        for (let m = 0; m < vertices.length; m++) {
          const side = dot(normal, vertices[m]) - planeDistance;
          if (side > epsilon) {
            hasPositive = true;
          } else if (side < -epsilon) {
            hasNegative = true;
          } else {
            coplanar.push(m);
          }
        }

        if (hasPositive && hasNegative) {
          continue;
        }

        if (hasPositive && !hasNegative) {
          normal = scale(normal, -1);
          planeDistance = -planeDistance;
        }

        if (coplanar.length < 3 || planeDistance < epsilon) {
          continue;
        }

        const key = faceKey(coplanar);
        if (!faceNormals.has(key)) {
          faceNormals.set(key, normal);
        }
      }
    }
  }

  return [...faceNormals.entries()].map(([key, normal]) => {
    const indices = key.split(",").map((value) => Number(value));
    return orderFace(vertices, indices, normal);
  });
};

export const buildDualVertices = (vertices: V3[], faces = buildConvexFaces(vertices)): V3[] => {
  return faces.map((face) => {
    const a = vertices[face[0]];
    const b = vertices[face[1]];
    const c = vertices[face[2]];
    let normal = normalize(cross(sub(b, a), sub(c, a)));
    let distance = dot(normal, a);

    if (distance < 0) {
      normal = scale(normal, -1);
      distance = -distance;
    }

    return scale(normal, 1 / distance);
  });
};

export const buildPolyhedronCells = (vertices: V3[], faces = buildConvexFaces(vertices)): { mirrors: Cell[]; segments: Cell[] } => {
  const mirrors: Cell[] = [];
  const segments: Cell[] = [];
  const edgeSet = new Set<string>();

  for (const face of faces) {
    const center = scale(
      face.map((idx) => vertices[idx]).reduce((acc, point) => add(acc, point), [0, 0, 0] as V3),
      1 / face.length
    );

    for (let i = 0; i < face.length; i++) {
      const current = vertices[face[i]];
      const next = vertices[face[(i + 1) % face.length]];
      mirrors.push(toCell(center, current, next));

      const edge = [face[i], face[(i + 1) % face.length]].sort((a, b) => a - b);
      const edgeKey = edge.join(":");
      if (!edgeSet.has(edgeKey)) {
        edgeSet.add(edgeKey);
        segments.push(toCell(vertices[edge[0]], vertices[edge[1]], [0, 0, 0]));
      }
    }
  }

  return { mirrors, segments };
};

export const zeroCellArm = (): Number4 => ZERO4;
