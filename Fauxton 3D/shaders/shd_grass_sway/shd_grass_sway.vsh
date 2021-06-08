/* 

	- Grass sway Shader - 
	
	This shader will make models sway based on their z position and
	a 'movement' input!

*/
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float time;

void main()
{

    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
	
	object_space_pos.x += ( cos(time+object_space_pos.y/2.) * object_space_pos.z ) * 0.3;
	object_space_pos.y += ( sin(time+object_space_pos.x/2.) * -object_space_pos.z ) * 0.3;
	
	
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}
