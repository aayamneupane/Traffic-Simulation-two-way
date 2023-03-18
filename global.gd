extends Node

signal signal_change(light)

enum Traffic_light_state {
	
	RED
	GREEN
	YELLOW
}

onready var current_light = Traffic_light_state.RED


func change_light(val):
	current_light = val
	emit_signal("signal_change",val)


func _ready():
	
	if (current_light == Traffic_light_state.GREEN):
		emit_signal("signal_change")
