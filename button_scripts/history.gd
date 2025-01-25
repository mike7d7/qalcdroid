extends Button

@onready var history_popup: Node = get_node("/root/Control/history_popup")

func _ready() -> void:
	self.pressed.connect(self._button_pressed)
	
func _button_pressed() -> void:
	history_popup.show()
	Globals.popup_number = 5
