extends Area3D

signal destroyed()

@export var explosion: PackedScene = load("res://scenes/explosion.tscn")

@export_category("Configuration")
@export var speed_variation := Vector2(2, 5)
@export var rotation_speed := 0.5
@export var scale_factor := 0.2
@export var color_factor := 0.2

var scene := load("res://scenes/asteroid.tscn")
var color = Color(0.3, 0.3, 0.3, 1)
var direction := Vector3(0, 0, 0)
var speed = 5.0
var _is_big := true
var is_big: bool:
	set(value):
		set_is_big(value)
	get:
		return _is_big

func set_is_big(value: bool):
	_is_big = value
	var scale_variance := Vector3(
		randf_range(-1, 1) * scale_factor, 
		randf_range(-1, 1) * scale_factor, 
		randf_range(-1, 1) * scale_factor)

	scale = (Vector3(2, 2, 2) if is_big else Vector3(0.5, 0.5, 0.5)) + scale_variance
 

func _ready():	
	# Set random size
	set_is_big(is_big)
	# sets random direction
	direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	# sets random speed
	speed = randf_range(speed_variation.x, speed_variation.y)


func _process(delta):
	position += direction * speed * delta;
	rotate_z(delta * rotation_speed)



## Spawn 1-3 new asteroids when hit if big
## Just destroy if small
func hit():
	destroyed.emit()
	spawn_explosion()
	if is_big:
		spawn_small_asteroids()
	queue_free()


## Spawn explosion and star emmiter
func spawn_explosion():
	var explosion_instance = explosion.instantiate()
	explosion_instance.position = position
	explosion_instance.emitting = true
	get_parent().add_child(explosion_instance)


## Spawn small asteroids
func spawn_small_asteroids():
	var number_of_asteroids := randi() % 2 + 2
	for i in range(number_of_asteroids):
		var asteroid = scene.instantiate()
		asteroid.position = position
		asteroid.is_big = false
		get_parent().add_child(asteroid)
