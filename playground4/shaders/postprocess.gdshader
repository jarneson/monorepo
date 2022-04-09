shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float line_power = 1.0;
uniform float outline_intensity = 1.0;
uniform float line_glow_intensity = 1.0;
uniform float fill_glow_intensity = 1.0;
uniform float bias = 0.0;

void vertex() {
	POSITION = vec4(VERTEX, 1.);
}

float linear_depth(sampler2D depth_texture, vec2 uv, mat4 inv_proj) {
	vec4 view = inv_proj*vec4(vec3(texture(depth_texture, uv).x), 1.0);
	view.xyz /= view.w;
	return -view.z;
}

float calc_line_weight(vec2 screen_uv, vec2 screen_size, sampler2D depth_texture, mat4 inv_proj) {
	vec4 proj = inv_proj*vec4(vec3(screen_uv, 1.0), 1.0);
	proj.xyz /= proj.w;
	float px = 0.5 / screen_size.x;
	float py = 0.5 / screen_size.y;
	float d = pow(texture(depth_texture, screen_uv).x, line_power);
	float du = pow(texture(depth_texture, screen_uv+vec2(0.0,py)).x, line_power);
	float dd = pow(texture(depth_texture, screen_uv+vec2(0.0,-py)).x, line_power);
	float dr = pow(texture(depth_texture, screen_uv+vec2(px,0.0)).x, line_power);
	float dl = pow(texture(depth_texture, screen_uv+vec2(-px,0.0)).x, line_power);
	float dq = pow(texture(depth_texture, screen_uv+vec2(-px,py)).x, line_power);
	float de = pow(texture(depth_texture, screen_uv+vec2(px,py)).x, line_power);
	float dz = pow(texture(depth_texture, screen_uv+vec2(-px,-py)).x, line_power);
	float dc = pow(texture(depth_texture, screen_uv+vec2(px,-py)).x, line_power);
	float w = abs(abs(abs(d)-abs(du)) - abs(abs(d)-abs(dd))) + abs(abs(abs(d)-abs(dl)) - abs(abs(d)-abs(dr))) + abs(abs(abs(d)-abs(dq)) - abs(abs(d)-abs(dc))) + abs(abs(abs(d)-abs(dz)) - abs(abs(d)-abs(de)));
	w *= pow(-proj.z, 1.5);
	w += bias-1.0;
	return clamp(w, 0.0, 1.0);
}

vec3 calc_color(vec3 color) {
	return step(vec3(0.5), color);
}

vec3 adjust_luminance(vec3 col) {
	float lum = (col.r*0.23 + col.g*0.73 + col.b*0.04);
	return col/lum;
}

vec3 outline_color(vec3 color) {
	return adjust_luminance(smoothstep(vec3(0.0), vec3(0.4),color)*clamp(color+vec3(1), 0.0, 1.0)) * line_glow_intensity;
}

vec3 fill_color(vec3 color) {
	return adjust_luminance(smoothstep(vec3(0.5), vec3(1.0), color)) * fill_glow_intensity;
}

void fragment() {
	vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 1));
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	
	float w = calc_line_weight(SCREEN_UV, screen_size, DEPTH_TEXTURE, INV_PROJECTION_MATRIX);

	vec3 outline = outline_color(texture(SCREEN_TEXTURE, SCREEN_UV).rgb) * w;
	vec3 fill_color = fill_color(texture(SCREEN_TEXTURE, SCREEN_UV).rgb);
	ALBEDO = max(outline, fill_color);
	ALPHA = step(depth, 0.99999);
	//ALBEDO = vec3(linear_depth(DEPTH_TEXTURE, SCREEN_UV, INV_PROJECTION_MATRIX))/2000.;
}
