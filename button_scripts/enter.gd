extends GDExample

@onready var input_node = get_tree().current_scene.get_node("%input")
var user_prefs: UserPreferences
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed)
	user_prefs = Globals.user_prefs
	self.load_settings()
	pass # Replace with function body.

func _button_pressed():
	Globals.answer = _calculate_and_print(input_node.text)
	$"../../../../ScrollContainer/Label".text = Globals.answer
	input_node.grab_focus()

func get_unit(input):
	return _unit_abbreviation(input)

func get_max_args(input):
	return _get_function_max_args(input)

func get_arg_type(input, index):
	return _get_function_arg_type(input, index)

func get_arg_name(input, index):
	return _get_function_arg_name(input, index)

func get_arg_def_val(input, index):
	return _get_function_arg_def_val(input, index)

func get_min_args(input):
	return _get_function_min_args(input)

#Functions for setting user preferences
func change_precision(input):
	if typeof(input) != TYPE_INT:
		input = input.get_meta("index")
		user_prefs.precision = input
		user_prefs.save()
	_change_precision(input)
	if input_node.text:
		_button_pressed()

func change_interval(input):
	user_prefs.interval = input
	user_prefs.save()
	_change_interval(input)
	if input_node.text:
		_button_pressed()

func change_fraction(input):
	if typeof(input) != TYPE_INT:
		input = input.get_meta("index")
		user_prefs.fraction = input
		user_prefs.save()
	_change_fraction(input)
	if input_node.text:
		_button_pressed()

func change_angle_unit(input):
	if typeof(input) != TYPE_INT:
		input = input.get_meta("index")
		user_prefs.angle_unit = input
		user_prefs.save()
	_change_angle_unit(input)
	if input_node.text:
		_button_pressed()
		

func load_settings():
	self.change_precision(user_prefs.precision)
	self.change_interval(user_prefs.interval)
	self.change_fraction(user_prefs.fraction)
	self.change_angle_unit(user_prefs.angle_unit)
