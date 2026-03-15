shader_type canvas_item;

// --- Controls (base ranges, can tweak) ---
uniform float min_speed = 1.5;
uniform float max_speed = 1.07;

uniform float min_height = 0.05;
uniform float max_height = 0.009;

uniform float min_rotation = 1.0;
uniform float max_rotation = 1.9;

void fragment() {
    COLOR = texture(TEXTURE, UV);
}

void vertex() {
    // --- Automatic random seed per instance ---
    float seed = fract(sin(float(INSTANCE_ID) * 12.9898) * 43758.5453);

    // --- Randomized parameters per instance ---
    float float_speed = mix(min_speed, max_speed, seed);
    float float_height = mix(min_height, max_height, seed);
    float float_rotation = mix(min_rotation, max_rotation, seed);

    // --- Vertical bobbing ---
    float offset_y = sin(TIME * float_speed + seed * 12.345) * float_height;

    // --- Rotation (optional) ---
    float rot = sin(TIME * float_speed * 0.7 + seed * 5.678) * (float_rotation * 3.14159265 / 180.0);

    // --- Apply rotation around sprite center ---
    vec2 center = vec2(0.5, 0.5);
    vec2 pos = VERTEX - center;
    float s = sin(rot);
    float c = cos(rot);
    VERTEX = vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c) + center;

    // --- Apply vertical bob ---
    VERTEX.y += offset_y / TEXTURE_PIXEL_SIZE.y; // convert pixels to normalized units
}
