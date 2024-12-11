extends RichTextLabel

func _on_meta_clicked(meta: String) -> void:
	DisplayServer.clipboard_set(meta)
