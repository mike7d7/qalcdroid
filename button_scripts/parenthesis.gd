extends Button

@onready var input_node: Node = get_tree().current_scene.get_node("%input")

func _ready() -> void:
	self.pressed.connect(self._button_pressed.bind(self.text))

func _button_pressed() -> void:
	input_node.insert_text_at_caret("()", -1)
	input_node.set_caret_column(input_node.get_caret_column() - 1)
	input_node.scroll_vertical = input_node.get_line_wrap_count(0) - 1
	input_node.grab_focus()
