extends GDExample

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed)
	pass # Replace with function body.

func _button_pressed():
	Globals.answer = _fun1($"../../../input".text)
	$"../../../ScrollContainer/Label".text = Globals.answer
	$"../../../input".grab_focus()

func get_unit(name):
	return _unit_abbreviation(name)

func get_max_args(name):
	return _get_function_max_args(name)

func get_arg_type(name, index):
	return _get_function_arg_type(name, index)

func get_arg_name(name, index):
	return _get_function_arg_name(name, index)

func get_arg_def_val(name, index):
	return _get_function_arg_def_val(name, index)

func get_min_args(name):
	return _get_function_min_args(name)
