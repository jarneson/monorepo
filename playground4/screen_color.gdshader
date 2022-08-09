shader_type spatial;
render_mode unshaded, cull_disabled;

void vertex() {
	POSITION = vec4(VERTEX, 1.);
}
void fragment() {
	ALBEDO = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
}
