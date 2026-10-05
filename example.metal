#pragma clang diagnostic ignored "-Wmissing-prototypes"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct main0_out {
  float2 f_uv        [[user(locn0)]];
  float4 f_c0        [[user(locn1)]];
  float4 f_c1        [[user(locn2)]];
  float4 gl_Position [[position]];
};

struct vtx_t {
  float4 rect;
  float4 uv;
  uint c0;
  uint c1;
  float2 scr;
};

struct vtx_t_1
{
    float4 rect;
    float4 uv;
    uint c0;
    uint c1;
    float2 scr;
};

struct vtx_buf
{
    vtx_t_1 vtx[1];
};


static inline __attribute__((always_inline))
float4 colour(thread const uint& c)
{
    uint r = (c >> uint(24)) & 255u;
    uint g = (c >> uint(16)) & 255u;
    uint b = (c >> uint(8)) & 255u;
    uint a = c & 255u;
    return float4(float(r), float(g), float(b), float(a)) / float4(255.0);
}

vertex main0_out main0(const device vtx_buf& _56 [[buffer(0)]], uint gl_InstanceIndex [[instance_id]], uint gl_VertexIndex [[vertex_id]])
{
    vtx_t v;
    v.rect = _56.vtx[int(gl_InstanceIndex)].rect;
    v.uv = _56.vtx[int(gl_InstanceIndex)].uv;
    v.c0 = _56.vtx[int(gl_InstanceIndex)].c0;
    v.c1 = _56.vtx[int(gl_InstanceIndex)].c1;
    v.scr = _56.vtx[int(gl_InstanceIndex)].scr;

    float2 p = float2(float(int(gl_VertexIndex) & 1), float((int(gl_VertexIndex) >> 1) & 1));
    float2 f_uv = v.uv.xy + (p * v.uv.zw);
    uint param = v.c0;
    float4 f_c0 = colour(param);
    uint param_1 = v.c1;
    float4 f_c1 = colour(param_1);
    p = (v.rect.xy + (p * v.rect.zw)) / v.scr;
    p = (p * 2.0) - float2(1.0);
    float4 gl_Position = float4(p, 0.0f, 1.0f);
    gl_Position.y = -gl_Position.y;

    main0_out stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.f_uv = f_uv;
    stage_output.f_c0 = f_c0;
    stage_output.f_c1 = f_c1;
    return stage_output;
}
