extends Node3D

var top_left: = Vector3()
var bottom_right: = Vector3()

func _ready() -> void:
	# Check if there is a camera in the scene
	if get_viewport().get_camera_3d() == null:
		print("No camera found in the scene.")
		return

	var camera_position = get_viewport().get_camera_3d().global_position
	var screen_size = get_viewport().get_visible_rect().size

	top_left = get_viewport().get_camera_3d().project_position(
			Vector2.ZERO, 
			camera_position.y)

	bottom_right = get_viewport().get_camera_3d().project_position(
			Vector2(screen_size.x, screen_size.y), 
			camera_position.y)

func _process(_delta: float) -> void:
	# Check if there is a camera in the scene
	if get_viewport().get_camera_3d() == null:
		return
	wrap_position()


# wrap the object around the screen when it goes off the screen
func wrap_position() -> void:	
	if get_parent().position.x < top_left.x:
		get_parent().position.x = bottom_right.x
	elif get_parent().position.x > bottom_right.x:
		get_parent().position.x = top_left.x

	if get_parent().position.z < top_left.z:
		get_parent().position.z = bottom_right.z
	elif get_parent().position.z > bottom_right.z:
		get_parent().position.z = top_left.z
