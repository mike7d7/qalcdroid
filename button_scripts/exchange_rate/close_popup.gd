extends Button

func _ready() -> void:
	self.pressed.connect(self._button_pressed)

func _button_pressed() -> void:
	self.get_owner().hide()

func set_popup_number_on_hide() -> void:
	Globals.popup_number = 0
