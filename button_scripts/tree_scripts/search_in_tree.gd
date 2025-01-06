extends Tree

func _ready() -> void:
	$"../LineEdit".text_changed.connect(_on_line_edit_text_changed.bind())
	pass

var previous_search_text: String = ""
#@onready var tree: Node = $"../../../../VBoxContainer/TabContainer/Variables/VariableTree"
func _on_line_edit_text_changed(search_text: String):
	#Have to start from the end so children are hidden before parent
	
	#This code should work, but there's a bug in Godot (probably #85032), where get_prev_visible() doesnt work correctly with warp, so we use a workaround
	#Original code
	#var child = tree.get_root().get_prev_in_tree(true)
	#var child2
	
	#Workaround, simply goes to the end of the tree
	var child: TreeItem = self.get_root().get_next_in_tree()
	var child2: TreeItem
	while child != null:
		if previous_search_text.length() > search_text.length():
			child.set_visible(true)
		child2 = child
		child = child.get_next_in_tree()
	child = child2
	#Workaround
	if search_text.is_empty():
		return
	while child != null:
		if child.get_metadata(0):
			if child.get_text(0).to_lower().find(search_text.to_lower()) == -1:
				child.set_visible(false)
		else:
			var children_array: Array = child.get_children()
			var can_delete: bool = false
			for i in children_array:
				can_delete = can_delete || i.is_visible()
			if !can_delete:
				child.set_visible(false)
		child = child.get_prev_in_tree()
	previous_search_text = search_text
