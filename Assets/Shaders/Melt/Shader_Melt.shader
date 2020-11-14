// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader_Dissolve"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Teleport("Teleport", Range( -20 , 20)) = 0
		_Range("Range", Range( -20 , 20)) = 0
		[HDR][Gamma]_GlowColor("Glow Color", Color) = (0,24.32254,42.72251,1)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _Teleport;
		uniform float _Range;
		uniform float4 _GlowColor;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform10 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Dissolve6 = ( _Teleport * _CosTime.w );
			float YGradient22 = saturate( ( ( transform10.y + Dissolve6 ) / _Range ) );
			float4 Emission48 = ( ( YGradient22 * YGradient22 ) * _GlowColor );
			o.Emission = Emission48.rgb;
			o.Alpha = 1;
			float temp_output_29_0 = ( YGradient22 * 1.0 );
			float OpacityMask47 = ( ( ( ( 1.0 - YGradient22 ) * YGradient22 ) - temp_output_29_0 ) + ( 1.0 - temp_output_29_0 ) );
			clip( OpacityMask47 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18600
0;73;1920;928;1096.765;-167.3416;1.687128;True;False
Node;AmplifyShaderEditor.CommentaryNode;58;550.6338,877.0168;Inherit;False;984.4811;606.6554;Comment;4;1;2;5;6;Dissolve Over Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.CosTime;2;658.8727,1076.269;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1;600.6339,927.0168;Inherit;False;Property;_Teleport;Teleport;3;0;Create;True;0;0;False;0;False;0;20;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;4;-1279.447,49.73694;Inherit;False;1952.739;710.9845;Comment;8;22;19;17;15;14;10;9;7;Y Gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;1040.15,1080.458;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;1311.115,1017.372;Inherit;False;Dissolve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;7;-1231.447,97.73694;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;10;-911.447,129.7369;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;9;-1071.97,532.788;Inherit;False;6;Dissolve;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-583.2458,491.1511;Inherit;False;Property;_Range;Range;4;0;Create;True;0;0;False;0;False;0;20;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-463.447,209.7369;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;17;-143.447,289.7369;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;19;160.553,321.7369;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-1255.802,801.3579;Inherit;False;1729.92;886.1586;Comment;10;47;45;36;34;32;29;28;27;26;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;464.553,337.7369;Inherit;False;YGradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-1205.802,851.3579;Inherit;False;22;YGradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-915.579,1098.783;Inherit;False;22;YGradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-978.563,1418.976;Inherit;False;22;YGradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;57;-1237.895,1779.921;Inherit;False;1107.907;753.0477;Comment;6;30;31;37;38;42;48;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;28;-894.217,860.1339;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-1187.895,1829.921;Inherit;False;22;YGradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-1167.68,2068.01;Inherit;False;22;YGradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-626.0165,988.949;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-703.198,1422.441;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;36;-326.748,1451.315;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;-881.215,2320.969;Inherit;False;Property;_GlowColor;Glow Color;5;2;[HDR];[Gamma];Create;True;0;0;False;0;False;0,24.32254,42.72251,1;23.96863,0.5019608,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-883.0071,2035.838;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;-355.4269,1143.875;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-624.8169,2147.727;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-58.24722,1296.762;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;288.8425,1274.005;Inherit;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;3;-1286.99,-673.6196;Inherit;False;2044.254;624.23;Comment;9;25;21;20;18;16;13;12;11;8;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-353.9883,2142.897;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;12;-690.714,-623.6196;Inherit;False;Property;_Tiling;Tiling;1;0;Create;True;0;0;False;0;False;5,5;50,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;55;875.2006,-430.5652;Inherit;False;48;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1209.375,-279.3549;Inherit;True;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;False;0;12.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-950.011,-301.4468;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;955.1694,-100.6082;Inherit;False;47;OpacityMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;226.9395,-354.6882;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;-102.136,-492.0311;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-54.97073,-260.7306;Inherit;True;Constant;_Booster;Booster;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-417.6848,-509.8317;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;515.5516,-351.1085;Inherit;True;NoiseOutput;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;13;-712.213,-316.8274;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1257.784,-429.1242;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Shader_Dissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;1;0
WireConnection;5;1;2;4
WireConnection;6;0;5;0
WireConnection;10;0;7;0
WireConnection;14;0;10;2
WireConnection;14;1;9;0
WireConnection;17;0;14;0
WireConnection;17;1;15;0
WireConnection;19;0;17;0
WireConnection;22;0;19;0
WireConnection;28;0;24;0
WireConnection;32;0;28;0
WireConnection;32;1;27;0
WireConnection;29;0;26;0
WireConnection;36;0;29;0
WireConnection;37;0;31;0
WireConnection;37;1;30;0
WireConnection;34;0;32;0
WireConnection;34;1;29;0
WireConnection;42;0;37;0
WireConnection;42;1;38;0
WireConnection;45;0;34;0
WireConnection;45;1;36;0
WireConnection;47;0;45;0
WireConnection;48;0;42;0
WireConnection;11;0;8;0
WireConnection;21;0;20;0
WireConnection;21;1;18;0
WireConnection;20;0;16;0
WireConnection;16;0;12;0
WireConnection;16;1;13;0
WireConnection;25;0;21;0
WireConnection;13;1;11;0
WireConnection;0;2;55;0
WireConnection;0;10;51;0
ASEEND*/
//CHKSM=9D21DF75563BBE2AF0735B8C7AA8C79431840B6F