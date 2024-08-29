extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed.bind())
	pass # Replace with function body.

func _button_pressed():
	var text = "Σ(" + $"../expression".text + "," + "%d" + "," + "%d"
	text = text % [$"../low_limit".value, $"../up_limit".value]
	if ($"../variable".text != ""):
		text += "," + $"../variable".text
	text += ")"
	$"../../../../sum_popup".hide();
	$"../../../../VBoxContainer/input".insert_text_at_caret(text, -1)
	$"../../../../VBoxContainer/input".scroll_vertical = $"../../../../VBoxContainer/input".get_line_wrap_count(0) - 1
	$"../../../../VBoxContainer/input".grab_focus()
