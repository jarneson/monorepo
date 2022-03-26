shader_type spatial;
render_mode unshaded;

void fragment() {
	ALBEDO = step(vec3(0.1), NORMAL);
}
