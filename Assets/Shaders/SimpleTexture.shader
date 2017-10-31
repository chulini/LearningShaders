Shader "Custom/SimpleTexture" {
	Properties {
		_Texture("Main Texture", 2D) = "gray"
	}
	SubShader {
		Tags{"Rendertype" = "opaque"}

		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma	fragment frag
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord: TEXCOORD0;
			};
			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord: TEXCOORD0;
			};
			sampler2D _Texture;
			v2f vert(appdata_t v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}
			fixed4 frag(v2f i) : COLOR{
				fixed4 c = tex2D(_Texture,i.texcoord);
				return c;
			}
			ENDCG
		}
	}
	
}
