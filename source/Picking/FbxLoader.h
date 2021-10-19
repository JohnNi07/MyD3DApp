#pragma once

#include "../../Common/d3dUtil.h"
#include "FrameResource.h"
HRESULT LoadFBX(std::vector<Vertex>* pOutVertexVector, std::vector<std::int32_t>* pOutIndicesBuffer, DirectX::XMFLOAT3* pVmax, DirectX::XMFLOAT3* pVMin);