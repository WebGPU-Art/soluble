import triangleWgsl from "../../shaders/triangle.wgsl";
import sdfWgsl from "../../shaders/sdf.wgsl";

import { flattenData, group, object } from "../alias.mjs";
import { LagopusElement, V3 } from "../primes.mjs";

export let compContainer = (store: { position: V3 }): LagopusElement => {
  return group(
    // object({
    //   shader: triangleWgsl,
    //   topology: "triangle-list",
    //   // topology: "line-strip",
    //   attrsList: [
    //     { field: "position", format: "float32x4", size: 4 },
    //     { field: "color", format: "float32x4", size: 4 },
    //   ],
    //   data: [
    //     { position: [-100.0, -100.0, 0.3, 1], color: [1, 0, 0, 1] },
    //     { position: [-0.0, 100.0, 100, 1], color: [1, 1, 0, 1] },
    //     { position: [100.0, -100.0, -100, 1], color: [0, 0, 1, 1] },
    //   ],
    // })
    object({
      shader: sdfWgsl,
      topology: "triangle-list",
      // topology: "line-strip",
      attrsList: [{ field: "position", format: "float32x2", size: 2 }],
      data: [
        {
          position: [-1, -1],
        },
        { position: [-1, 1] },
        { position: [1, -1] },
        { position: [1, 1] },
      ],
      indices: [0, 1, 2, 1, 2, 3],
    })
  );
};
