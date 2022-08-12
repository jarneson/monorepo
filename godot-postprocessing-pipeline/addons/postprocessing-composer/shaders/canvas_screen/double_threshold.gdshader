shader_type canvas_item;

uniform float high_threshold = 0.7;
uniform float low_threshold = 0.3;

void fragment() {
	COLOR = 0.5*step(low_threshold, texture(SCREEN_TEXTURE, SCREEN_UV)) + 0.5*step(high_threshold, texture(SCREEN_TEXTURE, SCREEN_UV));
}
