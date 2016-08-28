
#ifndef utils_h
#define utils_h


#include <metal_stdlib>

using namespace metal;


struct VertextOut {
    float4  position [[position]];
};

struct CubeOut {
    float4  position [[position]];
    float4 color;
};

float4 rgbaToNormalizedGPUColors(int r, int g, int b);

#endif /* utils_h */