extends Control


func _on_host_button_pressed():
	Globals.start_as_lobby_host($LobbyNameLineEdit.text)

func _on_player_button_pressed():
	Globals.start_as_player_client()

func _on_player_join_button_pressed():
	Globals.player_client_join_lobby($LobbyIdLineEdit.text)

func _on_quit_button_pressed():
	Globals.quit_program()
