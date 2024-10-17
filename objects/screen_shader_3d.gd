@tool
class_name ScreenShader3D
extends Node3D
## An encapsulated way to add a post-processing effect to a scene.
##
## This uses a full-screen quad to add a post-processing effect to a scene, as described here:
## [url=https://docs.godotengine.org/en/latest/tutorials/shaders/advanced_postprocessing.html]Advanced post-processing[/url].



# PUBLIC PROPERTIES

## Whether to display this screen shader in the editor.
@export var display_in_editor := false:
	get:
		return display_in_editor
	set(value):
		display_in_editor = value
		if Engine.is_editor_hint():
			_full_screen_quad.visible = display_in_editor

## Whether to display this screen shader in the running game.
@export var display_in_game := true:
	get:
		return display_in_game
	set(value):
		display_in_game = value
		if not Engine.is_editor_hint():
			_full_screen_quad.visible = display_in_game

## The shader material to put on the full-screen quad.
@export var shader_material := ShaderMaterial.new():
	get:
		return shader_material
	set(value):
		shader_material = value
		_full_screen_quad.mesh.surface_set_material(0, shader_material)

## The rendering layers that this screen shader will appear on.
@export_flags_3d_render var layers := 0:
	get:
		return layers
	set(value):
		layers = value
		_full_screen_quad.layers = layers



# PRIVATE PROPERTIES

# The full-screen quad that will be put over the whole screen.
var _full_screen_quad := MeshInstance3D.new()



# PRIVATE METHODS

# Constructor
func _init() -> void:
	# Set it up to use the "screen_shader.gd_shader" by default.
	shader_material.shader = load("res://shaders/screen_shader.gdshader")
	# Set up the mesh
	var quad_mesh := QuadMesh.new()
	quad_mesh.size = Vector2(2.0, 2.0)
	quad_mesh.material = shader_material
	quad_mesh.flip_faces = true
	_full_screen_quad.mesh = quad_mesh
	_full_screen_quad.extra_cull_margin = 16384
	# Set up visibility
	if Engine.is_editor_hint():
		_full_screen_quad.visible = display_in_editor
	else:
		_full_screen_quad.visible = display_in_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Add the full-screen quad
	add_child(_full_screen_quad)
