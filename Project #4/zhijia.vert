#version 330 compatibility

out vec2  vST;
out vec3  vMCposition;
out vec3  vECposition;
out vec3  normal;
out vec4  newVertexPos;

uniform float uA; 
uniform float uB;
uniform float uC;
uniform float uD;
const float PI = 3.14159265;

uniform float uLightX;
uniform float uLightY;
uniform float uLightZ;
vec3 eyeLightPosition= vec3( uLightX, uLightY, uLightZ );

flat out vec3 vNs;
flat out vec3 vLs;
flat out vec3 vEs;
	 
void
main( )
{
	vMCposition = gl_Vertex.xyz;
	vECposition = ( gl_ModelViewMatrix * gl_Vertex ).xyz;
	vST = gl_MultiTexCoord0.st;

	float x = vMCposition.x;
        float y = vMCposition.y;
	
        float r = x*x + y*y; 
        float drdx = 2.*x; 
        float dzdx = -uA*sin(2.*PI*uB*r+uC) * 2.*PI*uB*drdx * exp(-uD*r) + uA*cos(2.*PI*uB*r+uC) * exp(-uD*r) * -uD*drdx;
        float drdy = 2.*y; 
        float dzdy = -uA*sin(2.*PI*uB*r+uC) * 2.*PI*uB*drdy * exp(-uD*r) + uA*cos(2.*PI*uB*r+uC) * exp(-uD*r) * -uD*drdy;
        vec3 Tx = vec3(1., 0., dzdx ); 
        vec3 Ty = vec3(0., 1., dzdy ); 
	normal = normalize(cross(Tx, Ty)); 

	vNs = normalize( gl_NormalMatrix * normal );
			
	vLs = eyeLightPosition - vECposition.xyz;
	
	vEs = vec3( 0., 0., 0. ) - vECposition.xyz;	

	float z = uA*cos(2.*PI*uB*r+uC) * exp(-uD*r);
	vec4 newVertexPos = gl_Vertex;
	newVertexPos.z = newVertexPos.z + z;

	gl_Position = gl_ModelViewProjectionMatrix * newVertexPos;
}
