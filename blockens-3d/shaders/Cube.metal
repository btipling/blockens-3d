//
//  cube.metal
//  blockens
//
//  Created by Bjorn Tipling on 7/22/16.
//  Copyright (c) 2016 apphacker. All rights reserved.
//

#include "utils.h"

struct CubeRotation {
    float x;
    float y;
    float z;
};

vertex CubeOut cubeVertex(uint vid [[ vertex_id ]],
                                     constant packed_float3* position  [[ buffer(0) ]],
                                     constant packed_float3* colors  [[ buffer(1) ]],
                                     constant CubeRotation* cubeRotation [[ buffer(2)]]) {

    CubeOut outVertex;

    // Projection angle:
    //float3 n = float3(0.5, 0.5, 0.3);
    float3 n = float3(0.03, 0.03, 0.03);
    float nx = n[0];
    float ny = n[1];
    float nz = n[2];

    float3 m1 = float3(1 - (nx * nx), (-nx) * ny, (-nx) * nz);

    float3 m2 = float3((-nx) * ny, 1 - (ny * ny), (-ny) * nz);

    float3 m3 = float3((-nx) * nz, (-ny) * nz, 1 - (nz * nz));


    float3 pos = position[vid];

    float3 proj_pos = pos;

    proj_pos[0] = pos[0] * m1[0] + pos[1] * m1[1] + pos[2] * m1[2];
    proj_pos[1] = pos[0] * m2[0] + pos[1] * m2[1] + pos[2] * m2[2];
    proj_pos[2] = pos[0] * m3[0] + pos[1] * m3[1] + pos[2] * m3[2];

    proj_pos *= 0.5;


    outVertex.position = float4(proj_pos[0], proj_pos[1], proj_pos[2], 1.0);

    uint face = vid / 6;
    float3 color = colors[face];
    outVertex.color = float4(color[0], color[1], color[2], 1.0);

    return outVertex;
}

fragment float4 cubeFragment(CubeOut inFrag [[stage_in]]) {
    return inFrag.color;
}