//
//  cube.metal
//  blockens
//
//  Created by Bjorn Tipling on 7/22/16.
//  Copyright (c) 2016 apphacker. All rights reserved.
//

#include "utils.h"

vertex CubeOut cubeVertex(uint vid [[ vertex_id ]],
                                     constant packed_float3* position  [[ buffer(0) ]],
                                     constant packed_float3* colors  [[ buffer(1) ]]) {

    CubeOut outVertex;

    float3 pos = position[vid];
    outVertex.position = float4(pos[0], pos[1], pos[2], 1.0);

    uint face = vid / 6;
    float3 color = colors[face % 6];
    outVertex.color = float4(color[0], color[1], color[3], 1.0);

    return outVertex;
}

fragment float4 cubeFragment(CubeOut inFrag [[stage_in]]) {

    return inFrag.color;
}