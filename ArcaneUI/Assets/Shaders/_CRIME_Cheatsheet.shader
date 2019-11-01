Shader "Reference/Unlit/ShaderTraining"
{
    Properties
    { 
        [Header(Number and vector fields)]
        _Float ("Float", Float) = 0
        //[Gamma] _GammaFloat ("Gamma Float", Float) = 0 //gamma float 
        _Int ("Integer", Int) = 15       
        _Vector ("Vector", Vector) = (0,0,0,0)
        [Space(10)]
        [Header(Textures)]
        _Texture2D ("2D Texture", 2D) = "" {}
        _Cube ("Cube Map", Cube) = "" {}
        _Texture3D ("3D Texture", 3D) = "" {}
        [NoScaleOffset]_NoScaleOffsetTexture2D ("2D Texture w/o scale nor offset", 2D) = "" {}  
        [Space(10)]
        [Header(Header Example)] _Prop03 ("Prop1", Float) = 0
        [Space(10)]
        [Header(Ranges and sliders)]
        _Range ("Range 0. - 1.", Range (0, 1)) = 0
        [IntRange] _Alpha ("Range 0 - 255", Range (0, 255)) = 100
        [Header(Nonlinear slider (power of 3))]
        [PowerSlider(3.0)] _PowerSlider ("Range 0 - 1.", Range (0.01, 1)) = 0.08 //Nonlinear slider 
        [Space(10)]
        [Header(Color pickers)]
        [HDR] _HDRColor ("HDR Color", Color) = (0,1,0,1) //HDR color picker
        _Color ("Normal Color", Color) = (1,0,0,1) //Normal color picker
        [Space(10)]
        [Header(Toggle)]
        [Toggle(ENABLE_SOMETHING)] _Something ("Something", Float) = 0 //Will set ENABLE_SOMETHING
        [Header(Single space)]
        [Space] _Prop01 ("Prop01", Float) = 0
        [Space(10)]
        [Header(Unity API Enums)]
        [Enum(UnityEngine.Rendering.BlendMode)] _Src ("Blend enum 1", Float) = 1 //Blend mode selector
        [Enum(UnityEngine.Rendering.BlendMode)] _Dst ("Blend enum 2", Float) = 1 //
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 0        
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Int) = 0 //Cull mode selector
        [Header(Custom Enums)]
        [Enum(One,1,Five,5)] _SubSet ("Subset", Float) = 1 //One will set - 1, Five will set 5
        [KeywordEnum(Red, Yellow, Blue)] _Keyword ("Set Color", Float) = 0  //Each option will set _KEYWORD_RED, _KEYWORD_YELLOW, _KEYWORD_BLUE
        //
        [PerRendererData] _MPBTexture2D ("MPB 2D Texture", 2D) = "" {} //accessible with script
        [HideInInspector] _Hidden ("Hidden Property", Float) = 0
           
    }
    SubShader
    {
        // TODO Tags
        Tags { "RenderType" = "Opaque" "PreviewType" = "Plane" }
        // TODO Queue tag:
        // Background - this render queue is rendered before any others. You’d typically use this for things that really need to be in the background.
        // Geometry (default) - this is used for most objects. Opaque geometry uses this queue.
        // AlphaTest - alpha tested geometry uses this queue. It’s a separate queue from Geometry one since it’s more efficient to render alpha-tested objects after all solid ones are drawn.
        // Transparent - this render queue is rendered after Geometry and AlphaTest, in back-to-front order. Anything alpha-blended (i.e. shaders that don’t write to depth buffer) should go here (glass, particle effects).
        // Overlay - this render queue is meant for overlay effects. Anything rendered last should go here (e.g. lens flares).
        //
        // TODO RenderType tag: (Can you custom values and use Camera.RenderWithShader or Camera.SetReplacementShader to render camera with selected subshader e.g. replacementTag="RenderType=Transparent"
        // Opaque: most of the shaders (Normal, Self Illuminated, Reflective, terrain shaders).
        // Transparent: most semitransparent shaders (Transparent, Particle, Font, terrain additive pass shaders).
        // TransparentCutout: masked transparency shaders (Transparent Cutout, two pass vegetation shaders).
        // Background: Skybox shaders.
        // Overlay: GUITexture, Halo, Flare shaders.
        // TreeOpaque: terrain engine tree bark.
        // TreeTransparentCutout: terrain engine tree leaves.
        // TreeBillboard: terrain engine billboarded trees.
        // Grass: terrain engine grass.
        // GrassBillboard: terrain engine billboarded grass.
        //
        // RequireOptions tag:
        // SoftVegetation: Render this pass only if Soft Vegetation is on in Quality Settings.
        //
        // DisableBatching tag
        // True, False, LODFading
        //
        // ForceNoShadowCasting tag
        //
        // IgnoreProjector tag
        //
        // CanUseSpriteAtlas tag
        //
        // PreviewType tag
        // Sphere, Plane, Skybox
        //
        // TODO Render setup
        // Cull Back | Front | Off
        //
        // ZTest (Less | Greater | LEqual | GEqual | Equal | NotEqual | Always)
        // 
        // ZWrite On | Off
        // 
        // Blend [_Src] [_Dst] // using with enums
        // Blend SrcFactor DstFactor
        // Blend N SrcFactor DstFactor
        // Blending formulas:
        // out_RGB = SrcFactor * SourceRGB + DstFactor * DestinationRGB
        // out_A = SrcAFactor * SourceAlpha + DstAFactor * DestinationAlpha
        // Examples:
        // Blend SrcAlpha OneMinusSrcAlpha  // Traditional transparency
        // Blend One OneMinusSrcAlpha       // Premultiplied transparency
        // Blend One One                    // Additive
        // Blend OneMinusDstColor One       // Soft Additive
        // Blend DstColor Zero              // Multiplicative
        // Blend DstColor SrcColor          // 2x Multiplicative
        // Blending factors:
        // One             The value of one - use this to let either the source or the destination color come through fully.
        // Zero                The value zero - use this to remove either the source or the destination values.
        // SrcColor            The value of this stage is multiplied by the source color value.
        // SrcAlpha            The value of this stage is multiplied by the source alpha value.
        // DstColor            The value of this stage is multiplied by frame buffer source color value.
        // DstAlpha            The value of this stage is multiplied by frame buffer source alpha value.
        // OneMinusSrcColor    The value of this stage is multiplied by (1 - source color).
        // OneMinusSrcAlpha    The value of this stage is multiplied by (1 - source alpha).
        // OneMinusDstColor    The value of this stage is multiplied by (1 - destination color).
        // OneMinusDstAlpha    The value of this stage is multiplied by (1 - destination alpha).
        //
        // Blend N Add | Sub | RevSub | Min | Max | https://docs.unity3d.com/Manual/SL-Blend.html
        // N - is render target
        // Blend SourceBlendMode DestBlendMode, AlphaSourceBlendMode AlphaDestBlendMode
        //
        // ColorMask RGB | A | 0 | any combination of R, G, B, A
        // Offset OffsetFactor, OffsetUnits
        
        LOD 100
        
        //GrabPass { }
        GrabPass { "_BackgroundTexture" }
        
        //UsePass "Shader/Name"
        Pass
        {
            Cull Front
            Color (0, 0, 0, 1)
        }
        
        Pass
        {
            Name "Pass Name"
            // TODO Tags - same as above
            // TODO Render setup - Same as above
            Cull [_CullMode]
            
            CGPROGRAM
            #define PI 3.1415
            #define BLUE float4(0., 0., 1., 1.)
            #define YELLOW float4(1., 1., 0., 1.)
            // define with parameters 
            #define A(b,c) b ## c
            // A(Test,OfDefine) will be substituted by - TestOfDefine
            
            // Definition of vertex program
            #pragma vertex vert
            
            // Definition of pixel program
            #pragma fragment frag
            
            // make fog work
            #pragma multi_compile_fog
            
            #pragma multi_compile __ ENABLE_SOMETHING
            #pragma shader_feature _KEYWORD_RED _KEYWORD_YELLOW _KEYWORD_BLUE 
            
            #pragma target 3.5 
            // https://docs.unity3d.com/Manual/SL-ShaderCompileTargets.html
            
            // The broad #pragma target directives are shorthands for the requirements above, and they correspond to:
            // 2.5: derivatives
            // 3.0: 2.5 + interpolators10 + samplelod + fragcoord
            // 3.5: 3.0 + interpolators15 + mrt4 + integers + 2darray + instancing
            // 4.0: 3.5 + geometry
            // 5.0: 4.0 + compute + randomwrite + tesshw + tessellation
            // 4.5: 3.5 + compute + randomwrite
            // 4.6: 4.0 + cubearray + tesshw + tessellation

            #include "UnityCG.cginc"

            struct appdata
            {
                // intent of input and output variables have to be indecatet by sematics. 
                // https://docs.microsoft.com/en-us/windows/win32/direct3dhlsl/dx-graphics-hlsl-semantics              
                fixed color : COLOR;
                float3 normal : NORMAL;
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;  
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                half3 worldNormal : TEXCOORD2;
                UNITY_FOG_COORDS(3) //put fog information into TEXCOORD3
                float4 grabPos : TEXCOORD4;   
                float4 vertex : SV_POSITION;                
            };

            //Samplers
            sampler2D _Texture2D;
            sampler3D _Texture3D;
            samplerCUBE _Cube;
            
            //variables
            float4 _Texture2D_ST;
            float _Float; //32 bits
            fixed _Fixed; //11 bits -2 to +2
            half _Half; //16 bits -60000 to +60000
            int _Int; //_Int not work D3D9 and OpenGL ES 2.0 (integers are emulated), D3D11, OGLES3, Metal, Vulkan have a proper support
            
            float2 f2;
            float3 f3;
            float4 f4;
            
            half2x2 m1 = half2x2(1,2,3,4);
            //m1[0].x m1[0].y
            //m1[1].x m1[1].y
            
            
            fixed3x3 m2;
            //m2[0].x m2[0].y m2[0].z
            //m2[1].x m2[1].y m2[2].z
            //m2[2].x m2[2].y m2[2].z
            
            float4x4 m3;
            //m3[0].x m3[0].y m3[0].z m3[0].w
            //m3[1].x m3[1].y m3[1].z m3[1].w
            //m3[2].x m3[2].y m3[2].z m3[2].w
            //m3[3].x m3[3].y m3[3].z m3[3].w
                       
            //Buit-in shader veriables
            //Built-in light color variable 
            float4 _LightColor0;
            
            float _PowerSlider;
            
            sampler2D _BackgroundTexture;
                        
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // using _TextureName_ST, calculating texture transformations
                o.uv = TRANSFORM_TEX(v.uv, _Texture2D);        
                // calculationg word position of the vertex
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                // calculating world norval of the vector
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                // computing grab screen position, needed for grab pass
                o.grabPos = ComputeGrabScreenPos(o.vertex);
                // FOG macro
                UNITY_TRANSFER_FOG(o,o.vertex);
                // pass all the stuff to the fragment function
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_Texture2D, i.uv);
                
                // using shader feature
                #if ENABLE_SOMETHING
                #if _KEYWORD_YELLOW 
                // using define
                col = YELLOW;
                #elif _KEYWORD_RED
                col = fixed4(1., 0., 0., 1.); 
                #elif _KEYWORD_BLUE
                col = BLUE;
                #endif
                #endif
                
                //swizzling
                float4 a = float4(1, 2, 3, 4).zxwy;
                //a.x = 3, a.y = 1, a.z = 4, a.w = 2
                
                // TODO Built-in variables
                //
                // unity_ObjectToWorld Current model matrix.
                // unity_WorldToObject Inverse of current world matrix.
                // _WorldSpaceCameraPos    float3 World space position of the camera.
                // _ScreenParams   float4 x is the width of the camera’s target texture in pixels, y is the height of the camera’s target texture in pixels, z is 1.0 + 1.0/width and w is 1.0 + 1.0/height.
                // _ZBufferParams  float4 Used to linearize Z buffer values. x is (1-far/near), y is (far/near), z is (x/far) and w is (y/far).
                // unity_OrthoParams   float4 x is orthographic camera’s width, y is orthographic camera’s height, z is unused and w is 1.0 when camera is orthographic, 0.0 when perspective.
                // unity_CameraProjection  float4x4   Camera’s projection matrix.
                // unity_CameraInvProjection   float4x4   Inverse of camera’s projection matrix.
                // unity_CameraWorldClipPlanes[6]  float4 Camera frustum plane world space equations, in this order: left, right, bottom, top, near, far.
                // _Time   float4 Time since level load (t/20, t, t*2, t*3), use to animate things inside the shaders.
                // _SinTime    float4 Sine of time: (t/8, t/4, t/2, t).
                // _CosTime    float4 Cosine of time: (t/8, t/4, t/2, t).
                // unity_DeltaTime float4 Delta time: (dt, 1/dt, smoothDt, 1/smoothDt).
            
                // _LightColor0 (declared in Lighting.cginc)   fixed4 Light color.
                // _WorldSpaceLightPos0    float4 Directional lights: (world space direction, 0). Other lights: (world space position, 1).
                // _LightMatrix0 (declared in AutoLight.cginc) float4x4   World-to-light matrix. Used to sample cookie & attenuation textures.
                // unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0 float4 (ForwardBase pass only) world space positions of first four non-important point lights.
                // unity_4LightAtten0  float4 (ForwardBase pass only) attenuation factors of first four non-important point lights.
                // unity_LightColor    half4[4]   (ForwardBase pass only) colors of of first four non-important point lights.
                // unity_WorldToShadow float4x4[4]    World-to-shadow matrices. One matrix for spot lights, up to four for directional light cascades.
                
                
                //calculating world view direction vector
                half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                //reflect view direction vector (needed for cube map sampling)
                half3 worldRefl = reflect(-worldViewDir, i.worldNormal);
                
                // sample Unity's skybox
                // half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);               
                // unity cube map sampling
                half4 cube = texCUBE(_Cube, worldRefl);
                half3 skyColor = DecodeHDR(cube, unity_SpecCube0_HDR);
                
                // 3d texture sumpling
                half3 texture3d = tex3D(_Texture3D, i.worldPos*.2+_Time.x);
                
                // grab texture sampling
                half4 bgcolor = tex2Dproj(_BackgroundTexture, i.grabPos);
                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                
                return col;
            }
            ENDCG
        }
    }
    Fallback "Diffuse" //if none of subshaders can run on this hardware, try using the ones from another shader
}