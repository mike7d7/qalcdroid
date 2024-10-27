extends Button

@onready var input_node = get_tree().current_scene.get_node("%input")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed)
	pass # Replace with function body.
	
func _button_pressed():
	input_node.set_caret_column(input_node.get_caret_column() + 1)
	input_node.scroll_vertical = input_node.get_line_wrap_count(0) - 1
	input_node.grab_focus()
