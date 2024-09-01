extends TextEdit
@onready var cpp_code = $"../../VBoxContainer/TabContainer/numbers/GDExample"
@onready var popup = $"../../fn_popup/ScrollContainer/VBoxContainer/GridContainer"

func _ready():
	grab_focus()
	

#code for units
func _on_tree_item_activated():
	var item = $"../../VBoxContainer/TabContainer/Units/Tree".get_selected()
	if item.get_metadata(0):
		self.insert_text_at_caret(item.get_metadata(0), -1)
	else:
		item.set_collapsed_recursive(!item.collapsed)

#code for functions
func _on_functions_item_activated() -> void:
	while popup.get_child_count() > 1:
		popup.get_child(0).free()
	var item = $"../../VBoxContainer/TabContainer/Functions/Functions".get_selected()
	if item.get_metadata(0):
		var max_args = cpp_code.get_max_args(item.get_metadata(0))
		if max_args == -1:
			max_args = cpp_code.get_min_args(item.get_metadata(0))
		if max_args == 0:
			max_args = 1
		for i in range(max_args):
			var label = Label.new()
			popup.add_child(label)
			label.set_text(cpp_code.get_arg_name(item.get_metadata(0), i + 1))
			
			var default_value = cpp_code.get_arg_def_val(item.get_metadata(0), i + 1)
			
			var input_type = cpp_code.get_arg_type(item.get_metadata(0), i + 1)
			var input
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
			var separator = HSeparator.new()
			popup.add_child(separator)
			
		#popup.move_child(popup.get_child(1), popup.get_child_count() - 1)
		popup.move_child(popup.get_child(0), popup.get_child_count() - 1)
		$"../../fn_popup/ScrollContainer/VBoxContainer/Label".set_text(item.get_text(0))
		$"../../fn_popup".size = $"../../../Control".size
		$"../../fn_popup".show()
	else:
		item.set_collapsed_recursive(!item.collapsed)

#code for variables
func _on_variable_tree_item_activated() -> void:
	var item = $"../../VBoxContainer/TabContainer/Variables/VariableTree".get_selected()
	if item.get_metadata(0):
		self.insert_text_at_caret(item.get_metadata(0), -1)
	else:
		item.set_collapsed_recursive(!item.collapsed)
