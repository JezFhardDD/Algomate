extends Control

# =======================================================
#   DFS SIMULATION - FINAL (Iterative Stack Logic)
# =======================================================

# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton
@onready var auto_btn: Button = $VBoxContainer/WaitingElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var compare_label: Label = $HBoxContainer2/Label

# --- CONTAINER FIX ---
@onready var array_container: Control = $TreeContainer
@onready var dequeued_container: Control = $DequeuedContainer 

# --- POPUPS ---
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label

# --- TIMELINE POPUP ---
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: Label = $TimelinePopup/MainVBox/ScrollContainer/VBoxContainer/Label
@onready var timeline_close_btn: Button = get_node_or_null("TimelinePopup/MainVBox/CloseButton")

# Queue Full Warning (Kept variable name for compatibility, conceptually 'Stack Full')
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
const BLOCK_SCENE := preload("res://TreeNode.tscn")
const POINTER_TEX := preload("res://assets/point_left.png")
const RESULT_POPUP_SCENE := preload("res://scene/ResultPopup.tscn")

# --- POINTERS (Hidden for Tree) ---
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

# --- DFS VARIABLES ---
var main_array: Array[int] = []
var tree_nodes: Array = [] # Stores Node Instances (or null)
var timeline_log: Array[String] = []
var node_positions: Array = []

# DFS State
var dfs_stack: Array[int] = [] # Stack of INDICES
var visited: Array[int] = []
var target_value: int = -1
var search_found: bool = false
var is_searching: bool = false

var comparison_counter: int = 0
var sorting_complete: bool = false
var is_sorting: bool = false
var is_auto_playing: bool = false
var ANIM_SPEED: float = 1.0 

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

# --- INPUT DIALOGS ---
var target_input_dialog: ConfirmationDialog
var target_spinbox: SpinBox

# New: Dialog for editing nodes
var node_input_dialog: ConfirmationDialog
var node_spinbox: SpinBox
var current_editing_index: int = -1

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

# --- INTRO TEXT (DFS WITH COMPLEXITY) ---
var intro_step: int = 0
var intro_texts = [
	"Welcome to DFS Tree Search!\nDepth-First Search (DFS) explores as deep as possible along each branch before backtracking.",
	"INSTRUCTIONS:\n\n1. SETUP: Enter the Tree Size.\n2. INPUT: Type initial numbers or leave blank.\n3. EDIT: Click on any node to change it later.",
	"The Algorithm:\n\n1. Start at the Root.\n2. Check if it matches the Target.\n3. Push children to a Stack (Right then Left).\n4. Pop (LIFO) and repeat.",
	"Complexity Analysis:\n\n• Time: [color=yellow]O(V + E)[/color] - Explores all Vertices and Edges.\n• Space: [color=green]O(V)[/color] - Stack stores up to V nodes.",
	"Visual Elements:\n\n• The STACK stores nodes waiting to be checked.\n• Orange nodes are being processed.\n• Green node means TARGET FOUND."
]

# --- CODE TUTORIAL DATA (DFS MULTI-LANGUAGE) ---
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = [] 

# 1. C++ DATA
var cpp_tutorial_data = [
	{ "lines": [0, 1, 2, 3], "text": "1. Imports & Setup:\nIncludes standard Stack library." },
	{ "lines": [5, 6, 7, 8, 9], "text": "2. Complexity Analysis:\n[color=yellow]Time: O(V + E)[/color] and [color=green]Space: O(V)[/color]." },
	{ "lines": [10, 11, 12], "text": "3. Initialization:\nCreate a Stack and push the root index (0)." },
	{ "lines": [14, 15, 16], "text": "4. The Loop:\nWhile stack isn't empty, pop the top element." },
	{ "lines": [18, 19], "text": "5. Check Target:\nIf current node matches target, return TRUE." },
	{ "lines": [21, 22, 23], "text": "6. Push Children:\nPush Right then Left child so Left is processed next (LIFO)." }
]

# 2. PYTHON DATA
var python_tutorial_data = [
	{ "lines": [0], "text": "1. Function:\nDefine DFS taking tree list and target." },
	{ "lines": [1], "text": "2. Complexity:\n[color=yellow]Time: O(V + E)[/color] | [color=green]Space: O(V)[/color]." },
	{ "lines": [2], "text": "3. Initialization:\nStart stack with root index 0." },
	{ "lines": [4, 5], "text": "4. Processing:\nPop the last element (LIFO) from stack." },
	{ "lines": [6, 7, 8, 9], "text": "5. Target Check:\nSkip invalid nodes, return True if found." },
	{ "lines": [11, 12, 13], "text": "6. Push Children:\nAppend Right then Left so Left is popped first." }
]

# 3. JAVA DATA
var java_tutorial_data = [
	{ "lines": [0], "text": "1. Imports:\nImport java.util.Stack." },
	{ "lines": [3, 4, 5, 6], "text": "2. Complexity:\n[color=yellow]Time: O(V + E)[/color] | [color=green]Space: O(V)[/color]." },
	{ "lines": [7, 8, 9], "text": "3. Initialization:\nCreate Stack and push root." },
	{ "lines": [11, 12], "text": "4. Dequeue:\nPop the top element." },
	{ "lines": [14, 15], "text": "5. Target Check:\nReturn true if target is found." },
	{ "lines": [17, 18], "text": "6. Push Children:\nPush Right then Left child indices." }
]

# 4. C DATA
var c_tutorial_data = [
	{ "lines": [2], "text": "1. Complexity:\n[color=yellow]Time: O(V + E)[/color] | [color=green]Space: O(V)[/color]." },
	{ "lines": [3, 4, 5, 6], "text": "2. Stack Setup:\nArray-based stack implementation." },
	{ "lines": [8, 9], "text": "3. Initialization:\nPush root index (0) to start." },
	{ "lines": [10, 11, 12, 13], "text": "4. Pop & Check:\nPop top node and check if it matches target." },
	{ "lines": [15, 16], "text": "5. Push Children:\nPush right child, then left child." }
]

# ==============================================
#   READY
# ==============================================
func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	print("Program started — initializing DFS visualizer...")
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
	
	_define_tree_positions()
	
	# --- FIX: FORCE CONTAINERS TO IGNORE MOUSE ---
	if dequeued_container: dequeued_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if array_container: array_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tex_rect = get_node_or_null("TextureRect")
	if tex_rect: tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if unused_ptr1: unused_ptr1.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	if cpp_code_button: cpp_code_button.hide()
	
	if sort_btn: sort_btn.text = "Find Element"
	if auto_btn: auto_btn.text = "DFS STEP"
	
	_create_target_input_dialog() 
	_create_node_input_dialog() 
	
	_connect_configuration_buttons()
	
	# Setup compiler
	_setup_compiler()
	
	_show_config_modal() 
	
	if size_input:
		size_input.min_value = 5
		size_input.max_value = 7
		size_input.value = 5 
	
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
	
	print("=== DFS Compile Request ===")
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

func _create_target_input_dialog():
	var my_font = load("res://assets/font/Planes_ValMore.ttf") 
	
	target_input_dialog = ConfirmationDialog.new()
	target_input_dialog.title = "Find Element"
	target_input_dialog.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	target_input_dialog.min_size = Vector2(450, 220) 
	if my_font: target_input_dialog.add_theme_font_override("title_font", my_font)
	target_input_dialog.add_theme_font_size_override("title_font_size", 24)
	
	var ok_btn = target_input_dialog.get_ok_button()
	var cancel_btn = target_input_dialog.get_cancel_button()
	ok_btn.text = "Search"
	for btn in [ok_btn, cancel_btn]:
		btn.custom_minimum_size = Vector2(140, 50)
		if my_font: btn.add_theme_font_override("font", my_font)
		btn.add_theme_font_size_override("font_size", 22)
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	var margin_container = MarginContainer.new()
	margin_container.add_theme_constant_override("margin_top", 20)
	margin_container.add_theme_constant_override("margin_left", 30)
	margin_container.add_theme_constant_override("margin_right", 30)
	margin_container.add_theme_constant_override("margin_bottom", 20)
	target_input_dialog.add_child(margin_container)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	margin_container.add_child(vbox)

	var lbl = Label.new()
	lbl.text = "Enter value to search:"
	if my_font: lbl.add_theme_font_override("font", my_font)
	lbl.add_theme_font_size_override("font_size", 26)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(lbl)

	target_spinbox = SpinBox.new()
	target_spinbox.min_value = 0
	target_spinbox.max_value = 999
	target_spinbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(target_spinbox)

	var line_edit = target_spinbox.get_line_edit()
	line_edit.custom_minimum_size = Vector2(0, 60)
	if my_font: line_edit.add_theme_font_override("font", my_font)
	line_edit.add_theme_font_size_override("font_size", 30)
	
	line_edit.max_length = 3
	line_edit.text_changed.connect(_on_dialog_input_changed.bind(line_edit))
	
	line_edit.text_submitted.connect(func(_text): 
		_on_target_confirmed()
		target_input_dialog.hide()
	)

	add_child(target_input_dialog)
	target_input_dialog.confirmed.connect(_on_target_confirmed)

func _on_dialog_input_changed(new_text: String, line_edit: LineEdit) -> void:
	if not new_text.is_empty() and not new_text.is_valid_int():
		var filtered_text = ""
		for char in new_text:

			if char >= "0" and char <= "9":
				filtered_text += char
		
		line_edit.text = filtered_text
		line_edit.caret_column = filtered_text.length()

func _create_node_input_dialog():
	var my_font = load("res://assets/font/Planes_ValMore.ttf") 
	

	node_input_dialog = ConfirmationDialog.new()
	node_input_dialog.title = "Edit Node"
	node_input_dialog.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	node_input_dialog.min_size = Vector2(450, 220) 
	if my_font: node_input_dialog.add_theme_font_override("title_font", my_font)
	node_input_dialog.add_theme_font_size_override("title_font_size", 24)
	
	var ok_btn = node_input_dialog.get_ok_button()
	var cancel_btn = node_input_dialog.get_cancel_button()
	ok_btn.text = "Update"
	for btn in [ok_btn, cancel_btn]:
		btn.custom_minimum_size = Vector2(140, 50)
		if my_font: btn.add_theme_font_override("font", my_font)
		btn.add_theme_font_size_override("font_size", 22)
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	var margin_container = MarginContainer.new()
	margin_container.add_theme_constant_override("margin_top", 20)
	margin_container.add_theme_constant_override("margin_left", 30)
	margin_container.add_theme_constant_override("margin_right", 30)
	margin_container.add_theme_constant_override("margin_bottom", 20)
	node_input_dialog.add_child(margin_container)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	margin_container.add_child(vbox)

	var lbl = Label.new()
	lbl.text = "Set new value :"
	if my_font: lbl.add_theme_font_override("font", my_font)
	lbl.add_theme_font_size_override("font_size", 26)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(lbl)

	node_spinbox = SpinBox.new()
	node_spinbox.min_value = 0
	node_spinbox.max_value = 999
	node_spinbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(node_spinbox)

	var line_edit = node_spinbox.get_line_edit()
	line_edit.custom_minimum_size = Vector2(0, 60)
	if my_font: line_edit.add_theme_font_override("font", my_font)
	line_edit.add_theme_font_size_override("font_size", 30)
	
	line_edit.max_length = 3
	line_edit.text_changed.connect(_on_dialog_input_changed.bind(line_edit))
	
	line_edit.text_submitted.connect(func(_text): 
		_on_node_value_confirmed()
		node_input_dialog.hide()
	)

	add_child(node_input_dialog)
	node_input_dialog.confirmed.connect(_on_node_value_confirmed)

func _on_target_confirmed():
	btn_sound.play()
	var new_target = int(target_spinbox.value)
	_reset_search_for_new_target(new_target)

func _on_node_value_confirmed():
	btn_sound.play()
	if current_editing_index != -1 and current_editing_index < main_array.size():
		var val = int(node_spinbox.value)
		main_array[current_editing_index] = val
		
		# Add code line for node edit
		_add_code_line("EDIT", current_editing_index, val)
		
		var node = tree_nodes[current_editing_index]
		if node:
			if val != 0:
				node.set_value(val)
				node.modulate = Color(1, 1, 1, 1) 
			else:
				node.set_value(0)
				node.modulate = Color(0.5, 0.5, 0.5, 0.5)
		
		if current_editing_index == 0 and val != 0:
			if node.has_method("mark_processing"):
				node.mark_processing()
				
		status_label.text = "Node %d set to %d." % [current_editing_index, val]

func _reset_search_for_new_target(new_val: int):
	target_value = new_val
	status_label.text = "Target: %d" % target_value
	compare_label.text = "Stack: [Root]"
	
	dfs_stack.clear()
	dfs_stack.append(0)
	visited.clear()
	timeline_log.clear()
	timeline_log.append("New Search Started. Target: " + str(target_value))
	
	# Add code line for target
	_add_code_line("TARGET", 0, target_value)
	
	sorting_complete = false
	is_sorting = false
	is_auto_playing = false
	auto_btn.disabled = false
	auto_btn.text = "DFS STEP"
	sort_btn.disabled = false
	
	for i in range(tree_nodes.size()):
		if tree_nodes[i] != null:
			tree_nodes[i].reset_color()
			tree_nodes[i].scale = Vector2(1, 1)
			
	if tree_nodes[0] != null and main_array[0] != 0:
		tree_nodes[0].mark_processing()

func _connect_language_buttons():
	if cpp_lang_btn: cpp_lang_btn.pressed.connect(func(): _set_language("cpp"))
	if python_lang_btn: python_lang_btn.pressed.connect(func(): _set_language("python"))
	if java_lang_btn: java_lang_btn.pressed.connect(func(): _set_language("java"))
	if c_lang_btn: c_lang_btn.pressed.connect(func(): _set_language("c"))

func _set_language(lang: String):
	btn_sound.play()
	current_code_language = lang
	_show_cpp_popup()

# --- TREE LAYOUT LOGIC ---
func _define_tree_positions():
	node_positions.clear()
	var screen_width = 1152.0
	var ui_offset = 280.0
	var available_width = screen_width - ui_offset
	var start_y = 60       
	var layer_height = 140 
	
	for i in range(7):
		var layer = floor(log(i + 1) / log(2))
		var nodes_in_this_layer = pow(2, layer)
		var index_in_layer = (i + 1) - nodes_in_this_layer
		var slice_width = available_width / (nodes_in_this_layer + 1)
		var pos_x = ui_offset + (slice_width * (index_in_layer + 1))
		pos_x -= 32 
		var pos_y = start_y + (layer * layer_height)
		node_positions.append(Vector2(pos_x, pos_y))

# ==============================================
#   INITIALIZATION
# ==============================================

func _initialize_with_elements(elements: Array[int]) -> void:
	# Reset cache for new simulation
	reset_cache_for_scene()
	
	# Clear code lines
	code_lines.clear()
	
	print("Initializing Tree with:", elements)
	audio_player.play()
	
	main_array = elements.duplicate()
	if main_array.size() > 7: main_array.resize(7)
	
	tree_nodes.clear()
	tree_nodes.resize(7)
	tree_nodes.fill(null)
	
	timeline_log.clear()
	code_lines.clear()
	
	# Add initial code line
	_add_code_line("INITIAL", 0, 0)
	
	dfs_stack.clear()
	visited.clear()
	is_searching = false
	search_found = false
	comparison_counter = 0
	sorting_complete = false
	
	target_value = 0 
	status_label.text = "Click Nodes to Add Numbers!"
	compare_label.text = "Stack: [Root]"
	
	for child in array_container.get_children():
		child.queue_free()
	
	for i in range(7):
		if i < elements.size():
			var node = BLOCK_SCENE.instantiate()
			array_container.add_child(node)
			node.position = node_positions[i]
			
			# --- INVISIBLE BUTTON OVERLAY ---
			var click_btn = Button.new()
			click_btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			click_btn.modulate.a = 0.0 # Invisible
			click_btn.mouse_filter = Control.MOUSE_FILTER_STOP
			click_btn.pressed.connect(_handle_node_click.bind(i))
			node.add_child(click_btn)
			
			node.custom_minimum_size = Vector2(64, 64)
			node.size = Vector2(64, 64)
			
			if node.has_method("set_value"):
				if main_array[i] != 0:
					node.set_value(main_array[i])
					node.modulate = Color(1, 1, 1, 1)
				else:
					node.set_value(0) 
					node.modulate = Color(0.5, 0.5, 0.5, 0.5) 
			
			tree_nodes[i] = node
		else:
			tree_nodes[i] = null
			
	queue_redraw()
	
	dfs_stack.append(0)
	if tree_nodes[0] != null and main_array[0] != 0:
		if tree_nodes[0].has_method("mark_processing"):
			tree_nodes[0].mark_processing()
	
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

	if cpp_code_button: cpp_code_button.hide()

# --- HANDLE NODE CLICKS ---
func _handle_node_click(index: int):
	if is_sorting or sorting_complete:
		status_label.text = "Reset Simulation to edit nodes!"
		return

	# Validation
	if index > 0:
		var parent_idx = (index - 1) / 2
		var parent_val = main_array[parent_idx]
		if parent_val == 0:
			status_label.text = "⚠ Parent is empty! Fill parent node first."
			return
	
	current_editing_index = index
	node_spinbox.value = main_array[index]
	node_input_dialog.popup_centered()

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

func _draw():
	if tree_nodes.is_empty(): return
	var center_offset = Vector2(32, 32)
	var my_global_pos = get_global_position()
	
	for i in range(tree_nodes.size()):
		var current_node = tree_nodes[i]
		if current_node == null: continue
		var start_pos = (current_node.global_position + center_offset) - my_global_pos
		var left = 2*i + 1
		var right = 2*i + 2
		
		if left < 7 and tree_nodes[left] != null:
			var left_node = tree_nodes[left]
			var end_pos = (left_node.global_position + center_offset) - my_global_pos
			draw_line(start_pos, end_pos, Color.WHITE, 4.0)
			
		if right < 7 and tree_nodes[right] != null:
			var right_node = tree_nodes[right]
			var end_pos = (right_node.global_position + center_offset) - my_global_pos
			draw_line(start_pos, end_pos, Color.WHITE, 4.0)

# ==============================================
#   DFS LOGIC
# ==============================================

func _on_step_pressed() -> void:
	btn_sound.play()
	target_input_dialog.popup_centered()

func _on_auto_pressed() -> void:
	if sorting_complete: return
	btn_sound.play()
	_perform_dfs_step()

func _perform_dfs_step():
	is_sorting = true
	
	if dfs_stack.is_empty():
		status_label.text = "Stack Empty. Not Found."
		_finish_simulation(false)
		is_sorting = false
		return

	# --- DFS LOGIC: POP BACK (Stack) ---
	var curr_idx = dfs_stack.pop_back()
	
	if tree_nodes[curr_idx] == null or main_array[curr_idx] == 0:
		is_sorting = false
		_perform_dfs_step() 
		return

	var node = tree_nodes[curr_idx]
	var val = main_array[curr_idx]
	
	var tw = create_tween()
	tw.tween_property(node, "scale", Vector2(1.2, 1.2), 0.1)
	tw.tween_property(node, "scale", Vector2(1.0, 1.0), 0.1)
	
	status_label.text = "Checking Node %d (Val: %d)" % [curr_idx, val]
	timeline_log.append("Popped %d (Val: %d)" % [curr_idx, val])
	_add_code_line("POP", curr_idx, val)
	
	await get_tree().create_timer(ANIM_SPEED * 0.5).timeout
	
	if val == target_value:
		if node.has_method("mark_found"): node.mark_found()
		status_label.text = "TARGET FOUND!"
		timeline_log.append("-> FOUND MATCH!")
		_add_code_line("FOUND", curr_idx, val)
		_finish_simulation(true)
	else:
		if node.has_method("mark_visited"): node.mark_visited()
		
		var left = 2*curr_idx + 1
		var right = 2*curr_idx + 2
		var added = ""
		
		# --- DFS LOGIC: PUSH RIGHT THEN LEFT ---
		# We push Right first, then Left.
		# Because Stack is LIFO, Left will be on top and popped next.
		
		if right < 7 and tree_nodes[right] != null and main_array[right] != 0:
			dfs_stack.append(right)
			_add_code_line("PUSH", right, main_array[right])
			if tree_nodes[right].has_method("mark_processing"): tree_nodes[right].mark_processing()
			added += "R "
			
		if left < 7 and tree_nodes[left] != null and main_array[left] != 0:
			dfs_stack.append(left)
			_add_code_line("PUSH", left, main_array[left])
			if tree_nodes[left].has_method("mark_processing"): tree_nodes[left].mark_processing()
			added += "L "
			
		if added != "": timeline_log.append("Pushed: " + added)
	
	var q_str = ""
	for i in dfs_stack: q_str += str(main_array[i]) + " "
	compare_label.text = "Stack: [ " + q_str + "]"
	
	is_sorting = false

func _finish_simulation(found: bool):
	sorting_complete = true
	is_auto_playing = false
	auto_btn.text = "DFS STEP"
	auto_btn.disabled = true
	sort_btn.disabled = false
	
	var txt = "Target Found!" if found else "Target Not Found."
	process_label.text = txt
	complete_popup.popup_centered()
	if cpp_code_button: cpp_code_button.show()
	if code_anim: code_anim.play("default")

# ==============================================
#   UI & POPUPS
# ==============================================

func _show_complete_popup() -> void:
	complete_popup.popup_centered()

func _on_timeline_pressed() -> void:
	btn_sound.play()
	if timeline_popup.visible:
		timeline_popup.hide()
	else:
		timeline_label.text = "Log:\n" + "\n".join(timeline_log)
		timeline_popup.popup_centered()

func _on_timeline_close_pressed() -> void:
	btn_sound.play()
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
	var code = "/* DFS Tree Search Simulation - Operations Log */\n"
	code += "#include <iostream>\n#include <stack>\nusing namespace std;\n\n"
	code += "void printTree(int tree[], int size) {\n"
	code += "    cout << \"Tree values: [\";\n"
	code += "    for(int i = 0; i < size; i++) {\n"
	code += "        cout << tree[i];\n"
	code += "        if(i < size-1) cout << \", \";\n"
	code += "    }\n"
	code += "    cout << \"]\" << endl;\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    int tree[7] = {"
	
	# Add tree values
	for i in range(7):
		if i < main_array.size() and tree_nodes[i] != null:
			code += str(main_array[i])
		else:
			code += "-1"
		if i < 6:
			code += ", "
	code += "};\n"
	code += "    int target = %d;\n" % target_value
	code += "    int size = %d;\n\n" % main_array.size()
	code += "    cout << \"Initial tree: \";\n"
	code += "    printTree(tree, size);\n"
	code += "    cout << \"Searching for target: \" << target << endl;\n\n"
	
	# DFS Implementation
	code += "    // DFS Implementation\n"
	code += "    stack<int> s;\n"
	code += "    bool visited[7] = {false};\n"
	code += "    s.push(0);\n"
	code += "    visited[0] = true;\n\n"
	code += "    while(!s.empty()) {\n"
	code += "        int curr = s.top();\n"
	code += "        s.pop();\n"
	code += "        cout << \"Visiting node \" << curr << \": \" << tree[curr] << endl;\n"
	code += "        \n"
	code += "        if(tree[curr] == target) {\n"
	code += "            cout << \"Found target at node \" << curr << \"!\" << endl;\n"
	code += "            break;\n"
	code += "        }\n"
	code += "        \n"
	code += "        // Push right then left for DFS order\n"
	code += "        int right = 2*curr + 2;\n"
	code += "        int left = 2*curr + 1;\n"
	code += "        \n"
	code += "        if(right < size && tree[right] != -1 && !visited[right]) {\n"
	code += "            s.push(right);\n"
	code += "            visited[right] = true;\n"
	code += "        }\n"
	code += "        if(left < size && tree[left] != -1 && !visited[left]) {\n"
	code += "            s.push(left);\n"
	code += "            visited[left] = true;\n"
	code += "        }\n"
	code += "    }\n\n"
	
	code += "    return 0;\n"
	code += "}\n"
	code += "/* Complexity: Time O(V+E) | Space O(V) */"
	return code

func _gen_python_code() -> String:
	var code = "# DFS Tree Search Simulation - Operations Log\n\n"
	code += "def print_tree(tree):\n"
	code += "    print('Tree values:', [x for x in tree if x != -1])\n\n"
	code += "tree = ["
	
	# Add tree values
	for i in range(7):
		if i < main_array.size() and tree_nodes[i] != null:
			code += str(main_array[i])
		else:
			code += "-1"
		if i < 6:
			code += ", "
	code += "]\n"
	code += "target = %d\n" % target_value
	code += "size = %d\n\n" % main_array.size()
	code += "print('Initial tree: ', end='')\n"
	code += "print_tree(tree)\n"
	code += "print(f'Searching for target: {target}')\n\n"
	
	# DFS Implementation
	code += "# DFS Implementation\n"
	code += "stack = [0]\n"
	code += "visited = [False] * 7\n"
	code += "visited[0] = True\n\n"
	code += "while stack:\n"
	code += "    curr = stack.pop()\n"
	code += "    print(f'Visiting node {curr}: {tree[curr]}')\n"
	code += "    \n"
	code += "    if tree[curr] == target:\n"
	code += "        print(f'Found target at node {curr}!')\n"
	code += "        break\n"
	code += "    \n"
	code += "    # Push right then left for DFS order\n"
	code += "    right = 2*curr + 2\n"
	code += "    left = 2*curr + 1\n"
	code += "    \n"
	code += "    if right < size and tree[right] != -1 and not visited[right]:\n"
	code += "        stack.append(right)\n"
	code += "        visited[right] = True\n"
	code += "    if left < size and tree[left] != -1 and not visited[left]:\n"
	code += "        stack.append(left)\n"
	code += "        visited[left] = True\n"
	code += "\n''' Complexity: Time O(V+E) | Space O(V) '''"
	return code

func _gen_java_code() -> String:
	var code = "/* DFS Tree Search Simulation - Operations Log */\n"
	code += "import java.util.*;\n\n"
	code += "public class DFSTreeSearch {\n"
	code += "    public static void printTree(int[] tree, int size) {\n"
	code += "        System.out.print(\"Tree values: [\");\n"
	code += "        for(int i = 0; i < size; i++) {\n"
	code += "            System.out.print(tree[i]);\n"
	code += "            if(i < size-1) System.out.print(\", \");\n"
	code += "        }\n"
	code += "        System.out.println(\"]\");\n"
	code += "    }\n\n"
	code += "    public static void main(String[] args) {\n"
	code += "        int[] tree = {"
	
	# Add tree values
	for i in range(7):
		if i < main_array.size() and tree_nodes[i] != null:
			code += str(main_array[i])
		else:
			code += "-1"
		if i < 6:
			code += ", "
	code += "};\n"
	code += "        int target = %d;\n" % target_value
	code += "        int size = %d;\n\n" % main_array.size()
	code += "        System.out.print(\"Initial tree: \");\n"
	code += "        printTree(tree, size);\n"
	code += "        System.out.println(\"Searching for target: \" + target);\n\n"
	
	# DFS Implementation
	code += "        // DFS Implementation\n"
	code += "        Stack<Integer> stack = new Stack<>();\n"
	code += "        boolean[] visited = new boolean[7];\n"
	code += "        stack.push(0);\n"
	code += "        visited[0] = true;\n\n"
	code += "        while(!stack.isEmpty()) {\n"
	code += "            int curr = stack.pop();\n"
	code += "            System.out.println(\"Visiting node \" + curr + \": \" + tree[curr]);\n"
	code += "            \n"
	code += "            if(tree[curr] == target) {\n"
	code += "                System.out.println(\"Found target at node \" + curr + \"!\");\n"
	code += "                break;\n"
	code += "            }\n"
	code += "            \n"
	code += "            // Push right then left for DFS order\n"
	code += "            int right = 2*curr + 2;\n"
	code += "            int left = 2*curr + 1;\n"
	code += "            \n"
	code += "            if(right < size && tree[right] != -1 && !visited[right]) {\n"
	code += "                stack.push(right);\n"
	code += "                visited[right] = true;\n"
	code += "            }\n"
	code += "            if(left < size && tree[left] != -1 && !visited[left]) {\n"
	code += "                stack.push(left);\n"
	code += "                visited[left] = true;\n"
	code += "            }\n"
	code += "        }\n"
	code += "    }\n"
	code += "}\n"
	code += "/* Complexity: Time O(V+E) | Space O(V) */"
	return code

func _gen_c_code() -> String:
	var code = "/* DFS Tree Search Simulation - Operations Log */\n"
	code += "#include <stdio.h>\n#include <stdbool.h>\n\n"
	code += "#define MAX 100\n\n"
	code += "int stack[MAX];\n"
	code += "int top = -1;\n\n"
	code += "void push(int v) { stack[++top] = v; }\n"
	code += "int pop() { return stack[top--]; }\n"
	code += "bool is_empty() { return top == -1; }\n\n"
	code += "void printTree(int tree[], int size) {\n"
	code += "    printf(\"Tree values: [\");\n"
	code += "    for(int i = 0; i < size; i++) {\n"
	code += "        printf(\"%d\", tree[i]);\n"
	code += "        if(i < size-1) printf(\", \");\n"
	code += "    }\n"
	code += "    printf(\"]\\n\");\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    int tree[7] = {"
	
	# Add tree values
	for i in range(7):
		if i < main_array.size() and tree_nodes[i] != null:
			code += str(main_array[i])
		else:
			code += "-1"
		if i < 6:
			code += ", "
	code += "};\n"
	code += "    int target = %d;\n" % target_value
	code += "    int size = %d;\n\n" % main_array.size()
	code += "    printf(\"Initial tree: \");\n"
	code += "    printTree(tree, size);\n"
	code += "    printf(\"Searching for target: %d\\n\\n\", target);\n\n"
	
	# DFS Implementation
	code += "    // DFS Implementation\n"
	code += "    bool visited[7] = {false};\n"
	code += "    push(0);\n"
	code += "    visited[0] = true;\n\n"
	code += "    while(!is_empty()) {\n"
	code += "        int curr = pop();\n"
	code += "        printf(\"Visiting node %d: %d\\n\", curr, tree[curr]);\n"
	code += "        \n"
	code += "        if(tree[curr] == target) {\n"
	code += "            printf(\"Found target at node %d!\\n\", curr);\n"
	code += "            break;\n"
	code += "        }\n"
	code += "        \n"
	code += "        // Push right then left for DFS order\n"
	code += "        int right = 2*curr + 2;\n"
	code += "        int left = 2*curr + 1;\n"
	code += "        \n"
	code += "        if(right < size && tree[right] != -1 && !visited[right]) {\n"
	code += "            push(right);\n"
	code += "            visited[right] = true;\n"
	code += "        }\n"
	code += "        if(left < size && tree[left] != -1 && !visited[left]) {\n"
	code += "            push(left);\n"
	code += "            visited[left] = true;\n"
	code += "        }\n"
	code += "    }\n\n"
	code += "    return 0;\n"
	code += "}\n"
	code += "/* Complexity: Time O(V+E) | Space O(V) */"
	return code

func _array_to_string(arr: Array) -> String:
	var parts: Array[String] = []
	for v in arr:
		if v != 0:
			parts.append(str(v))
	return ", ".join(parts)

# ==============================================
#   CODE GENERATION & TUTORIAL (DFS)
# ==============================================

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

func _show_cpp_popup() -> void:
	match current_code_language:
		"cpp": current_tutorial_data = cpp_tutorial_data
		"python": current_tutorial_data = python_tutorial_data
		"java": current_tutorial_data = java_tutorial_data
		"c": current_tutorial_data = c_tutorial_data
	
	var code = _generate_code_for_language(current_code_language)
	
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
		var highlighted = ""
		var indices = data["lines"]
		for i in range(lines.size()):
			if i in indices:
				highlighted += "[color=yellow]" + lines[i] + "[/color]\n"
			else:
				highlighted += lines[i] + "\n"
		
		cpp_label.bbcode_enabled = true
		cpp_label.text = highlighted
		if cpp_scroll and indices.size() > 0:
			cpp_scroll.scroll_vertical = indices[0] * 20

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
			translate_code_btn.hide()
		if cpp_code_button:
			cpp_code_button.hide()
	
	score_summary.text = "Nodes Checked: %d" % grade.get("bad_moves", 0)
	accuracy_label.text = "Target: %d" % target_value
	time_used_label.text = "Stack Size: %d" % dfs_stack.size()
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
#   CONFIG HANDLERS & INTRO
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
	config_size_modal.hide()
	_show_config_elements_modal()

func _show_config_elements_modal() -> void:
	element_inputs.clear()
	for child in elements_container.get_children(): 
		child.queue_free()

	# Use a VBox to stack the levels of the tree
	var tree_vbox = VBoxContainer.new()
	tree_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	tree_vbox.add_theme_constant_override("separation", 20)
	tree_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	elements_container.add_child(tree_vbox)

	var count = int(size_input.value)
	var current_index = 0
	var level = 0

	# Build the tree inputs layer by layer
	while current_index < count:
		var nodes_in_level = pow(2, level)
		var h_box = HBoxContainer.new()
		h_box.alignment = BoxContainer.ALIGNMENT_CENTER
		# Nodes get closer together at lower levels
		h_box.add_theme_constant_override("separation", max(10, 50 - (level * 15))) 

		for i in range(nodes_in_level):
			if current_index >= count:
				break

			var node_vbox = VBoxContainer.new()
			node_vbox.alignment = BoxContainer.ALIGNMENT_CENTER

			var lbl = Label.new()
			lbl.text = "Node " + str(current_index)
			lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			lbl.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
			node_vbox.add_child(lbl)

			var le = LineEdit.new()
			le.placeholder_text = "0"
			le.text = "" 
			le.alignment = HORIZONTAL_ALIGNMENT_CENTER
			le.custom_minimum_size = Vector2(100, 70)
			
			le.max_length = 3 
			
			node_vbox.add_child(le)
			h_box.add_child(node_vbox)
			
			element_inputs.append(le)
			
			le.text_changed.connect(_on_element_input_changed.bind(le))

			current_index += 1

		tree_vbox.add_child(h_box)
		level += 1

	_validate_tree_inputs("")
	config_elements_modal.show()

func _on_element_input_changed(new_text: String, line_edit: LineEdit) -> void:
	if not new_text.is_empty() and not new_text.is_valid_int():
		var filtered_text = ""
		for char in new_text:
			if char >= "0" and char <= "9":
				filtered_text += char
		line_edit.text = filtered_text
		line_edit.caret_column = filtered_text.length()
	_validate_tree_inputs("")

func _validate_tree_inputs(_ignored_text: String):
	for i in range(element_inputs.size()):
		if i == 0: 
			element_inputs[i].editable = true
			continue
			
		var parent_idx = (i - 1) / 2
		if parent_idx >= 0 and parent_idx < element_inputs.size():
			var parent_le = element_inputs[parent_idx]
			if parent_le.text.strip_edges().is_empty() or parent_le.text == "0":
				element_inputs[i].editable = false
				element_inputs[i].text = ""
				element_inputs[i].placeholder_text = "Locked"
			else:
				element_inputs[i].editable = true
				element_inputs[i].placeholder_text = "0"

func _on_elements_done_pressed() -> void:
	btn_sound.play()
	var arr: Array[int] = []
	for le in element_inputs:
		if le.text.strip_edges().is_empty():
			arr.append(0)
		elif le.text.is_valid_int():
			arr.append(int(le.text))
		else:
			arr.append(0)
			
	config_elements_modal.hide()
	_set_main_ui_enabled(true)
	_initialize_with_elements(arr)

func _on_config_no_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	var count = 7
	var arr: Array[int] = []
	for i in count: arr.append(randi_range(1, 99))
	_set_main_ui_enabled(true)
	_initialize_with_elements(arr)

func _on_size_back_pressed(): config_size_modal.hide(); config_modal.show()
func _on_elements_back_pressed(): config_elements_modal.hide(); config_size_modal.show()

# ==============================================
#   INTRO LOGIC & TUTORIAL
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
			"node": array_container,
			"title": "TREE EDITOR",
			"text": "Click on any node to change its number.\nREMEMBER: You must set the parent node first!",
			"action": "highlight"
		},
		{
			"node": sort_btn,
			"title": "FIND ELEMENT",
			"text": "Opens a popup to choose which number to search for.",
			"action": "highlight"
		},
		{
			"node": auto_btn,
			"title": "DFS STEP",
			"text": "Executes exactly one step of the Depth-First Search.",
			"action": "highlight"
		},
		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View search logs.",
			"action": "highlight"
		},
		{
			"node": simulate_new_btn,
			"title": "SIMULATE NEW",
			"text": "Generates a new Random Tree.",
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
		if node is Button: node.disabled = false
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

# --- HELPER UTILS ---

func _set_main_ui_enabled(enabled: bool) -> void:
	if sort_btn: sort_btn.disabled = not enabled
	if auto_btn: auto_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled
	if simulate_new_btn: simulate_new_btn.disabled = not enabled

func _on_cpp_close_pressed(): btn_sound.play(); cpp_popup.hide()
func _on_cpp_code_button_pressed(): btn_sound.play(); _show_cpp_popup()
func _on_complete_ok_pressed(): btn_sound.play(); complete_popup.hide()
func _on_simulate_new_pressed(): sim_confirmation.show()
func _on_yes_pressed():
	sim_confirmation.hide()
	sim_success.show()
	await get_tree().create_timer(1.0).timeout
	sim_success.hide()
	_show_config_modal()
func _on_no_pressed(): sim_confirmation.hide()
func _on_help_button_pressed(): start_tutorial()
