extends Node

func to_player_name(id : int) -> String: return "player_" + str(id)
func from_player_name(name_ : String) -> int: return name_.split("_")[-1].to_int()
