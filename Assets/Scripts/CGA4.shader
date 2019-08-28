Shader "Hidden/CGAHalftone" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}	
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
 
			#include "UnityCG.cginc"
 
			uniform sampler2D _MainTex;

			float _ObjectColor;
			float thresBound;

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			float4 frag(v2f i) : COLOR {
				float4 c = tex2D(_MainTex, i.uv);
				float lum = 1-(c.r*0.299 + c.g*0.587 + c.b * 0.114);
				
				//float4 output_color = float4(0.3,1,1,1);
				//if(lum < 0.4) {
				//	output_color = float4(1,0.3,1,1);
				//}
				float4 output_color = float4(1,1,1,1);
				float x = i.pos.x;
				float y = i.pos.y;
				uint b_size = 3;
				uint newX = x/b_size;
				uint newY = y/b_size;
				if(lum >= .9 * thresBound)
					return float4(0,0,0,1);
				else{
					float neibour = .004;
					float neiboutx = neibour*768.0/1024.0;
					float4 c1 = tex2D(_MainTex, i.uv + float2(neiboutx, 0));
					float4 c2 = tex2D(_MainTex, i.uv + float2(-neiboutx, 0));
					float4 c3 = tex2D(_MainTex, i.uv + float2(0, neibour));
					float4 c4 = tex2D(_MainTex, i.uv + float2(0, -neibour));
					if(c1.r == 0 || c2.r == 0 || c3.r==0 || c4.r==0)
						return float4(1,1,1,1);
				}
				//else return float4(1,1,1,1);
				if(lum >= .7 * thresBound)
				{
					if(newX%2 == newY%2)
					{
						if(((newX%4 == 0) || newY%4 == 2) && (newX/2) % 2 == (newY/2) % 2)
							output_color = float4(0,0,0,1);
						else output_color = float4(1,1,1,1);
					}
					else
						output_color = float4(0,0,0,1);
					//if((newX-2)%8 ==0 && newY % 8 ==0)
					//	output_color = float4(0,0,0,1);
				}
				else if(lum >= .6 * thresBound)
				{
					if(newX%2 == newY%2)
						output_color = float4(0,0,0,1);
					else
						output_color = float4(1,1,1,1);
				}
				else if(lum >= .4 * thresBound)
				{
					if(newX%2 == newY%2)
					{
						if(((newX%4 == 0) || newY%4 == 2) && (newX%12!=0 || newY % 16 !=0) && (newX/2) % 2 == (newY/2) % 2)
							output_color = float4(1,1,1,1);
						else output_color = float4(0,0,0,1);
					}
					else
						output_color = float4(1,1,1,1);
					
				}
				else if (lum>=.2 * thresBound)
				{
					if(newX%2 == 0 && newY%2 == 0)
						output_color = float4(0,0,0,1);
				}
				else if(lum > .15 * thresBound)
				{
					if(newX%4 == 0 && newY%4 == 0)
						output_color = float4(0,0,0,1);
				}
				
				return output_color;
				
			}
			ENDCG
		}
	}
}