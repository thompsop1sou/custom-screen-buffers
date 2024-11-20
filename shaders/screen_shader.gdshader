shader_type spatial;
render_mode unshaded;
/**
 * screen_shader.gdshader
 *
 * A post-processing shader that has been applied to the FullScreenQuad node in the
 * "main_camera.tscn" scene. In the vertex() function, it just ensures that the quad covers the
 * whole screen. Then, in the fragment() function, it reads from the buffers that have been passed
 * to it and does some basic conversion to get the original values. This info can then be used to
 * render a post-processing effect.
 */



// PREPROCESSOR DIRECTIVES

// Contains layer numbers and some common functions
#include "res://shaders/globals.gdshaderinc"



// UNIFORMS

/** This texture holds color from the second visual layer. */
uniform sampler2D color_buffer : filter_nearest;

/** This texture holds depth info from the third visual layer. */
uniform sampler2D depth_buffer : filter_nearest;

/** This texture holds normal info from the fourth visual layer. */
uniform sampler2D normal_buffer : filter_nearest;



// FUNCTIONS

// Called once for each vertex.
void vertex()
{
	// Make sure the full-screen quad covers the entire screen
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

// Called once for each pixel.
void fragment()
{
	// Read the buffers for this pixel (and convert to original values as necessary)
	vec4 color = texture(color_buffer, SCREEN_UV);
	vec2 depth_xy = texture(depth_buffer, SCREEN_UV).xy;
	float depth = floor(depth_xy.x * 256.0) / 256.0 + floor(depth_xy.y * 256.0) / (256.0 * 256.0);
	vec3 normal = 2.0 * texture(normal_buffer, SCREEN_UV).xyz - vec3(1.0);

	// Set the screen shader to show info about this pixel (uncomment a line to view)
	ALBEDO = color.rgb;                                // Color
	//ALBEDO = vec3(color.r + color.g + color.b) / 3.0;  // Grayscale 
	//ALBEDO = vec3(depth);                              // Depth
	//ALBEDO = 0.5 * (normal + vec3(1.0));               // Normal
}
