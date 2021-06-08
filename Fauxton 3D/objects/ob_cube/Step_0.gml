image_angle++;
z = ( height*.25 ) + sin(current_time/250) * ( height*.25);
fauxton_model_set( model, x, y, z, 0, 0, image_angle, 1, 1, 1);
