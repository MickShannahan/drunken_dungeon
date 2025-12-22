shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

// =====================
// CHROMATIC ABERRATION
// =====================
uniform float aberration_x: hint_range(-1.0, 1.0) = 0.04;
uniform float aberration_y: hint_range(-1.0, 1.0) = 0.04;
uniform float aberration_strength: hint_range(0.0, 1.0) = 1.0;

// =====================
// FISHEYE DISTORTION
// =====================
uniform bool enable_fisheye = true;
uniform float fisheye_strength: hint_range(0.0, 2.0) = 0.5;
uniform float fisheye_center_x: hint_range(-1.0, 1.0) = 0.5;
uniform float fisheye_center_y: hint_range(-1.0, 1.0) = 0.5;
uniform float fisheye_edge_fade: hint_range(0.0, 1.0) = 0.3;

// =====================
// SCAN LINES
// =====================
uniform bool enable_scanlines = true;
uniform float scanline_intensity: hint_range(0.0, 1.0) = 0.4;
uniform float scanline_spacing: hint_range(1.0, 10.0) = 2.0;
uniform float scanline_speed: hint_range(0.0, 5.0) = 0.0;

// =====================
// SCREEN GLOW
// =====================
uniform bool enable_glow = true;
uniform float glow_intensity: hint_range(0.0, 1.0) = 0.15;
uniform float glow_blur_strength: hint_range(0.0, 2.0) = 0.8;

vec2 apply_fisheye(vec2 uv) {
	// Convert to normalized coordinates centered at (0.5, 0.5)
	vec2 center = vec2(fisheye_center_x, fisheye_center_y);
	vec2 pos = uv - center;
	
	// Apply fisheye distortion
	float distance = length(pos);
	float angle = atan(pos.y, pos.x);
	
	// Barrel distortion formula with edge clamping
	float distorted_distance = distance * (1.0 + fisheye_strength * distance * distance);
	
	vec2 distorted_uv = center + vec2(cos(angle), sin(angle)) * distorted_distance;
	
	// Clamp UV to valid range and apply edge fade
	distorted_uv = clamp(distorted_uv, 0.0, 1.0);
	
	return distorted_uv;
}

vec3 apply_scanlines(vec3 color, vec2 uv) {
	// Create animated scan lines
	float scanline = sin((uv.y * 100.0 * scanline_spacing) + TIME * scanline_speed) * 0.5 + 0.5;
	float scan_effect = mix(1.0, scanline, scanline_intensity);
	return color * scan_effect;
}

vec3 apply_screen_glow(vec3 color, vec2 uv) {
	// Create fuzzy screen glow using noise-like function
	vec2 glow_offset = sin(uv * 10.0 + TIME * 0.5) * glow_blur_strength;
	
	// Sample nearby pixels for glow effect
	vec3 glow = texture(SCREEN_TEXTURE, uv + glow_offset * 0.01).rgb;
	glow += texture(SCREEN_TEXTURE, uv - glow_offset * 0.01).rgb;
	glow += texture(SCREEN_TEXTURE, uv + vec2(glow_offset.y, -glow_offset.x) * 0.01).rgb;
	glow += texture(SCREEN_TEXTURE, uv - vec2(glow_offset.y, -glow_offset.x) * 0.01).rgb;
	glow /= 4.0;
	
	// Blend glow with original color
	return mix(color, glow, glow_intensity);
}

vec3 apply_chromatic_aberration(vec2 uv) {
	vec2 pixel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));
	vec2 offset = vec2(aberration_x * pixel_size.x, aberration_y * pixel_size.y) * 100.0 * aberration_strength;
	
	vec3 final_color;
	final_color.r = texture(SCREEN_TEXTURE, uv + offset).r;
	final_color.g = texture(SCREEN_TEXTURE, uv).g;
	final_color.b = texture(SCREEN_TEXTURE, uv - offset).b;
	
	return final_color;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = SCREEN_UV;
	vec2 original_uv = uv;
	
	// Apply fisheye effect
	if (enable_fisheye) {
		uv = apply_fisheye(uv);
	}
	
	// Apply chromatic aberration
	vec3 color = apply_chromatic_aberration(uv);
	
	// Apply screen glow
	if (enable_glow) {
		color = apply_screen_glow(color, original_uv);
	}
	
	// Apply scan lines
	if (enable_scanlines) {
		color = apply_scanlines(color, original_uv);
	}
	
	// Apply edge fade vignette for fisheye
	if (enable_fisheye) {
		vec2 edge_pos = original_uv - 0.5;
		float distance_from_center = length(edge_pos);
		float vignette = smoothstep(0.5 + fisheye_edge_fade, 0.5 - fisheye_edge_fade, distance_from_center);
		color *= vignette;
	}
	
	COLOR.rgb = color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
