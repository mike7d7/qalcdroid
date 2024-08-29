extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed.bind(self.get_meta("node")))
	pass # Replace with function body.

func _button_pressed(node):
	get_node(node).hide();
