shader_type spatial;

uniform vec3 color: source_color;

void fragment() {
	ALBEDO = color;
}

void light() {
	float att = ATTENUATION * max(0.0, dot(NORMAL, LIGHT));
	DIFFUSE_LIGHT += vec3(step(0.001, att));
}
