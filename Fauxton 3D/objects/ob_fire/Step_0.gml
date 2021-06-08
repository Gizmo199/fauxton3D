// Create a random range around us
var xx = x + random_range(-2, 2);
var yy = y + random_range(-2, 2);

// Create smoke particles
var chs = irandom_range(0, 3);
if ( chs == 1 )
{
	var part = instance_create_layer(xx, yy, layer, ob_smoke_particle);
	part.image_blend = $4D4D4D;
	part.size = random_range(5, 15);
	part.life = random_range(60, 120);
	part.z = random_range(15, 25);
	part.zspeed = random_range(1, 1.5);
}

// Create our fire particles
var chs = irandom_range(0, 3);
if ( chs == 1 ){
	var part = instance_create_layer(xx, yy, layer, ob_fire_particle);
	part.size = random_range(10, 20);
	part.z = random_range(0, 10);
	part.life = random_range(20, 80);
	part.zspeed = random_range(.5, .8);
	part.image_index = irandom(part.image_number);
	part.image_blend = choose($634FBD, $65C1F2);
	part.image_speed = random_range(0.4, 0.6);
	part.image_angle = random(360);
}