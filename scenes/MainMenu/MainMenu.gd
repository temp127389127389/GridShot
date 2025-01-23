extends Control



class Projectile:
	func _init():
		pass

func _on_start_button_pressed():
	Globals.start_game()

func _on_quit_button_pressed():
	Globals.quit_game()
