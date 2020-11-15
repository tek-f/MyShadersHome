// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader_Water"
{
	Properties
	{
		_NormalMap("NormalMap", 2D) = "white" {}
		_LerpStrength("LerpStrength", Range( 0 , 1)) = 0
		_AnimateUV1XYUV2ZW("Animate UV1 (XY) UV2 (ZW)", Vector) = (0,0,0,0)
		_UV1TilingXYScaleZW("UV1 Tiling (XY) Scale (ZW)", Vector) = (1,1,1,1)
		_UV2TilingXYScaleZW("UV2 Tiling (XY) Scale(ZW)", Vector) = (0,0,0,0)
		_WaterTintColor("Water Tint Color", Color) = (0.7028302,1,1,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
			float3 viewDir;
			float3 worldNormal;
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

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _NormalMap;
		uniform float4 _AnimateUV1XYUV2ZW;
		uniform float4 _UV1TilingXYScaleZW;
		uniform float4 _UV2TilingXYScaleZW;
		uniform float _LerpStrength;
		uniform float4 _WaterTintColor;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 appendResult7 = (float4(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g , 0.0 , 0.0));
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_21_0 = (ase_worldPos).xz;
			float4 appendResult30 = (float4(( _Time.x * _AnimateUV1XYUV2ZW.x ) , ( _Time.x * _AnimateUV1XYUV2ZW.y ) , 0.0 , 0.0));
			float4 appendResult35 = (float4(_UV1TilingXYScaleZW.z , _UV1TilingXYScaleZW.w , 0.0 , 0.0));
			float4 appendResult34 = (float4(_UV1TilingXYScaleZW.x , _UV1TilingXYScaleZW.y , 0.0 , 0.0));
			float4 UV136 = ( ( ( float4( temp_output_21_0, 0.0 , 0.0 ) + appendResult30 ) * appendResult35 ) / appendResult34 );
			float4 appendResult39 = (float4(( _AnimateUV1XYUV2ZW.z * _Time.x ) , ( _Time.x * _AnimateUV1XYUV2ZW.w ) , 0.0 , 0.0));
			float4 appendResult45 = (float4(_UV2TilingXYScaleZW.x , _UV2TilingXYScaleZW.y , 0.0 , 0.0));
			float4 appendResult46 = (float4(_UV2TilingXYScaleZW.z , _UV2TilingXYScaleZW.w , 0.0 , 0.0));
			float4 UV243 = ( ( ( float4( temp_output_21_0, 0.0 , 0.0 ) + appendResult39 ) * appendResult45 ) / appendResult46 );
			float4 lerpResult9 = lerp( tex2D( _NormalMap, UV136.xy ) , float4( UnpackNormal( tex2D( _NormalMap, UV243.xy ) ) , 0.0 ) , _LerpStrength);
			float4 normalMapping11 = lerpResult9;
			float4 screenUV13 = ( appendResult7 - float4( ( (normalMapping11).rga * 0.1 ) , 0.0 ) );
			float4 screenColor1 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,screenUV13.xy);
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float4 appendResult69 = (float4(ase_vertexNormal.x , ase_vertexNormal.y , 0.0 , 0.0));
			float3 appendResult73 = (float3(( appendResult69 - float4( (normalMapping11).rg, 0.0 , 0.0 ) ).xy , ase_vertexNormal.z));
			float dotResult60 = dot( i.viewDir , appendResult73 );
			float fresnel68 = pow( ( 1.0 - saturate( abs( dotResult60 ) ) ) , 1.0 );
			float4 lerpResult57 = lerp( screenColor1 , _WaterTintColor , fresnel68);
			c.rgb = lerpResult57.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18600
91;1153;1920;928;2595.735;2116.436;2.969357;True;False
Node;AmplifyShaderEditor.CommentaryNode;47;-1594.924,-1286.43;Inherit;False;1911.133;1072.602;Comment;24;21;20;24;25;27;30;22;29;33;35;31;34;32;36;37;38;39;40;41;44;45;46;42;43;Annimated UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;29;-1544.924,-725.231;Inherit;False;Property;_AnimateUV1XYUV2ZW;Animate UV1 (XY) UV2 (ZW);2;0;Create;True;0;0;False;0;False;0,0,0,0;10,10,10,10;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;24;-1541.136,-937.739;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1205.084,-569.9178;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1209.426,-687.1192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1230.888,-808.9968;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1217.181,-970.8541;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;20;-1537.382,-1171.984;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;30;-1044.134,-906.4694;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector4Node;33;-972.482,-1236.43;Inherit;False;Property;_UV1TilingXYScaleZW;UV1 Tiling (XY) Scale (ZW);3;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,10,10;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;44;-1076.166,-425.8281;Inherit;False;Property;_UV2TilingXYScaleZW;UV2 Tiling (XY) Scale(ZW);4;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,5,5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;39;-1048.816,-643.711;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;21;-1288.334,-1114.443;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-862.1631,-756.5714;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-894.9708,-1024.336;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;35;-672.575,-1135.205;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;-816.6083,-564.7463;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-687.0839,-758.0181;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-419.2853,-1178.908;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-480.1823,-993.8922;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;46;-672.2065,-444.1067;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;42;-493.2693,-675.3821;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;32;-156.4923,-995.2448;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-317.8103,-678.9647;Inherit;False;UV2;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;92.2094,-995.2202;Inherit;False;UV1;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;12;-1448.363,623.7635;Inherit;False;1318.766;638.5795;Comment;9;11;9;10;2;3;48;49;52;53;Normal Mapping;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-1288.535,720.2672;Inherit;False;36;UV1;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-1281.923,948.3966;Inherit;False;43;UV2;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;3;-1004.987,897.1207;Inherit;True;Property;_NormalMap1;NormalMap;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-944.1243,1130.007;Inherit;False;Property;_LerpStrength;LerpStrength;1;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1011.75,668.3182;Inherit;True;Property;_NormalMap;NormalMap;0;0;Create;True;0;0;False;0;False;-1;None;3621ff7803782334182316bd23b2506b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;9;-581.2728,878.6458;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;66;-1584,-1792;Inherit;False;1890.012;480.6888;Comment;14;58;65;60;61;62;63;64;68;59;69;70;71;73;75;Fresnel;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-417.077,868.5106;Inherit;False;normalMapping;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;59;-1395.295,-1713.488;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;70;-1415.598,-1542.567;Inherit;False;11;normalMapping;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;69;-1188.097,-1703.767;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;71;-1207.598,-1551.668;Inherit;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;75;-992.923,-1633.193;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;14;-1493.474,-13.26464;Inherit;False;956.8313;536.9556;Comment;8;13;8;17;7;19;16;5;15;Screen UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;-832.5965,-1555.669;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;58;-844.9664,-1734.134;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;60;-604.8801,-1698.909;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-1475.861,302.0672;Inherit;False;11;normalMapping;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;19;-1265.426,311.0202;Inherit;False;True;True;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1404.892,417.0649;Inherit;False;Constant;_01;0.1;2;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;61;-476.88,-1705.35;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;5;-1443.474,36.73541;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;7;-1203.57,64.89769;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1039.164,312.6461;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;62;-357.4285,-1707.239;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-886.2297,197.3735;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-383.8645,-1606.568;Inherit;False;Constant;_FresnelPower;FresnelPower;7;0;Create;True;0;0;False;0;False;1;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;63;-211.6412,-1708.132;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;77;-501.5037,-120.0963;Inherit;False;1013.841;698.6848;Comment;8;18;56;1;67;57;0;76;78;Main Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;64;-56.41236,-1713.797;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-726.4226,189.19;Inherit;False;screenUV;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;98.58145,-1718.047;Inherit;False;fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-451.5036,132.8042;Inherit;False;13;screenUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-195.9267,426.1437;Inherit;False;68;fresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;1;-233.0527,168.8083;Inherit;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;56;-400.6438,366.5884;Inherit;False;Property;_WaterTintColor;Water Tint Color;7;0;Create;True;0;0;False;0;False;0.7028302,1,1,0;0.7028302,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;78;-470.3549,16.23698;Inherit;False;11;normalMapping;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.IndirectSpecularLight;76;-236.2709,12.9291;Inherit;False;World;3;0;FLOAT3;0,0,1;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;57;47.65268,211.616;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1308.951,815.7999;Inherit;False;Property;_NormalMap1Strength;Normal Map 1 Strength;5;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1290.094,1025.751;Inherit;False;Property;_NormalMap2Strength;Normal Map 2 Strength;6;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;257.3374,-70.09634;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Shader_Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;38;0;24;1
WireConnection;38;1;29;4
WireConnection;37;0;29;3
WireConnection;37;1;24;1
WireConnection;27;0;24;1
WireConnection;27;1;29;2
WireConnection;25;0;24;1
WireConnection;25;1;29;1
WireConnection;30;0;25;0
WireConnection;30;1;27;0
WireConnection;39;0;37;0
WireConnection;39;1;38;0
WireConnection;21;0;20;0
WireConnection;40;0;21;0
WireConnection;40;1;39;0
WireConnection;22;0;21;0
WireConnection;22;1;30;0
WireConnection;35;0;33;3
WireConnection;35;1;33;4
WireConnection;45;0;44;1
WireConnection;45;1;44;2
WireConnection;41;0;40;0
WireConnection;41;1;45;0
WireConnection;34;0;33;1
WireConnection;34;1;33;2
WireConnection;31;0;22;0
WireConnection;31;1;35;0
WireConnection;46;0;44;3
WireConnection;46;1;44;4
WireConnection;42;0;41;0
WireConnection;42;1;46;0
WireConnection;32;0;31;0
WireConnection;32;1;34;0
WireConnection;43;0;42;0
WireConnection;36;0;32;0
WireConnection;3;1;49;0
WireConnection;2;1;48;0
WireConnection;9;0;2;0
WireConnection;9;1;3;0
WireConnection;9;2;10;0
WireConnection;11;0;9;0
WireConnection;69;0;59;1
WireConnection;69;1;59;2
WireConnection;71;0;70;0
WireConnection;75;0;69;0
WireConnection;75;1;71;0
WireConnection;73;0;75;0
WireConnection;73;2;59;3
WireConnection;60;0;58;0
WireConnection;60;1;73;0
WireConnection;19;0;15;0
WireConnection;61;0;60;0
WireConnection;7;0;5;1
WireConnection;7;1;5;2
WireConnection;17;0;19;0
WireConnection;17;1;16;0
WireConnection;62;0;61;0
WireConnection;8;0;7;0
WireConnection;8;1;17;0
WireConnection;63;0;62;0
WireConnection;64;0;63;0
WireConnection;64;1;65;0
WireConnection;13;0;8;0
WireConnection;68;0;64;0
WireConnection;1;0;18;0
WireConnection;76;0;78;0
WireConnection;57;0;1;0
WireConnection;57;1;56;0
WireConnection;57;2;67;0
WireConnection;0;13;57;0
ASEEND*/
//CHKSM=BEA19408C8D0E4F110EB347396AA57FFE02DA747