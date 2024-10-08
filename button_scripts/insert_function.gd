extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed.bind())
	pass # Replace with function body.

func _button_pressed():
	#var item = $"../../../../../../VBoxContainer/TabContainer/Functions/Functions".get_selected()
	var item = $"../../../Label".get_meta("metadata")
	var expression = item + "("
	for i in $"../../../../../../fn_popup/ScrollContainer/VBoxContainer/GridContainer".get_children():
		match i.get_class():
			"LineEdit":
				expression += i.text + ","
			"SpinBox":
				expression += "%d" + ","
				expression = expression % [i.value]
			"OptionButton":
				expression += i.get_selected() + ","
			"CheckButton":
				if i.is_pressed():
					expression += "true" + ","
				else:
					expression += "false" + ","
	expression = expression.left(-1)
	expression += ")"
	$"../../../../../../VBoxContainer/input".insert_text_at_caret(expression, -1)
	$"../../../../../../fn_popup".hide();
