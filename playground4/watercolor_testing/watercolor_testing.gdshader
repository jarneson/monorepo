shader_type spatial;

uniform vec3 color: source_color;
uniform sampler2D shadow_noise;
uniform sampler2D attenuation_ramp;
uniform sampler2D color_ramp;

void fragment() {
	// ALBEDO = texture(color_ramp, vec2(0.0, 0.0)).rgb;
	// ALBEDO = vec3(UV, 0.0);
	ALBEDO = color;
}

void light() {
	float att = ATTENUATION * max(0.0, dot(LIGHT, NORMAL));
	att += att * pow(texture(shadow_noise, UV).r, 4.0);
	float clamped_att = clamp(att, 0.01, 0.99);
	DIFFUSE_LIGHT += att*texture(color_ramp, vec2(clamped_att)).rgb * LIGHT_COLOR;
}
