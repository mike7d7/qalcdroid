extends Button

@onready var input_node: Node = get_tree().current_scene.get_node("%input")

func _ready() -> void:
	self.pressed.connect(self._button_pressed.bind("^"))

func _button_pressed(arg: String) -> void:
	input_node.insert_text_at_caret(arg, -1)
	input_node.scroll_vertical = input_node.get_line_wrap_count(0) - 1
	input_node.grab_focus()
