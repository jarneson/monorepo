shader_type canvas_item;

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
	
	float colorSamples[9];
	for (int i = 0; i < 9; i++){
		colorSamples[i] = texture(tex, uvSamples[i]).r;
	}
	return step(colorSamples[0], colorSamples[4]) * 
		step(colorSamples[1], colorSamples[4]) * 
		step(colorSamples[2], colorSamples[4]) * 
		step(colorSamples[3], colorSamples[4]) * 
		step(colorSamples[5], colorSamples[4]) * 
		step(colorSamples[6], colorSamples[4]) * 
		step(colorSamples[7], colorSamples[4]) *  
		step(colorSamples[8], colorSamples[4]) * colorSamples[4];
}

void fragment() {
	COLOR = vec4(vec3(magnitude_threshold(SCREEN_TEXTURE, SCREEN_UV, SCREEN_PIXEL_SIZE)), 1.0);
}
