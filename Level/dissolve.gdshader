shader_type canvas_item;

uniform float dissolve_amount: hint_range(0.0, 1.0) = 0.0;
uniform float chunk_size: hint_range(0.01, 0.5) = 0.08;

float hash(vec2 p) {
	p = fract(p * vec2(234.34, 435.345));
	p += dot(p, p + 34.23);
	return fract(p.x * p.y);
}

void fragment() {
	vec2 chunk_index = floor(UV / chunk_size);
	if (hash(chunk_index) < dissolve_amount) {
		discard;
	}
	COLOR = texture(TEXTURE, UV) * COLOR;
}
