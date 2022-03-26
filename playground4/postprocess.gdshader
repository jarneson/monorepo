shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float line_power = 1.0;
uniform float outline_intensity = 1.0;
uniform float glow_intensity = 1.0;

void vertex() {
	POSITION = vec4(VERTEX, 1.);
}

void fragment() {
	vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 1));
	
	float px = 0.5 / screen_size.x;
	float py = 0.5 / screen_size.y;
	
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	float d = pow(depth, line_power);
	float du = pow(texture(DEPTH_TEXTURE, SCREEN_UV+vec2(0.0,py)).x, line_power);
	float dd = pow(texture(DEPTH_TEXTURE, SCREEN_UV+vec2(0.0,-py)).x, line_power);
	float dr = pow(texture(DEPTH_TEXTURE, SCREEN_UV+vec2(px,0.0)).x, line_power);
	float dl = pow(texture(DEPTH_TEXTURE, SCREEN_UV+vec2(-px,0.0)).x, line_power);
	float dq = pow(texture(DEPTH_TEXTURE, SCREEN_UV+vec2(-px,py)).x, line_power);
	float de = pow(texture(DEPTH_TEXTURE, SCREEN_UV+vec2(px,py)).x, line_power);
	float dz = pow(texture(DEPTH_TEXTURE, SCREEN_UV+vec2(-px,-py)).x, line_power);
	float dc = pow(texture(DEPTH_TEXTURE, SCREEN_UV+vec2(px,-py)).x, line_power);
	
	float w = abs(abs(abs(d)-abs(du)) - abs(abs(d)-abs(dd))) + abs(abs(abs(d)-abs(dl)) - abs(abs(d)-abs(dr))) + abs(abs(abs(d)-abs(dq)) - abs(abs(d)-abs(dc))) + abs(abs(abs(d)-abs(dz)) - abs(abs(d)-abs(de)));
	w *= 50000.0*outline_intensity;
	w = floor(w);
	
	ALBEDO = texture(SCREEN_TEXTURE, SCREEN_UV).rgb * step(0.1, w) * glow_intensity;
	ALPHA = step(depth, 0.9999);
}
