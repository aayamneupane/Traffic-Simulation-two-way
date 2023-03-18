extends Control

export (PackedScene) var cars_scene
export (PackedScene) var pedestrian_scene

onready var left_spawn = $cars_spawn_location/left_lane

onready var right_spawn = $cars_spawn_location2/right_lane

onready var bottom_spawn = $pedestrian_spawn_location/bottom

onready var top_spawn = $pedestrian_spawn_location_2/top

onready var left_spawn_timer = $left_lane_spawn_time

onready var right_spawn_timer = $right_lane_spawn_time

onready var bottom_spawn_timer = $bottom_spawn_timer

onready var top_spawn_timer = $top_spawn_timer

onready var rng = RandomNumberGenerator.new()

onready var count



func _ready():
	
	rng.randomize()
	left_spawn_timer.wait_time = rng.randf_range(1.0, 5.0)
	right_spawn_timer.wait_time = rng.randf_range(1.0, 7.0)
	
	bottom_spawn_timer.wait_time = rng.randf_range(1.0, 3.0)
	top_spawn_timer.wait_time = rng.randf_range(1.0, 2.0)
	
	left_spawn_timer.start()
	right_spawn_timer.start()
	bottom_spawn_timer.start()
	top_spawn_timer.start()
	
	count = get_tree().get_nodes_in_group("INSTANCE").size()
	
	if (count >= 5):
		left_spawn_timer.stop()
		right_spawn_timer.stop()
	elif (count == 0):
		left_spawn_timer.start()
		right_spawn_timer.start()
	else:
		return


func spawn_vehicle(p_direction, p_spawn_position):
	
	var car = cars_scene.instance()
	car.direction = p_direction
	car.position = p_spawn_position
	if (p_direction == -1):
		car.rotation_degrees  = 180
	count = get_tree().get_nodes_in_group("INSTANCE").size()
	
	if (count >= 5):
		return
	
	
	add_child(car)
	
	car.add_to_group("INSTANCE")
	
	

	
func spawn_pedestrian(p_direction, p_spawn_position):
	
	var pedestrian = pedestrian_scene.instance()
	pedestrian.direction = p_direction
	pedestrian.position = p_spawn_position
	
	if (p_direction == 1):
		pedestrian.rotation_degrees  = 180
	
	add_child(pedestrian)



func _on_stopping_area_body_entered(body):
	
	if (body.type == "cars"):
		if (Global.current_light == Global.Traffic_light_state.RED or Global.current_light == Global.Traffic_light_state.YELLOW):
			body.moving = false
			
	if (body.type == "pedestrians"):
		if (Global.current_light == Global.Traffic_light_state.GREEN):
		
			body.moving = false
			body.get_child(0).playing = false
	
#		if (Global.current_light == Global.Traffic_light_state.RED or Global.Traffic_light_state.YELLOW):
#			body.moving = true


func _on_stopping_area_body_exited(body):
	
	body.moving = true


func _on_bottom_spawn_timer_timeout():
	
	randomize()
	rng.randomize()
	bottom_spawn_timer.wait_time = rng.randf_range(1.0, 3.0)
	$pedestrian_spawn_location/bottom.unit_offset = randf()
	spawn_pedestrian(-1, bottom_spawn.position)


func _on_top_spawn_timer_timeout():
	
	randomize()
	rng.randomize()
	top_spawn_timer.wait_time = rng.randf_range(1.0, 2.0)
	$pedestrian_spawn_location_2/top.unit_offset = randf()
	spawn_pedestrian(1, top_spawn.position)
	
func _on_left_lane_spawn_time_timeout():
	
	left_spawn_timer.wait_time = rng.randf_range(1.0, 8.0)
	spawn_vehicle(1, left_spawn.position)
	
	
func _on_right_lane_spawn_time_timeout():
	
	spawn_vehicle(-1, right_spawn.position)
	right_spawn_timer.wait_time = rng.randf_range(1.5, 9.0) 
