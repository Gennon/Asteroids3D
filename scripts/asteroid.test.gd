extends GutTest

var Asteroid = load("res://scripts/asteroid.gd")
var Scene = load("res://scenes/asteroid.tscn")

func test_asteroid_exists():
  var asteroid = double(Asteroid).new()
  assert_true(asteroid != null)


func test_asteroid_moves_forward():
  var asteroid = partial_double(Scene).instantiate()
  add_child(asteroid)
  var initial_position = asteroid.global_position
  simulate(asteroid, 10, 0.1)
  # The asteroid should have moved forward from its initial position
  assert_not_same(asteroid.global_position.z, initial_position.z)
  

func test_asteroid_moves_forward_with_speed():
  var asteroid = partial_double(Scene).instantiate()
  add_child(asteroid)
  # Measuring the distance traveled by the asteroid in 1 second and speed 1
  asteroid.speed = 1
  var initial_position = asteroid.global_position
  simulate(asteroid, 10, 0.1)
  var second_position = asteroid.global_position
  # Measuring the distance traveled by the asteroid in 1 second and speed 2
  asteroid.global_position = initial_position
  asteroid.speed = 2
  simulate(asteroid, 10, 0.1)
  # The distance traveled by the asteroid with speed 2 should be greater
  # than the distance traveled by the asteroid with speed 1
  assert_gt(abs(asteroid.global_position.z), abs(second_position.z))


func test_asteroid_rotates():
  var asteroid = partial_double(Scene).instantiate()
  add_child(asteroid)
  var initial_rotation = asteroid.rotation
  simulate(asteroid, 10, 0.1)
  # The asteroid should have rotated from its initial rotation
  assert_not_same(asteroid.rotation, initial_rotation)


func test_asteroid_rotates_with_rotation_speed():
  var asteroid = partial_double(Scene).instantiate()
  add_child(asteroid)
  # Measuring the rotation of the asteroid in 1 second and rotation speed 1
  asteroid.rotation_speed = 1
  var initial_rotation = asteroid.rotation
  simulate(asteroid, 10, 0.1)
  var second_rotation = asteroid.rotation
  # Measuring the rotation of the asteroid in 1 second and rotation speed 2
  asteroid.rotation = initial_rotation
  asteroid.rotation_speed = 2
  simulate(asteroid, 10, 0.1)
  # The rotation of the asteroid with rotation speed 2 should be greater
  # than the rotation of the asteroid with rotation speed 1
  assert_gt(abs(asteroid.rotation), abs(second_rotation))
  

func test_asteroid_is_big_by_default():
  var asteroid = partial_double(Scene).instantiate()
  add_child(asteroid)
  assert_true(asteroid.is_big)


func test_big_astroid_has_larger_scale():
  var asteroid_big = partial_double(Scene).instantiate()
  add_child(asteroid_big)
  var asteroid_small = partial_double(Scene).instantiate()
  asteroid_small.is_big = false
  add_child(asteroid_small)
  assert_gt(asteroid_big.scale, asteroid_small.scale)