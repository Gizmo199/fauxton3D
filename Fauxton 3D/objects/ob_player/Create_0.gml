// Set the camera to us
Camera.Target = id;

// Movement
direction = 270;
max_speed = 1.5;
fric = 0.4;
z = 0;

// Animation
anim_speed = 0.3;
leg_anim = "idle";
leg_spr = sp_pl_idle;
leg_ind = 6;
body_z = z;
image_speed = 0;
image_index = 6;

// Create our flashlight
instance_create_layer(x, y, layer, ob_flashlight);