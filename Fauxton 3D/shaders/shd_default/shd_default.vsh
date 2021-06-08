/* 

	- Default Render Shader - 
	
	This all this shader does is clip alpha values below 0.05.
	This shader is just a stripped down version of GM's 
	default shader

*/
attribute vec3 in_Position;                  
attribute vec4 in_Colour;                    
attribute vec2 in_TextureCoord;              
attribute vec3 in_Normal;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying vec3 v_vWorldPosition;

void main()
{
	vec4 object_norm = vec4(in_Normal, 0.);
    vec4 object_space_pos = vec4( in_Position, 1.0);
	vec3 wdPos = ( gm_Matrices[MATRIX_WORLD] * object_space_pos ).xyz;
	vec3 wdNrm = normalize(gm_Matrices[MATRIX_WORLD] * object_norm).xyz;
	
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
		
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
	v_vNormal = wdNrm;
	v_vWorldPosition = wdPos;
}
