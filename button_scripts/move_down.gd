extends Button

@onready var input_node: Node = get_tree().current_scene.get_node("%input")
var last_history: String

func _ready() -> void:
	self.pressed.connect(self._button_pressed)
	
func _button_pressed() -> void:
	if Globals.entry_number < -1:
		Globals.entry_number += 1
		input_node.text = Globals.history[Globals.entry_number]
	elif Globals.entry_number == -1:
		Globals.entry_number += 1
		input_node.text = ""
