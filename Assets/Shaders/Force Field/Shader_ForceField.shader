// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader_ForceField"
{
	Properties
	{
		_AnnimationSpeed("Annimation Speed", Range( 1 , 10)) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_ShieldPower("ShieldPower", Range( 0 , 100)) = 0
		_ShieldPatternScale("Shield Pattern Scale", Range( 0 , 5)) = 0
		_AnnimationScale("Annimation Scale", Range( 0 , 0.25)) = 0
		_emissionColor("emissionColor", Color) = (0,0.1404216,0.2924528,1)
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_RimColor("RimColor", Color) = (0,0,0,0)
		_TimeScale("Time Scale", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _AnnimationSpeed;
		uniform float _AnnimationScale;
		uniform sampler2D _TextureSample0;
		uniform float _ShieldPatternScale;
		uniform float _TimeScale;
		uniform float4 _emissionColor;
		uniform float4 _RimColor;
		uniform float _ShieldPower;
		uniform float _Opacity;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float simplePerlin2D7 = snoise( ( ase_vertexNormal + ( _Time.x * _AnnimationSpeed ) ).xy );
			simplePerlin2D7 = simplePerlin2D7*0.5 + 0.5;
			float VetexDistortion36 = (( _AnnimationScale * 0.0 ) + (simplePerlin2D7 - 0.0) * (_AnnimationScale - ( _AnnimationScale * 0.0 )) / (1.0 - 0.0));
			float3 temp_cast_1 = (VetexDistortion36).xxx;
			v.vertex.xyz += temp_cast_1;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 appendResult23 = (float4(_ShieldPatternScale , _ShieldPatternScale , 0.0 , 0.0));
			float mulTime105 = _Time.y * _TimeScale;
			float4 appendResult116 = (float4(0.0 , mulTime105 , 0.0 , 0.0));
			float2 uv_TexCoord25 = i.uv_texcoord * appendResult23.xy + appendResult116.xy;
			float4 ShieldMainPatternOutput35 = ( tex2D( _TextureSample0, uv_TexCoord25 ) * _emissionColor );
			o.Albedo = ShieldMainPatternOutput35.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float ShieldPower31 = _ShieldPower;
			float fresnelNdotV13 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode13 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV13, (10.0 + (ShieldPower31 - 0.0) * (0.0 - 10.0) / (10.0 - 0.0)) ) );
			float4 ShieldRimOutput33 = ( _RimColor * fresnelNode13 );
			o.Emission = ShieldRimOutput33.rgb;
			o.Alpha = _Opacity;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
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
403;73;962;650;719.5129;363.3572;1.397533;True;False
Node;AmplifyShaderEditor.CommentaryNode;18;-841.3776,-759.6338;Inherit;False;1284.228;446.8881;Comment;8;118;117;33;13;12;32;31;11;Fresnel/FieldRim;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;28;-848,-240;Inherit;False;1407.305;490.8243;Comment;8;35;132;27;26;25;116;23;105;Field Main Pattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;10;-864,336;Inherit;False;1341.276;690.9487;Comment;10;36;9;8;7;5;6;4;3;2;1;Vertex Offset/Distortion;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-815.2169,-697.1025;Inherit;False;Property;_ShieldPower;ShieldPower;2;0;Create;True;0;0;False;0;False;0;7.6;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-864,32;Inherit;False;Property;_TimeScale;Time Scale;8;0;Create;True;0;0;False;0;False;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-864,-160;Inherit;False;Property;_ShieldPatternScale;Shield Pattern Scale;3;0;Create;True;0;0;False;0;False;0;0.61;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;105;-656,32;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-484.2923,-686.4086;Inherit;False;ShieldPower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-800,832;Inherit;False;Property;_AnnimationSpeed;Annimation Speed;0;0;Create;True;0;0;False;0;False;0;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;1;-736,592;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;3;-656,400;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;32;-785.9083,-565.0265;Inherit;False;31;ShieldPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-496,704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-496,-176;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;116;-464,16;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-368,880;Inherit;False;Property;_AnnimationScale;Annimation Scale;4;0;Create;True;0;0;False;0;False;0;0.01;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-336,-192;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;12;-454.9218,-582.6377;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;10;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-336,608;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;13;-225.856,-500.9032;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;117;-221.8379,-684.3777;Inherit;False;Property;_RimColor;RimColor;7;0;Create;True;0;0;False;0;False;0,0,0,0;0,1,0.9335959,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-96,704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;7;-192,608;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-144,-192;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;False;-1;77bd9e6842f978b4ab6e9e04e655aa3e;77bd9e6842f978b4ab6e9e04e655aa3e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;27;-224,64;Inherit;False;Property;_emissionColor;emissionColor;5;0;Create;True;0;0;False;0;False;0,0.1404216,0.2924528,1;0,1,0.8651323,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;9;96,640;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;175.2296,-82.31123;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;29.22041,-598.0764;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;288,640;Inherit;False;VetexDistortion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;214.8082,-598.2938;Inherit;False;ShieldRimOutput;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;133;576,-768;Inherit;False;677.3268;521;Comment;5;113;125;106;119;0;Shader Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;319.516,-92.52365;Inherit;True;ShieldMainPatternOutput;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;624,-720;Inherit;False;35;ShieldMainPatternOutput;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;113;640,-496;Inherit;False;Property;_Opacity;Opacity;6;0;Create;True;0;0;False;0;False;0;0.278;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;688,-624;Inherit;False;33;ShieldRimOutput;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;736,-400;Inherit;False;36;VetexDistortion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1008,-720;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Shader_ForceField;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;105;0;122;0
WireConnection;31;0;11;0
WireConnection;4;0;1;1
WireConnection;4;1;2;0
WireConnection;23;0;20;0
WireConnection;23;1;20;0
WireConnection;116;1;105;0
WireConnection;25;0;23;0
WireConnection;25;1;116;0
WireConnection;12;0;32;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;13;3;12;0
WireConnection;8;0;6;0
WireConnection;7;0;5;0
WireConnection;26;1;25;0
WireConnection;9;0;7;0
WireConnection;9;3;8;0
WireConnection;9;4;6;0
WireConnection;132;0;26;0
WireConnection;132;1;27;0
WireConnection;118;0;117;0
WireConnection;118;1;13;0
WireConnection;36;0;9;0
WireConnection;33;0;118;0
WireConnection;35;0;132;0
WireConnection;0;0;119;0
WireConnection;0;2;125;0
WireConnection;0;9;113;0
WireConnection;0;11;106;0
ASEEND*/
//CHKSM=32AE32AF6881706E2CAE50FABB066457E1F7A06B