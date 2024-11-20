shader_type spatial;
render_mode depth_draw_always, depth_prepass_alpha;



// PREPROCESSORS

// Give it the the color shader (affects fragment() and light() functions).
#include "res://shaders/modular/color_shader.gdshaderinc"
