shader_type canvas_item;

void fragment() {
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV) * vec4(1.0, 0.0, 0.0, 1.0);
}
