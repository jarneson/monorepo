shader_type spatial;

void fragment() {
	ALBEDO = texture(SCREEN_TEXTURE, SCREEN_UV).rgb * vec3(1.0, 0.0, 0.0);
}
