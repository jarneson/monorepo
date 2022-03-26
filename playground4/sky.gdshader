shader_type sky;

uniform sampler2D background_noise;

void sky() {
	vec2 offset = texture(background_noise, SKY_COORDS+vec2(TIME/120.)).xy;
	COLOR = vec3(.01, 0., .05) * texture(background_noise, (SKY_COORDS+offset)+vec2(TIME/20.)).rgb;
	float top_fade = clamp(SKY_COORDS.y/.4, 0., 1.);
	float bottom_fade = clamp((1.-SKY_COORDS.y)/.4, 0., 1.);
	COLOR = COLOR * top_fade * bottom_fade;
	COLOR = COLOR;
}
