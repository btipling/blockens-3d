
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
float3 crossProduct(float3 a, float3 b);
float dotProduct3(float3 a, float3 b);
float dotProduct4(float4 a, float4 b);
float3 scaleVector3(float scalar, float3 vector);
float4 scaleVector4(float scalar, float4 vector);
float3 negateVector3(float3 vector);
float4 negateVector4(float4 vector);
float3 addVector3(float3 a, float3 b);
float4 addVector4(float4 a, float4 b);
float3 subtractVector3(float3 a, float3 b);
float4 subtractVector4(float4 a, float4 b);
float3 getVectorTo3(float3 from, float3 to);
float4 getVectorTo4(float4 from, float4 to);
float vectorMagnitude3(float3 vector);
float vectorMagnitude4(float4 vector);
float3 toUnitVector3(float3 vector);
float4 toUnitVector4(float4 vector);
float distance3(float3 from, float3 to);
float distance4(float4 from, float4 to);
float3x3 scale3x3(float scalar, float3x3 m);
float4x4 scale4x4(float scalar, float3x3 m);
float3x3 matrixProduct3x3(float3x3 m1, float3x3 m2);
float4x4 matrixProduct4x4(float4x4 m1, float4x4 m2);

#endif /* utils_h */