extends PlayerCameraEffect

# called on all peers
func game_over(winning_team):
	var peer_id = multiplayer.get_unique_id()
	var player : Player = Globals.game_node.get_player(peer_id)
	var is_on_winning_team = player.team == winning_team
	
	# update the label and buttons to match wether this this peer is the lobby host
	$Label.text = "Game %s" % ("won" if is_on_winning_team else "lost")
	$HBoxContainer/BackToLobbyButton.text = "Return to lobby" if peer_id == 1 else "Waiting on lobby host to return to lobby"
	$HBoxContainer/BackToLobbyButton.disabled = peer_id != 1
	
	# ensure this is the only shown screen
	var player_camera = Globals.game_node.player_camera
	player_camera.show_screen(player_camera.game_over_screen)
	
	$AnimationPlayer.play("fade")
	#000000a5

# only ever called on peer 1, aka the lobby host
func _on_back_to_lobby_button_pressed():
	Globals.return_to_lobby.rpc()

# called locally
func _on_exit_button_pressed():
	Globals.to_main_menu()
