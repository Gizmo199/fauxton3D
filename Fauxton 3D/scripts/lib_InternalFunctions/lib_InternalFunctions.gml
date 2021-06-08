global.__modelMap = ds_map_create();
global.__renderFormat = -1;
global.__matWorldReset = matrix_build_identity();

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
vertex_format_add_color();
vertex_format_add_normal();
global.__renderFormat = vertex_format_end();

#macro SYSTEM_MODEL_MAP		global.__modelMap
#macro SYSTEM_VERTEX_FORMAT	global.__renderFormat
#macro SYSTEM_MATRIX_RESET global.__matWorldReset

// Buffer functions
function __FauxtonWritePoint(mBuff, pArr, tArr, col, alp, nArr)
{
	///@func __FauxtonWritePoint(buffer, point_array, texcoord_array, color, alpha)
	
	// Position
	buffer_write(mBuff, buffer_f32, pArr[0]);
	buffer_write(mBuff, buffer_f32, pArr[1]);
	buffer_write(mBuff, buffer_f32, pArr[2]);
	
	// Texcoord
	buffer_write(mBuff, buffer_f32, tArr[0]);
	buffer_write(mBuff, buffer_f32, tArr[1]);
	
	// Color
	buffer_write(mBuff, buffer_u8, color_get_red(col));
	buffer_write(mBuff, buffer_u8, color_get_green(col));
	buffer_write(mBuff, buffer_u8, color_get_blue(col));
	buffer_write(mBuff, buffer_u8, alp * 255);
	
	// Normal
	buffer_write(mBuff, buffer_f32, nArr[0]);
	buffer_write(mBuff, buffer_f32, nArr[1]);
	buffer_write(mBuff, buffer_f32, nArr[2]);
	
}
function __FauxtonWriteVert(mBuff, _3mat, _uv1, _uv2, _uv3, _col, _alp, _nMat)
{
	///@func __FauxtonWriteVert(buffer, 3x3_matrix, uv1_array, uv2_array, uv3_array, color, alpha)
	var m = _3mat;
	var n = _nMat;
	
	// Must be done this way for HTML5
	var point1 = array_create(3);
	var point2 = array_create(3);
	var point3 = array_create(3);
	point1 = [ m[0], m[1], m[2] ];
	point2 = [ m[3], m[4], m[5] ];
	point3 = [ m[6], m[7], m[8] ];
	
	var pNorm1 = array_create(3);
	var pNorm2 = array_create(3);
	var pNorm3 = array_create(3);
	pNorm1 = [ n[0], n[1], n[2] ];
	pNorm2 = [ n[3], n[4], n[5] ];
	pNorm3 = [ n[6], n[7], n[8] ];
	
	// Add points
	__FauxtonWritePoint( mBuff, point1, _uv1,_col, _alp, pNorm1);
	__FauxtonWritePoint( mBuff, point2, _uv2, _col, _alp, pNorm2 );
	__FauxtonWritePoint( mBuff, point3, _uv3, _col, _alp, pNorm3 );
}
function __FauxtonWriteQuad(mBuff, texture, index, _x, _y, _z, color, alpha, angle, xscale, yscale, zscale )
{
	///@func __FauxtonWriteQuad(buffer, sprite, index, x, y, z, color, alpha, angle, xscale, yscale, zscale)
	var l,t,r,b,tl,tt,tr,tb,
		vx0,vy0,vx1,vy1,vx2,vy2,vx3,vy3,
		cs, sn, _uvs, _tuvs;
	
	_uvs = sprite_get_uvs(texture, index);
	_tuvs = texture_get_uvs(sprite_get_texture(texture, index));

	// Get UVs
	l = _tuvs[0];
	t = _tuvs[1];
	r = _tuvs[2];
	b = _tuvs[3];
	
	// Get Vertex offsets	
	tl = xscale * _uvs[4] - sprite_get_xoffset(texture) * xscale;
	tt = yscale * _uvs[5] - sprite_get_yoffset(texture) * yscale;
	tr = tl + xscale * ( sprite_get_width(texture) * _uvs[6]);
	tb = tt + yscale * ( sprite_get_height(texture) * _uvs[7]);
	
	cs = dcos(angle);
	sn = dsin(angle);
	
	vx0 = _x + cs*tl + sn*tt;
	vy0 = _y + -sn*tl + cs*tt;
	vx1 = _x + cs*tr + sn*tt;
	vy1 = _y + -sn*tr + cs*tt;
	vx2 = _x + cs*tr + sn*tb;
	vy2 = _y + -sn*tr + cs*tb;
	vx3 = _x + cs*tl + sn*tb;
	vy3 = _y + -sn*tl + cs*tb;
	
	_z *= zscale;
	// Create matrixes
	var _mat1 = mat3(
	vx0, vy0, _z, 
	vx1, vy1, _z, 
	vx2, vy2, _z);
	
	var _mat2 = mat3(
	vx0, vy0, _z, 
	vx2, vy2, _z, 
	vx3, vy3, _z);
	
	// Must use array create for export with HTML5
	var vert1 = array_create(2);
	var vert2 = array_create(2);
	var vert3 = array_create(2);
	vert1 = [l,t];
	vert2 = [r,t];
	vert3 = [r,b];
	
	var vert4 = array_create(2);
	var vert5 = array_create(2);
	var vert6 = array_create(2);
	vert4 = [l,t];
	vert5 = [r,b];
	vert6 = [l,b];
		
	// Normals
	_z = 1;
	var nx1 = lengthdir_x(1, point_direction(_x, _y, vx0, vy0));
	var nx2 = lengthdir_x(1, point_direction(_x, _y, vx1, vy1));
	var nx3 = lengthdir_x(1, point_direction(_x, _y, vx2, vy2));
	var nx4 = lengthdir_x(1, point_direction(_x, _y, vx3, vy3));
	
	var ny1 = lengthdir_y(1, point_direction(_x, _y, vx0, vy0));
	var ny2 = lengthdir_y(1, point_direction(_x, _y, vx1, vy1));
	var ny3 = lengthdir_y(1, point_direction(_x, _y, vx2, vy2));
	var ny4 = lengthdir_y(1, point_direction(_x, _y, vx3, vy3));
	
	var norm1 = mat3(
		nx1, ny1, _z,
		nx2, ny2, _z,
		nx3, ny3, _z		
	);
	var norm2 = mat3(
		nx1, ny1, _z,
		nx3, ny3, _z,
		nx4, ny4, _z
	);
	__FauxtonWriteVert( mBuff, _mat1, vert1, vert2, vert3, color, alpha, norm1 );
	__FauxtonWriteVert( mBuff, _mat2, vert4, vert5, vert6, color, alpha, norm2 );
}
function __FauxtonWriteSpriteStack(sprite, _x, _y, _z, _col, _alp, _ang)
{
	///@func __FauxtonWriteSpriteStack(sprite, x, y, z, color, alpha, angle)
	
	// Has this model already been created?
	var mName = sprite_get_name(sprite);
	if ( ds_map_exists(SYSTEM_MODEL_MAP, mName) ){
		return SYSTEM_MODEL_MAP[? mName];	
	}
	
	// Number of images
	var _num = sprite_get_number(sprite);
	
	// Prevent z-fighting
	var _zoffset = random_range(0.01, 0.1);
		
	// Create and write to buffer (much faster than writing a direction vertex buffer
	var _buff = buffer_create( 1, buffer_grow, 1);
	for ( var i=0; i<_num * RENDER_FIDELITY; i++ )
	{
		var _ind = i/RENDER_FIDELITY;
		__FauxtonWriteQuad(_buff, sprite, _ind, _x, _y, _z + (i/RENDER_FIDELITY) + _zoffset, _col, _alp, _ang, 1, 1, 1)
	}
	
	if ( _buff < 0 ) { buffer_delete(_buff); return -1; }
	var vBuff = vertex_create_buffer_from_buffer(_buff, SYSTEM_VERTEX_FORMAT);
	vertex_freeze(vBuff);
	SYSTEM_MODEL_MAP[? mName] = vBuff;
	return SYSTEM_MODEL_MAP[? mName];
}
function __FauxtonWrite3DTexCube( _h, _col, _alpha, _ang)
{
	var vBuff = vertex_create_buffer();
	vertex_begin(vBuff, SYSTEM_VERTEX_FORMAT);
	
	for ( var i=0; i<_h; i++ )
	{
		// Tri 1
		vertex_position_3d(vBuff, -.5, -.5, i);
		vertex_texcoord(vBuff,0,0);
		vertex_color(vBuff, _col, _alpha);
		vertex_normal(vBuff, 0, -1, 1);
		
		vertex_position_3d(vBuff, .5, .5, i);
		vertex_texcoord(vBuff,1,1);
		vertex_color(vBuff, _col, _alpha);
		vertex_normal(vBuff, 1, 0, 1);
		
		vertex_position_3d(vBuff, .5, -.5, i);
		vertex_texcoord(vBuff,1,0);
		vertex_color(vBuff, _col, _alpha);
		vertex_normal(vBuff, 1, 1, 1);
	
		// Tri 2
		vertex_position_3d(vBuff, -.5, -.5, i);
		vertex_texcoord(vBuff,0,0);
		vertex_color(vBuff, _col, _alpha);
		vertex_normal(vBuff, -1, 0, 1);
		
		vertex_position_3d(vBuff, .5, .5, i);
		vertex_texcoord(vBuff,1,1);
		vertex_color(vBuff, _col, _alpha);
		vertex_normal(vBuff, 0, 1, 1);
		
		vertex_position_3d(vBuff, -.5, .5, i);
		vertex_texcoord(vBuff,0,1);
		vertex_color(vBuff, _col, _alpha);
		vertex_normal(vBuff, -1, -1, 1);
	}
	vertex_end(vBuff);
	vertex_freeze(vBuff);
	return vBuff;
}
function __FauxtonWriteStaticSpriteStack(_buffer, sprite, _x, _y, _z, _col, _alp, _ang, _xs, _ys, _zs )
{
	///@func __FauxtonWriteStaticSpriteStack(buffer, sprite, x, y, z, color, alpha, angle, xscale, yscale, zscale)

	// Number of images
	var _num = sprite_get_number(sprite);
	
	// Prevent z-fighting
	var _zoffset = random_range(0.01, 0.1);
		
	// Create and write to buffer (much faster than writing a direct vertex buffer)
	for ( var i=0; i<_num * _zs; i+=1/_zs )
	{
		var _ind = ceil(i / _zs);
		//if ( _ind > _num-1.6 ){ _ind = ceil(_ind); }
		_ind = clamp(_ind, 0, _num-1);
		__FauxtonWriteQuad(_buffer, sprite, _ind, _x, _y, _z + i + _zoffset, _col, _alp, _ang, _xs, _ys,_zs)
	}
}
	
// Maths
function vector2() constructor {
	x = 0;
	y = 0;
	if ( argument_count > 0 ){
		x = argument[0];
		if ( argument_count > 1 ){
			y = argument[1];	
		}
	}
	
	static add = function(vec2){
		x += vec2.x;
		y += vec2.y;
	}
}
function vector3() constructor {
	
	x = 0;
	y = 0;
	z = 0;	
	if ( argument_count > 0 ){
		x = argument[0];
		if ( argument_count > 1 ){
			y = argument[1];	
			if ( argument_count > 2 ){
				z = argument[2];	
			}
		}
	}
	
	static add = function(vec3){
		x += vec3.x;
		y += vec3.y;
		z += vec3.z;
	}
}
function mat3(){
	////@func mat3(*x1, *y1, *z1, *x2, *y2, *z2, *x3, *y3, *z3)
	var _mat = array_create(9);
	_mat = [
		0, 0, 0,
		0, 0, 0,
		0, 0, 0
	];
	for ( var i=0; i<argument_count; i++ ){
		_mat[i] = argument[i];	
	}
	return _mat;
}
function matrix_vec_build(pos, rot, scl){
	return matrix_build( 
				pos.x, pos.y, pos.z,
				rot.x, rot.y, rot.z,
				scl.x, scl.y, scl.z
		   );
}
function matrix_reset(){
	matrix_set(matrix_world, SYSTEM_MATRIX_RESET);
}
