extends PlayerCameraEffect

var weapon_types = {
	0: AssaultRifle,
	1: SubMachineGun,
	2: Shotgun,
	3: Molotov,
	4: FlashGrenade,
	5: SmokeGrenade,
	6: Tripwire
}

@onready var buttons = {
	0: $Gun/VBoxContainer/VBoxContainer/AssaultRifle,
	1: $Gun/VBoxContainer/VBoxContainer/SubMachineGun,
	2: $Gun/VBoxContainer/VBoxContainer/Shotgun,
	3: $Util/VBoxContainer/GridContainer/Molotov,
	4: $Util/VBoxContainer/GridContainer/FlashGrenade,
	5: $Util/VBoxContainer/GridContainer/SmokeGrenade,
	6: $Util/VBoxContainer/GridContainer/Tripwire
}

@onready var gun_count_label = $Gun/VBoxContainer/CountLabel
@onready var util_count_label = $Util/VBoxContainer/CountLabel
@onready var start_time_label = $StartTimeLabel
@onready var start_game_timer = $StartGameTimer

var current_gun : int
var current_util : Array[int]


func start_timer():
	start_game_timer.start()

func _process(delta):
	super._process(delta)
	
	start_time_label.text = "Starting in %ss" % int(round(start_game_timer.time_left))

# called locally on all peers
func _on_start_game_timer_timeout():
	# youre given an assaultrifle if you dont select your gun on time
	if current_gun == null:
		current_gun = 0
	
	var loadout = {
		"gun": weapon_types[current_gun].new(),
		"util": current_util.map(
			func(weapon_type : int): return weapon_types[weapon_type].new(source))
	}
	Globals.game_node.shopping_phase_completed(loadout)

func _on_gun_button_pressed(weapon_type):
	# lift the old button
	var old_button = buttons[current_gun]
	old_button.disabled = false
	
	# update current gun
	current_gun = weapon_type
	
	# sink the selected gun button
	var current_button = buttons[weapon_type]
	current_button.disabled = true
	
	# update the count label
	gun_count_label.text = "1/1"

func _on_util_button_pressed(weapon_type):
	# if the util count cap has been reached: unselect the oldest selected util
	if len(current_util) == 3:
		var oldest_util = current_util.pop_front()
		buttons[oldest_util].disabled = false
	
	# update current util
	current_util.append(weapon_type)
	
	# sink the selected util button
	var current_button = buttons[weapon_type]
	current_button.disabled = true
	
	# update the count label
	util_count_label.text = "%s/3" % len(current_util)
