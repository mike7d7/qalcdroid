extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed)
	pass # Replace with function body.

func _button_pressed():
	$"../../../input".text = ''
	$"../../../input".grab_focus()
