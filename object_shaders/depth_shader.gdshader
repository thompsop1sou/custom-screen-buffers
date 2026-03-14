shader_type spatial;
render_mode unshaded;
/**
 * depth_shader.gdshader
 *
 * Part of the modular approach to object shaders.
 *
 * This shader handles rendering depth info.
 */



// FUNCTIONS

// Transforms a 3D position vector v by a given 4x4 transformation matrix m.
vec3 transform_position(mat4 m, vec3 v)
{
	vec4 u = m * vec4(v, 1.0);
	return u.xyz / u.w;
}

// Called once for every pixel.
void fragment()
{
	// Render depth at this point (using both the x and y channels for greater precision)
	float depth = transform_position(PROJECTION_MATRIX, VERTEX).z;
	ALBEDO.x = depth;
	ALBEDO.y = fract(depth * 256.0);
	ALBEDO.z = 0.0; // Could add other info in this channel if desired...
}
