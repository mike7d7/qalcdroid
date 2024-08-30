extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed.bind())
	pass # Replace with function body.

func _button_pressed():
	var item = $"../../../../../../VBoxContainer/TabContainer/Functions/Functions".get_selected()
	var text = item.get_metadata(0) + "("
	for i in $"../../../../../../fn_popup/ScrollContainer/VBoxContainer/GridContainer".get_children():
		match i.get_class():
			"LineEdit":
				text += i.text + ","
			"SpinBox":
				text += "%d" + ","
				text = text % [i.value]
			"OptionButton":
				text += i.get_selected() + ","
			"CheckButton":
				if i.is_pressed():
					text += "true" + ","
				else:
					text += "false" + ","
	text = text.left(-1)
	text += ")"
	$"../../../../../../VBoxContainer/input".insert_text_at_caret(text, -1)
	$"../../../../../../fn_popup".hide();
