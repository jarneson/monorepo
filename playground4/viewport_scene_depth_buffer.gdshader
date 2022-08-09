shader_type spatial;
render_mode unshaded, cull_disabled;

void vertex() {
	POSITION = vec4(VERTEX, 1.);
}

float linear_depth(sampler2D depth_texture, vec2 uv, mat4 inv_proj) {
	float depth = texture(depth_texture, uv).x;
	vec3 ndc = vec3(uv * 2.0 - 1.0, depth);
	vec4 view = inv_proj*vec4(ndc, 1.0);
	view.xyz /= view.w;
	return -view.z/4000.0;
}
void fragment() {
	ALBEDO = vec3(linear_depth(DEPTH_TEXTURE, SCREEN_UV, INV_PROJECTION_MATRIX));
}
