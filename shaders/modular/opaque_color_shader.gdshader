shader_type spatial;
/**
 * opaque_color_shader.gdshader
 *
 * Part of the modular approach to object shaders.
 *
 * This shader is for fully opaque objects. Most of the code is in "color_shader.gdshaderinc". It
 * defines the OPAQUE preprocessor, which ensures that ALPHA is not written to in
 * "color_shader.gdshaderinc".
 */



// PREPROCESSOR DIRECTIVES

// Indicate that this one should be fully opaque.
#define OPAQUE

// Give it the color shader (affects vertex() and fragment() functions).
#include "res://shaders/modular/color_shader.gdshaderinc"
