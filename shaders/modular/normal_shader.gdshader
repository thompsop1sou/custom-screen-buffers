shader_type spatial;
render_mode unshaded;
/**
 * normal_shader.gdshader
 *
 * Part of the modular approach to object shaders.
 *
 * This shader handles rendering normal info and is rendered only on the normal layer.
 */



// PREPROCESSOR DIRECTIVES

// Contains layer numbers and some common functions
#include "res://shaders/globals.gdshaderinc"



// FUNCTIONS

// Called once for every vertex.
void vertex()
{
#ifdef VERTEX_DISCARD
	// Don't render if not on the normal layer
	if (CAMERA_VISIBLE_LAYERS != NORMAL_LAYER)
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
	// Don't render if not on the normal layer
	if (CAMERA_VISIBLE_LAYERS != NORMAL_LAYER)
	{
		discard;
	}
#endif

	// Otherwise, render normal value
	vec3 normal = 0.5 * (NORMAL + vec3(1.0));
	ALBEDO = normal;
}
