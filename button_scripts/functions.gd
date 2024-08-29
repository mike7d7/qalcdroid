extends Tree


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_functions_from_xml()
	pass # Replace with function body.


func get_functions_from_xml():
	var xml_doc = XML.parse_file("/usr/share/qalculate/functions.xml")
	xml_doc = xml_doc.root
	
	var root: TreeItem = self.create_item()
	root.set_text(0, "All")
	
	for i in xml_doc.children:
		var current_item: TreeItem = self.create_item()
		current_item.set_text(0, i.children[0].content)
		
		for j in i.children:
			if j.name == "builtin_function":
				var current_sub_item: TreeItem = self.create_item(current_item)
				current_sub_item.set_text(0, j.children[0].content)
				var arguments = 0
				for k in j.children:
					if k.name == "names" && not k.attributes:
						current_sub_item.set_metadata(0, k.content.get_slice(":", 1).get_slice(",", 0))
