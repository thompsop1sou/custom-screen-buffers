#include "res://shaders/global_functions.gdshaderinc"

#define hint_texture filter_nearest_mipmap, repeat_enable



// UNIFORMS

group_uniforms flags;

/** Sets whether this material will be affected by lights. */
uniform bool shaded = true;

group_uniforms albedo;

/** The material's base color. */
uniform vec4 albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

/** Texture to multiply by albedo_color. Used for basic texturing of objects. */
uniform sampler2D albedo_texture : hint_texture, source_color, hint_default_white;

group_uniforms metallic;

/** Adjusts the strength of specular reflections. */
uniform float specular_value : hint_range(0.0, 1.0) = 1.0;

/** A high value makes the material appear more like a metal. */
uniform float metallic_value : hint_range(0.0, 1.0) = 0.0;

/** Texture used to specify metallic for an object. This is multiplied by metallic. */
uniform sampler2D metallic_texture : hint_texture, hint_default_white;

/** Specifies the channel of the metallic_texture in which the metallic information is stored.
    Choosing channel 4 will give the average of the RGB channels. */
uniform int metallic_texture_channel : hint_range(0, 4) = 0;

group_uniforms roughness;

/** Surface reflection. A value of 0 represents a perfect mirror while a value of 1 completely blurs the reflection. */
uniform float roughness_value : hint_range(0.0, 1.0) = 1.0;

/** Texture used to control the roughness per-pixel. Multiplied by roughness. */
uniform sampler2D roughness_texture : hint_texture, hint_default_white;

/** Specifies the channel of the roughness_texture in which the roughness information is stored.
    Choosing channel 4 will give the average of the RGB channels. */
uniform int roughness_texture_channel : hint_range(0, 4) = 0;

group_uniforms emission;

/** The emitted light's color. Emitting light makes the object appear brighter. */
uniform vec3 emission_color : source_color = vec3(0.0, 0.0, 0.0);

/** Texture that specifies how much surface emits light at a given point. */
uniform sampler2D emission_texture : hint_texture, source_color, hint_default_black;

/** Multiplier for emitted light. */
uniform float emission_energy = 1.0;



// CONSTANTS

// Layers.
const int MAIN_LAYER = 1;
const int COLOR_LAYER = 2;
const int DEPTH_LAYER = 4;
const int NORMALS_LAYER = 8;

// Converts a texture channel selector from an int to a vec4.
const vec4 texture_channel_vec[5] =
{
	vec4(1.0, 0.0, 0.0, 0.0),
	vec4(0.0, 1.0, 0.0, 0.0),
	vec4(0.0, 0.0, 1.0, 0.0),
	vec4(0.0, 0.0, 0.0, 1.0),
	vec4(0.33333333, 0.33333333, 0.33333333, 0.0)
};



// VARYINGS

// The layer(s) of the current camera.
varying int camera_layers;



// FUNCTIONS

// Called once for every pixel.
void fragment()
{
	camera_layers = int(CAMERA_VISIBLE_LAYERS);
	switch (camera_layers)
	{
		// Use emission to display the depth value
		case DEPTH_LAYER:
			ALBEDO = vec3(0.0);
			float depth = transform_position(PROJECTION_MATRIX, VERTEX).z;
			EMISSION.x = depth;
			EMISSION.y = fract(depth * 256.0);
			EMISSION.z = 0.0; // Could add other info in this channel if desired...
			break;
		// Use emission to display the normal value
		case NORMALS_LAYER:
			ALBEDO = vec3(0.0);
			vec3 normal = 0.5 * (NORMAL + vec3(1.0));
			EMISSION = normal;
			break;
		// Display regular material properties
		default:
			// Color properties
			vec4 color = texture(albedo_texture, UV) * albedo_color;
			ALBEDO = color.rgb;
#ifndef OPAQUE
			ALPHA = color.a;
#endif
			// Other properties
			EMISSION = (texture(emission_texture, UV).rgb + emission_color) * emission_energy;
			SPECULAR = specular_value;
			METALLIC = dot(texture(metallic_texture, UV), texture_channel_vec[metallic_texture_channel]) * metallic_value;
			ROUGHNESS = dot(texture(roughness_texture, UV), texture_channel_vec[roughness_texture_channel]) * roughness_value;
			break;
	}
}

// Called once for every pixel-light pair.
void light()
{
	switch (camera_layers)
	{
		// Make sure it is unshaded for depth and normals
		case DEPTH_LAYER:
		case NORMALS_LAYER:
			DIFFUSE_LIGHT = vec3(0.0);
			SPECULAR_LIGHT = vec3(0.0);
			break;
		// Display regular light properties
		default:
			// Shaded material
			if (shaded)
			{
				// Calculate diffuse using Lambert model
				DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * LIGHT_COLOR / PI;
				// Calculate specular using Phong model
				// (with some modifications regarding how light is spread out due to roughness)
				vec3 LIGHT_REFLECTED = reflect(-LIGHT, NORMAL);
				float k = 12.0 * (1.0 - ROUGHNESS);
				float metallic_contribution = pow(16.0, METALLIC - 1.0);
				SPECULAR_LIGHT += pow(clamp(dot(VIEW, LIGHT_REFLECTED), 0.0, 1.0), pow(2.0, k)) *
								specular_value * ATTENUATION * LIGHT_COLOR * metallic_contribution *
								SPECULAR_AMOUNT * (k + 1.0) / PI;
			}
			// Unshaded material
			else
			{
				DIFFUSE_LIGHT = vec3(1.0);
				SPECULAR_LIGHT = vec3(0.0);
			}
			break;
	}
}
