varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying float v_vZ;
varying float v_vLayers;

uniform float alpha;
uniform float amount;
uniform float time;

void main()
{
	// Cancel alphas	
	vec2 uv = v_vTexcoord;
	uv.x = uv.x + cos(uv.y * ( amount * 10. ) + time ) * amount * .01;
	uv.y = uv.y + sin(uv.x * ( amount * 10. ) + time ) * amount * .01;
	
	vec4 col = v_vColour * texture2D( gm_BaseTexture, uv );
	if ( col.r < v_vZ/255. ) col.a = 0.;

	float alp = alpha;
	gl_FragColor = vec4(.5, .5, .5, col.a * alp * 0.1);
}