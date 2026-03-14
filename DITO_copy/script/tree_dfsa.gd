extends Control

# =======================================================
# DFS ASSESSMENT MODE - TREE SEARCH
# =======================================================

# --- MAIN BUTTONS ---
@onready var match_btn: Button = $VBoxContainer/MatchButton
@onready var undo_btn: Button = $VBoxContainer/UndoButton
@onready var redo_btn: Button = $VBoxContainer/RedoButton
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var compare_label: Label = $HBoxContainer2/Label
@onready var timer_label: Label = $VBoxContainer/HBoxContainer/Label2
@onready var target_label: Label = $TargetLabel
@onready var difficulty_label: Label = $DiificultyLabel

# --- CONTAINERS ---
@onready var array_container: Control = $TreeContainer
@onready var dequeued_container: Control = $DequeuedContainer

# --- POPUPS ---
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label

# --- TIMELINE POPUP ---
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: RichTextLabel = $TimelinePopup/MainVBox/ScrollContainer/VBoxContainer/TimelineLabel
@onready var timeline_close_btn: Button = $TimelinePopup/MainVBox/MarginContainer/CloseButton

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

# Top Right Button
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")
@onready var code_anim: AnimatedSprite2D = get_node_or_null("CppCodeButton/code_anim")

# --- COMPILER INTEGRATION ---
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CompileButton")

# --- SCENE RESOURCES ---
const BLOCK_SCENE := preload("res://scene/TreeNode.tscn")
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
@onready var clock = $AnimatedSprite2D

# --- CONFIGURATION MODALS (Hidden in Assessment) ---
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

# =======================================================
# COMPILER INTEGRATION - API KEYS
# =======================================================
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

# =======================================================
# ASSESSMENT VARIABLES
# =======================================================

enum SimMode { LECTURE, ASSESSMENT }
var sim_mode: SimMode = SimMode.ASSESSMENT
var difficulty := 2  # Default Medium

# Timer variables
var time_remaining: float = 0.0
var timer_running: bool = false
var assessment_time_limit: float = 0.0
const TIKTAK_SFX := preload("res://assets/sfx/tiktak.mp3")
var tiktak_sound: AudioStreamPlayer

# Tree data
var main_array: Array[int] = []
var tree_nodes: Array = []  # Stores node instances
var node_positions: Array = []
var timeline_log: Array[String] = []

# DFS Assessment specific
var revealed_nodes: Array[bool] = []  # Track which nodes are revealed
var last_tapped_index: int = -1  # Track the most recently tapped node
var target_index: int = -1  # Index where target value is located
var target_value: int = -1

# Tracking variables
var correct_moves: int = 0
var mistake_counter: int = 0
var has_completed_assessment: bool = false
var completion_type: String = ""
var coins_earned: int = 0

# Code generation variables
var code_lines: Array[String] = []
var current_code_language: String = "cpp"

# Undo/Redo stacks
var undo_stack: Array = []
var redo_stack: Array = []

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

# Animation
var ANIM_SPEED: float = 0.2
var is_animating: bool = false

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

# Intro Text
var intro_step: int = 0
var intro_texts = [
	"WELCOME TO DFS ASSESSMENT! 🌲\n\nDepth-First Search (DFS) explores as deep as possible along each branch before backtracking.",
	
	"HOW TO PLAY:\n\n• All node values are HIDDEN at start\n• Tap nodes in the correct DFS order to reveal them\n• Root → Left subtree completely → Right subtree\n• Find the target number shown at the top!",
	
	"DFS ORDER RULES:\n\n1. Start at the ROOT (index 0)\n2. Explore entire LEFT subtree first\n3. Then explore RIGHT subtree\n\nExample: [0, 1, 3, 4, 2, 5, 6] is correct DFS order",
	
	"SCORING:\n\n✓ Correct DFS order tap = Good move\n✗ Wrong order tap = Mistake (but number still reveals)\n✓ Match button on correct target = Victory!\n✗ Match button on wrong node = Mistake",
	
	"DIFFICULTY LEVELS:\n\nEASY (5 nodes): No time limit\nMEDIUM (6 nodes): 15 minutes\nHARD (7 nodes): 1 minute with tick-tock!\n\nPassing: 60% (Easy), 75% (Medium), 80% (Hard)",
	
	"VISUAL GUIDE:\n\n• Pink Circle 🔴 = Unvisited/Hidden\n• Orange Circle 🟠 = Current/Last tapped\n• Green Circle 🟢 = Target Found!\n\nGood luck!"
]

# =======================================================
# READY & INITIALIZATION
# =======================================================

func _ready() -> void:
	print("DFS Assessment mode initialized")
	randomize()
	
	# Setup tick-tock sound
	tiktak_sound = AudioStreamPlayer.new()
	tiktak_sound.stream = TIKTAK_SFX
	add_child(tiktak_sound)
	
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
	try_again_result_btn.pressed.connect(_on_try_again_result_pressed)
	back_result_btn.pressed.connect(_on_back_result_pressed)
	translate_code_btn.pressed.connect(_on_translate_code_pressed)
	
	# Define tree positions
	_define_tree_positions()
	
	# Force containers to ignore mouse
	if dequeued_container: 
		dequeued_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if array_container: 
		array_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var try_again_root_btn = get_node_or_null("TryAgainButton")
	if try_again_root_btn:
		try_again_root_btn.pressed.connect(_on_try_again_root_btn_pressed)
	var tex_rect = get_node_or_null("TextureRect")
	if tex_rect: 
		tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Hide lecture elements
	_hide_lecture_elements()
	
	# Show assessment elements
	_show_assessment_elements()
	
	# Hide modals
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	# Hide pointers
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if unused_ptr1: unused_ptr1.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	# Setup buttons
	if timeline_btn: timeline_btn.text = "TIMELINE"
	if timeline_close_btn:
		if not timeline_close_btn.is_connected("pressed", _on_timeline_close_pressed):
			timeline_close_btn.pressed.connect(_on_timeline_close_pressed)
	else:
		print("WARNING: timeline_close_btn not found!")
	
	# Connect buttons
	_connect_assessment_buttons()
	_connect_language_buttons()
	
	# Setup compiler
	_setup_compiler()
	
	# Initialize tree but DON'T start timer yet
	_initialize_assessment_for_intro()
	
	# Show intro
	call_deferred("show_introduction")
	
	# Play animations
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")

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
		print("Compiler cache reset for new assessment")

func _on_try_again_root_btn_pressed():
	btn_sound.play()
	result_popup.hide()
	
	# Hide self
	var try_again_root_btn = get_node_or_null("TryAgainButton")
	if try_again_root_btn: try_again_root_btn.hide()
	
	_reset_assessment()
	show_introduction()

# Add this new function to initialize tree without starting timer
func _initialize_assessment_for_intro():
	# Reset cache for new assessment
	reset_cache_for_scene()
	
	# Clear code lines
	code_lines.clear()
	
	# Set difficulty-based parameters
	var size = _get_array_size()
	assessment_time_limit = _get_time_limit()
	time_remaining = assessment_time_limit
	timer_running = false  # Timer not running yet
	
	# Update difficulty label
	_update_difficulty_label()
	
	# Generate tree with random values
	var tree_values = _generate_tree_values(size)
	
	# Select random target that exists in tree
	target_index = randi() % size
	target_value = tree_values[target_index]
	
	# Initialize tree with hidden nodes
	_initialize_assessment_tree(tree_values)
	
	# Add initial code line
	_add_code_line("INITIAL", 0, 0)
	
	# Set target label
	if target_label:
		target_label.text = "Find: %d" % target_value
	
	# Set status
	if status_label:
		status_label.text = "Read instructions"
	
	# Update timer display
	_update_timer_display()
	
	# Enable/disable buttons appropriately
	match_btn.disabled = true  # Disable until instructions are done
	undo_btn.disabled = true
	redo_btn.disabled = true
	timeline_btn.disabled = false  # Timeline can be viewed anytime
	
	# Log start
	timeline_log.append("--- DFS Assessment Ready ---")
	timeline_log.append("Target: %d" % [target_value])

func _hide_lecture_elements():
	# Hide lecture-specific buttons (they should be removed from scene, but just in case)
	var find_btn = get_node_or_null("VBoxContainer/SortButton")
	if find_btn: find_btn.hide()
	
	var step_btn = get_node_or_null("VBoxContainer/WaitingElements")
	if step_btn: step_btn.hide()
	
	var sim_new_btn = get_node_or_null("VBoxContainer/SimulateNew")
	if sim_new_btn: sim_new_btn.hide()

func _show_assessment_elements():
	# Show assessment buttons
	if match_btn: 
		match_btn.show()
	if undo_btn: 
		undo_btn.show()
	if redo_btn: 
		redo_btn.show()
	if timeline_btn: 
		timeline_btn.show()
	
	# Show timer and target labels
	if timer_label: 
		timer_label.show()
	if target_label: 
		target_label.show()
	if clock: 
		clock.show()
	if difficulty_label:
		difficulty_label.show()

func _connect_assessment_buttons():
	if match_btn:
		match_btn.pressed.connect(_on_match_pressed)
	if undo_btn:
		undo_btn.pressed.connect(_on_undo_pressed)
	if redo_btn:
		redo_btn.pressed.connect(_on_redo_pressed)
	if timeline_btn:
		timeline_btn.pressed.connect(_on_timeline_pressed)

func _connect_language_buttons():
	if cpp_lang_btn: cpp_lang_btn.pressed.connect(func(): _set_language("cpp"))
	if python_lang_btn: python_lang_btn.pressed.connect(func(): _set_language("python"))
	if java_lang_btn: java_lang_btn.pressed.connect(func(): _set_language("java"))
	if c_lang_btn: c_lang_btn.pressed.connect(func(): _set_language("c"))

func _set_language(lang: String):
	btn_sound.play()
	current_code_language = lang
	_show_cpp_popup()

# =======================================================
# TREE LAYOUT
# =======================================================

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

# =======================================================
# ASSESSMENT MODE START
# =======================================================

func _start_assessment_mode():
	# Reset all tracking variables
	correct_moves = 0
	mistake_counter = 0
	has_completed_assessment = false
	completion_type = ""
	coins_earned = 0
	last_tapped_index = -1
	undo_stack.clear()
	redo_stack.clear()
	timeline_log.clear()
	
	# Set difficulty-based parameters
	var size = _get_array_size()
	assessment_time_limit = _get_time_limit()
	time_remaining = assessment_time_limit
	timer_running = true
	
	# Update difficulty label
	_update_difficulty_label()
	
	# Generate tree with random values
	var tree_values = _generate_tree_values(size)
	
	# Select random target that exists in tree
	target_index = randi() % size
	target_value = tree_values[target_index]
	
	# Initialize tree with hidden nodes
	_initialize_assessment_tree(tree_values)
	
	# Set target label
	if target_label:
		target_label.text = "Find: %d" % target_value
	
	# Set status
	if status_label:
		status_label.text = "Tap nodes in DFS order"
	
	# Start timer display
	_update_timer_display()
	
	# Enable buttons
	_update_undo_redo_buttons()
	
	# Log start
	timeline_log.append("--- DFS Assessment Started ---")
	timeline_log.append("Target: %d at node %d" % [target_value, target_index])

func _get_array_size() -> int:
	match difficulty:
		1: return 5  # Easy
		2: return 6  # Medium
		3: return 7  # Hard
	return 5

func _get_time_limit() -> float:
	match difficulty:
		1: return 100000.0  # Easy (no timer)
		2: return 900.0      # Medium (15 minutes)
		3: return 60.0       # Hard (1 minute)
	return 90.0

func _update_difficulty_label():
	if not difficulty_label:
		return
	match difficulty:
		1: difficulty_label.text = "Difficulty: Easy"
		2: difficulty_label.text = "Difficulty: Medium"
		3: difficulty_label.text = "Difficulty: Hard"

func _generate_tree_values(size: int) -> Array[int]:
	var values: Array[int] = []
	var used_values: Dictionary = {}  # Track used values to avoid duplicates
	
	for i in range(size):
		var new_value: int
		# Keep generating until we find a unique value
		while true:
			new_value = randi_range(1, 99)
			if not used_values.has(new_value):
				used_values[new_value] = true
				break
		
		values.append(new_value)
	
	return values

func _initialize_assessment_tree(values: Array[int]):
	# Clear existing tree
	for child in array_container.get_children():
		child.queue_free()
	
	tree_nodes.clear()
	tree_nodes.resize(7)
	tree_nodes.fill(null)
	main_array = values.duplicate()
	revealed_nodes = []
	revealed_nodes.resize(7)
	revealed_nodes.fill(false)
	
	# Load texture resources
	var pink_texture = load("res://assets/circles3.png")  # Unvisited
	
	# Create nodes with hidden values
	for i in range(values.size()):
		var node = BLOCK_SCENE.instantiate()
		array_container.add_child(node)
		node.position = node_positions[i]
		
		# Set initial hidden state (blank)
		node.set_value("")
		node.modulate = Color(1, 1, 1, 1)
		
		# Set pink sprite for unvisited
		var sprite = node.get_node_or_null("Sprite2D")
		if sprite and pink_texture:
			sprite.texture = pink_texture
		
		# Add click handler
		var click_btn = Button.new()
		click_btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		click_btn.modulate.a = 0.0
		click_btn.mouse_filter = Control.MOUSE_FILTER_STOP
		click_btn.pressed.connect(_on_assessment_node_clicked.bind(i))
		node.add_child(click_btn)
		
		tree_nodes[i] = node
	
	# Fill remaining positions with null
	for i in range(values.size(), 7):
		tree_nodes[i] = null
	
	queue_redraw()

# =======================================================
# NODE CLICK HANDLER
# =======================================================

func _on_assessment_node_clicked(index: int):
	if has_completed_assessment or not timer_running:
		show_feedback("Assessment complete!", Color.YELLOW, get_global_mouse_position())
		return
	
	# Check if node exists and is valid
	if index >= tree_nodes.size() or tree_nodes[index] == null:
		return
	
	# Check if node is already revealed (visited before)
	if revealed_nodes[index]:
		# Already visited - just show feedback but don't count as move
		show_feedback("Already visited!", Color.YELLOW, tree_nodes[index].global_position)
		# Still highlight as current node
		_highlight_node(index, true)
		# Clear previous last tapped highlight
		if last_tapped_index != -1 and last_tapped_index != index:
			_reset_node_highlight(last_tapped_index)
		last_tapped_index = index
		return  # Don't count as move, don't save state
	
	# Save state for undo (only for new revelations)
	_save_state()
	redo_stack.clear()
	
	# Get node
	var node = tree_nodes[index]
	var actual_value = main_array[index]
	
	# Reveal the number
	node.set_value(str(actual_value))
	revealed_nodes[index] = true
	
	# Update visual - orange for current/last tapped
	_highlight_node(index, true)
	
	# Clear previous last tapped highlight
	if last_tapped_index != -1 and last_tapped_index != index:
		_reset_node_highlight(last_tapped_index)
	
	last_tapped_index = index
	
	# Check if this is the correct DFS order
	var is_correct_order = _validate_dfs_order(index)
	
	# Count moves based on order correctness
	if is_correct_order:
		correct_moves += 1
		timeline_log.append("[color=green]Good move: Revealed node %d in correct DFS order[/color]" % index)
		show_feedback("Good move!", Color.GREEN, node.global_position)
		_add_code_line("TAP", index, actual_value)
	else:
		mistake_counter += 1
		timeline_log.append("[color=red]Bad move: Revealed node %d out of DFS order[/color]" % index)
		show_feedback("Wrong order!", Color.RED, node.global_position)
		_add_code_line("TAP", index, actual_value)
	
	# Update UI
	_update_ui_labels()
	_update_undo_redo_buttons()

func _validate_dfs_order(index: int) -> bool:
	# Root (0) is always valid first move
	if last_tapped_index == -1:
		return index == 0
	
	# Get the expected next nodes in DFS order
	var expected_order = _get_dfs_order()
	
	# Find where we are in the expected order
	var current_pos = -1
	for i in range(expected_order.size()):
		if expected_order[i] == index:
			current_pos = i
			break
	
	if current_pos == -1:
		return false
	
	# Check if all previous nodes in expected order are revealed
	for i in range(current_pos):
		var expected_idx = expected_order[i]
		if not revealed_nodes[expected_idx]:
			return false  # Missed a required node
	
	return true

func _get_dfs_order() -> Array[int]:
	# Generate DFS order for the tree (Root → Left subtree → Right subtree)
	var order: Array[int] = []
	var stack: Array[int] = []
	stack.append(0)  # Start with root
	
	# Use a visited set for generation
	var visited_gen: Array[bool] = []
	visited_gen.resize(7)
	visited_gen.fill(false)
	
	while not stack.is_empty():
		var current = stack.pop_back()
		if current >= 7 or tree_nodes[current] == null or visited_gen[current]:
			continue
		
		order.append(current)
		visited_gen[current] = true
		
		# Push right then left (so left is processed first)
		var right = 2 * current + 2
		var left = 2 * current + 1
		
		if right < 7 and tree_nodes[right] != null and not visited_gen[right]:
			stack.append(right)
		if left < 7 and tree_nodes[left] != null and not visited_gen[left]:
			stack.append(left)
	
	return order

func _highlight_node(index: int, highlight: bool):
	if index >= tree_nodes.size() or tree_nodes[index] == null:
		return
	
	var node = tree_nodes[index]
	var sprite = node.get_node_or_null("Sprite2D")
	if not sprite:
		return
	
	if highlight:
		# Orange for current/last tapped (circles1.png)
		var orange_texture = load("res://assets/circles1.png")
		if orange_texture:
			sprite.texture = orange_texture
	else:
		# Reset to appropriate color
		_reset_node_highlight(index)

func _reset_node_highlight(index: int):
	if index >= tree_nodes.size() or tree_nodes[index] == null:
		return
	
	var node = tree_nodes[index]
	var sprite = node.get_node_or_null("Sprite2D")
	if not sprite:
		return
	
	# Load textures
	var pink_texture = load("res://assets/circles3.png")  # Unvisited/revealed not target
	
	if revealed_nodes[index]:
		# Revealed but not current - pink
		if pink_texture:
			sprite.texture = pink_texture
	else:
		# Unrevealed - pink
		if pink_texture:
			sprite.texture = pink_texture

# =======================================================
# MATCH BUTTON HANDLER
# =======================================================

func _on_match_pressed():
	btn_sound.play()
	
	if has_completed_assessment:
		return
	
	if last_tapped_index == -1:
		show_feedback("Tap a node first!", Color.YELLOW, get_global_mouse_position())
		return
	
	# Check if last tapped node matches target
	if last_tapped_index == target_index:
		# Correct match!
		correct_moves += 1
		timeline_log.append("[color=green]MATCH! Found target at node %d[/color]" % target_index)
		show_feedback("TARGET FOUND!", Color.GREEN, tree_nodes[target_index].global_position)
		_add_code_line("MATCH", target_index, target_value)
		
		# Mark node as found (green)
		var node = tree_nodes[target_index]
		var sprite = node.get_node_or_null("Sprite2D")
		if sprite:
			var green_texture = load("res://assets/circles2.png")
			if green_texture:
				sprite.texture = green_texture
		
		# End assessment
		_end_assessment("found")
	else:
		# Wrong match
		mistake_counter += 1
		timeline_log.append("[color=red]Wrong match! Node %d ≠ target[/color]" % last_tapped_index)
		show_feedback("Wrong node!", Color.RED, tree_nodes[last_tapped_index].global_position)
		_add_code_line("WRONG_MATCH", last_tapped_index, target_value)
		
		# REMOVED: _flash_target_hint() - no more pulsing
		
		_update_ui_labels()

func _flash_target_hint():
	if target_index < tree_nodes.size() and tree_nodes[target_index]:
		var node = tree_nodes[target_index]
		var original_scale = node.scale
		var tween = create_tween()
		tween.tween_property(node, "scale", original_scale * 1.3, 0.2)
		tween.tween_property(node, "scale", original_scale, 0.2)

# =======================================================
# UNDO/REDO FUNCTIONS
# =======================================================

func _save_state():
	var state = {
		"revealed": revealed_nodes.duplicate(),
		"last_tapped": last_tapped_index,
		"correct": correct_moves,
		"mistakes": mistake_counter,
		"timeline": timeline_log.duplicate(),
		"code_lines": code_lines.duplicate()
	}
	undo_stack.append(state)

func _restore_state(state: Dictionary):
	# Restore revealed states
	revealed_nodes = state["revealed"].duplicate()
	last_tapped_index = state["last_tapped"]
	correct_moves = state["correct"]
	mistake_counter = state["mistakes"]
	timeline_log = state["timeline"].duplicate()
	code_lines = state["code_lines"].duplicate()
	
	# Update visual states
	for i in range(tree_nodes.size()):
		if tree_nodes[i] == null:
			continue
		
		var node = tree_nodes[i]
		if revealed_nodes[i]:
			node.set_value(str(main_array[i]))
		else:
			node.set_value("")
		
		# Update sprite colors
		_reset_node_highlight(i)
	
	# Re-highlight last tapped
	if last_tapped_index != -1:
		_highlight_node(last_tapped_index, true)
	
	queue_redraw()
	_update_timeline_display()
	_update_ui_labels()

func _on_undo_pressed():
	btn_sound.play()
	
	if undo_stack.is_empty():
		return
	
	# Save current state to redo
	var current_state = {
		"revealed": revealed_nodes.duplicate(),
		"last_tapped": last_tapped_index,
		"correct": correct_moves,
		"mistakes": mistake_counter,
		"timeline": timeline_log.duplicate(),
		"code_lines": code_lines.duplicate()
	}
	redo_stack.append(current_state)
	
	# Restore previous state
	var prev_state = undo_stack.pop_back()
	_restore_state(prev_state)
	
	timeline_log.append("[color=gray]Undo: Reverted last tap[/color]")
	_update_timeline_display()
	_update_undo_redo_buttons()

func _on_redo_pressed():
	btn_sound.play()
	
	if redo_stack.is_empty():
		return
	
	# Save current state to undo
	var current_state = {
		"revealed": revealed_nodes.duplicate(),
		"last_tapped": last_tapped_index,
		"correct": correct_moves,
		"mistakes": mistake_counter,
		"timeline": timeline_log.duplicate(),
		"code_lines": code_lines.duplicate()
	}
	undo_stack.append(current_state)
	
	# Restore next state
	var next_state = redo_stack.pop_back()
	_restore_state(next_state)
	
	timeline_log.append("[color=gray]Redo: Reapplied tap[/color]")
	_update_timeline_display()
	_update_undo_redo_buttons()

# =======================================================
# TIMER & PROCESS
# =======================================================

func _process(delta: float) -> void:
	if not timer_running or has_completed_assessment:
		return
	
	time_remaining -= delta
	
	if time_remaining <= 0:
		time_remaining = 0
		timer_running = false
		tiktak_sound.stop()
		_on_time_up()
	
	_update_timer_display()

func _update_timer_display():
	if not timer_label:
		return
	
	var total_seconds: int = int(time_remaining)
	var minutes: int = total_seconds / 60
	var seconds: int = total_seconds % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]
	
	# Tick-tock sound in last 10 seconds
	if time_remaining <= 10.0 and timer_running and time_remaining > 0:
		if not tiktak_sound.playing:
			tiktak_sound.play()

func _on_time_up() -> void:
	tiktak_sound.stop()
	show_feedback("Time's Up!", Color.RED, Vector2(400, 200))
	timer_running = false
	_end_assessment("timeout")

# =======================================================
# ASSESSMENT COMPLETION
# =======================================================

func _end_assessment(reason: String):
	if has_completed_assessment:
		return
	
	has_completed_assessment = true
	completion_type = reason
	timer_running = false
	tiktak_sound.stop()
	
	# Disable buttons with null checks
	if match_btn:
		match_btn.disabled = true
	if undo_btn:
		undo_btn.disabled = true
	if redo_btn:
		redo_btn.disabled = true
	if timeline_btn:
		timeline_btn.disabled = true
	
	# Show result popup
	if reason == "found":
		var grade = _compute_grade()
		# Check if they actually passed based on accuracy
		if grade["passed"]:
			_show_result_popup("PASS", grade)
		else:
			_show_result_popup("FAIL", grade)
	else: # timeout
		_show_result_popup("FAIL")

func _compute_grade() -> Dictionary:
	var total_moves = correct_moves + mistake_counter
	var accuracy = float(correct_moves) / max(total_moves, 1) * 100
	var required_threshold = _get_required_threshold() * 100
	var passed = accuracy >= required_threshold
	
	var time_used = assessment_time_limit - time_remaining
	
	var coins = 0
	match difficulty:
		1: coins = 5 if passed else 1
		2: coins = 10 if passed else 3
		3: coins = 20 if passed else 5
	
	coins_earned = coins if passed else 0
	
	return {
		"passed": passed,
		"accuracy": accuracy,
		"total_moves": total_moves,
		"correct_moves": correct_moves,
		"mistake_counter": mistake_counter,
		"time_used": time_used,
		"coins": coins_earned,
		"required": required_threshold
	}

func _get_required_threshold() -> float:
	match difficulty:
		1: return 0.6   # Easy
		2: return 0.75  # Medium
		3: return 0.8   # Hard
	return 0.7

func _show_result_popup(result: String, grade_data: Dictionary = {}):
	if not result_popup:
		return
	
	# Make sure we're showing the correct result based on the parameter
	if result == "PASS":
		result_title.text = "PASSED!"
		result_title.modulate = Color(0, 1, 0)
		if translate_code_btn:
			translate_code_btn.show()
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")
		var try_again_root_btn = get_node_or_null("TryAgainButton")
		if try_again_root_btn: try_again_root_btn.hide()
	else:  # FAIL or any other value
		result_title.text = "FAILED!"
		result_title.modulate = Color(1, 0, 0)
		if translate_code_btn:
			translate_code_btn.hide()  # Hide code button on failure
		if cpp_code_button:
			cpp_code_button.hide()
		var try_again_root_btn = get_node_or_null("TryAgainButton")
		if try_again_root_btn: try_again_root_btn.show()
	
	if completion_type == "timeout":
		score_summary.text = "Time's Up!"
		accuracy_label.text = "Accuracy: 0%"
		var total_seconds = int(assessment_time_limit)
		var minutes = total_seconds / 60
		var seconds = total_seconds % 60
		time_used_label.text = "Time: %02d:%02d" % [minutes, seconds]
		coins_label.text = "+0"
	else:
		var total_seconds = int(grade_data.get("time_used", 0))
		var minutes = total_seconds / 60
		var seconds = total_seconds % 60
		
		score_summary.text = "Correct: %d | Mistakes: %d" % [grade_data.get("correct_moves", 0), grade_data.get("mistake_counter", 0)]
		accuracy_label.text = "Accuracy: %.1f%% (Need %.0f%%)" % [grade_data.get("accuracy", 0), grade_data.get("required", 0)]
		time_used_label.text = "Time Used: %02d:%02d" % [minutes, seconds]
		coins_label.text = "+%d" % grade_data.get("coins", 0)
	
	# Show target node in green in the tree (only if found, otherwise maybe highlight it differently?)
	if target_index < tree_nodes.size() and tree_nodes[target_index]:
		var node = tree_nodes[target_index]
		var sprite = node.get_node_or_null("Sprite2D")
		if sprite:
			if result == "PASS":
				var green_texture = load("res://assets/circles2.png")
				if green_texture:
					sprite.texture = green_texture
			else:
				# On failure, maybe show target in red or keep as is
				var pink_texture = load("res://assets/circles3.png")
				if pink_texture:
					sprite.texture = pink_texture
	
	result_popup.popup_centered()
	
	if grade_data.get("coins", 0) > 0 and coins_anim:
		coins_anim.play("default")

func _on_try_again_result_pressed():
	btn_sound.play()
	result_popup.hide()
	
	# Reset the assessment but DON'T start timer yet
	var try_again_root_btn = get_node_or_null("TryAgainButton")
	if try_again_root_btn: try_again_root_btn.hide()
	_reset_assessment()
	
	# Show intro again
	show_introduction()

# Add this helper function
func _reset_assessment():
	# Reset cache for new assessment
	reset_cache_for_scene()
	
	# Reset all tracking variables
	correct_moves = 0
	mistake_counter = 0
	has_completed_assessment = false
	completion_type = ""
	coins_earned = 0
	last_tapped_index = -1
	undo_stack.clear()
	redo_stack.clear()
	timeline_log.clear()
	code_lines.clear()
	var try_again_root_btn = get_node_or_null("TryAgainButton")
	if try_again_root_btn: try_again_root_btn.hide()
	
	# Re-initialize tree
	var size = _get_array_size()
	var tree_values = _generate_tree_values(size)
	target_index = randi() % size
	target_value = tree_values[target_index]
	_initialize_assessment_tree(tree_values)
	
	# Add initial code line
	_add_code_line("INITIAL", 0, 0)
	
	# Update target label
	if target_label:
		target_label.text = "Find: %d" % target_value
	
	# Reset timer but don't start
	assessment_time_limit = _get_time_limit()
	time_remaining = assessment_time_limit
	timer_running = false
	_update_timer_display()
	
	# Set status
	if status_label:
		status_label.text = "Read instructions"
	
	# Disable buttons until intro finishes
	match_btn.disabled = true
	undo_btn.disabled = true
	redo_btn.disabled = true
	timeline_btn.disabled = false
	
	# Log start
	timeline_log.append("--- DFS Assessment Ready ---")
	timeline_log.append("Target: %d at node %d" % [target_value, target_index])

func _on_back_result_pressed():
	btn_sound.play()
	result_popup.hide()
	# Return to difficulty selection or main menu

func _on_translate_code_pressed():
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()

# =======================================================
# UI HELPER FUNCTIONS
# =======================================================

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

func _update_ui_labels():
	if compare_label:
		compare_label.text = "Correct: %d | Mistakes: %d" % [correct_moves, mistake_counter]

func _update_undo_redo_buttons():
	if undo_btn:
		undo_btn.disabled = undo_stack.is_empty()
	if redo_btn:
		redo_btn.disabled = redo_stack.is_empty()

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

# =======================================================
# TIMELINE FUNCTIONS
# =======================================================

func _on_timeline_pressed() -> void:
	btn_sound.play()
	if timeline_popup.visible:
		timeline_popup.hide()
	else:
		# Show timeline with BBCode formatting
		var display_log = []
		if timeline_log.is_empty():
			display_log.append("No moves yet")
		else:
			for entry in timeline_log:
				# Keep the BBCode formatting
				display_log.append(entry)
		
		if timeline_label:
			timeline_label.bbcode_enabled = true
			timeline_label.text = "[b]TIMELINE:[/b]\n\n" + "\n".join(display_log)
			
			# Ensure the label expands to fit content
			timeline_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			timeline_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
			
		timeline_popup.popup_centered()
		
		# Small delay to ensure popup is visible before setting scroll
		await get_tree().process_frame
		
		# Auto-scroll to bottom to show latest moves
		var scroll_container = $TimelinePopup/MainVBox/ScrollContainer
		if scroll_container:
			scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value

func _on_timeline_close_pressed() -> void:
	btn_sound.play()
	timeline_popup.hide()

func _update_timeline_display():
	# Just keep the log, don't auto-show
	pass

# =======================================================
# CODE GENERATION FUNCTIONS
# =======================================================

func _add_code_line(op: String, index: int, value: int) -> void:
	code_lines.append("%s|%d|%d" % [op, index, value])

func _generate_code_for_language(lang: String) -> String:
	match lang:
		"python": return _gen_python_code()
		"java": return _gen_java_code()
		"c": return _gen_c_code()
		_: return _gen_cpp_code()

func _gen_cpp_code() -> String:
	var code = "/* DFS Tree Search Assessment - Operations Log */\n"
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
		if i < main_array.size():
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
	
	# DFS implementation
	code += "    // DFS Implementation\n"
	code += "    stack<int> s;\n"
	code += "    bool visited[7] = {false};\n"
	code += "    s.push(0);\n\n"
	code += "    while(!s.empty()) {\n"
	code += "        int curr = s.top();\n"
	code += "        s.pop();\n"
	code += "        \n"
	code += "        if(curr >= size || visited[curr]) continue;\n"
	code += "        visited[curr] = true;\n"
	code += "        \n"
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
	code += "        if(right < size && !visited[right])\n"
	code += "            s.push(right);\n"
	code += "        if(left < size && !visited[left])\n"
	code += "            s.push(left);\n"
	code += "    }\n\n"
	
	code += "    return 0;\n}"
	return code

func _gen_python_code() -> String:
	var code = "# DFS Tree Search Assessment - Operations Log\n\n"
	code += "def print_tree(tree):\n"
	code += "    print('Tree values:', [x for x in tree if x != -1])\n\n"
	code += "tree = ["
	
	# Add tree values
	for i in range(7):
		if i < main_array.size():
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
	code += "visited = [False] * 7\n\n"
	code += "while stack:\n"
	code += "    curr = stack.pop()\n"
	code += "    \n"
	code += "    if curr >= size or visited[curr]:\n"
	code += "        continue\n"
	code += "    visited[curr] = True\n"
	code += "    \n"
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
	code += "    if right < size and not visited[right]:\n"
	code += "        stack.append(right)\n"
	code += "    if left < size and not visited[left]:\n"
	code += "        stack.append(left)\n"
	return code

func _gen_java_code() -> String:
	var code = "/* DFS Tree Search Assessment - Operations Log */\n"
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
		if i < main_array.size():
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
	code += "        stack.push(0);\n\n"
	code += "        while(!stack.isEmpty()) {\n"
	code += "            int curr = stack.pop();\n"
	code += "            \n"
	code += "            if(curr >= size || visited[curr]) continue;\n"
	code += "            visited[curr] = true;\n"
	code += "            \n"
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
	code += "            if(right < size && !visited[right])\n"
	code += "                stack.push(right);\n"
	code += "            if(left < size && !visited[left])\n"
	code += "                stack.push(left);\n"
	code += "        }\n"
	code += "    }\n"
	code += "}"
	return code

func _gen_c_code() -> String:
	var code = "/* DFS Tree Search Assessment - Operations Log */\n"
	code += "#include <stdio.h>\n#include <stdbool.h>\n\n"
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
		if i < main_array.size():
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
	code += "    int stack[100];\n"
	code += "    int top = -1;\n"
	code += "    bool visited[7] = {false};\n"
	code += "    stack[++top] = 0;\n\n"
	code += "    while(top >= 0) {\n"
	code += "        int curr = stack[top--];\n"
	code += "        \n"
	code += "        if(curr >= size || visited[curr]) continue;\n"
	code += "        visited[curr] = true;\n"
	code += "        \n"
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
	code += "        if(right < size && !visited[right])\n"
	code += "            stack[++top] = right;\n"
	code += "        if(left < size && !visited[left])\n"
	code += "            stack[++top] = left;\n"
	code += "    }\n\n"
	code += "    return 0;\n}"
	return code

# =======================================================
# CODE POPUP FUNCTIONS (Adapted from Lecture)
# =======================================================

var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

# 1. C++ DATA (DFS)
var cpp_tutorial_data = [
	{ "lines": [0, 1, 2, 3], "text": "1. Imports & Setup:\nIncludes standard Stack library." },
	{ "lines": [5, 6, 7, 8, 9], "text": "2. Complexity Analysis:\n[color=yellow]Time: O(V + E)[/color] and [color=green]Space: O(V)[/color]." },
	{ "lines": [10, 11, 12], "text": "3. Initialization:\nCreate a Stack and push the root index (0)." },
	{ "lines": [14, 15, 16], "text": "4. The Loop:\nWhile stack isn't empty, pop the top element." },
	{ "lines": [18, 19], "text": "5. Check Target:\nIf current node matches target, return TRUE." },
	{ "lines": [21, 22, 23], "text": "6. Push Children:\nPush Right then Left child so Left is processed next (LIFO)." }
]

# 2. PYTHON DATA (DFS)
var python_tutorial_data = [
	{ "lines": [0], "text": "1. Function:\nDefine DFS taking tree list and target." },
	{ "lines": [1], "text": "2. Complexity:\n[color=yellow]Time: O(V + E)[/color] | [color=green]Space: O(V)[/color]." },
	{ "lines": [2], "text": "3. Initialization:\nStart stack with root index 0." },
	{ "lines": [4, 5], "text": "4. Processing:\nPop the last element (LIFO) from stack." },
	{ "lines": [6, 7, 8, 9], "text": "5. Target Check:\nSkip invalid nodes, return True if found." },
	{ "lines": [11, 12, 13], "text": "6. Push Children:\nAppend Right then Left so Left is popped first." }
]

# 3. JAVA DATA (DFS)
var java_tutorial_data = [
	{ "lines": [0], "text": "1. Imports:\nImport java.util.Stack." },
	{ "lines": [3, 4, 5, 6], "text": "2. Complexity:\n[color=yellow]Time: O(V + E)[/color] | [color=green]Space: O(V)[/color]." },
	{ "lines": [7, 8, 9], "text": "3. Initialization:\nCreate Stack and push root." },
	{ "lines": [11, 12], "text": "4. Dequeue:\nPop the top element." },
	{ "lines": [14, 15], "text": "5. Target Check:\nReturn true if target is found." },
	{ "lines": [17, 18], "text": "6. Push Children:\nPush Right then Left child indices." }
]

# 4. C DATA (DFS)
var c_tutorial_data = [
	{ "lines": [2], "text": "1. Complexity:\n[color=yellow]Time: O(V + E)[/color] | [color=green]Space: O(V)[/color]." },
	{ "lines": [3, 4, 5, 6], "text": "2. Stack Setup:\nArray-based stack implementation." },
	{ "lines": [8, 9], "text": "3. Initialization:\nPush root index (0) to start." },
	{ "lines": [10, 11, 12, 13], "text": "4. Pop & Check:\nPop top node and check if it matches target." },
	{ "lines": [15, 16], "text": "5. Push Children:\nPush right child, then left child." }
]

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	if complete_popup: complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

func _show_cpp_popup() -> void:
	match current_code_language:
		"cpp": current_tutorial_data = cpp_tutorial_data
		"python": current_tutorial_data = python_tutorial_data
		"java": current_tutorial_data = java_tutorial_data
		"c": current_tutorial_data = c_tutorial_data
	
	var arr_str = ""
	for i in range(7):
		if tree_nodes.size() > i and tree_nodes[i] != null:
			arr_str += str(main_array[i]) + ","
		else:
			arr_str += "-1,"
	
	var current_size = main_array.size()
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
		var arr_str = ""
		for i in range(7):
			if tree_nodes.size() > i and tree_nodes[i] != null:
				arr_str += str(main_array[i]) + ","
			else:
				arr_str += "-1,"
		
		var current_size = main_array.size()
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

# --- DFS CODE STRINGS (Iterative) ---

func generate_code_in_language(lang: String, arr_str: String, size: int, target: int) -> String:
	match lang:
		"python": return get_python_dfs_code(arr_str, target)
		"java": return get_java_dfs_code(arr_str, size, target)
		"c": return get_c_dfs_code(arr_str, size, target)
		_: return get_cpp_dfs_code(arr_str, size, target)

func get_cpp_dfs_code(arr: String, size: int, target: int) -> String:
	return """#include <iostream>
#include <stack>
using namespace std;

/*
 * COMPLEXITY:
 * Time: O(V + E)
 * Space: O(V)
 */
bool DFS(int tree[], int size, int target) {
	stack<int> s;
	s.push(0); // Start at root
	
	while(!s.empty()) {
		int curr = s.top();
		s.pop();
		
		if(curr >= size || tree[curr] == -1) continue;
		
		if(tree[curr] == target) return true;
		
		// Push Right then Left
		s.push(2 * curr + 2);
		s.push(2 * curr + 1);
	}
	return false;
}

int main() {
	int tree[] = { %s };
	int target = %d;
	if (DFS(tree, %d, target)) cout << "Found";
	return 0;
}""" % [arr, target, size]

func get_python_dfs_code(arr: String, target: int) -> String:
	return """def dfs(tree, target):
	# Time: O(V + E) | Space: O(V)
	stack = [0]  # Index 0
	
	while stack:
		curr = stack.pop()
		if curr >= len(tree) or tree[curr] == -1:
			continue
		
		if tree[curr] == target:
			return True
		
		# Append Right then Left
		stack.append(2 * curr + 2)
		stack.append(2 * curr + 1)
	
	return False

tree = [%s]
target = %d
print(dfs(tree, target))""" % [arr, target]

func get_java_dfs_code(arr: String, size: int, target: int) -> String:
	return """import java.util.Stack;

class DFS {
	/*
	 * Time: O(V + E)
	 * Space: O(V)
	 */
	static boolean dfs(int[] tree, int target) {
		Stack<Integer> s = new Stack<>();
		s.push(0);
		
		while(!s.isEmpty()) {
			int curr = s.pop();
			if(curr >= tree.length || tree[curr] == -1) continue;
			
			if(tree[curr] == target) return true;
			
			s.push(2 * curr + 2);
			s.push(2 * curr + 1);
		}
		return false;
	}
	
	public static void main(String[] args) {
		int[] tree = {%s};
		int target = %d;
		System.out.println(dfs(tree, target));
	}
}""" % [arr, target]

func get_c_dfs_code(arr: String, size: int, target: int) -> String:
	return """#include <stdio.h>

/* Time: O(V+E) | Space: O(V) */
int stack[100];
int top = -1;

void push(int v) { stack[++top] = v; }
int pop() { return stack[top--]; }

int dfs(int tree[], int size, int target) {
	push(0);
	
	while(top >= 0) {
		int curr = pop();
		if(curr >= size || tree[curr] == -1) continue;
		
		if(tree[curr] == target) return 1;
		
		push(2*curr+2); // Right
		push(2*curr+1); // Left
	}
	return 0;
}

int main() {
	int tree[] = {%s};
	int target = %d;
	printf(dfs(tree, %d, target) ? "Found" : "Not Found");
}""" % [arr, target, size]

# =======================================================
# TUTORIAL FUNCTIONS
# =======================================================

func start_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	
	_set_main_ui_enabled(false)
	
	tutorial_overlay.show()
	dim_bg.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{
			"node": array_container,
			"title": "TREE NODES",
			"text": "Tap any node to reveal its number.\nYou must follow DFS order: Root → Left subtree → Right subtree",
			"action": "highlight"
		},
		{
			"node": match_btn,
			"title": "MATCH BUTTON",
			"text": "When you think you've found the target, tap this.\nIf correct, you win! If wrong, it counts as a mistake.",
			"action": "highlight"
		},
		{
			"node": undo_btn,
			"title": "UNDO",
			"text": "Reverts your last tap. Useful if you tapped wrong!",
			"action": "highlight"
		},
		{
			"node": redo_btn,
			"title": "REDO",
			"text": "Reapplies an undone tap.",
			"action": "highlight"
		},
		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View your move history.",
			"action": "highlight"
		},
		{
			"node": target_label,
			"title": "TARGET DISPLAY",
			"text": "Shows the number you need to find in the tree.",
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
	tutorial_box.visible = true
	tutorial_text.visible = true
	tutorial_next.visible = true
	
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

func _on_next_button_pressed():
	tutorial_sequence_index += 1
	show_tutorial_step()

func end_tutorial():
	tutorial_in_progress = false
	tutorial_overlay.hide()
	_set_main_ui_enabled(true)
	
	if pointer_sprite:
		pointer_sprite.hide()
		if pointer_sprite.has_meta("tween"):
			pointer_sprite.get_meta("tween").kill()

# =======================================================
# INTRO POPUP FUNCTIONS
# =======================================================

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
		_start_assessment_timer()  # Start timer when intro finishes

func _on_intro_prev_pressed():
	btn_sound.play()
	if intro_step > 0:
		intro_step -= 1
		_update_intro_text()

func _on_intro_skip_pressed():
	btn_sound.play()
	intro_popup.hide()
	_set_main_ui_enabled(true)
	_start_assessment_timer()  # Start timer when intro is skipped

# Add this new function
func _start_assessment_timer():
	timer_running = true
	match_btn.disabled = false
	undo_btn.disabled = true  # Still disabled until first move
	redo_btn.disabled = true
	if status_label:
		status_label.text = "Tap nodes in DFS order"

# =======================================================
# UTILITY FUNCTIONS
# =======================================================

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

func _set_main_ui_enabled(enabled: bool) -> void:
	if match_btn: match_btn.disabled = not enabled
	if undo_btn: undo_btn.disabled = not enabled
	if redo_btn: redo_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled

# =======================================================
# BUTTON CALLBACKS (Minimal)
# =======================================================

func _on_cpp_close_pressed(): 
	btn_sound.play()
	cpp_popup.hide()

func _on_cpp_code_button_pressed(): 
	btn_sound.play()
	_show_cpp_popup()

func _on_complete_ok_pressed(): 
	btn_sound.play()
	complete_popup.hide()

func _on_help_button_pressed(): 
	btn_sound.play()
	start_tutorial()

func _on_close_button_pressed() -> void:
	btn_sound.play()
	timeline_popup.hide()
