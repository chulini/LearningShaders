// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/DiffuseRim" {
	Properties {
		_Color("Color", Color) = (1,1,1,1)
		_Texture("Main Texture", 2D) = "gray"{}
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimPower("Rim Power", Range(0.5,30.0)) = 3.0
	}
	SubShader {
		Tags{"Rendertype" = "opaque"}

		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma	fragment frag
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc" // for _LightColor0

			struct appdata_t {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv: TEXCOORD0;
				float3 viewDir : TEXCOORD1;
			};
			struct v2f {
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv: TEXCOORD0;
				float3 viewDir : TEXCOORD1;
			};


			float4 _Color;
			float4 _RimColor;
			float _RimPower;

			sampler2D _Texture;
			v2f vert(appdata_t v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); //convert vertex position to worldspace position
				o.uv = v.uv;
				o.normal =  mul(float4(v.normal,0.0), unity_ObjectToWorld).xyz; //convert normals to worldspace
				o.viewDir = normalize(_WorldSpaceCameraPos - mul((float3x3)unity_ObjectToWorld, v.vertex.xyz)); //convert viewDirection to worldspace
				return o;
			}
			fixed4 frag(v2f i) : COLOR{
				fixed4 c = tex2D(_Texture,i.uv);
				float3 normalDirection = normalize(i.normal);
				float3 lightDirection = normalize(-_WorldSpaceLightPos0.xyz);
				float3 diffuse = _LightColor0.rgb*max(0.0, dot(lightDirection,normalDirection));
				half rim = 1.0 - saturate(dot(normalize(i.viewDir), normalDirection));
				return c*_Color*float4(diffuse,1.0)+ _RimColor*pow(rim, _RimPower);
			}
			ENDCG
		}
	}
}
