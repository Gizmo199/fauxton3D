// Set the position. This can simulate fog moving more in 1 direction
flow += flow_speed;

// Update our position
x = Camera.x; 
y = Camera.y;

// Particle system position
// This will give the 'illusion' that fog exists everywhere, but
// Really we are just offseting the particle layer,
// And updating our fog model to the cameras x/y position
var xx = ( -x ) + flow;
var yy = ( y );

// Update our fog matrix position
fauxton_model_set(fog_cube, x, y, 0, 0, 0, 0, fog_size.x, fog_size.y, fog_size.z);

// Update particle system position
part_system_position(part_sys, xx, yy);

// Check for our surface
if ( !surface_exists(fog_surface) )
{
	fog_surface = surface_create(fog_size.x, fog_size.y);
}

// Draw fog particles to our surface
surface_set_target(fog_surface);

	draw_clear(c_black);
	gpu_set_blendmode(bm_add);
	part_system_drawit(part_sys);
	gpu_set_blendmode(bm_normal);

surface_reset_target();
shader_reset();