shader_type canvas_item;

uniform sampler2D stipple_noise;
uniform float stipple_weight = 1.0;
uniform sampler2D stroke_noise;
uniform float stroke_weight = 1.0;
uniform sampler2D depth_texture;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	vec3 px = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	vec3 hsv = rgb2hsv(px);
	float d = round(10. * texture(depth_texture, SCREEN_UV).r) / 10.;
	float stipple = smoothstep(0., 1., texture(stipple_noise, fract(SCREEN_UV*stipple_weight/d)).r);
	float stroke = texture(stroke_noise, fract(SCREEN_UV*stroke_weight+vec2(hsv.x, hsv.x)/2.0)).g;
	float luminance = hsv.z;
	hsv.z = 1.0;
	px = hsv2rgb(hsv);
	COLOR = vec4(step(step(0.03, d)*stipple, luminance) * (vec3(1.) - (vec3(1.) - px)/stroke), 1.0);
	// COLOR = vec4(step(stipple, luminance) * (vec3(1.) - (vec3(1.) - px)*(1.-stroke)), 1.0);
	// COLOR = vec4(vec3(hsv.y), 1.0);
}
