extends Button

@onready var input_node: Node = get_tree().current_scene.get_node("%input")

func _ready() -> void:
	self.pressed.connect(self._button_pressed)

func _button_pressed() -> void:
	input_node.backspace();
	input_node.scroll_vertical = input_node.get_line_wrap_count(0) - 1
	input_node.grab_focus()
