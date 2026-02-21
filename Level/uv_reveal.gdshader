shader_type canvas_item;

uniform bool uv_active = false;
uniform vec2 light_world_pos = vec2(0.0, 0.0);
uniform vec2 light_facing = vec2(1.0, 0.0);
uniform float light_range = 300.0;
uniform float light_half_angle = 0.567; // deg_to_rad(32.5)
uniform float dissolve_amount: hint_range(0.0, 1.0) = 0.0;
uniform float chunk_size: hint_range(0.01, 0.5) = 0.08;

varying vec2 world_pos;

float hash(vec2 p) {
	p = fract(p * vec2(234.34, 435.345));
	p += dot(p, p + 34.23);
	return fract(p.x * p.y);
}

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec2 chunk_index = floor(UV / chunk_size);
	if (hash(chunk_index) < dissolve_amount) {
		discard;
	}

	vec4 base = texture(TEXTURE, UV);
	float alpha = 0.0;
	if (uv_active) {
		vec2 to_frag = world_pos - light_world_pos;
		float dist = length(to_frag);
		if (dist > 0.0 && dist < light_range) {
			float cos_a = dot(normalize(to_frag), light_facing);
			float angle = acos(clamp(cos_a, -1.0, 1.0));
			if (angle < light_half_angle) {
				float edge = smoothstep(light_half_angle, light_half_angle * 0.7, angle);
				float falloff = sqrt(1.0 - dist / light_range);
				alpha = base.a * edge * falloff;
			}
		}
	}
	COLOR = vec4(0.5, 1.0, 1.0, alpha);
}
