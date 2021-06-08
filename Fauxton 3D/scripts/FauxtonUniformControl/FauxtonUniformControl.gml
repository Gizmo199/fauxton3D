/*

		------------------------- NOTE -------------------------
		
		This script is now OPTIONAL! This script has been left in for now
		but might be later gotten rid of in future versions of fauxton.
		It is advised instead to use:
		
			fauxton_buffer_set_uniform_script(buffer_name, script)
			
		for your buffer shader uniform controls instead!
			
		-------------------------------------------------------
	
*/

function FauxtonUniformControl(shader){
	/*					---		IMPORTANT	  --- 

	**DO NOT CHANGE THE NAME OF THIS SCRIPT!! THIS FUNCTION IS USED INTERNALLY WITH THE
	RENDER PIPELINE FOUND HERE (if you do wish to change the name):
		
		Engine > 
			System > 
				Libraries > 
					lib_RenderPipelineScripts > 
						pipeline_initialize() > 
							render_buffer_maps()
	*/
	#region About
	/*
	HERE IS WHERE YOU NEED TO MANAGE SHADER UNIFORM SETTINGS
	When creating static buffers you can set personal shaders for them
	all you need to do is check that the 'shader' value is equal
	to the shader and set values below
	
		Example:
	
		switch(shader)
		{
			case shd_alpha:
				var uni = shader_get_uniform(shd_alpha, "amount")
				shader_set_uniform_f(uni, 0.5);
			break;
		}
		
		and BOOM! When 'shd_alpha' is called/set for a particular static
		buffer this script will automatically alter the values! Its that easy! :D
	
	*/
	#endregion
	switch(shader)
	{
		default: break;
		
		//case Example_Shader:
		//	var Example_Uniform = shader_get_uniform(Example_Shader, "Example Uniform");
		//	shader_set_uniform_f(Example_Uniform, 1.0 );
		//break;
		
	}

}