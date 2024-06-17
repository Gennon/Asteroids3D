class_name TestScreenWrapper
extends GdUnitTestSuite

var __source = load("res://scripts/screen_wrapper.gd")
# The asteroid scene is used to test the wrapper
var scene := "res://scenes/asteroid.tscn"


func before_test():
  # Adds a camera that is always looking at the origin from above
  var camera = auto_free(Camera3D.new())
  camera.global_position = Vector3(0, 50, 0)
  camera.rotation_degrees = Vector3(-90, 0, 0)
  add_child(camera)


func test_script_exists():
  var wrapper = auto_free(__source.new())
  assert_object(wrapper).is_not_null()


func test_wrapper_will_not_wrap_while_standing_still():
  var parent_node = auto_free(Node3D.new())
  var wrapper = auto_free(__source.new())
  parent_node.add_child(wrapper)
  var initial_position = parent_node.global_position
  await await_millis(1)
  assert_vector(parent_node.global_position).is_equal(initial_position)


func test_wrapper_calculates_visible_area():
  var runner = scene_runner(scene)
  await await_idle_frame()
  var wrapper = runner.find_child("ScreenWrapper")
  var top_left: Vector3 = wrapper.top_left
  var bottom_right: Vector3 = wrapper.bottom_right
  # We expect the top left and bottom right corners to be non-zero
  assert_vector(top_left).is_not_equal(Vector3.ZERO)
  assert_vector(bottom_right).is_not_equal(Vector3.ZERO)


func test_wrapper_will_wrap_when_moving_above_top():
  var runner = scene_runner(scene)
  var wrapper = runner.find_child("ScreenWrapper")
  # We position the wrapper so that it is just above the top of the screen
  runner.set_property("directopm", Vector3(0, 0, -1))
  runner.set_property("global_position", Vector3(0, 0, wrapper.top_left.z - 1))
  await runner.simulate_frames(1)
  # We expect the wrapper to have wrapped to the bottom of the screen
  var new_position = runner.get_property("global_position")
  assert_float(new_position.z).is_less(wrapper.bottom_right.z)


func test_wrapper_will_wrap_when_moving_below_bottom():
  var runner = scene_runner(scene)
  var wrapper = runner.find_child("ScreenWrapper")
  # We position the wrapper so that it is just below the bottom of the screen
  runner.set_property("direction", Vector3(0, 0, 1))
  runner.set_property("global_position", Vector3(0, 0, wrapper.bottom_right.z + 1))
  await runner.simulate_frames(1)
  # We expect the wrapper to have wrapped to the top of the screen
  var new_position = runner.get_property("global_position")
  assert_float(new_position.z).is_greater(wrapper.top_left.z)


func test_wrapper_will_wrap_when_moving_outside_left():
  var runner = scene_runner(scene)
  var wrapper = runner.find_child("ScreenWrapper")
  # We position the wrapper so that it is just outside the left of the screen
  runner.set_property("direction", Vector3(-1, 0, 0))
  runner.set_property("global_position", Vector3(wrapper.top_left.x - 1, 0, 0))
  await runner.simulate_frames(1)
  # We expect the wrapper to have wrapped to the right of the screen
  var new_position = runner.get_property("global_position")
  assert_float(new_position.x).is_less(wrapper.bottom_right.x)


func test_wrapper_will_wrap_when_moving_outside_right():
  var runner = scene_runner(scene)
  var wrapper = runner.find_child("ScreenWrapper")
  # We position the wrapper so that it is just outside the right of the screen
  runner.set_property("direction", Vector3(1, 0, 0))
  runner.set_property("global_position", Vector3(wrapper.bottom_right.x + 1, 0, 0))
  await runner.simulate_frames(1)
  # We expect the wrapper to have wrapped to the left of the screen
  var new_position = runner.get_property("global_position")
  assert_float(new_position.x).is_greater(wrapper.top_left.x)