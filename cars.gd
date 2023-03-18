extends KinematicBody2D

#onready var direction: int
onready var speed: int
onready var direction: int
onready var velocity: Vector2 = Vector2.ZERO
onready var moving = true
onready var obj_detection = false
onready var cars = $many_cars
onready var deceleration = 2

export var type : String = "cars"

func _ready():
	randomize()
	Global.connect("signal_change",self,"change_body_motion")
	
	var frame_names = cars.frames.get_animation_names()
	cars.animation = frame_names[randi() % frame_names.size()]
	speed = rand_range(200.0, 400.0)


func change_body_motion(val):
	
	if(val == Global.Traffic_light_state.GREEN):
		moving = true
	

func slow_down(_arg : String):
	pass

	
func _physics_process(delta):
	

	if (moving):
#		print('------------')
		velocity = Vector2(direction, 0) * speed
		move_and_collide(velocity * delta)

#	else :
#		print("//////////////")
#		velocity.x = lerp(velocity.x, 0, 0.6 )
#		move_and_collide(velocity)

#	if (moving):
#		velocity = Vector2(direction, 0) * speed * delta
#		move_and_collide(velocity)
#
#	elif (obj_detection or velocity.length() != 0):
#		print("initial velocity ", velocity)
#		velocity.x = lerp(velocity.x, 0, deceleration)
##		velocity.x -= deceleration * delta
#		print("final velocity ", velocity)
#		move_and_collide(velocity * delta)

#	if (moving and obj_detection):
#
#		velocity = Vector2(direction, 0) * speed
#		move_and_collide(velocity * delta)
#
##
#	elif (moving and !obj_detection):
#
#		velocity = Vector2(direction, 0) * 10
##		velocity.x = lerp(velocity.x, 0, deceleration * delta)
#		move_and_collide(velocity)
##		velocity = lerp(velocity.x, 0, deceleration)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_detector_body_entered(body):
	obj_detection = true


func _on_detector_area_entered(area):
	obj_detection = true
