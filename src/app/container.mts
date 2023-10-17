import sdfWgsl from "../../shaders/sdf.wgsl";
import starWgsl from "../../shaders/star.wgsl";
import strokeWgsl from "../../shaders/stroke.wgsl";

import { group, object } from "../alias.mjs";
import { LagopusElement } from "../primes.mjs";

export let compContainer = (): LagopusElement => {
  return group(
    null,
    object({
      shader: strokeWgsl,
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

console.log("Container");
