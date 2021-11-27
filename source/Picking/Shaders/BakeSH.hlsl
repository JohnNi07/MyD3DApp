//s meaning 11 10 1-1 21 2-1 2-2
#define SHc00 0.282095
#define SHc1s 0.488603
#define SHc2s 1.092548
#define SHc20 0.315392
#define SHc22 0.546274

#define TexSize 512.0
struct prefilterData
{
float3 c00;
float3 c11;
float3 c10;
float3 c1minus1;
float3 c21;
float3 c2minus1;
float3 c2minus2;
float3 c20;
float3 c22;
};

Texture2DArray gEnvMapArray : register(t0);
RWStructuredBuffer<prefilterData> gOutput :register(u0);

groupshared float3 gCache[256];

uint3 threadGroupSize = int3 (16,16,1);
uint3 texArraySize = int3(512,512,6);





float3 getTexDirInWorld(int index ,float x,float y)
{

  float3 texDirOneX = float3(0.0,-y,-x);
  float3 texDirMinusX = float3(0.0,-y,x);
  float3 texDirOneY = float3(-y,0.0,x);
  float3 texDirMinusY = float3(-y,0.0,-x);
  float3 texDirOneZ = float3(x,-y,0.0);
  float3 texDirMinusZ = float3(x,-y,0.0);
  
  float3 texDirInWorld[6]= {texDirOneX,texDirMinusX,texDirOneY,texDirMinusY,texDirOneZ,texDirMinusZ};
  
  return texDirInWorld[index];
}
// x and y meaning -1~1 coord vector , and return the vector bounding sr
float AreaElement(float x ,float y){
  return atan2(x*y,sqrt(x*x+y*y+1.0f));
}
float texelCoordSolidAngle(float x ,float y){
  float u = (2.0f * (x+0.5f)/TexSize) - 1.0f;
   float v = (2.0f * (y+0.5f)/TexSize) - 1.0f;
   
   float invRes = 1.0f / TexSize ;
   //shrink
   float x0 = u - invRes;
   float y0 = v - invRes;
   //expand
   float x1 = u + invRes;
   float y1 = v + invRes ;
   
   float solidAngle = AreaElement (x0,y0) - AreaElement (x0,y1) - AreaElement (x1,y0) +AreaElement (x1,y1);
   return solidAngle;

}





[numthreads(16,16,1)]
void BakeSHCS(int3 dispatchThreadID : SV_DispatchThreadID,int3 GTID: SV_GroupThreadID,int GroupIndex : SV_GroupIndex, int3 groupID : SV_GroupID)
{
float3 oneX = float3(0.5,0.5,0.5);
float3 minusX = float3(-0.5,0.5,-0.5);
float3 oneY = float3(0.5,0.5,-0.5);
float3 minusY = float3(0.5,-0.5,0.5);
float3 oneZ = float3(-0.5,0.5,0.5);
float3 minusZ  = float3(0.5,0.5,-0.5);
float3 cubeMapVector [6] = {oneX,minusX,oneY,minusY,oneZ,minusZ};
int3 groupSize = texArraySize/threadGroupSize;

float3 texelValue = gEnvMapArray[dispatchThreadID.xyz]* texelCoordSolidAngle(dispatchThreadID.x,dispatchThreadID.y);

float3 TexelDir = normalize(getTexDirInWorld(dispatchThreadID.z,float (dispatchThreadID.x)/TexSize,float(dispatchThreadID.y)/TexSize)+cubeMapVector[dispatchThreadID.z]);

int gLinearIndex = GroupIndex + 256*groupID.y*groupSize.x + 256* groupID.x + groupSize.x * groupSize.y * groupID.z;

gOutput[dispatchThreadID.x+512*dispatchThreadID.y+dispatchThreadID.z*512*512].c00 = SHc00 * texelValue;
gOutput[dispatchThreadID.x+512*dispatchThreadID.y+dispatchThreadID.z*512*512].c11 = SHc1s * TexelDir.x * texelValue;
gOutput[dispatchThreadID.x+512*dispatchThreadID.y+dispatchThreadID.z*512*512].c10 = SHc1s*TexelDir.z*texelValue;
gOutput[dispatchThreadID.x+512*dispatchThreadID.y+dispatchThreadID.z*512*512].c1minus1 = SHc1s*TexelDir.y*texelValue;
gOutput[dispatchThreadID.x+512*dispatchThreadID.y+dispatchThreadID.z*512*512].c21 = SHc2s*TexelDir.x*TexelDir.z*texelValue;
gOutput[dispatchThreadID.x+512*dispatchThreadID.y+dispatchThreadID.z*512*512].c2minus1 = SHc2s*TexelDir.y*TexelDir.z*texelValue;
gOutput[dispatchThreadID.x+512*dispatchThreadID.y+dispatchThreadID.z*512*512].c2minus2 = SHc2s*TexelDir.x*TexelDir.y*texelValue;
gOutput[dispatchThreadID.x+512*dispatchThreadID.y+dispatchThreadID.z*512*512].c20 = SHc20*(3*TexelDir.z*TexelDir.z-1)*texelValue;
gOutput[dispatchThreadID.x+512*dispatchThreadID.y+dispatchThreadID.z*512*512].c22 = SHc22*(TexelDir.x*TexelDir.x-TexelDir.y*TexelDir.y)*texelValue;
}