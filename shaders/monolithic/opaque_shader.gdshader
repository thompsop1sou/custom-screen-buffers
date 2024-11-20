shader_type spatial;



// PREPROCESSORS

// Indicate that this one should be fully opaque.
#define OPAQUE

// Give it the regular old object shading (affects fragment() and light() functions).
#include "res://shaders/monolithic/object_shader.gdshaderinc"
