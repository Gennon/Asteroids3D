class_name TestAsteroid
extends GdUnitTestSuite

var asteroid_script = load("res://scripts/asteroid.gd")
const scene = "res://scenes/asteroid.tscn"

func before_test():
  # Adds a camera that is always looking at the origin from above
  var camera = auto_free(Camera3D.new())
  camera.global_position = Vector3(0, 50, 0)
  camera.rotation_degrees = Vector3(-90, 0, 0)
  add_child(camera)


func test_asteroid_script_exists():
  var asteroid = auto_free(asteroid_script.new())
  assert_object(asteroid).is_not_null()


func test_asteroid_moves_forward():
  var asteroid = scene_runner(scene)
  var initial_position = asteroid.get_property("global_position")
  await asteroid.simulate_frames(10)
  # The asteroid should have moved forward from its initial position
  assert_float(asteroid.get_property("global_position").z).is_not_equal(initial_position.z)


func test_asteroid_moves_forward_with_speed():
  var asteroid = scene_runner(scene)
  asteroid.set_property("direction", Vector3(0, 0, 1))
  # Measuring the distance traveled by the asteroid in 1 second and speed 1
  asteroid.set_property("speed", 1.0)
  var initial_position: Vector3 = asteroid.get_property("global_position")
  await await_millis(100)
  var second_position: Vector3 = asteroid.get_property("global_position")
  # Measuring the distance traveled by the asteroid in 1 second and speed 2
  asteroid.set_property("speed", 2.0)
  await await_millis(100)
  var third_position : Vector3 = asteroid.get_property("global_position")
  # The distance traveled by the asteroid with speed 2 should be greater
  # than the distance traveled by the asteroid with speed 1
  var length1 = (second_position - initial_position).length()
  var length2 = (third_position - second_position).length()
  assert_float(length2).is_greater(length1)


func test_asteroid_rotates():
  var asteroid = scene_runner(scene)
  var initial_rotation: Vector3 = asteroid.get_property("rotation")
  await asteroid.simulate_frames(10)
  # The asteroid should have rotated from its initial rotation
  assert_vector(asteroid.get_property("rotation")).is_not_equal(initial_rotation)


func test_asteroid_rotates_with_rotation_speed():
  var asteroid = scene_runner(scene)
  # Measuring the rotation of the asteroid in 1 second and rotation speed 1
  var initial_rotation : Vector3 = asteroid.get_property("rotation")
  asteroid.set_property("rotation_speed", 1.0)
  await await_millis(100)
  var second_rotation : Vector3 = asteroid.get_property("rotation")
  # Measuring the rotation of the asteroid in 1 second and rotation speed 2
  asteroid.set_property("rotation", initial_rotation)
  asteroid.set_property("rotation_speed", 2.0)
  await await_millis(100)
  # The rotation of the asteroid with rotation speed 2 should be greater
  # than the rotation of the asteroid with rotation speed 1
  assert_float(asteroid.get_property("rotation").length()).is_greater(second_rotation.length())


func test_asteroid_is_big_by_default():
  var asteroid = scene_runner(scene)
  assert_bool(asteroid.get_property("is_big")).is_true()


func test_big_astroid_has_larger_scale_than_small_asteroid():
  var big_asteroid = scene_runner(scene)
  big_asteroid.set_property("is_big", true)
  var small_asteroid = scene_runner(scene)
  small_asteroid.set_property("is_big", false)
  var big_scale = big_asteroid.get_property("scale")
  var small_scale = small_asteroid.get_property("scale")
  # The big asteroid should have a larger scale than the small asteroid
  assert_vector(big_scale).is_greater(small_scale)


func test_asteroids_has_random_scale():
  var asteroid1 = scene_runner(scene)
  var asteroid2 = scene_runner(scene)
  # The scale of the two asteroids should be different
  assert_vector(asteroid1.get_property("scale")).is_not_equal(asteroid2.get_property("scale"))


func test_big_asteroid_will_split_on_hit():
  var runner = scene_runner(scene)
  runner.set_property("is_big", true)
  var count1 = get_tree().get_nodes_in_group("asteroid")
  await await_idle_frame()
  runner.invoke("hit")
  await await_idle_frame()
  var count2 = get_tree().get_nodes_in_group("asteroid")
  # The number of asteroids in the scene should have increased
  assert_int(count1.size()).is_equal(1)
  assert_int(count2.size()).is_greater(count1.size())
  for asteroid in count2:
    asteroid.queue_free()


func test_small_asteroid_will_destroy_on_hit():
  var runner = scene_runner(scene)
  runner.set_property("is_big", false)
  var count1 = get_tree().get_nodes_in_group("asteroid")
  await await_idle_frame()
  runner.invoke("hit")
  await await_idle_frame()
  var count2 = get_tree().get_nodes_in_group("asteroid")
  # The number of asteroids in the scene should have decreased
  assert_int(count1.size()).is_equal(1)
  assert_int(count2.size()).is_equal(0)


func test_big_asteroid_will_instanciate_effect_on_hit():
  var runner = scene_runner(scene)
  runner.set_property("is_big", true)
  await await_idle_frame()
  runner.invoke("hit")
  await await_idle_frame()
  # The asteroid should have instanciated an effect
  var effect_found = false
  for child in get_tree().get_root().get_children():
    if child is GPUParticles3D:
      effect_found = true
  assert_bool(effect_found).is_true()


func test_small_asteroid_will_instanciate_effect_on_hit():
  var runner = scene_runner(scene)
  runner.set_property("is_big", false)
  await await_idle_frame()
  runner.invoke("hit")
  await await_idle_frame()
  # The asteroid should have instanciated an effect
  var effect_found = false
  for child in get_tree().get_root().get_children():
    if child is GPUParticles3D:
      effect_found = true
  assert_bool(effect_found).is_true()
	

func test_asteroids_should_move_in_random_direction():
  var asteroid1 = scene_runner(scene)
  var asteroid2 = scene_runner(scene)
  await asteroid1.simulate_frames(10)
  await asteroid2.simulate_frames(10)
  # The two asteroids should have different global positions
  assert_vector(asteroid1.get_property("global_position")).is_not_equal(asteroid2.get_property("global_position"))


func test_asteroids_should_move_with_different_speed():
  var asteroid1 = scene_runner(scene)
  var asteroid2 = scene_runner(scene)
  asteroid1.set_property("direction", Vector3.FORWARD)
  asteroid2.set_property("direction", Vector3.FORWARD)
  await asteroid1.simulate_frames(10)
  await asteroid2.simulate_frames(10)
  # The asteroids should move in the same direction but at different speeds
  assert_float(asteroid2.get_property("global_position").length()).is_not_equal(asteroid1.get_property("global_position").length())
