extends Node

var loading_screen: Control = null
var is_loading: bool = false

func _ready():
	print("GlobalLoading ready")
	loading_screen = preload("res://scenes/loading_screen.tscn").instantiate()
	add_child(loading_screen)
	loading_screen.z_index = 1000
	loading_screen.visible = false

func load_scene(scene_path: String, stay_portrait: bool = false):
	print("GlobalLoading.load_scene called with: ", scene_path)

	if not ResourceLoader.exists(scene_path):
		print("❌ ERROR: File does not exist: ", scene_path)
		return

	if is_loading:
		print("Already loading, please wait...")
		return

	is_loading = true

	if is_instance_valid(loading_screen):
		loading_screen.queue_free()

	loading_screen = preload("res://scenes/loading_screen.tscn").instantiate()
	add_child(loading_screen)
	loading_screen.z_index = 1000
	loading_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	loading_screen.stay_portrait = stay_portrait

	loading_screen.anchor_left = 0
	loading_screen.anchor_top = 0
	loading_screen.anchor_right = 1
	loading_screen.anchor_bottom = 1

	if not loading_screen.loading_complete.is_connected(_on_loading_complete):
		loading_screen.loading_complete.connect(_on_loading_complete)

	loading_screen.start_loading(scene_path)

func _on_loading_complete():
	print("Loading complete, resetting flag")
	is_loading = false

	if is_instance_valid(loading_screen):
		loading_screen.visible = false
