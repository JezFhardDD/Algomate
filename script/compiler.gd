extends Control
var input_container: MarginContainer
var input_textedit: TextEdit


@onready var tabs = {
	"cpp": $TextureRect/VBoxContainer/TabContainer/HBoxContainer/Tab_Cpp,
	"c": $TextureRect/VBoxContainer/TabContainer/HBoxContainer/Tab_C,
	"java": $TextureRect/VBoxContainer/TabContainer/HBoxContainer/Tab_Java,
	"python": $TextureRect/VBoxContainer/TabContainer/HBoxContainer/Tab_Python
}

@onready var code_editor: TextEdit = $TextureRect/VBoxContainer/EditorContainer/CodeArea/CodeHBox/TextEdit
@onready var back_button: Button = $TextureRect/VBoxContainer/TopBar/Button
@onready var compile_button: Button = $TextureRect/VBoxContainer/BottomBar/CompileButton
@onready var compiler_output_popup: PopupPanel = null

var current_language: String = "cpp"
var saved_code: Dictionary = {
	"cpp": "",
	"c": "",
	"java": "",
	"python": ""
}

var code_templates = {
	"cpp": '#include <iostream>\nusing namespace std;\n\nint main() {\n    cout << "Hello, World!" << endl;\n    return 0;\n}',
	"c": '#include <stdio.h>\n\nint main() {\n    printf("Hello, World!\\n");\n    return 0;\n}',
	"java": 'public class Main {\n    public static void main(String[] args) {\n        System.out.println("Hello, World!");\n    }\n}',
	"python": 'print("Hello, World!")'
}

var previous_orientation: int
var orientation_locked: bool = true

func _enter_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)
	await get_tree().process_frame
	await get_tree().process_frame

	var current_size = get_viewport().get_visible_rect().size
	if current_size.x > current_size.y: 
		get_tree().root.content_scale_size = Vector2i(int(current_size.y), int(current_size.x))

func _setup_input_field():
	var existing_container = $TextureRect/VBoxContainer.get_node_or_null("InputContainer")
	if existing_container:
		input_container = existing_container
		input_textedit = input_container.get_node("InputTextEdit")
		return

	input_container = MarginContainer.new() 
	input_container.name = "InputContainer"
	input_container.custom_minimum_size = Vector2(0, 120)
	

	var input_vbox = VBoxContainer.new()
	input_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input_container.add_child(input_vbox)

	var input_label = Label.new()
	input_label.text = "Program Input (stdin):"
	var my_font = load("res://assets/font/Planes_ValMore.ttf")
	if my_font:
		input_label.add_theme_font_override("font", my_font)
	input_label.add_theme_font_size_override("font_size", 20)
	input_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8, 1))
	input_vbox.add_child(input_label)

	input_textedit = TextEdit.new() 
	input_textedit.name = "InputTextEdit"
	input_textedit.placeholder_text = "Enter input here...\nEach line is sent in order when program calls input() / cin"
	input_textedit.custom_minimum_size = Vector2(0, 70)
	input_textedit.wrap_mode = TextEdit.LINE_WRAPPING_NONE
	

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.12, 1)
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_right = 4
	style.corner_radius_bottom_left = 4
	input_textedit.add_theme_stylebox_override("normal", style)
	input_textedit.add_theme_stylebox_override("focus", style)
	
	if my_font:
		input_textedit.add_theme_font_override("font", my_font)
	input_textedit.add_theme_font_size_override("font_size", 18)
	
	input_vbox.add_child(input_textedit)

	var hint_label = Label.new()
	hint_label.text = "Tip: For multiple inputs, put each on a new line"
	if my_font:
		hint_label.add_theme_font_override("font", my_font)
	hint_label.add_theme_font_size_override("font_size", 14)
	hint_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5, 1))
	input_vbox.add_child(hint_label)
	

	var clear_btn = Button.new()
	clear_btn.text = "Clear Input"
	clear_btn.custom_minimum_size = Vector2(120, 40)
	clear_btn.pressed.connect(_on_clear_input_pressed)
	input_vbox.add_child(clear_btn)

	var editor_container = $TextureRect/VBoxContainer/EditorContainer
	var editor_index = editor_container.get_index()
	
	$TextureRect/VBoxContainer.add_child(input_container)
	$TextureRect/VBoxContainer.move_child(input_container, editor_index + 1)
	
	print("Input field added to compiler scene")

func _ready():
	for lang in tabs:
		tabs[lang].pressed.connect(_on_tab_pressed.bind(lang))
	

	back_button.pressed.connect(_on_back_pressed)
	compile_button.pressed.connect(_on_compile_pressed)
	

	_load_code_for_language(current_language)
	
	_update_tab_highlight()

	var editor_container = $TextureRect/VBoxContainer/EditorContainer
	editor_container.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var floating_blocks = $TextureRect/VBoxContainer/EditorContainer/FloatingBlocks
	if floating_blocks:
		floating_blocks.anchor_right = 1.0
		floating_blocks.anchor_bottom = 1.0
		floating_blocks.offset_right = 0
		floating_blocks.offset_bottom = 0

	previous_orientation = DisplayServer.screen_get_orientation()
	_set_compiler_orientation()
	

	self.visibility_changed.connect(_on_visibility_changed)
	
	print("Compiler scene ready - orientation set to portrait")
	await get_tree().process_frame
	await get_tree().process_frame
	$TextureRect.queue_redraw()
	get_tree().root.propagate_notification(NOTIFICATION_RESIZED)
	_setup_input_field()


func _set_compiler_orientation():
	if orientation_locked:

		DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_PORTRAIT)
		print("Orientation locked to portrait")
	else:

		DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)
		print("Orientation set to portrait (auto-rotate allowed)")

func _on_visibility_changed():
	if self.visible:

		_set_compiler_orientation()
	else:

		_restore_orientation()

func _restore_orientation():

	if not self.visible:
		DisplayServer.screen_set_orientation(previous_orientation)
		print("Restored previous orientation: ", previous_orientation)

func _exit_tree():

	_restore_orientation()

func toggle_orientation_lock():
	orientation_locked = !orientation_locked
	_set_compiler_orientation()

func get_orientation_string() -> String:
	var current = DisplayServer.screen_get_orientation()
	match current:
		DisplayServer.SCREEN_PORTRAIT:
			return "Portrait"
		DisplayServer.SCREEN_REVERSE_PORTRAIT:
			return "Reverse Portrait"
		DisplayServer.SCREEN_LANDSCAPE:
			return "Landscape"
		DisplayServer.SCREEN_REVERSE_LANDSCAPE:
			return "Reverse Landscape"
		DisplayServer.SCREEN_SENSOR:
			return "Sensor"
		DisplayServer.SCREEN_SENSOR_LANDSCAPE:
			return "Sensor Landscape"
		DisplayServer.SCREEN_SENSOR_PORTRAIT:
			return "Sensor Portrait"
		_:
			return "Unknown"

func _on_tab_pressed(lang: String):

	saved_code[current_language] = code_editor.text

	current_language = lang

	_load_code_for_language(lang)
	

	_update_tab_highlight()

func _load_code_for_language(lang: String):
	if saved_code[lang] == "":
		code_editor.text = code_templates[lang]
	else:
		code_editor.text = saved_code[lang]

func _update_tab_highlight():

	for lang in tabs:
		tabs[lang].self_modulate = Color(0.5, 0.5, 0.5, 1)
	

	if current_language in tabs:
		match current_language:
			"cpp": 
				tabs[current_language].self_modulate = Color(0.0117647, 0.478431, 0.623529, 1)
				tabs[current_language].modulate = Color(1, 1, 1, 1)
			"c": 
				tabs[current_language].self_modulate = Color(0.531, 0.33, 1, 1)
				tabs[current_language].modulate = Color(1, 1, 1, 1)
			"java": 
				tabs[current_language].self_modulate = Color(0.244373, 0.506155, 0.204431, 1)
				tabs[current_language].modulate = Color(1, 1, 1, 1)
			"python": 
				tabs[current_language].self_modulate = Color(0, 0.67451, 0.627451, 1)
				tabs[current_language].modulate = Color(1, 1, 1, 1)

func _on_compile_pressed():

	saved_code[current_language] = code_editor.text
	

	_show_feedback("Compiling...", Color.YELLOW)

	var keys = APIManager.get_keys("KEY_C")
	

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_compile_completed.bind(http_request))
	
	var url = "https://api.jdoodle.com/v1/execute"
	var headers = ["Content-Type: application/json"]
	
	var api_language = current_language
	match current_language:
		"python":
			api_language = "python3"
	
	var stdin_input = ""
	if input_textedit and input_textedit.text.strip_edges() != "":
		stdin_input = input_textedit.text
		print("User input provided: ", stdin_input)
	else:
		print("No user input provided")
	
	var body = JSON.new().stringify({
		"clientId": keys["clientId"],
		"clientSecret": keys["clientSecret"],
		"script": code_editor.text,
		"language": api_language,
		"versionIndex": _get_version_index(current_language),
		"stdin": stdin_input
	})
	
	print("=== JDoodle API Request ===")
	print("URL: ", url)
	print("Language: ", current_language, " → API Language: ", api_language)
	print("Version Index: ", _get_version_index(current_language))
	print("Stdin: ", stdin_input)
	print("Script preview: ", code_editor.text.substr(0, 50) + "...")
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		_show_feedback("Network error!", Color.RED)

func _get_version_index(lang: String) -> String:
	match lang:
		"cpp": return "5" 
		"c": return "4"    
		"java": return "4"  
		"python": return "4"
		_: return "0"

func _on_compile_completed(result, response_code, headers, body, http_request):
	http_request.queue_free()
	
	if response_code != 200:
		_show_feedback("API Error: " + str(response_code), Color.RED)
		return
	
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	
	if parse_result != OK:
		_show_feedback("Parse error!", Color.RED)
		return
	
	var response = json.data
	
	_show_compiler_output(response)

func _show_compiler_output(response: Dictionary):
	if compiler_output_popup == null:
		var popup_scene = preload("res://scene/CompilerOutput.tscn")
		compiler_output_popup = popup_scene.instantiate()
		add_child(compiler_output_popup)
		
		compiler_output_popup.recompile_requested.connect(_on_recompile_requested)
		compiler_output_popup.closed.connect(_on_output_closed)
	
	compiler_output_popup.show_output(current_language, response, self, true)

func _show_feedback(text: String, color: Color):
	var feedback_scene = preload("res://scene/FeedbackLabel.tscn")
	var label = feedback_scene.instantiate()
	label.text = text
	label.modulate = color
	label.global_position = Vector2(200, 500)  # Adjust position as needed
	add_child(label)
	
	var anim_player: AnimationPlayer = label.get_node("AnimationPlayer")
	anim_player.play("notification_pop")
	anim_player.animation_finished.connect(func(_anim_name): label.queue_free())

func _on_back_pressed():
	saved_code[current_language] = code_editor.text
	_restore_orientation()
	AudioManager.play_back_sound()
	SceneManager.go_back()


func set_initial_code(lang: String, code: String):
	current_language = lang
	saved_code[lang] = code
	_load_code_for_language(lang)
	_update_tab_highlight()

func reset_cache_for_scene():
	print("Cache reset called - to be implemented with CompilerOutput")
func _on_recompile_requested(language: String):
	_on_compile_pressed()
func _on_output_closed():
	print("Compiler output closed")
func has_cached_output() -> bool:
	if compiler_output_popup == null:
		return false
	return compiler_output_popup.has_cached_result(current_language)

func show_cached_output():
	if compiler_output_popup != null and has_cached_output():
		var cached = compiler_output_popup.get_cached_result(current_language)
		var fake_response = {
			"output": cached.output,
			"error": cached.error,
			"memory": cached.memory,
			"cpu": cached.cpu
		}
		compiler_output_popup.show_output(current_language, fake_response, self)



func _on_clear_input_pressed():
	if input_textedit:
		input_textedit.text = ""
		_show_feedback("Input cleared", Color.GREEN)
