shader_type spatial;
render_mode unshaded, cull_disabled;

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
		// samples[i] = texture(DEPTH_TEXTURE, uvSamples[i]).r;
		samples[i] = linear_depth(depth_texture, uvSamples[i], inv_proj);
	}
	
	float sobel_edge_h = samples[2] + (2.0 * samples[5]) + samples[8] - (samples[0] + (2.0 * samples[3] + samples[6]));
	float sobel_edge_v = samples[0] + (2.0 * samples[1]) + samples[2] - (samples[6] + (2.0 * samples[7] + samples[8]));
	float sobel = sqrt(sobel_edge_h * sobel_edge_h + sobel_edge_v * sobel_edge_v);
	
	float line_weight = 1.0 - step(sobel, 0.9 * samples[4]);
	return line_weight;
}

void fragment() {
	vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 1));
	float line_weight = depth_sobel(DEPTH_TEXTURE, SCREEN_UV, vec2(1.5) / screen_size, INV_PROJECTION_MATRIX);
	ALBEDO = vec3(0.0);
	ALPHA = line_weight;
}
