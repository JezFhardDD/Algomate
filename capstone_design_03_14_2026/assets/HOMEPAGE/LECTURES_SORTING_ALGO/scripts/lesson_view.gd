extends Control

@onready var lesson_text: RichTextLabel = $MarginContainer/MainVBox/ScrollContainer/ContentBox/LessonText
@onready var tts_button: Button = $MarginContainer/MainVBox/TopBar/TTSButton
@onready var simulate_button: Button = $MarginContainer/MainVBox/ScrollContainer/ContentBox/SimulateButton

@onready var student_speaker: Node2D = $StudentSpeaker
@onready var student_sprite: AnimatedSprite2D = $StudentSpeaker/AnimatedSprite2D

var voices: Array[Dictionary] = []
var selected_voice_id: String = ""
var is_speaking := false

var lesson_id: String = ""
var lesson_data := {}

func _ready() -> void:
	student_speaker.visible = false

	lesson_id = str(get_tree().get_current_scene().get_meta("lesson_id", ""))

	_load_lesson_data()
	_apply_lesson()

	voices = DisplayServer.tts_get_voices()
	selected_voice_id = _pick_default_us_voice()

func _load_lesson_data() -> void:
	var file := FileAccess.open("res://data/lessons.json", FileAccess.READ)
	if file == null:
		push_error("Lessons file not found.")
		return

	var text: String = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Invalid lessons.json format.")
		return

	var all_lessons: Dictionary = parsed
	lesson_data = all_lessons.get(lesson_id, {}) as Dictionary

func _apply_lesson() -> void:
	var content: String = str(lesson_data.get("content", ""))
	lesson_text.text = content

	var sim_path: String = str(lesson_data.get("simulation_scene", ""))
	simulate_button.visible = sim_path != ""

func _pick_default_us_voice() -> String:
	# Prefer known male network voices
	for v in voices:
		var voice_id: String = str(v.get("id", "")).to_lower()
		if voice_id.contains("x-gbb") or voice_id.contains("x-us"):
			return v["id"]

	# Any English fallback
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

func _show_student_sprite() -> void:
	student_speaker.visible = true
	student_sprite.play("talk")

func _hide_student_sprite() -> void:
	student_sprite.stop()
	student_speaker.visible = false

func _on_simulate_button_pressed() -> void:
	var path: String = str(lesson_data.get("simulation_scene", ""))
	if path != "":
		get_tree().change_scene_to_file(path)
