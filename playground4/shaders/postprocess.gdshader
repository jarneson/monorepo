shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float line_power = 1.0;
uniform float outline_intensity = 1.0;
uniform float line_glow_intensity = 1.0;
uniform float fill_glow_intensity = 1.0;

void vertex() {
	POSITION = vec4(VERTEX, 1.);
}

float calc_line_weight(vec2 screen_uv, vec2 screen_size, sampler2D depth_texture) {
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
	w *= 50000.0*outline_intensity;
	w = floor(w);
	return w;
}

vec3 calc_color(vec3 color) {
	return step(vec3(0.5), color);
}

vec3 outline_color(vec3 color) {
	return smoothstep(vec3(0.0), vec3(0.4),color)*clamp(color+vec3(1), 0.0, 1.0) * line_glow_intensity;
}

vec3 fill_color(vec3 color) {
	return smoothstep(vec3(0.5), vec3(1.0), color) * fill_glow_intensity;
}

void fragment() {
	vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 1));
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	
	float w = calc_line_weight(SCREEN_UV, screen_size, DEPTH_TEXTURE);

	vec3 outline = outline_color(texture(SCREEN_TEXTURE, SCREEN_UV).rgb) * step(0.1, w);
	vec3 fill_color = fill_color(texture(SCREEN_TEXTURE, SCREEN_UV).rgb);
	ALBEDO = max(outline, fill_color);
	ALPHA = step(depth, 0.9999);
}
