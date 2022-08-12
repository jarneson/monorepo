shader_type canvas_item;

uniform float line_width = 1.0;
uniform float depth_weight = 1.0;
uniform sampler2D depth_buffer;

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
	
	vec3 sobel_edge_h = 3.0*colorSamples[2] + (10.0 * colorSamples[5]) + 3.0*colorSamples[8] - (3.0*colorSamples[0] + (10.0 * colorSamples[3] + 3.0*colorSamples[6]));
	vec3 sobel_edge_v = 3.0*colorSamples[0] + (10.0 * colorSamples[1]) + 3.0*colorSamples[2] - (3.0*colorSamples[6] + (10.0 * colorSamples[7] + 3.0*colorSamples[8]));
	return sqrt(dot(sobel_edge_h, sobel_edge_h) + dot(sobel_edge_v, sobel_edge_v));
}

void fragment() {
	float s = sobel(SCREEN_TEXTURE, SCREEN_UV, SCREEN_PIXEL_SIZE * line_width * pow(texture(depth_buffer, UV).r, depth_weight));
	COLOR = vec4(vec3(s),1.);
}