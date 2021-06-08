/* 

	- Grass sway Shader - 
	
	This shader will make models sway based on their z position and
	a 'movement' input!

*/
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 col = texture2D( gm_BaseTexture, v_vTexcoord );
	if ( col.a < 0.05 ) discard;
    gl_FragColor = col * v_vColour;
}
