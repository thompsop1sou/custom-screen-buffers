shader_type spatial;
render_mode depth_draw_always, depth_prepass_alpha;
/**
 * transparent_color_shader.gdshader
 *
 * Part of the modular approach to object shaders.
 *
 * This shader is for transparent objects. Most of the code is in "color_shader.gdshaderinc". It
 * does not define the OPAQUE preprocessor, which means that ALPHA will be written to in
 * "color_shader.gdshaderinc".
 */



// PREPROCESSOR DIRECTIVES

// Give it the the color shader (affects vertex() and fragment() functions).
#include "res://shaders/modular/color_shader.gdshaderinc"
