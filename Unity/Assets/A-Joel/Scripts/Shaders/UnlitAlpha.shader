Shader "Ad-Dispatch/UnlitAlpha" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	Category {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100
		
		Blend SrcAlpha OneMinusSrcAlpha
		//AlphaTest Greater .01
		ColorMask RGBA
		Cull Off
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		
		BindChannels
		{
			Bind "Color", color
			Bind "Vertex", vertex
			Bind "TexCoord", texcoord
		}
		
		SubShader
		{
			Pass
			{
				SetTexture[_MainTex]
				{
					constantColor[_Color]
					combine constant * primary
				}
				SetTexture[_MainTex]
				{
					combine texture * previous// DOUBLE
				}
			}
		} // end subshader
	} 
	FallBack "Transparent/Diffuse"
}
