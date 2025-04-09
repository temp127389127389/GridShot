extends Node

var multiplayer_node

func init_host_node(lobby_name : String):
	multiplayer_node = WebRTCLobbyHost.new(
		Config.network.signaling_server_url,
		Config.network.lobby_size,
		true,  # accepting new players
		lobby_name,
		false, # password enabled
		"",    # password
		Config.debug.network_logs_verbose
	)
	
	return multiplayer_node

func init_player_node():
	multiplayer_node = WebRTCPlayerClient.new(
		Config.network.signaling_server_url,
		Config.debug.network_logs_verbose
	)
	
	return multiplayer_node
