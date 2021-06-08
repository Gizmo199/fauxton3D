/* 

	- Default Render Shader - 
	
	This all this shader does is clip alpha values below 0.05.
	This shader is just a stripped down version of GM's 
	default shader

*/
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 col = texture2D( gm_BaseTexture, v_vTexcoord );
	if ( col.a < 0.05 ) { discard; }

    gl_FragColor = col * v_vColour;
}