extends Button

@onready var cpp_code: Node = get_node("%TabContainer/numbers/GDExample")
@onready var rates_popup: Node = get_node("%rates_popup")
@onready var success_popup: Node = get_node("/root/Control/success_exchange_rate")
@onready var error_popup: Node = get_node("/root/Control/error_exchange_rate")

var thread: Thread = Thread.new()
signal fetch_complete(result: bool)
var http_request = HTTPRequest.new()

func _ready() -> void:
	http_request.request_completed.connect(self._http_request_completed)
	add_child(http_request)
	self.pressed.connect(self._button_pressed)
	http_request.set_download_file("user://eurofxref-daily.xml")

func _button_pressed() -> void:
	rates_popup.show()
	fetch_exchange_rates_in_background()
	
	var result: bool = await Signal(fetch_complete)
	var reload: bool = cpp_code.reload_exchange_rates()
	rates_popup.hide()
	if result && reload:
		success_popup.show()
	else:
		error_popup.show()

func fetch_exchange_rates_in_background() -> void:
	var error = http_request.request("https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		call_deferred("emit_signal", "fetch_complete", false)
	
	
func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")
		call_deferred("emit_signal", "fetch_complete", false)
	
	call_deferred("emit_signal", "fetch_complete", true)
	print(headers)
	print(body)

func _exit_tree():
	if thread.is_started():
		thread.wait_to_finish()
