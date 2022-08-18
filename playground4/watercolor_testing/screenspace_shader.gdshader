shader_type canvas_item;

uniform sampler2D depth;
uniform float depth_weight = 1.0;
uniform sampler2D paint_noise;
uniform float paint_weight = 100.0;

void fragment() {
	vec3 albedo = texture(TEXTURE, UV).rgb;
	vec2 offset = 2.0*texture(paint_noise, fract(UV /*+ vec2(sin(TIME/30.), cos(TIME/20.))*/)).xy - vec2(1.0);
	offset /= paint_weight;
	float my_depth = texture(depth, UV).r;
	float other_depth = texture(depth, UV+offset).r;
	float max_depth = max(my_depth, other_depth);
	offset *= pow(max_depth, depth_weight);
	vec3 other = texture(TEXTURE, UV + offset).rgb;
	COLOR = vec4(mix(other, albedo, min(1.0, texture(paint_noise, UV).x)), 1.0);
	//COLOR = vec4(vec3(my_depth/(my_depth+other_depth)), 1.0);
	//COLOR = vec4(offset*25.0, 0.0, 1.0);
	
	// ALBEDO = vec3(offset, 0.);
}
