extends Tree
	
@onready var cpp_code: Node = get_node("%TabContainer/numbers/GDExample")
@onready var tree: Node = get_node("%TabContainer/Units/Tree")

func _ready() -> void:
	get_units()
	get_currencies()

@onready var root: TreeItem = tree.create_item()
func get_units() -> void:
	var xml_doc: XMLDocument = XML.parse_file("res://units.xml")
	var xml_root: XMLNode = xml_doc.root
	var current_sub_sub_item: TreeItem
	
	root.set_text(0, "All")
	for i in xml_root.children:
		var current_item: TreeItem = tree.create_item()
		current_item.set_text(0, i.children[0].content.get_slice("!", 2))
		
		for j in i.children:
			if j.name == "category":
				var current_sub_item: TreeItem = tree.create_item(current_item)
				current_sub_item.set_text(0, j.children[0].content.get_slice("!", 2))

				for k in j.children:
					if k.name == "unit":
						for l in k.children:
							if l.name == "hidden":
								break

							if l.name == "title" && not l.attributes:
								current_sub_sub_item = tree.create_item(current_sub_item)
								current_sub_sub_item.set_text(0, l.content)
								
							if l.name == "names" && not l.attributes:
								current_sub_sub_item.set_metadata(0, cpp_code.get_unit(l.content.get_slice(":", 1).get_slice(",", 0)))
						
			if j.name == "unit":
				for k in j.children:
					if k.name == "hidden":
						break

					if k.name == "title" && not k.attributes:
						current_sub_sub_item = tree.create_item(current_item)
						current_sub_sub_item.set_text(0, k.content)
								
					if k.name == "names" && not k.attributes:
						current_sub_sub_item.set_metadata(0, cpp_code.get_unit(k.content.get_slice(":", 1).get_slice(",", 0)))
		current_item.set_collapsed_recursive(true)

func get_currencies() -> void:
	var xml_doc: XMLDocument = XML.parse_file("res://currencies.xml")
	var xml_root: XMLNode = xml_doc.root
	var current_sub_sub_item: TreeItem
	
	root.set_text(0, "All")
	for i in xml_root.children:
		var current_item: TreeItem = tree.create_item()
		current_item.set_text(0, i.children[0].content.get_slice("!", 2))
		
		for j in i.children:
			if j.name == "category":
				var current_sub_item: TreeItem = tree.create_item(current_item)
				current_sub_item.set_text(0, j.children[0].content.get_slice("!", 2))

				for k in j.children:
					if k.name == "unit" || k.name == "builtin_unit":
						for l in k.children:
							if l.name == "hidden":
								break

							if l.name == "title" && not l.attributes:
								current_sub_sub_item = tree.create_item(current_sub_item)
								current_sub_sub_item.set_text(0, l.content)
								
							if l.name == "names" && not l.attributes:
								current_sub_sub_item.set_metadata(0, cpp_code.get_unit(l.content.get_slice(":", 1).get_slice(",", 0)))
						
			if j.name == "unit" || j.name == "builtin_unit":
				for k in j.children:
					if k.name == "hidden":
						break

					if k.name == "title" && not k.attributes:
						current_sub_sub_item = tree.create_item(current_item)
						current_sub_sub_item.set_text(0, k.content)
								
					if k.name == "names" && not k.attributes:
						current_sub_sub_item.set_metadata(0, cpp_code.get_unit(k.content.get_slice(":", 1).get_slice(",", 0)))
		current_item.set_collapsed_recursive(true)

var previous_search_text: String = ""
func _on_line_edit_text_changed(search_text: String) -> void:
	#Have to start from the end so children are hidden before parent
	
	#This code should work, but there's a bug in Godot (probably #85032), where get_prev_visible() doesnt work correctly with warp, so we use a workaround
	#Original code
	#var child = tree.get_root().get_prev_in_tree(true)
	#var child2
	
	#Workaround, simply goes to the end of the tree
	var child: TreeItem = tree.get_root().get_next_in_tree()
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
