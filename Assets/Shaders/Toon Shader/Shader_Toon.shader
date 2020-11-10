// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ToonShader"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_NormalMap("Normal Map", 2D) = "white" {}
		_ShadowContribution("ShadowContribution", Range( 0 , 1)) = 0.5
		_IndirectSpecularContribution("IndirectSpecularContribution", Range( 0 , 1)) = 0
		_BaseCellSharpness("Base Cell Sharpness", Range( 0.01 , 1)) = 0.01
		_BaseCellOffset("Base Cell Offset", Range( -1 , 1)) = 0
		_Highlight("Highlight", 2D) = "white" {}
		_HighlightCellOffset("HighlightCellOffset", Range( -1 , -0.5)) = -0.5
		_HighlightCellSharpness("HighlightCellSharpness", Range( 0.001 , 1)) = 0
		[Toggle(_STATICHIGHLIGHTS_ON)] _StaticHighlights("StaticHighlights", Float) = 0
		_OutlineColor("OutlineColor", Color) = (0.5294118,0.5294118,0.5294118,0)
		_OutlineWidth("Outline Width", Range( 0 , 0.2)) = 0.2
		_RimOffset("RimOffset", Range( 0 , 1)) = 0.6
		_RimPower("RimPower", Range( 0.4 , 1)) = 0.4
		_RimColor("Rim Color", Color) = (1,1,1,0)
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 4
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		
		void outlineVertexDataFunc( inout appdata_full v )
		{
			float2 uv_MainTexture = v.texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float4 tex2DNode2 = tex2Dlod( _MainTexture, float4( uv_MainTexture, 0, 0.0) );
			float CustomOutlineWidth131 = tex2DNode2.a;
			float outlineVar = ( _OutlineWidth * CustomOutlineWidth131 );
			v.vertex.xyz *= ( 1 + outlineVar);
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			float3 temp_cast_0 = (1.0).xxx;
			float3 lerpResult62 = lerp( temp_cast_0 , float3(0,0,0) , 1.0);
			float3 IndirectDiffuseOutput66 = lerpResult62;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float temp_output_44_0 = ( 1.0 - ( ( 1.0 - 1 ) * _WorldSpaceLightPos0.w ) );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 normalizeResult25 = normalize( (WorldNormalVector( i , UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap ), 0.0 ) )) );
			float3 Normals26 = normalizeResult25;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult31 = dot( Normals26 , ase_worldlightDir );
			float NDotL32 = dotResult31;
			float lerpResult46 = lerp( temp_output_44_0 , ( saturate( ( ( NDotL32 + _BaseCellOffset ) / _BaseCellSharpness ) ) * 1 ) , _ShadowContribution);
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float4 tex2DNode2 = tex2D( _MainTexture, uv_MainTexture );
			float3 BaseColor8 = ( ( ( IndirectDiffuseOutput66 * ase_lightColor.a * temp_output_44_0 ) + ( ase_lightColor.rgb * lerpResult46 ) ) * (( tex2DNode2 * _Tint )).rgb );
			o.Emission = ( (_OutlineColor).rgb * BaseColor8 );
			o.Normal = float3(0,0,-1);
		}
		ENDCG
		

		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" }
		Cull Back
		Blend One Zero , SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature_local _STATICHIGHLIGHTS_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _BaseCellOffset;
		uniform float _BaseCellSharpness;
		uniform float _ShadowContribution;
		uniform sampler2D _MainTexture;
		uniform float4 _MainTexture_ST;
		uniform float4 _Tint;
		SamplerState sampler_MainTexture;
		uniform sampler2D _Highlight;
		uniform float4 _Highlight_ST;
		uniform float _IndirectSpecularContribution;
		uniform float _HighlightCellOffset;
		uniform float _HighlightCellSharpness;
		uniform float _RimOffset;
		uniform float _RimPower;
		uniform float4 _RimColor;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;
		uniform float _TessPhongStrength;
		uniform float4 _OutlineColor;
		uniform float _OutlineWidth;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 OutlineOutput75 = 0;
			v.vertex.xyz += OutlineOutput75;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float4 tex2DNode2 = tex2D( _MainTexture, uv_MainTexture );
			float MainAlpha5 = ( tex2DNode2.a * _Tint.a );
			float3 temp_cast_1 = (0.0).xxx;
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 normalizeResult25 = normalize( (WorldNormalVector( i , UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap ), 0.0 ) )) );
			float3 Normals26 = normalizeResult25;
			float3 indirectNormal92 = Normals26;
			float4 color82 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float2 uv_Highlight = i.uv_texcoord * _Highlight_ST.xy + _Highlight_ST.zw;
			float4 temp_output_84_0 = ( color82 * tex2D( _Highlight, uv_Highlight ) );
			float4 Smoothness86 = (temp_output_84_0).rgba;
			Unity_GlossyEnvironmentData g92 = UnityGlossyEnvironmentSetup( Smoothness86.r, data.worldViewDir, indirectNormal92, float3(0,0,0));
			float3 indirectSpecular92 = UnityGI_IndirectSpecular( data, 1.0, indirectNormal92, g92 );
			float3 lerpResult96 = lerp( temp_cast_1 , indirectSpecular92 , _IndirectSpecularContribution);
			float3 IndirectSpecular97 = lerpResult96;
			float4 HighlightColor106 = (temp_output_84_0).rgba;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 LightFalloff103 = ( ase_lightColor.rgb * ase_lightAtten );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult4_g2 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float dotResult109 = dot( normalizeResult4_g2 , Normals26 );
			float dotResult31 = dot( Normals26 , ase_worldlightDir );
			float NDotL32 = dotResult31;
			#ifdef _STATICHIGHLIGHTS_ON
				float staticSwitch111 = NDotL32;
			#else
				float staticSwitch111 = dotResult109;
			#endif
			float4 CellShading121 = saturate( ( ( staticSwitch111 + _HighlightCellOffset ) / ( _HighlightCellSharpness * ( 1.0 - Smoothness86 ) ) ) );
			float4 Highlights129 = ( float4( IndirectSpecular97 , 0.0 ) * HighlightColor106 * float4( LightFalloff103 , 0.0 ) * pow( Smoothness86 , 1.5 ) * CellShading121 );
			float3 temp_cast_5 = (1.0).xxx;
			UnityGI gi60 = gi;
			float3 diffNorm60 = Normals26;
			gi60 = UnityGI_Base( data, 1, diffNorm60 );
			float3 indirectDiffuse60 = gi60.indirect.diffuse + diffNorm60 * 0.0001;
			float3 lerpResult62 = lerp( temp_cast_5 , indirectDiffuse60 , 1.0);
			float3 IndirectDiffuseOutput66 = lerpResult62;
			float temp_output_44_0 = ( 1.0 - ( ( 1.0 - ase_lightAtten ) * _WorldSpaceLightPos0.w ) );
			float lerpResult46 = lerp( temp_output_44_0 , ( saturate( ( ( NDotL32 + _BaseCellOffset ) / _BaseCellSharpness ) ) * ase_lightAtten ) , _ShadowContribution);
			float3 BaseColor8 = ( ( ( IndirectDiffuseOutput66 * ase_lightColor.a * temp_output_44_0 ) + ( ase_lightColor.rgb * lerpResult46 ) ) * (( tex2DNode2 * _Tint )).rgb );
			float dotResult136 = dot( Normals26 , ase_worldViewDir );
			float4 RimColor152 = ( ( saturate( NDotL32 ) * pow( ( 1.0 - saturate( ( dotResult136 + _RimOffset ) ) ) , _RimPower ) ) * HighlightColor106 * float4( LightFalloff103 , 0.0 ) * (_RimColor).rgba );
			float4 FinalLightingOutput80 = ( Highlights129 + float4( BaseColor8 , 0.0 ) + RimColor152 );
			c.rgb = FinalLightingOutput80.rgb;
			c.a = MainAlpha5;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float3 temp_cast_0 = (1.0).xxx;
			float3 lerpResult62 = lerp( temp_cast_0 , float3(0,0,0) , 1.0);
			float3 IndirectDiffuseOutput66 = lerpResult62;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float temp_output_44_0 = ( 1.0 - ( ( 1.0 - 1 ) * _WorldSpaceLightPos0.w ) );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 normalizeResult25 = normalize( (WorldNormalVector( i , UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap ), 0.0 ) )) );
			float3 Normals26 = normalizeResult25;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult31 = dot( Normals26 , ase_worldlightDir );
			float NDotL32 = dotResult31;
			float lerpResult46 = lerp( temp_output_44_0 , ( saturate( ( ( NDotL32 + _BaseCellOffset ) / _BaseCellSharpness ) ) * 1 ) , _ShadowContribution);
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float4 tex2DNode2 = tex2D( _MainTexture, uv_MainTexture );
			float3 BaseColor8 = ( ( ( IndirectDiffuseOutput66 * ase_lightColor.a * temp_output_44_0 ) + ( ase_lightColor.rgb * lerpResult46 ) ) * (( tex2DNode2 * _Tint )).rgb );
			o.Albedo = BaseColor8;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18600
2159;73;1113;625;-703.9033;889.337;3.440266;True;True
Node;AmplifyShaderEditor.CommentaryNode;23;1248,1088;Inherit;False;1357.903;248.2225;Comment;5;26;25;24;20;21;Normals;0.273086,0,0.6792453,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;21;1296,1136;Inherit;False;Constant;_NormalScale;Normal Scale;4;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;1648,1136;Inherit;True;Property;_NormalMap;Normal Map;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;24;1984,1152;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;25;2224,1152;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;2416,1152;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;29;448,1088;Inherit;False;770.1949;335.7215;Normals Dot World Light Dir;4;32;31;30;28;N Dot L;0.8018868,0,0,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;496,1136;Inherit;False;26;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;30;496,1248;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;81;448,-1520;Inherit;False;2286.432;1006.401;Comment;29;121;120;84;83;106;105;85;109;86;117;115;118;116;114;111;113;112;82;110;119;108;125;126;123;122;127;124;128;129;Highlights;0.01720572,0,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;83;496,-1264;Inherit;True;Property;_Highlight;Highlight;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;82;576,-1472;Inherit;False;Constant;_Color0;Color 0;9;0;Create;True;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;31;848,1152;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;3;448,48;Inherit;False;2437.497;959.856;Comment;28;5;12;8;55;7;52;6;48;49;47;67;46;4;2;39;45;44;42;38;36;43;41;35;37;40;34;33;131;Base Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;992,1152;Inherit;False;NDotL;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;912,-1360;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;34;464,192;Inherit;False;Property;_BaseCellOffset;Base Cell Offset;6;0;Create;True;0;0;False;0;False;0;0.01;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;57;448,1488;Inherit;False;886.4301;315.5576;Comment;6;66;65;62;56;61;60;Indirect Diffuse;0.6320754,0.6045749,0,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;85;1088,-1360;Inherit;False;True;True;True;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;544,112;Inherit;False;32;NDotL;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;464,1520;Inherit;False;26;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;37;464,272;Inherit;False;Property;_BaseCellSharpness;Base Cell Sharpness;5;0;Create;True;0;0;False;0;False;0.01;1;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;40;848,208;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;134;464,1904;Inherit;False;2045.144;514.0862;Comment;18;152;141;145;142;140;139;138;144;135;137;136;143;151;147;146;150;149;148;Rim Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;1296,-1344;Inherit;False;Smoothness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;108;636.6022,-1039.848;Inherit;False;Blinn-Phong Half Vector;-1;;2;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;664.7619,-882.4235;Inherit;False;26;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;736,112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;60;656,1616;Inherit;False;World;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;41;1088,272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;1034.667,-622.9513;Inherit;False;86;Smoothness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;137;495.7079,2078.971;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;112;659.3801,-783.7645;Inherit;False;32;NDotL;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;36;880,112;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;672,1536;Inherit;False;Constant;_DefaultDiffuseLight;Default Diffuse Light;7;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;505.0123,1952.83;Inherit;False;26;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;43;832,320;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;65;656,1712;Inherit;False;Constant;_IndirectDiffuceContribution;Indirect Diffuce Contribution;7;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;109;935.6245,-973.907;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;638.8587,2259.448;Inherit;False;Property;_RimOffset;RimOffset;13;0;Create;True;0;0;False;0;False;0.6;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;136;756.8995,2005.267;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;62;912,1568;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;116;1231.99,-621.3274;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;38;1024,112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;1052.352,-751.6326;Inherit;False;Property;_HighlightCellSharpness;HighlightCellSharpness;9;0;Create;True;0;0;False;0;False;0;0.001;0.001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;87;1232,-448;Inherit;False;1190.466;427.5466;;7;97;93;92;96;91;88;95;Indirect Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;111;1082.715,-975.7006;Inherit;False;Property;_StaticHighlights;StaticHighlights;10;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;1068.28,-854.439;Inherit;False;Property;_HighlightCellOffset;HighlightCellOffset;8;0;Create;True;0;0;False;0;False;-0.5;-0.95;-1;-0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;1248,288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;114;1424.675,-925.8132;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;1248,-288;Inherit;False;86;Smoothness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;45;1152,416;Inherit;False;Property;_ShadowContribution;ShadowContribution;3;0;Create;True;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;138;996.1138,2088.762;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;98;2640,1088;Inherit;False;647.2675;376.6853;Comment;4;103;102;100;101;Light Falloff;1,0.9538098,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;1184,112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;44;1392,288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;1104,1568;Inherit;False;IndirectDiffuseOutput;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;1248,-400;Inherit;False;26;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;1432.672,-665.5728;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;119;1633.891,-822.3859;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;1568,96;Inherit;False;66;IndirectDiffuseOutput;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;95;1648,-400;Inherit;False;Constant;_DefaultSpecular;DefaultSpecular;11;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;140;1140.977,2095.109;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;100;2672,1136;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;4;1006.416,778.7715;Inherit;False;Property;_Tint;Tint;1;0;Create;True;0;0;False;0;False;1,1,1,1;0,0.0545814,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;93;1632,-128;Inherit;False;Property;_IndirectSpecularContribution;IndirectSpecularContribution;4;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;1568,368;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectSpecularLight;92;1616,-288;Inherit;False;World;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;47;1392,96;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LightAttenuation;101;2656,1280;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;926.4156,586.7715;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;144;1310.489,1979.294;Inherit;False;32;NDotL;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;141;1324.364,2091.756;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;142;1075.342,2237.453;Inherit;False;Property;_RimPower;RimPower;14;0;Create;True;0;0;False;0;False;0.4;0.4;0.4;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;1792,192;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;1744,336;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;120;1796.255,-814.0596;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;1278.416,666.7715;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;105;1088,-1232;Inherit;False;True;True;True;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;96;1968,-368;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;2896,1200;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;147;1514.508,2224.782;Inherit;False;Property;_RimColor;Rim Color;15;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;143;1508.955,2092.904;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;7;1438.416,666.7715;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;1280,-1232;Inherit;False;HighlightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;145;1508.751,1980.893;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;1966.929,-802.8902;Inherit;False;CellShading;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;3088,1248;Inherit;False;LightFalloff;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;1545.556,-1186.526;Inherit;False;86;Smoothness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;1984,320;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;2208,-368;Inherit;False;IndirectSpecular;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;1731.362,-1406.747;Inherit;False;97;IndirectSpecular;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;1768.494,2067.639;Inherit;False;106;HighlightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;1757.942,-1083.188;Inherit;False;121;CellShading;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;2173.161,341.9903;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;69;1361.26,1382.85;Inherit;False;1178.321;469.6807;Comment;9;75;74;72;73;70;71;68;132;133;Outline;0.6792453,0,0.4646906,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;148;1783.112,2257.67;Inherit;False;True;True;True;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;127;1788.37,-1177.586;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1.5;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;1794.075,2160.828;Inherit;False;103;LightFalloff;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;1737.782,-1332.963;Inherit;False;106;HighlightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;1814.821,1952.571;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;1757.462,-1253.947;Inherit;False;103;LightFalloff;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;131;1312.118,532.9926;Inherit;False;CustomOutlineWidth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;68;1377.26,1430.85;Inherit;False;Property;_OutlineColor;OutlineColor;11;0;Create;True;0;0;False;0;False;0.5294118,0.5294118,0.5294118,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;2102.722,-1278.425;Inherit;False;5;5;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;2086.435,2082.257;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;2256,576;Inherit;False;BaseColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;1554.66,1748.348;Inherit;False;131;CustomOutlineWidth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;77;445.1417,-430.021;Inherit;False;731.4917;355.9041;Comment;5;80;79;78;130;153;Final Lighting;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;2282.304,-1312.545;Inherit;False;Highlights;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;1601.26,1542.85;Inherit;False;8;BaseColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;2309.358,2096.875;Inherit;False;RimColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;73;1530.3,1644.03;Inherit;False;Property;_OutlineWidth;Outline Width;12;0;Create;True;0;0;False;0;False;0.2;0.045;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;70;1601.26,1430.85;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;490.9435,-172.9147;Inherit;False;152;RimColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1809.26,1430.85;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;499.1742,-356.917;Inherit;False;129;Highlights;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;1825.447,1690.51;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;496.1291,-264.2863;Inherit;False;8;BaseColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OutlineNode;74;2053.161,1436.108;Inherit;False;1;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;1294.415,810.7715;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;749.8766,-299.7372;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;942.2762,-287.3371;Inherit;False;FinalLightingOutput;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;2300.036,1434.484;Inherit;False;OutlineOutput;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;11;2912,48;Inherit;False;679.0034;679.1249;Comment;5;19;76;9;59;10;Shader Output;0.002886745,0.5943396,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;1502.416,826.7715;Inherit;False;MainAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;9;2977,246;Inherit;False;5;MainAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;10;2976,112;Inherit;False;8;BaseColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;2958.037,497.3116;Inherit;False;75;OutlineOutput;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;2951,340;Inherit;False;80;FinalLightingOutput;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;19;3341,103;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;ToonShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;4;10;25;True;0.5;True;0;0;False;-1;0;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;16;-1;-1;17;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;5;21;0
WireConnection;24;0;20;0
WireConnection;25;0;24;0
WireConnection;26;0;25;0
WireConnection;31;0;28;0
WireConnection;31;1;30;0
WireConnection;32;0;31;0
WireConnection;84;0;82;0
WireConnection;84;1;83;0
WireConnection;85;0;84;0
WireConnection;86;0;85;0
WireConnection;35;0;33;0
WireConnection;35;1;34;0
WireConnection;60;0;56;0
WireConnection;41;0;40;0
WireConnection;36;0;35;0
WireConnection;36;1;37;0
WireConnection;109;0;108;0
WireConnection;109;1;110;0
WireConnection;136;0;135;0
WireConnection;136;1;137;0
WireConnection;62;0;61;0
WireConnection;62;1;60;0
WireConnection;62;2;65;0
WireConnection;116;0;115;0
WireConnection;38;0;36;0
WireConnection;111;1;109;0
WireConnection;111;0;112;0
WireConnection;42;0;41;0
WireConnection;42;1;43;2
WireConnection;114;0;111;0
WireConnection;114;1;113;0
WireConnection;138;0;136;0
WireConnection;138;1;139;0
WireConnection;39;0;38;0
WireConnection;39;1;40;0
WireConnection;44;0;42;0
WireConnection;66;0;62;0
WireConnection;118;0;117;0
WireConnection;118;1;116;0
WireConnection;119;0;114;0
WireConnection;119;1;118;0
WireConnection;140;0;138;0
WireConnection;46;0;44;0
WireConnection;46;1;39;0
WireConnection;46;2;45;0
WireConnection;92;0;88;0
WireConnection;92;1;91;0
WireConnection;141;0;140;0
WireConnection;49;0;67;0
WireConnection;49;1;47;2
WireConnection;49;2;44;0
WireConnection;48;0;47;1
WireConnection;48;1;46;0
WireConnection;120;0;119;0
WireConnection;6;0;2;0
WireConnection;6;1;4;0
WireConnection;105;0;84;0
WireConnection;96;0;95;0
WireConnection;96;1;92;0
WireConnection;96;2;93;0
WireConnection;102;0;100;1
WireConnection;102;1;101;0
WireConnection;143;0;141;0
WireConnection;143;1;142;0
WireConnection;7;0;6;0
WireConnection;106;0;105;0
WireConnection;145;0;144;0
WireConnection;121;0;120;0
WireConnection;103;0;102;0
WireConnection;52;0;49;0
WireConnection;52;1;48;0
WireConnection;97;0;96;0
WireConnection;55;0;52;0
WireConnection;55;1;7;0
WireConnection;148;0;147;0
WireConnection;127;0;125;0
WireConnection;146;0;145;0
WireConnection;146;1;143;0
WireConnection;131;0;2;4
WireConnection;128;0;126;0
WireConnection;128;1;123;0
WireConnection;128;2;122;0
WireConnection;128;3;127;0
WireConnection;128;4;124;0
WireConnection;151;0;146;0
WireConnection;151;1;150;0
WireConnection;151;2;149;0
WireConnection;151;3;148;0
WireConnection;8;0;55;0
WireConnection;129;0;128;0
WireConnection;152;0;151;0
WireConnection;70;0;68;0
WireConnection;72;0;70;0
WireConnection;72;1;71;0
WireConnection;133;0;73;0
WireConnection;133;1;132;0
WireConnection;74;0;72;0
WireConnection;74;1;133;0
WireConnection;12;0;2;4
WireConnection;12;1;4;4
WireConnection;79;0;130;0
WireConnection;79;1;78;0
WireConnection;79;2;153;0
WireConnection;80;0;79;0
WireConnection;75;0;74;0
WireConnection;5;0;12;0
WireConnection;19;0;10;0
WireConnection;19;9;9;0
WireConnection;19;13;59;0
WireConnection;19;11;76;0
ASEEND*/
//CHKSM=7FECA76CBB7C2D8D7BF1E5060BCB0EB8EE8CC0BD