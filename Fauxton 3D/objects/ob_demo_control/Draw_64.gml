// Set the font
draw_set_font(fnt_demo_font);

// Transition
with ( ob_demo_transition ) { event_user(0); }

// Vignette
draw_sprite_stretched_ext(sp_ui_vignette, 0, 0, 50 * gui_show, gui_width, gui_height-( 32 * gui_show ), c_white, 0.3);

draw_set_color($0f0f0f);
draw_rectangle(0,0,120,50,false);

guiButton.y = lerp(guiButton.y, 20 + (50 * gui_show), 0.2);
guiButton.text = gui_show ? "Hide GUI" : "Show GUI";
guiButton.draw();
if ( !gui_show )
{
	draw_set_color(text_color);
	draw_set_valign(fa_top);
	draw_set_halign(fa_center);
	var f = FPS_REAL;
	if ( is_phone || is_html ) { f = fps; }
	draw_text(60, 15, "FPS: "+string(round(f)));
}

if ( room == rm_demo3 )
{
	fogButton.text = ( fog_setting ? "Fog" : "Clouds" );
	fogButton.draw();	
	fogWaveButton.text = "Waves "+(wave_amount ? "On" : "Off");
	fogWaveButton.draw();
	
	if ( gui_show && !is_phone )
	draw_sprite_ext(sp_ui_mouse_prompt_click, 0, fogButton.width, fogButton.y, 1, 1, 0, c_white, abs(sin(current_time/400)) );
}

if ( room == rm_demo2 )
{
	explodeButton.draw();	
	if ( gui_show && !is_phone )
	draw_sprite_ext(sp_ui_mouse_prompt_click, 0, explodeButton.width, explodeButton.y, 1, 1, 0, c_white, abs(sin(current_time/400)) );
}

if ( !gui_show ) { exit; }

nextButton.draw();
prevButton.draw();
if ( !is_html && !is_phone ){
	exitButton.draw();
} else {
	rotButton.x = gui_width-(rotButton.width*.5);
}
rotButton.draw();

if ( !is_phone ){
	for ( var i=0; i<array_length(renderButtons); i++ )
	{
		renderButtons[i].draw();	
	}
}

if ( room == rm_demo4 )
{
	controlsButton.draw();	
}

draw_set_color($0f0f0f);
draw_rectangle(0, 0, gui_width,  50, false);
draw_rectangle(0, gui_height, gui_width, gui_height-32, false);

if ( !is_phone ){
	draw_rectangle(0, gui_height-30, 160, gui_height-71, false);
	draw_rectangle(0, gui_height-70, 160, gui_height-112, false);
}

draw_set_color(text_color);
draw_set_valign(fa_top);
draw_set_halign(fa_left);

if ( !is_phone ){
	draw_text(10, gui_height-60, "Resolution "+string(RENDER_QUALITY*100)+"%");
	draw_text(10, gui_height-100, "Fidelity "+string(RENDER_FIDELITY));
	draw_text(10, gui_height-140, "Render Settings");
}

draw_text( 10, 5, @"FPS: "+string(fps)+@"
FPS_REAL: "+string(round(FPS_REAL)));

var _ind = 0;
if ( is_html ) { _ind = 1; }
if ( is_phone ) { _ind = 2; }
draw_sprite(sp_ui_mouse_prompts, _ind, gui_width-10, 0);


draw_set_halign(fa_center);
draw_text(gui_width*.5, 15, demo_text);

if ( !is_phone ){
	draw_set_valign(fa_bottom);
	draw_text(gui_width*.5, gui_height-5, demo_desc);
}

draw_set_alpha(1);
