extends Button
@onready var cpp_code = $"../../../../VBoxContainer/TabContainer/numbers/GDExample"
@onready var popup = $"../../../../fn_popup/ScrollContainer/VBoxContainer/GridContainer"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed.bind())
	pass # Replace with function body.

func _button_pressed():
	get_tree().current_scene.get_node("%input")._on_functions_item_activated(self.get_meta("item"), self.get_meta("title"), null)
