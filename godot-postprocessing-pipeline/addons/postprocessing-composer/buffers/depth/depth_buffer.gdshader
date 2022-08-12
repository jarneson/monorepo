shader_type spatial;
render_mode unshaded,cull_disabled;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	vec4 view = INV_PROJECTION_MATRIX * vec4(vec3(SCREEN_UV * 2.0 - 1.0, texture(DEPTH_TEXTURE, SCREEN_UV).r), 1.0);
	ALBEDO = vec3(view.w);
}
