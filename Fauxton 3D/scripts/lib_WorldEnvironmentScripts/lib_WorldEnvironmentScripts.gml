global.__FWORLDENV = {
	sun_color : c_white,
	sun_intensity : 0,
	sun_pos : [0,0,0],
	
	ambient_color : c_white
}
#macro fauxton_world_environment global.__FWORLDENV

function fauxton_world_set_default_environment()
{
	fauxton_world_environment.sun_color = c_white;
	fauxton_world_environment.sun_intensity = 0;
	fauxton_world_environment.ambient_color = c_white;
	fauxton_world_environment.sun_pos = [1,1,1];
	
	shader_set(shd_default);
	shader_set_uniform_i(
		shader_get_uniform(shd_default, "lightTotal"), 
		0
	);
	shader_reset();
}	

enum eLightType {
	Point,
	Spot
}

function fauxton_calculate_sprite_lighting(_x, _y, _z, _ogColor)
{
	// If no world environment exits exit;
	if ( !instance_exists(WorldEnvironment) ) { exit; }
	
	// Get our initial color
	var _c = { r: color_get_red(_ogColor)/255, g: color_get_green(_ogColor)/255, b: color_get_blue(_ogColor)/255 };
	
	// Get the world ambient color
	var _aCol = {	r: color_get_red(fauxton_world_environment.ambient_color)/255, 
					g: color_get_green(fauxton_world_environment.ambient_color)/255, 
					b: color_get_blue(fauxton_world_environment.ambient_color)/255 
				};
	var _sCol = {	r: color_get_red(fauxton_world_environment.sun_color), 
					g: color_get_green(fauxton_world_environment.sun_color), 
					b: color_get_blue(fauxton_world_environment.sun_color) 
				};
	
	// Vector functions
	var color_vec_add = function(vec1, vec2)
	{
		vec1.r += vec2.r;
		vec1.g += vec2.g;
		vec1.b += vec2.b;
		return { r : vec1.r, g : vec1.g, b : vec1.b };
	}
	var color_vec_mul = function(vec1, vec2)
	{
		vec1.r *= vec2.r;
		vec1.g *= vec2.g;
		vec1.b *= vec2.b;
		return { r : vec1.r, g : vec1.g, b : vec1.b };
	}
	
	// Multiply our color by our world ambient color
	_c = color_vec_mul(_c, _aCol);
	
	// Interact with point lights
	for ( var i=0; i<instance_number(PointLight); i++ )
	{
		// Find the light
		var _l = instance_find(PointLight, i);
		
		// Get the distance by the range
		var _d = 1 - ( point_distance_3d(_x, _y, _z, _l.x, _l.y, _l.z) / _l.range );
		_d = clamp(_d, 0, 1);
		
		// Get our light color and multiply it by the distance to the light
		var _lCol = { 
			r: color_get_red(_l.color) * _d, 
			g: color_get_green(_l.color) * _d, 
			b: color_get_blue(_l.color) * _d
		}
		
		// Add our light amounts to our color
		_c = color_vec_add(_c, _lCol);
	}
	
	// Add our sun-light to the player.
	_c.r += _sCol.r * fauxton_world_environment.sun_intensity * 0.5;
	_c.g += _sCol.g * fauxton_world_environment.sun_intensity * 0.5;
	_c.b += _sCol.b * fauxton_world_environment.sun_intensity * 0.5;
		
	_c.r = clamp(_c.r, 0, 255);
	_c.g = clamp(_c.g, 0, 255);
	_c.b = clamp(_c.b, 0, 255);
	
	// Get our new color
	return make_color_rgb(_c.r, _c.g, _c.b);	
}