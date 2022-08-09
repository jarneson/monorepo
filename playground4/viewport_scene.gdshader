shader_type canvas_item;
render_mode unshaded;

uniform float color_width = 0.1;
uniform float color_threshold = 0.1;

vec3 rgb_to_hue(vec3 color) {
	float k = 0.0;
	float tmp;
	
	if (color.r < color.b) {
		tmp = color.g;
		color.g = color.b;
		color.b = tmp;
		k = -1.0;
	}
	
	if (color.r < color.g) {
		tmp = color.r;
		color.r = color.g;
		color.g = tmp;
		k = -2.0 / 6.0;
	}
	float chroma = color.r - min(color.g, color.b);
	float h = abs(k + (color.g - color.b) / (6.0 * chroma + 1e-20));
	float s = chroma / (color.r + 1e-20);
	float v = color.r;
	return vec3(h,s,v);
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
		colorSamples[i] = rgb_to_hue(texture(tex, uvSamples[i]).rgb);
	}
	
	vec3 sobel_edge_h = 3.0*colorSamples[2] + (10.0 * colorSamples[5]) + 3.0*colorSamples[8] - (3.0*colorSamples[0] + (10.0 * colorSamples[3] + 3.0*colorSamples[6]));
	vec3 sobel_edge_v = 3.0*colorSamples[0] + (10.0 * colorSamples[1]) + 3.0*colorSamples[2] - (3.0*colorSamples[6] + (10.0 * colorSamples[7] + 3.0*colorSamples[8]));
	return sqrt(dot(sobel_edge_h, sobel_edge_h) + dot(sobel_edge_v, sobel_edge_v));
}

float color_sobel(sampler2D tex, vec2 uv, vec2 texel) {
	float s = sobel2(tex, uv, texel);
	float line_weight = 1.0 - step(s, color_threshold);
	return line_weight;
}

void fragment() {
	float line_weight = color_sobel(TEXTURE, UV, SCREEN_PIXEL_SIZE * color_width);
	COLOR.rgb = vec3(1.0 - line_weight) * texture(TEXTURE, UV).rgb;
}
