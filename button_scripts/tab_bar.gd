extends TabBar

@onready var tab_container_node: Node = get_tree().current_scene.get_node("%TabContainer")

func _ready() -> void:
	tab_container_node.connect("tab_switched", Callable(self, "on_tab_change"))

func on_tab_change(tab: int):
	self.current_tab = tab

func _on_tab_clicked(tab: int) -> void:
	tab_container_node.switch_tab_silent(tab)
