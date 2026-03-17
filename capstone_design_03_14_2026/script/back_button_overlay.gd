extends CanvasLayer

func _ready():
	$Button.pressed.connect(_on_back_pressed)

func _on_back_pressed():
	AudioManager.play_back_sound()
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_PORTRAIT)
	get_tree().root.content_scale_size = Vector2i(648, 1152)
	await get_tree().create_timer(0.3).timeout
	SceneManager.go_back()
