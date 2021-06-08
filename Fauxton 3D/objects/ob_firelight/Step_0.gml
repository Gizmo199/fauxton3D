// Make our 'firelight' point light flicker color and range
// at random iterations
var rand = irandom_range(0, 3);
if ( rand == 1 )
{
	toRange = random_range(100, 200);
}

toHue = random_range(0, 25);
// Interpolate our hue and range
hue = lerp(hue, toHue, 0.2);
range = lerp(range, toRange, 0.1);

// Set our color
color = make_color_hsv(hue, 255, random_range(180, 255));