shader_type spatial;
render_mode depth_draw_always, depth_prepass_alpha;

// Give it the regular old object shading (affects fragment() and light() functions).
#include "res://shaders/object_shader.gdshaderinc"