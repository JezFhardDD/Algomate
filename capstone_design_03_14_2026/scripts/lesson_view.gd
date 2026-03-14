extends Control

@onready var lesson_text: RichTextLabel = $MarginContainer/MainVBox/ScrollContainer/ContentBox/LessonText
@onready var tts_button: Button = $MarginContainer/MainVBox/TopBar/TTSButton
@onready var simulate_button: Button = $MarginContainer/MainVBox/ScrollContainer/ContentBox/SimulateButton
@onready var title_label: Label = $MarginContainer/MainVBox/TopBar/TitleLabel

@onready var student_speaker: Node2D = $StudentSpeaker
@onready var profile_pic: AnimatedSprite2D = $StudentSpeaker/ProfilePic

var voices: Array[Dictionary] = []
var selected_voice_id: String = ""
var is_speaking := false

var lesson_id: String = ""
var lesson_data : Dictionary = {}

# For floating animation
var float_tween: Tween = null
var original_sprite_position: Vector2

func set_lesson(id: String) -> void:
	lesson_id = id

func _ready() -> void:
	student_speaker.visible = false
	print("LessonView loaded with ID:", lesson_id)
	if lesson_id.is_empty():
		push_error("Lesson ID was not set before scene loaded.")
		return

	_load_lesson_data()
	_apply_lesson()

	voices = DisplayServer.tts_get_voices()
	selected_voice_id = _pick_default_us_voice()
	
	# Store original position for floating animation
	if profile_pic:
		original_sprite_position = profile_pic.position
	
	# Load profile picture
	load_profile_picture()

# Main function to load profile picture
func load_profile_picture():
	print("\n=== LOADING PROFILE PICTURE ===")
	
	if not profile_pic:
		print("ERROR: profile_pic is null")
		return
		
	if Global.has_profile():
		var picture_path = Global.profile_data.get("profile_picture", "")
		print("Picture path: ", picture_path)
		
		if picture_path and FileAccess.file_exists(picture_path):
			var file_name = picture_path.get_file()
			var base_path = "res://assets/profile_pics/"
			
			# Map each profile to its animation sheet
			var sheet_path = ""
			
			match file_name:
				"cat1.jpg":
					sheet_path = base_path + "cat-sheet.png"
				"girlCCT2.jpeg":
					sheet_path = base_path + "girlCCT-Sheet.png"
				"wildboar1.png":
					sheet_path = base_path + "wildboard-Sheet.png"
				"boyCCT2.jpg":
					sheet_path = base_path + "boyCCT-Sheet.png"
				"bread1.png":
					sheet_path = base_path + "bread-Sheet.png"
				_:
					print("Unknown profile: ", file_name)
			
			# Check if animation sheet exists
			print("Sheet path: ", sheet_path)
			print("Sheet exists? ", FileAccess.file_exists(sheet_path))
			if sheet_path != "" and FileAccess.file_exists(sheet_path):
				load_animation_sheet(sheet_path)
			else:
				use_static_image(picture_path)
		else:
			print("File not found: ", picture_path)
			profile_pic.visible = false
	else:
		profile_pic.visible = false

# Function to load animation sheet
func load_animation_sheet(sheet_path: String):
	print("Loading animation sheet: ", sheet_path)
	
	var sheet_texture = load(sheet_path)
	if not sheet_texture:
		print("Failed to load sheet texture")
		return
	
	# Get sheet dimensions
	var image = sheet_texture.get_image()
	var sheet_width = image.get_width()
	var sheet_height = image.get_height()
	
	# Different sheets might have different frame sizes
	var frame_width = 50
	var frame_height = 50
	
	# Check if this is the bread sheet (which has different dimensions)
	if sheet_path.contains("bread-Sheet.png"):
		frame_width = 64   # 192 / 3 = 64
		frame_height = 32   # Height is 32
		print("Using bread sheet dimensions: ", frame_width, "x", frame_height)
	
	# Calculate frames
	var frames_x = sheet_width / frame_width
	var frames_y = sheet_height / frame_height
	
	print("Sheet: ", sheet_width, "x", sheet_height, " Frames: ", frames_x, "x", frames_y)
	
	# Create sprite frames
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_animation("talk")
	
	# Add frames based on layout
	if frames_y == 1:
		# Horizontal strip
		print("Detected horizontal strip (", frames_x, " frames)")
		for frame_x in range(frames_x):
			var frame_texture = AtlasTexture.new()
			frame_texture.atlas = sheet_texture
			frame_texture.region = Rect2(frame_x * frame_width, 0, frame_width, frame_height)
			sprite_frames.add_frame("talk", frame_texture)
	else:
		# Grid layout
		print("Detected grid layout (", frames_x, "x", frames_y, ")")
		for frame_y in range(frames_y):
			for frame_x in range(frames_x):
				var frame_texture = AtlasTexture.new()
				frame_texture.atlas = sheet_texture
				frame_texture.region = Rect2(frame_x * frame_width, frame_y * frame_height, frame_width, frame_height)
				sprite_frames.add_frame("talk", frame_texture)
	
	# Configure animation
	sprite_frames.set_animation_loop("talk", true)
	sprite_frames.set_animation_speed("talk", 8.0)
	
	# Apply to sprite
	profile_pic.sprite_frames = sprite_frames
	profile_pic.scale = Vector2(4.0, 4.0)
	profile_pic.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	profile_pic.centered = true
	profile_pic.visible = true
	
	print("✓ Animation loaded with ", sprite_frames.get_frame_count("talk"), " frames")
# Function to use static image (no animation)
func use_static_image(image_path: String):
	print("Using static image: ", image_path)
	
	var texture = load(image_path)
	if not texture:
		print("Failed to load image")
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
	
	print("✓ Static image loaded")

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

	if lesson_data.has("title"):
		title_label.text = str(lesson_data["title"])
	else:
		title_label.text = "Lesson"

	if lesson_data.has("content"):
		lesson_text.text = str(lesson_data["content"])
	else:
		lesson_text.text = "[b]Lesson content not found.[/b]"

	if lesson_data.has("simulation_scene"):
		var sim_path: String = str(lesson_data["simulation_scene"])
		simulate_button.visible = sim_path != ""
	else:
		simulate_button.visible = false

func _pick_default_us_voice() -> String:
	for v in voices:
		var voice_id: String = str(v.get("id", "")).to_lower()
		if voice_id.contains("x-gbb") or voice_id.contains("x-us"):
			return v["id"]

	for v in voices:
		var lang: String = str(v.get("language", "")).to_lower()
		if lang.contains("en-us") or lang.contains("en-gb"):
			return v["id"]

	if voices.is_empty():
		return ""
	else:
		return voices[0]["id"]

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
	var path: String = str(lesson_data.get("simulation_scene", ""))
	if path != "":
		get_tree().change_scene_to_file(path)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/lectures.tscn")
