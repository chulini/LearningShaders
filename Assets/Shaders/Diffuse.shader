// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Diffuse" {
	Properties {
		_Color("Color", Color) = (1,1,1,1)
		_Texture("Main Texture", 2D) = "gray"
	}
	SubShader {
		Tags{"Rendertype" = "opaque"}

		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc" // for UnityObjectToWorldNormal
			#include "UnityLightingCommon.cginc" // for _LightColor0

			struct appdata_t {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord: TEXCOORD0;
			};
			struct v2f {
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float2 texcoord: TEXCOORD0;
			};


			float4 _Color;
			sampler2D _Texture;
			v2f vert(appdata_t v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); //convert vertex position to worldspace position
				o.texcoord = v.texcoord;
				o.normal =  mul(float4(v.normal,0.0), unity_ObjectToWorld).xyz; //convert normals to worldspace
				return o;
			}
			fixed4 frag(v2f i) : COLOR{
				fixed4 c = tex2D(_Texture,i.texcoord);
				float3 normalDirection = normalize(i.normal);
				float3 lightDirection = normalize(-_WorldSpaceLightPos0.xyz);
				float3 diffuse = _LightColor0.rgb*max(0.0, dot(lightDirection,normalDirection));

				return c*_Color*float4(diffuse,1.0);
			}
			ENDCG
		}
	}
}
