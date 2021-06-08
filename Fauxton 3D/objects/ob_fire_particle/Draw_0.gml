// Draw our fire particle NOT facing the camera at all times
// This will have the 'cardboard cutout' effect
// where our flames will face at all random angles
draw_sprite_3d_ext(sprite_index, image_index, x, y, z, 0, 90, image_angle, scale, scale, scale, image_blend, image_alpha, false);
