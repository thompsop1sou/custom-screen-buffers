shader_type spatial;
render_mode unshaded;
/**
 * screen_shader.gdshader
 *
 * A post-processing shader that has been applied to the FullScreenQuad node in the
 * "main_camera.tscn" scene. In the vertex() function, it just ensures that the quad covers the
 * whole screen. Then, in the fragment() function, it reads from the buffers that have been passed
 * to it using a helper function get_pixel_info(). This info can then be used to render a
 * post-processing effect.
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



// CUSTOM STRUCT AND FUNCTION

// Holds information about a pixel.
struct PixelInfo
{
	vec2 coords; // screen coordinates
	vec4 color;
	float depth;
	vec3 position; // 3D position (in screen space)
	vec3 normal;
};

// Gets information about a pixel.
PixelInfo get_pixel_info(vec2 pixel_coords, vec2 viewport_size, mat4 inv_projection_matrix)
{
	PixelInfo pixel_info;
	// Screen position
	ivec2 i_pixel_coords = ivec2(pixel_coords);
	pixel_info.coords = pixel_coords;
	// Color
	pixel_info.color = texelFetch(color_buffer, i_pixel_coords, 0);
	// Depth
	vec2 depth_xy = texelFetch(depth_buffer, i_pixel_coords, 0).xy;
	pixel_info.depth = floor(depth_xy.x * 256.0) / 256.0 + 
						floor(depth_xy.y * 256.0) / (256.0 * 256.0);
	// 3D Position (in screen space)
	vec3 clip_position = vec3(2.0 * (pixel_coords / viewport_size) - vec2(1.0, 1.0), pixel_info.depth);
	pixel_info.position = transform_position(inv_projection_matrix, clip_position);
	// Normal
	pixel_info.normal = 2.0 * texelFetch(normal_buffer, i_pixel_coords, 0).xyz - vec3(1.0);
	// Return the newly defined pixel_info
	return pixel_info;
}



// BUILT-IN FUNCTIONS

// Called once for each vertex.
void vertex()
{
	// Make sure the full-screen quad covers the entire screen
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

// Called once for each pixel.
void fragment()
{
	// Read the buffers for this pixel
	PixelInfo pixel_info = get_pixel_info(FRAGCOORD.xy, VIEWPORT_SIZE, INV_PROJECTION_MATRIX);

	// Set the screen shader to show info about this pixel (uncomment a line to view)
	ALBEDO = pixel_info.color.rgb;                  // Color
	//ALBEDO = vec3(pixel_info.depth);                // Depth
	//ALBEDO = 0.5 * (pixel_info.normal + vec3(1.0)); // Normal
	//ALBEDO = fract(pixel_info.position);            // 3D Position (in screen space)
}
