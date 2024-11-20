/**
 * color_shader.gdshaderinc
 *
 * Part of the modular approach to object shaders.
 *
 * This shader include file is used by both "opaque_color_shader.gdshader" and
 * "transparent_color_shader.gdshader". Since rendering opaque and transparent objects is almost
 * exactly the same (except for writing to ALPHA), it makes sense to consolidate the shared code in
 * a single file.
 *
 * This shader only handles rendering color info, which is rendered on all layers besides the depth
 * and normal layers. (This ensures that objects will appear correctly in the editor.) It sets
 * ALBEDO and potentially ALPHA based on a uniform that has been passed in.
 */



// PREPROCESSOR DIRECTIVES

// Contains layer numbers and some common functions
#include "res://shaders/globals.gdshaderinc"

// Common hints for uniform textures.
#define hint_texture filter_nearest_mipmap, repeat_enable



// UNIFORMS

/** The material's base color. */
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);



// FUNCTIONS

// Called once for every vertex.
void vertex()
{
#ifdef VERTEX_DISCARD
	// Don't render if on the depth or normal layers
	if (CAMERA_VISIBLE_LAYERS == DEPTH_LAYER || CAMERA_VISIBLE_LAYERS == NORMAL_LAYER)
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
	// Don't render if on the depth or normal layers
	if (CAMERA_VISIBLE_LAYERS == DEPTH_LAYER || CAMERA_VISIBLE_LAYERS == NORMAL_LAYER)
	{
		discard;
	}
#endif

	// Otherwise, render color
	ALBEDO = color.rgb;
#ifndef OPAQUE
	ALPHA = color.a;
#endif
	// Since the fragment() function has to be overridden, you may also want to look up how to
	// render out other common properties, like roughness, emission, metallic, etc...
}
