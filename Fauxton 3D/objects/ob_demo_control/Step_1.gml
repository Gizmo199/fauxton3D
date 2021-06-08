// Rotate the camera if we are clicking and dragging
Camera.MouseLock = mouse_check_button(is_html ? mb_left : mb_right);
Camera.Zoom += ( mouse_wheel_down() - mouse_wheel_up() ) * 0.1;
if ( room == rm_demo4 )
{
	Camera.Zoom = clamp(Camera.Zoom, 0.5, 1);
}	

if ( auto_rotate ) { 
	// Just to keep a rotation going
	Camera.Angle+=0.25;
}

window_set_cursor( Camera.MouseLock ? cr_none : cr_arrow );

// Switch the demo text
switch(room)
{
	case rm_demo1:
		demo_text = "Demo 1 - Static buffers & Dynamic Models";
		demo_desc = "Using fauxton's buffer system, we can create a 'Scene' buffer for static objects AND a 'Grass' buffer and set two separate shaders!";
	break;
	
	case rm_demo2:
		demo_text = "Demo 2 - Particles";
		demo_desc = "Using billboards, we can create some cool particle effects using objects! *NOTE* These are expensive performance wise."
	break;
	
	case rm_demo3:
		demo_text = "Demo 3 - Volumetric Fog";
		demo_desc = "Using a shader, we can get rid of pixels between 0-255 divided by the height of our cube to create height maps";
	break;
	
	case rm_demo4:
		demo_text = "Demo 4 - Lighting";
		demo_desc = "Lighting is a breeze, all we need is to add an instance of 'WorldEnvironment' to our room and up to 64 lights!";
		
		Camera.PitchRange = 20;
		// Set to slow fog
		with ( ob_vfog_control ){
			part_type_size(part_fog, 0.5, 1, 0.01, 0);
			part_type_life(part_fog, 250, 500);
			
			alarm_speed = 120;
			flow_speed = 0.1;	
			alpha = 0.05;
			fog_size.z = 2;
			wave_amount = 2.5;
			
			fog_size.x = room_width*1.5;
			fog_size.y = room_height*1.5;
		}
	break;
}

// Show scene controls GUI event if gui is visible
with ( ob_scene_control )
{
	visible = ob_demo_control.gui_show;	
}