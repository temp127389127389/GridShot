extends TextureRect

const start_fade_delay = Config.flash_screen.start_fade_delay
const fade_duration = Config.flash_screen.fade_duration

func _ready():
	# if the player gets flashed multiple times within a short interval there will be
	#   multiple flash effects present on the player's camera
	# to prevent graphical issues all pre-existing flashes are deleted once
	#   a new flash is added
	var flashes = get_node("..").get_children()
	if 1 < len(flashes):
		flashes.map(func(flash): if flash != self: flash.queue_free())
	
	await RenderingServer.frame_post_draw
	
	# the texture gets all fucked up if its not converted to
	#   image and then back to a texture
	var img = get_viewport().get_texture().get_image()
	texture = ImageTexture.create_from_image(img)
	
	var anim_lib : AnimationLibrary = $AnimationPlayer.get_animation_library("")
	var anim : Animation = anim_lib.get_animation("fade")
	
	anim.length = start_fade_delay + fade_duration
	anim.track_set_key_time(0, 2, start_fade_delay + fade_duration)
	anim.track_set_key_time(0, 1, start_fade_delay)
	anim.track_set_key_time(1, 0, start_fade_delay + fade_duration)

func _process(_delta):
	# this node's rotation is relative to the player's rotation
	# the below code negates the player's rotation to ensure the flash screen stays upright
	pivot_offset = size/2
	rotation -= get_global_transform().get_rotation()
