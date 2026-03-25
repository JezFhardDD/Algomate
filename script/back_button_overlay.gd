extends CanvasLayer

func _ready():
	$Button.pressed.connect(_on_back_pressed)

func _on_back_pressed():
	AudioManager.play_back_sound()
	# Hide the entire CanvasLayer immediately so it doesn't bleed through
	# the loading screen animation (CanvasLayer renders above all z_index layers)
	visible = false
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_PORTRAIT)
	get_tree().root.content_scale_size = Vector2i(648, 1152)
	await get_tree().create_timer(0.3).timeout

	# Find the correct return scene by scanning the stack for known portrait scenes
	var portrait_scenes = [
		"res://scenes/lesson_view.tscn",
		"res://scenes/assessment_map.tscn",
		"res://scenes/lectures.tscn",
		"res://scenes/homepage.tscn",
	]

	var target = ""
	for i in range(SceneManager.scene_stack.size() - 1, -1, -1):
		if SceneManager.scene_stack[i] in portrait_scenes:
			target = SceneManager.scene_stack[i]
			SceneManager.scene_stack.resize(i)  # clear everything above it too
			break

	if target != "":
		GlobalLoading.load_scene(target, true)  # true = stay portrait
	else:
		SceneManager.go_back()
