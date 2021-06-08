// Particle variables
life = 0;
grow = 0;
scale = 0;
size = 1;
z = 0;
zgrav = 0;
zspeed = 0;
ground_z = 0;

image_speed = 0;
image_index = irandom(image_number);

can_die = false;

// We can create some functions to
// make our 'derbis' paricle an emitter
emitter = true;
emitter_values = [];

// A function for setting the emitter
function emitter_part_set(_pob, _life, _size, _xspd, _yspd, _zspd, _grav, _color)
{
	///@func emitter_part_set(part_obj, life, size, xspeed, yspeed, zspeed, gravity, color);
	emitter_values = [
		_pob,
		_life,
		_size,
		_xspd,
		_yspd,
		_zspd,
		_grav,
		_color
	];
}
// A function for creating our emitter particles
function emit_particles()
{
	if ( !emitter ) { exit; }
	var e = emitter_values;
	if ( array_length(e) < 1 ){ exit; }
	
	// Set particle variables from our emitter_values array
	var p = instance_create_layer(x, y, layer, e[0]);
	with ( p )
	{
		life = e[1];
		size = max(e[2] * dsin(other.grow), size);
		z = other.z;
		hspeed = e[3];
		vspeed = e[4];
		zspeed = e[5];
		zgrav = e[6];
		image_blend = e[7];
	}
}