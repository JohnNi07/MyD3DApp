//***************************************************************************************
// CubeRenderTarget.h by Frank Luna (C) 2015 All Rights Reserved.
//***************************************************************************************

#pragma once

#include "../../Common/d3dUtil.h"

enum class CubeMapFace : int
{
	PositiveX = 0,
	NegativeX = 1,
	PositiveY = 2,
	NegativeY = 3,
	PositiveZ = 4,
	NegativeZ = 5
};

struct prefilterData
{
	DirectX::XMFLOAT3 c00;
	DirectX::XMFLOAT3 c11;
	DirectX::XMFLOAT3 c10;
	DirectX::XMFLOAT3 c1minus1;
	DirectX::XMFLOAT3 c21;
	DirectX::XMFLOAT3 c2minus1;
	DirectX::XMFLOAT3 c2minus2;
	DirectX::XMFLOAT3 c20;
	DirectX::XMFLOAT3 c22;
};


class CubeRenderTarget
{
public:
	CubeRenderTarget(ID3D12Device* device,
		UINT width, UINT height,
		DXGI_FORMAT format);
		
	CubeRenderTarget(const CubeRenderTarget& rhs)=delete;
	CubeRenderTarget& operator=(const CubeRenderTarget& rhs)=delete;
	~CubeRenderTarget()=default;

	ID3D12Resource* Resource();
	CD3DX12_GPU_DESCRIPTOR_HANDLE Srv();
	CD3DX12_CPU_DESCRIPTOR_HANDLE Rtv(int faceIndex);

	D3D12_VIEWPORT Viewport()const;
	D3D12_RECT ScissorRect()const;

	void BuildDescriptors(
		CD3DX12_CPU_DESCRIPTOR_HANDLE hCpuSrv,
		CD3DX12_GPU_DESCRIPTOR_HANDLE hGpuSrv,
		CD3DX12_CPU_DESCRIPTOR_HANDLE hCpuRtv[6]);

	void OnResize(UINT newWidth, UINT newHeight);
	void Execute(ID3D12GraphicsCommandList* cmdList,
		ID3D12RootSignature* rootSig,
		ID3D12PipelineState* pso,
		CD3DX12_GPU_DESCRIPTOR_HANDLE input);
	void BuildSHCoe(ID3D12GraphicsCommandList* cmdList);


	Microsoft::WRL::ComPtr<ID3D12Resource> mOutputBuffer = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> mReadBackBuffer= nullptr;


private:
	void BuildDescriptors();
	void BuildResource();

private:

	ID3D12Device* md3dDevice = nullptr;

	D3D12_VIEWPORT mViewport;
	D3D12_RECT mScissorRect;

	UINT mWidth = 0;
	UINT mHeight = 0;
	DXGI_FORMAT mFormat = DXGI_FORMAT_R8G8B8A8_UNORM;

	CD3DX12_CPU_DESCRIPTOR_HANDLE mhCpuSrv;
	CD3DX12_GPU_DESCRIPTOR_HANDLE mhGpuSrv;
	CD3DX12_CPU_DESCRIPTOR_HANDLE mhCpuRtv[6];

	
	Microsoft::WRL::ComPtr<ID3D12Resource> mCubeMap = nullptr;


	

	std::vector<prefilterData> SHData;
};

 