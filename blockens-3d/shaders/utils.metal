
#include "utils.h"

float4 rgbaToNormalizedGPUColors(int r, int g, int b) {
    return float4(float(r)/255.0, float(g)/255.0, float(b)/255.0, 1.0);
}

float3 crossProduct(float3 a, float3 b) {

    float3 product;

    float x1 = a[0];
    float y1 = a[1];
    float z1 = a[2];

    float x2 = b[0];
    float y2 = b[1];
    float z2 = b[2];

    product[0] = y1 * z2 + z1 * y2;
    product[1] = z1 * x2 + x1 * z2;
    product[2] = x1 * y2 + y1 * x2;

    return product;
}

float dotProduct3(float3 a, float3 b) {
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2] + a[3] * b[3];
}

float dotProduct4(float4 a, float4 b) {
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2] + a[3] * b[3];
}

float3 scaleVector3(float scalar, float3 vector) {
    float3 result;
    for (int i = 0; i < 3; i++) {
        result[i] = vector[i] * scalar;
    }
    return result;
}

float4 scaleVector4(float scalar, float4 vector) {
    float4 result;
    for (int i = 0; i < 4; i++) {
        result[i] = vector[i] * scalar;
    }
    return result;
}

float3 negateVector3(float3 vector) {
    float3 result;
    for (int i = 0; i < 3; i++) {
        result[i] = vector[i] * -1;
    }
    return result;

}

float4 negateVector4(float4 vector) {
    float4 result;
    for (int i = 0; i < 3; i++) {
        result[i] = vector[i] * -1;
    }
    return result;

}

float3 addVector3(float3 a, float3 b) {
    float3 result;
    for (int i = 0; i < 3; i++) {
        result[i] = a[i] + b[i];
    }
    return result;
}

float4 addVector4(float4 a, float4 b) {
    float4 result;
    for (int i = 0; i < 4; i++) {
        result[i] = a[i] + b[i];
    }
    return result;
}

float3 subtractVector3(float3 a, float3 b) {
    return addVector3(a, negateVector3(b));
}

float4 subtractVector4(float4 a, float4 b) {
    return addVector4(a, negateVector4(b));
}

float3 getVectorTo3(float3 from, float3 to) {
    return subtractVector3(to, from);
}

float4 getVectorTo4(float4 from, float4 to) {
    return subtractVector4(to, from);
}

float vectorMagnitude3(float3 vector) {
    float result;
    for (int i = 0; i < 3; i++) {
        result += pow(vector[i], 2);
    }
    return sqrt(result);
}

float vectorMagnitude4(float4 vector) {
    float result;
    for (int i = 0; i < 4; i++) {
        result += pow(vector[i], 2);
    }
    return sqrt(result);
}

float3 toUnitVector3(float3 vector) {
    float magnitude = vectorMagnitude3(vector);

    float3 result;

    for (int i = 0; i < 3; i++) {
        result[i] = vector[i]/magnitude;
    }

    return result;
}

float4 toUnitVector4(float4 vector) {
    float magnitude = vectorMagnitude4(vector);

    float4 result;

    for (int i = 0; i < 4; i++) {
        result[i] = vector[i]/magnitude;
    }

    return result;
}

float distance3(float3 from, float3 to) {

    float3 vector = getVectorTo3(from, to);

    return vectorMagnitude3(vector);
}

float distance4(float4 from, float4 to) {

    float4 vector = getVectorTo4(from, to);

    return vectorMagnitude4(vector);
}

float3x3 scale3x3(float scalar, float3x3 m) {
    float3x3 result;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; i++) {
            result[i][j] = m[i][j] * scalar;
        }
    }
    return result;
}

float4x4 scale4x4(float scalar, float3x3 m) {
    float4x4 result;
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; i++) {
            result[i][j] = m[i][j] * scalar;
        }
    }
    return result;
}

float3x3 matrixProduct3x3(float3x3 m1, float3x3 m2) {

    float3x3 result;

    for (int i = 0; i < 4; i++) {
        float3 rowM1 = float3(m1[0][i], m1[1][i], m1[2][i]);
        result[i] = dotProduct3(rowM1, m2[i]);
    }

    return result;
}

float4x4 matrixProduct4x4(float4x4 m1, float4x4 m2) {

    float4x4 result;

    for (int i = 0; i < 4; i++) {
        float4 rowM1 = float4(m1[0][i], m1[1][i], m1[2][i], m1[3][i]);
        result[i] = dotProduct4(rowM1, m2[i]);
    }

    return result;
}