extends Node
var answer = '';
@onready var result_string = get_tree().current_scene.get_node("%Label")
@onready var user_prefs: UserPreferences = UserPreferences.load_or_create()

func _ready() -> void:
	var cppcode = get_tree().current_scene.get_node("%GDExample")
	
	var approximation_group = get_tree().current_scene.get_node("%Settings/VBoxContainer/PanelContainer/VBoxContainer/Button").get("button_group")
	var interval_switch = get_tree().current_scene.get_node("%Settings/VBoxContainer/PanelContainer/VBoxContainer/CheckButton")
	var fractions_group = get_tree().current_scene.get_node("%Settings/VBoxContainer/PanelContainer2/VBoxContainer/CheckBox").get("button_group")
	var angle_unit_group = get_tree().current_scene.get_node("%Settings/VBoxContainer/PanelContainer3/VBoxContainer/CheckBox").get("button_group")
	
	#Change approximation type configuration
	approximation_group.connect("pressed", Callable(cppcode, "change_precision"))
	interval_switch.connect("toggled", Callable(cppcode, "change_interval"))
	fractions_group.connect("pressed", Callable(cppcode, "change_fraction"))
	angle_unit_group.connect("pressed", Callable(cppcode, "change_angle_unit"))
	
	approximation_group.get_buttons()[user_prefs.precision].set_pressed_no_signal(true)
	interval_switch.set_pressed_no_signal(user_prefs.interval)
	fractions_group.get_buttons()[user_prefs.fraction].set_pressed_no_signal(true)
	angle_unit_group.get_buttons()[user_prefs.angle_unit].set_pressed_no_signal(true)
