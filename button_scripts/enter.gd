extends GDExample

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed)
	pass # Replace with function body.

func _button_pressed():
	Globals.answer = _fun1($"../../../input".text)
	$"../../../ScrollContainer/Label".text = Globals.answer
	$"../../../input".grab_focus()

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

func change_precision(input):
	_change_precision(input.get_meta("index"))

func change_fraction(input):
	_change_fraction(input.get_meta("index"))
