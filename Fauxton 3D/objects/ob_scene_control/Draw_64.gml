// Here is an example of how you can check that your buffers are loaded.
// You might want to make a loading screen, in which case
// You will need to have a reference to the buffers 
// or get a reference using 'fauxton_buffer_get("buffer_name")'

draw_set_halign(fa_right);
draw_set_valign(fa_bottom);
draw_text(gui_width-10, gui_height-32, 

@"Tree buffer :"+( TreeBuff.loaded ? " Loaded!" : " Loading...") + @"
 Grass buffer :"+( GrassBuff.loaded ? " Loaded!" : " Loading...") + @"
 Scene buffer :"+( SceneBuff.loaded ? " Loaded!" : " Loading...")

);	

//** NOTE **//
// The visibility of this object is controlled by 'ob_demo_control' in the begin step event