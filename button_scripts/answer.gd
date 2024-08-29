extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed.bind())
	pass # Replace with function body.

func _button_pressed():
	$"../../../input".insert_text_at_caret(Globals.answer, -1)
	$"../../../input".scroll_vertical = $"../../../input".get_line_wrap_count(0) - 1
	$"../../../input".grab_focus()
	
