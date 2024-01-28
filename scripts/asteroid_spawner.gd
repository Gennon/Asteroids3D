extends Node3D

## Spaws an asteroid at a random corner of the screen
func spawn() -> void:
	var asteroid = load("res://scenes/asteroid.tscn").instantiate()
	add_child(asteroid)
	asteroid.global_position = get_random_position()

## Returns a random corner position of the screen
func get_random_position() -> Vector3:
	var camera_position = get_viewport().get_camera_3d().global_position
	var screen_size = get_viewport().get_visible_rect().size

	return get_viewport().get_camera_3d().project_position(
			Vector2(one_of([0, screen_size.x]), one_of([0, screen_size.y])),
			camera_position.y)

## Returns a random item from the list
func one_of(list) -> Variant:
	return list[randi() % list.size()]
