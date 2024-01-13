extends Area3D

@export var speed := 5.0
@export var rotation_speed := 0.5
@export var explosion: PackedScene = load("res://scenes/explosion.tscn")

var scene := load("res://scenes/asteroid.tscn")


var is_big := true


func _ready():
	if is_big:
		scale = Vector3(2, 2, 2)
	else:
		scale = Vector3(0.5, 0.5, 0.5)



func _process(delta):
	position += Vector3.FORWARD * speed * delta;
	rotate_z(delta * rotation_speed)



## Spawn 1-3 new asteroids when hit if big
## Just destroy if small
func hit():
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
