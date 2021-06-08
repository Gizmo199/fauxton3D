x = lerp(x, dir * display_get_gui_width(), 0.3);
if ( point_distance(x, 0, dir * display_get_gui_width(), 0) < 1 )
{
	instance_destroy();	
}
