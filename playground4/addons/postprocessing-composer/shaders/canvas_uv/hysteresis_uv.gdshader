shader_type canvas_item;

uniform float weight = 5.0;

float magnitude_threshold(sampler2D tex, vec2 uv, vec2 texel) {
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
	
	float m = 0.0;
	for (int i = 0; i < 9; i++){
		m = max(m, texture(tex, uvSamples[i]).r);
	}
	return step(m, 0.6);
}

void fragment() {
	COLOR = vec4(vec3(1.0) - vec3(magnitude_threshold(TEXTURE, UV, SCREEN_PIXEL_SIZE/weight)), 1.0);
}
