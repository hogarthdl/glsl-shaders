#version 330 compatibility

in vec2  vST;
in vec3  vMCposition;
in vec3  vECposition;
in vec3  normal;

flat in vec3 vNs;
flat in vec3 vLs;
flat in vec3 vEs;

uniform float uNoiseAmp;
uniform float uNoiseFreq;
uniform float uKa;
uniform float uKd;
uniform float uKs;
uniform float uShininess;
uniform float uLightX;
uniform float uLightY;
uniform float uLightZ;
uniform sampler2D Noise2; 
uniform vec4 uColor;
uniform vec4 uSpecularColor;


vec3
RotateNormal( float angx, float angy, vec3 n )
{
        float cx = cos( angx );
        float sx = sin( angx );
        float cy = cos( angy );
        float sy = sin( angy );

        // rotate about x:
        float yp =  n.y*cx - n.z*sx;    // y'
        n.z      =  n.y*sx + n.z*cx;    // z'
        n.y      =  yp;
        // n.x      =  n.x;

        // rotate about y:
        float xp =  n.x*cy + n.z*sy;    // x'
        n.z      = -n.x*sy + n.z*cy;    // z'
        n.x      =  xp;
        // n.y      =  n.y;

        return normalize( n );
}

void
main( )
{	
	vec4 nvx = texture( Noise3, uNoiseFreq*vMCposition );
	float angx = nvx.r + nvx.g + nvx.b + nvx.a  -  2.;
	angx *= uNoiseAmp;
        vec4 nvy = texture( Noise3, uNoiseFreq*vec3(vMCposition.xy,vMCposition.z+0.5) );
	float angy = nvy.r + nvy.g + nvy.b + nvy.a  -  2.;
	angy *= uNoiseAmp;
	
	vec3 thisNormal = RotateNormal(angx, angy, normal);
	
	//move the normal with the rotatation.
	thisNormal = normalize( gl_NormalMatrix * thisNormal);

	// Old way
	//float LightIntensity  = abs( dot( normalize(vec3( uLightX, uLightY, uLightZ )), thisNormal ) );
	//     if( LightIntensity < 0.1 )
	//	    LightIntensity = 0.1;
        //gl_FragColor = vec4( LightIntensity*uColor.rgb, uColor.a );
	
	
	vec3 Light;
	vec3 Eye;
	
	//one bug is that I recalculate the normal instead of using "thisNormal"
	Light = normalize(vLs);
	Eye = normalize(vEs);
	
	vec4 ambient = uKa * uColor;

	float d = max( dot(thisNormal ,Light), 0. );
	vec4 diffuse = uKd * d * uColor;

	float s = 0.;
	vec3 ref = normalize( 2. * thisNormal  * dot(thisNormal, Light) - Light );
	s = pow( max( dot(Eye,ref),0. ), uShininess );
	vec4 specular = uKs * s * uSpecularColor;
	
	//Another bug is that I use the LightIntensity product the ads in the following line of code, 
	//The consequence is that changing ka produce the same outcome as I changing the Kd.
	gl_FragColor = vec4( (ambient.rgb + diffuse.rgb + specular.rgb), uColor.a );
	
}
