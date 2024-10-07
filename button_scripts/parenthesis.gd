extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed.bind(self.text))
	pass # Replace with function body.

func _button_pressed(_arg):
	$"../../../input".insert_text_at_caret("()", -1)
	$"../../../input".set_caret_column($"../../../input".get_caret_column() - 1)
	$"../../../input".scroll_vertical = $"../../../input".get_line_wrap_count(0) - 1
	$"../../../input".grab_focus()
