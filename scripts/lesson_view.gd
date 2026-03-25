extends Control

@onready var lesson_text: RichTextLabel = $MarginContainer/MainVBox/ScrollContainer/ContentBox/LessonText
@onready var tts_button: Button = $MarginContainer/MainVBox/TopBar/TTSButton
@onready var simulate_button: TextureButton = $MarginContainer/MainVBox/ScrollContainer/ContentBox/SimulateButton
@onready var title_label: Label = $MarginContainer/MainVBox/TopBar/TitleLabel

@onready var student_speaker: Node2D = $StudentSpeaker
@onready var profile_pic: AnimatedSprite2D = $StudentSpeaker/ProfilePic

var voices: Array[Dictionary] = []
var selected_voice_id: String = ""
var is_speaking := false

var lesson_id: String = ""
var lesson_data: Dictionary = {}

var float_tween: Tween = null
var original_sprite_position: Vector2

# =============================================
# PFP CONFIG — frame size and voice per pfp
# =============================================
const PFP_CONFIG = {
	"boyCCT2.jpg":   {"sheet": "boyCCT-Sheet.png",   "frames": 6,  "size": 32, "voice_hint": "en-gb-x-gbb-network"},
	"girlCCT2.jpeg": {"sheet": "girlCCT-Sheet.png",  "frames": 6,  "size": 32, "voice_hint": "en-gb-x-gba-local"},
	"bread1.png":    {"sheet": "bread-Sheet.png",     "frames": 6,  "size": 32, "voice_hint": "da-dk"},
	"cat1.jpg":      {"sheet": "cat-sheet.png",       "frames": 12, "size": 60, "voice_hint": "hr-HR"},
	"fishpfp1.png":  {"sheet": "fish-sheet.png",      "frames": 8,  "size": 32, "voice_hint": "id-id"},
	"robot1.png":    {"sheet": "robot-Sheet.png",     "frames": 8,  "size": 32, "voice_hint": "uk-UA-language"},
	"wildboar1.png": {"sheet": "wildboard-Sheet.png", "frames": 8,  "size": 50, "voice_hint": "fr-ca"},
}

func set_lesson(id: String) -> void:
	lesson_id = id

func _ready() -> void:
	var margin = $MarginContainer
	margin.offset_left = 0
	margin.offset_right = 0
	if lesson_id.is_empty() and not Global.last_lesson_id.is_empty():
		lesson_id = Global.last_lesson_id
	student_speaker.visible = false
	print("LessonView loaded with ID:", lesson_id)
	if lesson_id.is_empty():
		push_error("Lesson ID was not set before scene loaded.")
		return
	if simulate_button:
		if not simulate_button.is_connected("pressed", _on_simulate_button_pressed):
			simulate_button.pressed.connect(_on_simulate_button_pressed)

	_load_lesson_data()
	_apply_lesson()

	# 🔥 DEBUG: Get voices and print them
	voices = DisplayServer.tts_get_voices()
	_debug_print_all_voices()

	if profile_pic:
		original_sprite_position = profile_pic.position

	load_profile_picture()
	
	# Connect to Global signals to detect profile changes
# Disconnect first to prevent duplicate connections on reload
	if Global.profile_updated.is_connected(_on_profile_updated):
		Global.profile_updated.disconnect(_on_profile_updated)
	if Global.purchases_updated.is_connected(_on_profile_updated):
		Global.purchases_updated.disconnect(_on_profile_updated)

	# Now connect safely
	Global.profile_updated.connect(_on_profile_updated, CONNECT_DEFERRED)
	Global.purchases_updated.connect(_on_profile_updated, CONNECT_DEFERRED)
	print("Connected to profile_updated signal")
	print("Connected to purchases_updated signal")
# 🔥 NEW: Debug function to print all available voices
func _debug_print_all_voices():
	print("\n=== AVAILABLE VOICES ===")
	print("Total voices found: ", voices.size())

# 🔥 NEW: Called when profile changes
func _on_profile_updated():
	print("\n=== PROFILE UPDATED - Reloading PFP and Voice ===")
	# Refresh voices list to ensure we have latest
	voices = DisplayServer.tts_get_voices()
	_debug_print_all_voices()
	load_profile_picture()

# =============================================
# PROFILE PICTURE LOADING
# =============================================
func load_profile_picture():
	print("\n=== LOADING PROFILE PICTURE ===")

	if not profile_pic:
		print("ERROR: profile_pic is null")
		return

	if not Global.has_profile():
		profile_pic.visible = false
		return

	var picture_path = Global.profile_data.get("profile_picture", "")
	print("Picture path: ", picture_path)

	if picture_path.is_empty():
		profile_pic.visible = false
		return

	var file_name = picture_path.get_file()

	if not PFP_CONFIG.has(file_name):
		print("Unknown pfp: ", file_name, " — using static fallback")
		use_static_image(picture_path)
		# Set default voice
		selected_voice_id = _pick_voice_by_hint("en-us")
		return

	var config = PFP_CONFIG[file_name]
	var sheet_path = "res://assets/profile_pics/" + config["sheet"]
	var frame_count = config["frames"]
	var frame_size = config["size"]
	var voice_hint = config["voice_hint"]

	print("Sheet: ", sheet_path, " | Frames: ", frame_count, " | Size: ", frame_size)
	print("Looking for voice with hint: '", voice_hint, "'")

	# Pick voice based on pfp
	selected_voice_id = _pick_voice_by_hint(voice_hint)
	print("Voice selected: ", selected_voice_id)

	load_animation_sheet(sheet_path, frame_count, frame_size)

func load_animation_sheet(sheet_path: String, frame_count: int, frame_size: int):
	print("Loading sheet: ", sheet_path)

	var sheet_texture = load(sheet_path)
	if not sheet_texture:
		print("Failed to load sheet: ", sheet_path)
		return

	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_animation("talk")

	for i in range(frame_count):
		var frame_texture = AtlasTexture.new()
		frame_texture.atlas = sheet_texture
		frame_texture.region = Rect2(i * frame_size, 0, frame_size, frame_size)
		sprite_frames.add_frame("talk", frame_texture)

	sprite_frames.set_animation_loop("talk", true)
	sprite_frames.set_animation_speed("talk", 8.0)

	profile_pic.sprite_frames = sprite_frames
	const TARGET_DISPLAY_SIZE = 128.0
	var scale_factor = TARGET_DISPLAY_SIZE / frame_size
	profile_pic.scale = Vector2(scale_factor, scale_factor)
	profile_pic.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	profile_pic.centered = true
	profile_pic.visible = true

	print("✓ Loaded ", frame_count, " frames from sheet")

func use_static_image(image_path: String):
	var texture = load(image_path)
	if not texture:
		return
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_animation("talk")
	sprite_frames.add_frame("talk", texture)
	sprite_frames.set_animation_loop("talk", false)
	sprite_frames.set_animation_speed("talk", 1.0)
	profile_pic.sprite_frames = sprite_frames
	profile_pic.scale = Vector2(4.0, 4.0)
	profile_pic.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	profile_pic.centered = true
	profile_pic.visible = true

# =============================================
# VOICE SELECTION
# =============================================
func _pick_voice_by_hint(hint: String) -> String:
	print("Searching for voice with hint: '", hint, "'")
	
	# First pass: exact language match
	for v in voices:
		var lang: String = str(v.get("language", "")).to_lower()
		var vid: String = str(v.get("id", "")).to_lower()
		if lang.begins_with(hint.to_lower()) or vid.contains(hint.to_lower()):
			print("  ✓ Found exact match: ", v.get("id", ""), " (lang: ", lang, ")")
			return v["id"]
	
	# Second pass: partial match
	for v in voices:
		var lang: String = str(v.get("language", "")).to_lower()
		if lang.contains(hint.to_lower()):
			print("  ✓ Found partial match: ", v.get("id", ""), " (lang: ", lang, ")")
			return v["id"]
	
	# Fallback: first available
	if not voices.is_empty():
		print("  ⚠ No match found, using first available: ", voices[0]["id"])
		return voices[0]["id"]
	
	print("  ❌ No voices available at all!")
	return ""

# =============================================
# LESSON LOADING
# =============================================
func _load_lesson_data() -> void:
	var file: FileAccess = FileAccess.open("res://data/lessons.json", FileAccess.READ)
	if file == null:
		push_error("Lessons file not found.")
		return
	var text: String = file.get_as_text()
	file.close()
	var parsed: Variant = JSON.parse_string(text)
	if parsed == null or typeof(parsed) != TYPE_DICTIONARY:
		push_error("Invalid lessons.json format.")
		return
	var all_lessons: Dictionary = parsed as Dictionary
	if not all_lessons.has(lesson_id):
		push_error("Lesson ID not found: " + lesson_id)
		return
	lesson_data = all_lessons[lesson_id] as Dictionary

func _apply_lesson() -> void:
	if lesson_data.is_empty():
		push_error("Lesson data is empty. Lesson ID: " + lesson_id)
		return
	title_label.text = str(lesson_data.get("title", "Lesson"))
	lesson_text.text = str(lesson_data.get("content", "[b]Lesson content not found.[/b]"))
	var sim_path = _get_simulation_path()
	simulate_button.visible = sim_path != ""

func _get_simulation_path() -> String:
	var sim_map = {
		"array":                "res://scene/Array.tscn",  # Changed from "scene" to "scene"
		"linked_list":          "res://scene/Linked.tscn",
		"doubly_linked_list":   "res://scene/Linked.tscn",
		"stack":                "res://scene/Stack.tscn",
		"queue":                "res://scene/Queue.tscn",
		"bubble_sort":          "res://scene/Bubble.tscn",
		"insertion_sort":       "res://scene/Insertion.tscn",
		"selection_sort":       "res://scene/Selection.tscn",
		"merge_sort":           "res://scene/Merge.tscn",
		"quick_sort":           "res://scene/QuickSort.tscn",
		"shell_sort":           "res://scene/ShellSort.tscn",
		"linear_search":        "res://scene/Linear.tscn",
		"binary_search":        "res://scene/Binary.tscn",
		"interpolation_search": "res://scene/Interpolation.tscn",
		"depth_first_search":   "res://scene/Dfs.tscn",
		"breadth_first_search": "res://scene/Bfs.tscn",
	}
	return sim_map.get(lesson_id, "")

# =============================================
# TTS
# =============================================
func _on_tts_button_pressed() -> void:
	if is_speaking:
		DisplayServer.tts_stop()
		_on_tts_stopped()
	else:
		_start_tts()

func _start_tts() -> void:
	var text := lesson_text.get_parsed_text().strip_edges()
	if text.is_empty():
		return

	# Refresh voices list
	voices = DisplayServer.tts_get_voices()
	
	# Load profile picture (this also updates selected_voice_id)
	load_profile_picture()

	# Verify the selected voice exists
	var voice_exists = false
	for v in voices:
		if v["id"] == selected_voice_id:
			voice_exists = true
			break
	
	if not voice_exists and not voices.is_empty():
		print("⚠ Selected voice no longer exists, using first available")
		selected_voice_id = voices[0]["id"]

	print("Starting TTS with voice ID: ", selected_voice_id)
	DisplayServer.tts_speak(text, selected_voice_id)
	is_speaking = true
	tts_button.text = "⏸"
	_show_student_sprite()

func _on_tts_stopped() -> void:
	is_speaking = false
	tts_button.text = "🔊"
	_hide_student_sprite()

func _exit_tree() -> void:
	DisplayServer.tts_stop()
	if float_tween:
		float_tween.kill()
	if Global.profile_updated.is_connected(_on_profile_updated):
		Global.profile_updated.disconnect(_on_profile_updated)
	if Global.purchases_updated.is_connected(_on_profile_updated):
		Global.purchases_updated.disconnect(_on_profile_updated)

func _show_student_sprite() -> void:
	student_speaker.visible = true
	if profile_pic and profile_pic.sprite_frames:
		profile_pic.play("talk")
		print("Playing talk animation")
	start_floating_animation()

func _hide_student_sprite() -> void:
	if profile_pic:
		profile_pic.stop()
	student_speaker.visible = false
	if float_tween:
		float_tween.kill()
		if profile_pic:
			profile_pic.position = original_sprite_position

func start_floating_animation():
	if not profile_pic:
		return
	if float_tween:
		float_tween.kill()
	float_tween = create_tween()
	float_tween.set_loops()
	float_tween.tween_property(profile_pic, "position:y", original_sprite_position.y - 5, 1.5)
	float_tween.tween_property(profile_pic, "position:y", original_sprite_position.y + 5, 1.5)

func _on_simulate_button_pressed() -> void:
	var path = _get_simulation_path()
	if path != "":
		Global.last_lesson_id = lesson_id
		SceneManager.scene_stack.append("res://scenes/lesson_view.tscn")
		GlobalLoading.load_scene(path)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/lectures.tscn")
