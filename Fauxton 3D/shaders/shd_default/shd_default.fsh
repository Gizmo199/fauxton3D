/* 

	- Default Render Shader - 
	
	This all this shader does is clip alpha values below 0.05.
	This shader is just a stripped down version of GM's 
	default shader

*/
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying vec3 v_vWorldPosition;

uniform vec3 ambient_color;
uniform vec3 sun_color;
uniform vec3 sun_pos;
uniform float sun_intensity;

uniform float lightTotal;
uniform vec3 lightPos[64];
uniform vec3 lightColor[64];
uniform float lightRange[64];
uniform float lightIsCone[64];
uniform vec3 lightDirection[64];
uniform float lightCutoffAngle[64];

// Pointlights
float evaluate_point_light(vec3 world_position, vec3 world_normal, vec3 light_position, float light_radius)
{
	// Light position
	vec3 lightIncome = world_position - light_position;
	
	// Light magnitude
	float lightDist = length(lightIncome);
	
	// Send light back
	lightIncome = normalize(-lightIncome);
	float lDiff = max(dot(world_normal, lightIncome), 0.);
	
	// Attenuation
	float lightAtt = clamp( 1. - lightDist*lightDist/( light_radius*light_radius ), 0., 1. ); 
	lightAtt *= lightAtt;
	
	// Return attenuation mulitplied by the light sent back
	return lightAtt * lDiff;
}

// Spotlights
float evaluate_cone_light(vec3 world_position, vec3 world_normal, vec3 light_direction, float cutoff, vec3 light_position, float light_radius)
{
	// Light position
	vec3 lightIncome = world_position - light_position;
	
	// Light magnitude
	float lightDist = length(lightIncome);
	
	// Send light back
	lightIncome = normalize(-lightIncome);
	float lDiff = max(dot(world_normal, lightIncome), 0.);
	
	// Attenuation
	float cAng = max(dot(lightIncome, -normalize(light_direction)), 0.);
	float lightAtt = 0.;
	
	// Cut off attenuation for spot lights
	if ( cAng > cutoff )
	{
		lightAtt = max(( light_radius - lightDist ) / light_radius, 0.);
	}
	
	// Return attenuation by returning light
	return lightAtt * lDiff;
}

void main()
{
	vec4 col = texture2D( gm_BaseTexture, v_vTexcoord ) * v_vColour;	
	
	// Alpha
	if ( col.a < 0.05 ) { discard; }
	
	// Diffuse and ambient
	float nDot = max(dot(v_vNormal, normalize(sun_pos)), 0.);
	col.rgb *= ( ambient_color ) + ( sun_color * sun_intensity ) * nDot;
	
	// Spot & Point lights
	if ( lightTotal > 0. ){
		float eval = 0.;
		for ( int i=0; i<64; i++ )
		{
			if ( float(i) > lightTotal ) { break; }
			
			if ( lightIsCone[i] == 1. ) {
				eval = evaluate_cone_light(v_vWorldPosition, v_vNormal, lightDirection[i], lightCutoffAngle[i], lightPos[i], lightRange[i]);
			} else {
				eval = evaluate_point_light(v_vWorldPosition, v_vNormal, lightPos[i], lightRange[i]);
			}
			col += eval * vec4( min( lightColor[i], 1. ), 1. );
		}
	}
	
	// Final color
	gl_FragColor = min( col, vec4(1.) );
}