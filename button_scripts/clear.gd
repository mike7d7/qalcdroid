extends Button

@onready var input_node = get_tree().current_scene.get_node("%input")
@onready var label = get_tree().current_scene.get_node("%Label")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed)
	pass # Replace with function body.

func _button_pressed():
	input_node.text = ''
	label.text = '0'
	input_node.grab_focus()
