//
//  cube.metal
//  blockens
//
//  Created by Bjorn Tipling on 7/22/16.
//  Copyright (c) 2016 apphacker. All rights reserved.
//

#include "utils.h"

vertex VertextOut cubeVertex(uint vid [[ vertex_id ]],
                                     constant packed_float2* position  [[ buffer(0) ]]) {

    VertextOut outVertex;

    float2 pos = position[vid];
    pos *= 0.5;
    outVertex.position = float4(pos[0], pos[1], 0.0, 1.0);
    return outVertex;
}

fragment float4 cubeFragment(VertextOut inFrag [[stage_in]]) {

    return float4(0.0, 0.5, 1.0, 1.0);
}