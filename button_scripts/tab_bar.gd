extends TabBar

@onready var tab_container_node = get_tree().current_scene.get_node("%TabContainer")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tab_container_node.connect("tab_switched", Callable(self, "on_tab_change"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_tab_change(tab):
	self.current_tab = tab

func _on_tab_clicked(tab: int) -> void:
	tab_container_node.switch_tab_silent(tab)
