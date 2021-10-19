
#include <fbxsdk.h>
#include <vector>
#include "FbxLoader.h"




struct MyVertex
{
	float pos[3];
};

FbxManager* g_pFbxSdkManager = nullptr;

HRESULT LoadFBX(std::vector<Vertex>* pOutVertexVector, std::vector<std::int32_t>* pOutIndicesBuffer, DirectX::XMFLOAT3* pVMax, DirectX::XMFLOAT3* pVMin)
{
	if (g_pFbxSdkManager == nullptr)
	{
		g_pFbxSdkManager = FbxManager::Create();

		FbxIOSettings* pIOsettings = FbxIOSettings::Create(g_pFbxSdkManager, IOSROOT);
		g_pFbxSdkManager->SetIOSettings(pIOsettings);
	}

	FbxImporter* pImporter = FbxImporter::Create(g_pFbxSdkManager, "");
	FbxScene* pFbxScene = FbxScene::Create(g_pFbxSdkManager, "");

	bool bSuccess = pImporter->Initialize("C:\\Users\\86187\\Desktop\\2020_demo_assets\\MyD3DApp\\source\\Picking\\Models\\teapot.FBX", -1, g_pFbxSdkManager->GetIOSettings());
	if (!bSuccess) return E_FAIL;

	bSuccess = pImporter->Import(pFbxScene);
	if (!bSuccess) return E_FAIL;

	pImporter->Destroy();

	FbxNode* pFbxRootNode = pFbxScene->GetRootNode();

	if (pFbxRootNode)
	{
		for (int i = 0; i < pFbxRootNode->GetChildCount(); i++)
		{
			FbxNode* pFbxChildNode = pFbxRootNode->GetChild(i);

			if (pFbxChildNode->GetNodeAttribute() == NULL)
				continue;

			FbxNodeAttribute::EType AttributeType = pFbxChildNode->GetNodeAttribute()->GetAttributeType();

			if (AttributeType != FbxNodeAttribute::eMesh)
				continue;

			FbxMesh* pMesh = (FbxMesh*)pFbxChildNode->GetNodeAttribute();

			FbxVector4* pVertices = pMesh->GetControlPoints();
			FbxVector4 pNormal;
			FbxVector2 pUV;
			FbxStringList uvSetName;
			bool pUnmapped = false;
			pMesh->GetUVSetNames(uvSetName);
			FbxDouble3 vMax = pMesh->BBoxMax.Get();
			FbxDouble3 vMin = pMesh->BBoxMin.Get();

			pVMax->x = vMax.mData[0];
			pVMax->y = vMax.mData[1];
			pVMax->z = vMax.mData[2];
			pVMin->x = vMin.mData[0];
			pVMin->y = vMin.mData[1];
			pVMin->z = vMin.mData[2];

			std::vector<std::int32_t> indicesBuffer(3 * pMesh->GetPolygonCount());

			for (int j = 0; j < pMesh->GetPolygonCount(); j++)
			{
				int iNumVertices = pMesh->GetPolygonSize(j);
				assert(iNumVertices == 3);

				indicesBuffer[j * 3 + 0] = j * 3 + 0;
				indicesBuffer[j * 3 + 1] = j * 3 + 1;
				indicesBuffer[j * 3 + 2] = j * 3 + 2;

				for (int k = 0; k < iNumVertices; k++) {

					int iControlPointIndex = pMesh->GetPolygonVertex(j, k);
					pMesh->GetPolygonVertexNormal(j, k, pNormal);
					pMesh->GetPolygonVertexUV(j, k, uvSetName.GetStringAt(0), pUV, pUnmapped);

					Vertex vertex;

					vertex.Pos.x = (float)pVertices[iControlPointIndex].mData[0];
					vertex.Pos.y = (float)pVertices[iControlPointIndex].mData[1];
					vertex.Pos.z = (float)pVertices[iControlPointIndex].mData[2];

					vertex.Normal.x = (float)pNormal.mData[0];
					vertex.Normal.y = (float)pNormal.mData[1];
					vertex.Normal.z = (float)pNormal.mData[2];

					vertex.TexC.x = (float)pUV.mData[0];
					vertex.TexC.y = (float)pUV.mData[1];





					pOutVertexVector->push_back(vertex);
				}
			}
			std::copy(indicesBuffer.begin(), indicesBuffer.end(), std::back_inserter(*pOutIndicesBuffer));
		}

	}
	return S_OK;
}