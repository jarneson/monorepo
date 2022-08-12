shader_type canvas_item;

void fragment() {
	float c = texture(TEXTURE, UV).r;
	COLOR = vec4(vec3(0.), step(0.01,c));
}
