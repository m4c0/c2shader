#if HLSL
#  define LOC(n) : TEXCOORD##n
#  define POS    : SV_Position
#  define VID    : SV_VertexID
#  define IID    : SV_InstanceID
#  define VERTEX(res, name, b0, ...) \
  StructuredBuffer<b0> _56 : register(t0); \
  res name(__VA_ARGS__)
#elif METAL
#pragma clang diagnostic ignored "-Wmissing-prototypes"
#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
#  define LOC(n) [[user(loc##n)]]
#  define POS    [[position]]
#  define VID    [[vertex_id]]
#  define IID    [[instance_id]]
#  define VERTEX(res, name, b0, ...) vertex res name(const device b0 * _56 [[buffer(0)]], __VA_ARGS__)
#else
#  error Unsupported
#endif

struct main0_out {
  float2 f_uv        LOC(0);
  float4 f_c0        LOC(1);
  float4 f_c1        LOC(2);
  float4 gl_Position POS;
};

struct vtx_t {
  float4 rect;
  float4 uv;
  uint c0;
  uint c1;
  float2 scr;
};

float4 colour(uint c) {
  uint r = (c >> uint(24)) & 255u;
  uint g = (c >> uint(16)) & 255u;
  uint b = (c >> uint(8)) & 255u;
  uint a = c & 255u;
  return float4(float(r), float(g), float(b), float(a)) / 255.0f;
}

VERTEX(main0_out, main, vtx_t, uint gl_VertexIndex VID, uint gl_InstanceIndex IID) {
  vtx_t v = _56[gl_InstanceIndex];

  float2 p = float2(gl_VertexIndex & 1, (gl_VertexIndex >> 1) & 1);
  float2 f_uv = v.uv.xy + (p * v.uv.zw);
  p = (v.rect.xy + (p * v.rect.zw)) / v.scr;
  p = (p * 2.0f) - 1.0f;

  main0_out stage_output;
  stage_output.gl_Position = float4(p, 0.0f, 1.0f);
  stage_output.f_uv = f_uv;
  stage_output.f_c0 = colour(v.c0);
  stage_output.f_c1 = colour(v.c1);
  return stage_output;
}
