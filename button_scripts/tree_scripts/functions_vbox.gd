extends VBoxContainer

var thread: Thread = Thread.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thread.start(get_functions_from_xml)

@onready var input: Node = get_node("%input")
func get_functions_from_xml() -> void:
	var tree: Tree = Tree.new()
	var xml_doc: XMLDocument = XML.parse_file("res://functions.xml")
	var xml_root: XMLNode = xml_doc.root
	
	var root: TreeItem = tree.create_item()
	root.set_text(0, "All")
	
	for i in xml_root.children:
		var current_item: TreeItem = tree.create_item()
		current_item.set_text(0, i.children[0].content)
		
		for j in i.children:
			if j.name == "category":
				var current_sub_item: TreeItem = tree.create_item(current_item)
				current_sub_item.set_text(0, j.children[0].content)
				for k in j.children:
					if k.name == "builtin_function" || k.name == "function":
						var current_sub_sub_item: TreeItem = tree.create_item(current_sub_item)
						current_sub_sub_item.set_text(0, k.children[0].content)
						for l in k.children:
							if l.name == "names" && not l.attributes:
								current_sub_sub_item.set_metadata(0, l.content.get_slice(":", 1).get_slice(",", 0))
				
			if j.name == "builtin_function" || j.name == "function":
				if j.children[0].name != "hidden":
					var current_sub_item: TreeItem = tree.create_item(current_item)
					current_sub_item.set_text(0, j.children[0].content)
					for k in j.children:
						if k.name == "names" && not k.attributes:
							current_sub_item.set_metadata(0, k.content.get_slice(":", 1).get_slice(",", 0))
		current_item.set_collapsed_recursive(true)
		tree.set_script(load("res://button_scripts/tree_scripts/search_in_tree.gd"))
	tree.allow_search = false
	tree.hide_root = true
	tree.scroll_horizontal_enabled = false
	tree.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tree.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tree.focus_mode = Control.FOCUS_NONE
	tree.mouse_filter = Control.MOUSE_FILTER_PASS
	tree.add_theme_font_size_override("font_size", 70)
	tree.theme = load("res://fontsize40.tres")
	tree.item_activated.connect(input._on_functions_item_activated)
	call_deferred("add_child", tree)
	
func _exit_tree():
	if thread.is_alive() == false:
		thread.wait_to_finish()
