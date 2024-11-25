extends Button

func _ready() -> void:
	self.pressed.connect(self._button_pressed.bind())

func _button_pressed() -> void:
	var item: String = $"../../../Label".get_meta("metadata")
	var expression: String = item + "("
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
