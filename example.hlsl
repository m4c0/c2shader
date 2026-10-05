struct main0_out {
  float2 f_uv        : TEXCOORD0;
  float4 f_c0        : TEXCOORD1;
  float4 f_c1        : TEXCOORD2;
  float4 gl_Position : SV_Position;
};

struct vtx_t {
  float4 rect;
  float4 uv;
  uint c0;
  uint c1;
  float2 scr;
};

struct main0_in {
  uint gl_VertexIndex   : SV_VertexID;
  uint gl_InstanceIndex : SV_InstanceID;
};

float4 colour(uint c) {
  uint r = (c >> uint(24)) & 255u;
  uint g = (c >> uint(16)) & 255u;
  uint b = (c >> uint(8)) & 255u;
  uint a = c & 255u;
  return float4(float(r), float(g), float(b), float(a)) / 255.0f.xxxx;
}

StructuredBuffer<vtx_t> _56 : register(t0);
main0_out main(main0_in stage_input) {
    vtx_t v = _56[stage_input.gl_InstanceIndex];

    float2 p = float2(float(stage_input.gl_VertexIndex & 1), float((stage_input.gl_VertexIndex >> 1) & 1));
    float2 f_uv = v.uv.xy + (p * v.uv.zw);
    uint param = v.c0;
    float4 f_c0 = colour(param);
    uint param_1 = v.c1;
    float4 f_c1 = colour(param_1);
    p = (v.rect.xy + (p * v.rect.zw)) / v.scr;
    p = (p * 2.0f) - 1.0f.xx;
    float4 gl_Position = float4(p, 0.0f, 1.0f);
    gl_Position.y = -gl_Position.y;

    main0_out stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.f_uv = f_uv;
    stage_output.f_c0 = f_c0;
    stage_output.f_c1 = f_c1;
    return stage_output;
}
