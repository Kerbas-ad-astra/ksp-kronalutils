Shader "KVV/Hidden/Edge Detect Normals2" {
Properties {
	_MainTex ("Base (RGB)", Rect) = "white" {}
	_NormalPower ("Normal power", Range(0.0, 10.0)) = 1.5
	_DepthPower ("Depth power", Range(0.0, 10.0)) = 1.5
}

SubShader {
	Pass {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }

Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 14 to 14
//   d3d9 - ALU: 23 to 23
//   d3d11 - ALU: 5 to 5, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 5 to 5, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Vector 9 [_MainTex_TexelSize]
"!!ARBvp1.0
# 14 ALU
PARAM c[10] = { { 0 },
		state.matrix.mvp,
		state.matrix.texture[0],
		program.local[9] };
TEMP R0;
TEMP R1;
MOV R1.zw, c[0].x;
MOV R1.xy, vertex.texcoord[0];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
MOV R0.w, -c[9].y;
MOV R0.z, c[9].x;
MOV result.texcoord[0].xy, R0;
MOV result.texcoord[1].xy, R0;
ADD result.texcoord[2].xy, R0, -c[9];
ADD result.texcoord[3].xy, R0, R0.zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture0]
Vector 8 [_MainTex_TexelSize]
"vs_2_0
; 23 ALU
def c9, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.x, c9
slt r0.z, c8.y, r0.x
max r1.x, -r0.z, r0.z
slt r1.y, c9.x, r1.x
mov r0.zw, c9.x
mov r0.xy, v1
dp4 r1.x, r0, c4
dp4 r0.x, r0, c5
add r1.z, -r1.y, c9.y
mul r0.z, r0.x, r1
add r0.y, -r0.x, c9
mad r1.y, r1, r0, r0.z
mov r0.w, -c8.y
mov r0.z, c8.x
mov oT1.xy, r1
add oT2.xy, r1, -c8
add oT3.xy, r1, r0.zwzw
mov oT0.y, r0.x
mov oT0.x, r1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 48 // 48 used size, 4 vars
Vector 32 [_MainTex_TexelSize] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
ConstBuffer "UnityPerDrawTexMatrices" 768 // 576 used size, 5 vars
Matrix 512 [glstate_matrix_texture0] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
BindCB "UnityPerDrawTexMatrices" 2
// 12 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedogmpgcejjngofmnlchjdpkjkjcpbdlkoabaaaaaadeadaaaaadaaaaaa
cmaaaaaaiaaaaaaacaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaadamaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaadamaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklkl
fdeieefcamacaaaaeaaaabaaidaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaa
fjaaaaaeegiocaaaabaaaaaaaeaaaaaafjaaaaaeegiocaaaacaaaaaaccaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaa
aaaaaaaafgbfbaaaabaaaaaaegiacaaaacaaaaaacbaaaaaadcaaaaakdcaabaaa
aaaaaaaaegiacaaaacaaaaaacaaaaaaaagbabaaaabaaaaaaegaabaaaaaaaaaaa
dgaaaaafdccabaaaabaaaaaaegaabaaaaaaaaaaadgaaaaafdccabaaaacaaaaaa
egaabaaaaaaaaaaaaaaaaaajdccabaaaadaaaaaaegaabaaaaaaaaaaaegiacaia
ebaaaaaaaaaaaaaaacaaaaaaaaaaaaaibccabaaaaeaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaacaaaaaaaaaaaaajcccabaaaaeaaaaaabkaabaaaaaaaaaaa
bkiacaiaebaaaaaaaaaaaaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD0_3;
varying highp vec2 xlv_TEXCOORD0_2;
varying highp vec2 xlv_TEXCOORD0_1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_TexelSize;
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = _glesMultiTexCoord0.xy;
  highp vec2 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.x = tmpvar_1.x;
  tmpvar_3.y = tmpvar_1.y;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_texture0 * tmpvar_3);
  tmpvar_2 = tmpvar_4.xy;
  highp vec2 tmpvar_5;
  tmpvar_5.x = -(_MainTex_TexelSize.x);
  tmpvar_5.y = -(_MainTex_TexelSize.y);
  highp vec2 tmpvar_6;
  tmpvar_6.x = _MainTex_TexelSize.x;
  tmpvar_6.y = -(_MainTex_TexelSize.y);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD0_1 = tmpvar_2;
  xlv_TEXCOORD0_2 = (tmpvar_4.xy + tmpvar_5);
  xlv_TEXCOORD0_3 = (tmpvar_4.xy + tmpvar_6);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0_3;
varying highp vec2 xlv_TEXCOORD0_2;
varying highp vec2 xlv_TEXCOORD0_1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _CameraDepthNormalsTexture;
uniform highp float _DepthPower;
uniform highp float _NormalPower;
uniform sampler2D _MainTex;
void main ()
{
  mediump vec4 sample2_1;
  mediump vec4 sample1_2;
  mediump vec4 center_3;
  mediump vec4 original_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  original_4 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_CameraDepthNormalsTexture, xlv_TEXCOORD0_1);
  center_3 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_CameraDepthNormalsTexture, xlv_TEXCOORD0_2);
  sample1_2 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthNormalsTexture, xlv_TEXCOORD0_3);
  sample2_1 = tmpvar_8;
  highp vec2 enc_9;
  enc_9 = center_3.zw;
  highp float tmpvar_10;
  tmpvar_10 = dot (enc_9, vec2(1.0, 0.00392157));
  mediump float isSameDepth_11;
  mediump vec2 diff_12;
  mediump vec2 tmpvar_13;
  tmpvar_13 = abs((center_3.xy - sample1_2.xy));
  highp vec2 tmpvar_14;
  tmpvar_14 = pow (tmpvar_13, vec2(_NormalPower));
  diff_12 = tmpvar_14;
  highp vec2 enc_15;
  enc_15 = sample1_2.zw;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((tmpvar_10 - (10.0 * pow (abs((tmpvar_10 - dot (enc_15, vec2(1.0, 0.00392157)))), _DepthPower))) / tmpvar_10), 0.0, 1.0);
  isSameDepth_11 = tmpvar_16;
  mediump float isSameDepth_17;
  mediump vec2 diff_18;
  mediump vec2 tmpvar_19;
  tmpvar_19 = abs((center_3.xy - sample2_1.xy));
  highp vec2 tmpvar_20;
  tmpvar_20 = pow (tmpvar_19, vec2(_NormalPower));
  diff_18 = tmpvar_20;
  highp vec2 enc_21;
  enc_21 = sample2_1.zw;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((tmpvar_10 - (10.0 * pow (abs((tmpvar_10 - dot (enc_21, vec2(1.0, 0.00392157)))), _DepthPower))) / tmpvar_10), 0.0, 1.0);
  isSameDepth_17 = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = ((original_4 * (clamp ((1.0 - (5.0 * (diff_12.x + diff_12.y))), 0.0, 1.0) * isSameDepth_11)) * (clamp ((1.0 - (5.0 * (diff_18.x + diff_18.y))), 0.0, 1.0) * isSameDepth_17));
  original_4 = tmpvar_23;
  gl_FragData[0] = tmpvar_23;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD0_3;
varying highp vec2 xlv_TEXCOORD0_2;
varying highp vec2 xlv_TEXCOORD0_1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_TexelSize;
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = _glesMultiTexCoord0.xy;
  highp vec2 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.x = tmpvar_1.x;
  tmpvar_3.y = tmpvar_1.y;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_texture0 * tmpvar_3);
  tmpvar_2 = tmpvar_4.xy;
  highp vec2 tmpvar_5;
  tmpvar_5.x = -(_MainTex_TexelSize.x);
  tmpvar_5.y = -(_MainTex_TexelSize.y);
  highp vec2 tmpvar_6;
  tmpvar_6.x = _MainTex_TexelSize.x;
  tmpvar_6.y = -(_MainTex_TexelSize.y);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD0_1 = tmpvar_2;
  xlv_TEXCOORD0_2 = (tmpvar_4.xy + tmpvar_5);
  xlv_TEXCOORD0_3 = (tmpvar_4.xy + tmpvar_6);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0_3;
varying highp vec2 xlv_TEXCOORD0_2;
varying highp vec2 xlv_TEXCOORD0_1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _CameraDepthNormalsTexture;
uniform highp float _DepthPower;
uniform highp float _NormalPower;
uniform sampler2D _MainTex;
void main ()
{
  mediump vec4 sample2_1;
  mediump vec4 sample1_2;
  mediump vec4 center_3;
  mediump vec4 original_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  original_4 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_CameraDepthNormalsTexture, xlv_TEXCOORD0_1);
  center_3 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_CameraDepthNormalsTexture, xlv_TEXCOORD0_2);
  sample1_2 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthNormalsTexture, xlv_TEXCOORD0_3);
  sample2_1 = tmpvar_8;
  highp vec2 enc_9;
  enc_9 = center_3.zw;
  highp float tmpvar_10;
  tmpvar_10 = dot (enc_9, vec2(1.0, 0.00392157));
  mediump float isSameDepth_11;
  mediump vec2 diff_12;
  mediump vec2 tmpvar_13;
  tmpvar_13 = abs((center_3.xy - sample1_2.xy));
  highp vec2 tmpvar_14;
  tmpvar_14 = pow (tmpvar_13, vec2(_NormalPower));
  diff_12 = tmpvar_14;
  highp vec2 enc_15;
  enc_15 = sample1_2.zw;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((tmpvar_10 - (10.0 * pow (abs((tmpvar_10 - dot (enc_15, vec2(1.0, 0.00392157)))), _DepthPower))) / tmpvar_10), 0.0, 1.0);
  isSameDepth_11 = tmpvar_16;
  mediump float isSameDepth_17;
  mediump vec2 diff_18;
  mediump vec2 tmpvar_19;
  tmpvar_19 = abs((center_3.xy - sample2_1.xy));
  highp vec2 tmpvar_20;
  tmpvar_20 = pow (tmpvar_19, vec2(_NormalPower));
  diff_18 = tmpvar_20;
  highp vec2 enc_21;
  enc_21 = sample2_1.zw;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((tmpvar_10 - (10.0 * pow (abs((tmpvar_10 - dot (enc_21, vec2(1.0, 0.00392157)))), _DepthPower))) / tmpvar_10), 0.0, 1.0);
  isSameDepth_17 = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = ((original_4 * (clamp ((1.0 - (5.0 * (diff_12.x + diff_12.y))), 0.0, 1.0) * isSameDepth_11)) * (clamp ((1.0 - (5.0 * (diff_18.x + diff_18.y))), 0.0, 1.0) * isSameDepth_17));
  original_4 = tmpvar_23;
  gl_FragData[0] = tmpvar_23;
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture0]
Vector 8 [_MainTex_TexelSize]
"agal_vs
c9 0.0 0.0 0.0 0.0
[bc]
aaaaaaaaabaaamacajaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.zw, c9.x
aaaaaaaaabaaadacadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r1.xy, a3
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, r1, c4
bdaaaaaaaaaaacacabaaaaoeacaaaaaaafaaaaoeabaaaaaa dp4 r0.y, r1, c5
aaaaaaaaabaaapacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c8
bfaaaaaaaaaaaiacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa neg r0.w, r1.y
aaaaaaaaaaaaaeacaiaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.z, c8.x
aaaaaaaaaaaaadaeaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov v0.xy, r0.xyyy
aaaaaaaaabaaadaeaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.xyyy
acaaaaaaacaaadaeaaaaaafeacaaaaaaaiaaaaoeabaaaaaa sub v2.xy, r0.xyyy, c8
abaaaaaaadaaadaeaaaaaafeacaaaaaaaaaaaapoacaaaaaa add v3.xy, r0.xyyy, r0.zwww
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.zw, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 48 // 48 used size, 4 vars
Vector 32 [_MainTex_TexelSize] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
ConstBuffer "UnityPerDrawTexMatrices" 768 // 576 used size, 5 vars
Matrix 512 [glstate_matrix_texture0] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
BindCB "UnityPerDrawTexMatrices" 2
// 12 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedaeofdibfjfajgpdmeechencdaeodkejpabaaaaaaieaeaaaaaeaaaaaa
daaaaaaahmabaaaajaadaaaaoeadaaaaebgpgodjeeabaaaaeeabaaaaaaacpopp
piaaaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaacaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaacaacaaaacaaagaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
afaaaaadaaaaadiaabaaffjaahaaoekaaeaaaaaeaaaaadiaagaaoekaabaaaaja
aaaaoeiaacaaaaadacaaadoaaaaaoeiaabaaoekbacaaaaadadaaaboaaaaaaaia
abaaaakaacaaaaadadaaacoaaaaaffiaabaaffkbafaaaaadabaaapiaaaaaffja
adaaoekaaeaaaaaeabaaapiaacaaoekaaaaaaajaabaaoeiaaeaaaaaeabaaapia
aeaaoekaaaaakkjaabaaoeiaaeaaaaaeabaaapiaafaaoekaaaaappjaabaaoeia
aeaaaaaeaaaaadmaabaappiaaaaaoekaabaaoeiaabaaaaacaaaaammaabaaoeia
abaaaaacaaaaadoaaaaaoeiaabaaaaacabaaadoaaaaaoeiappppaaaafdeieefc
amacaaaaeaaaabaaidaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaaaaae
egiocaaaabaaaaaaaeaaaaaafjaaaaaeegiocaaaacaaaaaaccaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagiaaaaacabaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaaaaaaaaa
fgbfbaaaabaaaaaaegiacaaaacaaaaaacbaaaaaadcaaaaakdcaabaaaaaaaaaaa
egiacaaaacaaaaaacaaaaaaaagbabaaaabaaaaaaegaabaaaaaaaaaaadgaaaaaf
dccabaaaabaaaaaaegaabaaaaaaaaaaadgaaaaafdccabaaaacaaaaaaegaabaaa
aaaaaaaaaaaaaaajdccabaaaadaaaaaaegaabaaaaaaaaaaaegiacaiaebaaaaaa
aaaaaaaaacaaaaaaaaaaaaaibccabaaaaeaaaaaaakaabaaaaaaaaaaaakiacaaa
aaaaaaaaacaaaaaaaaaaaaajcccabaaaaeaaaaaabkaabaaaaaaaaaaabkiacaia
ebaaaaaaaaaaaaaaacaaaaaadoaaaaabejfdeheoemaaaaaaacaaaaaaaiaaaaaa
diaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfc
eeaaklklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaadamaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfcee
aaklklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;

#line 150
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 186
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 180
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 311
struct v2f {
    highp vec4 pos;
    highp vec2 uv[4];
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_LightPosition[4];
uniform highp vec4 unity_LightAtten[4];
#line 19
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHBr;
#line 23
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
#line 27
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
uniform highp vec4 _LightSplitsNear;
#line 31
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
#line 35
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 _Object2World;
#line 39
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
uniform highp mat4 glstate_matrix_texture0;
#line 43
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
uniform highp mat4 glstate_matrix_projection;
#line 47
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 unity_ColorSpaceGrey;
#line 76
#line 81
#line 86
#line 90
#line 95
#line 119
#line 136
#line 157
#line 165
#line 192
#line 205
#line 214
#line 219
#line 228
#line 233
#line 242
#line 259
#line 264
#line 290
#line 298
#line 302
#line 306
uniform sampler2D _MainTex;
uniform highp float _NormalPower;
uniform highp float _DepthPower;
uniform sampler2D _CameraDepthNormalsTexture;
#line 310
uniform highp vec4 _MainTex_TexelSize;
#line 317
#line 192
highp vec2 MultiplyUV( in highp mat4 mat, in highp vec2 inUV ) {
    highp vec4 temp = vec4( inUV.x, inUV.y, 0.0, 0.0);
    temp = (mat * temp);
    #line 196
    return temp.xy;
}
#line 317
v2f vert( in appdata_img v ) {
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 321
    highp vec2 uv = MultiplyUV( glstate_matrix_texture0, v.texcoord);
    o.uv[0] = uv;
    o.uv[1] = uv;
    o.uv[2] = (uv + (vec2( (-_MainTex_TexelSize.x), (-_MainTex_TexelSize.y)) * 1.0));
    #line 325
    o.uv[3] = (uv + (vec2( _MainTex_TexelSize.x, (-_MainTex_TexelSize.y)) * 1.0));
    return o;
}
out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD0_1;
out highp vec2 xlv_TEXCOORD0_2;
out highp vec2 xlv_TEXCOORD0_3;
void main() {
    v2f xl_retval;
    appdata_img xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.texcoord = vec2(gl_MultiTexCoord0);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.uv[0]);
    xlv_TEXCOORD0_1 = vec2(xl_retval.uv[1]);
    xlv_TEXCOORD0_2 = vec2(xl_retval.uv[2]);
    xlv_TEXCOORD0_3 = vec2(xl_retval.uv[3]);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 150
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 186
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 180
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 311
struct v2f {
    highp vec4 pos;
    highp vec2 uv[4];
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_LightPosition[4];
uniform highp vec4 unity_LightAtten[4];
#line 19
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHBr;
#line 23
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
#line 27
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
uniform highp vec4 _LightSplitsNear;
#line 31
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
#line 35
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 _Object2World;
#line 39
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
uniform highp mat4 glstate_matrix_texture0;
#line 43
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
uniform highp mat4 glstate_matrix_projection;
#line 47
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 unity_ColorSpaceGrey;
#line 76
#line 81
#line 86
#line 90
#line 95
#line 119
#line 136
#line 157
#line 165
#line 192
#line 205
#line 214
#line 219
#line 228
#line 233
#line 242
#line 259
#line 264
#line 290
#line 298
#line 302
#line 306
uniform sampler2D _MainTex;
uniform highp float _NormalPower;
uniform highp float _DepthPower;
uniform sampler2D _CameraDepthNormalsTexture;
#line 310
uniform highp vec4 _MainTex_TexelSize;
#line 317
#line 228
highp float DecodeFloatRG( in highp vec2 enc ) {
    highp vec2 kDecodeDot = vec2( 1.0, 0.00392157);
    return dot( enc, kDecodeDot);
}
#line 328
mediump float CheckSame( in mediump vec2 centerNormal, in highp float centerDepth, in mediump vec4 xlat_var_sample ) {
    #line 330
    mediump vec2 diff = pow( abs((centerNormal - xlat_var_sample.xy)), vec2( _NormalPower));
    mediump float isSameNormal = xll_saturate_f((1.0 - (5.0 * (diff.x + diff.y))));
    highp float sampleDepth = DecodeFloatRG( xlat_var_sample.zw);
    highp float zdiff = pow( abs((centerDepth - sampleDepth)), _DepthPower);
    #line 334
    mediump float isSameDepth = xll_saturate_f(((centerDepth - (10.0 * zdiff)) / centerDepth));
    return (isSameNormal * isSameDepth);
}
#line 337
mediump vec4 frag( in v2f i ) {
    #line 339
    mediump vec4 original = texture( _MainTex, i.uv[0]);
    mediump vec4 center = texture( _CameraDepthNormalsTexture, i.uv[1]);
    mediump vec4 sample1 = texture( _CameraDepthNormalsTexture, i.uv[2]);
    mediump vec4 sample2 = texture( _CameraDepthNormalsTexture, i.uv[3]);
    #line 343
    mediump vec2 centerNormal = center.xy;
    highp float centerDepth = DecodeFloatRG( center.zw);
    original *= CheckSame( centerNormal, centerDepth, sample1);
    original *= CheckSame( centerNormal, centerDepth, sample2);
    #line 347
    return original;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD0_1;
in highp vec2 xlv_TEXCOORD0_2;
in highp vec2 xlv_TEXCOORD0_3;
void main() {
    mediump vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv[0] = vec2(xlv_TEXCOORD0);
    xlt_i.uv[1] = vec2(xlv_TEXCOORD0_1);
    xlt_i.uv[2] = vec2(xlv_TEXCOORD0_2);
    xlt_i.uv[3] = vec2(xlv_TEXCOORD0_3);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 37 to 37, TEX: 4 to 4
//   d3d9 - ALU: 56 to 56, TEX: 4 to 4
//   d3d11 - ALU: 29 to 29, TEX: 4 to 4, FLOW: 1 to 1
//   d3d11_9x - ALU: 29 to 29, TEX: 4 to 4, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Float 0 [_NormalPower]
Float 1 [_DepthPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_CameraDepthNormalsTexture] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 37 ALU, 4 TEX
PARAM c[3] = { program.local[0..1],
		{ 1, 5, 0.0039215689, 10 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R3, fragment.texcoord[1], texture[1], 2D;
TEX R1, fragment.texcoord[3], texture[1], 2D;
TEX R2, fragment.texcoord[2], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R2.zw, R2, c[2].xyxz;
MUL R1.zw, R1, c[2].xyxz;
ADD R2.xy, R3, -R2;
ABS R2.xy, R2;
ADD R1.xy, R3, -R1;
ABS R1.xy, R1;
ADD R1.z, R1, R1.w;
POW R2.x, R2.x, c[0].x;
POW R2.y, R2.y, c[0].x;
ADD R2.y, R2.x, R2;
ADD R2.w, R2.z, R2;
MUL R3.zw, R3, c[2].xyxz;
ADD R2.z, R3, R3.w;
ADD R2.w, R2.z, -R2;
ABS R2.x, R2.w;
POW R2.w, R2.x, c[1].x;
ADD R1.z, R2, -R1;
RCP R2.x, R2.z;
MAD R2.w, -R2, c[2], R2.z;
ABS R1.z, R1;
POW R1.w, R1.x, c[0].x;
POW R1.x, R1.z, c[1].x;
POW R1.y, R1.y, c[0].x;
MAD R1.x, -R1, c[2].w, R2.z;
ADD R1.z, R1.w, R1.y;
MUL_SAT R1.y, R2.x, R1.x;
MAD_SAT R1.x, -R1.z, c[2].y, c[2];
MAD_SAT R2.y, -R2, c[2], c[2].x;
MUL_SAT R2.w, R2, R2.x;
MUL R2.y, R2, R2.w;
MUL R1.x, R1, R1.y;
MUL R0, R0, R2.y;
MUL result.color, R0, R1.x;
END
# 37 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_NormalPower]
Float 1 [_DepthPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_CameraDepthNormalsTexture] 2D
"ps_2_0
; 56 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
def c2, 1.00000000, 0.00392157, 10.00000000, 5.00000000
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t3.xy
texld r4, t0, s0
texld r5, t2, s1
texld r0, t3, s1
texld r6, t1, s1
add_pp r0.xy, r6, -r0
abs_pp r0.xy, r0
pow_pp r1.z, r0.y, c0.x
pow_pp r2.z, r0.x, c0.x
add_pp r5.xy, r6, -r5
mov_pp r0.x, r1.z
mov_pp r1.x, r2.z
add_pp r0.x, r1, r0
mov r1.y, r0.w
mov r1.x, r0.z
mul r1.xy, r1, c2
mov r2.x, r6.z
mov r2.y, r6.w
mul r3.xy, r2, c2
add r2.x, r1, r1.y
add r1.x, r3, r3.y
add r2.x, r1, -r2
mov r3.y, r5.w
mov r3.x, r5.z
abs_pp r6.xy, r5
pow_pp r5.x, r6.x, c0.x
mul r7.xy, r3, c2
abs r2.x, r2
pow r3.y, r2.x, c1.x
add r2.x, r7, r7.y
mov r7.x, r3.y
add r2.x, r1, -r2
abs r3.x, r2
pow r8.x, r3.x, c1.x
rcp r2.x, r1.x
mad r7.x, -r7, c2.z, r1
mov r3.x, r8.x
mad r1.x, -r3, c2.z, r1
pow_pp r3.y, r6.y, c0.x
mul_sat r1.x, r1, r2
mul_sat r7.x, r2, r7
mad_pp_sat r0.x, -r0, c2.w, c2
mul_pp r0.x, r0, r7
add_pp r3.x, r5.x, r3.y
mad_pp_sat r2.x, -r3, c2.w, c2
mul_pp r1.x, r2, r1
mul_pp r1, r4, r1.x
mul_pp r0, r1, r0.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { }
ConstBuffer "$Globals" 48 // 24 used size, 4 vars
Float 16 [_NormalPower]
Float 20 [_DepthPower]
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_CameraDepthNormalsTexture] 2D 1
// 38 instructions, 4 temp regs, 0 temp arrays:
// ALU 29 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedlpoeddjpdagidbjbkmndgaoolbobiflnabaaaaaabaagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfagphdgjhegjgpgoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcaiafaaaaeaaaaaaaecabaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaaddcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaad
dcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaaaaaaaaaidcaabaaaaaaaaaaaegaabaiaebaaaaaaaaaaaaaaegaabaaa
abaaaaaaapaaaaakecaabaaaaaaaaaaaogakbaaaaaaaaaaaaceaaaaaaaaaiadp
ibiaiadlaaaaaaaaaaaaaaaacpaaaaagdcaabaaaaaaaaaaaegaabaiaibaaaaaa
aaaaaaaadiaaaaaidcaabaaaaaaaaaaaegaabaaaaaaaaaaaagiacaaaaaaaaaaa
abaaaaaabjaaaaafdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaaaaaaahbcaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaa
akaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaakaeaabeaaaaaaaaaiadpdeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaapaaaaakccaabaaa
aaaaaaaaogakbaaaabaaaaaaaceaaaaaaaaaiadpibiaiadlaaaaaaaaaaaaaaaa
aaaaaaaiecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaabkaabaaaaaaaaaaa
cpaaaaagecaabaaaaaaaaaaackaabaiaibaaaaaaaaaaaaaadiaaaaaiecaabaaa
aaaaaaaackaabaaaaaaaaaaabkiacaaaaaaaaaaaabaaaaaabjaaaaafecaabaaa
aaaaaaaackaabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaackaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaacaebbkaabaaaaaaaaaaaaocaaaahecaabaaaaaaaaaaa
ckaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaackaabaaa
aaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaaagaabaaa
aaaaaaaaegaobaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaaeaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaaapaaaaakbcaabaaaaaaaaaaaogakbaaa
adaaaaaaaceaaaaaaaaaiadpibiaiadlaaaaaaaaaaaaaaaaaaaaaaaimcaabaaa
aaaaaaaaagaebaaaabaaaaaaagaebaiaebaaaaaaadaaaaaacpaaaaagmcaabaaa
aaaaaaaakgaobaiaibaaaaaaaaaaaaaadiaaaaaimcaabaaaaaaaaaaakgaobaaa
aaaaaaaaagiacaaaaaaaaaaaabaaaaaabjaaaaafmcaabaaaaaaaaaaakgaobaaa
aaaaaaaaaaaaaaahecaabaaaaaaaaaaadkaabaaaaaaaaaaackaabaaaaaaaaaaa
dcaaaaakecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaakaea
abeaaaaaaaaaiadpdeaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaa
aaaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaabkaabaaa
aaaaaaaacpaaaaagbcaabaaaaaaaaaaaakaabaiaibaaaaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkiacaaaaaaaaaaaabaaaaaabjaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaabeaaaaaaaaacaebbkaabaaaaaaaaaaaaocaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaackaabaaaaaaaaaaadiaaaaahpccabaaaaaaaaaaaagaabaaa
aaaaaaaaegaobaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { }
ConstBuffer "$Globals" 48 // 24 used size, 4 vars
Float 16 [_NormalPower]
Float 20 [_DepthPower]
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_CameraDepthNormalsTexture] 2D 1
// 38 instructions, 4 temp regs, 0 temp arrays:
// ALU 29 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedhfaohclgadnnkldmemmdnemnjgoocndoabaaaaaajiajaaaaaeaaaaaa
daaaaaaaleadaaaameaiaaaageajaaaaebgpgodjhmadaaaahmadaaaaaaacpppp
eeadaaaadiaaaaaaabaacmaaaaaadiaaaaaadiaaacaaceaaaaaadiaaaaaaaaaa
abababaaaaaaabaaabaaaaaaaaaaaaaaaaacppppfbaaaaafabaaapkaaaaaiadp
ibiaiadlaaaakaeaaaaaaaaafbaaaaafacaaapkaaaaacaebaaaaaaaaaaaaaaaa
aaaaaaaabpaaaaacaaaaaaiaaaaaadlabpaaaaacaaaaaaiaabaaadlabpaaaaac
aaaaaaiaacaaadlabpaaaaacaaaaaaiaadaaadlabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkaecaaaaadaaaacpiaacaaoelaabaioekaecaaaaad
abaacpiaabaaoelaabaioekaecaaaaadacaacpiaaaaaoelaaaaioekaecaaaaad
adaacpiaadaaoelaabaioekaacaaaaadaaaacdiaaaaaoeibabaaoeiaafaaaaad
aaaaaeiaaaaakkiaabaaaakaaeaaaaaeaaaaaeiaaaaappiaabaaffkaaaaakkia
cdaaaaacaaaaadiaaaaaoeiaapaaaaacaeaaabiaaaaaaaiaapaaaaacaeaaacia
aaaaffiaafaaaaadaaaaadiaaeaaoeiaaaaaaakaaoaaaaacaaaacbiaaaaaaaia
aoaaaaacaaaacciaaaaaffiaacaaaaadaaaacbiaaaaaffiaaaaaaaiaaeaaaaae
aaaacbiaaaaaaaiaabaakkkbabaaaakaalaaaaadaeaacbiaaaaaaaiaabaappka
afaaaaadaaaaabiaabaakkiaabaaaakaaeaaaaaeaaaaabiaabaappiaabaaffka
aaaaaaiaacaaaaadaaaaaciaaaaakkibaaaaaaiacdaaaaacaaaaaciaaaaaffia
caaaaaadabaaaeiaaaaaffiaaaaaffkaaeaaaaaeaaaaaciaabaakkiaacaaaakb
aaaaaaiaagaaaaacaaaaaeiaaaaaaaiaafaaaaadaaaadciaaaaakkiaaaaaffia
afaaaaadaaaacciaaaaaffiaaeaaaaiaafaaaaadacaacpiaaaaaffiaacaaoeia
afaaaaadaaaaaciaadaakkiaabaaaakaaeaaaaaeaaaaaciaadaappiaabaaffka
aaaaffiaacaaaaadabaacdiaabaaoeiaadaaoeibcdaaaaacabaaadiaabaaoeia
acaaaaadaaaaaciaaaaaffibaaaaaaiacdaaaaacaaaaaciaaaaaffiacaaaaaad
abaaaeiaaaaaffiaaaaaffkaaeaaaaaeaaaaabiaabaakkiaacaaaakbaaaaaaia
afaaaaadaaaadbiaaaaakkiaaaaaaaiaapaaaaacadaaabiaabaaaaiaapaaaaac
adaaaciaabaaffiaafaaaaadaaaaagiaadaanciaaaaaaakaaoaaaaacaaaaccia
aaaaffiaaoaaaaacaaaaceiaaaaakkiaacaaaaadaaaacciaaaaakkiaaaaaffia
aeaaaaaeaaaacciaaaaaffiaabaakkkbabaaaakaalaaaaadabaacbiaaaaaffia
abaappkaafaaaaadaaaacbiaaaaaaaiaabaaaaiaafaaaaadaaaacpiaaaaaaaia
acaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcaiafaaaaeaaaaaaa
ecabaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaafkaaaaadaagabaaaaaaaaaaa
fkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
adaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaaidcaabaaa
aaaaaaaaegaabaiaebaaaaaaaaaaaaaaegaabaaaabaaaaaaapaaaaakecaabaaa
aaaaaaaaogakbaaaaaaaaaaaaceaaaaaaaaaiadpibiaiadlaaaaaaaaaaaaaaaa
cpaaaaagdcaabaaaaaaaaaaaegaabaiaibaaaaaaaaaaaaaadiaaaaaidcaabaaa
aaaaaaaaegaabaaaaaaaaaaaagiacaaaaaaaaaaaabaaaaaabjaaaaafdcaabaaa
aaaaaaaaegaabaaaaaaaaaaaaaaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaakaeaabeaaaaaaaaaiadpdeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaapaaaaakccaabaaaaaaaaaaaogakbaaaabaaaaaa
aceaaaaaaaaaiadpibiaiadlaaaaaaaaaaaaaaaaaaaaaaaiecaabaaaaaaaaaaa
ckaabaiaebaaaaaaaaaaaaaabkaabaaaaaaaaaaacpaaaaagecaabaaaaaaaaaaa
ckaabaiaibaaaaaaaaaaaaaadiaaaaaiecaabaaaaaaaaaaackaabaaaaaaaaaaa
bkiacaaaaaaaaaaaabaaaaaabjaaaaafecaabaaaaaaaaaaackaabaaaaaaaaaaa
dcaaaaakecaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaacaeb
bkaabaaaaaaaaaaaaocaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaabkaabaaa
aaaaaaaadiaaaaahbcaabaaaaaaaaaaackaabaaaaaaaaaaaakaabaaaaaaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaa
efaaaaajpcaabaaaadaaaaaaegbabaaaaeaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaaapaaaaakbcaabaaaaaaaaaaaogakbaaaadaaaaaaaceaaaaaaaaaiadp
ibiaiadlaaaaaaaaaaaaaaaaaaaaaaaimcaabaaaaaaaaaaaagaebaaaabaaaaaa
agaebaiaebaaaaaaadaaaaaacpaaaaagmcaabaaaaaaaaaaakgaobaiaibaaaaaa
aaaaaaaadiaaaaaimcaabaaaaaaaaaaakgaobaaaaaaaaaaaagiacaaaaaaaaaaa
abaaaaaabjaaaaafmcaabaaaaaaaaaaakgaobaaaaaaaaaaaaaaaaaahecaabaaa
aaaaaaaadkaabaaaaaaaaaaackaabaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaa
ckaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaakaeaabeaaaaaaaaaiadpdeaaaaah
ecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaabkaabaaaaaaaaaaacpaaaaagbcaabaaa
aaaaaaaaakaabaiaibaaaaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaabkiacaaaaaaaaaaaabaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaa
aaaacaebbkaabaaaaaaaaaaaaocaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
bkaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaackaabaaa
aaaaaaaadiaaaaahpccabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaa
doaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaadadaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}

#LINE 89

		}
	}
	Fallback off
}