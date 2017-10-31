﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SolidColor" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags {"RenderType" = "opaque"}
		LOD 100
		Pass{
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				struct appdata_t {
					float4 vertex : POSITION;
				};
				struct v2f {
					float4 vertex : SV_POSITION;

				};
				fixed4 _Color;
				v2f vert(appdata_t v){
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					return o;
				}
				fixed4 frag(v2f i) : COLOR{
					fixed4 c = _Color;
					return c;
				}

			ENDCG
		}
	}
	
}
