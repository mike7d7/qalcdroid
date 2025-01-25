extends Node
var answer: String = '';
var exit: bool = false;
var popup_number: int = 0;
@onready var user_prefs: UserPreferences = UserPreferences.load_or_create()

func _ready() -> void:
	# print(ProjectSettings.globalize_path("user://variables.xml"))

	var cppcode: Node = get_tree().current_scene.get_node("%GDExample")
	
	var approximation_group: ButtonGroup = get_tree().current_scene.get_node("%Settings/VBoxContainer/PanelContainer/VBoxContainer/Button").get("button_group")
	var interval_switch: Node = get_tree().current_scene.get_node("%Settings/VBoxContainer/PanelContainer/VBoxContainer/CheckButton")
	var fractions_group: ButtonGroup = get_tree().current_scene.get_node("%Settings/VBoxContainer/PanelContainer2/VBoxContainer/CheckBox").get("button_group")
	var angle_unit_group: ButtonGroup = get_tree().current_scene.get_node("%Settings/VBoxContainer/PanelContainer3/VBoxContainer/CheckBox").get("button_group")
	var tab_swipe: Node = get_tree().current_scene.get_node("%Settings/VBoxContainer/Customization/VBoxContainer/CheckButton")
	
	#Change approximation type configuration
	approximation_group.connect("pressed", Callable(cppcode, "change_precision"))
	interval_switch.connect("toggled", Callable(cppcode, "change_interval"))
	fractions_group.connect("pressed", Callable(cppcode, "change_fraction"))
	angle_unit_group.connect("pressed", Callable(cppcode, "change_angle_unit"))
	tab_swipe.connect("toggled", Callable(cppcode, "change_tab_swipe"))
	
	approximation_group.get_buttons()[user_prefs.precision].set_pressed_no_signal(true)
	interval_switch.set_pressed_no_signal(user_prefs.interval)
	fractions_group.get_buttons()[user_prefs.fraction].set_pressed_no_signal(true)
	angle_unit_group.get_buttons()[user_prefs.angle_unit].set_pressed_no_signal(true)
	tab_swipe.set_pressed_no_signal(user_prefs.tab_swipe)
	
	get_tree().current_scene.get_node("/root/Control/rates_popup").size = get_tree().current_scene.get_node("/root/Control").size
	get_tree().current_scene.get_node("/root/Control/success_exchange_rate").size = get_tree().current_scene.get_node("/root/Control").size
	get_tree().current_scene.get_node("/root/Control/error_exchange_rate").size = get_tree().current_scene.get_node("/root/Control").size
	
	get_tree().current_scene.get_node("/root/Control/rates_popup").max_size = get_tree().current_scene.get_node("/root/Control").size
	get_tree().current_scene.get_node("/root/Control/success_exchange_rate").max_size = get_tree().current_scene.get_node("/root/Control").size
	get_tree().current_scene.get_node("/root/Control/error_exchange_rate").max_size = get_tree().current_scene.get_node("/root/Control").size
	
# Handles back button on Android, only exits on 2 consecutive back button events.
func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if exit:
			get_tree().quit()
		else:
			exit = true
			get_tree().create_timer(1.0).timeout.connect(set_exit_false)
		# If popup_number is 0 no popup is shown, other numbers are based
		# on the order of appearance in the editor in the main scene.
		match self.popup_number:
			0:
				return
			1:
				get_node("/root/Control/fn_popup").hide()
			2:
				get_node("/root/Control/rates_popup").hide()
			3:
				get_node("/root/Control/success_exchange_rate").hide()
			4:
				get_node("/root/Control/error_exchange_rate").hide()
			
func set_exit_false() -> void:
	exit = false
