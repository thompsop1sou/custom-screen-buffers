shader_type spatial;
render_mode depth_draw_always, depth_prepass_alpha;
/**
 * transparent_shader.gdshader
 *
 * Part of the monolithic approach to object shaders.
 *
 * This shader is for transparent objects. Most of the code is in "object_shader.gdshaderinc". It
 * does not define the OPAQUE preprocessor, which means that ALPHA will be written to in
 * "object_shader.gdshaderinc".
 */



// PREPROCESSOR DIRECTIVES

// Give it the regular old object shading (affects fragment() and light() functions).
#include "res://shaders/monolithic/object_shader.gdshaderinc"
