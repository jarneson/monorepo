shader_type spatial;

uniform float albedo_scale = 1.0;
uniform sampler2D albedo: source_color;
uniform vec4 tint: source_color;
uniform float depth_width = 1.5;
uniform float depth_threshold = 0.9;
uniform float normal_width = 1.0;
uniform float normal_threshold = 0.9;
uniform float color_width = 0.1;
uniform float color_threshold = 0.1;

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

float color_sobel(sampler2D tex, vec2 uv, vec2 texel) {
	float s = sobel2(tex, uv, texel);
	float line_weight = 1.0 - step(s, color_threshold);
	return line_weight;
}

float linear_depth(sampler2D depth_texture, vec2 uv, mat4 inv_proj) {
	float depth = texture(depth_texture, uv).x;
	vec3 ndc = vec3(uv * 2.0 - 1.0, depth);
	vec4 view = inv_proj*vec4(ndc, 1.0);
	view.xyz /= view.w;
	return -view.z;
}

float depth_sobel(sampler2D depth_texture, vec2 uv, vec2 texel, mat4 inv_proj) {
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
	
	float samples[9];
	for (int i = 0; i < 9; i++){
		samples[i] = linear_depth(depth_texture, uvSamples[i], inv_proj);
	}
	
	float sobel_edge_h = samples[2] + (2.0 * samples[5]) + samples[8] - (samples[0] + (2.0 * samples[3] + samples[6]));
	float sobel_edge_v = samples[0] + (2.0 * samples[1]) + samples[2] - (samples[6] + (2.0 * samples[7] + samples[8]));
	float sobel = sqrt(sobel_edge_h * sobel_edge_h + sobel_edge_v * sobel_edge_v);
	
	float line_weight = 1.0 - step(sobel, depth_threshold * samples[4]);
	return line_weight;
}

float normal_sobel(sampler2D tex, vec2 uv, vec2 texel) {
	float s = sobel(tex, uv, texel);
	float line_weight = 1.0 - step(clamp(s, 0.0, 1.0), normal_threshold); // fresnel modulate doesn't seem to work, it's more about distance?
	return line_weight;
}


void fragment() {
	vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 1));
	ALBEDO = texture(albedo, UV/albedo_scale).rgb * tint.rgb;
}

void light() {
	float att = clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION;
	float influence = step(0.2, att);
	
	DIFFUSE_LIGHT = max(DIFFUSE_LIGHT, influence * mix(ALBEDO, LIGHT_COLOR, influence*0.5));
}