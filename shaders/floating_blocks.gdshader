// floating_blocks.gdshader
shader_type canvas_item;

// Adjustable parameters
uniform float speed : hint_range(0.0, 2.0) = 0.3;
uniform float density : hint_range(0.0, 1.0) = 0.25;
uniform float block_size : hint_range(1.0, 20.0) = 8.0;
uniform vec4 block_color : source_color = vec4(0.3, 0.3, 0.5, 0.25);
uniform vec4 bg_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    // Get the screen UV coordinates (0-1)
    vec2 uv = UV;
    
    // Scale up to create more blocks
    uv *= 15.0;
    
    // Add movement
    uv.x += TIME * speed * 0.5;
    uv.y += TIME * speed * 0.3;
    
    // Create block pattern by flooring the coordinates
    vec2 block_pos = floor(uv);
    
    // Create a pseudo-random value based on block position
    float random = fract(sin(block_pos.x * 12.9898 + block_pos.y * 78.233) * 43758.5453);
    
    // Determine if this block should be visible based on density
    float visible = step(1.0 - density, random);
    
    // Make blocks pulse slightly
    float pulse = sin(block_pos.x * 2.0 + TIME * 2.0) * 0.5 + 0.5;
    pulse *= sin(block_pos.y * 2.0 + TIME * 1.5) * 0.5 + 0.5;
    
    // Calculate final color
    vec4 final_color = bg_color;
    
    if (visible > 0.5) {
        // Block is visible - mix with block color and add pulse
        final_color = mix(bg_color, block_color, 0.8 + pulse * 0.2);
        
        // Add a subtle glow
        final_color.rgb += vec3(0.1, 0.15, 0.2) * pulse * 0.3;
    }
    
    COLOR = final_color;
}