shader_type spatial;
render_mode cull_disabled,unshaded,depth_draw_opaque;

uniform vec4 color: hint_color;
uniform float intensity = 1.0;
uniform sampler2D tex;

void fragment() {
	ALBEDO = texture(tex, UV).aaa*color.rgb*intensity;
	ALPHA = texture(tex,UV).a;
}
