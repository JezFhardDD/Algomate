shader_type canvas_item;

uniform float speed = 2.0;
uniform float strength = 0.05;
uniform float tilt_strength = 0.03;

void vertex() {
    float pump = 1.0 + sin(TIME * speed) * strength;
    float angle = sin(TIME * speed) * tilt_strength;

    float c = cos(angle);
    float s = sin(angle);
    mat2 rot = mat2(vec2(c, s), vec2(-s, c));

    // Center the vertex, transform, then move back
    vec2 v = VERTEX;
    v = rot * (v * pump);
    VERTEX = v;
}

void fragment() {
    COLOR = texture(TEXTURE, UV);
}
