// Create particles
var flow_offset_x = ( x ) - flow;
var flow_offset_y = y;
part_particles_create(
	part_sys, 
	x + flow_offset_x + random_range(-fog_size.x*.5, fog_size.x*.5), 
	-y + flow_offset_y + random_range(-fog_size.y*.5, fog_size.y*.5), 
	part_fog, 
	1
);

// Set particle alarm
alarm[0] = alarm_speed;