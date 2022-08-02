shader_type spatial;

uniform sampler2D albedo: source_color;
uniform vec4 tint: source_color;

float sobel(sampler2D tex, vec2 uv, vec2 texel) {
	vec2 uvSamples[9];
	uvSamples[0] = uv + vec2(-texel.x, -texel.y);
	uvSamples[1] = uv + vec2(0.0, -texel.y);
	uvSamples[2] = uv + vec2(texel.x, -texel.y);
	uvSamples[3] = uv + vec2(-texel.x, 0.0);
	uvSamples[4] = uv + vec2(0.0, 0.0);
	uvSamples[5] = uv + vec2(texel.x, 0.0);
	uvSamples[6] = uv + vec2(-texel.x, texel.y);
	uvSamples[7] = uv + vec2(0.0, texel.y);
	uvSamples[8] = uv + vec2(texel.x, texel.y);
	
	vec3 colorSamples[9];
	for (int i = 0; i < 9; i++){
		colorSamples[i] = texture(tex, uvSamples[i]).rgb;
	}
	
	vec3 sobel_edge_h = colorSamples[2] + (2.0 * colorSamples[5]) + colorSamples[8] - (colorSamples[0] + (2.0 * colorSamples[3] + colorSamples[6]));
	vec3 sobel_edge_v = colorSamples[0] + (2.0 * colorSamples[1]) + colorSamples[2] - (colorSamples[6] + (2.0 * colorSamples[7] + colorSamples[8]));
	return sqrt(dot(sobel_edge_h, sobel_edge_h) + dot(sobel_edge_v, sobel_edge_v));
}

float sobel2(sampler2D tex, vec2 uv, vec2 texel) {
	vec2 uvSamples[9];
	uvSamples[0] = uv + vec2(-texel.x, -texel.y);
	uvSamples[1] = uv + vec2(0.0, -texel.y);
	uvSamples[2] = uv + vec2(texel.x, -texel.y);
	uvSamples[3] = uv + vec2(-texel.x, 0.0);
	uvSamples[4] = uv + vec2(0.0, 0.0);
	uvSamples[5] = uv + vec2(texel.x, 0.0);
	uvSamples[6] = uv + vec2(-texel.x, texel.y);
	uvSamples[7] = uv + vec2(0.0, texel.y);
	uvSamples[8] = uv + vec2(texel.x, texel.y);
	
	vec3 colorSamples[9];
	for (int i = 0; i < 9; i++){
		colorSamples[i] = texture(tex, uvSamples[i]).rgb;
	}
	
	vec3 sobel_edge_h = colorSamples[2] + (2.0 * colorSamples[5]) + colorSamples[8] - (colorSamples[0] + (2.0 * colorSamples[3] + colorSamples[6]));
	vec3 sobel_edge_v = colorSamples[0] + (2.0 * colorSamples[1]) + colorSamples[2] - (colorSamples[6] + (2.0 * colorSamples[7] + colorSamples[8]));
	return sqrt(dot(sobel_edge_h, sobel_edge_h) + dot(sobel_edge_v, sobel_edge_v));
}

float normal_sobel(sampler2D tex, vec2 uv, vec2 texel) {
	float s = sobel(tex, uv, texel);
	float line_weight = 1.0 - step(clamp(dot(s, s), 0.0, 1.0), 0.9); // module here by normal somehow...
	return line_weight;
}

float color_sobel(sampler2D tex, vec2 uv, vec2 texel) {
	float s = sobel2(tex, uv, texel);
	float line_weight = 1.0 - step(s, 0.1);
	return line_weight;
}

void fragment() {
	vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 1));
	float line_weight = max(
		normal_sobel(SCREEN_TEXTURE, SCREEN_UV, vec2(1.0) / screen_size),
		color_sobel(albedo, UV, vec2(0.1) / screen_size));
	ALBEDO = vec3(1.0 - line_weight) * texture(albedo, UV).rgb * tint.rgb;
}
