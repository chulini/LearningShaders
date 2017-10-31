// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ScreenSpaceImageOutline"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_OutlineVal("Outline value", Range(0., 2.)) = 1.
		_OutlineCol("Outline color", color) = (1., 1., 1., 1.)
	}
	SubShader
	{
		Tags { "Queue"="Geometry" "RenderType"="Opaque" }
		LOD 100

		//Outline
		Pass{
			Cull Front

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			struct v2f {
				float4 pos : SV_POSITION;
			};

			float _OutlineVal;

			v2f vert(appdata_base v) {
				v2f o;

				// Convert vertex to clip space
				o.pos = UnityObjectToClipPos(v.vertex);

				// Convert normal to view space (camera space)
				float3 normal = mul((float3x3) UNITY_MATRIX_IT_MV, v.normal);

				// Compute normal value in clip space
				normal.x *= UNITY_MATRIX_P[0][0];
				normal.y *= UNITY_MATRIX_P[1][1];

				// Scale the model depending the previous computed normal and outline value
				o.pos.xy += _OutlineVal * normal.xy;
				return o;
			}

			fixed4 _OutlineCol;
			fixed4 frag(v2f i) : SV_Target{
				return _OutlineCol;
			}

			ENDCG
		}

		//ScreenSpaceImage
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 scrPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				o.scrPos = ComputeScreenPos(o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture using screen size
				float2 uv2 = (i.scrPos.xy / i.scrPos.w)*_MainTex_ST;
				fixed4 col = tex2D(_MainTex, uv2);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}


	}
}
