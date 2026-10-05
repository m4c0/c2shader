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

ByteAddressBuffer _56 : register(t0);

static float4 gl_Position;
static int gl_VertexIndex;
static int gl_InstanceIndex;
static float2 f_uv;
static float4 f_c0;
static float4 f_c1;

struct SPIRV_Cross_Input
{
    uint gl_VertexIndex : SV_VertexID;
    uint gl_InstanceIndex : SV_InstanceID;
};

float4 colour(uint c)
{
    uint r = (c >> uint(24)) & 255u;
    uint g = (c >> uint(16)) & 255u;
    uint b = (c >> uint(8)) & 255u;
    uint a = c & 255u;
    return float4(float(r), float(g), float(b), float(a)) / 255.0f.xxxx;
}

main0_out main(SPIRV_Cross_Input stage_input)
{
    gl_VertexIndex = int(stage_input.gl_VertexIndex);
    gl_InstanceIndex = int(stage_input.gl_InstanceIndex);

    vtx_t _63;
    _63.rect = asfloat(_56.Load4(gl_InstanceIndex * 48 + 0));
    _63.uv = asfloat(_56.Load4(gl_InstanceIndex * 48 + 16));
    _63.c0 = _56.Load(gl_InstanceIndex * 48 + 32);
    _63.c1 = _56.Load(gl_InstanceIndex * 48 + 36);
    _63.scr = asfloat(_56.Load2(gl_InstanceIndex * 48 + 40));
    vtx_t v;
    v.rect = _63.rect;
    v.uv = _63.uv;
    v.c0 = _63.c0;
    v.c1 = _63.c1;
    v.scr = _63.scr;
    float2 p = float2(float(gl_VertexIndex & 1), float((gl_VertexIndex >> 1) & 1));
    f_uv = v.uv.xy + (p * v.uv.zw);
    uint param = v.c0;
    f_c0 = colour(param);
    uint param_1 = v.c1;
    f_c1 = colour(param_1);
    p = (v.rect.xy + (p * v.rect.zw)) / v.scr;
    p = (p * 2.0f) - 1.0f.xx;
    gl_Position = float4(p, 0.0f, 1.0f);
    gl_Position.y = -gl_Position.y;

    main0_out stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.f_uv = f_uv;
    stage_output.f_c0 = f_c0;
    stage_output.f_c1 = f_c1;
    return stage_output;
}

