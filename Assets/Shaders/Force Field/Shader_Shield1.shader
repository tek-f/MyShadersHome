// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader_Shield1"
{
	Properties
	{
		_hitPosition("hitPosition", Vector) = (0,0,0,0)
		_hitSize("hitSize", Float) = 0.5
		_HitColor("Hit Color", Color) = (1,0,0,1)
		_UnhitColor("Unhit Color", Color) = (0,0,0,1)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float3 _hitPosition;
		uniform float _hitSize;
		uniform float4 _HitColor;
		uniform float4 _UnhitColor;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			o.Albedo = ( distance( ase_vertex3Pos , _hitPosition ) < _hitSize ? _HitColor : _UnhitColor ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18600
403;73;962;650;1545.842;370.8673;1.911871;True;False
Node;AmplifyShaderEditor.CommentaryNode;3;-1006.674,-122.2704;Inherit;False;977.5243;617.103;Handles effect when the force field is collided with by an object;7;2;5;4;6;7;8;9;Hit Flare Effect;0.6603774,0,0,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;2;-956.6737,-72.27036;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;5;-950.251,81.52162;Inherit;False;Property;_hitPosition;hitPosition;0;0;Create;True;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;4;-686.9304,-65.08717;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-683.0362,45.07742;Inherit;False;Property;_hitSize;hitSize;1;0;Create;True;0;0;False;0;False;0.5;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-746.3646,129.201;Inherit;False;Property;_HitColor;Hit Color;2;0;Create;True;0;0;False;0;False;1,0,0,1;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-736.9386,316.0829;Inherit;False;Property;_UnhitColor;Unhit Color;3;0;Create;True;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;1;-16,-128;Inherit;False;305;521;Comment;1;0; Output Node;1,1,1,1;0;0
Node;AmplifyShaderEditor.Compare;6;-186.5786,4.716493;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;48,-80;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Shader_Shield1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;4;1;5;0
WireConnection;6;0;4;0
WireConnection;6;1;7;0
WireConnection;6;2;8;0
WireConnection;6;3;9;0
WireConnection;0;0;6;0
ASEEND*/
//CHKSM=7CB366C905DBA2EF512D8C9F8CD192E646A78080