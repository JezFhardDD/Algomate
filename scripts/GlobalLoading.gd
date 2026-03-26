extends Node

var loading_screen: Control = null
var is_loading: bool = false

const MUSIC_PATH = "res://assets/MUSIC/8bit bg music.mp3"

# Scene paths that are simulations (landscape, no music)
const SIM_SCENES = [
	"res://scene/Array.tscn",
	"res://scene/ArrayA.tscn",
	"res://scene/Linked.tscn",
	"res://scene/LLA.tscn",
	"res://scene/Stack.tscn",
	"res://scene/StackA.tscn",
	"res://scene/Queue.tscn",
	"res://scene/QueueA.tscn",
	"res://scene/Bubble.tscn",
	"res://scene/BBSA.tscn",
	"res://scene/Insertion.tscn",
	"res://scene/ISA.tscn",
	"res://scene/Selection.tscn",
	"res://scene/SLA.tscn",
	"res://scene/Merge.tscn",
	"res://scene/MSA.tscn",
	"res://scene/QuickSort.tscn",
	"res://scene/QSA.tscn",
	"res://scene/ShellSort.tscn",
	"res://scene/SSA.tscn",
	"res://scene/Linear.tscn",
	"res://scene/LSA.tscn",
	"res://scene/Binary.tscn",
	"res://scene/BNYSA.tscn",
	"res://scene/Interpolation.tscn",
	"res://scene/IPSA.tscn",
	"res://scene/Dfs.tscn",
	"res://scene/TreeDFSA.tscn",
	"res://scene/Bfs.tscn",
	"res://scene/TreeBFSa.tscn",
]

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

	# Stop music when entering a simulation, resume when leaving
	if scene_path in SIM_SCENES:
		AudioManager.stop_music()
	else:
		AudioManager.play_music(MUSIC_PATH)

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
