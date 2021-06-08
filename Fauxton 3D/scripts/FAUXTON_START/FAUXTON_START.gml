// Display macros
#macro display_width display_get_width()
#macro display_height display_get_height()
#macro window_width window_get_width()
#macro window_height window_get_height()
#macro gui_width display_get_gui_width()
#macro gui_height display_get_gui_height()

// Rendering macros
global.__fRQ = 2;
global.__fRF = 2;
#macro RENDER_QUALITY global.__fRQ
#macro RENDER_FIDELITY global.__fRF

function FAUXTON_START() {
	///@func FAUXTON_START(*resolution, *fidelity)
	
	// Create our default render pipeline if
	// one does not already exist in the room
	if ( !instance_exists(RenderPipeline) )
	{
		var RP = instance_create_depth(	0, 0, 0, RenderPipeline);
		if ( RP.RenderShader == noone )
		{
			RP.RenderShader = shd_default;
		}	
	}
	
	// Change resolution of the game
	if ( argument_count > 0 ){
		RENDER_QUALITY = argument[0]; 	
	}
	
	// Change the fidelity of the models
	// Larger -> Better quality / worse performance
	if ( argument_count > 1 ){
		RENDER_FIDELITY = argument[1];
	}	
}
