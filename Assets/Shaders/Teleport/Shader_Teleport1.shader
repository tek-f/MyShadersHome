// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader_Teleport1"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Tiling("Tiling", Vector) = (5,5,0,0)
		_Speed("Speed", Float) = 0
		_Teleport("Teleport", Range( -20 , 20)) = 0
		_Range("Range", Range( -20 , 20)) = 0
		[HDR][Gamma]_GlowColor("Glow Color", Color) = (0,24.32254,42.72251,1)
		_AmbientOcculsion("Ambient Occulsion", 2D) = "white" {}
		_Albedo("Albedo", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "white" {}
		_Metalic("Metalic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _AmbientOcculsion;
		uniform float4 _AmbientOcculsion_ST;
		uniform float _Teleport;
		uniform float _Range;
		uniform float2 _Tiling;
		uniform float _Speed;
		uniform float4 _GlowColor;
		uniform float _Metalic;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.5;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float4 NormalMap77 = tex2D( _NormalMap, uv_NormalMap );
			o.Normal = NormalMap77.rgb;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 color68 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float2 uv_AmbientOcculsion = i.uv_texcoord * _AmbientOcculsion_ST.xy + _AmbientOcculsion_ST.zw;
			float4 Albedo72 = ( tex2D( _Albedo, uv_Albedo ) * color68 * tex2D( _AmbientOcculsion, uv_AmbientOcculsion ) );
			o.Albedo = Albedo72.rgb;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform35 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Teleport56 = ( _Teleport * _CosTime.y );
			float YGradient33 = saturate( ( ( transform35.y + Teleport56 ) / _Range ) );
			float mulTime6 = _Time.y * _Speed;
			float2 panner5 = ( mulTime6 * float2( 0,-1 ) + float2( 0,0 ));
			float2 uv_TexCoord1 = i.uv_texcoord * _Tiling + panner5;
			float simplePerlin2D16 = snoise( uv_TexCoord1 );
			simplePerlin2D16 = simplePerlin2D16*0.5 + 0.5;
			float NoiseOutput22 = ( simplePerlin2D16 + 0.0 );
			float4 Emission64 = ( ( YGradient33 * NoiseOutput22 ) * _GlowColor );
			o.Emission = Emission64.rgb;
			o.Metallic = _Metalic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			float temp_output_47_0 = ( YGradient33 * 1.0 );
			float OpacityMask44 = ( ( ( ( 1.0 - YGradient33 ) * NoiseOutput22 ) - temp_output_47_0 ) + ( 1.0 - temp_output_47_0 ) );
			clip( OpacityMask44 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18600
286;99;962;650;1814.785;543.8552;2.631541;False;False
Node;AmplifyShaderEditor.RangedFloatNode;26;-2568.36,661.221;Inherit;False;Property;_Teleport;Teleport;3;0;Create;True;0;0;False;0;False;0;-20;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosTime;67;-2546.533,954.4651;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;23;-1639.543,-179.3566;Inherit;False;2044.254;624.23;Comment;9;22;4;20;1;5;19;16;6;18;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-1632,544;Inherit;False;1952.739;710.9845;Comment;8;37;33;38;36;27;35;25;57;Y Gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2112.405,963.8764;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-1857.879,751.5762;Inherit;False;Teleport;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;25;-1584,592;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-1561.928,214.9082;Inherit;True;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;False;0;12.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1424.523,1027.051;Inherit;False;56;Teleport;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;35;-1264,624;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;6;-1302.564,192.8163;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;4;-1043.267,-129.3566;Inherit;False;Property;_Tiling;Tiling;1;0;Create;True;0;0;False;0;False;5,5;50,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;5;-1064.766,177.4357;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-816,704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-938.6876,985.4141;Inherit;False;Property;_Range;Range;4;0;Create;True;0;0;False;0;False;0;20;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-770.2378,-15.56859;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;36;-496,784;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-407.5237,233.5325;Inherit;True;Constant;_Booster;Booster;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;38;-192,816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;16;-454.689,2.231934;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-125.6135,139.5749;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;112,832;Inherit;False;YGradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;45;-1608.355,1295.621;Inherit;False;1729.92;886.1586;Comment;10;44;50;49;48;47;43;41;42;46;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-1558.355,1345.621;Inherit;False;33;YGradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;162.9986,143.1546;Inherit;True;NoiseOutput;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1331.116,1913.239;Inherit;False;33;YGradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-1268.132,1593.046;Inherit;False;22;NoiseOutput;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;41;-1246.77,1354.397;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1055.751,1916.704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-1520.233,2562.273;Inherit;False;22;NoiseOutput;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-1540.448,2324.184;Inherit;False;33;YGradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-978.5695,1483.212;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;73;-1735.956,-1099.196;Inherit;False;953.9576;798.7015;Albedo;5;72;70;69;68;71;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;-707.9799,1638.138;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;68;-1637.956,-789.587;Inherit;False;Constant;_Tint;Tint;6;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;49;-679.301,1945.578;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-1235.56,2530.101;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;65;-1233.768,2815.232;Inherit;False;Property;_GlowColor;Glow Color;5;2;[HDR];[Gamma];Create;True;0;0;False;0;False;0,24.32254,42.72251,1;0,18.26178,32,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;76;-677.3371,-1101.075;Inherit;False;910.3591;790.5052;Comment;2;75;77;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;69;-1685.956,-537.8442;Inherit;True;Property;_AmbientOcculsion;Ambient Occulsion;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;71;-1667.266,-1049.196;Inherit;True;Property;_Albedo;Albedo;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-977.3699,2641.99;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;75;-627.3371,-1048.65;Inherit;True;Property;_NormalMap;Normal Map;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1310.137,-795.0909;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-410.8002,1791.025;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-1034.084,-752.6697;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-63.71052,1768.268;Inherit;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-706.5413,2637.16;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-213.0015,-995.8667;Inherit;False;NormalMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;80;521.4966,483.3625;Inherit;False;Property;_Smoothness;Smoothness;10;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;598.5408,725.8226;Inherit;False;44;OpacityMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;518.6274,-120.2841;Inherit;False;77;NormalMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SinTimeNode;58;-2522.003,1181.561;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;74;559.4771,-366.8246;Inherit;False;72;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;520.7654,78.75618;Inherit;False;64;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;79;503.2878,271.5304;Inherit;False;Property;_Metalic;Metalic;9;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;854.1366,77.90983;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Shader_Teleport1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;59;0;26;0
WireConnection;59;1;67;2
WireConnection;56;0;59;0
WireConnection;35;0;25;0
WireConnection;6;0;18;0
WireConnection;5;1;6;0
WireConnection;27;0;35;2
WireConnection;27;1;57;0
WireConnection;1;0;4;0
WireConnection;1;1;5;0
WireConnection;36;0;27;0
WireConnection;36;1;37;0
WireConnection;38;0;36;0
WireConnection;16;0;1;0
WireConnection;19;0;16;0
WireConnection;19;1;20;0
WireConnection;33;0;38;0
WireConnection;22;0;19;0
WireConnection;41;0;40;0
WireConnection;47;0;46;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;48;0;43;0
WireConnection;48;1;47;0
WireConnection;49;0;47;0
WireConnection;62;0;60;0
WireConnection;62;1;61;0
WireConnection;66;0;62;0
WireConnection;66;1;65;0
WireConnection;70;0;71;0
WireConnection;70;1;68;0
WireConnection;70;2;69;0
WireConnection;50;0;48;0
WireConnection;50;1;49;0
WireConnection;72;0;70;0
WireConnection;44;0;50;0
WireConnection;64;0;66;0
WireConnection;77;0;75;0
WireConnection;0;0;74;0
WireConnection;0;1;78;0
WireConnection;0;2;51;0
WireConnection;0;3;79;0
WireConnection;0;4;80;0
WireConnection;0;10;34;0
ASEEND*/
//CHKSM=127A0F8EF9B58E19CA60078FC0CDC17CBF840429