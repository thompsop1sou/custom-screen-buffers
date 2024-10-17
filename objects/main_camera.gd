@tool
class_name MainCamera
extends Camera3D
## This is a custom node meant to hold several child [Camera3D]s and their connected [SubViewport]s.
## It ensures that the properties of the cameras are all synced up with the properties of this main
## camera. It also ensures that the sizes of the subviewports all match the viewport which is a
## parent of this camera. This means that the textures from the subviewports will be the same
## resolution as the main viewport.



# PUBLIC PROPERTIES

## Holds an array of properties that are unique to Camera3Ds.
static var camera_3d_unique_properties: Array[StringName] = get_camera_3d_unique_properties()



# PRIVATE PROPERTIES

# Camera3D properties which should not be copied to the child cameras.
var _excluded_properties: Array[StringName] = [&"cull_mask", &"current", &"environment"]

# Keep references to various child nodes.
@onready var _viewports: Array[Node] = find_children("*", "SubViewport")
@onready var _cameras: Array[Node] = find_children("*", "Camera3D")

# Keep a reference to the viewport which is above this camera.
@onready var _parent_viewport: Viewport = get_viewport()



# PUBLIC METHODS

## Returns a list of property names unique to a Camera3D
static func get_camera_3d_unique_properties() -> Array[StringName]:
	var child_camera_settable_properties: Array[StringName] = []
	for prop in Camera3D.new().get_property_list():
		child_camera_settable_properties.append(prop["name"])
	for prop in Node3D.new().get_property_list():
		child_camera_settable_properties.erase(prop["name"])
	return child_camera_settable_properties



# PRIVATE METHODS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to changes in the parent viewport
	if is_instance_valid(_parent_viewport):
		_parent_viewport.size_changed.connect(_on_parent_viewport_size_changed)
		_on_parent_viewport_size_changed.call_deferred()

# Called whenever the parent viewport's size changes.
func _on_parent_viewport_size_changed() -> void:
	if !Engine.is_editor_hint() and is_instance_valid(_parent_viewport):
		# Update the size of any child viewport nodes
		for viewport: Node in _viewports:
			if viewport is SubViewport:
				viewport.size = _parent_viewport.size

# Overriding what happens when a property is set
# Keeps the depth and normals camera in sync with the main camera
func _set(property: StringName, value: Variant) -> bool:
	# This branch sets both the main camera and the child cameras
	if property in camera_3d_unique_properties and property not in _excluded_properties:
		for camera: Node in _cameras:
			if camera is Camera3D:
				camera.set(property, value)
		return false
	# This branch only sets the main camera
	else:
		return false
