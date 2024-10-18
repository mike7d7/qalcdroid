extends Node
var answer = '';
var swipe_start;
@onready var result_string = get_tree().current_scene.get_node("%Label")
@onready var user_prefs: UserPreferences = UserPreferences.load_or_create()

func _ready() -> void:
	var cppcode = get_tree().current_scene.get_node("%GDExample")
	
	var approximation_group = get_tree().current_scene.get_node("%Settings/VBoxContainer/Button").get("button_group")
	var interval_switch = get_tree().current_scene.get_node("%Settings/VBoxContainer/CheckButton")
	var fractions_group = get_tree().current_scene.get_node("%Settings/VBoxContainer/CheckBox").get("button_group")
	
	#Change approximation type configuration
	approximation_group.connect("pressed", Callable(cppcode, "change_precision"))
	interval_switch.connect("toggled", Callable(cppcode, "change_interval"))
	fractions_group.connect("pressed", Callable(cppcode, "change_fraction"))
	
	approximation_group.get_buttons()[user_prefs.precision].set_pressed_no_signal(true)
	interval_switch.set_pressed_no_signal(user_prefs.interval)
	fractions_group.get_buttons()[user_prefs.fraction].set_pressed_no_signal(true)


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
		if swipe.x < 0:
			get_tree().current_scene.get_node("%TabContainer").select_next_available()
		else:
			get_tree().current_scene.get_node("%TabContainer").select_previous_available()
