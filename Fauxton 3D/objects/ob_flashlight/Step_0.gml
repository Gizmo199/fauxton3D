if ( instance_exists(ob_player) )
{
	// Lerp our direction to the players direction
	var ad = angle_difference(angle, -ob_player.direction);
	var angle_lerp_speed_min = 6;
	angle -= min(abs(ad), angle_lerp_speed_min) * sign(ad);
	
	// Set our x/y position to the players position
	x = ob_player.x;
	y = ob_player.y;
}	