extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed.bind(self.text))
	pass # Replace with function body.

func _button_pressed(_arg):
	$"../../../../sum_popup".size = $"../../../../../Control/".size;
	$"../../../../sum_popup".show();
