shader_type spatial;
render_mode unshaded;
/**
 * normal_shader.gdshader
 *
 * Part of the modular approach to object shaders.
 *
 * This shader handles rendering normal info.
 */



// FUNCTIONS

// Called once for every pixel.
void fragment()
{
	// Render normal at this point (each component mapped to the range [0, 1])
	vec3 normal = 0.5 * (NORMAL + vec3(1.0));
	ALBEDO = normal;
}
