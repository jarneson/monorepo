shader_type canvas_item;

uniform sampler2D noise;

void fragment() {
	vec3 px = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	float n = smoothstep(-0.2, 1.2, texture(noise, SCREEN_UV*0.9).r);
	float luminance = px.r * 0.0721 + px.g * 0.7154 + px.b * 0.2125;
	COLOR = vec4(vec3(step(n, luminance)), 1.0);
}
