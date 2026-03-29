extends Control

# =======================================================
#   LINEAR SEARCH SIMULATION - FINAL (Manual + Auto)
# =======================================================

# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton          # "Find Element"
@onready var auto_btn: Button = $VBoxContainer/LinearStep      # "Linear Step"
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew

# --- NEW BUTTON (Make sure you created "AutoSearchButton" in VBoxContainer!) ---
@onready var auto_search_btn: Button = get_node_or_null("VBoxContainer/AutoSearchButton")

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var compare_label: Label = $HBoxContainer2/Label
@onready var array_container: Control = $QueueContainer
@onready var dequeued_container: Control = $DequeuedContainer 

# --- POPUPS ---
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label

# --- TIMELINE POPUP ---
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: Label = $TimelinePopup/MainVBox/ScrollContainer/VBoxContainer/Label
@onready var timeline_close_btn: Button = get_node_or_null("TimelinePopup/MainVBox/CloseButton")

# Queue Full Warning
@onready var Queue_full: Panel = get_node_or_null("Queue_full")
@onready var anim_sprite: AnimatedSprite2D = get_node_or_null("Queue_full/AnimatedSprite2D")

# Simulation Complete popup
@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var process_label: Label = get_node_or_null("SimulationCompletePopup/VBoxContainer/ProcessLabel")

# --- C++ POPUP NODES ---
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_scroll: ScrollContainer = get_node_or_null("CppPopup/VBoxContainer/CodeScroll")
@onready var cpp_label: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/CodeScroll/CodeLabel")
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/close") as Button

# Code Walkthrough Nodes
@onready var cpp_next_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CppNextButton")
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_lbl: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")

# --- COMPILER INTEGRATION ---
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CompileButton")

# Top Right Button
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")
@onready var code_anim: AnimatedSprite2D = get_node_or_null("CppCodeButton/code_anim")

# --- SCENE RESOURCES ---
const BLOCK_SCENE := preload("res://BubbleBlock.tscn")
const POINTER_TEX := preload("res://assets/point_left.png")
const RESULT_POPUP_SCENE := preload("res://scene/ResultPopup.tscn")

# --- POINTERS ---
@onready var ptr_left: Node = $TextureRect/front  
@onready var ptr_right: Node = $TextureRect/rear  

@onready var unused_ptr1: Node = $TextureRect/front2
@onready var unused_ptr2: Node = $TextureRect/rear2

# --- TUTORIAL OVERLAY ---
@onready var tutorial_overlay: CanvasLayer = $TutorialOverlay
@onready var dim_bg: ColorRect = $TutorialOverlay/DimBackground
@onready var tutorial_box: Panel = $TutorialOverlay/TutorialBox
@onready var tutorial_text: Label = $TutorialOverlay/TutorialBox/VBoxContainer/TutorialText
@onready var tutorial_next: Button = $TutorialOverlay/TutorialBox/VBoxContainer/NextButton
@onready var pointer_sprite: Sprite2D = $TutorialOverlay/PointerSprite

# --- INTRO POPUP ---
@onready var intro_popup: Panel = $TutorialOverlay/Intro_popup
@onready var intro_label: Label = $TutorialOverlay/Intro_popup/Label
@onready var intro_next_btn: Button = $TutorialOverlay/Intro_popup/next
@onready var intro_skip_btn: Button = $TutorialOverlay/Intro_popup/skip
@onready var intro_prev_btn: Button = $TutorialOverlay/Intro_popup/prev

# --- AUDIO ---
@onready var audio_player = $bgm
@onready var btn_sound = $btn_sound

# --- CONFIGURATION MODALS ---
@onready var config_modal: Panel = $ConfigChoiceModal
@onready var yes_btn: Button = $ConfigChoiceModal/yesButton
@onready var no_btn: Button = $ConfigChoiceModal/NoButton

@onready var config_size_modal: Panel = $ConfigSizeModal
@onready var size_input: SpinBox = $ConfigSizeModal/SizeSpinBox
@onready var size_back_btn: Button = $ConfigSizeModal/BackButton
@onready var size_next_btn: Button = $ConfigSizeModal/NextButton

@onready var config_elements_modal: Panel = $ConfigElementsModal
@onready var elements_container: VBoxContainer = $ConfigElementsModal/ScrollContainer/VBoxContainer
@onready var elements_back_btn: Button = $ConfigElementsModal/BackButton
@onready var elements_done_btn: Button = $ConfigElementsModal/DoneButton

@onready var sim_confirmation: Panel = $Simulate_new_confirmation
@onready var sim_success: Panel = $"simulate_new success"
@onready var q_mark_sprite: AnimatedSprite2D = $HelpButton/Q_mark_anim_sprites

# --- LANGUAGE BUTTONS ---
@onready var cpp_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Cpp_btn
@onready var python_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Py_btn
@onready var java_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Java_btn
@onready var c_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/C_btn

# ==============================================
#   COMPILER INTEGRATION - API KEYS
# ==============================================
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

# --- LINEAR SEARCH VARIABLES ---
var main_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []

# Code generation variables
var code_lines: Array[String] = []
var current_code_language: String = "cpp"

# Result Popup
var result_popup: PopupPanel
var result_title: Label
var score_summary: Label
var accuracy_label: Label
var time_used_label: Label
var coins_label: Label
var coins_anim: AnimatedSprite2D
var try_again_result_btn: Button
var back_result_btn: Button
var translate_code_btn: Button

# Linear Search State
var search_target: int = 0
var current_idx: int = 0
var search_found: bool = false

var comparison_counter: int = 0
var swap_counter: int = 0 
var sorting_complete: bool = false
var is_sorting: bool = false
var is_auto_playing: bool = false

var BLOCK_WIDTH: float = 64.0 
var BLOCK_SPACING: float = 15.0
var START_POSITION: Vector2 = Vector2(50, 80)
var ANIM_SPEED: float = 1.0

# --- Target Input Dialog ---
var target_input_dialog: ConfirmationDialog
var target_spinbox: SpinBox

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

# Intro Text
var intro_step: int = 0
var intro_texts = [
	"Welcome to Linear Search Simulation!\nLinear Search is the simplest searching algorithm. It checks each element in the list sequentially until a match is found.",
	"The Algorithm:\n\n1. Start from the first element.\n2. Compare the current element with the Target Value.\n3. If it matches, STOP (Found).\n4. If not, move to the next element.",
	"Complexity Analysis:\n\nTime: O(n) - In the worst case, it checks every item.\nSpace: O(1) - Uses a constant amount of memory.",
	"Visual Elements:\n\n• The 'FRONT' pointer tracks the current element being checked.\n• We are searching for a specific target value.",
	"How to Use:\n\n1. Click 'FIND ELEMENT' to set target.\n2. Click 'LINEAR STEP' for manual check.\n3. Click 'AUTO SEARCH' to run automatically."
]

# Code Tutorial Data
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = [] 

var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Imports & Setup: Include iostream for standard input/output." },
	{ "lines": [3, 4, 5, 6, 7], "text": "2. Complexity: [color=yellow]Time: O(n)[/color] (linear scan) and [color=green]Space: O(1)[/color] (in-place)." },
	{ "lines": [8], "text": "3. The Loop: Use a for-loop to iterate from index 0 to n-1." },
	{ "lines": [9, 10], "text": "4. Comparison: Check if current element matches the target value 'x'." },
	{ "lines": [11], "text": "5. Match Found: Return the current index immediately." },
	{ "lines": [13], "text": "6. Not Found: If the loop finishes, return -1." }
]

var python_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Complexity: [color=yellow]Time: O(n)[/color], [color=green]Space: O(1)[/color]." },
	{ "lines": [2], "text": "2. Function: Define search taking the list and target value." },
	{ "lines": [3], "text": "3. Loop: Standard Python loop using range and length of array." },
	{ "lines": [4, 5], "text": "4. Check: If the element at index 'i' equals target 'x', return index." },
	{ "lines": [6], "text": "5. Return: Give back -1 if not found." }
]

var java_tutorial_data = [
	{ "lines": [0, 1, 2, 3], "text": "1. Complexity: [color=yellow]Time: O(n)[/color], [color=green]Space: O(1)[/color]." },
	{ "lines": [4, 5], "text": "2. Method: Create a static method that returns an integer index." },
	{ "lines": [6], "text": "3. Loop: Iterate through the array using 'arr.length'." },
	{ "lines": [7, 8, 9], "text": "4. Logic: Use '==' to compare primitive integers." },
	{ "lines": [11], "text": "5. Result: Return -1 if the search concludes without a match." }
]

var c_tutorial_data = [
	{ "lines": [0], "text": "1. Setup: Include stdio.h for printing." },
	{ "lines": [1, 2, 3, 4], "text": "2. Complexity: [color=yellow]Time: O(n)[/color], [color=green]Space: O(1)[/color]." },
	{ "lines": [6], "text": "3. Logic: Standard C for-loop iterating over the array size." },
	{ "lines": [7, 8], "text": "4. Return: Return index immediately upon finding the target." }
]

# ==============================================
#   READY
# ==============================================
func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	print("Program started — initializing Linear Search visualizer...")
	randomize()
	
	# Setup result popup
	result_popup = RESULT_POPUP_SCENE.instantiate()
	add_child(result_popup)
	result_title = result_popup.get_node("TextureRect/VBoxContainer/ResultTitle")
	score_summary = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer3/VBoxContainer/ScoreSummary")
	accuracy_label = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer3/VBoxContainer/AccuracyLabel")
	time_used_label = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer3/VBoxContainer/TimeUsedLabel")
	coins_label = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer3/HBoxContainer/Label")
	coins_anim = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer3/HBoxContainer/Control/AnimatedSprite2D")
	try_again_result_btn = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer2/TryAgainButton")
	back_result_btn = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer2/BackButton")
	translate_code_btn = result_popup.get_node("TextureRect/VBoxContainer/translate_code_btn")
	
	# Connect result buttons
	try_again_result_btn.pressed.connect(_on_try_again_pressed)
	back_result_btn.pressed.connect(_on_back_pressed)
	translate_code_btn.pressed.connect(_on_translate_code_pressed)
	
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if unused_ptr1: unused_ptr1.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	if cpp_code_button: cpp_code_button.hide()
	
	# --- BUTTON TEXT SETUP ---
	if sort_btn: sort_btn.text = "Find Element"
	if auto_btn: auto_btn.text = "Linear Step"
	
	# --- SETUP NEW AUTO BUTTON ---
	if auto_search_btn:
		auto_search_btn.text = "Auto Search"
		_ensure_connected(auto_search_btn, "pressed", _on_auto_search_pressed)
	
	_create_target_input_dialog()
	_connect_configuration_buttons()
	
	# Setup compiler
	_setup_compiler()
	
	_show_config_modal() 
	
	call_deferred("show_introduction")
	
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")
	
	_connect_language_buttons()

func _enter_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	await get_tree().process_frame
	await get_tree().process_frame
	var current_size = get_viewport().get_visible_rect().size
	if current_size.y > current_size.x:
		get_tree().root.content_scale_size = Vector2i(int(current_size.y), int(current_size.x))

func _exit_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_PORTRAIT)
	 
	
# ==============================================
#   COMPILER SETUP FUNCTIONS
# ==============================================
func _setup_compiler() -> void:
	"""Setup compiler button and popup"""
	if compile_btn:
		if compile_btn.is_connected("pressed", _on_compile_button_pressed):
			compile_btn.disconnect("pressed", _on_compile_button_pressed)
		compile_btn.pressed.connect(_on_compile_button_pressed)
	
	if compiler_output_popup == null:
		var popup_scene = preload("res://scene/CompilerOutput.tscn")
		compiler_output_popup = popup_scene.instantiate()
		add_child(compiler_output_popup)
		
		compiler_output_popup.recompile_requested.connect(_on_recompile_requested)
		compiler_output_popup.closed.connect(_on_compiler_output_closed)


func _on_compile_button_pressed() -> void:
	btn_sound.play()
	
	var code = _generate_code_for_language(current_code_language)
	
	if compiler_output_popup and compiler_output_popup.has_cached_result(current_code_language):
		var cached = compiler_output_popup.get_cached_result(current_code_language)
		var fake_response = {
			"output": cached.output,
			"error": cached.error,
			"memory": cached.memory,
			"cpu": cached.cpu
		}
		compiler_output_popup.show_output(current_code_language, fake_response, self, false)
		show_feedback("Using cached result!", Color.YELLOW, Vector2(200, 200))
	else:
		_compile_code(code)


func _compile_code(code: String) -> void:
	show_feedback("Compiling...", Color.YELLOW, Vector2(200, 200))
	
	var keys = API_KEYS[current_code_language]
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_compile_completed.bind(http_request, current_code_language))
	
	var url = "https://api.jdoodle.com/v1/execute"
	var headers = ["Content-Type: application/json"]
	
	var api_language = current_code_language
	match current_code_language:
		"python":
			api_language = "python3"
	
	var body = JSON.new().stringify({
		"clientId": keys["clientId"],
		"clientSecret": keys["clientSecret"],
		"script": code,
		"language": api_language,
		"versionIndex": _get_version_index(current_code_language)
	})
	
	print("=== Linear Search Compile Request ===")
	print("Language: ", current_code_language, " → API: ", api_language)
	print("Script preview: ", code.substr(0, 50) + "...")
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		show_feedback("Network error!", Color.RED, Vector2(200, 200))


func _get_version_index(lang: String) -> String:
	match lang:
		"cpp": return "5"
		"c": return "4"
		"java": return "4"
		"python": return "4"
		_: return "0"


func _on_compile_completed(result, response_code, headers, body, http_request, language: String) -> void:
	http_request.queue_free()
	
	if response_code != 200:
		show_feedback("API Error: " + str(response_code), Color.RED, Vector2(200, 200))
		return
	
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	
	if parse_result != OK:
		show_feedback("Parse error!", Color.RED, Vector2(200, 200))
		return
	
	var response = json.data
	
	if compiler_output_popup:
		compiler_output_popup.show_output(language, response, self, false)


func _on_recompile_requested(language: String) -> void:
	var code = _generate_code_for_language(language)
	_compile_code(code)


func _on_compiler_output_closed() -> void:
	print("Compiler output closed")


func reset_cache_for_scene() -> void:
	if compiler_output_popup:
		compiler_output_popup.reset_cache_for_scene()
		print("Compiler cache reset for new simulation")

# --- NEW: Auto Search Handler ---
func _on_auto_search_pressed() -> void:
	if sorting_complete: return
	btn_sound.play()
	is_auto_playing = !is_auto_playing
	
	if auto_search_btn:
		auto_search_btn.text = "Pause" if is_auto_playing else "Auto Search"
	
	# Disable manual step while auto is running
	if auto_btn:
		auto_btn.disabled = is_auto_playing
		
	if is_auto_playing:
		_run_auto_sort()

func _run_auto_sort() -> void:
	while is_auto_playing and not sorting_complete:
		if is_sorting: await get_tree().process_frame 
		else:
			await _perform_sort_step()
			await get_tree().create_timer(ANIM_SPEED).timeout

# --- POPUP CREATION ---
# --- POPUP CREATION ---
func _create_target_input_dialog():
	var my_font = load("res://assets/font/Planes_ValMore.ttf") 
	
	target_input_dialog = ConfirmationDialog.new()
	target_input_dialog.title = "Find Element"
	target_input_dialog.add_theme_font_size_override("title_font_size", 24)
	target_input_dialog.add_theme_font_override("title_font", my_font)
	target_input_dialog.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	target_input_dialog.min_size = Vector2(450, 220) 
	
	# --- DIALOG BACKGROUND ---
	var texture_style = StyleBoxTexture.new()
	texture_style.texture = load("res://assets/containers/CONTAINER.png") 
	texture_style.content_margin_bottom = 25 # Pushes the buttons up
	target_input_dialog.add_theme_stylebox_override("panel", texture_style)
	
	target_input_dialog.close_requested.connect(func(): pass) 

	# --- BUTTONS ---
	var ok_btn = target_input_dialog.get_ok_button()
	var cancel_btn = target_input_dialog.get_cancel_button()
	
	ok_btn.text = "Search"
	
	var btn_texture = StyleBoxTexture.new()
	btn_texture.texture = load("res://assets/BUTTON.png")
	btn_texture.texture_margin_left = 6
	btn_texture.texture_margin_right = 6
	btn_texture.texture_margin_top = 6
	btn_texture.texture_margin_bottom = 6
	
	var btn_hover = btn_texture.duplicate()
	btn_hover.modulate_color = Color(0.8, 0.8, 0.8, 1.0) 
	
	var btn_pressed = btn_texture.duplicate()
	btn_pressed.modulate_color = Color(0.6, 0.6, 0.6, 1.0)

	for btn in [ok_btn, cancel_btn]:
		btn.custom_minimum_size = Vector2(140, 60)
		btn.add_theme_font_override("font", my_font)
		btn.add_theme_font_size_override("font_size", 22)

		btn.add_theme_stylebox_override("normal", btn_texture)
		btn.add_theme_stylebox_override("hover", btn_hover)
		btn.add_theme_stylebox_override("pressed", btn_pressed)
		
		var empty_style = StyleBoxEmpty.new()
		btn.add_theme_stylebox_override("focus", empty_style)

	# --- CONTAINERS ---
	var margin_container = MarginContainer.new()
	margin_container.add_theme_constant_override("margin_top", 20)
	margin_container.add_theme_constant_override("margin_left", 25)
	margin_container.add_theme_constant_override("margin_right", 25)
	margin_container.add_theme_constant_override("margin_bottom", 10)
	target_input_dialog.add_child(margin_container)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15)
	margin_container.add_child(vbox)

	var lbl = Label.new()
	lbl.text = "Enter value (0-999):"
	lbl.add_theme_font_override("font", my_font)
	lbl.add_theme_font_size_override("font_size", 24)
	vbox.add_child(lbl)

	target_spinbox = SpinBox.new()
	target_spinbox.min_value = 0
	target_spinbox.max_value = 999
	target_spinbox.custom_minimum_size = Vector2(0, 60)
	vbox.add_child(target_spinbox)

	var line_edit = target_spinbox.get_line_edit()
	line_edit.max_length = 3
	line_edit.select_all_on_focus = true

	line_edit.add_theme_font_override("font", my_font)
	line_edit.add_theme_font_size_override("font_size", 26)

	line_edit.text_changed.connect(func(new_text: String):
		var regex = RegEx.new()
		regex.compile("[^0-9]") 
		var filtered = regex.sub(new_text, "", true)
		if new_text != filtered:
			line_edit.text = filtered
			line_edit.caret_column = filtered.length()
	)

	line_edit.text_submitted.connect(func(_text): 
		_on_target_confirmed()
		target_input_dialog.hide()
	)

	add_child(target_input_dialog)
	target_input_dialog.confirmed.connect(_on_target_confirmed)

func _on_target_confirmed():
	btn_sound.play()
	var new_target = int(target_spinbox.value)
	_reset_search_for_new_target(new_target)

func _reset_search_for_new_target(new_val: int):
	search_target = new_val
	status_label.text = "Target to Find: %d" % search_target
	timeline_log.clear()
	timeline_log.append("Started Search for Target: %d" % search_target)
	
	# Add code line for target
	_add_code_line("TARGET", 0, search_target)
	
	current_idx = 0
	search_found = false
	comparison_counter = 0
	sorting_complete = false
	is_auto_playing = false
	
	# Enable buttons
	if auto_btn: auto_btn.disabled = false
	if sort_btn: sort_btn.disabled = false
	if auto_search_btn: 
		auto_search_btn.disabled = false
		auto_search_btn.text = "Auto Search"
	
	if ptr_left: ptr_left.hide()
	
	for block in block_nodes:
		if block.has_method("set_highlight"): block.set_highlight(false)
		if block.has_method("reset_visuals"): block.reset_visuals()
		block.modulate = Color(1, 1, 1, 1)
		
	_update_ui_labels()

func _connect_language_buttons():
	if cpp_lang_btn: cpp_lang_btn.pressed.connect(func(): _set_language("cpp"))
	if python_lang_btn: python_lang_btn.pressed.connect(func(): _set_language("python"))
	if java_lang_btn: java_lang_btn.pressed.connect(func(): _set_language("java"))
	if c_lang_btn: c_lang_btn.pressed.connect(func(): _set_language("c"))

func _set_language(lang: String):
	btn_sound.play()
	current_code_language = lang
	_show_cpp_popup()

# ==============================================
#   INITIALIZATION
# ==============================================

func _initialize_with_elements(elements: Array[int]) -> void:
	# Reset cache for new simulation
	reset_cache_for_scene()
	
	# Clear code lines
	code_lines.clear()
	
	print("Initializing Array with:", elements)
	audio_player.play()
	
	main_array = elements.duplicate()
	block_nodes.clear()
	timeline_log.clear()
	
	# Add initial code line
	_add_code_line("INITIAL", 0, 0)
	
	search_target = 0
	status_label.text = "Click 'Find Element' to start."
	
	current_idx = 0
	search_found = false
	comparison_counter = 0
	swap_counter = 0
	sorting_complete = false
	is_auto_playing = false
	
	for child in array_container.get_children():
		child.queue_free()
	
	var current_x = START_POSITION.x
	for val in main_array:
		var new_block = BLOCK_SCENE.instantiate()
		new_block.value = val
		new_block.position = Vector2(current_x, START_POSITION.y)
		
		if new_block.has_signal("block_dropped"):
			new_block.connect("block_dropped", _on_block_dropped)
		
		new_block.modulate.a = 0.0 
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(new_block, "modulate:a", 1.0, 0.5)
		
		array_container.add_child(new_block)
		block_nodes.append(new_block)
		current_x += new_block.size.x + BLOCK_SPACING
	
	_ensure_connected(sort_btn, "pressed", _on_step_pressed)
	_ensure_connected(auto_btn, "pressed", _on_auto_pressed)
	_ensure_connected(timeline_btn, "pressed", _on_timeline_pressed)
	_ensure_connected(simulate_new_btn, "pressed", _on_simulate_new_pressed)
	_ensure_connected(complete_ok_btn, "pressed", _on_complete_ok_pressed)
	_ensure_connected(show_cpp_btn, "pressed", _on_show_cpp_pressed)
	_ensure_connected(cpp_code_button, "pressed", _on_cpp_code_button_pressed)
	_ensure_connected(cpp_close_btn, "pressed", _on_cpp_close_pressed)
	
	if timeline_close_btn:
		if not timeline_close_btn.is_connected("pressed", _on_timeline_close_pressed):
			timeline_close_btn.pressed.connect(_on_timeline_close_pressed)

	_update_ui_labels()
	if cpp_code_button: cpp_code_button.hide()

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

# ==============================================
#   DRAG AND DROP LOGIC
# ==============================================

func _on_block_dropped(dropped_block: Control) -> void:
	if is_sorting or comparison_counter > 0:
		print("Cannot drag blocks while searching!")
		_resnap_blocks()
		return
		
	var children: Array = array_container.get_children()
	var old_index: int = block_nodes.find(dropped_block)
	var center_x: float = dropped_block.position.x + dropped_block.size.x * 0.5
	var insert_index: int = 0
	
	for c in block_nodes:
		if c == dropped_block: continue
		var c_center: float = c.position.x + c.size.x * 0.5
		if center_x > c_center:
			insert_index += 1
	
	if old_index != insert_index:
		var val = main_array.pop_at(old_index)
		main_array.insert(insert_index, val)
		block_nodes.remove_at(old_index)
		block_nodes.insert(insert_index, dropped_block)
		timeline_log.append("User moved %d from index %d to %d" % [val, old_index, insert_index])
		_add_code_line("MOVE", insert_index, val)
	
	_resnap_blocks()

func _resnap_blocks() -> void:
	var x = START_POSITION.x
	for i in range(block_nodes.size()):
		var node = block_nodes[i]
		var target_pos = Vector2(x, START_POSITION.y)
		create_tween().tween_property(node, "position", target_pos, ANIM_SPEED)
		x += node.size.x + BLOCK_SPACING

# ==============================================
#   LINEAR SEARCH LOGIC
# ==============================================

func _on_step_pressed() -> void:
	btn_sound.play()
	target_input_dialog.popup_centered()

func _on_auto_pressed() -> void:
	if is_sorting or sorting_complete or is_auto_playing: return
	if tutorial_in_progress: _handle_tutorial_step()
	btn_sound.play()
	_perform_sort_step()

func _perform_sort_step():
	is_sorting = true
	var n = main_array.size()
	
	if current_idx >= n:
		status_label.text = "Finished. Target NOT found."
		timeline_log.append("End of list. %d not found." % search_target)
		_add_code_line("NOT_FOUND", 0, search_target)
		_finish_simulation()
		is_sorting = false
		return
	
	_update_pointers(current_idx)
	
	if block_nodes[current_idx].has_method("set_highlight"):
		block_nodes[current_idx].set_highlight(true)
	
	comparison_counter += 1
	var val = main_array[current_idx]
	status_label.text = "Checking index %d: %d == %d?" % [current_idx, val, search_target]
	timeline_log.append("Checking index %d: Value %d" % [current_idx, val])
	_add_code_line("COMPARE", current_idx, val)
	
	await get_tree().create_timer(ANIM_SPEED * 0.5).timeout
	
	if val == search_target:
		search_found = true
		status_label.text = "FOUND %d at index %d!" % [val, current_idx]
		timeline_log.append(" -> FOUND MATCH!")
		_add_code_line("FOUND", current_idx, val)
		if block_nodes[current_idx].has_method("set_sorted_visual"):
			block_nodes[current_idx].set_sorted_visual()
		_finish_simulation()
	else:
		status_label.text = "Not a match. Moving on."
		if block_nodes[current_idx].has_method("set_highlight"):
			block_nodes[current_idx].set_highlight(false)
		current_idx += 1
	
	_update_ui_labels()
	is_sorting = false

func _update_pointers(idx: int):
	if block_nodes.is_empty(): return
	if ptr_left: ptr_left.show()
	if idx < block_nodes.size():
		var node = block_nodes[idx]
		if ptr_left:
			ptr_left.global_position = node.global_position + Vector2(16, node.size.y + 10) 

func _finish_simulation():
	sorting_complete = true
	is_auto_playing = false
	
	if auto_btn: auto_btn.disabled = true
	if sort_btn: sort_btn.disabled = true
	if auto_search_btn: 
		auto_search_btn.text = "Auto Search"
		auto_search_btn.disabled = true
	
	if ptr_left: ptr_left.hide()
	
	timeline_log.append("--- SEARCH COMPLETE ---")
	_show_complete_popup()
	
	if cpp_code_button:
		cpp_code_button.show()
		if code_anim: code_anim.play("default")
	
	# Show result popup

func _compute_grade() -> Dictionary:
	var passed = search_found
	var coins = 5 if passed else 0
	
	return {
		"passed": passed,
		"accuracy": 100.0 if passed else 0.0,
		"correct_moves": 1 if passed else 0,
		"bad_moves": comparison_counter,
		"time_used": 0,
		"coins": coins,
		"required": 60
	}

# ==============================================
#   UI & POPUPS
# ==============================================

func _update_ui_labels():
	compare_label.text = "Comparisons: %d" % [comparison_counter]

func _show_complete_popup() -> void:
	if complete_popup:
		var result_text = "Found" if search_found else "Not Found"
		var txt = "Search Finished!\n\nTarget: %d\nResult: %s\nComparisons: %d" % [search_target, result_text, comparison_counter]
		if process_label: process_label.text = txt
		complete_popup.popup_centered()

func _on_timeline_pressed() -> void:
	btn_sound.play()
	if timeline_popup.visible:
		timeline_popup.hide()
	else:
		timeline_label.text = "Timeline:\n" + "\n".join(timeline_log)
		timeline_popup.popup_centered()

func _on_timeline_close_pressed() -> void:
	btn_sound.play()
	if timeline_popup:
		timeline_popup.hide()

# ==============================================
#   CODE GENERATION
# ==============================================

func _add_code_line(op: String, index: int, value: int) -> void:
	code_lines.append("%s|%d|%d" % [op, index, value])

func _generate_code_for_language(lang: String) -> String:
	match lang:
		"python": return _gen_python_code()
		"java": return _gen_java_code()
		"c": return _gen_c_code()
		_: return _gen_cpp_code()

func _gen_cpp_code() -> String:
	var code = "/* Linear Search Simulation - Operations Log */\n"
	code += "#include <iostream>\nusing namespace std;\n\n"
	code += "void printArray(int arr[], int n) {\n"
	code += "    cout << \"[\";\n"
	code += "    for(int i = 0; i < n; i++) {\n"
	code += "        cout << arr[i];\n"
	code += "        if(i < n-1) cout << \", \";\n"
	code += "    }\n"
	code += "    cout << \"]\" << endl;\n"
	code += "}\n\n"
	code += "int linearSearch(int arr[], int n, int target) {\n"
	code += "    for(int i = 0; i < n; i++) {\n"
	code += "        cout << \"Checking index \" << i << \": \" << arr[i] << endl;\n"
	code += "        if(arr[i] == target) {\n"
	code += "            cout << \"Found target at index \" << i << \"!\" << endl;\n"
	code += "            return i;\n"
	code += "        }\n"
	code += "    }\n"
	code += "    cout << \"Target not found\" << endl;\n"
	code += "    return -1;\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    int arr[] = {%s};\n" % _array_to_string(main_array)
	code += "    int n = sizeof(arr)/sizeof(arr[0]);\n"
	code += "    int target = %d;\n\n" % search_target
	code += "    cout << \"Initial array: \";\n"
	code += "    printArray(arr, n);\n"
	code += "    cout << \"Searching for: \" << target << endl << endl;\n\n"
	code += "    int result = linearSearch(arr, n, target);\n\n"
	code += "    return 0;\n"
	code += "}\n"
	code += "/* Complexity: Time O(n) | Space O(1) */"
	return code

func _gen_python_code() -> String:
	var code = "# Linear Search Simulation - Operations Log\n\n"
	code += "def print_array(arr):\n"
	code += "    print('[', end='')\n"
	code += "    for i in range(len(arr)):\n"
	code += "        print(arr[i], end='')\n"
	code += "        if i < len(arr) - 1:\n"
	code += "            print(', ', end='')\n"
	code += "    print(']')\n\n"
	code += "def linear_search(arr, target):\n"
	code += "    for i in range(len(arr)):\n"
	code += "        print(f'Checking index {i}: {arr[i]}')\n"
	code += "        if arr[i] == target:\n"
	code += "            print(f'Found target at index {i}!')\n"
	code += "            return i\n"
	code += "    print('Target not found')\n"
	code += "    return -1\n\n"
	code += "arr = [%s]\n" % _array_to_string(main_array)
	code += "target = %d\n\n" % search_target
	code += "print('Initial array: ', end='')\n"
	code += "print_array(arr)\n"
	code += "print(f'Searching for: {target}\\n')\n"
	code += "linear_search(arr, target)\n"
	code += "''' Complexity: Time O(n) | Space O(1) '''"
	return code

func _gen_java_code() -> String:
	var code = "/* Linear Search Simulation - Operations Log */\n"
	code += "import java.util.*;\n\n"
	code += "public class LinearSearchSim {\n"
	code += "    public static void printArray(int[] arr) {\n"
	code += "        System.out.print(\"[\");\n"
	code += "        for(int i = 0; i < arr.length; i++) {\n"
	code += "            System.out.print(arr[i]);\n"
	code += "            if(i < arr.length-1) System.out.print(\", \");\n"
	code += "        }\n"
	code += "        System.out.println(\"]\");\n"
	code += "    }\n\n"
	code += "    public static int linearSearch(int[] arr, int target) {\n"
	code += "        for(int i = 0; i < arr.length; i++) {\n"
	code += "            System.out.println(\"Checking index \" + i + \": \" + arr[i]);\n"
	code += "            if(arr[i] == target) {\n"
	code += "                System.out.println(\"Found target at index \" + i + \"!\");\n"
	code += "                return i;\n"
	code += "            }\n"
	code += "        }\n"
	code += "        System.out.println(\"Target not found\");\n"
	code += "        return -1;\n"
	code += "    }\n\n"
	code += "    public static void main(String[] args) {\n"
	code += "        int[] arr = {%s};\n" % _array_to_string(main_array)
	code += "        int target = %d;\n\n" % search_target
	code += "        System.out.print(\"Initial array: \");\n"
	code += "        printArray(arr);\n"
	code += "        System.out.println(\"Searching for: \" + target + \"\\n\");\n"
	code += "        linearSearch(arr, target);\n"
	code += "    }\n"
	code += "}\n"
	code += "/* Complexity: Time O(n) | Space O(1) */"
	return code

func _gen_c_code() -> String:
	var code = "/* Linear Search Simulation - Operations Log */\n"
	code += "#include <stdio.h>\n\n"
	code += "void printArray(int arr[], int n) {\n"
	code += "    printf(\"[\");\n"
	code += "    for(int i = 0; i < n; i++) {\n"
	code += "        printf(\"%d\", arr[i]);\n"
	code += "        if(i < n-1) printf(\", \");\n"
	code += "    }\n"
	code += "    printf(\"]\\n\");\n"
	code += "}\n\n"
	code += "int linearSearch(int arr[], int n, int target) {\n"
	code += "    for(int i = 0; i < n; i++) {\n"
	code += "        printf(\"Checking index %d: %d\\n\", i, arr[i]);\n"
	code += "        if(arr[i] == target) {\n"
	code += "            printf(\"Found target at index %d!\\n\", i);\n"
	code += "            return i;\n"
	code += "        }\n"
	code += "    }\n"
	code += "    printf(\"Target not found\\n\");\n"
	code += "    return -1;\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    int arr[] = {%s};\n" % _array_to_string(main_array)
	code += "    int n = sizeof(arr)/sizeof(arr[0]);\n"
	code += "    int target = %d;\n\n" % search_target
	code += "    printf(\"Initial array: \");\n"
	code += "    printArray(arr, n);\n"
	code += "    printf(\"Searching for: %d\\n\\n\", target);\n"
	code += "    linearSearch(arr, n, target);\n"
	code += "    return 0;\n"
	code += "}\n"
	code += "/* Complexity: Time O(n) | Space O(1) */"
	return code

func _array_to_string(arr: Array) -> String:
	var parts: Array[String] = []
	for v in arr:
		parts.append(str(v))
	return ", ".join(parts)

# ==============================================
#   CODE GENERATION & TUTORIAL (LINEAR SEARCH)
# ==============================================

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	if complete_popup: complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

func _show_cpp_popup() -> void:
	var code = _generate_code_for_language(current_code_language)
	
	match current_code_language:
		"cpp":
			current_tutorial_data = cpp_tutorial_data
		"python":
			current_tutorial_data = python_tutorial_data
		"java":
			current_tutorial_data = java_tutorial_data
		"c":
			current_tutorial_data = c_tutorial_data
	
	if cpp_label:
		cpp_label.bbcode_enabled = true
		cpp_label.text = code
	
	cpp_popup.popup_centered()
	
	cpp_tutorial_step = 0
	if cpp_next_btn:
		if not cpp_next_btn.is_connected("pressed", _on_cpp_next_pressed):
			cpp_next_btn.pressed.connect(_on_cpp_next_pressed)
	_update_cpp_tutorial()

func _on_cpp_next_pressed() -> void:
	btn_sound.play()
	cpp_tutorial_step += 1
	if cpp_tutorial_step >= current_tutorial_data.size():
		cpp_tutorial_step = 0
	_update_cpp_tutorial()

func _update_cpp_tutorial() -> void:
	if current_tutorial_data.is_empty(): return
	var data = current_tutorial_data[cpp_tutorial_step]
	
	if cpp_explanation_lbl:
		cpp_explanation_lbl.bbcode_enabled = true
		cpp_explanation_lbl.text = data["text"]
	
	if cpp_label:
		var code = _generate_code_for_language(current_code_language)
		
		var lines = code.split("\n")
		var highlighted_code = ""
		var indices = data["lines"]
		
		for i in range(lines.size()):
			if i in indices:
				highlighted_code += "[color=yellow]" + lines[i] + "[/color]\n"
			else:
				highlighted_code += lines[i] + "\n"
		
		cpp_label.text = highlighted_code
		
		if cpp_scroll and indices.size() > 0:
			cpp_scroll.scroll_vertical = indices[0] * 25

func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()

# ==============================================
#   RESULT POPUP HANDLERS
# ==============================================

func _on_try_again_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_config_modal()

func _on_back_pressed() -> void:
	btn_sound.play()
	result_popup.hide()

func _show_result_popup(result: String, grade: Dictionary) -> void:
	if not result_popup:
		return
	
	if result == "PASS":
		result_title.text = "FOUND!"
		result_title.modulate = Color.GREEN
		if translate_code_btn:
			translate_code_btn.show()
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")
	else:
		result_title.text = "NOT FOUND"
		result_title.modulate = Color.RED
		if translate_code_btn:
			translate_code_btn.show()
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")
	
	score_summary.text = "Comparisons: %d" % grade.get("bad_moves", 0)
	accuracy_label.text = "Target: %d" % search_target
	time_used_label.text = "Array Size: %d" % main_array.size()
	coins_label.text = "+%d" % grade.get("coins", 0)
	
	result_popup.popup_centered()
	
	if grade.get("coins", 0) > 0 and coins_anim:
		coins_anim.play("default")

func show_feedback(text: String, color: Color, position: Vector2):
	var feedback_scene = preload("res://scene/FeedbackLabel.tscn")
	var label = feedback_scene.instantiate()
	label.text = text
	label.modulate = color
	label.global_position = position
	add_child(label)
	
	var anim_player: AnimationPlayer = label.get_node("AnimationPlayer")
	anim_player.play("notification_pop")
	anim_player.animation_finished.connect(func(_a): label.queue_free())

# ==============================================
#   CONFIG HANDLERS
# ==============================================

func _connect_configuration_buttons() -> void:
	_ensure_connected(yes_btn, "pressed", _on_config_yes_pressed)
	_ensure_connected(no_btn, "pressed", _on_config_no_pressed)
	_ensure_connected(size_back_btn, "pressed", _on_size_back_pressed)
	_ensure_connected(size_next_btn, "pressed", _on_size_next_pressed)
	_ensure_connected(elements_back_btn, "pressed", _on_elements_back_pressed)
	_ensure_connected(elements_done_btn, "pressed", _on_elements_done_pressed)

func _show_config_modal() -> void:
	config_modal.show()
	_set_main_ui_enabled(false)

func _on_config_yes_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	_show_config_size_modal()

func _show_config_size_modal() -> void:
	config_size_modal.show()

func _on_size_next_pressed() -> void:
	btn_sound.play()
	var size = int(size_input.value)
	if size > 10: 
		if Queue_full:
			Queue_full.show()
			if anim_sprite: anim_sprite.play("default")
			await get_tree().create_timer(2.0).timeout
			Queue_full.hide()
		return
	config_size_modal.hide()
	_show_config_elements_modal()

func _show_config_elements_modal() -> void:
	var array_size = int(size_input.value)
	
	element_inputs.clear()
	for child in elements_container.get_children():
		child.queue_free()

	var grid = GridContainer.new()
	grid.columns = min(5, array_size)
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	elements_container.add_child(grid)
	
	for i in range(array_size):
		var element_box = VBoxContainer.new()
		
		# Create label
		var label = Label.new()
		label.text = "Value %d" % (i + 1)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		# Create input
		var line_edit = LineEdit.new()
		line_edit.placeholder_text = "0-999"
		line_edit.text = str(randi_range(1, 99))
		line_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
		line_edit.max_length = 3
		line_edit.custom_minimum_size = Vector2(80, 80)

		line_edit.text_changed.connect(_on_input_text_changed.bind(line_edit))
		
		element_box.add_child(label)
		element_box.add_child(line_edit)
		grid.add_child(element_box)
		
		element_inputs.append(line_edit)
	
	config_elements_modal.show()

func _on_input_text_changed(new_text: String, line_edit: LineEdit) -> void:
	if not new_text.is_valid_int() and new_text != "":
		line_edit.text = new_text.trim_suffix(new_text[-1])
		line_edit.set_caret_column(line_edit.text.length())

func _on_elements_done_pressed() -> void:
	btn_sound.play()
	var arr: Array[int] = []
	for le in element_inputs:
		var val = int(le.text) if le.text.is_valid_int() else int(le.placeholder_text)
		arr.append(val)
	config_elements_modal.hide()
	_set_main_ui_enabled(true)
	_initialize_with_elements(arr)

func _on_config_no_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	var count = randi_range(5, 7)
	var arr: Array[int] = []
	for i in count: arr.append(randi_range(1, 99))
	_set_main_ui_enabled(true)
	_initialize_with_elements(arr)

func _on_size_back_pressed(): config_size_modal.hide(); config_modal.show()
func _on_elements_back_pressed(): config_elements_modal.hide(); config_size_modal.show()

# ==============================================
#   INTRO LOGIC & TUTORIAL (CRITICAL)
# ==============================================

func show_introduction():
	if tutorial_overlay: tutorial_overlay.show()
	if not intro_popup: return
	intro_popup.show()
	_set_main_ui_enabled(false)
	intro_step = 0
	_update_intro_text()
	_ensure_connected(intro_prev_btn, "pressed", _on_intro_prev_pressed)
	_ensure_connected(intro_next_btn, "pressed", _on_intro_next_pressed)
	_ensure_connected(intro_skip_btn, "pressed", _on_intro_skip_pressed)

func _update_intro_text():
	if intro_label and intro_texts.size() > 0:
		intro_label.text = intro_texts[intro_step]
	if intro_prev_btn:
		intro_prev_btn.visible = (intro_step > 0)
	if intro_next_btn:
		intro_next_btn.text = "Finish" if intro_step >= intro_texts.size() - 1 else "Next"

func _on_intro_next_pressed():
	btn_sound.play()
	if intro_step < intro_texts.size() - 1:
		intro_step += 1
		_update_intro_text()
	else:
		intro_popup.hide()
		_set_main_ui_enabled(true)

func _on_intro_prev_pressed():
	btn_sound.play()
	if intro_step > 0:
		intro_step -= 1
		_update_intro_text()

func _on_intro_skip_pressed():
	btn_sound.play()
	intro_popup.hide()
	_set_main_ui_enabled(true)

# --- TUTORIAL MAIN ---

func start_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	tutorial_overlay.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{
			"node": sort_btn,
			"title": "FIND ELEMENT",
			"text": "Opens a popup to set the Target value you want to search for.",
			"action": "highlight"
		},
		{
			"node": auto_btn,
			"title": "LINEAR STEP",
			"text": "Executes one comparison step (Is current == target?).",
			"action": "highlight"
		},
		{
			"node": auto_search_btn,
			"title": "AUTO SEARCH",
			"text": "Starts/Pauses automatic searching.",
			"action": "highlight"
		},
		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View a scrollable history of comparisons.",
			"action": "highlight"
		},
		{
			"node": simulate_new_btn,
			"title": "SIMULATE NEW",
			"text": "Resets the simulation to enter new numbers.",
			"action": "highlight"
		}
	]
	show_tutorial_step()

func show_tutorial_step() -> void:
	if tutorial_sequence_index >= tutorial_sequence.size():
		end_tutorial()
		return
		
	var step = tutorial_sequence[tutorial_sequence_index]
	tutorial_text.text = step["title"] + "\n\n" + step["text"]
	
	var node = step["node"]
	
	if node and pointer_sprite:
		pointer_sprite.texture = POINTER_TEX
		pointer_sprite.show()
		
		var pos_x = node.global_position.x + node.size.x + 30 
		var pos_y = node.global_position.y + (node.size.y / 2)
		pointer_sprite.global_position = Vector2(pos_x, pos_y)
		pointer_sprite.z_index = 100 
		
		if pointer_sprite.has_meta("tween"):
			pointer_sprite.get_meta("tween").kill()
		
		var tween = create_tween().set_loops()
		pointer_sprite.set_meta("tween", tween)
		pointer_sprite.offset = Vector2.ZERO
		tween.tween_property(pointer_sprite, "offset:x", -10.0, 0.5).set_trans(Tween.TRANS_SINE)
		tween.tween_property(pointer_sprite, "offset:x", 0.0, 0.5).set_trans(Tween.TRANS_SINE)
	else:
		if pointer_sprite: pointer_sprite.hide()
	
	if step["action"] == "press":
		tutorial_next.hide()
		if node: node.disabled = false
	else:
		tutorial_next.show()

func _handle_tutorial_step():
	var step = tutorial_sequence[tutorial_sequence_index]
	if step["node"] == sort_btn:
		tutorial_sequence_index += 1
		show_tutorial_step()

func _on_next_button_pressed():
	tutorial_sequence_index += 1
	show_tutorial_step()

func end_tutorial():
	tutorial_in_progress = false
	tutorial_overlay.hide()
	if pointer_sprite:
		pointer_sprite.hide()
		if pointer_sprite.has_meta("tween"):
			pointer_sprite.get_meta("tween").kill()

# ==============================================
#   HELPER / UTILS
# ==============================================

func _set_main_ui_enabled(enabled: bool) -> void:
	if sort_btn: sort_btn.disabled = not enabled
	if auto_btn: auto_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled
	if simulate_new_btn: simulate_new_btn.disabled = not enabled
	if auto_search_btn: auto_search_btn.disabled = not enabled

func _on_cpp_close_pressed(): btn_sound.play(); cpp_popup.hide()
func _on_cpp_code_button_pressed(): btn_sound.play(); _show_cpp_popup()
func _on_complete_ok_pressed(): btn_sound.play(); complete_popup.hide()

func _on_simulate_new_pressed():
	sim_confirmation.show()

func _on_yes_pressed():
	sim_confirmation.hide()
	sim_success.show()
	await get_tree().create_timer(1.0).timeout
	sim_success.hide()
	_show_config_modal()

func _on_no_pressed():
	sim_confirmation.hide()

func _on_help_button_pressed():
	start_tutorial()

# ==============================================
#  CUSTOM THEME STYLING FOR ALL UI ELEMENTS
# ==============================================

func _apply_global_styles() -> void:
	var my_font = load("res://assets/font/Planes_ValMore.ttf") 

func _style_panel(panel_node: Node) -> void:
	if not panel_node: return
	
	var texture_style = StyleBoxTexture.new()
	texture_style.texture = load("res://assets/containers/CONTAINER.png")
	# 9-slice margins to keep container borders from stretching
	texture_style.texture_margin_left = 12
	texture_style.texture_margin_right = 12
	texture_style.texture_margin_top = 12
	texture_style.texture_margin_bottom = 12
	
	if panel_node.has_method("add_theme_stylebox_override"):
		panel_node.add_theme_stylebox_override("panel", texture_style)

func _style_button(btn: Button, font: Font) -> void:
	if not btn: return
	
	var btn_tex = StyleBoxTexture.new()
	btn_tex.texture = load("res://assets/BUTTON.png")
	btn_tex.texture_margin_left = 6
	btn_tex.texture_margin_right = 6
	btn_tex.texture_margin_top = 6
	btn_tex.texture_margin_bottom = 6
	
	var btn_hover = btn_tex.duplicate()
	btn_hover.modulate_color = Color(0.8, 0.8, 0.8, 1.0) 
	
	var btn_pressed = btn_tex.duplicate()
	btn_pressed.modulate_color = Color(0.6, 0.6, 0.6, 1.0)
	
	btn.add_theme_stylebox_override("normal", btn_tex)
	btn.add_theme_stylebox_override("hover", btn_hover)
	btn.add_theme_stylebox_override("pressed", btn_pressed)
	
	var empty_style = StyleBoxEmpty.new()
	btn.add_theme_stylebox_override("focus", empty_style)
	
	if font:
		btn.add_theme_font_override("font", font)
