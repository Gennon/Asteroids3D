class_name TestAsteroidSpawner
extends GdUnitTestSuite

var __source = load("res://scripts/asteroid_spawner.gd")
const scene = "res://scenes/asteroid_spawner.tscn"


func before_test():
  # Adds a camera that is always looking at the origin from above
  var camera = auto_free(Camera3D.new())
  camera.global_position = Vector3(0, 50, 0)
  camera.rotation_degrees = Vector3(-90, 0, 0)
  add_child(camera)


func test_script_exists():
  var spawner = auto_free(__source.new())
  assert_object(spawner).is_not_null()


func test_asteroid_spawner_spawns_asteroids():
  var spawner := scene_runner(scene)
  spawner.invoke("spawn")
  await await_idle_frame()
  var asteroids = spawner.find_child("asteroid")
  assert_array(asteroids).is_not_empty()
  

func test_asteroid_spawner_spawns_asteroids_with_random_positions():
  var spawner := scene_runner(scene)
  spawner.invoke("spawn")
  await await_idle_frame()
  var asteroids = get_tree().get_nodes_in_group("asteroid")
  assert_array(asteroids).is_not_empty()
  assert_array(asteroids).has_size(1)
  spawner.invoke("spawn")
  await await_idle_frame()
  asteroids = get_tree().get_nodes_in_group("asteroid")
  assert_array(asteroids).has_size(2)
  assert_vector(asteroids[0].global_position).is_not_equal(asteroids[1].global_position)