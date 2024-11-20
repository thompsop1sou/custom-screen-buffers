shader_type spatial;
render_mode unshaded;



// PREPROCESSORS

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
		VERTEX /= 0.0;
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

	// Otherwise, render depth value
	float depth = transform_position(PROJECTION_MATRIX, VERTEX).z;
	ALBEDO.x = depth;
	ALBEDO.y = fract(depth * 256.0);
	ALBEDO.z = 0.0; // Could add other info in this channel if desired...
}
