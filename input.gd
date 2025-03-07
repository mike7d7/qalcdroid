extends CodeEdit
@onready var cpp_code: Node = $"../../VBoxContainer/TabContainer/numbers/GDExample"
@onready var popup: Node = $"../../fn_popup/ScrollContainer/VBoxContainer/GridContainer"

func _ready() -> void:
	grab_focus()
	

#code for units
@onready var units_tree_node: Node = $"../../VBoxContainer/TabContainer/Units"
func _on_tree_item_activated() -> void:
	var tree: = units_tree_node.get_child(-1)
	var item: TreeItem = tree.get_selected()
	if item.get_metadata(0):
		self.insert_text_at_caret(item.get_metadata(0), -1)
	else:
		item.set_collapsed_recursive(!item.collapsed)

#code for functions
@onready var functions_tree_node: Node = $"../../VBoxContainer/TabContainer/Functions"
func _on_functions_item_activated() -> void:
	var treeitem: TreeItem = functions_tree_node.get_child(-1).get_selected()
	var item_string = treeitem.get_metadata(0) # 'item' can be null or string
	var title: String = treeitem.get_text(0)
	while popup.get_child_count() > 1:
		popup.get_child(0).free()
	if item_string:
		var max_args: int = cpp_code.get_max_args(item_string)
		if max_args == -1:
			max_args = cpp_code.get_min_args(item_string)
		if max_args == 0:
			max_args = 1
		for i in range(max_args):
			var label: Node = Label.new()
			popup.add_child(label)
			label.set_text(cpp_code.get_arg_name(item_string, i + 1))
			
			var default_value: String = cpp_code.get_arg_def_val(item_string, i + 1)
			
			var input_type: int = cpp_code.get_arg_type(item_string, i + 1)
			var input: Node
			match input_type:
				0:
					input = LineEdit.new()
					if default_value == "undefined":
						input.set_placeholder("optional")
					elif default_value:
						input.set_text(default_value)
				1:
					input = CheckButton.new()
				2:
					input = SpinBox.new()
					input.set_allow_lesser(true)
					input.set_allow_greater(true)
					if default_value:
						input.set_value_no_signal(default_value.to_float())
				3:
					input = OptionButton.new()
					#TODO add working combobox
			popup.add_child(input)
			var separator: Node = HSeparator.new()
			popup.add_child(separator)
			
		#popup.move_child(popup.get_child(1), popup.get_child_count() - 1)
		popup.move_child(popup.get_child(0), popup.get_child_count() - 1)
		$"../../fn_popup/ScrollContainer/VBoxContainer/Label".set_text(title)
		$"../../fn_popup/ScrollContainer/VBoxContainer/Label".set_meta("metadata", item_string)
		$"../../fn_popup".size = $"../../../Control".size
		$"../../fn_popup".show()
		Globals.popup_number = 1
	else:
		treeitem.set_collapsed_recursive(!treeitem.collapsed)

#code for functions when calling from buttons in numbers2
func _on_functions_item_activated_grid(item, title: String, treeitem: TreeItem) -> void: # 'item' can be null or string
	while popup.get_child_count() > 1:
		popup.get_child(0).free()
	if item:
		var max_args: int = cpp_code.get_max_args(item)
		if max_args == -1:
			max_args = cpp_code.get_min_args(item)
		if max_args == 0:
			max_args = 1
		for i in range(max_args):
			var label: Node = Label.new()
			popup.add_child(label)
			label.set_text(cpp_code.get_arg_name(item, i + 1))
			
			var default_value: String = cpp_code.get_arg_def_val(item, i + 1)
			
			var input_type: int = cpp_code.get_arg_type(item, i + 1)
			var input: Node
			match input_type:
				0:
					input = LineEdit.new()
					if default_value == "undefined":
						input.set_placeholder("optional")
					elif default_value:
						input.set_text(default_value)
				1:
					input = CheckButton.new()
				2:
					input = SpinBox.new()
					input.set_allow_lesser(true)
					input.set_allow_greater(true)
					if default_value:
						input.set_value_no_signal(default_value.to_float())
				3:
					input = OptionButton.new()
					#TODO add working combobox
			popup.add_child(input)
			var separator: Node = HSeparator.new()
			popup.add_child(separator)
			
		#popup.move_child(popup.get_child(1), popup.get_child_count() - 1)
		popup.move_child(popup.get_child(0), popup.get_child_count() - 1)
		$"../../fn_popup/ScrollContainer/VBoxContainer/Label".set_text(title)
		$"../../fn_popup/ScrollContainer/VBoxContainer/Label".set_meta("metadata", item)
		$"../../fn_popup".size = $"../../../Control".size
		$"../../fn_popup".show()
		Globals.popup_number = 1
	else:
		treeitem.set_collapsed_recursive(!treeitem.collapsed)

#code for variables
@onready var variable_tree_node: Node = $"../../VBoxContainer/TabContainer/Variables"
func _on_variable_tree_item_activated() -> void:
	var tree: = variable_tree_node.get_child(-1)
	var item: TreeItem = tree.get_selected()
	if item.get_metadata(0):
		self.insert_text_at_caret(item.get_metadata(0), -1)
	else:
		item.set_collapsed_recursive(!item.collapsed)
		

func _on_gui_input(_event: InputEvent) -> void:
	self.set_virtual_keyboard_enabled(true)

# Need to disable virtual keyboard property because multible buttons set focus to
# input and that would make the keyboard show in unwanted situations.
func _on_focus_exited() -> void:
	self.set_virtual_keyboard_enabled(false)
