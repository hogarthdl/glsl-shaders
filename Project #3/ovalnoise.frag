#version 330 compatibility

in vec2  vST;
in vec4  vColor;
in float vLightIntensity;
in vec3  vMCposition;
in float Z;

uniform bool uUseChromaDepth;
uniform float uAd;
uniform float uBd;
uniform float uNoiseAmp;
uniform float uNoiseFreq;
uniform float uAlpha;
uniform float uTol;
uniform float Blend;

uniform float uChromaRed;
uniform float uChromaBlue;

uniform sampler3D Noise3; 
	
//const vec4 WHITE = vec4( 1., 1., 1., 1. );
//const vec4 ORANGE = vec4(1., .5, 0., 1. );

const vec3 WHITE3 = vec3( 1., 1., 1.);
const vec3 GREEN = vec3(.2, .8, .2);

vec3
	Rainbow( float t ){
		t = clamp( t, 0., 1. );

		float r = 1.;
		float g = 0.0;
		float b = 1.  -  6. * ( t - (5./6.) );

        if( t <= (5./6.) )
        {
                r = 6. * ( t - (4./6.) );
                g = 0.;
                b = 1.;
        }

        if( t <= (4./6.) )
        {
                r = 0.;
                g = 1.  -  6. * ( t - (3./6.) );
                b = 1.;
        }

        if( t <= (3./6.) )
        {
                r = 0.;
                g = 1.;
                b = 6. * ( t - (2./6.) );
        }

        if( t <= (2./6.) )
        {
                r = 1.  -  6. * ( t - (1./6.) );
                g = 1.;
                b = 0.;
        }

        if( t <= (1./6.) )
        {
                r = 1.;
                g = 6. * t;
        }

		return vec3( r, g, b );
	}
	
void
main( )
{	
	vec3 stp = uNoiseFreq * vMCposition; 
	vec4  nv  = texture( Noise3, stp );
	float n = nv.r + nv.g + nv.b + nv.a;	// 1. -> 3.
	n = n - 2.;				// -1. -> 1.
	float delta = uNoiseAmp * n;

	float u = vST.s;
	float v = vST.t;
	float up = 2. * u;
	float vp = 2. * v;
	float numinu = floor( up / (2.*uAd) ); 
	float numinv = floor( vp / (2.*uBd) ); 
	
	float uc = numinu *2.* uAd + uAd;
	float vc = numinv *2.* uBd + uBd;
	float du = up - uc;
	float dv = vp - vc;

	float oldrad = sqrt( du*du + dv*dv);
	float newrad = oldrad + delta;
	float factor = newrad / oldrad;
		
	du *= factor;
	dv *= factor;

	float d = ( du * du ) / (uAd * uAd) + ( dv * dv ) / (uBd * uBd);
	
	gl_FragColor = vColor;
	vec3 TheColor = vec3( 1., 1., 1.);	
   
    float opacity = 1.;
		
	if( abs(d -1.)<= uTol)
	{
		//float f = fract( d );
		float t = smoothstep( 1. - uTol, 1. + uTol, d);
		//gl_FragColor = mix( ORANGE ,WHITE, t );
		TheColor = mix( GREEN ,WHITE3, t );
	}
	if(d <= 1.-uTol)
	{		
		//gl_FragColor = ORANGE;
		TheColor = GREEN;
	}
	if (d >= 1.+uTol){
		//gl_FragColor = WHITE;
		//TheColor = WHITE3;
		//gl_FragColor = vec4(TheColor, uAlpha );
		opacity = uAlpha;
		if (opacity == 0.){
			discard;
			//gl_FragColor.a = 0;
		}
		
	}
	if( uUseChromaDepth == true)
	{
		float t = (2./3.) * ( Z - uChromaRed ) / ( uChromaBlue - uChromaRed );
		t = clamp( t, 0., 2./3. );
		vec3 rainbowColor = Rainbow( t );

		//TheColor = mix(TheColor, rainbowColor, Blend);
		//gl_FragColor = vec4( vLightIntensity*TheColor, uAlpha );
		gl_FragColor = vec4( vLightIntensity*rainbowColor, opacity );
	}else{
		gl_FragColor = vec4( vLightIntensity*TheColor, opacity );
		
	}
	//gl_FragColor.rainbowColor *= vLightIntensity;	// apply lighting model
}