// When this object is created/instanced it will
// create a large explosion!

// Shake the camera
Camera.Shake = 3;

// Create explosion particles
var _amount = irandom_range(3, 5);
var _damt = 360/_amount;
var _d = 0;
var _explcol = c_ltgray;

for ( var i=0; i<_amount; i++ )
{
	// Flying explosions
	var xx = x + random_range(-12, 12);
	var yy = y + random_range(-12, 12);
	
	var part = instance_create_layer(xx, yy, layer, ob_debris_particle);	
	part.z = random_range(4, 10);
	part.zspeed = random_range(2, 6);
	part.life = random_range(80, 120);
	part.zgrav = 0.2;
	part.direction = _d;
	part.speed = random_range(2, 4);
	part.size = random_range(5, 15);
	part.image_blend = c_white;
	
	// Set smoke particles to be created
	part.emitter = true;
	part.emitter_part_set(
		ob_smoke_particle, 
		random_range(60, 80),
		part.size*1.5,
		0,0, 0.2, 0, choose($3A2A17, $5E4424)
	);
	
	// Ground explosion poofs
	var xx = x;
	var yy = y;

	var part = instance_create_layer(xx, yy, layer, ob_smoke_particle);	
	part.life = random_range(60, 120);
	part.size = random_range(20, 40);
	part.z = part.size*.5;
	part.speed = random(1);
	part.direction = random(360);
	part.image_blend = _explcol;
	
	// random bits of debris
	var xx = x + random_range(-12, 12);
	var yy = y + random_range(-12, 12);
	
	var part = instance_create_layer(xx, yy, layer, ob_debris_particle);	
	part.z = random_range(4, 10);
	part.zspeed = random_range(2, 6);
	part.life = random_range(80, 120);
	part.zgrav = 0.2;
	part.direction = random(360);
	part.speed = random_range(2, 5);
	part.size = random_range(2, 8);
	part.image_blend = $509ce9;
	
	_d += _damt;
}
// Destroy us, no longer needed
instance_destroy();