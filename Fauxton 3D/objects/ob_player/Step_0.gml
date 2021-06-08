// Input
var _h = ( keyboard_check(ord("D")) - keyboard_check(ord("A")) );
var _v = ( keyboard_check(ord("S")) - keyboard_check(ord("W")) );

_h += gamepad_axis_value(0, gp_axislh);
_v += gamepad_axis_value(0, gp_axislv);

_h = clamp(_h, -1, 1);
_v = clamp(_v, -1, 1);

var moving = false;
if ( _h != 0 || _v != 0 ) { moving = true; }

// Movement
if ( moving )
{
	direction = point_direction(0, 0, _h, _v) + Camera.Forward;
}
speed = lerp(speed, moving * max_speed, fric);

// Scale ground and make it follow us
if ( instance_exists(ob_ground_ref) )
{
	ob_ground_ref.x = x;
	ob_ground_ref.y = y;
}