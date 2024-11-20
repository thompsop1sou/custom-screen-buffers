shader_type spatial;
/**
 * opaque_shader.gdshader
 *
 * Part of the monolithic approach to object shaders.
 *
 * This shader is for fully opaque objects. Most of the code is in "object_shader.gdshaderinc". It
 * defines the OPAQUE preprocessor, which ensures that ALPHA is not written to in
 * "object_shader.gdshaderinc".
 */



// PREPROCESSOR DIRECTIVES

// Indicate that this one should be fully opaque.
#define OPAQUE

// Give it the regular old object shading (affects fragment() and light() functions).
#include "res://shaders/monolithic/object_shader.gdshaderinc"
