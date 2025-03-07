extends Button

@onready var cpp_code: Node = get_node("/root/Control/VBoxContainer/TabContainer/numbers/GDExample")

func _ready() -> void:
	self.pressed.connect(self._button_pressed)

func _button_pressed() -> void:
	Globals.user_prefs.history = []
	for i in get_node("/root/Control/history_popup/VBoxContainer/ScrollContainer/VBoxContainer").get_children():
		i.queue_free()
	cpp_code.user_prefs.save()
