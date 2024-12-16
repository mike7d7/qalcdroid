extends Button

@onready var cpp_code: Node = get_node("%TabContainer/numbers/GDExample")
@onready var rates_popup: Node = get_node("%rates_popup")
@onready var success_popup: Node = get_node("/root/Control/success_exchange_rate")
@onready var error_popup: Node = get_node("/root/Control/error_exchange_rate")

var thread: Thread = Thread.new()
signal fetch_complete(result: bool)

func _ready() -> void:
	self.pressed.connect(self._button_pressed)

func _button_pressed() -> void:
	rates_popup.show()
	thread.start(fetch_exchange_rates_in_background)
	
	var result: bool = await Signal(fetch_complete)
	
	rates_popup.hide()
	if result:
		success_popup.show()
	else:
		error_popup.show()

func fetch_exchange_rates_in_background() -> void:
	var result: bool = cpp_code.fetch_exchange_rates()
	call_deferred("emit_signal", "fetch_complete", result)

func _exit_tree():
	if thread.is_started():
		thread.wait_to_finish()
