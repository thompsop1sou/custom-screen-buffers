/**
 * globals.gdshaderinc
 *
 * Defines a few constants and functions that are used in multiple places.
 */



// PREPROCESSOR DIRECTIVES

// If this is defined, the modular shaders will discard in the vertex function (by setting VERTEX
// to vec3(inf, inf, inf)). If this is not defined, they will just discard in the fragment function.
#define VERTEX_DISCARD



// CONSTANTS

// The different layers in use by the project. (These could be global uniforms as well.)
const uint MAIN_LAYER = uint(1);
const uint COLOR_LAYER = uint(2);
const uint DEPTH_LAYER = uint(4);
const uint NORMAL_LAYER = uint(8);

// Converts a texture channel selector from an int to a vec4. (Used by "object_shader.gdshader",
// "opaque_color_shader.gdshader", and "transparent_color_shader.gdshader".)
const vec4 texture_channel_vec[5] =
{
	vec4(1.0, 0.0, 0.0, 0.0),
	vec4(0.0, 1.0, 0.0, 0.0),
	vec4(0.0, 0.0, 1.0, 0.0),
	vec4(0.0, 0.0, 0.0, 1.0),
	vec4(0.33333333, 0.33333333, 0.33333333, 0.0)
};



// FUNCTIONS

// Transforms a 3D position vector v by a given 4x4 transformation matrix m.
vec3 transform_position(mat4 m, vec3 v)
{
	vec4 u = m * vec4(v, 1.0);
	return u.xyz / u.w;
}
