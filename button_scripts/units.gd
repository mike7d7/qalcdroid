extends Tree
	
@onready var cpp_code = get_node("%TabContainer/numbers/GDExample")
@onready var tree = get_node("%TabContainer/Units/Tree")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_units()

func get_units():
	var xml_doc = XML.parse_file("res://units.xml")
	xml_doc = xml_doc.root
	var current_sub_sub_item: TreeItem
	
	var root: TreeItem = tree.create_item()
	root.set_text(0, "All")
	for i in xml_doc.children:
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


var previous_search_text = ""
func _on_line_edit_text_changed(search_text):
	#Have to start from the end so children are hidden before parent
	
	#This code should work, but there's a bug in Godot (probably #85032), where get_prev_visible() doesnt work correctly with warp, so we use a workaround
	#Original code
	#var child = tree.get_root().get_prev_in_tree(true)
	#var child2
	
	#Workaround, simply goes to the end of the tree
	var child = tree.get_root().get_next_in_tree()
	var child2
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
			var children_array = child.get_children()
			var can_delete = false
			for i in children_array:
				can_delete = can_delete || i.is_visible()
			if !can_delete:
				child.set_visible(false)
		child = child.get_prev_in_tree()
	previous_search_text = search_text
