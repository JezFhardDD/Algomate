extends Control

# --- 1. NODE REFERENCES ---

@onready var dequeue_btn: Button = $VBoxContainer/Searchstep
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew
@onready var auto_search_btn: Button = $VBoxContainer/Searchstep2

# --- STATE VARIABLES ---
var is_searching: bool = false
var is_auto_playing: bool = false
var has_target: bool = false  # Track if target is set

@onready var enqueue_label: Label = $HBoxContainer/Label
@onready var dequeue_label: Label = $HBoxContainer2/Label
@onready var queue_container: Control = $QueueContainer

# --- INPUT POPUP NODES ---
@onready var search_modal: ConfirmationDialog = get_node_or_null("SearchInputModal")
@onready var target_spinbox: SpinBox = get_node_or_null("SearchInputModal/TargetSpinBox")

# Popups
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label

@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: Label = $TimelinePopup/ScrollContainer/VBoxContainer/Label

@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var process_label: Label = $SimulationCompletePopup/VBoxContainer/ProcessLabel

# C++ Popup
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_label: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/CodeScroll/CodeLabel") as RichTextLabel
@onready var cpp_scroll: ScrollContainer = get_node_or_null("CppPopup/VBoxContainer/CodeScroll")
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/close") as Button
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")

# --- COMPILER INTEGRATION ---
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CompileButton")

# C++ Tutorial Nodes
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_lbl: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")
@onready var cpp_next_btn: Button = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/CppNextButton")

# Main Tutorial Nodes
@onready var tutorial_overlay: CanvasLayer = $TutorialOverlay
@onready var dim_bg: ColorRect = $TutorialOverlay/DimBackground
@onready var tutorial_box: Panel = $TutorialOverlay/TutorialBox
@onready var tutorial_text: Label = $TutorialOverlay/TutorialBox/TutorialText
@onready var tutorial_next: Button = $TutorialOverlay/TutorialBox/NextButton
@onready var pointer_sprite: Sprite2D = $TutorialOverlay/PointerSprite
@onready var help_btn: Button = get_node_or_null("HelpButton")

# Config Modals
@onready var config_modal: Panel = $ConfigChoiceModal
@onready var yes_btn: Button = $ConfigChoiceModal/yesButton
@onready var no_btn: Button = $ConfigChoiceModal/NoButton

@onready var config_size_modal: Panel = $ConfigSizeModal
@onready var size_input: SpinBox = $ConfigSizeModal/SizeSpinBox
@onready var size_back_btn: Button = $ConfigSizeModal/BackButton
@onready var size_next_btn: Button = $ConfigSizeModal/NextButton
@onready var elements_input: LineEdit = get_node_or_null("ConfigSizeModal/ElementsInput")
@onready var random_elements_btn: Button = get_node_or_null("ConfigSizeModal/RandomButton")

@onready var Queue_full: Panel = get_node_or_null("Queue_full")
@onready var anim_sprite: AnimatedSprite2D = get_node_or_null("Queue_full/AnimatedSprite2D")

@onready var config_elements_modal: Panel = $ConfigElementsModal
@onready var elements_container: VBoxContainer = $ConfigElementsModal/ScrollContainer/VBoxContainer
@onready var elements_back_btn: Button = $ConfigElementsModal/BackButton
@onready var elements_done_btn: Button = $ConfigElementsModal/DoneButton

# Visual Assets
@onready var low_icon: Node = $TextureRect/front
@onready var high_icon: Node = $TextureRect/rear
@onready var probe_arrow: Sprite2D = get_node_or_null("TextureRect/PivotArrow")

# Binary Search Visual Assets
@onready var binary_low_icon: Sprite2D = get_node_or_null("TextureRect/BinaryLow")
@onready var binary_high_icon: Sprite2D = get_node_or_null("TextureRect/BinaryHigh")
@onready var binary_mid_icon: Sprite2D = get_node_or_null("TextureRect/BinaryMid")

@onready var audio_player = $bgm
@onready var btn_sound = $btn_sound

@onready var intro_popup: Panel = $TutorialOverlay/Intro_popup
@onready var intro_label: Label = $TutorialOverlay/Intro_popup/Label
@onready var intro_next_btn: Button = $TutorialOverlay/Intro_popup/next
@onready var intro_skip_btn: Button = $TutorialOverlay/Intro_popup/skip
@onready var intro_prev_btn: Button = $TutorialOverlay/Intro_popup/prev

#simulate new confirmation
@onready var sim_new_confirmation: Panel = $SimNewConfirmation
@onready var sim_yes: Button = $SimNewConfirmation/YesBtn
@onready var sim_no: Button = $SimNewConfirmation/NoBtn

# --- LANGUAGE BUTTONS ---
@onready var cpp_lang_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/Cpp_btn")
@onready var python_lang_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/Py_btn")
@onready var java_lang_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/Java_btn")
@onready var c_lang_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/C_btn")

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

# --- 2. CONFIGURATION ---
const BLOCK_SCENE := preload("res://BubbleBlock.tscn")
const RESULT_POPUP_SCENE := preload("res://scene/ResultPopup.tscn")

var MAX_SIZE: int = 6
var START_POSITION: Vector2 = Vector2(80, 80)
var BLOCK_SPACING: float = 30.0

# --- 3. STATE VARIABLES ---
var array_data: Array[int] = []
var log_history: Array[String] = []
var comparison_count: int = 0

# Binary Search variables for comparison
var binary_low: int = 0
var binary_high: int = 0
var binary_mid: int = 0
var binary_comparisons: int = 0
var show_binary_comparison: bool = true

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

# Interpolation Search Variables
var low: int = 0
var high: int = 0
var pos: int = 0
var target_value: int = -1
var current_action_text: String = ""

# Formula visualization
var current_ratio: float = 0.0
var current_numerator: int = 0
var current_denominator: int = 0

# Tutorial
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

var intro_step: int = 0
var element_inputs: Array[LineEdit] = []

var intro_texts = [
	"Welcome to Interpolation Search!\n\nUnlike Binary Search which always checks the middle, Interpolation Search estimates where the target might be based on its value.",
	"The Formula:\n\npos = low + ((target - arr[low]) * (high - low)) / (arr[high] - arr[low])\n\nIt's like looking up a word in a dictionary - you don't start in the middle, you guess based on the letters!",
	"How it works:\n1. Calculate a probe position using the formula\n2. If the value matches, FOUND!\n3. If too small, search right (low = pos + 1)\n4. If too big, search left (high = pos - 1)",
	"Best for UNIFORM data:\n• Time Complexity: O(log(log n)) average\n• Space Complexity: O(1)\n• Becomes O(n) in worst case with clustered data",
	"We'll also show Binary Search side-by-side so you can compare how they work differently!"
]

var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = [] 

var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Imports & Setup: Standard headers for input/output." },
	{ "lines": [3], "text": "2. Complexity: [color=yellow]O(log(log n))[/color] Average Time and [color=green]O(1)[/color] Space." },
	{ "lines": [5], "text": "3. Initialization: Start with 'low' at 0 and 'high' at the last index." },
	{ "lines": [6], "text": "4. Loop Condition: Continue while target 'x' is within the bounds." },
	{ "lines": [7, 8, 9, 10], "text": "5. Edge Case: If low equals high, check value to prevent division by zero." },
	{ "lines": [11], "text": "6. The Probe Formula: Estimates position based on value." },
	{ "lines": [12, 13, 14], "text": "7. Evaluate: Return if found. Else, shrink range (low/high)." }
]

var python_tutorial_data = [
	{ "lines": [0], "text": "1. Complexity: [color=yellow]O(log(log n))[/color] Avg Time, [color=green]O(1)[/color] Space." },
	{ "lines": [1, 2], "text": "2. Setup: Define function and initialize low/high bounds." },
	{ "lines": [3], "text": "3. Condition: Loop while target 'x' is logically within bounds." },
	{ "lines": [4, 5, 6], "text": "4. Zero-Division Guard: If bounds are equal, check value and return." },
	{ "lines": [7], "text": "5. Probe Formula: Calculate the estimated index 'pos'." },
	{ "lines": [8, 9, 10], "text": "6. Adjust: Return if found, or update bounds." }
]

var java_tutorial_data = [
	{ "lines": [0], "text": "1. Complexity: [color=yellow]O(log(log n))[/color] Avg Time, [color=green]O(1)[/color] Space." },
	{ "lines": [1, 2, 3], "text": "2. Initialization: Method setup and defining low/high." },
	{ "lines": [4], "text": "3. Loop: Check if target 'x' is within current bounds." },
	{ "lines": [5, 6, 7, 8], "text": "4. Edge Case Guard: Prevent divide by zero error." },
	{ "lines": [9], "text": "5. Probe Formula: Standard interpolation math formula." },
	{ "lines": [10, 11, 12], "text": "6. Result: Check match or narrow search range." }
]

var c_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Setup & Complexity: Includes and [color=yellow]O(log(log n))[/color] Avg Time." },
	{ "lines": [2, 3], "text": "2. Setup: Standard array bounds initialization." },
	{ "lines": [4, 5, 6, 7, 8], "text": "3. Condition & Edge Case: Ensure valid range and guard against zero division." },
	{ "lines": [9], "text": "4. Formula: Compute estimated position." },
	{ "lines": [10, 11, 12], "text": "5. Adjust: Shrink range or return match." }
]

# --- 4. INITIALIZATION ---
func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	print("--- Interpolation Search Visualizer Started ---")
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
	
	if dequeue_btn: 
		dequeue_btn.text = "SET TARGET"
		dequeue_btn.disabled = true  # Disabled until array is ready
	
	if auto_search_btn:
		auto_search_btn.text = "Auto Search"
		auto_search_btn.disabled = true
	
	var old_history_btn = get_node_or_null("VBoxContainer/DequeuedElements")
	if old_history_btn: old_history_btn.hide()
	
	if tutorial_text:
		tutorial_text.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	
	_hide_pointers()
	_hide_binary_pointers()
	_connect_signals()
	_ready_tutorial_connection()
	
	config_modal.hide()
	if config_size_modal: config_size_modal.hide()
	if config_elements_modal: config_elements_modal.hide()
	
	# Setup compiler
	_setup_compiler()
	
	_show_config_modal()
	call_deferred("show_introduction")

func _hide_binary_pointers():
	if binary_low_icon: binary_low_icon.hide()
	if binary_high_icon: binary_high_icon.hide()
	if binary_mid_icon: binary_mid_icon.hide()

func _update_binary_pointers():
	if not show_binary_comparison: return
	
	if binary_low >= 0 and binary_low < queue_container.get_child_count():
		var block = queue_container.get_child(binary_low)
		var target_pos = block.global_position
		target_pos.x += block.size.x / 2.0
		target_pos.y += 50
		if binary_low_icon:
			create_tween().tween_property(binary_low_icon, "global_position", target_pos, 0.2).set_trans(Tween.TRANS_CUBIC)
			binary_low_icon.show()
	
	if binary_high >= 0 and binary_high < queue_container.get_child_count():
		var block = queue_container.get_child(binary_high)
		var target_pos = block.global_position
		target_pos.x += block.size.x / 2.0
		target_pos.y += 50
		if binary_high_icon:
			create_tween().tween_property(binary_high_icon, "global_position", target_pos, 0.2).set_trans(Tween.TRANS_CUBIC)
			binary_high_icon.show()
	
	if binary_mid >= 0 and binary_mid < queue_container.get_child_count():
		var block = queue_container.get_child(binary_mid)
		var target_pos = block.global_position
		target_pos.x += block.size.x / 2.0
		target_pos.y += 80
		if binary_mid_icon:
			create_tween().tween_property(binary_mid_icon, "global_position", target_pos, 0.2).set_trans(Tween.TRANS_CUBIC)
			binary_mid_icon.show()

func _reset_binary_search():
	binary_low = 0
	binary_high = array_data.size() - 1
	binary_comparisons = 0
	_update_binary_pointers()

func _simulate_binary_search_step():
	if not show_binary_comparison or binary_low > binary_high:
		return
	
	binary_mid = binary_low + (binary_high - binary_low) / 2
	binary_comparisons += 1
	
	var mid_val = array_data[binary_mid]
	
	# Add to log
	log_history.append("🔍 BINARY SEARCH: Checking middle index %d = %d" % [binary_mid, mid_val])
	
	# Visual feedback
	if binary_mid >= 0 and binary_mid < queue_container.get_child_count():
		var blk = queue_container.get_child(binary_mid)
		var tw = create_tween()
		tw.tween_property(blk, "scale", Vector2(1.15, 1.15), 0.15)
		tw.tween_property(blk, "scale", Vector2(1.0, 1.0), 0.15)
		blk.modulate = Color(0.8, 0.8, 0.2)  # Yellow tint for binary search
	
	if mid_val == target_value:
		log_history.append("✅ BINARY SEARCH: Found at index %d!" % binary_mid)
		return true
	elif mid_val < target_value:
		binary_low = binary_mid + 1
		log_history.append("→ BINARY SEARCH: %d < %d, search RIGHT (low = %d)" % [mid_val, target_value, binary_low])
	else:
		binary_high = binary_mid - 1
		log_history.append("→ BINARY SEARCH: %d > %d, search LEFT (high = %d)" % [mid_val, target_value, binary_high])
	
	_update_binary_pointers()
	return false

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
	if btn_sound: btn_sound.play()
	
	var code = generate_code_in_language(current_code_language, _array_to_string(array_data))
	
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
	
	print("=== Interpolation Search Compile Request ===")
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
	var code = generate_code_in_language(language, _array_to_string(array_data))
	_compile_code(code)


func _on_compiler_output_closed() -> void:
	print("Compiler output closed")


func reset_cache_for_scene() -> void:
	if compiler_output_popup:
		compiler_output_popup.reset_cache_for_scene()
		print("Compiler cache reset for new simulation")

func _connect_signals() -> void:
	if not dequeue_btn.is_connected("pressed", _on_search_step_pressed): dequeue_btn.pressed.connect(_on_search_step_pressed)
	if not timeline_btn.is_connected("pressed", _on_timeline_pressed): timeline_btn.pressed.connect(_on_timeline_pressed)
	if not simulate_new_btn.is_connected("pressed", _on_reset_pressed): simulate_new_btn.pressed.connect(_on_reset_pressed)
	if auto_search_btn:
		if not auto_search_btn.is_connected("pressed", _on_auto_search_pressed):
			auto_search_btn.pressed.connect(_on_auto_search_pressed)
	if yes_btn: yes_btn.pressed.connect(_on_config_yes)
	if no_btn: no_btn.pressed.connect(_on_config_no)
	if random_elements_btn: random_elements_btn.pressed.connect(_gen_random_config)
	if size_next_btn: size_next_btn.pressed.connect(_on_size_next_pressed)
	if size_back_btn: size_back_btn.pressed.connect(_on_config_cancel)
	
	if elements_done_btn: elements_done_btn.pressed.connect(_on_elements_done_pressed)
	if elements_back_btn: elements_back_btn.pressed.connect(_on_elements_back_pressed)
	
	if size_input:
		if not size_input.is_connected("value_changed", _on_size_spinbox_changed):
			size_input.value_changed.connect(_on_size_spinbox_changed)
	
	if search_modal:
		if not search_modal.is_connected("confirmed", _on_target_confirmed):
			search_modal.confirmed.connect(_on_target_confirmed)
	
	if complete_ok_btn: complete_ok_btn.pressed.connect(func(): complete_popup.hide())
	if show_cpp_btn: show_cpp_btn.pressed.connect(_show_cpp_popup)
	if cpp_code_button: cpp_code_button.pressed.connect(_show_cpp_popup)
	
	if cpp_close_btn: cpp_close_btn.pressed.connect(func(): cpp_popup.hide())
	
	if cpp_next_btn:
		if not cpp_next_btn.is_connected("pressed", _on_cpp_next_button_pressed):
			cpp_next_btn.pressed.connect(_on_cpp_next_button_pressed)

	if cpp_lang_btn: cpp_lang_btn.pressed.connect(func(): _set_language("cpp"))
	if python_lang_btn: python_lang_btn.pressed.connect(func(): _set_language("python"))
	if java_lang_btn: java_lang_btn.pressed.connect(func(): _set_language("java"))
	if c_lang_btn: c_lang_btn.pressed.connect(func(): _set_language("c"))

func _set_language(lang: String):
	if btn_sound: btn_sound.play()
	current_code_language = lang
	_show_cpp_popup()

# --- 5. CONFIGURATION ---
func _show_config_modal(): config_modal.show()
func _on_config_yes(): config_modal.hide(); _show_detailed_config()

func _on_config_no():
	# Reset cache for new simulation
	reset_cache_for_scene()
	
	MAX_SIZE = randi_range(5, 7)
	var rnd: Array[int] = []
	for i in range(MAX_SIZE):
		rnd.append(randi_range(1, 99))
	config_modal.hide()
	_init_simulation(rnd)

func show_introduction():
	if tutorial_overlay: tutorial_overlay.show()
	if not intro_popup: return
	intro_popup.show()
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
	if btn_sound: btn_sound.play()
	if intro_step < intro_texts.size() - 1:
		intro_step += 1
		_update_intro_text()
	else:
		intro_popup.hide()

func _on_intro_prev_pressed():
	if btn_sound: btn_sound.play()
	if intro_step > 0:
		intro_step -= 1
		_update_intro_text()

func _on_intro_skip_pressed():
	if btn_sound: btn_sound.play()
	intro_popup.hide()

func _on_size_next_pressed() -> void:
	if btn_sound: btn_sound.play()
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
		
		var label = Label.new()
		label.text = "Value %d" % (i + 1)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

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
	if btn_sound: btn_sound.play()
	MAX_SIZE = int(size_input.value)
	var arr: Array[int] = []
	
	for line_edit in element_inputs:
		var txt = line_edit.text.strip_edges()
		if txt.is_valid_int():
			arr.append(int(txt))
		else:
			arr.append(randi_range(1, 99))
			
	config_elements_modal.hide()
	_init_simulation(arr)

func _on_elements_back_pressed() -> void:
	if btn_sound: btn_sound.play()
	config_elements_modal.hide()
	config_size_modal.show()

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

func _show_detailed_config():
	size_input.min_value = 5
	size_input.max_value = 7
	size_input.value = 5
	_gen_random_config()
	config_size_modal.show()

func _on_size_spinbox_changed(new_val: float) -> void:
	_gen_random_config()

func _gen_random_config():
	var sz = int(size_input.value)
	var arr = []
	for i in range(sz): arr.append(str(randi_range(1,99)))
	if elements_input: elements_input.text = ", ".join(arr)

func _on_config_cancel():
	config_size_modal.hide()
	config_modal.show()

func _init_simulation(data: Array[int]):
	# Reset cache for new simulation
	reset_cache_for_scene()
	
	# Clear code lines
	code_lines.clear()
	
	# Reset target and search state
	has_target = false
	is_searching = false
	target_value = -1
	
	if audio_player: audio_player.play()
	
	# Sort data immediately and push to array_data
	data.sort()
	array_data = data.duplicate()
	log_history.clear()
	log_history.append("Array generated and sorted: %s" % _array_to_string(array_data))
	
	# Reset binary search
	_reset_binary_search()
	
	# Add initial code line
	_add_code_line("INITIAL", 0, 0)
	
	_spawn_all_blocks()
	
	# Enable set target button, disable search buttons
	if dequeue_btn:
		dequeue_btn.disabled = false
		dequeue_btn.text = "SET TARGET"
	if auto_search_btn:
		auto_search_btn.disabled = true
	
	_update_ui()
	if cpp_code_button: cpp_code_button.hide()

func _spawn_all_blocks():
	for i in range(array_data.size()):
		var val = array_data[i]
		
		var blk = BLOCK_SCENE.instantiate()
		blk.set("value", val)
		
		var block_width = 64.0
		var target_x = START_POSITION.x + i * (block_width + BLOCK_SPACING)
		var target_pos = Vector2(target_x, START_POSITION.y)

		var base_col = Color(1, 0.6, 0.2)
		if blk.has_method("set_base_color"): blk.set_base_color(base_col)
		else: blk.modulate = base_col
		
		queue_container.add_child(blk)
		
		# Animate them appearing all at once with a slight drop effect
		blk.position = target_pos + Vector2(0, -30)
		blk.modulate.a = 0
		
		var tw = create_tween().set_parallel(true)
		tw.tween_property(blk, "position", target_pos, 0.4).set_trans(Tween.TRANS_CUBIC).set_delay(i * 0.05)
		tw.tween_property(blk, "modulate:a", 1.0, 0.3).set_delay(i * 0.05)

# --- 6. EDUCATIONAL INTERPOLATION SEARCH LOGIC ---

func _on_search_step_pressed():
	if array_data.size() < 1: return
	
	# If no target is set, open the modal to set target
	if not has_target:
		if search_modal:
			search_modal.popup_centered()
		return
	
	# If we're not searching but have target, start the search
	if not is_searching:
		_start_search_process()
		return
	
	# If we're already searching, execute ONE step
	if btn_sound: btn_sound.play()
	_execute_search_step()

func _on_target_confirmed():
	if btn_sound: btn_sound.play()
	if target_spinbox:
		target_value = int(target_spinbox.value)
		has_target = true
		
		# Change button text to "SEARCH STEP"
		if dequeue_btn:
			dequeue_btn.text = "SEARCH STEP"
		
		# Enable auto search button
		if auto_search_btn:
			auto_search_btn.disabled = false
		
		# Show target value in UI
		if enqueue_label:
			enqueue_label.text = "🎯 Target: %d (Click Search Step to begin)" % target_value
		
		# Reset binary search for comparison
		_reset_binary_search()
		
		show_feedback("Target set to %d! Click SEARCH STEP to begin." % target_value, Color.GREEN, Vector2(200, 200))

func _start_search_process():
	is_searching = true
	comparison_count = 0
	
	# Reset binary search
	_reset_binary_search()
	
	# Reset all block colors
	for i in range(queue_container.get_child_count()):
		var blk = queue_container.get_child(i)
		blk.modulate = Color(1, 0.6, 0.2)
	
	# Add code line for target
	_add_code_line("TARGET", 0, target_value)
	
	low = 0
	high = array_data.size() - 1
	
	log_history.append("\n=== INTERPOLATION SEARCH STARTED ===")
	log_history.append("Target: %d" % target_value)
	log_history.append("Array: %s" % _array_to_string(array_data))
	log_history.append("Initial range: indices [%d, %d] = values [%d, %d]" % [low, high, array_data[low], array_data[high]])
	current_action_text = "Click SEARCH STEP to start searching for %d" % target_value
	
	if low_icon: low_icon.show()
	if high_icon: high_icon.show()
	if probe_arrow: probe_arrow.hide()
	
	_update_pointers()
	_update_ui()
	
	# Show educational message - TELL USER WHAT TO DO NEXT
	show_feedback("Ready! Click SEARCH STEP to see the first probe calculation.", Color.GREEN, Vector2(200, 200))

func _execute_search_step():
	# Check if we're still in a valid search range
	if low <= high and target_value >= array_data[low] and target_value <= array_data[high]:
		
		# Calculate formula components for visualization
		current_numerator = (target_value - array_data[low]) * (high - low)
		current_denominator = array_data[high] - array_data[low]
		
		if current_denominator == 0:
			pos = low
			current_ratio = 0.5
			current_action_text = "⚠ All values equal in range - using middle position"
		else:
			# Calculate position using the interpolation formula
			var pos_float = float(low) + (float(target_value - array_data[low]) * float(high - low)) / float(current_denominator)
			pos = int(pos_float)
			pos = clamp(pos, low, high)
			current_ratio = float(target_value - array_data[low]) / float(current_denominator)
		
		comparison_count += 1
		var pos_val = array_data[pos]
		
		# BUILD EDUCATIONAL FORMULA DISPLAY - SHOW FULL CALCULATION
		var formula_text = "📐 STEP %d - INTERPOLATION FORMULA:\n" % comparison_count
		formula_text += "pos = low + ((target - arr[low]) × (high - low)) / (arr[high] - arr[low])\n"
		formula_text += "    = %d + ((%d - %d) × (%d - %d)) / (%d - %d)\n" % [low, target_value, array_data[low], high, low, array_data[high], array_data[low]]
		formula_text += "    = %d + (%d × %d) / %d\n" % [low, (target_value - array_data[low]), (high - low), current_denominator]
		formula_text += "    = %d + %d / %d\n" % [low, current_numerator, current_denominator]
		
		if current_denominator != 0:
			formula_text += "    = %d + %.2f\n" % [low, current_ratio * (high - low)]
			formula_text += "    = %.2f → [color=yellow]pos = %d[/color]" % [low + current_ratio * (high - low), pos]
		
		# Add to log
		log_history.append(formula_text)
		log_history.append("Checking arr[%d] = %d" % [pos, pos_val])
		
		# SIMULATE ONE BINARY SEARCH STEP FOR COMPARISON
		var binary_found = _simulate_binary_search_step()
		
		# Add code line for probe
		_add_code_line("PROBE", pos, pos_val)
		
		if probe_arrow: probe_arrow.show()
		_update_pointers()
		
		# Visual feedback for current block
		var blk = queue_container.get_child(pos)
		var tw = create_tween()
		tw.tween_property(blk, "scale", Vector2(1.2, 1.2), 0.2)
		tw.tween_property(blk, "scale", Vector2(1.0, 1.0), 0.2)
		blk.modulate = Color(1, 0.8, 0)  # Orange highlight
		
		# Highlight the probe arrow with color based on ratio
		if probe_arrow:
			if current_ratio < 0.33:
				probe_arrow.modulate = Color(1, 0.5, 0)  # Orange - left side
			elif current_ratio > 0.66:
				probe_arrow.modulate = Color(1, 0, 0)  # Red - right side
			else:
				probe_arrow.modulate = Color(1, 1, 0)  # Yellow - middle
		
		# Check if found
		if pos_val == target_value:
			blk.modulate = Color(0.2, 1, 0.2)
			log_history.append("✅ FOUND! Target %d at index %d" % [pos_val, pos])
			log_history.append("Interpolation Search comparisons: %d" % comparison_count)
			log_history.append("Binary Search comparisons: %d" % binary_comparisons)
			
			_add_code_line("FOUND", pos, pos_val)
			_update_ui()
			_finish_simulation(true)
			return
			
		elif pos_val < target_value:
			var old_low = low
			low = pos + 1
			current_action_text = "→ Value %d < target %d → Search RIGHT\n📊 New range: [%d, %d]" % [pos_val, target_value, low, high]
			log_history.append(current_action_text)
			_add_code_line("MOVE_RIGHT", pos, pos_val)
			_dim_range(old_low, pos)
			
			# SHOW EDUCATIONAL MESSAGE - STOP HERE, WAIT FOR NEXT CLICK
			show_feedback("✅ Step %d complete! Click SEARCH STEP to continue." % comparison_count, Color.YELLOW, Vector2(200, 200))
			
		else:
			var old_high = high
			high = pos - 1
			current_action_text = "→ Value %d > target %d → Search LEFT\n📊 New range: [%d, %d]" % [pos_val, target_value, low, high]
			log_history.append(current_action_text)
			_add_code_line("MOVE_LEFT", pos, pos_val)
			_dim_range(pos, old_high)
			
			# SHOW EDUCATIONAL MESSAGE - STOP HERE, WAIT FOR NEXT CLICK
			show_feedback("✅ Step %d complete! Click SEARCH STEP to continue." % comparison_count, Color.YELLOW, Vector2(200, 200))
		
		_update_ui()
		
	else:
		# Search is complete - not found
		current_action_text = "❌ Target %d not in current range! Search complete." % target_value
		log_history.append(current_action_text)
		
		# Complete binary search simulation
		while binary_low <= binary_high:
			_simulate_binary_search_step()
		
		log_history.append("Interpolation Search comparisons: %d" % comparison_count)
		log_history.append("Binary Search comparisons: %d" % binary_comparisons)
		_add_code_line("NOT_FOUND", 0, target_value)
		_finish_simulation(false)

func _dim_range(from_idx: int, to_idx: int):
	for i in range(from_idx, to_idx + 1):
		if i >= 0 and i < queue_container.get_child_count():
			var blk = queue_container.get_child(i)
			create_tween().tween_property(blk, "modulate", Color(0.3, 0.3, 0.3, 0.6), 0.3)

func _finish_simulation(found: bool):
	# Stop auto-play
	is_searching = false
	is_auto_playing = false
	has_target = false
	
	if auto_search_btn:
		auto_search_btn.text = "Auto Search"
		auto_search_btn.disabled = true
	
	if dequeue_btn:
		dequeue_btn.text = "SET TARGET"
	
	var msg = ""
	if found:
		msg = "✅ SEARCH COMPLETE!\n\n"
		msg += "INTERPOLATION SEARCH:\n"
		msg += "• Target %d FOUND at index %d\n" % [target_value, pos]
		msg += "• Comparisons: %d\n\n" % comparison_count
		msg += "BINARY SEARCH (for comparison):\n"
		msg += "• Comparisons: %d\n\n" % binary_comparisons
	
	process_label.text = msg
	complete_popup.popup_centered()
	if cpp_code_button: cpp_code_button.show()
	
	# Reset target for next search
	target_value = -1
	if enqueue_label:
		enqueue_label.text = "Ready to Search"

func _compute_grade(found: bool) -> Dictionary:
	var passed = found
	var coins = 5 if passed else 0
	
	return {
		"passed": passed,
		"accuracy": 100.0 if passed else 0.0,
		"correct_moves": 1 if passed else 0,
		"bad_moves": comparison_count,
		"time_used": 0,
		"coins": coins,
		"required": 60
	}

# --- POINTER UPDATES ---
func _update_pointers():
	if not is_searching: return
	
	if low >= 0 and low < queue_container.get_child_count():
		var block = queue_container.get_child(low)
		var target_pos = block.global_position
		target_pos.x += block.size.x / 2.0
		target_pos.y -= 50
		create_tween().tween_property(low_icon, "global_position", target_pos, 0.2).set_trans(Tween.TRANS_CUBIC)
	
	if high >= 0 and high < queue_container.get_child_count():
		var block = queue_container.get_child(high)
		var target_pos = block.global_position
		target_pos.x += block.size.x / 2.0
		target_pos.y -= 50
		create_tween().tween_property(high_icon, "global_position", target_pos, 0.2).set_trans(Tween.TRANS_CUBIC)
		
	if probe_arrow and pos >= 0 and pos < queue_container.get_child_count():
		var block = queue_container.get_child(pos)
		var target_pos = block.global_position
		target_pos.x += block.size.x / 2.0
		target_pos.y -= 75
		create_tween().tween_property(probe_arrow, "global_position", target_pos, 0.2).set_trans(Tween.TRANS_CUBIC)

func _hide_pointers():
	if low_icon: low_icon.hide()
	if high_icon: high_icon.hide()
	if probe_arrow: probe_arrow.hide()

# --- RESET FUNCTION ---
func _on_reset_pressed():
	if btn_sound: btn_sound.play()
	sim_new_confirmation.show()

# --- HELPER FUNCTIONS ---
func _on_timeline_pressed():
	var timeline_content = "=== INTERPOLATION SEARCH TIMELINE ===\n\n"
	for entry in log_history:
		timeline_content += entry + "\n"
	timeline_label.text = timeline_content
	timeline_popup.popup_centered()

# --- CODE GENERATION FUNCTIONS ---

func _add_code_line(op: String, index: int, value: int) -> void:
	code_lines.append("%s|%d|%d" % [op, index, value])

func _array_to_string(arr: Array) -> String:
	var parts: Array[String] = []
	for v in arr:
		parts.append(str(v))
	return ", ".join(parts)

func _show_cpp_popup() -> void:
	if complete_popup: complete_popup.hide()
	var arr_str = _array_to_string(array_data)
	
	match current_code_language:
		"cpp": current_tutorial_data = cpp_tutorial_data
		"python": current_tutorial_data = python_tutorial_data
		"java": current_tutorial_data = java_tutorial_data
		"c": current_tutorial_data = c_tutorial_data
		
	var code = generate_code_in_language(current_code_language, arr_str)
	
	if cpp_label:
		cpp_label.bbcode_enabled = true
		cpp_label.text = code
	
	cpp_popup.popup_centered()
	cpp_tutorial_step = 0
	
	if cpp_tutorial_panel: cpp_tutorial_panel.show()
	_update_cpp_tutorial()

func _on_cpp_next_button_pressed() -> void:
	if btn_sound: btn_sound.play()
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
		var arr_str = _array_to_string(array_data)
		var code = generate_code_in_language(current_code_language, arr_str)
		
		var lines = code.split("\n")
		var highlighted_code = ""
		var indices = data["lines"]
		
		for i in range(lines.size()):
			if i in indices:
				highlighted_code += "[color=yellow]" + lines[i] + "[/color]\n"
			else:
				highlighted_code += lines[i] + "\n"
		
		cpp_label.bbcode_enabled = true
		cpp_label.text = highlighted_code
		
		if indices.size() > 0:
			call_deferred("_scroll_to_highlight", indices[0])

func _scroll_to_highlight(line_index: int) -> void:
	var target_scroll = line_index * 26
	
	if cpp_scroll:
		var tween = create_tween()
		tween.tween_property(cpp_scroll, "scroll_vertical", target_scroll, 0.2).set_trans(Tween.TRANS_SINE)
	elif cpp_label:
		var scrollbar = cpp_label.get_v_scroll_bar()
		if scrollbar:
			var tween = create_tween()
			tween.tween_property(scrollbar, "value", target_scroll, 0.2).set_trans(Tween.TRANS_SINE)

# --- INTERPOLATION SEARCH CODE STRINGS ---

# --- INTERPOLATION SEARCH CODE STRINGS WITH PROPER OUTPUT ---

func generate_code_in_language(lang: String, arr_str: String) -> String:
	match lang:
		"python": return get_python_interp_code(arr_str)
		"java": return get_java_interp_code(arr_str)
		"c": return get_c_interp_code(arr_str)
		_: return get_cpp_interp_code(arr_str)

func get_cpp_interp_code(arr: String) -> String:
	return """#include <iostream>
using namespace std;

/* Interpolation Search - O(log(log n)) average time */
int interpolationSearch(int arr[], int n, int x) {
    int low = 0, high = n - 1;
    
    while (low <= high && x >= arr[low] && x <= arr[high]) {
        // Probe formula: estimate position based on value
        int pos = low + ((x - arr[low]) * (high - low)) / (arr[high] - arr[low]);
        
        if (arr[pos] == x)
            return pos;  // Found!
        else if (arr[pos] < x)
            low = pos + 1;  // Search right
        else
            high = pos - 1;  // Search left
    }
    return -1;  // Not found
}

int main() {
    int arr[] = { %s };
    int n = sizeof(arr) / sizeof(arr[0]);
    int target = %d;
    
    // Print the array
    cout << "Initial array: [";
    for (int i = 0; i < n; i++) {
        cout << arr[i];
        if (i < n - 1) cout << ", ";
    }
    cout << "]" << endl;
    cout << "Searching for: " << target << endl << endl;
    
    int result = interpolationSearch(arr, n, target);
    
    if (result != -1)
        cout << "Found at index " << result << endl;
    else
        cout << "Not found" << endl;
        
    return 0;
}""" % [arr, target_value]

func get_python_interp_code(arr: String) -> String:
	return """# Interpolation Search - O(log(log n)) average time
def interpolation_search(arr, x):
    low = 0
    high = len(arr) - 1
    
    while low <= high and x >= arr[low] and x <= arr[high]:
        # Probe formula: estimate position based on value
        pos = low + ((x - arr[low]) * (high - low)) // (arr[high] - arr[low])
        
        if arr[pos] == x:
            return pos  # Found!
        elif arr[pos] < x:
            low = pos + 1  # Search right
        else:
            high = pos - 1  # Search left
    
    return -1  # Not found

def main():
    arr = [%s]
    target = %d
    
    # Print the array
    print("Initial array:", arr)
    print("Searching for:", target)
    print()
    
    result = interpolation_search(arr, target)
    
    if result != -1:
        print(f"Found at index {result}")
    else:
        print("Not found")

if __name__ == "__main__":
	main()""" % [arr, target_value]

func get_java_interp_code(arr: String) -> String:
	return """/* Interpolation Search - O(log(log n)) average time */
import java.util.*;

public class InterpolationSearch {
    public static int interpolationSearch(int[] arr, int x) {
        int low = 0;
        int high = arr.length - 1;
        
        while (low <= high && x >= arr[low] && x <= arr[high]) {
            // Probe formula: estimate position based on value
            int pos = low + ((x - arr[low]) * (high - low)) / (arr[high] - arr[low]);
            
            if (arr[pos] == x) {
                return pos;  // Found!
            } else if (arr[pos] < x) {
                low = pos + 1;  // Search right
            } else {
                high = pos - 1;  // Search left
            }
        }
        
        return -1;  // Not found
    }
}
    
    public static void main(String[] args) {
        int[] arr = {%s};
        int target = %d;
        
        // Print the array
        System.out.print("Initial array: [");
        for (int i = 0; i < arr.length; i++) {
            System.out.print(arr[i]);
            if (i < arr.length - 1) System.out.print(", ");
        }
        System.out.println("]");
        System.out.println("Searching for: " + target);
        System.out.println();
        
        int result = search(arr, target);
        
        if (result != -1)
            System.out.println("Found at index " + result);
        else
            System.out.println("Not found");
    }
}""" % [arr, target_value]

func get_c_interp_code(arr: String) -> String:
	return """#include <stdio.h>

int interpolationSearch(int arr[], int n, int x) {
    int low = 0;
    int high = n - 1;
    
    while (low <= high && x >= arr[low] && x <= arr[high]) {
        // Probe formula: estimate position based on value
        // Avoid division by zero
        if (arr[high] == arr[low]) {
            if (arr[low] == x) return low;
            else break;
        }
        
        int pos = low + ((x - arr[low]) * (high - low)) / (arr[high] - arr[low]);
        
        // Check if pos is within bounds
        if (pos < low || pos > high) break;
        
        if (arr[pos] == x) {
            return pos;  // Found!
        } else if (arr[pos] < x) {
            low = pos + 1;  // Search right
        } else {
            high = pos - 1;  // Search left
        }
    }
    
    return -1;  // Not found
}

int main() {
    int arr[] = {%s};
    int n = sizeof(arr) / sizeof(arr[0]);
    int target = %d;
    
    // Print the array
    printf("Initial array: [");
    for (int i = 0; i < n; i++) {
        printf("%d", arr[i]);
        if (i < n - 1) printf(", ");
    }
    printf("]\\n");
    printf("Searching for: %d\\n\\n", target);
    
    int result = interpolationSearch(arr, n, target);
    
    if (result != -1)
        printf("Found at index %d\\n", result);
    else
        printf("Not found\\n");
        
    return 0;
}""" % [arr, target_value]

# --- UI UPDATES ---
func _update_ui():
	if enqueue_label: 
		if has_target and not is_searching:
			enqueue_label.text = "🎯 Target: %d\nPress SEARCH STEP to begin" % target_value
			enqueue_label.add_theme_color_override("font_color", Color(1, 0.8, 0.2))
		elif is_searching:
			enqueue_label.text = "🎯 Searching for: %d\nStep %d" % [target_value, comparison_count]
			enqueue_label.add_theme_color_override("font_color", Color(1, 0.8, 0.2))
		else:
			enqueue_label.text = "⚙️ 1. Set Target\n2. Click SEARCH STEP"
			enqueue_label.add_theme_color_override("font_color", Color(1, 1, 1))
	
	if dequeue_label: 
		if is_searching:
			dequeue_label.text = "📊 Step %d\n%s" % [comparison_count, current_action_text]
		elif has_target:
			dequeue_label.text = "✅ Target: %d\nClick SEARCH STEP" % target_value
		else:
			dequeue_label.text = "📊 Ready - Set target first"

# --- AUTO-PLAY ---
func _on_auto_search_pressed():
	if array_data.is_empty(): return
	
	# If no target set, open modal
	if not has_target:
		if search_modal:
			search_modal.popup_centered()
		return
	
	# Show warning that auto mode is not step-by-step
	show_feedback("⚠️ Auto mode runs automatically. Use SEARCH STEP for step-by-step learning!", Color.ORANGE, Vector2(200, 200))
	
	if btn_sound: btn_sound.play()
	
	is_auto_playing = !is_auto_playing
	
	if auto_search_btn:
		auto_search_btn.text = "⏸ Pause" if is_auto_playing else "▶ Auto Search"
	
	if is_auto_playing:
		_run_auto_search()

func _run_auto_search():
	while is_auto_playing and is_searching:
		# Only execute ONE step
		_execute_search_step()
		
		# Check if search is complete
		if not is_searching:
			is_auto_playing = false
			if auto_search_btn: auto_search_btn.text = "▶ Auto Search"
			break
		
		# Wait longer between steps so students can see the formula
		await get_tree().create_timer(2.5).timeout

# --- TUTORIAL BOILERPLATE ---

func _ready_tutorial_connection():
	if help_btn and not help_btn.is_connected("pressed", _on_help_button_pressed):
		help_btn.pressed.connect(_on_help_button_pressed)
	if tutorial_next and not tutorial_next.is_connected("pressed", _on_tutorial_next_pressed):
		tutorial_next.pressed.connect(_on_tutorial_next_pressed)

func _on_help_button_pressed() -> void:
	if btn_sound: btn_sound.play()
	start_main_tutorial()

func start_main_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	if tutorial_overlay: tutorial_overlay.show()
	if dim_bg: dim_bg.show()
	if tutorial_box: tutorial_box.show()
	
	tutorial_sequence = [
		{ "node": null, "text": "🔍 INTERPOLATION SEARCH - LEARN STEP BY STEP\n\nWe'll go through each calculation one at a time so you can fully understand the formula!", "action": "next" },
		{ "node": dequeue_btn, "text": "1️ SET TARGET: First, click here to choose a number to search for", "action": "next" },
		{ "node": dequeue_btn, "text": "2️ SEARCH STEP: After setting target, click repeatedly to see each calculation step-by-step", "action": "next" },
		{ "node": null, "text": "3 FORMULA: Each step shows the complete formula with actual numbers!\n\npos = low + ((target - arr[low]) × (high - low)) / (arr[high] - arr[low])", "action": "next" },
		{ "node": timeline_btn, "text": "5 TIMELINE: Shows the complete formula calculation history", "action": "next" },
		{ "node": simulate_new_btn, "text": "7 SIMULATE NEW: Try different data to see when Interpolation Search works best!", "action": "end" }
	]
	show_tutorial_step()

func show_tutorial_step() -> void:
	if tutorial_sequence_index >= tutorial_sequence.size():
		end_main_tutorial()
		return
	var step = tutorial_sequence[tutorial_sequence_index]
	var node = step["node"]
	if tutorial_text: tutorial_text.text = step["text"]
	
	if node:
		if pointer_sprite:
			pointer_sprite.show()
			# Fix: Use global_position for Sprite2D instead of get_global_rect()
			if node is Control:
				var node_pos = node.global_position
				pointer_sprite.global_position = node_pos + Vector2(node.size.x / 2, 20)
			else:
				# For non-Control nodes, use their global_position
				pointer_sprite.global_position = node.global_position + Vector2(0, 20)
		_highlight_node(node)
	else:
		if pointer_sprite: pointer_sprite.hide()
		_clear_highlights()
	
	if tutorial_next:
		if step["action"] == "next":
			tutorial_next.show()
			tutorial_next.text = "Next"
		elif step["action"] == "end":
			tutorial_next.show()
			tutorial_next.text = "Finish"

# Also update the _highlight_node function to handle both Control and Node2D:
func _highlight_node(node: Node):
	_clear_highlights()
	if node:
		if node is Control:
			var tw = create_tween().set_loops()
			tw.tween_property(node, "modulate", Color(1.5, 1.5, 1.5), 0.5)
			tw.tween_property(node, "modulate", Color(1, 1, 1), 0.5)
			node.set_meta("tutorial_tween", tw)
		elif node is Node2D:
			var original_modulate = node.modulate if node.has_method("get_modulate") else Color(1, 1, 1)
			var tw = create_tween().set_loops()
			tw.tween_property(node, "modulate", Color(1.5, 1.5, 1.5), 0.5)
			tw.tween_property(node, "modulate", original_modulate, 0.5)
			node.set_meta("tutorial_tween", tw)

func _clear_highlights():
	var buttons = [dequeue_btn, timeline_btn, simulate_new_btn, auto_search_btn, low_icon, high_icon, probe_arrow]
	for b in buttons:
		if b and b.has_meta("tutorial_tween"):
			var tw = b.get_meta("tutorial_tween") as Tween
			if tw: tw.kill()
		if b and b is Control:
			b.modulate = Color(1, 1, 1)
		elif b and b is Node2D:
			b.modulate = Color(1, 1, 1)

func _on_tutorial_next_pressed() -> void:
	if btn_sound: btn_sound.play()
	tutorial_sequence_index += 1
	show_tutorial_step()

func end_main_tutorial() -> void:
	tutorial_in_progress = false
	if tutorial_overlay: tutorial_overlay.hide()
	_clear_highlights()

func _on_yes_btn_pressed() -> void:
	if btn_sound: btn_sound.play()
	for c in queue_container.get_children(): c.queue_free()
	array_data.clear(); log_history.clear()
	comparison_count = 0; is_searching = false
	has_target = false
	low = 0; high = 0; pos = 0
	target_value = -1
	current_action_text = ""
	_hide_pointers()
	_on_config_no()
	sim_new_confirmation.hide()

func _on_no_btn_pressed() -> void:
	if btn_sound: btn_sound.play()
	sim_new_confirmation.hide()

func _on_close_pressed() -> void:
	cpp_popup.hide()

# ==============================================
#   RESULT POPUP HANDLERS
# ==============================================

func _on_try_again_pressed() -> void:
	if btn_sound: btn_sound.play()
	result_popup.hide()
	_show_config_modal()

func _on_back_pressed() -> void:
	if btn_sound: btn_sound.play()
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
	else:
		result_title.text = "NOT FOUND"
		result_title.modulate = Color.RED
		if translate_code_btn:
			translate_code_btn.show()
		if cpp_code_button:
			cpp_code_button.show()

func _on_translate_code_pressed() -> void:
	if btn_sound: btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()

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

func check_jdoodle_credits():
	var keys = API_KEYS[current_code_language]
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_credit_check_completed)
	
	var url = "https://api.jdoodle.com/v1/credit-spent"
	var headers = ["Content-Type: application/json"]
	
	var body = JSON.new().stringify({
		"clientId": keys["clientId"],
		"clientSecret": keys["clientSecret"]
	})
	
	print("Checking credits for account: ", current_code_language)
	http_request.request(url, headers, HTTPClient.METHOD_POST, body)

func _on_credit_check_completed(result, response_code, headers, body):
	if response_code != 200:
		print("Failed to check credits: ", response_code)
		return
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.data
	
	print("=== CREDIT USAGE ===")
	print("Credits used today: ", response.get("used", "Unknown"))
	print("Remaining: ", 200 - response.get("used", 0))
