extends Node2D


onready var red = $traffic_light_red
onready var yellow = $traffic_light_yellow
onready var green = $traffic_light_green

func _ready():
	
	yellow.hide()
	green.hide()
	red.hide()

	traffic_light_cycle()
	
	
func traffic_light_cycle():
	
	red_light()
	yield(get_tree().create_timer(10), "timeout")
	yellow_light()
	yield(get_tree().create_timer(3), "timeout")
	green_light()
	yield(get_tree().create_timer(15), "timeout")
	yellow_light()
	yield(get_tree().create_timer(3), "timeout")

func red_light():
	
	Global.change_light( Global.Traffic_light_state.RED)
	
	red.show()
	yellow.hide()
	green.hide()


func yellow_light():
	
	Global.change_light( Global.Traffic_light_state.YELLOW)
	
	
	yellow.show()
	green.hide()
	red.hide()
	
	
func green_light():
	
	Global.change_light( Global.Traffic_light_state.GREEN)
	
	green.show()
	yellow.hide()
	red.hide()
	


func _on_cycle_timer_timeout():
	
	traffic_light_cycle()
