// Check for HTML5 (This doesn't like to work on html5 for some reason)
if ( os_browser != browser_not_a_browser )
{
	instance_destroy();
}

// Create shadow surface
shadow_surface = surface_create(room_width, room_height);
shadow_matrix = matrix_build(0, 0, 1, 0, 0, 0, 1, 1, 1);