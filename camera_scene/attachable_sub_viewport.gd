@tool
class_name AttachableSubViewport
extends SubViewport
## Extends the functionality of a [SubViewport] by allowing it to be attached to a custom [Camera3D].



# PROPERTIES

## The [Camera3D] that this [SubViewport] will attach to.
@export var camera: Camera3D = null:
	get:
		return camera
	set(value):
		camera = value
		if is_instance_valid(camera):
			RenderingServer.viewport_attach_camera(get_viewport_rid(), camera.get_camera_rid())
