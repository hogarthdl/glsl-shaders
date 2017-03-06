#version 330 compatibility

out vec4  vColor;
out vec2  vST;
out float vLightIntensity;
out vec3  vMCposition;
out float Z;

const vec3 LIGHTPOS = vec3( -2., 0., 10. );

void
main( )
{
	vST = gl_MultiTexCoord0.st;
	vec3 tnorm = normalize( gl_NormalMatrix * gl_Normal );
	vec3 ECposition = vec3( gl_ModelViewMatrix * gl_Vertex );//.xyz;
	Z = ECposition.z;
	vLightIntensity  = abs( dot( normalize(LIGHTPOS - ECposition), tnorm ) );

	vColor = gl_Color;
	vMCposition = gl_Vertex.xyz;
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
