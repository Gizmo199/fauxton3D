#region Macros & Globals (ignore)
	global.__SYSTEM_RENDER_QUEUE = ds_list_create();
	global.__SYSTEM_DEFAULT_STATE = gpu_get_state();
	global.__SYSTEMBUFFERMAPS = ds_map_create();

	#macro RENDER_QUEUE global.__SYSTEM_RENDER_QUEUE
	#macro BUFFER_MAPS global.__SYSTEMBUFFERMAPS
	
	#macro gm_DefaultState global.__SYSTEM_DEFAULT_STATE
	
#endregion

// Rendering functions
function pipeline_initiate()
{
	///@func pipeline_initiate()
	
	// default static buffer
	texref = sprite_get_texture(ico_texref, 0);
	default_shader = ( RenderShader == noone ? shd_default : RenderShader );
	fidelity_matrix = [];
	
	timer = 3;
	
	// Create fidelity matrices
	function render_build_fidelity() {
		///@func render_build_fidelity()
		if ( array_length(fidelity_matrix) < RENDER_FIDELITY ) 
		{
			for ( var i=0; i<round(RENDER_FIDELITY); i++ ){
				var zxtra = 1/RENDER_FIDELITY;
				fidelity_matrix[i] = matrix_build(0, 0, zxtra * i, 0, 0, 0, 1, 1, 1);
			}	
		}
	}
	uni = {
		amb_col : shader_get_uniform(shd_default, "ambient_color"),
		sun_col : shader_get_uniform(shd_default, "sun_color"),
		sun_int : shader_get_uniform(shd_default, "sun_intensity"),
		sun_pos : shader_get_uniform(shd_default, "sun_pos"),
			
		light_num		: shader_get_uniform(shd_default, "lightTotal"),
		light_position	: shader_get_uniform(shd_default, "lightPos"),
		light_color		: shader_get_uniform(shd_default, "lightColor"),
		light_range		: shader_get_uniform(shd_default, "lightRange"),
			
		light_is_cone	: shader_get_uniform(shd_default, "lightIsCone"),
		light_direction : shader_get_uniform(shd_default, "lightDirection"),
		light_cutoff	: shader_get_uniform(shd_default, "lightCutoffAngle")
	}
	show_debug_message("UNIFORM (int) 'lightTotal' :" + string(uni.light_num) );

	function default_world_shader_set(){
		if ( shader_current() != shd_default ) { exit; }
		// World environment lighting
	
		var uAmbCol = fauxton_world_environment.ambient_color;
		var uSunCol = fauxton_world_environment.sun_color;
		var color_return = function(color){
			var r,g,b;
			r = color_get_red(color)/255;
			g = color_get_green(color)/255;
			b = color_get_blue(color)/255;
			var ret = array_create(3);
			ret = [ r, g, b];
			return ret;
		}
		var acol, scol;
		acol = array_create(3);
		scol = array_create(3);
		
		acol = color_return(uAmbCol);
		shader_set_uniform_f_array(uni.amb_col, acol);
			
		scol = color_return(uSunCol);
		shader_set_uniform_f_array(uni.sun_col, scol);
			
		shader_set_uniform_f(uni.sun_int, fauxton_world_environment.sun_intensity);
		var s = fauxton_world_environment.sun_pos;
		shader_set_uniform_f_array(uni.sun_pos, s);
		
		// Lights		
		var _LightNum = instance_number(__fauxtonLight);
		shader_set_uniform_f(uni.light_num, _LightNum);
		
		if ( !instance_exists(WorldEnvironment) ){ exit; }
		var lPos = [];
		var lCol = [];
		var lRad = [];
		var lType = [];
		var lDir = [];
		var lCutoff = [];
		
		if ( _LightNum > 0 ){
			for ( var i=0; i<_LightNum; i++ )
			{
				var lightId = instance_find(__fauxtonLight, i);
				array_insert(lPos, 0, lightId.x, lightId.y, lightId.z);
					
				var _c = color_return(lightId.color);
				array_insert(lCol, 0, _c[0], _c[1], _c[2]);
					
				array_insert(lRad, 0, lightId.range);
				
				array_insert(lType, 0, lightId.light_type);
				switch(lightId.light_type)
				{
					case eLightType.Point:
						array_insert(lCutoff, 0, dcos(360));
						array_insert(lDir, 0, 0, 0, 0);
					break;
					
					case eLightType.Spot:
						array_insert(lCutoff, 0, dcos( lightId.cutoff_angle ));
						array_insert(lDir, 0, 
							dcos(lightId.angle) * dcos(lightId.z_angle), 
							dsin(lightId.angle) * dcos(lightId.z_angle), 
							dsin(lightId.z_angle)
						);
					break;
				}
			}
			shader_set_uniform_f_array(uni.light_is_cone, lType);
			shader_set_uniform_f_array(uni.light_direction, lDir);
			shader_set_uniform_f_array(uni.light_cutoff,  lCutoff);
			
			shader_set_uniform_f_array(uni.light_position, lPos);
			shader_set_uniform_f_array(uni.light_color, lCol);
			shader_set_uniform_f_array(uni.light_range, lRad);
		}
	}
	render_build_fidelity();
	function load_buffer_maps() 
	{		
		// Load all buffer maps
		for ( var i=ds_map_find_first(BUFFER_MAPS); !is_undefined(i); i = ds_map_find_next(BUFFER_MAPS, i) )
		{
			var b = BUFFER_MAPS[? i];
			if ( !b.loaded ){
				// Load and write to buffers 
				var l = b.load_pos + b.load_chunk;
				l = clamp(l, 0, ds_list_size(b.load_queue));
				for ( var j = b.load_pos; j<l; j++ ) 
				{
					b.load_pos++;
					var m = b.load_queue[| j];
					__FauxtonWriteStaticSpriteStack( b.buffer, m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9]);
				}
				
				// Complete loading
				if ( b.load_pos == ds_list_size(b.load_queue) )
				{
					show_debug_message("Buffer "+string(i)+": Succesfully Loaded! ");
					b.loaded = true;	
					ds_list_destroy(b.load_queue);
					if ( b.buffer < 0 ) { buffer_delete(b.buffer); b.buffer = -1; exit; }
					b.vertex_buffer = vertex_create_buffer_from_buffer(b.buffer, SYSTEM_VERTEX_FORMAT);
					buffer_delete(b.buffer);
					vertex_freeze(b.vertex_buffer);
				}
			}
			
		}
	}
	function render_buffer_maps()
	{
		for ( var b = ds_map_find_first(BUFFER_MAPS); !is_undefined(b); b = ds_map_find_next(BUFFER_MAPS, b) )
		{
			var buff = BUFFER_MAPS[? b];
			if ( !buff.loaded ){ continue; }
			
			// Buffer shader
			shader_set(buff.shader);
			default_world_shader_set();
			
			// Override shader
			if ( buff.uniform_script == -1 ){
				FauxtonUniformControl(buff.shader);
			} else {
				buff.uniform_script();	
			}
			
			if ( buff.matrix != -1 )
			{
				matrix_set(matrix_world, buff.matrix);
			}
			vertex_submit(buff.vertex_buffer, pr_trianglelist, texref);
		}
	}
}
function pipeline_load()
{
	render_build_fidelity();
	if ( !instance_exists(WorldEnvironment) )
	{
		fauxton_world_set_default_environment();	
	}
	if ( timer > 0 ){ timer--; exit; }
	load_buffer_maps();
}
function pipeline_cleanup()
{
	// Cleanup buffer & buffer map
	for ( var i=ds_map_find_first(BUFFER_MAPS); !is_undefined(i); i = ds_map_find_next(BUFFER_MAPS, i)) {
		var _vb = BUFFER_MAPS[? i];
		if ( _vb.vertex_buffer != -1  )
		{
			vertex_delete_buffer(_vb.vertex_buffer);
		}
		if ( buffer_exists(_vb.buffer ) )
		{
			buffer_delete(_vb.buffer); 	
		}
		ds_list_destroy(_vb.load_queue);
	}
	ds_map_destroy(BUFFER_MAPS);
	BUFFER_MAPS = ds_map_create();
	
	// Reset to gm's default state
	gpu_set_state(gm_DefaultState);
}
function pipeline_roomend(){
	// Clear our render queue
	ds_list_clear(RENDER_QUEUE);	
}
function pipeline_render()
{
	// Render the static buffer
	if ( RENDER_FIDELITY > 1 )
	{
		for ( var i=0; i<RENDER_FIDELITY; i++ )
		{
			matrix_set(matrix_world, fidelity_matrix[i]);
			render_buffer_maps();
		}
	} 
	else
	{
		render_buffer_maps();
	}
	
	// Render models
	shader_set(default_shader);
	default_world_shader_set();
	
	for ( var i=0; i<ds_list_size(RENDER_QUEUE); i++ )
	{	
		var m = RENDER_QUEUE[| i];
		if ( m == -1 ) { continue; }
		if ( !m.draw_enable ){ continue; }
		matrix_set(matrix_world, m.matrix_id);
		vertex_submit(m.model_id, pr_trianglelist, m.texture);
	}
	
	// Reset all shaders
	shader_reset();
	matrix_reset();
}
function pipeline_render_to_screen()
{
	// Reset matrices
	matrix_reset();
	
	if ( !instance_exists(Camera) )
	{
		gpu_set_state(gm_DefaultState);
		exit;
	}

	// Draw application surface & Post-processing
	draw_surface_stretched( application_surface, 0, 0, gui_width, gui_height );
}
