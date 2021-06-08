// Draw a background color
var gstate = gpu_get_state();
gpu_set_state(gm_DefaultState);

draw_set_color( room != rm_demo4 ? $52391B : $5C6628);
draw_rectangle(-10000, -10000, 10000, 10000, false);

gpu_set_state(gstate);
ds_map_destroy(gstate);