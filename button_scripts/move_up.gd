extends Button

@onready var input_node: Node = get_tree().current_scene.get_node("%input")
var last_history: String

func _ready() -> void:
	self.pressed.connect(self._button_pressed)
	
func _button_pressed() -> void:
	if abs(Globals.entry_number - 1) <= Globals.history.size():
		Globals.entry_number -= 1
		input_node.text = Globals.history[Globals.entry_number]
		input_node.set_caret_column(input_node.text.length())
		input_node.scroll_vertical = input_node.get_line_wrap_count(0) - 1
		input_node.grab_focus()
