function __SYSTEMCAMERAVARS()
{
	// Look Settings
	Pitch = 1;
	Angle = 90;
	Zoom = 1;
	
	// Mouse position (for html5 & mobile)
	mousePos = new vector2(window_mouse_get_x(), window_mouse_get_y());
	mLockP = MouseLock;
	
	// Effects
	Shake = 0;
	
	// Clamps
	PitchRangePosition = 45;
	var p = clamp(PitchRange, 1, 89);
	PitchClamp = new vector2(PitchRangePosition - p*.5, PitchRangePosition + p*.5);
	ZoomClamp  = new vector2(0.5, 2);
	
	// Enablers
	enable_pitch = true;
	enable_angle = true;
	
	// Interpolate settings
	pTo=Pitch;
	aTo=Angle;
	zTo=Zoom;
	
	// Directional
	Forward = 0;
	Backward = 0;
	Right = 0;
	Left = 0;
	
	// Gamepad device
	Device = 0;
	
	// Sensitivity Settings
	Sens = {
		Mouse		: new vector2(.05, .05),
		Joystick	: new vector2(1, 2)
	}
	
	// Viewport Settings
	VPort = {
		index : Viewport,
		size : new vector2(Width, Height)
	}
	AppSurf = {
		width : surface_get_width(Width),
		height : surface_get_height(Height)
	}
	
	// Camera Settings
	ThisCamera = view_camera[VPort.index];
	
	// Platform settings
	is_html = os_browser != browser_not_a_browser;
	is_phone = ( os_type == os_android || os_type == os_winphone || os_type == os_ios );
}
function camera_initialize()
{
	// Setup our variables
	__SYSTEMCAMERAVARS();
	
	// Setup GPU state
	layer_force_draw_depth(true, 0);
	gpu_set_alphatestenable(true);
	gpu_set_tex_filter(false);
	gpu_set_zwriteenable(true);
	gpu_set_ztestenable(true);
	
	// application surface management
	application_surface_draw_enable(false);

	display_set_gui_size(window_get_width(), window_get_height());
		
	// Setup viewport and camera size
	view_enabled				= true;
	view_visible[VPort.index]	= true;

	__init = false;
	// Update functions
	function camera_update(){
		
		// Set view resolution
		var vsx = Width * RENDER_QUALITY;
		var vsy = Height * RENDER_QUALITY;
		
		// Maximum size of 8k
		// Minimum size of 0.12k
		vsx = clamp(vsx, 160, 7680); 
		vsy = clamp(vsy, 90, 4320);
		
		surface_resize(
			application_surface,
			vsx,
			vsy
		);
		
		if ( AppSurf.width != vsx || AppSurf.height != vsy ){
			
			AppSurf.width = vsx;
			AppSurf.height = vsy;
		}
		
		#region GETSET { Camera-look values }
			// First setup
			if ( !__init ){
			
				if ( Target != noone ){
					x = Target.x;
					y = Target.y;
				}
			
				__init = true;
			}
		
			// Check for target & interpolate
			if ( Target != noone ){
				x = lerp(x, Target.x, Speed);
				y = lerp(y, Target.y, Speed);
			}
		
			// Mouse looking
			if ( MouseLock ){ // OTHER
				if ( !is_html && !is_phone ){
					// Set interpolation values
					Angle -= (
						( ( window_width * .5 ) - window_mouse_get_x() ) * Sens.Mouse.x * Sensitivity * LookAxisH
					);
					Pitch -= (
						( ( window_height * .5 ) - window_mouse_get_y() ) * Sens.Mouse.y * Sensitivity * LookAxisV
					);
					// Set mouse
					window_mouse_set( window_width * .5, window_height * .5 );
				} 
				else 
				{	// HTML5 & Mobile
					if ( mLockP != MouseLock )
					{
						mLockP = MouseLock;
						mousePos = new vector2(window_mouse_get_x(), window_mouse_get_y());
					}
					var _a = 2;
					if ( is_phone ) { _a = 4; }
					Angle -= ( 
						( mousePos.x - window_mouse_get_x() ) * Sens.Mouse.x * Sensitivity * LookAxisH * _a
					);
					Pitch -= (
						( mousePos.y - window_mouse_get_y() ) * Sens.Mouse.y * Sensitivity * LookAxisV * _a
					);
				}
			}
			mLockP = MouseLock;
			mousePos = new vector2(window_mouse_get_x(), window_mouse_get_y());
		
			// Joystick looking
			Pitch -= ( gamepad_axis_value( Device, gp_axisrv) ) *Sens.Joystick.x *Sensitivity *LookAxisV;
			Angle += ( gamepad_axis_value( Device, gp_axisrh) ) *Sens.Joystick.y *Sensitivity *LookAxisH;
			
			// Clamp values
			var p = clamp(PitchRange, 1, 89);
			PitchClamp = new vector2(PitchRangePosition - p*.5, PitchRangePosition + p*.5);
			
			Pitch = clamp(Pitch, PitchClamp.x, PitchClamp.y);
			Zoom = clamp(Zoom, ZoomClamp.x, ZoomClamp.y);
			
			// Interpolate
			if ( enable_angle ){ aTo = lerp(aTo, Angle, Interpolation); }
			if ( enable_pitch) { pTo = lerp(pTo, Pitch, Interpolation); }
			zTo = lerp(zTo, Zoom, Interpolation); 
			Shake = lerp(Shake, 0, 0.1);
			
			// Update viewport
			VPort.size.x = Width * zTo;
			VPort.size.y = Height * zTo;
						
		#endregion
		#region UPDATE { Camera : Pos, Size, Yaw }

		// Build projection
		var dis = 1;
		var xto = x+dis * dcos(aTo) * dcos(pTo);
		var yto = y+dis * dsin(aTo) * dcos(pTo);
		var zto = dis*dsin(pTo);
		var xx = x;
		var yy = y;
		var zz = 0;
		
		function shakeRand(){
			if ( Shake > 0.3 ){
				return random_range(-Shake, Shake);
			}
			return 0;
		}
		var shx = shakeRand();
		var shy = shakeRand();
		var shz = shakeRand();
		
		xx += shx;
		yy += shy;
		zz += shz;
		xto += shx;
		yto += shy;
		zto += shz;
		
		// Build and set projection
		var ProjMat = matrix_build_projection_ortho(VPort.size.x, -VPort.size.y, -10000, 10000);
		camera_set_proj_mat(ThisCamera, ProjMat);
		var LookMat = matrix_build_lookat(xto, yto, zto, xx, yy, zz, 0, 0, 1);
		camera_set_view_mat(ThisCamera, LookMat);

	#endregion
		#region UPDATE { Camera : Dir Values }
			
			Right = -aTo;
			Forward = -aTo+90;
			Left = -aTo+180;
			Backward = -aTo+270;
			
		#endregion
	}
	camera_update();
}