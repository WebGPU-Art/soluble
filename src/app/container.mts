import sdfWgsl from "../../shaders/sdf.wgsl";

import { flattenData, group, object } from "../alias.mjs";
import { LagopusElement, V3 } from "../primes.mjs";

export let compContainer = (store: { position: V3 }): LagopusElement => {
  return group(
    null,
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
