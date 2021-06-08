// Draw our shadow surface
matrix_set(matrix_world, shadow_matrix);
draw_surface_ext(shadow_surface, 0, room_height, 1, -1, 0, c_black, .1);
matrix_reset();