shader_type sky;

uniform sampler2D background_noise;
uniform sampler2D noise_noise;

void fragment() {
	vec2 uv = abs(2.*UV*SCREEN_PIXEL_SIZE-vec2(1.)); // 2.*UV-vec2(1.);
	vec2 offset = vec2(TIME/200.);
	offset = vec2(0.);
	COLOR=vec4(offset,0.,1.);
	COLOR = texture(background_noise, UV);
	// COLOR = vec4(uv, 0., 1.);
}
