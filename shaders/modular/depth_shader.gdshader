shader_type spatial;
render_mode unshaded;
/**
 * depth_shader.gdshader
 *
 * Part of the modular approach to object shaders.
 *
 * This shader handles rendering depth info and is rendered only on the depth layer.
 */



// PREPROCESSOR DIRECTIVES

// Contains layer numbers and some common functions
#include "res://shaders/globals.gdshaderinc"



// FUNCTIONS

// Called once for every vertex.
void vertex()
{
#ifdef VERTEX_DISCARD
	// Don't render if not on the depth layer
	if (CAMERA_VISIBLE_LAYERS != DEPTH_LAYER)
	{
		// This discards by setting the vertex to vec3(inf, inf, inf)
		VERTEX = vec3(1.0 / 0.0);
	}
#endif
}

// Called once for every pixel.
void fragment()
{
#ifndef VERTEX_DISCARD
	// Don't render if not on the depth layer
	if (CAMERA_VISIBLE_LAYERS != DEPTH_LAYER)
	{
		discard;
	}
#endif

	// Otherwise, render depth value (using both the x and y channels for greater precision)
	float depth = transform_position(PROJECTION_MATRIX, VERTEX).z;
	ALBEDO.x = depth;
	ALBEDO.y = fract(depth * 256.0);
	ALBEDO.z = 0.0; // Could add other info in this channel if desired...
}
