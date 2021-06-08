///@desc Animation

// Set animation
if ( speed > 0.5 ) { leg_anim = "run"; } else { leg_anim = "idle"; }

// Normalized directional value of the camera
var cdir = abs(Camera.Angle) % 360;
if ( Camera.Angle < 0 )
{
	cdir = 360-cdir;	
}
// This will give us a value of our direction
// in increments of 0-7 (8 directions) in relation 
// to the cameras rotation
var index_dir = round( ( direction+270 ) + cdir ) / 45;
image_index = index_dir;

switch(leg_anim)
{
	case "idle":
		// Set our idle leg animation
		leg_spr = sp_pl_idle;
		
		// Set the image index
		leg_ind = index_dir;
	break;
	
	case "run":
		// Create an array for easy access
		// to our sprite assets by assigning
		// a string to each directional value from index_dir
		var spr_name = "sp_pl_run_";
		var spr_dir_array = ["e", "ne", "n", "nw", "w", "sw", "s", "se"];
		
		// Set our run leg animation
		leg_spr = asset_get_index( spr_name + spr_dir_array[ index_dir % 8 ] );
		leg_ind += anim_speed;
	break;
}
// make body bob up and down
if ( leg_anim == "run" ){
	var _i = floor(leg_ind) % 10;
	if ( _i == 3 || _i == 8 ){
		body_z = -3;
	}
}
body_z = lerp(body_z, z, 0.2);