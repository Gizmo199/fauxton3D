// Start fauxton
FAUXTON_START();

// Set minimum quality/fidelity for mobile
is_phone = ( os_type == os_android || os_type == os_winphone || os_type == os_ios )
if ( is_phone )
{
	RENDER_FIDELITY = 2;
	RENDER_QUALITY = 1;
}

// Set window size for browser / phone
is_html = ( os_browser != browser_not_a_browser ); 
if ( is_html || is_phone )
{
	window_set_size(display_get_width(), display_get_height());
}

// Center splash screen
x = room_width*.5;
y = room_height*.5;

// Wait before starting demo
alarm[0] = 60;
