extends Control

func _ready():
	Network.connection_failed.connect(_connection_failed)
	Network.connected_to_server.connect(_connection_successful)

func _on_host_button_pressed():
	Network.host_session()
	Globals.start_game()

func _on_join_button_pressed():
	$ConnectionStatusColorRect.color = Color.YELLOW
	Network.join_session($IPLineEdit.text)

func _on_ip_line_edit_text_submitted(_new_text):
	_on_join_button_pressed()

func _connection_failed():
	$ConnectionStatusColorRect.color = Color.RED

func _connection_successful():
	$ConnectionStatusColorRect.color = Color.GREEN
	Globals.start_game()

func _on_quit_button_pressed():
	Globals.quit_program()
