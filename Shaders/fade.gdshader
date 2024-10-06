shader_type canvas_item;

uniform float opacity;

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = vec4(COLOR.rgb, min(opacity, COLOR.a));
}