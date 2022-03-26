shader_type sky;

uniform sampler2D background_noise;

void sky() {
	vec2 offset = 2.0*texture(background_noise, SKY_COORDS+vec2(TIME/120.)).xy-vec2(1.0);
	COLOR = vec3(.005, 0., .01) * texture(background_noise, (SKY_COORDS+offset)+vec2(TIME/20.)).rgb;
	float top_fade = clamp(SKY_COORDS.y/.4, 0., 1.);
	float bottom_fade = clamp((1.-SKY_COORDS.y)/.4, 0., 1.);
	
	vec3 horiz_line_color = vec3(0., 25.*step(fract(SKY_COORDS.y*256.0), 0.02), 0.0);
	float horiz_line_offset = 2.0 * texture(
		background_noise,
		fract(SKY_COORDS.yy*4.)).y - 1.0;
	horiz_line_offset *= 25.0;
	horiz_line_color *= (abs(sin(TIME))+1.)*0.0001 + smoothstep(0.01, -0.01,
		abs(
			SKY_COORDS.x -
			abs(
				fract(
					TIME * sign(horiz_line_offset) * clamp(
							texture(background_noise, SKY_COORDS.yy).y,
							0.01, 0.05
					) + horiz_line_offset* sign(horiz_line_offset)
				)
			)
		)
	)*0.006;
	
	vec3 vert_line_color = vec3(0., 25.*step(fract(SKY_COORDS.x*512.0), 0.04), 0.0);
	float vert_line_offset = 2.0 * texture(
		background_noise,
		fract(SKY_COORDS.xx*4.)).y - 1.0;
	vert_line_offset *= 25.0;
	vert_line_color *= (abs(sin(TIME))+1.)*0.0001 + smoothstep(0.02, -0.02,
		abs(
			SKY_COORDS.y -
			abs(
				sin(
					TIME * clamp(
							texture(background_noise, SKY_COORDS.xx).y,
							0.01, 0.03) + 
					vert_line_offset
				)
			)
		)
	)*0.003;
	// line_color /= abs(sin(TIME*SKY_COORDS.y));
	COLOR = max(max(COLOR, horiz_line_color), vert_line_color);
	COLOR = COLOR * top_fade * bottom_fade;
	COLOR = COLOR * 5.0;
}
