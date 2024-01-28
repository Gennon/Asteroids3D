extends GutTest

var AsteroidSpawner = load("res://scripts/asteroid_spawner.gd")
var Scene = load("res://scenes/asteroid_spawner.tscn")

func before_each():
  # Adds a camera that is always looking at the origin from above
  var camera = add_child_autoqfree(Camera3D.new())
  camera.global_position = Vector3(0, 50, 0)
  camera.rotation_degrees = Vector3(-90, 0, 0)


func test_asteroid_spawner_exists():
  var spawner = partial_double(AsteroidSpawner).new()
  assert_not_null(spawner)


func test_asteroid_spawner_spawns_asteroids():
  var spawner = partial_double(Scene).instantiate()
  add_child(spawner)
  spawner.spawn()
  await wait_frames(1)
  var asteroids = get_tree().get_nodes_in_group("asteroid")
  assert_eq(1, asteroids.size())


func test_asteroid_spawner_spawns_asteroids_with_random_positions():
  var spawner = partial_double(Scene).instantiate()
  add_child(spawner)
  spawner.spawn()
  spawner.spawn()
  await wait_frames(1)
  var asteroids = get_tree().get_nodes_in_group("asteroid")
  assert_ne(asteroids[0].global_position, asteroids[1].global_position)