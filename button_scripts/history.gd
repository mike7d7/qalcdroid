extends Button

@onready var history_popup: Node = get_node("/root/Control/history_popup")

func _ready() -> void:
	fill_history_container()
	self.pressed.connect(self._button_pressed)
	
func _button_pressed() -> void:
	history_popup.show()
	Globals.popup_number = 5

func fill_history_container() -> void:
	for i in Globals.user_prefs.history:
		var entry: Button = Button.new()
		entry.text = i
		entry.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		entry.set_script(preload("res://button_scripts/history_entry_button.gd"))
		get_node("/root/Control/history_popup/VBoxContainer/ScrollContainer/VBoxContainer").add_child(entry)
		
func add_entry_to_history() -> void:
	var entry: Button = Button.new()
	entry.text = Globals.user_prefs.history[-1]
	entry.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	entry.set_script(preload("res://button_scripts/history_entry_button.gd"))
	get_node("/root/Control/history_popup/VBoxContainer/ScrollContainer/VBoxContainer").add_child(entry)
