extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed.bind())
	pass # Replace with function body.

func _button_pressed():
	var expression = "Σ(" + $"../../expression".text + "," + "%d" + "," + "%d"
	expression = expression % [$"../../low_limit".value, $"../../up_limit".value]
	if ($"../../variable".text != ""):
		expression += "," + $"../../variable".text
	expression += ")"
	$"../../../../../sum_popup".hide();
	$"../../../../../VBoxContainer/input".insert_text_at_caret(expression, -1)
	$"../../../../../VBoxContainer/input".scroll_vertical = $"../../../../../VBoxContainer/input".get_line_wrap_count(0) - 1
	$"../../../../../VBoxContainer/input".grab_focus()
