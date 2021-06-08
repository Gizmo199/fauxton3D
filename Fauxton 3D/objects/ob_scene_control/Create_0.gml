// Create & Set a custom shader for the grass buffer. 
// You can alter unfiroms in either:
// Fauxton 3D - Engine > User Utilities > Scripts > FauxtonUniformControl
// OR you can use the function 'fauxton_buffer_set_uniform_script' and assign
// a uniform control script to the buffer to be called, like so:

GrassBuff = -1;
if ( room == rm_demo1 )
{
	// Create the grass buffer with custom shader
	var GrassShaderControl = function(){
		var uni = shader_get_uniform(shd_grass_sway, "time");
		shader_set_uniform_f(uni, current_time/600);
	}
	
	GrassBuff = fauxton_buffer_create("GrassBuffer", shd_grass_sway);
	fauxton_buffer_set_uniform_script("GrassBuffer", GrassShaderControl);
	
} else {
	// Create grass buffer with default shader
	// ( This way the grass will be effected by the lighting )
	GrassBuff = fauxton_buffer_create("GrassBuffer");	
}

//----------------------------------------------------------------------------------------------//

				//					*** NOTE ***
				// Overriding fauxtons default shader for buffers will
				// Make it so that you will have to program your own lighting.
				// It is suggested that you duplicate 'shd_default',
				// make your changes, and then copy/paste the code found in:
				// RenderPipeline > pipeline_initiate() > default_world_shader_set()
				// as well as adding your own uniforms to this code.
				
//----------------------------------------------------------------------------------------------//

TreeBuff = fauxton_buffer_create("TreeBuffer");
SceneBuff = fauxton_buffer_create("SceneBuffer");

// Find objects in the room called
// 'ob_tree_ref' and create a new tree
// model at the position of those objects
with ( ob_tree_ref )
{
	// Randomize
	sprite_index = choose(sp_tree_1, sp_tree_2);
	image_angle = random(360);

	// Create model
	var model = fauxton_model_create(sprite_index, x, y, 0, 0, 0, image_angle, 1, 1, 1);
	fauxton_model_add_static(model, "TreeBuffer");	
	
	// Cleanup
	fauxton_model_destroy(model);
	instance_destroy();
}

// Create/load models for our scene
var grassModel1 = fauxton_model_create(sp_grass_1, 0, 0, 0, 0, 0, 0, 1, 1, 1);
var grassModel2 = fauxton_model_create(sp_grass_2, 0, 0, 0, 0, 0, 0, 1, 1, 1);
var weedModel = fauxton_model_create(sp_weed, 0, 0, 0, 0, 0, 0, 1, 1, 1);
var rockModel = fauxton_model_create(sp_rock_1, 0, 0, 0, 0, 0, 0, 1, 1, 1);
var pebbleModel = fauxton_model_create(sp_rock_2, 0, 0, 0, 0, 0, 0, 1, 1, 1);

repeat(round(room_width/7))
{
	// Add a bunch of randomized grass
	var ind = choose(grassModel1, grassModel2);
	var xx = random(room_width);
	var yy = random(room_height);
	
	// Check for 'no-grass' areas. If our xx
	// or yy are within 16px of one of these areas
	// we should re-locate the grass
	if ( instance_exists(ob_no_grass) )
	{
		var rad = 16;
		while ( collision_circle(xx, yy, rad, ob_no_grass, false, true) )
		{
			xx = random(room_width);
			yy = random(room_height);	
		}
	}
	
	// Keep grass within room bounds
	xx = clamp(xx, 80, room_width-80);
	yy = clamp(yy, 80, room_height-80);
	
	// Random scaling and angle
	var scl = random_range(.5, 1.25);
	var ang = random(360);
	
	// Set our grass models position, rotation, and scale
	// Then add it to our static buffer 'GrassBuffer'
	fauxton_model_set(ind, xx, yy, 0, 0, 0, ang, scl, scl, 1);
	fauxton_model_add_static(ind, "GrassBuffer");
	
	// Add a few random weeds
	var chs = irandom_range(0, 20);
	if ( chs == 1 )
	{
		fauxton_model_set(weedModel, random(room_width), random(room_height), 0, 0, 0, 0, .5, .5, 1);
		fauxton_model_add_static(weedModel, "TreeBuffer");	
	}
	
	// Add some rocks
	var chs = irandom_range(0, 15);
	if ( chs == 1 )
	{
		var _mod = choose(pebbleModel, rockModel);
		var scl = random_range(1, 1.5);
		var zscl = random_range(1, 1.25);
		var rot = random(360);
		fauxton_model_set(_mod, random(room_width), random(room_height), 0, 0, 0, rot, scl, scl, zscl);
		fauxton_model_add_static(_mod, "SceneBuffer");	
	}
	
	// Add the tent (if one exists)
	with ( ob_tent_ref )
	{
		var _mod = fauxton_model_create(sprite_index, x, y, 0, 0, 0, image_angle, 1, 1, 1);
		fauxton_model_add_static(_mod, "SceneBuffer");
		fauxton_model_destroy(_mod);
		instance_destroy();	
	}
	
}
fauxton_model_destroy(grassModel1);
fauxton_model_destroy(grassModel2);
fauxton_model_destroy(weedModel);
fauxton_model_destroy(rockModel);
fauxton_model_destroy(pebbleModel);