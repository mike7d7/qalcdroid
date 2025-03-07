extends TextureProgressBar

func _ready() -> void:
	var tween: Tween = get_tree().create_tween().set_loops()
	tween.tween_property(self, "radial_initial_angle", 360.0, 1.5).as_relative()

func set_popup_number_on_hide() -> void:
	Globals.popup_number = 0
