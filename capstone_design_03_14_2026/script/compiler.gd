extends Control

# API Keys
const API_KEYS = {
	"cpp": {
		"clientId": "2401da4c28f2c97e0bed9ca3957a31c7",
		"clientSecret": "6fdf1a280c510b6d61ba5f964a272a8fa30a5f207cbc395bdece31e781588e73"
	},
	"c": {
		"clientId": "1b1bc8decbed095d6bf0d7399224b9eb",
		"clientSecret": "e520c9852647730c46853932941226b1c6c47badaf6409c4f34e0a89dcc8611a"
	},
	"java": {
		"clientId": "14e8bb1335d07711f04c72a2a81ad16e",
		"clientSecret": "c59ca7898c39d69a3fa54a867e52ba35a950fb74707ef3e288d913bbf6a492af"
	},
	"python": {
		"clientId": "36c21fabf5976c192d192ab04af4c8f9",
		"clientSecret": "a2d0c24c91d4ab4193a2f242307967d61d5f70a2a422734d7458d240c9c596c4"
	}
}

# Node references
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
# Current language and code persistence
var current_language: String = "cpp"
var saved_code: Dictionary = {
	"cpp": "",
	"c": "",
	"java": "",
	"python": ""
}

# Default code templates
var code_templates = {
	"cpp": '#include <iostream>\nusing namespace std;\n\nint main() {\n    cout << "Hello, World!" << endl;\n    return 0;\n}',
	"c": '#include <stdio.h>\n\nint main() {\n    printf("Hello, World!\\n");\n    return 0;\n}',
	"java": 'public class Main {\n    public static void main(String[] args) {\n        System.out.println("Hello, World!");\n    }\n}',
	"python": 'print("Hello, World!")'
}

# Orientation tracking
var previous_orientation: int
var orientation_locked: bool = true

func _enter_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Swap width and height to match portrait
	var current_size = get_viewport().get_visible_rect().size
	if current_size.x > current_size.y:  # Still thinks it's landscape
		get_tree().root.content_scale_size = Vector2i(int(current_size.y), int(current_size.x))
	
func _ready():
	# Connect tab buttons
	for lang in tabs:
		tabs[lang].pressed.connect(_on_tab_pressed.bind(lang))
	
	# Connect other buttons
	back_button.pressed.connect(_on_back_pressed)
	compile_button.pressed.connect(_on_compile_pressed)
	
	# Set initial code
	_load_code_for_language(current_language)
	
	# Highlight current tab
	_update_tab_highlight()
	
	# Force EditorContainer to take available space
	var editor_container = $TextureRect/VBoxContainer/EditorContainer
	editor_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	# Make sure FloatingBlocks fills its parent
	var floating_blocks = $TextureRect/VBoxContainer/EditorContainer/FloatingBlocks
	if floating_blocks:
		floating_blocks.anchor_right = 1.0
		floating_blocks.anchor_bottom = 1.0
		floating_blocks.offset_right = 0
		floating_blocks.offset_bottom = 0
	
	# --- ORIENTATION HANDLING ---
	# Store current orientation and switch to portrait
	previous_orientation = DisplayServer.screen_get_orientation()
	_set_compiler_orientation()
	
	# Connect to visibility changes (in case scene is shown/hidden)
	self.visibility_changed.connect(_on_visibility_changed)
	
	print("Compiler scene ready - orientation set to portrait")
	await get_tree().process_frame
	await get_tree().process_frame
	$TextureRect.queue_redraw()
	get_tree().root.propagate_notification(NOTIFICATION_RESIZED)


func _set_compiler_orientation():
	if orientation_locked:
		# Lock to portrait (won't auto-rotate)
		DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_PORTRAIT)
		print("Orientation locked to portrait")
	else:
		# Allow both portrait orientations (can flip 180°)
		DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)
		print("Orientation set to portrait (auto-rotate allowed)")

func _on_visibility_changed():
	if self.visible:
		# Scene became visible - ensure portrait mode
		_set_compiler_orientation()
	else:
		# Scene hidden - restore previous orientation
		_restore_orientation()

func _restore_orientation():
	# Only restore if we're not visible (prevents flickering)
	if not self.visible:
		DisplayServer.screen_set_orientation(previous_orientation)
		print("Restored previous orientation: ", previous_orientation)

func _exit_tree():
	# Clean up when scene is destroyed
	_restore_orientation()

# Optional: Method to toggle orientation lock (can be called from a settings button)
func toggle_orientation_lock():
	orientation_locked = !orientation_locked
	_set_compiler_orientation()

# Optional: Get current orientation as string
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
	# Save current code before switching
	saved_code[current_language] = code_editor.text
	
	# Switch language
	current_language = lang
	
	# Load saved code for new language (or template if empty)
	_load_code_for_language(lang)
	
	# Update tab highlighting
	_update_tab_highlight()

func _load_code_for_language(lang: String):
	if saved_code[lang] == "":
		code_editor.text = code_templates[lang]
	else:
		code_editor.text = saved_code[lang]

func _update_tab_highlight():
	# Reset all tabs to gray
	for lang in tabs:
		tabs[lang].self_modulate = Color(0.5, 0.5, 0.5, 1)
	
	# Highlight current tab with its specific color
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
	# Save current code
	saved_code[current_language] = code_editor.text
	
	# Show feedback
	_show_feedback("Compiling...", Color.YELLOW)
	
	# Get API keys
	var keys = API_KEYS[current_language]
	
	# Prepare API request
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_compile_completed.bind(http_request))
	
	var url = "https://api.jdoodle.com/v1/execute"
	var headers = ["Content-Type: application/json"]
	
	# Map language to JDoodle API expected format
	var api_language = current_language
	match current_language:
		"python":
			api_language = "python3"  # CRITICAL FIX: JDoodle expects "python3" not "python"
		# C++ and C are fine as "cpp" and "c"
		# Java is fine as "java"
	
	var body = JSON.new().stringify({
		"clientId": keys["clientId"],
		"clientSecret": keys["clientSecret"],
		"script": code_editor.text,
		"language": api_language,  # Use the mapped language
		"versionIndex": _get_version_index(current_language)
	})
	
	print("=== JDoodle API Request ===")
	print("URL: ", url)
	print("Language: ", current_language, " → API Language: ", api_language)
	print("Version Index: ", _get_version_index(current_language))
	print("Script preview: ", code_editor.text.substr(0, 50) + "...")
	print("Full request body: ", body)
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		_show_feedback("Network error!", Color.RED)

func _get_version_index(lang: String) -> String:
	match lang:
		"cpp": return "5"  # C++17
		"c": return "4"     # C17
		"java": return "4"  # Java 17
		"python": return "4" # Python 3
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
	
	# Show CompilerOutput popup with results
	_show_compiler_output(response)

func _show_compiler_output(response: Dictionary):
	# Load the popup scene if not already loaded
	if compiler_output_popup == null:
		var popup_scene = preload("res://scene/CompilerOutput.tscn")
		compiler_output_popup = popup_scene.instantiate()
		add_child(compiler_output_popup)
		
		# Connect signals
		compiler_output_popup.recompile_requested.connect(_on_recompile_requested)
		compiler_output_popup.closed.connect(_on_output_closed)
	
	# Pass true to indicate this is from the Compiler scene (portrait mode)
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

# Public method to set initial code (for when opened from simulation)
func set_initial_code(lang: String, code: String):
	current_language = lang
	saved_code[lang] = code
	_load_code_for_language(lang)
	_update_tab_highlight()

# Public method to reset cache (will be called from simulation scenes)
func reset_cache_for_scene():
	# This will be implemented when we create the CompilerOutput cache system
	print("Cache reset called - to be implemented with CompilerOutput")
func _on_recompile_requested(language: String):
	# User wants to recompile the same code
	_on_compile_pressed()
func _on_output_closed():
	# Output popup closed - do any cleanup if needed
	print("Compiler output closed")
func has_cached_output() -> bool:
	if compiler_output_popup == null:
		return false
	return compiler_output_popup.has_cached_result(current_language)

# Optional: Method to show cached output without recompiling
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
