trans_surf = surface_create(surface_get_width(application_surface), surface_get_height(application_surface));
dir = 0;

surface_set_target(trans_surf);
draw_clear(c_black);
draw_surface_ext(application_surface, 0, surface_get_height(trans_surf), 1, -1, 0, c_white, 1);
surface_reset_target();

