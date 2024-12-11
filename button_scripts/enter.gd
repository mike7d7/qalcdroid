extends GDExample

@onready var input_node: Node = get_tree().current_scene.get_node("%input")
var user_prefs: UserPreferences

func _ready() -> void:
	self.pressed.connect(self._button_pressed)
	user_prefs = Globals.user_prefs
	self.load_settings()

func _button_pressed() -> void:
	Globals.answer = '[url]' + _calculate_and_print(input_node.text) + '[/url]'
	$"../../../../ScrollContainer/Label".text = Globals.answer
	input_node.grab_focus()

func get_unit(input: String) -> String:
	return _unit_abbreviation(input)

func get_max_args(input: String) -> int:
	return _get_function_max_args(input)

func get_arg_type(input: String, index: int) -> int:
	return _get_function_arg_type(input, index)

func get_arg_name(input: String, index: int) -> String:
	return _get_function_arg_name(input, index)

func get_arg_def_val(input: String, index: int) -> String:
	return _get_function_arg_def_val(input, index)

func get_min_args(input: String) -> int:
	return _get_function_min_args(input)

#Functions for setting user preferences
func change_precision(input) -> void:
	if typeof(input) != TYPE_INT:
		input = input.get_meta("index")
		user_prefs.precision = input
		user_prefs.save()
	_change_precision(input)
	if input_node.text:
		_button_pressed()

func change_interval(input: bool) -> void:
	user_prefs.interval = input
	user_prefs.save()
	_change_interval(input)
	if input_node.text:
		_button_pressed()

func change_fraction(input) -> void:
	if typeof(input) != TYPE_INT:
		input = input.get_meta("index")
		user_prefs.fraction = input
		user_prefs.save()
	_change_fraction(input)
	if input_node.text:
		_button_pressed()

func change_angle_unit(input) -> void:
	if typeof(input) != TYPE_INT:
		input = input.get_meta("index")
		user_prefs.angle_unit = input
		user_prefs.save()
	_change_angle_unit(input)
	if input_node.text:
		_button_pressed()
		
func change_tab_swipe(input: bool) -> void:
	if input:
		get_tree().current_scene.get_node("%TabContainer").swipe_threshold = 128
	else:
		get_tree().current_scene.get_node("%TabContainer").swipe_threshold = 9223372036854775807
	user_prefs.tab_swipe = input
	user_prefs.save()


func load_settings() -> void:
	self.change_precision(user_prefs.precision)
	self.change_interval(user_prefs.interval)
	self.change_fraction(user_prefs.fraction)
	self.change_angle_unit(user_prefs.angle_unit)
	self.change_tab_swipe(user_prefs.tab_swipe)
