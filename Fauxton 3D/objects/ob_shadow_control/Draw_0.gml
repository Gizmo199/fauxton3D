// Check for surface
if ( !surface_exists(shadow_surface) )
{
	shadow_surface = surface_create(room_width, room_height);
}	

// Draw our particles to the surface
surface_set_target(shadow_surface);
	draw_clear_alpha(c_black, 0);
	with ( ob_smoke_particle )
	{
		draw_sprite_3d_ext(sprite_index, image_index, x, y, 0, 0, 0, 0, scale, scale, scale, image_blend, image_alpha, false);
	}
	with ( ob_debris_particle )
	{
		draw_sprite_3d_ext(sprite_index, image_index, x, y, 0, 0, 0, 0, scale, scale, scale, image_blend, image_alpha, false);
	}
surface_reset_target();

