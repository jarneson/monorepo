shader_type canvas_item;

uniform float strength = 1.0;

void fragment() {
	float c = texture(TEXTURE, UV).r;
	COLOR = vec4(vec3(0.), step(0.01,c)*strength);
}
