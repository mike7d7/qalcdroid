extends Node
var answer = '';
var swipe_start;
@onready var result_string = get_tree().current_scene.get_node("%Label")

func _input(event):
	if event is InputEventScreenTouch && event.position.y > result_string.global_position.y + result_string.size.y:
		if event.pressed:
			swipe_start = event.position
		else:
			calcSwipe(event.position)

func calcSwipe(swipe_end):
	if swipe_start == null:
		return
	var swipe = swipe_end - swipe_start
	if abs(swipe.x) > 250:
		if swipe.x > 0:
			get_tree().current_scene.get_node("%TabContainer").select_next_available()
		else:
			get_tree().current_scene.get_node("%TabContainer").select_previous_available()
