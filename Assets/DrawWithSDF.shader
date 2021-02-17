Shader "Unlit/DrawWithSDF"
{
    Properties
    {
        _MainTex ("SDF Texture", 2D) = "white" {}
        _ShowTex("ShowTex",2D) = "white" {}
        _Cutoff ("Base Alpha cutoff", Range (0,.9)) = .5
        [Toggle] _OutLine ("OutLine?", Float) = 1
        _OutLineMaxValue("OutLineMaxValue1",float) = 0.6
        _OutLineMinValue("OutLineMinValue0",float) = 0.5
        _OutLineColor1("OutLineColor1",Color) = (1,1,1,1)
        _OutLineColor0("OutLineColor0",Color) = (1,1,1,1)
        [Toggle] _Soft_Edges ("Soft_Edges?", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        ZWrite on
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            // #pragma shader_feature _OUTLINE_ON

            #include "UnityCG.cginc"
            fixed _Cutoff;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _ShowTex;
    
            float _OutLine;
            float _OutLineMinValue;
            float _OutLineMaxValue;
            float4 _OutLineColor0;
            float4 _OutLineColor1;
            float _Soft_Edges;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 sdfColor = tex2D(_MainTex, i.uv);
                fixed4 baseColor = tex2D(_ShowTex, i.uv);
                float distAlphaMask = sdfColor.a;
                //添加outLine
                if(_OutLine == 1 && distAlphaMask >= _OutLineMinValue && distAlphaMask <= _OutLineMaxValue)
                {
                    //外圈混合
                    if(distAlphaMask<=_Cutoff)
                    baseColor = lerp(_OutLineColor0,_OutLineColor1,smoothstep(_OutLineMinValue,_Cutoff,distAlphaMask));
                    else//内圈混合(光滑)
                    baseColor = lerp(_OutLineColor1,baseColor,smoothstep(_Cutoff,_OutLineMaxValue,distAlphaMask));
                    //outline 往外扩
                    distAlphaMask+=(distAlphaMask-_OutLineMinValue)/2;
                }
                //soft融合处理
                if(_Soft_Edges == 1)
                baseColor.a *= smoothstep(_OutLineMinValue,_OutLineMaxValue,distAlphaMask);
                else
                baseColor.a = distAlphaMask>=_Cutoff;
                return baseColor;
            }
            ENDCG
        }
    }
}
