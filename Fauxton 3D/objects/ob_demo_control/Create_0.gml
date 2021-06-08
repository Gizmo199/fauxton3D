// Platform settings
is_phone = ( os_type == os_android || os_type == os_winphone || os_type == os_ios )
is_html = ( os_browser != browser_not_a_browser );

gamepad_set_axis_deadzone(0, 0.2);

// Create the camera
instance_create_layer(room_width*.5, room_height*.5, layer, Camera);

// Camera Size
Camera.Width = 640;					// The width of our view
Camera.Height = 360;				// The height of our view

// Set a default angle
Camera.Angle = 45;					// Set the angle
Camera.aTo = Camera.Angle;			// The 'interpolation' value must be set or the angle will just lerp to 0

// Set Camera pitch stuff
Camera.PitchRangePosition = 25;		// A lower starting point for our pitch range (default is 45)
Camera.Pitch = 22.5;				// Set the pitch
Camera.pTo = Camera.Pitch;			// The 'interpolation' value must be set or the pitch will just lerp to 45
Camera.PitchRange = 20;				// Set the pitch range

if ( !variable_global_exists("AutoRot") ){
	global.AutoRot = false;
}
auto_rotate = global.AutoRot;

// Create the floor
if ( room != rm_demo1 && room != rm_demo4 ){
	var spr = sp_demo_ground;
	fauxton_model_create(spr, room_width*.5, room_height*.5, -0.1, 0, 0, 0, room_width/sprite_get_width(spr), room_height/sprite_get_height(spr), 1);
}

// Show the gui
gui_show = true;

// Text for what demo
text_color = $509ce9;
demo_text = "";
demo_desc = "Description";
FPS_REAL = fps_real;
alarm[0] = 6;

// Button function
function button(_t, _x, _y, _w, _h, _s) constructor
{
	text = _t;
	x = _x;
	y = _y;
	width = _w;
	height = _h;
	hover = false;
	scr = _s;
	invert_color = false;
	
	static update = function()
	{
		if ( room = rm_demo1 && text == "<" ) { exit; }
		if ( room = room_last && text == ">" ) { exit; }
		var ms = new vector2(window_mouse_get_x(), window_mouse_get_y());
		if ( point_in_rectangle(ms.x, ms.y, x-width*.5, y-height*.5, x+width*.5, y+height*.5) )
		{
			hover = true;
			window_set_cursor(cr_handpoint);
			if ( scr != -1 )
			{
				scr();	
			}
		} else 
		{
			hover = false;	
		}
	}	
	static draw = function()
	{
		update();
		var c1 = $0F0F0F;
		var c2 = other.text_color;
		if ( invert_color )
		{
			var c = [c1, c2]
			c1 = c[1];
			c2 = c[0];
		}
		if ( room = rm_demo1 && text == "<" ) { exit; }
		if ( room = room_last && text == ">" ) { exit; }
		draw_set_color(c1);
		draw_set_alpha(hover==true ? 1 : 0.4);
		draw_rectangle(x-width*.5, y-height*.5, x+width*.5, y+height*.5, false);
		
		draw_set_alpha(1);
		draw_set_color(hover ? $6e7a28 : c2);
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		draw_text(x, y, text);
	}
}

// Demo change & exit
function demo_change(){
	other.demo_desc = ( text == ">" ? "Next Demo" : "Previous Demo" );
	if ( instance_exists(ob_demo_transition) ) { exit; }
	if ( mouse_check_button_pressed(mb_left) )
	{
		if ( room_exists(room_next(room)) && text == ">" )
		{ 
			var ins = instance_create_layer(0,0,other.layer,ob_demo_transition);
			ins.dir = -1;
			room_goto_next();
		}
		if ( room_exists(room_previous(room)) && text == "<" )
		{ 
			var ins = instance_create_layer(0,0,other.layer,ob_demo_transition);
			ins.dir = 1;
			room_goto_previous(); 
		}
	}	
}
function end_game(){
	other.demo_desc = "Exit Demo";
	if ( mouse_check_button_pressed(mb_left) )
	{
		game_end();
	}
}
function auto_rot(){
	other.demo_desc = "Turn Auto-rotation " + (other.auto_rotate ? "Off" : "On" );
	if ( mouse_check_button_pressed(mb_left) )
	{
		other.auto_rotate = !other.auto_rotate;
		global.AutoRot = other.auto_rotate;
	}	
}
var db_sizex = 40;
var db_sizey = 120;
if ( is_phone )
{
	db_sizex = 40;
	db_sizey = 99;
}
nextButton = new button(">", display_get_gui_width()-20, display_get_gui_height()*.5, db_sizex, db_sizey, demo_change);
prevButton = new button("<", 20, display_get_gui_height()*.5, db_sizex, db_sizey, demo_change);
exitButton = new button("x", display_get_gui_width()-20, 70, 40, 40, end_game);
rotButton  = new button("Auto-Rotate", display_get_gui_width()-101, 70, 120, 40, auto_rot);

function clp(){ RENDER_QUALITY = clamp(RENDER_QUALITY, 1, 8); RENDER_FIDELITY = clamp(RENDER_FIDELITY, 1, 8); }
var	qAdd = function(){ other.demo_desc = "Increase Resolution | Pixel Mode: 100% | High Quality: 400+% (Higher = Slower)"; if mouse_check_button_pressed(mb_left) RENDER_QUALITY++; clp(); }
var qSub = function(){ other.demo_desc = "Decrease Resolution | Pixel Mode: 100% | High Quality: 400+% (Higher = Slower)"; if mouse_check_button_pressed(mb_left) RENDER_QUALITY--; clp(); }
var fAdd = function(){ other.demo_desc = "Increase Model Fidelity | Recommended: 2+ (Higher = Slower)"; if mouse_check_button_pressed(mb_left) RENDER_FIDELITY++; clp(); }
var fSub = function(){ other.demo_desc = "Decrease Model Fidelity | Recommended: 2+ (Higher = Slower)"; if mouse_check_button_pressed(mb_left) RENDER_FIDELITY--; clp(); }

renderButtons = [ 
	new button("-", 180, gui_height-50, 40, 40, qSub),
	new button("+", 221, gui_height-50, 40, 40, qAdd),
	new button("-", 180, gui_height-91, 40, 40, fSub),
	new button("+", 221, gui_height-91, 40, 40, fAdd)
];

var show_gui = function(){ 
	other.demo_desc = ( other.gui_show ? "Hide GUI Elements (Increases performance)" : "Show GUI Elements" ); 
	if ( mouse_check_button_pressed(mb_left) )
	{
		other.gui_show = !other.gui_show;
	}
}
guiButton = new button("GUI", gui_width*.5, 70, 120, 40, show_gui);

function control_show(){
	var _x = gui_width*.5;
	var _y = gui_height*.5;
	draw_set_color($0f0f0f);
	draw_rectangle(_x-200, _y-100, _x+200, _y+100, false);
	draw_set_color(other.text_color);
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	draw_text( _x, _y, "Move player - [WASD] or Left-Joystick");
}
controlsButton = new button("Controls", 50, 70, 100, 40, control_show);

// Controls and settings
#region Demo 2
function explosion_create()
{
	other.demo_desc = "Create an explosion!";
	if ( mouse_check_button_pressed(mb_left) )
	{
		var xx = ( room_width * .5 ) + random_range(-50, 50);
		var yy = ( room_height * .5 ) + random_range(-50, 50);
		instance_create_layer(xx, yy, other.layer, ob_explosion);
	}
}
explodeButton = new button("+ Explosion", 60, 70, 120, 40, explosion_create);

#endregion
#region Demo 3

	fog_setting = 0;
	wave_amount = 0;
	
	// Clouds or fog settings
	function fog_change(){
		other.demo_desc = ( other.fog_setting ? "Change to 'Clouds' > Sharp & Fast" : "Change to 'Fog' > Smooth & Slow" );
		if ( mouse_check_button_pressed(mb_left) )
		{
			other.fog_setting = !other.fog_setting;
			with ( ob_vfog_control ){ part_particles_clear(part_sys); }
			if ( other.fog_setting == 1 ) {
				with ( ob_vfog_control ){
					// Smooth and slow
					part_type_size(part_fog, 0.5, 1, 0.01, 0);
					part_type_life(part_fog, 250, 500);
					
					alarm_speed = 120;
					flow_speed = 0.5;	
					alpha = 0.125;
				}
			} else {
				with ( ob_vfog_control ){
					// Sharp and fast
					part_type_size(part_fog, 0.01, 0.5, 0.001, 0);
					part_type_life(part_fog, 60, 120);
					
					alarm_speed = 1;
					flow_speed = 1;	
					alpha = 0.11;
				}
			}
			ob_vfog_control.alarm[0] = 2;
		}		
	}
	function fog_wave_change(){
		other.demo_desc = "Turn waves on or off";
		if ( mouse_check_button_pressed(mb_left) )
		{
			// Turn waves on or off
			other.wave_amount = !other.wave_amount;
			with ( ob_vfog_control )
			{
				wave_amount = ob_demo_control.wave_amount * 2.5;
			}
		}
	}
	fogButton = new button("Change Fog", 60, 70, 120, 40, fog_change);
	fogWaveButton = new button("Waves", 60, 111, 120, 40, fog_wave_change);
	
#endregion