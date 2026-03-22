shader_type canvas_item;

uniform vec3 base_color = vec3(0.478, 0.663, 0.224); // #7aa939
uniform float speed = 0.5;
uniform float wave_strength = 0.95;
uniform float noise_strength = 0.9;

float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u * u * (3.0 - 2.0 * u);

    float res = mix(
        mix(rand(ip), rand(ip + vec2(1.0, 0.0)), u.x),
        mix(rand(ip + vec2(0.0, 1.0)), rand(ip + vec2(1.0, 1.0)), u.x),
        u.y
    );
    return res;
}

void fragment() {
    vec2 uv = UV;

    // Slow drifting motion
    uv.x += sin(TIME * speed + uv.y * 3.0) * wave_strength;
    uv.y += cos(TIME * speed * 0.8 + uv.x * 3.0) * wave_strength;

    // Soft noise
    float n = noise(uv * 4.0 + TIME * 0.1);
    float shade = 1.0 + (n - 0.5) * noise_strength;

    vec3 color = base_color * shade;

    COLOR = vec4(color, 1.0);
}
