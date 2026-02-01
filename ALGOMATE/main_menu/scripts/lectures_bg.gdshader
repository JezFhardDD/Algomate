shader_type canvas_item;

// ===== CONTROLS =====
uniform float speed = 0.12;
uniform float density = 14.0;
uniform float min_size = 0.18;
uniform float max_size = 0.45;
uniform float min_alpha = 0.3;
uniform float max_alpha = 0.9;

uniform vec3 bg_color : source_color = vec3(0.02, 0.05, 0.1);
uniform vec3 block_color : source_color = vec3(0.0, 1.0, 0.7);
uniform vec3 accent_color : source_color = vec3(0.7, 0.4, 1.0);

// Hash
float hash(vec2 p){
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void fragment(){
	vec2 uv = SCREEN_UV;

	// Smooth upward movement
	uv.y = fract(uv.y - TIME * speed);

	vec3 col = bg_color;
	float final_alpha = 1.0;

	// Layered passes for depth
	for(float layer = 0.0; layer < 3.0; layer++){
		float layer_speed = speed * (0.5 + layer);
		vec2 luv = uv;
		luv.y = fract(luv.y - TIME * layer_speed);

		float d = density * (1.0 + layer * 0.6);
		vec2 grid = floor(luv * d);
		vec2 cell_uv = fract(luv * d);

		float rnd = hash(grid + layer * 13.7);
		float has_block = step(0.5, rnd);

		float size = mix(min_size, max_size, fract(rnd * 7.3));
		float alpha = mix(min_alpha, max_alpha, fract(rnd * 3.1));

		float dist = max(abs(cell_uv.x - 0.5), abs(cell_uv.y - 0.5));
		float square = smoothstep(size, size - 0.02, dist);

		vec3 c = mix(block_color, accent_color, fract(rnd * 5.7));
		col = mix(col, c, square * has_block * alpha);
	}

	COLOR = vec4(col, 1.0);
}
