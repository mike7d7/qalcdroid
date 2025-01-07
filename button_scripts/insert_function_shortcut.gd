extends Button
@onready var cpp_code: Node = $"../../../../VBoxContainer/TabContainer/numbers/GDExample"
@onready var popup: Node = $"../../../../fn_popup/ScrollContainer/VBoxContainer/GridContainer"

func _ready() -> void:
	self.pressed.connect(self._button_pressed.bind())

func _button_pressed() -> void:
	get_tree().current_scene.get_node("%input")._on_functions_item_activated_grid(self.get_meta("item"), self.get_meta("title"), null)
