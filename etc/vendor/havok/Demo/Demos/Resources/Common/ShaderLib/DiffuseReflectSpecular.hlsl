/* 
 * 
 * Confidential Information of Telekinesys Research Limited (t/a Havok). Not for disclosure or distribution without Havok's
 * prior written consent. This software contains code, techniques and know-how which is confidential and proprietary to Havok.
 * Level 2 and Level 3 source code contains trade secrets of Havok. Havok Software (C) Copyright 1999-2009 Telekinesys Research Limited t/a Havok. All Rights Reserved. Use of this software is subject to the terms of an end user license agreement.
 * 
 */

//
// One or Two diffuse maps, along with a normal and specular map, with and without shadows. The most common demo shaders 
// with 'proper' assets. These will currently also allow loading of a gloss map, but will ignore it
//
//:STYLE VertOneLightReflectT1 PixT1Reflect LD1 T1 DIFFUSE0 REFLECTION NORMAL0 SPECULAR0
//:STYLE VertOneLightReflectShadowProjT1 PixShadowSceneT1Reflect LD1 T1 SHADOWMAP DIFFUSE0 REFLECTION NORMAL0 SPECULAR0
//:STYLE VertOneLightReflectT1 PixT1ReflectMask LD1 T1 DIFFUSE0 REFLECTION REFLECTION NORMAL0 SPECULAR0
//:STYLE VertOneLightReflectShadowProjT1 PixShadowSceneT1ReflectMask LD1 T1 SHADOWMAP DIFFUSE0 REFLECTION REFLECTION NORMAL0 SPECULAR0
//:STYLE VertOneLightReflectT2 PixT2ReflectMask LD1 T2 DIFFUSE0 REFLECTION REFLECTION NORMAL0 SPECULAR0
//:STYLE VertOneLightReflectShadowProjT2 PixShadowSceneT2ReflectMask LD1 T2 SHADOWMAP DIFFUSE0 REFLECTION REFLECTION NORMAL0 SPECULAR0

#include "CommonHeader.hlslh"

// Matrices
float4x4 g_mWorldInv;
float4x4 g_mWorldView		: WorldView;
float4x4 g_mProj			: Proj;
float4x4 g_mViewInv			: ViewInverse;
 
// Textures, set assignment so that the behaviour is the same no mater what shader is using it 
sampler g_sSamplerOne  : register(s1);		// T0 if shadows, otherwise T1
sampler g_sSamplerTwo  : register(s2);		// T1 if shadows, , otherwise T1
sampler g_sSamplerThree : register(s3);     // T1 if shadows, otherwise T3
sampler g_sSamplerFour  : register(s4);		// T3 if shadows
sampler g_sSamplerFive  : register(s5);		// T4 if shadows



void computeTangentSpace( float3 tangent, float3 binormal, float3 normal, out float3x3 objToTangentSpace, out float3 tangentToWorldSpaceRow0, out float3 tangentToWorldSpaceRow1, out float3 tangentToWorldSpaceRow2 )
{
	float bumpHeight = 1.0f;
	
	objToTangentSpace[0] = tangent * bumpHeight;
	objToTangentSpace[1] = binormal * bumpHeight;
	objToTangentSpace[2] = normal;
 
 	float3x3 TangentToObjSpace;
	
	TangentToObjSpace[0] = float3(objToTangentSpace[0].x, objToTangentSpace[1].x, objToTangentSpace[2].x);
	TangentToObjSpace[1] = float3(objToTangentSpace[0].y, objToTangentSpace[1].y, objToTangentSpace[2].y);
	TangentToObjSpace[2] = float3(objToTangentSpace[0].z, objToTangentSpace[1].z, objToTangentSpace[2].z);
	
	tangentToWorldSpaceRow0.x = dot(g_mWorld[0].xyz, TangentToObjSpace[0]);
	tangentToWorldSpaceRow0.y = dot(g_mWorld[1].xyz, TangentToObjSpace[0]);
	tangentToWorldSpaceRow0.z = dot(g_mWorld[2].xyz, TangentToObjSpace[0]);
	tangentToWorldSpaceRow1.x = dot(g_mWorld[0].xyz, TangentToObjSpace[1]);
	tangentToWorldSpaceRow1.y = dot(g_mWorld[1].xyz, TangentToObjSpace[1]);
	tangentToWorldSpaceRow1.z = dot(g_mWorld[2].xyz, TangentToObjSpace[1]);
	tangentToWorldSpaceRow2.x = dot(g_mWorld[0].xyz, TangentToObjSpace[2]);
	tangentToWorldSpaceRow2.y = dot(g_mWorld[1].xyz, TangentToObjSpace[2]);
	tangentToWorldSpaceRow2.z = dot(g_mWorld[2].xyz, TangentToObjSpace[2]);  
	
}


vertexOutputT1BR VertOneLightReflectT1( vertexInputT1B In )
{
	vertexOutputT1BR Out;

	Out.position = mul(In.position, g_mWorldViewProj);
	Out.texCoord0 = In.texCoord0;
	
	float4 vertexPos = mul(In.position, g_mWorld); // world space position

	float3x3 objToTangentSpace;
	computeTangentSpace( In.tangent, In.binormal, In.normal, objToTangentSpace, Out.TangToWorld0.xyz, Out.TangToWorld1.xyz, Out.TangToWorld2.xyz);
	
	// light vector
	float3 lightVec = mul( g_vLightDir, (float3x3)g_mWorldInv );  // transform back to object space
	Out.L = mul( objToTangentSpace, lightVec ); // transform from object to tangent space
	
	// eye vector
	float3 eyeVec = g_mViewInv[3].xyz - vertexPos.xyz; // world space eye vector
	eyeVec = normalize(eyeVec);
	Out.TangToWorld0.w = eyeVec.x;
	Out.TangToWorld1.w = eyeVec.y;
	Out.TangToWorld2.w = eyeVec.z;
	
	eyeVec = mul(eyeVec, (float3x3) g_mWorldInv );  // transform back to object space
	float3 H = normalize(lightVec + eyeVec);
	Out.H = mul(objToTangentSpace, H);	// transform to tangent space

	
	return Out;
}


vertexOutputShadowT1BR VertOneLightReflectShadowProjT1( vertexInputT1B In) 
{
    vertexOutputShadowT1BR Output;
    
    float4 viewPos =  mul( float4(In.position.xyz, 1.0), g_mWorldView);
    
    Output.position = mul( viewPos, g_mProj);
    Output.texCoord0 = In.texCoord0;
		 
		// project pos into light space
    Output.posLight = mul( viewPos, g_mViewToLightProj );
    
    #ifdef HKG_SHADOWS_VSM
            Output.posWorld =  mul( float4(In.position.xyz, 1.0), g_mWorld);
   #endif
    
	// compute the 3x3 tranform from object space to tangent space
	float3x3 objToTangentSpace;
	computeTangentSpace( In.tangent, In.binormal, In.normal, objToTangentSpace, Output.TangToWorld0.xyz, Output.TangToWorld1.xyz, Output.TangToWorld2.xyz);
	
	float4 vertexPos = mul(In.position, g_mWorld); // world space position

	// light vector
	float3 lightVec = mul( g_vLightDir, (float3x3)g_mWorldInv );  // transform back to object space
	Output.L = mul( objToTangentSpace, lightVec ); // transform from object to tangent space
	
	// eye vector
	float3 eyeVec = g_mViewInv[3].xyz - vertexPos.xyz; // world space eye vector
	eyeVec = normalize(eyeVec);
	Output.TangToWorld0.w = eyeVec.x;
	Output.TangToWorld1.w = eyeVec.y;
	Output.TangToWorld2.w = eyeVec.z;
	
	eyeVec = mul(eyeVec, (float3x3) g_mWorldInv );  // transform back to object space
	float3 H = normalize(lightVec + eyeVec);
	Output.H = mul(objToTangentSpace, H);	// transform to tangent space
	
	return Output;
}


vertexOutputT2BR VertOneLightReflectT2( vertexInputT2B In )
{
	vertexOutputT2BR Out;

	Out.texCoord0 = In.texCoord0;
	Out.texCoord1 = In.texCoord1;
	Out.position = mul(In.position, g_mWorldViewProj);

	float3x3 objToTangentSpace;
	computeTangentSpace( In.tangent, In.binormal, In.normal, objToTangentSpace, Out.TangToWorld0.xyz, Out.TangToWorld1.xyz, Out.TangToWorld2.xyz);
	
	float4 vertexPos = mul(In.position, g_mWorld); // world space position

	// light vector
	float3 lightVec = mul( g_vLightDir, (float3x3)g_mWorldInv );  // transform back to object space
	Out.L = mul( objToTangentSpace, lightVec ); // transform from object to tangent space
	
	// eye vector
	float3 eyeVec = g_mViewInv[3].xyz - vertexPos.xyz; // world space eye vector
	eyeVec = normalize(eyeVec);
	Out.TangToWorld0.w = eyeVec.x;
	Out.TangToWorld1.w = eyeVec.y;
	Out.TangToWorld2.w = eyeVec.z;
	
	eyeVec = mul(eyeVec, (float3x3) g_mWorldInv );  // transform back to object space
	float3 H = normalize(lightVec + eyeVec);
	Out.H = mul(objToTangentSpace, H);	// transform to tangent space

	return Out;
}


vertexOutputShadowT2BR VertOneLightReflectShadowProjT2( vertexInputT2B In) 
{
    vertexOutputShadowT2BR Output;
    
    float4 viewPos =  mul( float4(In.position.xyz, 1.0), g_mWorldView);
    
    Output.position = mul( viewPos, g_mProj);
    
    Output.texCoord01 = float4( In.texCoord0.xy, In.texCoord1.xy);
	 
		// project pos into light space
    Output.posLight = mul( viewPos, g_mViewToLightProj );
    
    #ifdef HKG_SHADOWS_VSM
            Output.posWorld =  mul( float4(In.position.xyz, 1.0), g_mWorld);
   #endif
    
	// compute the 3x3 tranform from object space to tangent space
	float3x3 objToTangentSpace;
	computeTangentSpace( In.tangent, In.binormal, In.normal, objToTangentSpace, Output.TangToWorld0.xyz, Output.TangToWorld1.xyz, Output.TangToWorld2.xyz);
	
    float4 vertexPos = mul(In.position, g_mWorld); // world space position

	// light vector
	float3 lightVec = mul( g_vLightDir, (float3x3)g_mWorldInv );  // transform back to object space
	Output.L = mul( objToTangentSpace, lightVec ); // transform from object to tangent space
	
	// eye vector
	float3 eyeVec = g_mViewInv[3].xyz - vertexPos.xyz; // world space eye vector
	eyeVec = normalize(eyeVec);
	Output.TangToWorld0.w = eyeVec.x;
	Output.TangToWorld1.w = eyeVec.y;
	Output.TangToWorld2.w = eyeVec.z;
	
	eyeVec = mul(eyeVec, (float3x3) g_mWorldInv );  // transform back to object space
	float3 H = normalize(lightVec + eyeVec);
	Output.H = mul(objToTangentSpace, H);	// transform to tangent space

	return Output;
}


// Pixel Shaders

pixelOutput PixT1Reflect( vertexOutputT1BR In )
{
	float4 ColorMap = float4(1,1,1,1);
	float3 SpecMap = g_cSpecularColor.rgb;
	float3 N = float3(0,0,1); 
	
#if ENABLE_DIFFUSE_MAP0
    ColorMap = tex2D(g_sSamplerZero, In.texCoord0);
#endif
	
#if ENABLE_NORMAL_MAP
	#if ENABLE_LIGHTING
		N = tex2D(g_sSamplerTwo, In.texCoord0).xyz*2.0 - 1.0;
		N = normalize(N);
	#else
		ColorMap = tex2D(g_sSamplerTwo, In.texCoord0);
	#endif
#endif

	float3 worldEyeVec = float3( -In.TangToWorld0.w, -In.TangToWorld1.w, -In.TangToWorld2.w ); 
	float3 worldNormal = float3( dot(In.TangToWorld0.xyz, N), dot(In.TangToWorld1.xyz, N), dot(In.TangToWorld2.xyz, N) );
	float3 reflVect = reflect( worldEyeVec, worldNormal ); 
	float4 ReflectionMap = texCUBE(g_sSamplerOne, reflVect); 
	ColorMap.rgb = ColorMap.rgb * ReflectionMap.rgb;  


#if ENABLE_SPEC_MAP
	SpecMap *= tex2D(g_sSamplerThree, In.texCoord0).rgb;
#endif

	ColorMap *= g_cDiffuseColor;

	In.L = normalize(In.L);
	In.H = normalize(In.H);
	float NdotL = dot(N, In.L);
	float NdotH = dot(N, In.H);
#if ENABLE_LIGHTING
    float specPower = g_cSpecularPower;
    float4 light = Phong( NdotL, NdotH, specPower ) * float4(g_cLightColor.rgb, 1);
#else
	float4 light = float4(1,1,1,1);
#endif
	
	pixelOutput Output;
	Output.color.rgb = (1-light)*g_cAmbientColor.rgb*ColorMap.rgb + light*ColorMap.rgb + light.www*SpecMap;
	Output.color.a = ColorMap.a; // modulate alpha as is, light doesn't affect it.
	return Output; 
}


pixelOutput PixT1ReflectMask( vertexOutputT1BR In )
{
	float4 ColorMap = float4(1,1,1,1);
	float3 SpecMap = g_cSpecularColor.rgb;
	float3 N = float3(0,0,1); 
	
#if ENABLE_DIFFUSE_MAP0
    ColorMap = tex2D(g_sSamplerZero, In.texCoord0);
#endif

#if ENABLE_NORMAL_MAP
	#if ENABLE_LIGHTING
		N = tex2D(g_sSamplerThree, In.texCoord0).xyz*2.0 - 1.0;
		N = normalize(N);
	#else
		ColorMap = tex2D(g_sSamplerThree, In.texCoord0);
	#endif
#endif

	float3 worldEyeVec = float3( -In.TangToWorld0.w, -In.TangToWorld1.w, -In.TangToWorld2.w ); 
	float3 worldNormal = float3( dot(In.TangToWorld0.xyz, N), dot(In.TangToWorld1.xyz, N), dot(In.TangToWorld2.xyz, N) );
	float3 reflVect = reflect( worldEyeVec, worldNormal ); 
	float4 ReflectionMap = texCUBE(g_sSamplerTwo, reflVect); 
	float4 ReflectionMask = tex2D(g_sSamplerOne, In.texCoord0); 
	ColorMap.rgb = (1-ReflectionMask.rgb)*ColorMap.rgb + ReflectionMask.rgb*ReflectionMap.rgb*ColorMap.rgb;  
		


#if ENABLE_SPEC_MAP
	SpecMap *= tex2D(g_sSamplerFour, In.texCoord0).rgb;
#endif

	ColorMap *= g_cDiffuseColor;
	
	In.L = normalize(In.L);
	In.H = normalize(In.H);
	float NdotL = dot(N, In.L);
	float NdotH = dot(N, In.H);
	
#if ENABLE_LIGHTING
    float specPower = g_cSpecularPower;
    float4 light = Phong( NdotL, NdotH, specPower ) * float4(g_cLightColor.rgb, 1);
#else
	float4 light = float4(1,1,1,1);
#endif
	
	pixelOutput Output;
	Output.color.rgb = (1-light)*g_cAmbientColor.rgb*ColorMap.rgb + light*ColorMap.rgb + light.www*SpecMap;
	Output.color.a = ColorMap.a; // modulate alpha as is, light doesn't affect it.
	return Output; 
}

pixelOutput PixT2ReflectMask( vertexOutputT2BR In )
{
	float4 ColorMap = float4(1,1,1,1);
	float3 SpecMap = g_cSpecularColor.rgb;
	float3 N = float3(0,0,1); 
	
#if ENABLE_DIFFUSE_MAP0
    ColorMap = tex2D(g_sSamplerZero, In.texCoord0);
#endif
	
#if ENABLE_NORMAL_MAP
	#if ENABLE_LIGHTING
		N = tex2D(g_sSamplerThree, In.texCoord0).xyz*2.0 - 1.0;
		N = normalize(N);
	#else
		ColorMap = tex2D(g_sSamplerThree, In.texCoord0);
	#endif
#endif

	
	float3 worldEyeVec = float3( -In.TangToWorld0.w, -In.TangToWorld1.w, -In.TangToWorld2.w ); 
	float3 worldNormal = float3( dot(In.TangToWorld0.xyz, N), dot(In.TangToWorld1.xyz, N), dot(In.TangToWorld2.xyz, N) );
	float3 reflVect = reflect( worldEyeVec, worldNormal ); 
	float4 ReflectionMap = texCUBE(g_sSamplerTwo, reflVect); 
	float4 ReflectionMask = tex2D(g_sSamplerOne, In.texCoord1); 
	ColorMap.rgb = (1-ReflectionMask.rgb)*ColorMap.rgb + ReflectionMask.rgb*ReflectionMap.rgb*ColorMap.rgb;  


#if ENABLE_SPEC_MAP
	SpecMap *= tex2D(g_sSamplerFour, In.texCoord0).rgb;
#endif

	ColorMap *= g_cDiffuseColor;

	In.L = normalize(In.L);
	In.H = normalize(In.H);
	float NdotL = dot(N, In.L);
	float NdotH = dot(N, In.H);
#if ENABLE_LIGHTING
    float specPower = g_cSpecularPower;
    float4 light = Phong( NdotL, NdotH, specPower ) * float4(g_cLightColor.rgb, 1);
#else
	float4 light = float4(1,1,1,1);
#endif
	
	pixelOutput Output;
	Output.color.rgb = (1-light)*g_cAmbientColor.rgb*ColorMap.rgb + light*ColorMap.rgb + light.www*SpecMap;
	Output.color.a = ColorMap.a; // modulate alpha as is, light doesn't affect it.
	return Output; 
}



pixelOutput PixShadowSceneT1Reflect( vertexOutputShadowT1BR In )
{
    pixelOutput Output;
    
    #ifdef HKG_SHADOWS_VSM
		float lightAmount = getLightAmountVSM( In.posLight, In.posWorld );
  	#else
		float lightAmount = getLightAmountSM( In.posLight ); 
	#endif
		
	float4 ColorMap = float4(1,1,1,1);
	float3 SpecMap = g_cSpecularColor.rgb;
	float3 N = float3(0,0,1); 
	
#if ENABLE_DIFFUSE_MAP0
    ColorMap = tex2D(g_sSamplerOne, In.texCoord0);
#endif
		
#if ENABLE_NORMAL_MAP
	#if ENABLE_LIGHTING
		N = tex2D(g_sSamplerThree, In.texCoord0).xyz*2.0 - 1.0;
		N = normalize(N);
	#else
		ColorMap = tex2D(g_sSamplerThree, In.texCoord0);
	#endif
#endif

	float3 worldEyeVec = float3( -In.TangToWorld0.w, -In.TangToWorld1.w, -In.TangToWorld2.w ); 
	float3 worldNormal = float3( dot(In.TangToWorld0.xyz, N), dot(In.TangToWorld1.xyz, N), dot(In.TangToWorld2.xyz, N) );
	float3 reflVect = reflect( worldEyeVec, worldNormal ); 
	float4 ReflectionMap = texCUBE(g_sSamplerTwo, reflVect); 
	ColorMap.rgb = ColorMap.rgb * ReflectionMap.rgb;  


#if ENABLE_SPEC_MAP
	SpecMap *= tex2D(g_sSamplerFour, In.texCoord0).rgb;
#endif

	ColorMap *= g_cDiffuseColor;

	// interp will not preserve length
	In.L = normalize(In.L);
	In.H = normalize(In.H);
	float NdotL = dot(N, In.L);
	float NdotH = dot(N, In.H);
	
#if ENABLE_LIGHTING
	float specPower = g_cSpecularPower;
	float4 light = lightAmount * Phong(NdotL, NdotH, specPower) * float4(g_cLightColor.rgb, 1);
#else
	float4 light = float4(1,1,1,1);
#endif
	
	Output.color.rgb = (1-light)*g_cAmbientColor*ColorMap.rgb + light.rgb*ColorMap.rgb + light.www*SpecMap;
	Output.color.a = ColorMap.a; // modulate alpha as is, shadow doesn't affect it.
	
    return Output;
}

pixelOutput PixShadowSceneT1ReflectMask( vertexOutputShadowT1BR In )
{
    pixelOutput Output;
    
    #ifdef HKG_SHADOWS_VSM
		float lightAmount = getLightAmountVSM( In.posLight, In.posWorld );
  	#else
		float lightAmount = getLightAmountSM( In.posLight ); 
	#endif
		
	float4 ColorMap = float4(1,1,1,1);
	float3 SpecMap = g_cSpecularColor.rgb;
	float3 N = float3(0,0,1); 
	
#if ENABLE_DIFFUSE_MAP0
    ColorMap = tex2D(g_sSamplerOne, In.texCoord0);
#endif
	
#if ENABLE_NORMAL_MAP
	#if ENABLE_LIGHTING
		N = tex2D(g_sSamplerFour, In.texCoord0).xyz*2.0 - 1.0;
		N = normalize(N);
	#else
		ColorMap = tex2D(g_sSamplerFour, In.texCoord0);
	#endif
#endif	
		
	float3 worldEyeVec = float3( -In.TangToWorld0.w, -In.TangToWorld1.w, -In.TangToWorld2.w ); 
	float3 worldNormal = float3( dot(In.TangToWorld0.xyz, N), dot(In.TangToWorld1.xyz, N), dot(In.TangToWorld2.xyz, N) );
	float3 reflVect = reflect( worldEyeVec, worldNormal ); 
	float4 ReflectionMap = texCUBE(g_sSamplerThree, reflVect); 
	float4 ReflectionMask = tex2D(g_sSamplerTwo, In.texCoord0);
	ColorMap.rgb = ( (float3(1,1,1)-ReflectionMask.rgb) + ReflectionMask.rgb*ReflectionMap.rgb )*ColorMap.rgb;  

#if ENABLE_SPEC_MAP
	SpecMap *= tex2D(g_sSamplerFive, In.texCoord0).rgb;
#endif

	ColorMap *= g_cDiffuseColor;

	// interp will not preserve length
	In.L = normalize(In.L);
	In.H = normalize(In.H);
	float NdotL = dot(N, In.L);
	float NdotH = dot(N, In.H);
	
#if ENABLE_LIGHTING
	float specPower = g_cSpecularPower;
	float4 light = lightAmount * Phong(NdotL, NdotH, specPower) * float4(g_cLightColor.rgb, 1);
#else
	float4 light = float4(1,1,1,1);
#endif
	
	Output.color.rgb = (1-light)*g_cAmbientColor*ColorMap.rgb + light.rgb*ColorMap.rgb + light.www*SpecMap;
	Output.color.a = ColorMap.a; // modulate alpha as is, shadow doesn't affect it.
	
    return Output;
}


pixelOutput PixShadowSceneT2ReflectMask( vertexOutputShadowT2BR In )
{
    pixelOutput Output;
    
    #ifdef HKG_SHADOWS_VSM
		float lightAmount = getLightAmountVSM( In.posLight, In.posWorld );
  	#else
		float lightAmount = getLightAmountSM( In.posLight ); 
	#endif
		
	float4 ColorMap = float4(1,1,1,1);
	float3 SpecMap = g_cSpecularColor.rgb;
	float3 N = float3(0,0,1); 
	
	float2 tc0 = In.texCoord01.xy;
	float2 tc1 = In.texCoord01.zw;
	
#if ENABLE_DIFFUSE_MAP0
    ColorMap = tex2D(g_sSamplerOne, tc0);
#endif
		
#if ENABLE_NORMAL_MAP
	#if ENABLE_LIGHTING
		N = tex2D(g_sSamplerFour, tc0).xyz*2.0 - 1.0;
		N = normalize(N);
	#else
		ColorMap = tex2D(g_sSamplerFour, tc0);
	#endif
#endif

	float3 worldEyeVec = float3( -In.TangToWorld0.w, -In.TangToWorld1.w, -In.TangToWorld2.w ); 
	float3 worldNormal = float3( dot(In.TangToWorld0.xyz, N), dot(In.TangToWorld1.xyz, N), dot(In.TangToWorld2.xyz, N) );
	float3 reflVect = reflect( worldEyeVec, worldNormal ); 
	float4 ReflectionMap = texCUBE(g_sSamplerThree, reflVect); 
	float4 ReflectionMask = tex2D(g_sSamplerTwo, tc1);
	ColorMap.rgb = (1-ReflectionMask.rgb)*ColorMap.rgb + ReflectionMask.rgb*ReflectionMap.rgb*ColorMap.rgb;  
	


#if ENABLE_SPEC_MAP
	SpecMap *= tex2D(g_sSamplerFive, tc0).rgb;
#endif

	ColorMap *= g_cDiffuseColor;

	In.L = normalize(In.L);
	In.H = normalize(In.H);
	float NdotL = dot(N, In.L);
	float NdotH = dot(N, In.H);
	
#if ENABLE_LIGHTING
	float specPower = g_cSpecularPower;
	float4 light = lightAmount * Phong(NdotL, NdotH, specPower) * float4(g_cLightColor.rgb, 1);
#else
	float4 light = float4(1,1,1,1);
#endif
	
	Output.color.rgb = (1-light)*g_cAmbientColor*ColorMap.rgb + light.rgb*ColorMap.rgb + light.www*SpecMap;
	Output.color.a = ColorMap.a; // modulate alpha as is, shadow doesn't affect it.
	
    return Output;
}


/*
* Havok SDK - NO SOURCE PC DOWNLOAD, BUILD(#20090216)
* 
* Confidential Information of Havok.  (C) Copyright 1999-2009
* Telekinesys Research Limited t/a Havok. All Rights Reserved. The Havok
* Logo, and the Havok buzzsaw logo are trademarks of Havok.  Title, ownership
* rights, and intellectual property rights in the Havok software remain in
* Havok and/or its suppliers.
* 
* Use of this software for evaluation purposes is subject to and indicates
* acceptance of the End User licence Agreement for this product. A copy of
* the license is included with this software and is also available at www.havok.com/tryhavok.
* 
*/
