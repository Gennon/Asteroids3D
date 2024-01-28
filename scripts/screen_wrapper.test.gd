extends GutTest

var Wrapper = load("res://scripts/screen_wrapper.gd")
var Scene = load("res://scenes/screen_wrapper.tscn")


func before_each():
  # Adds a camera that is always looking at the origin from above
  var camera = partial_double(Camera3D).new()
  add_child(camera)
  camera.global_position = Vector3(0, 50, 0)
  camera.rotation_degrees = Vector3(-90, 0, 0)


func test_wrapper_exists():
  var wrapper = partial_double(Wrapper).new()
  assert_not_null(wrapper)


func test_wrapper_will_not_wrap_while_standing_still():
  var wrapper = partial_double(Scene).instantiate()
  var parent_node = Node3D.new()
  parent_node.add_child(wrapper)
  add_child(parent_node)
  var initial_position = wrapper.global_position
  simulate(wrapper, 1, 0.1)
  assert_eq(wrapper.global_position, initial_position)
  parent_node.queue_free()


func test_wrapper_calculates_visible_area():
  var wrapper = partial_double(Scene).instantiate()
  add_child(wrapper)
  assert_ne(wrapper.top_left, Vector3(0, 0, 0))
  assert_ne(wrapper.bottom_right, Vector3(0, 0, 0))


func test_wrapper_will_wrap_when_moving_above_top():
  var wrapper = partial_double(Scene).instantiate()
  var parent_node = Node3D.new()
  parent_node.add_child(wrapper)
  add_child(parent_node)
  # We position the wrapper so that it is just above the top of the screen
  parent_node.global_position.z = wrapper.top_left.z - 1
  simulate(wrapper, 1, 0.1)
  # We expect the wrapper to have wrapped to the bottom of the screen
  assert_eq(wrapper.global_position.z, wrapper.bottom_right.z)
  parent_node.queue_free()


func test_wrapper_will_wrap_when_moving_below_bottom():
  var wrapper = partial_double(Scene).instantiate()
  var parent_node = Node3D.new()
  parent_node.add_child(wrapper)
  add_child(parent_node)
  # We position the wrapper so that it is just below the bottom of the screen
  parent_node.global_position.z = wrapper.bottom_right.z + 1
  simulate(wrapper, 1, 0.1)
  # We expect the wrapper to have wrapped to the top of the screen
  assert_eq(wrapper.global_position.z, wrapper.top_left.z)
  parent_node.queue_free()


func test_wrapper_will_wrap_when_moving_outside_left():
  var wrapper = partial_double(Scene).instantiate()
  var parent_node = Node3D.new()
  parent_node.add_child(wrapper)
  add_child(parent_node)
  # We position the wrapper so that it is just outside the left of the screen
  parent_node.global_position.x = wrapper.top_left.x - 1
  simulate(wrapper, 1, 0.1)
  # We expect the wrapper to have wrapped to the right of the screen
  assert_eq(wrapper.global_position.x, wrapper.bottom_right.x)
  parent_node.queue_free()


func test_wrapper_will_wrap_when_moving_outside_right():
  var wrapper = partial_double(Scene).instantiate()
  var parent_node = Node3D.new()
  parent_node.add_child(wrapper)
  add_child(parent_node)
  # We position the wrapper so that it is just outside the right of the screen
  parent_node.global_position.x = wrapper.bottom_right.x + 1
  simulate(wrapper, 1, 0.1)
  # We expect the wrapper to have wrapped to the left of the screen
  assert_eq(wrapper.global_position.x, wrapper.top_left.x)
  parent_node.queue_free()