shader_type spatial;

void fragment() {
	ALBEDO = vec3(mod(UV, 1.0), 0.0);
}
