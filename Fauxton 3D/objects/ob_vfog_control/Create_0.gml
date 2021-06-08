// Variables
layers = 64;
alpha = 0.11;
wave_amount = 0;
zscale = 0.5;
scale = 1;
blend = bm_add;

// Particle creation vars
alarm_speed = 1;
flow = 0;
flow_speed = 1;

// Shader
shader = shd_vfog;
uniform = {
	height	: shader_get_uniform( shader, "layers" ),
	alpha	: shader_get_uniform( shader, "alpha" ),
	time	: shader_get_uniform( shader, "time"),
	amount	: shader_get_uniform( shader, "amount")
}

// Custom texture cube
fog_size = new vector3(room_width, room_height, 0.5);
fog_surface = surface_create(fog_size.x, fog_size.y);
fog_cube = fauxton_model_texcube(layers, surface_get_texture(fog_surface));

// Particle System
part_sys = part_system_create();
part_system_automatic_draw(part_sys, false);

part_fog = part_type_create();
part_type_sprite(part_fog, sp_fog_particles, 0.1, 0, true);
part_type_direction(part_fog, 0, 359, 0.01, 0);
part_type_speed(part_fog, .1, 1, 0, 0);
part_type_orientation(part_fog, 0, 359, 0.1, 0, 0);
part_type_alpha3(part_fog, 0, 0.75, 0);
part_type_size(part_fog, 0.01, 0.5, 0.001, 0);
part_type_life(part_fog, 60, 120);

// Create particles
part_particles_create(part_sys, flow+random(fog_size.x), random(fog_size.y), part_fog, 1);

// Particle alarm
alarm[0] = alarm_speed;
