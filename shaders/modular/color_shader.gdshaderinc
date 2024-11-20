/**
 * color_shader.gdshaderinc
 *
 * Part of the modular approach to object shaders.
 *
 * This shader include file is used by both "opaque_color_shader.gdshader" and
 * "transparent_color_shader.gdshader". Since rendering opaque and transparent objects is almost
 * exactly the same (except for writing to ALPHA), it makes sense to consolidate the shared code in
 * a single file.
 *
 * This shader only handles rendering color info, which is rendered on all layers besides the depth
 * and normal layers. (This ensures that objects will appear correct in the editor.) It attempts to
 * render a material similar to StandardMaterial3D. (The list of available uniforms is a subset of
 * those available in StandardMaterial3D.)
 */



// PREPROCESSOR DIRECTIVES

// Contains layer numbers and some common functions
#include "res://shaders/globals.gdshaderinc"

// Common hints for uniform textures.
#define hint_texture filter_nearest_mipmap, repeat_enable



// UNIFORMS

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

/**
 * Specifies the channel of [code]metallic_texture[/code] in which metallic information is stored.
 * Channel 0: Red
 * Channel 1: Green
 * Channel 2: Blue
 * Channel 3: Alpha
 * Channel 4: Average of Red, Green, and Blue
 */
uniform int metallic_texture_channel : hint_range(0, 4) = 0;

group_uniforms roughness;

/** Surface reflection. A value of 0 represents a perfect mirror while a value of 1 completely blurs the reflection. */
uniform float roughness_value : hint_range(0.0, 1.0) = 1.0;

/** Texture used to control the roughness per-pixel. Multiplied by roughness. */
uniform sampler2D roughness_texture : hint_texture, hint_default_white;

/**
 * Specifies the channel of [code]roughness_texture[/code] in which roughness information is stored.
 * Channel 0: Red
 * Channel 1: Green
 * Channel 2: Blue
 * Channel 3: Alpha
 * Channel 4: Average of Red, Green, and Blue
 */
uniform int roughness_texture_channel : hint_range(0, 4) = 0;

group_uniforms emission;

/** The emitted light's color. Emitting light makes the object appear brighter. */
uniform vec3 emission_color : source_color = vec3(0.0, 0.0, 0.0);

/** Texture that specifies how much surface emits light at a given point. */
uniform sampler2D emission_texture : hint_texture, source_color, hint_default_black;

/** Multiplier for emitted light. */
uniform float emission_energy = 1.0;



// FUNCTIONS

// Called once for every vertex.
void vertex()
{
#ifdef VERTEX_DISCARD
	// Don't render if on the depth or normal layers
	if (CAMERA_VISIBLE_LAYERS == DEPTH_LAYER || CAMERA_VISIBLE_LAYERS == NORMAL_LAYER)
	{
		// This discards by setting the vertex to vec3(inf, inf, inf)
		VERTEX = vec3(1.0 / 0.0);
	}
#endif
}

// Called once for every pixel.
void fragment()
{
#ifndef VERTEX_DISCARD
	// Don't render if on the depth or normal layers
	if (CAMERA_VISIBLE_LAYERS == DEPTH_LAYER || CAMERA_VISIBLE_LAYERS == NORMAL_LAYER)
	{
		discard;
	}
#endif

	// Otherwise, render color
	vec4 color = texture(albedo_texture, UV) * albedo_color;
	ALBEDO = color.rgb;
#ifndef OPAQUE
	ALPHA = color.a;
#endif
	EMISSION = (texture(emission_texture, UV).rgb + emission_color) * emission_energy;
	SPECULAR = specular_value;
	METALLIC = dot(texture(metallic_texture, UV), texture_channel_vec[metallic_texture_channel]) * metallic_value;
	ROUGHNESS = dot(texture(roughness_texture, UV), texture_channel_vec[roughness_texture_channel]) * roughness_value;
}
