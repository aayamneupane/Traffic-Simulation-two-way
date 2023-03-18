extends KinematicBody2D


onready var speed: int
onready var direction: int
onready var velocity: Vector2
onready var moving = true
onready var people = $people
signal ped_dead
#onready var collision
onready var fade_tween = $dead/fade_tween

export var type : String = "pedestrians"

func _ready():
	$dead.hide()
	randomize()
	people.playing = true
	Global.connect("signal_change",self,"change_body_motion")
	
	var frame_names = people.frames.get_animation_names()
	people.animation = frame_names[randi() % frame_names.size()]
	
	speed = rand_range(50.0, 70.0)

func _process(delta):
	
	if (moving):
		velocity = Vector2(0, direction) * speed
		move_and_collide(velocity * delta)
#		if(collision!= null):
#			people.playing = false

func change_body_motion(val):
	if(val == Global.Traffic_light_state.RED or val == Global.Traffic_light_state.YELLOW):
		moving = true
		people.playing = true
	
	elif (val == Global.Traffic_light_state.GREEN):
#		moving = false
		pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_body_entered(body):
	
	if (body.type == "cars"):
		
		$dead.show()
		$people.hide()
		moving = false
		velocity = Vector2.ZERO
		if fade_tween.is_inside_tree():
			fade_tween.interpolate_property($dead, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 3 )
			fade_tween.start()
	#		$Area2D/CollisionShape2D2.disabled = true
			yield(fade_tween, "tween_completed")
			queue_free()


