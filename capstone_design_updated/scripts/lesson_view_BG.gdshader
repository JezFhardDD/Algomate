shader_type canvas_item;

/* Paper look settings */
uniform float grain_strength : hint_range(0.0, 0.1) = 0.035;
uniform float shadow_strength : hint_range(0.0, 0.3) = 0.12;

/* Simple random */
float rand(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 uv = UV;

	/* Base paper color (pure white) */
	vec3 paper_color = vec3(1.0);

	/* Paper grain */
	float noise = rand(uv * 600.0);
	paper_color -= noise * grain_strength;

	/* Soft edge shadow */
	float edge =
		smoothstep(0.0, 0.06, uv.x) *
		smoothstep(0.0, 0.06, uv.y) *
		smoothstep(0.0, 0.06, 1.0 - uv.x) *
		smoothstep(0.0, 0.06, 1.0 - uv.y);

	paper_color *= mix(1.0 - shadow_strength, 1.0, edge);

	COLOR = vec4(paper_color, 1.0);
}
