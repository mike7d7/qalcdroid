extends Tree

func _ready() -> void:
	get_functions_from_xml()

func get_functions_from_xml() -> void:
	var xml_doc: XMLDocument = XML.parse_file("res://functions.xml")
	var xml_root: XMLNode = xml_doc.root
	
	var root: TreeItem = self.create_item()
	root.set_text(0, "All")
	
	for i in xml_root.children:
		var current_item: TreeItem = self.create_item()
		current_item.set_text(0, i.children[0].content)
		
		for j in i.children:
			if j.name == "category":
				var current_sub_item: TreeItem = self.create_item(current_item)
				current_sub_item.set_text(0, j.children[0].content)
				for k in j.children:
					if k.name == "builtin_function" || k.name == "function":
						var current_sub_sub_item: TreeItem = self.create_item(current_sub_item)
						current_sub_sub_item.set_text(0, k.children[0].content)
						for l in k.children:
							if l.name == "names" && not l.attributes:
								current_sub_sub_item.set_metadata(0, l.content.get_slice(":", 1).get_slice(",", 0))
				
			if j.name == "builtin_function" || j.name == "function":
				if j.children[0].name != "hidden":
					var current_sub_item: TreeItem = self.create_item(current_item)
					current_sub_item.set_text(0, j.children[0].content)
					for k in j.children:
						if k.name == "names" && not k.attributes:
							current_sub_item.set_metadata(0, k.content.get_slice(":", 1).get_slice(",", 0))
		current_item.set_collapsed_recursive(true)

var previous_search_text: String = ""
@onready var tree: Node = $"../../../../VBoxContainer/TabContainer/Functions/Functions"
func _on_line_edit_text_changed(search_text: String) -> void:
	#Have to start from the end so children are hidden before parent
	
	#This code should work, but there's a bug in Godot (probably #85032), where get_prev_visible() doesnt work correctly with warp, so we use a workaround
	#Original code
	#var child = tree.get_root().get_prev_in_tree(true)
	#var child2
	
	#Workaround, simply goes to the end of the tree
	var child: Node = tree.get_root().get_next_in_tree()
	var child2: Node
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

func _on_item_activated() -> void:
	var item: TreeItem = self.get_selected()
	get_tree().current_scene.get_node("%input")._on_functions_item_activated(item.get_metadata(0), item.get_text(0), item)
