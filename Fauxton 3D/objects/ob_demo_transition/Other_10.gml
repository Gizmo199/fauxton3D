if ( surface_exists(trans_surf) )
{
	draw_surface_stretched(trans_surf, x, 0, display_get_gui_width(), display_get_gui_height());
	draw_surface_stretched(application_surface, x+(display_get_gui_width()*-dir), 0,display_get_gui_width(), display_get_gui_height());
}