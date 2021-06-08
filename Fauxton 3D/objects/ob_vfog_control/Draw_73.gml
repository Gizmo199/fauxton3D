// ** Anything involving alpha should always be in the 'draw end' event **

// This shader deletes pixels between 0-255 by calculating the
// z position of each pixel based on the amount of layers.
// Forumla: zPos = ( 255 / amount_of_layers ) * vertex_z_position
// It then checks if the value of the color is less than 'zPos'
// and if so it will set that pixels alpha to 0
shader_set(shader);
shader_set_uniform_f(uniform.height, layers);
shader_set_uniform_f(uniform.alpha, alpha);
shader_set_uniform_f(uniform.time, flow * 0.01);
shader_set_uniform_f(uniform.amount, wave_amount);

// Set additive blending
gpu_set_blendmode(blend);
fauxton_model_draw_override(fog_cube);
gpu_set_blendmode(bm_normal);

shader_reset();