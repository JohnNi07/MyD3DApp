//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer cbPerObject
// {
//
//   float4x4 gWorld;                   // Offset:    0 Size:    64
//   float4x4 gTexTransform;            // Offset:   64 Size:    64 [unused]
//   uint gMaterialIndex;               // Offset:  128 Size:     4 [unused]
//   uint gObjPad0;                     // Offset:  132 Size:     4 [unused]
//   uint gObjPad1;                     // Offset:  136 Size:     4 [unused]
//   uint gObjPad2;                     // Offset:  140 Size:     4 [unused]
//
// }
//
// cbuffer cbPass
// {
//
//   float4x4 gView;                    // Offset:    0 Size:    64 [unused]
//   float4x4 gInvView;                 // Offset:   64 Size:    64 [unused]
//   float4x4 gProj;                    // Offset:  128 Size:    64 [unused]
//   float4x4 gInvProj;                 // Offset:  192 Size:    64 [unused]
//   float4x4 gViewProj;                // Offset:  256 Size:    64
//   float4x4 gInvViewProj;             // Offset:  320 Size:    64 [unused]
//   float3 gEyePosW;                   // Offset:  384 Size:    12
//   float cbPerObjectPad1;             // Offset:  396 Size:     4 [unused]
//   float2 gRenderTargetSize;          // Offset:  400 Size:     8 [unused]
//   float2 gInvRenderTargetSize;       // Offset:  408 Size:     8 [unused]
//   float gNearZ;                      // Offset:  416 Size:     4 [unused]
//   float gFarZ;                       // Offset:  420 Size:     4 [unused]
//   float gTotalTime;                  // Offset:  424 Size:     4 [unused]
//   float gDeltaTime;                  // Offset:  428 Size:     4 [unused]
//   float4 gAmbientLight;              // Offset:  432 Size:    16 [unused]
//   
//   struct Light
//   {
//       
//       float3 Strength;               // Offset:  448
//       float FalloffStart;            // Offset:  460
//       float3 Direction;              // Offset:  464
//       float FalloffEnd;              // Offset:  476
//       float3 Position;               // Offset:  480
//       float SpotPower;               // Offset:  492
//
//   } gLights[16];                     // Offset:  448 Size:   768 [unused]
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      ID      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- ------- -------------- ------
// cbPerObject                       cbuffer      NA          NA     CB0            cb0      1 
// cbPass                            cbuffer      NA          NA     CB1            cb1      1 
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// POSITION                 0   xyz         0     NONE   float   xyz 
// NORMAL                   0   xyz         1     NONE   float       
// TEXCOORD                 0   xy          2     NONE   float       
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_POSITION              0   xyzw        0      POS   float   xyzw
// POSITION                 0   xyz         1     NONE   float       
// NORMAL                   0   xyz         2     NONE   float       
// TEXCOORD                 0   xy          3     NONE   float       
// POSITION                 1   xyz         4     NONE   float   xyz 
//
vs_5_1
dcl_globalFlags refactoringAllowed | skipOptimization
dcl_constantbuffer CB0[0:0][4], immediateIndexed, space=0
dcl_constantbuffer CB1[1:1][25], immediateIndexed, space=0
dcl_input v0.xyz
dcl_output_siv o0.xyzw, position
dcl_output o4.xyz
dcl_temps 3
//
// Initial variable locations:
//   v0.x <- vin.PosL.x; v0.y <- vin.PosL.y; v0.z <- vin.PosL.z; 
//   v1.x <- vin.NormalL.x; v1.y <- vin.NormalL.y; v1.z <- vin.NormalL.z; 
//   v2.x <- vin.TexC.x; v2.y <- vin.TexC.y; 
//   o1.x <- <VS return value>.PosW.x; o1.y <- <VS return value>.PosW.y; o1.z <- <VS return value>.PosW.z; 
//   o2.x <- <VS return value>.NormalW.x; o2.y <- <VS return value>.NormalW.y; o2.z <- <VS return value>.NormalW.z; 
//   o3.x <- <VS return value>.TexC.x; o3.y <- <VS return value>.TexC.y; 
//   o4.x <- <VS return value>.PosL.x; o4.y <- <VS return value>.PosL.y; o4.z <- <VS return value>.PosL.z; 
//   o0.x <- <VS return value>.PosH.x; o0.y <- <VS return value>.PosH.y; o0.z <- <VS return value>.PosH.z; o0.w <- <VS return value>.PosH.w
//
#line 25 "C:\Users\86187\Desktop\2020_demo_assets\MyD3DApp\source\Picking\Shaders\Sky.hlsl"
mov r0.xyz, v0.xyzx  // r0.x <- vout.PosL.x; r0.y <- vout.PosL.y; r0.z <- vout.PosL.z

#line 28
mov r1.xyz, v0.xyzx
mov r1.w, l(1.000000)
dp4 r2.x, r1.xyzw, CB0[0][0].xyzw  // r2.x <- posW.x
dp4 r2.y, r1.xyzw, CB0[0][1].xyzw  // r2.y <- posW.y
dp4 r2.z, r1.xyzw, CB0[0][2].xyzw  // r2.z <- posW.z
dp4 r1.w, r1.xyzw, CB0[0][3].xyzw  // r1.w <- posW.w

#line 31
add r1.xyz, r2.xyzx, CB1[1][24].xyzx  // r1.x <- posW.x; r1.y <- posW.y; r1.z <- posW.z

#line 34
dp4 r2.x, r1.xyzw, CB1[1][16].xyzw  // r2.x <- vout.PosH.x
dp4 r2.y, r1.xyzw, CB1[1][17].xyzw  // r2.y <- vout.PosH.y
dp4 r2.w, r1.xyzw, CB1[1][19].xyzw
mov r2.zw, r2.wwww  // r2.z <- vout.PosH.z; r2.w <- vout.PosH.w

#line 36
mov o0.xyzw, r2.xyzw
mov o4.xyz, r0.xyzx
ret 
// Approximately 15 instruction slots used
