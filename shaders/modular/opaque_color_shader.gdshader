shader_type spatial;



// PREPROCESSORS

// Indicate that this one should be fully opaque.
#define OPAQUE

// Give it the color shader (affects fragment() and light() functions).
#include "res://shaders/monolithic/object_shader.gdshaderinc"
