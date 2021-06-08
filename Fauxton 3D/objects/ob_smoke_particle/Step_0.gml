// Growing & shrinking
grow += 360 / life;
if ( grow > life * .25 )
{
	can_die = true;	
}
scale = size / sprite_width * dsin(grow);

// Destroy ourselves
if ( can_die && grow >= 180 )
{
	instance_destroy();	
}

// Z movement
// Check for ground
if ( z <= ground_z ){
	// Bounce
	if ( zspeed < 0 )
	{
		zspeed *= -0.5;	
	}
} else {
	// Gravity
	zspeed -= zgrav;
}

// Update z position
z += zspeed;
