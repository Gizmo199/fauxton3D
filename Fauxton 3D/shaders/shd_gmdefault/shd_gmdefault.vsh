/* 

	- Default Render Shader - 
	
	This all this shader does is clip alpha values below 0.05.
	This shader is just a stripped down version of GM's 
	default shader

*/
attribute vec3 in_Position;                  
attribute vec4 in_Colour;                    
attribute vec2 in_TextureCoord;              

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 object_space_pos = vec4( in_Position, 1.0);	
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}
