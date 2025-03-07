extends Button

@onready var input_node: Node = get_tree().current_scene.get_node("%input")
@onready var label: Node = get_tree().current_scene.get_node("%Label")

func _ready() -> void:
	self.pressed.connect(self._button_pressed)

func _button_pressed() -> void:
	input_node.text = ''
	label.text = '0'
	input_node.grab_focus()
	Globals.entry_number = 0
