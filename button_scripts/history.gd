extends Button

@onready var history_popup: Node = get_node("/root/Control/history_popup")

func _ready() -> void:
	fill_history_container()
	self.pressed.connect(self._button_pressed)
	
func _button_pressed() -> void:
	history_popup.show()
	
	# Workaround to make VBox resize buttons, without this the buttons use
	# more vertical space than what they should.
	history_popup.hide()
	history_popup.call_deferred("show")
	
	Globals.popup_number = 5

func fill_history_container() -> void:
	for i in Globals.user_prefs.history:
		create_new_entry(i)

func add_entry_to_history() -> void:
	create_new_entry(Globals.user_prefs.history[-1])

func create_new_entry(text: String) -> void:
	var entry: Button = Button.new()
	get_node("/root/Control/history_popup/VBoxContainer/ScrollContainer/VBoxContainer").add_child(entry)
	get_node("/root/Control/history_popup/VBoxContainer/ScrollContainer/VBoxContainer").move_child(entry, 0)
	entry.text = text
	entry.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	entry.set_script(preload("res://button_scripts/history_entry_button.gd"))
	entry.mouse_filter = Control.MOUSE_FILTER_PASS
	entry.focus_mode = Control.FOCUS_NONE
