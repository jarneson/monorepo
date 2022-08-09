shader_type spatial;
render_mode unshaded;

uniform sampler2D color_buffer;

void fragment() {
	ALBEDO = texture(color_buffer, SCREEN_UV).rgb;
}
