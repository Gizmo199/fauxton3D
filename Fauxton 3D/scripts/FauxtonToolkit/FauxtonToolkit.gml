#region Model functions

	function fauxton_model_create(sprite, _x, _y, _z, _xr, _yr, _zr, _xs, _ys, _zs)
	{
		///@func fauxton_model_create(sprite, x, y, z, xrot, yrot, zrot, xscale, yscale, zscale)
		var _m = {
			spref		: sprite,
			texture		: sprite_get_texture(ico_texref, 0),
			pos_id		: ds_list_size(RENDER_QUEUE),
			model_id	: __FauxtonWriteSpriteStack(sprite, 0, 0, 0, c_white, 1, 0),
			position	: new vector3(_x, _y, _z),
			rotation	: new vector3(_xr, _yr, _zr),
			scale		: new vector3(_xs, _ys, _zs),
			matrix_id	: -1,
			draw_enable : true,
			isBBoard	: false,
			color       : c_white,
			alpha		: 1
		}
		_m.matrix_id = matrix_vec_build(_m.position, _m.rotation, _m.scale);
		RENDER_QUEUE[| _m.pos_id] = _m;
		fauxton_model_set(_m.pos_id, _x, _y, _z, _xr, _yr, _zr, _xs, _ys, _zs);
		
		return _m.pos_id;
	}
	function fauxton_model_create_ext(sprite, _x, _y, _z, _xr, _yr, _zr, _xs, _ys, _zs, _c, _a)
	{
		///@func fauxton_model_create_ext(sprite, x, y, z, xrot, yrot, zrot, xscale, yscale, zscale, blend, alpha)
		var _m = {
			spref		: sprite,
			texture		: sprite_get_texture(ico_texref, 0),
			pos_id		: ds_list_size(RENDER_QUEUE),
			model_id	: __FauxtonWriteSpriteStack(sprite, 0, 0, 0, _c, _a, 0),
			position	: new vector3(_x, _y, _z),
			rotation	: new vector3(_xr, _yr, _zr),
			scale		: new vector3(_xs, _ys, _zs),
			matrix_id	: -1,
			draw_enable : true,
			isBBoard	: false,
			color		: _c,
			alpha		: _a
		}
		_m.matrix_id = matrix_vec_build(_m.position, _m.rotation, _m.scale);
		RENDER_QUEUE[| _m.pos_id] = _m;
		fauxton_model_set(_m.pos_id, _x, _y, _z, _xr, _yr, _zr, _xs, _ys, _zs);
		
		return _m.pos_id;
	}
	function fauxton_model_texcube(height, tex)
	{
		var _m = {
			spref		: -1,
			texture		: tex,
			pos_id		: ds_list_size(RENDER_QUEUE),
			model_id	: __FauxtonWrite3DTexCube( height, c_white, 1, 0),
			position	: new vector3(),
			rotation	: new vector3(),
			scale		: new vector3(),
			matrix_id	: -1,
			draw_enable : true,
			isBBoard	: false
		}
		
		_m.matrix_id = matrix_vec_build(_m.position, _m.rotation, _m.scale);
		RENDER_QUEUE[| _m.pos_id] = _m;
		
		return _m.pos_id;
	}
	function fauxton_model_texcube_destroy(_m)
	{
		///@func fauxton_model_texcube_destroy(model_id)
		vertex_delete_buffer(RENDER_QUEUE[| _m].model_id);	
	}
	function fauxton_model_add_static(model_id, buffer_name) 
	{
		///@func fauxton_model_add_static(model_id, buffer_name)
		if ( is_undefined(BUFFER_MAPS[? buffer_name]) )
		{ 
			show_debug_message("--Error-- : Couldn't add static model to non-existent buffer '"+buffer_name+"'."); 
			exit;
		}
		var b = BUFFER_MAPS[? buffer_name];
		var m = RENDER_QUEUE[| model_id];
		if ( m.isBBoard ) { exit; }
		var a = [ m.spref, m.position.x, m.position.y, m.position.z, m.color, m.alpha, m.rotation.z, m.scale.x, m.scale.y, m.scale.z ];
		ds_list_add(b.load_queue, a);		
	}
	function fauxton_model_set(model_id, _x, _y, _z, _xr, _yr, _zr, _xs, _ys, _zs)
		{
			///@func fauxton_model_set(model_id, x, y, z, xrot, yrot, zrot, xscale, yscale, zscale)
			var m = RENDER_QUEUE[| model_id];
			//if ( !m.draw_enable ){ exit; }
			m.position.x = _x;
			m.position.y = _y;
			m.position.z = _z;
			m.rotation.x = _xr;
			m.rotation.y = _yr;
			m.rotation.z = _zr;
			m.scale.x	 = _xs;
			m.scale.y	 = _ys;
			m.scale.z	 = _zs;
	
			m.matrix_id  = matrix_vec_build( m.position, m.rotation, m.scale );
		}
	function fauxton_model_draw_enable(model_id, enable)
	{
		///@func fauxton_model_draw_enable(model_id, enabled)
		var m = RENDER_QUEUE[| model_id];
		m.draw_enable = enable;
	}
	function fauxton_model_destroy(model_id)
	{
		//ds_list_delete(RENDER_QUEUE, model_or_billboard_id);
		RENDER_QUEUE[| model_id] = -1;
	}
	function fauxton_model_draw_override(model_id)
	{
		var m = RENDER_QUEUE[| model_id];
		if ( m != -1 ) 
		{ 
			fauxton_model_draw_enable(model_id, false);
		}
		
		matrix_set(matrix_world, m.matrix_id);
		vertex_submit(m.model_id, pr_trianglelist, m.texture);
	}
	
#endregion
#region Sprite functions

	function fauxton_sprite_set(_x, _y, _z, _xr, _yr, _zr, _xs, _ys, _zs, _fc)
	{
		///@func fauxton_sprite_set(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale, face_camera)
		if ( !_fc )
		{
			matrix_set(matrix_world, matrix_build(_x, _y, _z, _xr + _xr, _yr, _zr, _xs, _ys, _zs));
		} 
		else 
		{
			matrix_set(matrix_world, matrix_build(_x, _y, _z, _xr + (-Camera.pTo-90), 0, (Camera.Forward), _xs, _ys, _zs));	
		}
		
	}
	function fauxton_sprite_draw(sprite, index, col, alp)
	{
		///@func fauxton_sprite_draw(sprite, index,color, alpha)
		shader_set(shd_gmdefault);
		draw_sprite_ext( sprite, index,	0, 0, 1, -1, 0, col, alp );
	}
	function draw_sprite_3d( sprite, subimg, _x, _y, _z, _xr, _yr, _zr, _xs, _ys, _zs, _fc )
	{
		///@func draw_sprite_3d(sprite, subimg, x, y, z, xrotation, yrotation, zrotation, xscale, yscale, zscale, facing_camera, *enable_lighting)
		fauxton_sprite_set(_x, _y, _z, _xr, _yr, _zr, _xs, _ys, _zs, _fc);
		
		var _col = c_white;
		if ( argument_count > 12 )
		{
			if ( argument[12] == true )
			{
				_col = 	fauxton_calculate_sprite_lighting(_x, _y, _z, c_white);
			}
		}
		
		fauxton_sprite_draw(sprite, subimg, _col, 1);
		matrix_reset();
	}
	function draw_sprite_3d_ext( sprite, subimg, _x, _y, _z, _xr, _yr, _zr, _xs, _ys, _zs, _c, _a, _fc )
	{
		///@func draw_sprite_3d_ext(sprite, subimg, x, y, z, xrotation, yrotation, zrotation, xscale, yscale, zscale, blend, alpha, facing_camera, *enable_lighting)
		fauxton_sprite_set(_x, _y, _z, _xr, _yr, _zr, _xs, _ys, _zs, _fc);
		
		var _col = _c;
		if ( argument_count > 14 )
		{
			if ( argument[14] == true )
			{
				_col = 	fauxton_calculate_sprite_lighting(_x, _y, _z, _c);
			}
		}
		fauxton_sprite_draw(sprite, subimg, _col, _a);
		matrix_reset();
	}
	
#endregion
#region Static buffer functions

	function fauxton_buffer_create(name)
	{
	///@func fauxton_buffer_create(name, *shader)
	BUFFER_MAPS[? name] = {
		buffer			: buffer_create(1, buffer_grow, 1),
		vertex_buffer	: -1,
		load_queue		: ds_list_create(),
		load_chunk		: 10,
		load_pos		: 0,
		loaded			: false,
		shader			: ( argument_count>1 ? argument[1] : shd_default ),
		matrix			: -1,
		uniform_script	: -1
		}
		
	return BUFFER_MAPS[? name];
	}
	function fauxton_buffer_get(name)
	{
		///@func fauxton_buffer_get(buffer_name)
		return BUFFER_MAPS[? name];
	}
	function fauxton_buffer_set(buffer_id_or_name, _sh)
	{
		///@func fauxton_buffer_set(buffer_id_or_name, shader, *matrix)
		var buff = buffer_id_or_name;
		if ( is_string(buffer_id_or_name) )
		{
			buff = BUFFER_MAPS[? buffer_id_or_name];
		}
		
		buff.shader = _sh;
		if ( argument_count > 2 ){
			buff.matrix = _mat;
		}
	}
	function fauxton_buffer_set_uniform_script(buffer_id_or_name, _sc)
	{
		///@func fauxton_buffer_set_uniform_script(buffer_id_or_name, uniform_control_script)
		var buff = buffer_id_or_name;
		if ( is_string(buffer_id_or_name) )
		{
			buff = BUFFER_MAPS[? buffer_id_or_name];
		}
		buff.uniform_script = _sc;
	}
		
#endregion