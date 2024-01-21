extends Area3D

signal destroyed

@export var explosion: PackedScene = load("res://scenes/explosion.tscn")

@export_category("Configuration")
@export var speed := 5.0
@export var rotation_speed := 0.5
@export var scale_factor := 0.2
@export var color_factor := 0.2

var scene := load("res://scenes/asteroid.tscn")
var color = Color(0.3, 0.3, 0.3, 1)
var is_big := true
 

func _ready():
	var scale_variance := Vector3(randf_range(-1, 1) * scale_factor, randf_range(-1, 1) * scale_factor, randf_range(-1, 1) * scale_factor)
	if is_big:
		scale = Vector3(2, 2, 2) + scale_variance
	else:
		scale = Vector3(0.5, 0.5, 0.5) + scale_variance

	# Set shader color
	var random_color_variance = randf_range(-1, 1) * color_factor
	color += Color(random_color_variance, random_color_variance, random_color_variance, 0)
	get_node("AsteroidMesh").get_surface_override_material(0).set_shader_parameter("color", color)


func _process(delta):
	position += Vector3.FORWARD * speed * delta;
	rotate_z(delta * rotation_speed)



## Spawn 1-3 new asteroids when hit if big
## Just destroy if small
func hit():
	destroyed.emit()
	spawn_explosion()
	if is_big:
		spawn_small_asteroids()
		queue_free()
	else:
		queue_free()


## Spawn explosion
func spawn_explosion():
	var explosion_instance = explosion.instantiate()
	explosion_instance.position = position
	get_parent().add_child(explosion_instance)


## Spawn small asteroids
func spawn_small_asteroids():
	var number_of_asteroids := randi() % 2 + 2
	for i in range(number_of_asteroids):
		var asteroid = scene.instantiate()
		asteroid.position = position
		asteroid.is_big = false
		get_parent().add_child(asteroid)
