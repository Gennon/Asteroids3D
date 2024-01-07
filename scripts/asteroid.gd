extends Area3D

@export var speed := 5.0
@export var rotation_speed := 0.5

var is_big := true

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_big:
		scale = Vector3(2, 2, 2)
	else:
		scale = Vector3(0.5, 0.5, 0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector3.FORWARD * speed * delta;

	rotate_z(delta * rotation_speed)
