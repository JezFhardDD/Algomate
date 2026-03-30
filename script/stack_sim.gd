extends Control

# Node paths
@onready var enqueue_btn: Button = $VBoxContainer/EnqueueButton
@onready var dequeue_btn: Button = $VBoxContainer/DequeueButton
@onready var peek_btn: Button = $VBoxContainer/PeekButton  # NEW: Peek button
@onready var waiting_btn: Button = $VBoxContainer/WaitingElements
@onready var dequeued_btn: Button = $VBoxContainer/DequeuedElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew

@onready var enqueue_label: Label = $HBoxContainer/Label
@onready var dequeue_label: Label = $HBoxContainer2/Label
@onready var queue_container: Control = $QueueContainer

# NEW: Indicators
@onready var is_full_indicator: TextureRect = $ColorRect2/isFull  # TextureRect for full indicator
@onready var is_empty_indicator: TextureRect = $ColorRect2/isEmpty  # TextureRect for empty indicator

# NEW: Index labels
var index_labels: Array[Label] = []
var INDEX_LABEL_OFFSET: float = 80.0  # Offset for index labels (right of blocks)

# Panels
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label
@onready var dequeued_container: Control = $DequeuedContainer
@onready var dequeued_close_btn: Button = dequeued_container.get_node_or_null("CloseButton")

# Timeline popup
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: Label = $TimelinePopup/VBoxContainer/Label

# Simulation Complete popup
@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button

# C++ Popup
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_label: Label = get_node_or_null("CppPopup/VBoxContainer/Label") as Label
@onready var cpp_text: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/ScrollContainer/RichTextLabel") as RichTextLabel
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/Button") as Button

# --- COMPILER INTEGRATION ---
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = $CppPopup/VBoxContainer/HBoxContainer2/CompileButton

# Top-right shortcut button (NEW)
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")

# Queue block scene
const BLOCK_SCENE := preload("res://BubbleBlock.tscn")
const RESULT_POPUP_SCENE := preload("res://scene/ResultPopup.tscn")

# Front/Rear indicators
@onready var rear_icon: Node = $TextureRect/rear
@onready var front_icon: Node = $TextureRect/front
@onready var rear2_icon: Node = $TextureRect/rear2
@onready var front2_icon: Node = $TextureRect/front2

# Tutorial system
@onready var tutorial_overlay: CanvasLayer = $TutorialOverlay
@onready var dim_bg: ColorRect = $TutorialOverlay/DimBackground
@onready var tutorial_box: Panel = $TutorialOverlay/TutorialBox
@onready var tutorial_text: Label = $TutorialOverlay/TutorialBox/TutorialText
@onready var tutorial_next: Button = $TutorialOverlay/TutorialBox/NextButton
@onready var pointer_sprite: Sprite2D = $TutorialOverlay/PointerSprite
@onready var process_label: Label = $SimulationCompletePopup/VBoxContainer/ProcessLabel
@onready var audio_player = $bgm
@onready var btn_sound = $btn_sound

# CONFIGURATION MODALS
@onready var config_modal: Panel = $ConfigChoiceModal
@onready var yes_btn: Button = $ConfigChoiceModal/yesButton
@onready var no_btn: Button = $ConfigChoiceModal/NoButton

@onready var config_size_modal: Panel = $ConfigSizeModal
@onready var size_input: SpinBox = $ConfigSizeModal/SizeSpinBox
@onready var size_back_btn: Button = $ConfigSizeModal/BackButton
@onready var size_next_btn: Button = $ConfigSizeModal/NextButton
@onready var size_label: Label = $ConfigSizeModal/Label

@onready var config_elements_modal: Panel = $ConfigElementsModal
@onready var elements_container: VBoxContainer = $ConfigElementsModal/ScrollContainer/VBoxContainer
@onready var elements_back_btn: Button = $ConfigElementsModal/BackButton
@onready var elements_done_btn: Button = $ConfigElementsModal/DoneButton
@onready var elements_label: Label = $ConfigElementsModal/Label

# Programming languages buttons
@onready var cpp_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Cpp_btn
@onready var python_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Py_btn
@onready var java_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Java_btn
@onready var c_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/C_btn

# ==============================================
#   COMPILER INTEGRATION - API KEYS
# ==============================================
const API_KEYS = {
	"cpp": {
		"clientId": "29cb443cb807bccf8958679fa40067dc",
		"clientSecret": "ac4b99a6102b8b472e8da670798941ddbbd47148e97a554eccce100246ccb1ad"
	},
	"c": {
		"clientId": "29cb443cb807bccf8958679fa40067dc",
		"clientSecret": "ac4b99a6102b8b472e8da670798941ddbbd47148e97a554eccce100246ccb1ad"
	},
	"java": {
		"clientId": "29cb443cb807bccf8958679fa40067dc",
		"clientSecret": "ac4b99a6102b8b472e8da670798941ddbbd47148e97a554eccce100246ccb1ad"
	},
	"python": {
		"clientId": "29cb443cb807bccf8958679fa40067dc",
		"clientSecret": "ac4b99a6102b8b472e8da670798941ddbbd47148e97a554eccce100246ccb1ad"
	}
}

# Tutorial variables
var tutorial_in_progress = false
var current_popup = null  # Track which popup is open during tutorial

var initial_waiting_elements: Array[int] = []
var initial_max_queue_size: int = 5

# Settings
var MAX_QUEUE_SIZE: int = 5
var BLOCK_SPACING: float = 30.0
var START_POSITION: Vector2 = Vector2(100, 0)  # X for horizontal position, Y for bottom of stack

# Runtime data
var queue: Array[int] = []
var waiting_elements: Array[int] = []
var dequeued_elements: Array[int] = []
var enqueue_counter: int = 0
var dequeue_counter: int = 0
var peek_counter: int = 0  # NEW: Peek counter
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

# Colors
var colors: Array[Color] = [
	Color8(29, 209, 235),
	Color8(0, 128, 0),
	Color8(144, 238, 144),
	Color8(255, 230, 0),
	Color8(255, 165, 0),
	Color8(220, 53, 69)
]

var tutorial_step: int = 0
var tutorial_nodes: Array = []
var tutorial_texts: Array = []

# C++ Tutorial
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_text: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")
@onready var cpp_next_button: Button = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/NextButton")

var cpp_tutorial_index := 0
var cpp_tutorial_texts := [
	" This is the code automatically generated from your stack simulation.",
	" The tutorial will loop back to the beginning when you reach the end.",
	" Use the Next button to navigate through the code explanations.",
	" This feature helps you connect the visual process with the actual implementation!"
]

var cpp_tutorialcode_index := 0
var current_tutorial_data: Array = [] 

# --- CODE TUTORIAL STEPS (STACK WITH PUSH, POP & PEEK) ---
var cpp_tutorial_steps := [
	{"lines": Vector2i(0, 2), "text": "1. Imports: <iostream> for I/O and <stack> for the standard container."},
	{"lines": Vector2i(4, 7), "text": "2. Main Setup: We define the array and initialize a standard `stack<int>`."},
	{"lines": Vector2i(9, 14), "text": "3. Push Loop: Iterate, push to the stack, and print the updated stack state."},
	{"lines": Vector2i(16, 17), "text": "4. Print Initial: We display the top element of the stack before popping."},
	{"lines": Vector2i(19, 26), "text": "5. Pop Loop: We get `top()`, `pop()` it, and print the remaining stack elements."},
	{"lines": Vector2i(28, 30), "text": "6. End: The simulation finishes when the stack is empty."}
]

var python_tutorial_steps := [
	{"lines": Vector2i(1, 2), "text": "1. Setup: In Python, a standard list `[]` acts perfectly as a stack."},
	{"lines": Vector2i(4, 6), "text": "2. Push Loop: Use `append()` to add elements to the end (top) and print the list."},
	{"lines": Vector2i(8, 9), "text": "3. Print: Display the initial stack top and start popping."},
	{"lines": Vector2i(11, 13), "text": "4. Pop Loop: Use `pop()` to remove the last element and print the remaining stack."},
	{"lines": Vector2i(15, 15), "text": "5. End: The simulation finishes."},
	{"lines": Vector2i(17, 18), "text": "6. Execution: Run the main function."}
]

var java_tutorial_steps := [
	{"lines": Vector2i(0, 0), "text": "1. Imports: Import the `Stack` class from java.util."},
	{"lines": Vector2i(4, 5), "text": "2. Setup: Initialize the array and the Stack object."},
	{"lines": Vector2i(7, 10), "text": "3. Push Loop: Use `s.push(value)` to place items on top and print the state."},
	{"lines": Vector2i(12, 13), "text": "4. Print: Display the initial stack top using `s.peek()`."},
	{"lines": Vector2i(15, 18), "text": "5. Pop Loop: Use `s.pop()` to remove the top item and print the remaining stack."},
	{"lines": Vector2i(19, 21), "text": "6. End: Simulation complete."}
]

var c_tutorial_steps := [
	{"lines": Vector2i(0, 6), "text": "1. Struct Definition: In C, we manually define a Stack struct and array items."},
	{"lines": Vector2i(8, 18), "text": "2. Helper Functions: Logic for `push`, `pop`, `isEmpty`, and `isFull`."},
	{"lines": Vector2i(20, 24), "text": "3. Main Setup: Initialize the stack struct and array."},
	{"lines": Vector2i(26, 31), "text": "4. Push Loop: Add items using `push()` and loop to print the updated stack."},
	{"lines": Vector2i(33, 34), "text": "5. Print Initial: Display the stack top."},
	{"lines": Vector2i(36, 41), "text": "6. Pop Loop: Remove items using `pop()` and print the remaining stack."}
]

# 🧮 Complexity display
@onready var complexity_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/ComplexityPanel")
@onready var time_label: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/ComplexityPanel/VBoxContainer/TimeLabel")
@onready var space_label: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/ComplexityPanel/VBoxContainer/SpaceLabel")

# Queue full panel
@onready var Queue_full:Panel = $Queue_full

#animated sprites
@onready var anim_sprite: AnimatedSprite2D = $Queue_full/AnimatedSprite2D
@onready var q_mark_sprite: AnimatedSprite2D = $HelpButton/Q_mark_anim_sprites
@onready var code_sprite: AnimatedSprite2D = $CppCodeButton/code_anim

@onready var intro_popup: Panel = $TutorialOverlay/Intro_popup
@onready var intro_label: Label = $TutorialOverlay/Intro_popup/Label
@onready var intro_next_btn: Button = $TutorialOverlay/Intro_popup/next
@onready var intro_skip_btn: Button = $TutorialOverlay/Intro_popup/skip
@onready var intro_prev_btn: Button = $TutorialOverlay/Intro_popup/prev
@onready var sim_confirmation: Panel = $Simulate_new_confirmation
@onready var sim_success: Panel = $"simulate_new success"

var intro_step = 0
var intro_texts = [
	"Welcome to Stack Simulation!\nA stack is a linear data structure that follows the Last-In-First-Out (LIFO) principle. In this simulation, you'll learn how stacks work through interactive visualization.",
	"Stack Operations:\n\n• PUSH: Add an element to the top of the stack\n• POP: Remove an element from the top of the stack\n• PEEK: View the top element without removing it",
	"Visual Elements:\n\n• Green blocks represent elements in the stack\n• TOP indicator (R) shows where the next element will be added or removed\n• Elements are stacked from left to right (Left = Bottom, Right = Top)\n• Index labels show each element's position (0 = bottom, top = size-1)",
	"Indicators:\n\n• FULL indicator lights up when stack reaches capacity\n• EMPTY indicator lights up when stack has no elements",
	"How to Use:\n\n1. Click PUSH to add elements from waiting list to the top\n2. Click POP to remove elements from the top\n3. Click PEEK to see the top element without removing it\n4. View waiting/popped elements using buttons\n5. Check timeline for operation history\n6. Generate code to see implementation",
	"Ready to Start!\n\nClick 'Got it' to explore on your own. You can always access the tutorial from the Help button."
]

# Configuration variables
var element_inputs: Array[LineEdit] = []
var user_configuration_step = 1  # 1: Size, 2: Elements

var is_dequeuing_active: bool = false

# ==============================================
#   READY
# ==============================================
func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	print("Program started — initializing stack visualizer...")
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
	
	Queue_full.hide()
	if front_icon: front_icon.text = "Bottom"
	# UPDATE UI TEXTS TO STACK TERMINOLOGY
	if enqueue_btn: enqueue_btn.text = "PUSH"
	if dequeue_btn: dequeue_btn.text = "POP"
	if peek_btn: peek_btn.text = "PEEK"  # NEW: Set peek button text
	if dequeued_btn: dequeued_btn.text = "Popped Elements"
	if Queue_full.get_node_or_null("Label"): Queue_full.get_node("Label").text = "STACK FULL"
	
	# Hide unused pointers (In stack, we just need 'rear' to act as TOP)
	if front_icon: front_icon.hide()
	if front2_icon: front2_icon.hide()
	if rear2_icon: rear2_icon.hide()
	
	# Hide all modals initially
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	
	# Connect configuration buttons
	_connect_configuration_buttons()
	
	# Setup compiler
	_setup_compiler()
	
	# Show the initial choice modal first
	_show_config_modal()
	
	call_deferred("show_introduction")
	q_mark_sprite.play("default")
	
	# Connect language buttons
	if cpp_lang_btn and not cpp_lang_btn.is_connected("pressed", _on_cpp_lang_button_pressed):
		cpp_lang_btn.pressed.connect(_on_cpp_lang_button_pressed)
	
	if python_lang_btn and not python_lang_btn.is_connected("pressed", _on_python_lang_button_pressed):
		python_lang_btn.pressed.connect(_on_python_lang_button_pressed)
	
	if java_lang_btn and not java_lang_btn.is_connected("pressed", _on_java_lang_button_pressed):
		java_lang_btn.pressed.connect(_on_java_lang_button_pressed)
	
	if c_lang_btn and not c_lang_btn.is_connected("pressed", _on_c_lang_button_pressed):
		c_lang_btn.pressed.connect(_on_c_lang_button_pressed)
	
	# Connect peek button
	if peek_btn and not peek_btn.is_connected("pressed", _on_peek_pressed):
		peek_btn.pressed.connect(_on_peek_pressed)

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

	print("=== DEBUG: Elements for code generation ===")
	print("initial_waiting_elements: ", initial_waiting_elements)
	print("waiting_elements: ", waiting_elements)
	print("queue (current stack): ", queue)
	var code = _generate_code_for_language(current_code_language)
	print("=== COMPILATION REQUEST ===")
	print("Language: ", current_code_language)
	print("Code length: ", code.length())
	print("Code preview:\n", code.substr(0, 500))
	print("=== GENERATED CODE ===")
	print(code)
	print("=== END GENERATED CODE ===")
	
	if compiler_output_popup and compiler_output_popup.has_cached_result(current_code_language):
		var cached = compiler_output_popup.get_cached_result(current_code_language)
		print("Using cached result for ", current_code_language)
		print("Cached output length: ", cached.output.length())
		print("Cached output preview:\n", cached.output.substr(0, 500))
		
		var fake_response = {
			"output": cached.output,
			"error": cached.error,
			"memory": cached.memory,
			"cpuTime": cached.cpu  # Make sure to use cpuTime, not cpu
		}
		compiler_output_popup.show_output(current_code_language, fake_response, self, false)
		show_feedback("Using cached result!", Color.YELLOW, Vector2(200, 200))
	else:
		print("No cache - making new API request")
		_compile_code(code)


func _compile_code(code: String) -> void:
	show_feedback("Compiling...", Color.YELLOW, Vector2(200, 200))
	print("Starting compilation request...")
	
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
	
	print("=== Stack Compile Request ===")
	print("Language: ", current_code_language, " → API: ", api_language)
	print("Script length: ", code.length())
	print("Script preview: ", code.substr(0, 100) + "...")
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		show_feedback("Network error! " + str(error), Color.RED, Vector2(200, 200))
		print("HTTP Request error: ", error)


func _get_version_index(lang: String) -> String:
	match lang:
		"cpp": return "5"
		"c": return "4"
		"java": return "4"
		"python": return "4"
		_: return "0"

func _on_compile_completed(result, response_code, headers, body, http_request, language: String) -> void:
	http_request.queue_free()
	
	print("=== COMPILATION RESPONSE ===")
	print("Response code: ", response_code)
	
	if response_code != 200:
		var error_text = "API Error: " + str(response_code)
		if body:
			error_text += "\n" + body.get_string_from_utf8()
		print(error_text)
		show_feedback(error_text, Color.RED, Vector2(200, 200))
		return
	
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	
	if parse_result != OK:
		print("Parse error: ", parse_result)
		show_feedback("Parse error!", Color.RED, Vector2(200, 200))
		return
	
	var response = json.data
	print("Response keys: ", response.keys())
	
	# Log output preview
	if response.has("output"):
		print("Output length: ", response.output.length())
		print("Output preview:\n", response.output.substr(0, 500))
	if response.has("error") and response.error != "":
		print("Error: ", response.error)
	
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

func _connect_configuration_buttons() -> void:
	"""Connect all configuration modal buttons"""
	if yes_btn: yes_btn.pressed.connect(_on_config_yes_pressed)
	if no_btn: no_btn.pressed.connect(_on_config_no_pressed)
	if size_back_btn: size_back_btn.pressed.connect(_on_size_back_pressed)
	if size_next_btn: size_next_btn.pressed.connect(_on_size_next_pressed)
	if elements_back_btn: elements_back_btn.pressed.connect(_on_elements_back_pressed)
	if elements_done_btn: elements_done_btn.pressed.connect(_on_elements_done_pressed)

func _show_config_modal() -> void:
	"""Show the first modal asking if user wants to configure"""
	config_size_modal.hide()
	config_elements_modal.hide()
	config_modal.show()
	_set_main_ui_enabled(false)

func _set_main_ui_enabled(enabled: bool) -> void:
	"""Enable/disable main UI buttons"""
	if enqueue_btn: enqueue_btn.disabled = not enabled
	if dequeue_btn: dequeue_btn.disabled = not enabled
	if peek_btn: peek_btn.disabled = not enabled  # NEW
	if waiting_btn: waiting_btn.disabled = not enabled
	if dequeued_btn: dequeued_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled
	if simulate_new_btn: simulate_new_btn.disabled = not enabled
	get_node("HelpButton").disabled = not enabled
	get_node("CppCodeButton").disabled = not enabled

func _show_config_size_modal() -> void:
	"""Show the second modal for array size input"""
	user_configuration_step = 1
	if size_input:
		size_input.min_value = 4
		size_input.max_value = 6
		size_input.value = 4
		size_label.text = "Please enter stack size"

	config_modal.hide()
	config_elements_modal.hide()
	config_size_modal.show()
	_set_main_ui_enabled(false)  # Keep buttons disabled during config

func _on_elements_done_pressed() -> void:
	btn_sound.play()
	var elements_array: Array[int] = []
	var has_errors = false
	
	for i in range(element_inputs.size()):
		var line_edit = element_inputs[i]
		var value_text = line_edit.text.strip_edges()
		
		if value_text.is_empty():
			value_text = "1"
			line_edit.text = "1"
		
		if not value_text.is_valid_int():
			line_edit.add_theme_color_override("font_color", Color.RED)
			has_errors = true
		else:
			var value = int(value_text)
			if value < 0 or value > 999:
				line_edit.add_theme_color_override("font_color", Color.RED)
				has_errors = true
			else:
				elements_array.append(value)
				line_edit.remove_theme_color_override("font_color")
	
	if has_errors: return
	
	config_elements_modal.hide()
	_set_main_ui_enabled(true)  # Re-enable buttons after config is done
	_initialize_with_elements(elements_array)

func _on_element_input_changed(new_text: String, line_edit: LineEdit) -> void:
	if new_text.is_empty(): return
	if not new_text.is_valid_int():
		var digits_only = ""
		for char in new_text:
			if char.is_valid_int(): digits_only += char
		line_edit.text = digits_only
		line_edit.caret_column = line_edit.text.length()
		return
	if new_text.is_valid_int():
		var num = int(new_text)
		if num > 999:
			line_edit.text = "999"
			line_edit.caret_column = 3

func _on_config_yes_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	get_node("HelpButton").show()
	_show_config_size_modal()

func _on_config_no_pressed() -> void:
	btn_sound.play()
	MAX_QUEUE_SIZE = randi_range(4, 6)
	var random_elements: Array[int] = []
	for i in range(MAX_QUEUE_SIZE):
		random_elements.append(randi_range(1, 99))
	config_modal.hide()
	get_node("HelpButton").show()
	_set_main_ui_enabled(true)
	_initialize_with_elements(random_elements)

func _on_size_back_pressed() -> void:
	btn_sound.play()
	config_size_modal.hide()
	_show_config_modal() 

func _on_size_next_pressed() -> void:
	btn_sound.play()
	MAX_QUEUE_SIZE = int(size_input.value)
	_show_config_elements_modal()

func _show_config_elements_modal() -> void:
	"""Show the third modal for array elements input"""
	user_configuration_step = 2
	element_inputs.clear()
	
	for child in elements_container.get_children():
		child.queue_free()
	
	var array_size = int(size_input.value)
	elements_label.text = "Please enter stack elements"
	
	var grid = GridContainer.new()
	grid.columns = min(5, array_size)
	grid.custom_minimum_size = Vector2(500, 300)
	
	for i in range(array_size):
		var element_box = VBoxContainer.new()
		element_box.custom_minimum_size = Vector2(100, 60)
		
		var label = Label.new()
		label.text = "Value %d" % (i + 1)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		var line_edit = LineEdit.new()
		line_edit.placeholder_text = "0-999"
		line_edit.text = str(randi_range(1, 99))
		line_edit.custom_minimum_size = Vector2(100, 80)
		line_edit.max_length = 3
		line_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		line_edit.text_changed.connect(_on_element_input_changed.bind(line_edit))
		
		element_box.add_child(label)
		element_box.add_child(line_edit)
		grid.add_child(element_box)
		
		element_inputs.append(line_edit)
	
	elements_container.add_child(grid)
	
	config_size_modal.hide()
	config_elements_modal.show()
	_set_main_ui_enabled(false)  # Keep buttons disabled during config
	
func _on_elements_back_pressed() -> void:
	btn_sound.play()
	config_elements_modal.hide()
	_show_config_size_modal()


func _initialize_with_elements(elements: Array[int]) -> void:
	initial_waiting_elements = elements.duplicate()
	initial_max_queue_size = MAX_QUEUE_SIZE
	# Reset cache for new simulation
	reset_cache_for_scene()
	
	# Clear code lines
	code_lines.clear()
	
	audio_player.play()
	waiting_elements = elements.duplicate()
	
	# Add initial code line
	_add_code_line("INITIAL", 0, 0)
	
	if waiting_btn and not waiting_btn.is_connected("pressed", _on_WaitingElements_pressed):
		waiting_btn.pressed.connect(_on_WaitingElements_pressed)
	if dequeued_btn and not dequeued_btn.is_connected("pressed", _on_dequeued_pressed):
		dequeued_btn.pressed.connect(_on_dequeued_pressed)
	if timeline_btn and not timeline_btn.is_connected("pressed", _on_timeline_pressed):
		timeline_btn.pressed.connect(_on_timeline_pressed)
	if simulate_new_btn and not simulate_new_btn.is_connected("pressed", _on_simulate_new_pressed):
		simulate_new_btn.pressed.connect(_on_simulate_new_pressed)
	
	if complete_ok_btn and not complete_ok_btn.is_connected("pressed", _on_complete_ok_pressed):
		complete_ok_btn.pressed.connect(_on_complete_ok_pressed)
	if show_cpp_btn and not show_cpp_btn.is_connected("pressed", _on_show_cpp_pressed):
		show_cpp_btn.pressed.connect(_on_show_cpp_pressed)
	
	if dequeued_close_btn and not dequeued_close_btn.is_connected("pressed", _on_dequeued_close_pressed):
		dequeued_close_btn.pressed.connect(_on_dequeued_close_pressed)
	
	if cpp_close_btn and not cpp_close_btn.is_connected("pressed", _on_cpp_close_pressed):
		cpp_close_btn.pressed.connect(_on_cpp_close_pressed)
	
	if cpp_code_button:
		if not cpp_code_button.is_connected("pressed", _on_cpp_code_button_pressed):
			cpp_code_button.pressed.connect(_on_cpp_code_button_pressed)
		cpp_code_button.hide()
	
	if tutorial_next and not tutorial_next.is_connected("pressed", _on_next_button_pressed):
		tutorial_next.pressed.connect(_on_next_button_pressed)
	
	if enqueue_btn and not enqueue_btn.is_connected("pressed", _on_enqueue_pressed):
		enqueue_btn.pressed.connect(_on_enqueue_pressed)
	if dequeue_btn and not dequeue_btn.is_connected("pressed", _on_dequeue_pressed):
		dequeue_btn.pressed.connect(_on_dequeue_pressed)
	if peek_btn and not peek_btn.is_connected("pressed", _on_peek_pressed):
		peek_btn.pressed.connect(_on_peek_pressed)
	
	if dequeued_container: dequeued_container.hide()
	if cpp_popup: cpp_popup.hide()
	if tutorial_overlay: tutorial_overlay.hide()
	if waiting_popup: waiting_popup.hide()
	if timeline_popup: timeline_popup.hide()
	for i in range(queue.size()):
		var new_block: Control = BLOCK_SCENE.instantiate() as Control
		if new_block.has_method("set"): new_block.set("value", queue[i])
		queue_container.add_child(new_block)
		
		var index_label = _create_index_label(i)
		queue_container.add_child(index_label)
		index_labels.append(index_label)
		
		var block_height = 64.0
		var y_pos = START_POSITION.y - i * (block_height + BLOCK_SPACING)
		new_block.position = Vector2(START_POSITION.x, y_pos)
		# GOOD position offset: +100, +30
		index_label.position = Vector2(new_block.position.x + 100, new_block.position.y + 30)
	_update_labels()
	_update_front_rear_visibility()
	_update_indicators()  # NEW: Update indicators

# ==============================================
#   INDICATOR FUNCTIONS (NEW)
# ==============================================

func _update_indicators() -> void:
	"""Update isFull and isEmpty indicator colors"""
	if is_full_indicator:
		if queue.size() >= MAX_QUEUE_SIZE:
			is_full_indicator.modulate = Color(0, 1, 0, 1)  # Green when full
		else:
			is_full_indicator.modulate = Color(0.3, 0.3, 0.3, 1)  # Dark when not full
	
	if is_empty_indicator:
		if queue.size() == 0:
			is_empty_indicator.modulate = Color(1, 0.5, 0.8, 1)  # Pink when empty
		else:
			is_empty_indicator.modulate = Color(0.3, 0.3, 0.3, 1)  # Dark when not empty

func _update_index_labels() -> void:
	"""Update index labels values only - positions are set during creation/animation"""
	var font = load("res://assets/font/Planes_ValMore.ttf")
	
	# Clear existing labels if count mismatches
	while index_labels.size() > queue.size():
		var label = index_labels.pop_back()
		if is_instance_valid(label):
			label.queue_free()
	
	# Create new labels if needed
	for i in range(queue.size()):
		if i >= index_labels.size():
			var index_label = Label.new()
			index_label.add_theme_font_override("font", font)
			index_label.add_theme_font_size_override("font_size", 28)
			index_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
			index_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
			index_label.add_theme_constant_override("outline_size", 4)
			queue_container.add_child(index_label)
			index_labels.append(index_label)
		
		# Only update the text, not the position
		index_labels[i].text = str(i)
		
# ==============================================
#   PEEK FUNCTION (NEW)
# ==============================================

func _on_peek_pressed() -> void:
	if tutorial_in_progress:
		return
	
	# FIX: Check empty first, give feedback, then return early — no modal shown
	if queue.is_empty():
		show_feedback("Cannot peek! Stack is empty.", Color.ORANGE, get_global_mouse_position())
		return
	
	btn_sound.play()
	var top_value = queue[-1]
	peek_counter += 1
	
	# Add to timeline
	timeline_log.append("Peeked top element: %d" % top_value)
	_add_code_line("PEEK", queue.size() - 1, top_value)
	
	# Find the top block (last block in container)
	var top_block: Control = null
	for i in range(queue_container.get_child_count() - 1, -1, -1):
		var child = queue_container.get_child(i)
		if not child is Label and not child.is_queued_for_deletion():
			top_block = child
			break
	
	if top_block:
		# Flash animation
		var tween = create_tween().set_parallel()
		tween.tween_property(top_block, "modulate", Color.YELLOW, 0.2)
		tween.tween_property(top_block, "modulate", Color.WHITE, 0.2).set_delay(0.2)
		
		show_feedback("Top element: %d" % top_value, Color.CYAN, top_block.global_position)
	else:
		show_feedback("Top element: %d" % top_value, Color.CYAN, get_global_mouse_position())
	
	_update_labels()


# ==============================================
#   TUTORIAL FUNCTIONS (UPDATED)
# ==============================================

func start_tutorial() -> void:
	print("Tutorial starting...")
	btn_sound.play()
	
	tutorial_in_progress = true
	tutorial_overlay.show()
	if dim_bg:
		dim_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tutorial_overlay.layer = 10
	
	tutorial_box.show()
	tutorial_box.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Define tutorial nodes and text in correct order
	tutorial_nodes = [
		enqueue_btn,
		dequeue_btn,
		peek_btn,
		dequeued_btn,
		waiting_btn,
		timeline_btn,
		simulate_new_btn,
		enqueue_label,
		dequeue_label,
		is_full_indicator,
		is_empty_indicator
	]
	
	tutorial_texts = [
		"PUSH BUTTON\nAdds a new element to the TOP of the stack. Elements are added from the waiting list.",
		"POP BUTTON\nRemoves the top element from the stack (LIFO). The element slides down and fades out.",
		"PEEK BUTTON\nViews the top element without removing it. The element will flash yellow and show its value.",
		"POPPED ELEMENTS\nShows all elements that have been popped from the stack.",
		"WAITING ELEMENTS\nShows the list of elements waiting to be pushed into the stack.",
		"TIMELINE\nShows the history of all push, pop, and peek operations.",
		"SIMULATE NEW\nRestarts the simulation with a new random stack.",
		"PUSH COUNTER\nShows the total number of push operations performed.",
		"POP COUNTER\nShows the total number of pop operations performed.",
		"FULL INDICATOR\nTurns GREEN when stack reaches maximum capacity. Turns DARK when there's still space available.",
		"EMPTY INDICATOR\nTurns PINK when stack has no elements. Turns DARK when stack contains data."
	]
	
	tutorial_step = 0
	_show_tutorial_step()
	
	# Force next button to be on top and clickable
	tutorial_next.mouse_filter = Control.MOUSE_FILTER_STOP
	tutorial_next.z_index = 100
	tutorial_next.disabled = false
	
	# Disable all buttons during tutorial
	_set_main_ui_enabled(false)

func _show_tutorial_step() -> void:
	if tutorial_step >= tutorial_nodes.size():
		_end_tutorial()
		return
	
	var node = tutorial_nodes[tutorial_step]
	if not node:
		tutorial_step += 1
		_show_tutorial_step()
		return
	
	tutorial_text.text = tutorial_texts[tutorial_step]
	
	# Show pointer and highlight
	if pointer_sprite:
		pointer_sprite.texture = load("res://assets/point_left.png")
		pointer_sprite.show()
		
		var pos_x = node.global_position.x + node.size.x + 50
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
	
	# Highlight the node (just visual, no color change)
	node.modulate = Color(1.5, 1.5, 0.8, 1)
	
	tutorial_box.visible = true
	tutorial_text.visible = true
	tutorial_next.visible = true
	tutorial_next.mouse_filter = Control.MOUSE_FILTER_STOP
	tutorial_next.z_index = 10

func _end_tutorial() -> void:
	tutorial_in_progress = false
	tutorial_overlay.hide()
	
	if pointer_sprite:
		pointer_sprite.hide()
		if pointer_sprite.has_meta("tween"):
			pointer_sprite.get_meta("tween").kill()
	
	# Reset all button modulations
	for node in tutorial_nodes:
		if node:
			node.modulate = Color(1, 1, 1, 1)
	
	# Clear any popups
	if dequeued_container and dequeued_container.visible:
		dequeued_container.hide()
	if waiting_popup and waiting_popup.visible:
		waiting_popup.hide()
	if timeline_popup and timeline_popup.visible:
		timeline_popup.hide()
	
	# Clear simulation data but don't show config modal - just continue with current simulation
	# Instead, enable the UI and keep the existing stack
	_set_main_ui_enabled(true)
	
	# Reset any existing data but keep the stack as is
	# Don't show config modal - just continue
	show_feedback("Tutorial complete! You can continue experimenting.", Color.GREEN, Vector2(500, 300))
	
func _setup_for_peek_tutorial() -> void:
	"""Setup for peek tutorial - ensure there's something to peek"""
	if queue.is_empty():
		if waiting_elements.is_empty():
			waiting_elements = [10, 20, 30]
		# Push one element
		var val = waiting_elements.pop_front()
		queue.append(val)
		var new_block: Control = BLOCK_SCENE.instantiate() as Control
		if new_block.has_method("set"): new_block.set("value", val)
		queue_container.add_child(new_block)
		
		var block_height = 64.0
		var target_y = START_POSITION.y - (queue.size() - 1) * (block_height + BLOCK_SPACING)
		new_block.position = Vector2(START_POSITION.x, target_y)
		_update_index_labels()
		_update_indicators()
	_update_labels()

func _setup_for_enqueue_tutorial() -> void:
	if waiting_elements.is_empty(): waiting_elements = [10, 20, 30, 40, 50]
	while queue.size() >= MAX_QUEUE_SIZE: queue.pop_back()
	_update_labels()

func _setup_for_dequeue_tutorial() -> void:
	if queue.is_empty():
		queue = [10, 20, 30]
		for child in queue_container.get_children():
			child.queue_free()
		index_labels.clear()
		for i in range(queue.size()):
			var new_block: Control = BLOCK_SCENE.instantiate() as Control
			if new_block.has_method("set"): new_block.set("value", queue[i])
			queue_container.add_child(new_block)
		_resnap_blocks()
		_update_index_labels()
	_update_labels()


func _on_enqueue_pressed() -> void:
	if tutorial_in_progress:
		return
	
	# FIX: Always give feedback, never silently block
	if queue.size() >= MAX_QUEUE_SIZE:
		# Show Stack Full modal only when PUSH is pressed and stack is full
		if Queue_full and not Queue_full.visible:
			Queue_full.visible = true
			anim_sprite.play("default")
			var timer = get_tree().create_timer(2.0)
			timer.timeout.connect(_hide_queue_full_panel)
		show_feedback("Cannot push! Stack is full.", Color.ORANGE, get_global_mouse_position())
		return
	
	if waiting_elements.is_empty():
		show_feedback("No waiting elements to push!", Color.ORANGE, get_global_mouse_position())
		return
	
	_perform_regular_enqueue()

func _perform_tutorial_enqueue() -> void:
	btn_sound.play()
	if waiting_elements.is_empty(): waiting_elements = [10, 20, 30, 40, 50]
	if queue.size() >= MAX_QUEUE_SIZE:
		queue.clear()
		for child in queue_container.get_children(): child.queue_free()
		for lbl in index_labels:
			if is_instance_valid(lbl): lbl.queue_free()
		index_labels.clear()
	
	var new_val: int = waiting_elements.pop_front()
	queue.append(new_val)
	enqueue_counter += 1
	timeline_log.append("Pushed %d to Top" % new_val)
	_add_code_line("PUSH", queue.size() - 1, new_val)

	var new_block: Control = BLOCK_SCENE.instantiate() as Control
	if new_block.has_method("set"): new_block.set("value", new_val)
	queue_container.add_child(new_block)
	
	var block_height = 64.0
	var target_y = START_POSITION.y - (queue.size() - 1) * (block_height + BLOCK_SPACING)
	var final_pos = Vector2(START_POSITION.x, target_y)
	
	var index_label = _create_index_label(queue.size() - 1)
	queue_container.add_child(index_label)
	index_labels.append(index_label)
	
	# GOOD position offset: +100, +30
	var label_target_pos = Vector2(final_pos.x + 100, final_pos.y + 30)
	
	# Start from ABOVE and slide DOWN
	new_block.position = Vector2(START_POSITION.x, target_y - 100)
	new_block.modulate.a = 0
	index_label.position = label_target_pos + Vector2(0, -100)
	index_label.modulate.a = 0
	
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(new_block, "position", final_pos, 0.4)
	tween.tween_property(new_block, "modulate:a", 1.0, 0.4)
	tween.tween_property(index_label, "position", label_target_pos, 0.4)
	tween.tween_property(index_label, "modulate:a", 1.0, 0.4)

	_update_labels()
	_update_front_rear_visibility()
	_update_indicators()
	
	await tween.finished
	

func _perform_regular_enqueue() -> void:
	if queue.size() >= MAX_QUEUE_SIZE:
		show_feedback("Cannot push! Stack is full.", Color.ORANGE, get_global_mouse_position())
		return

	if waiting_elements.is_empty():
		show_feedback("No waiting elements to push!", Color.ORANGE, get_global_mouse_position())
		return

	btn_sound.play()
	var new_val: int = waiting_elements.pop_front()
	queue.append(new_val)
	enqueue_counter += 1
	timeline_log.append("Pushed %d to Top" % new_val)
	_add_code_line("PUSH", queue.size() - 1, new_val)

	var new_block: Control = BLOCK_SCENE.instantiate() as Control
	if new_block.has_method("set"): new_block.set("value", new_val)
	queue_container.add_child(new_block)
	
	var block_height = 64.0
	# New block goes at the TOP (lowest Y value)
	var target_y = START_POSITION.y - (queue.size() - 1) * (block_height + BLOCK_SPACING)
	var final_pos = Vector2(START_POSITION.x, target_y)
	
	var index_label = _create_index_label(queue.size() - 1)
	queue_container.add_child(index_label)
	index_labels.append(index_label)
	
	# GOOD position offset: +100, +30
	var label_target_pos = Vector2(final_pos.x + 100, final_pos.y + 30)
	
	# Start from ABOVE (lower Y) and slide DOWN into position
	new_block.position = Vector2(START_POSITION.x, target_y - 100)
	new_block.modulate.a = 0
	index_label.position = label_target_pos + Vector2(0, -100)
	index_label.modulate.a = 0
	
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(new_block, "position", final_pos, 0.4)
	tween.tween_property(new_block, "modulate:a", 1.0, 0.4)
	tween.tween_property(index_label, "position", label_target_pos, 0.4)
	tween.tween_property(index_label, "modulate:a", 1.0, 0.4)

	# Update existing labels' text (their indices may have changed)
	for i in range(index_labels.size() - 1):
		if is_instance_valid(index_labels[i]):
			index_labels[i].text = str(i)

	_update_labels()
	_update_front_rear_visibility()
	_update_indicators()
	
	await tween.finished

func _on_dequeue_pressed() -> void:
	if is_dequeuing_active: return
	if tutorial_in_progress: return

	# FIX: Check empty first, give feedback, return early — no modal
	if queue.is_empty():
		show_feedback("Cannot pop! Stack is empty.", Color.ORANGE, get_global_mouse_position())
		return
	
	is_dequeuing_active = true
	btn_sound.play()

	var removed_val: int = queue.pop_back()
	dequeue_counter += 1
	dequeued_elements.append(removed_val)
	timeline_log.append("Popped %d from Top" % removed_val)
	_add_code_line("POP", queue.size(), removed_val)

	# Get the top block (last child that is a block, not a label)
	var top_block: Control = null
	var top_block_index = -1
	for i in range(queue_container.get_child_count() - 1, -1, -1):
		var child = queue_container.get_child(i)
		if not child is Label and not child.is_queued_for_deletion():
			top_block = child
			top_block_index = i
			break
	
	if top_block == null:
		is_dequeuing_active = false
		return
	
	# Get the corresponding index label (last in index_labels array)
	var top_label: Label = null
	if index_labels.size() > 0:
		top_label = index_labels.pop_back()
	
	# Animate both block and label UPWARD (negative Y direction)
	var exit_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	if top_block:
		exit_tween.tween_property(top_block, "position", top_block.position + Vector2(0, -100), 0.4)
		exit_tween.tween_property(top_block, "modulate:a", 0.0, 0.3)
	if top_label:
		exit_tween.tween_property(top_label, "position", top_label.position + Vector2(0, -100), 0.4)
		exit_tween.tween_property(top_label, "modulate:a", 0.0, 0.3)
	
	await exit_tween.finished

	# Remove the animated elements
	if top_block and is_instance_valid(top_block):
		top_block.queue_free()
	if top_label and is_instance_valid(top_label):
		top_label.queue_free()

	# Update remaining labels' text values (their indices changed)
	for i in range(index_labels.size()):
		if is_instance_valid(index_labels[i]):
			index_labels[i].text = str(i)

	_update_labels()
	_update_front_rear_visibility()
	_update_indicators()
	
	# Resnap remaining blocks to correct positions
	_resnap_blocks()

	if queue.is_empty() and waiting_elements.is_empty():
		_show_complete_popup()
			
	is_dequeuing_active = false



func _on_dequeued_close_pressed() -> void:
	btn_sound.play()
	dequeued_container.hide()
	current_popup = null

func _show_complete_popup() -> void:
	if complete_popup:
		var total_processes = enqueue_counter + dequeue_counter + peek_counter
		var process_text = "Total Processes: %d\n→ Pushes: %d\n→ Pops: %d\n→ Peeks: %d" % [total_processes, enqueue_counter, dequeue_counter, peek_counter]
		if process_label: process_label.text = process_text
		complete_popup.popup_centered()
	if cpp_code_button:
		cpp_code_button.show()
		code_sprite.play("default")

func _on_complete_ok_pressed() -> void:
	btn_sound.play()
	if complete_popup: complete_popup.hide()

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	if complete_popup and complete_popup.visible: complete_popup.hide()
	_show_cpp_popup()

func _show_cpp_popup() -> void:
	cpp_tutorialcode_index = 0
	if cpp_popup and cpp_text:
		cpp_text.text = _generate_code_for_language(current_code_language)
		cpp_text.custom_minimum_size = Vector2(700, 420)
		
		var lang_names = {"cpp": "C++ Code", "python": "Python Code", "java": "Java Code", "c": "C Code"}
		cpp_popup.title = lang_names.get(current_code_language, "Code")
		
		if cpp_tutorial_panel: cpp_tutorial_panel.show()
		if cpp_explanation_text: cpp_explanation_text.text = "💡 Click 'Next' to walk through this Stack logic!"
		if cpp_next_button:
			cpp_next_button.show()
			cpp_next_button.text = "Next"
		
		clear_cpp_highlight()
		show_cpp_explanation()
		cpp_popup.popup_centered()
		update_language_button_states()

# ==============================================
#   CODE GENERATION FUNCTIONS (UPDATED WITH PEEK)
# ==============================================

func _add_code_line(op: String, index: int, value: int) -> void:
	code_lines.append("%s|%d|%d" % [op, index, value])

func _generate_code_for_language(lang: String) -> String:
	var elements_to_use = initial_waiting_elements if initial_waiting_elements.size() > 0 else waiting_elements
	print("=== CODE GENERATION DEBUG ===")
	print("Language: ", lang)
	print("Elements to use: ", elements_to_use)
	print("initial_waiting_elements size: ", initial_waiting_elements.size())
	print("waiting_elements size: ", waiting_elements.size())
	
	match lang:
		"python": return _gen_python_code(elements_to_use)
		"java": return _gen_java_code(elements_to_use)
		"c": return _gen_c_code(elements_to_use)
		"cpp": return _gen_cpp_code(elements_to_use)
		_: return _gen_cpp_code(elements_to_use)

func _gen_cpp_code(elements_array: Array) -> String:
	var code = "/* Stack Simulation - Operations Log */\n"
	code += "#include <iostream>\n"
	code += "#include <stack>\n"
	code += "#include <vector>\n"
	code += "using namespace std;\n\n"
	
	code += "void printStack(stack<int> s) {\n"
	code += "    cout << \"[\";\n"
	code += "    vector<int> temp;\n"
	code += "    // Extract all elements from stack to vector (reverse order)\n"
	code += "    while(!s.empty()) {\n"
	code += "        temp.push_back(s.top());\n"
	code += "        s.pop();\n"
	code += "    }\n"
	code += "    // Print from bottom to top\n"
	code += "    for(int i = temp.size() - 1; i >= 0; i--) {\n"
	code += "        cout << temp[i];\n"
	code += "        if(i > 0) cout << \", \";\n"
	code += "    }\n"
	code += "    cout << \"]\" << endl;\n"
	code += "}\n\n"
	
	code += "int main() {\n"
	code += "    stack<int> s;\n"
	code += "    cout << \"=== STACK SIMULATION ===\" << endl;\n\n"
	
	if elements_array.size() > 0:
		var elements_str = _array_to_string(elements_array)
		code += "    // Initial elements to push onto the stack\n"
		code += "    int elements[] = {%s};\n" % elements_str
		code += "    int n = sizeof(elements)/sizeof(elements[0]);\n\n"
		
		code += "    cout << \"Initial stack: \";\n"
		code += "    printStack(s);\n\n"
		
		code += "    // PUSH operations - add elements to stack\n"
		code += "    cout << \"--- PUSH OPERATIONS ---\" << endl;\n"
		code += "    for(int i = 0; i < n; i++) {\n"
		code += "        cout << \"\\nPushing \" << elements[i] << \" to stack...\" << endl;\n"
		code += "        s.push(elements[i]);\n"
		code += "        cout << \"Stack after push: \";\n"
		code += "        printStack(s);\n"
		code += "    }\n\n"
		
		code += "    // PEEK operation - view top element\n"
		code += "    cout << \"--- PEEK OPERATION ---\" << endl;\n"
		code += "    if(!s.empty()) {\n"
		code += "        cout << \"\\nTop element (peek): \" << s.top() << endl;\n"
		code += "        cout << \"Stack remains: \";\n"
		code += "        printStack(s);\n"
		code += "    }\n\n"
		
		code += "    // POP operations - remove all elements from stack\n"
		code += "    cout << \"--- POP OPERATIONS ---\" << endl;\n"
		code += "    int pop_count = 0;\n"
		code += "    while(!s.empty()) {\n"
		code += "        cout << \"\\nPopping: \" << s.top() << endl;\n"
		code += "        s.pop();\n"
		code += "        pop_count++;\n"
		code += "        if(!s.empty()) {\n"
		code += "            cout << \"Stack after pop: \";\n"
		code += "            printStack(s);\n"
		code += "        } else {\n"
		code += "            cout << \"Stack is now empty.\" << endl;\n"
		code += "        }\n"
		code += "    }\n\n"
		
		code += "    // Summary\n"
		code += "    cout << \"\\n=== SIMULATION SUMMARY ===\" << endl;\n"
		code += "    cout << \"Total pushes: \" << n << endl;\n"
		code += "    cout << \"Total pops: \" << pop_count << endl;\n"
		code += "    cout << \"Total peeks: 1\" << endl;\n"
		
	else:
		code += "    // No elements to push - stack remains empty\n"
		code += "    cout << \"No elements to push. Stack remains empty.\" << endl;\n"
	
	code += "    cout << \"\\n=== SIMULATION FINISHED ===\" << endl;\n"
	code += "    return 0;\n"
	code += "}\n"
	code += "/* Complexity: Push/Pop/Peek O(1) | Space O(n) */\n"
	
	return code

func _gen_python_code(elements_array: Array) -> String:
	var code = "# Stack Simulation - Operations Log\n\n"
	code += "def print_stack(s):\n"
	code += "    print('[', end='')\n"
	code += "    # Print from bottom to top\n"
	code += "    for i in range(len(s)):\n"
	code += "        print(s[i], end='')\n"
	code += "        if i < len(s) - 1:\n"
	code += "            print(', ', end='')\n"
	code += "    print(']')\n\n"
	code += "def main():\n"
	code += "    s = []\n"
	code += "    print('=== STACK SIMULATION ===')\n\n"
	
	if elements_array.size() > 0:
		code += "    elements = [%s]\n" % _array_to_string(elements_array)
		code += "    print(f'Initial stack: ', end='')\n"
		code += "    print_stack(s)\n\n"
		
		code += "    # PUSH operations\n"
		code += "    print('--- PUSH OPERATIONS ---')\n"
		code += "    for val in elements:\n"
		code += "        print(f'\\nPushing {val} to stack...')\n"
		code += "        s.append(val)\n"
		code += "        print(f'Stack after push: ', end='')\n"
		code += "        print_stack(s)\n\n"
		
		code += "    # PEEK operation\n"
		code += "    print('--- PEEK OPERATION ---')\n"
		code += "    if s:\n"
		code += "        print(f'\\nTop element (peek): {s[-1]}')\n"
		code += "        print(f'Stack remains: ', end='')\n"
		code += "        print_stack(s)\n\n"
		
		code += "    # POP operations\n"
		code += "    print('--- POP OPERATIONS ---')\n"
		code += "    pop_count = 0\n"
		code += "    while s:\n"
		code += "        print(f'\\nPopping: {s[-1]}')\n"
		code += "        s.pop()\n"
		code += "        pop_count += 1\n"
		code += "        if s:\n"
		code += "            print(f'Stack after pop: ', end='')\n"
		code += "            print_stack(s)\n"
		code += "        else:\n"
		code += "            print('Stack is now empty.')\n\n"
		
		code += "    # Summary\n"
		code += "    print('\\n=== SIMULATION SUMMARY ===')\n"
		code += "    print(f'Total pushes: {len(elements)}')\n"
		code += "    print(f'Total pops: {pop_count}')\n"
		code += "    print('Total peeks: 1')\n"
	else:
		code += "    print('No elements to push. Stack remains empty.')\n"
	
	code += "    print('\\n=== SIMULATION FINISHED ===')\n\n"
	code += "if __name__ == '__main__':\n"
	code += "    main()\n"
	code += "''' Complexity: Push/Pop/Peek O(1) | Space O(n) '''"
	return code

func _gen_java_code(elements_array: Array) -> String:
	var code = "/* Stack Simulation - Operations Log */\n"
	code += "import java.util.*;\n\n"
	code += "public class StackSim {\n"
	code += "    public static void printStack(Stack<Integer> s) {\n"
	code += "        System.out.print(\"[\");\n"
	code += "        Stack<Integer> temp = new Stack<>();\n"
	code += "        temp.addAll(s);\n"
	code += "        // Print from bottom to top\n"
	code += "        for(int i = 0; i < temp.size(); i++) {\n"
	code += "            System.out.print(temp.get(i));\n"
	code += "            if(i < temp.size() - 1) System.out.print(\", \");\n"
	code += "        }\n"
	code += "        System.out.println(\"]\");\n"
	code += "    }\n\n"
	code += "    public static void main(String[] args) {\n"
	code += "        Stack<Integer> s = new Stack<>();\n"
	code += "        System.out.println(\"=== STACK SIMULATION ===\");\n\n"
	
	if elements_array.size() > 0:
		code += "        int[] elements = {%s};\n" % _array_to_string(elements_array)
		code += "        System.out.print(\"Initial stack: \");\n"
		code += "        printStack(s);\n\n"
		
		code += "        // PUSH operations\n"
		code += "        System.out.println(\"--- PUSH OPERATIONS ---\");\n"
		code += "        for(int val : elements) {\n"
		code += "            System.out.println(\"\\nPushing \" + val + \" to stack...\");\n"
		code += "            s.push(val);\n"
		code += "            System.out.print(\"Stack after push: \");\n"
		code += "            printStack(s);\n"
		code += "        }\n\n"
		
		code += "        // PEEK operation\n"
		code += "        System.out.println(\"--- PEEK OPERATION ---\");\n"
		code += "        if(!s.isEmpty()) {\n"
		code += "            System.out.println(\"\\nTop element (peek): \" + s.peek());\n"
		code += "            System.out.print(\"Stack remains: \");\n"
		code += "            printStack(s);\n"
		code += "        }\n\n"
		
		code += "        // POP operations\n"
		code += "        System.out.println(\"--- POP OPERATIONS ---\");\n"
		code += "        int popCount = 0;\n"
		code += "        while(!s.isEmpty()) {\n"
		code += "            System.out.println(\"\\nPopping: \" + s.peek());\n"
		code += "            s.pop();\n"
		code += "            popCount++;\n"
		code += "            if(!s.isEmpty()) {\n"
		code += "                System.out.print(\"Stack after pop: \");\n"
		code += "                printStack(s);\n"
		code += "            } else {\n"
		code += "                System.out.println(\"Stack is now empty.\");\n"
		code += "            }\n"
		code += "        }\n\n"
		
		code += "        // Summary\n"
		code += "        System.out.println(\"\\n=== SIMULATION SUMMARY ===\");\n"
		code += "        System.out.println(\"Total pushes: \" + elements.length);\n"
		code += "        System.out.println(\"Total pops: \" + popCount);\n"
		code += "        System.out.println(\"Total peeks: 1\");\n"
	else:
		code += "        System.out.println(\"No elements to push. Stack remains empty.\");\n"
	
	code += "        System.out.println(\"\\n=== SIMULATION FINISHED ===\");\n"
	code += "    }\n"
	code += "}\n"
	code += "/* Complexity: Push/Pop/Peek O(1) | Space O(n) */"
	return code

func _gen_c_code(elements_array: Array) -> String:
	var code = "/* Stack Simulation - Operations Log */\n"
	code += "#include <stdio.h>\n"
	code += "#include <stdlib.h>\n\n"
	code += "#define MAX 100\n\n"
	code += "typedef struct {\n"
	code += "    int items[MAX];\n"
	code += "    int top;\n"
	code += "} Stack;\n\n"
	code += "void initStack(Stack *s) { s->top = -1; }\n"
	code += "int isEmpty(Stack *s) { return s->top == -1; }\n"
	code += "int isFull(Stack *s) { return s->top == MAX - 1; }\n"
	code += "void push(Stack *s, int val) {\n"
	code += "    if(isFull(s)) return;\n"
	code += "    s->items[++s->top] = val;\n"
	code += "}\n"
	code += "int pop(Stack *s) {\n"
	code += "    if(isEmpty(s)) return -1;\n"
	code += "    return s->items[s->top--];\n"
	code += "}\n"
	code += "int peek(Stack *s) { return isEmpty(s) ? -1 : s->items[s->top]; }\n\n"
	code += "void printStack(Stack *s) {\n"
	code += "    printf(\"[\");\n"
	code += "    for(int i = 0; i <= s->top; i++) {\n"
	code += "        printf(\"%d\", s->items[i]);\n"
	code += "        if(i < s->top) printf(\", \");\n"
	code += "    }\n"
	code += "    printf(\"]\\n\");\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    Stack s;\n"
	code += "    initStack(&s);\n"
	code += "    printf(\"=== STACK SIMULATION ===\\n\\n\");\n"
	
	if elements_array.size() > 0:
		code += "    int elements[] = {%s};\n" % _array_to_string(elements_array)
		code += "    int n = sizeof(elements)/sizeof(elements[0]);\n\n"
		code += "    printf(\"Initial stack: \");\n"
		code += "    printStack(&s);\n\n"
		
		code += "    // PUSH operations\n"
		code += "    printf(\"--- PUSH OPERATIONS ---\\n\");\n"
		code += "    for(int i = 0; i < n; i++) {\n"
		code += "        printf(\"\\nPushing %d to stack...\\n\", elements[i]);\n"
		code += "        push(&s, elements[i]);\n"
		code += "        printf(\"Stack after push: \");\n"
		code += "        printStack(&s);\n"
		code += "    }\n\n"
		
		code += "    // PEEK operation\n"
		code += "    printf(\"--- PEEK OPERATION ---\\n\");\n"
		code += "    if(!isEmpty(&s)) {\n"
		code += "        printf(\"\\nTop element (peek): %d\\n\", peek(&s));\n"
		code += "        printf(\"Stack remains: \");\n"
		code += "        printStack(&s);\n"
		code += "    }\n\n"
		
		code += "    // POP operations\n"
		code += "    printf(\"--- POP OPERATIONS ---\\n\");\n"
		code += "    int pop_count = 0;\n"
		code += "    while(!isEmpty(&s)) {\n"
		code += "        printf(\"\\nPopping: %d\\n\", peek(&s));\n"
		code += "        pop(&s);\n"
		code += "        pop_count++;\n"
		code += "        if(!isEmpty(&s)) {\n"
		code += "            printf(\"Stack after pop: \");\n"
		code += "            printStack(&s);\n"
		code += "        } else {\n"
		code += "            printf(\"Stack is now empty.\\n\");\n"
		code += "        }\n"
		code += "    }\n\n"
		
		code += "    // Summary\n"
		code += "    printf(\"\\n=== SIMULATION SUMMARY ===\\n\");\n"
		code += "    printf(\"Total pushes: %d\\n\", n);\n"
		code += "    printf(\"Total pops: %d\\n\", pop_count);\n"
		code += "    printf(\"Total peeks: 1\\n\");\n"
	else:
		code += "    printf(\"No elements to push. Stack remains empty.\\n\");\n"
	
	code += "    printf(\"\\n=== SIMULATION FINISHED ===\\n\");\n"
	code += "    return 0;\n"
	code += "}\n"
	code += "/* Complexity: Push/Pop/Peek O(1) | Space O(n) */"
	return code

func _array_to_string(arr: Array) -> String:
	if arr.is_empty():
		return ""
	var parts: Array[String] = []
	for v in arr:
		parts.append(str(v))
	return ", ".join(parts)

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
		result_title.text = "SIMULATION COMPLETE!"
		result_title.modulate = Color.GREEN
		if translate_code_btn:
			translate_code_btn.show()
		if cpp_code_button:
			cpp_code_button.show()
			if code_sprite: code_sprite.play("default")
	else:
		result_title.text = "SIMULATION ENDED"
		result_title.modulate = Color.YELLOW
		if translate_code_btn:
			translate_code_btn.show()
		if cpp_code_button:
			cpp_code_button.show()
			if code_sprite: code_sprite.play("default")
	
	score_summary.text = "Pushes: %d | Pops: %d | Peeks: %d" % [grade.get("correct_moves", 0), grade.get("bad_moves", 0), peek_counter]
	accuracy_label.text = "Total Operations: %d" % [grade.get("correct_moves", 0) + grade.get("bad_moves", 0) + peek_counter]
	time_used_label.text = "Stack Size: %d" % queue.size()
	coins_label.text = "+%d" % grade.get("coins", 0)
	
	result_popup.popup_centered()
	
	if grade.get("coins", 0) > 0 and coins_anim:
		coins_anim.play("default")

func _on_translate_code_pressed() -> void:
	"""Handle translate code button press from result popup"""
	btn_sound.play()
	if result_popup:
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

# ==============================================
#   LANGUAGE BUTTON HANDLERS
# ==============================================

func _on_cpp_lang_button_pressed() -> void:
	btn_sound.play()
	current_code_language = "cpp"
	refresh_code_display()

func _on_python_lang_button_pressed() -> void:
	btn_sound.play()
	current_code_language = "python"
	refresh_code_display()

func _on_java_lang_button_pressed() -> void:
	btn_sound.play()
	current_code_language = "java"
	refresh_code_display()

func _on_c_lang_button_pressed() -> void:
	btn_sound.play()
	current_code_language = "c"
	refresh_code_display()

func refresh_code_display() -> void:
	if cpp_popup and cpp_popup.visible and cpp_text:
		cpp_text.text = _generate_code_for_language(current_code_language)
		update_language_button_states()
		cpp_tutorialcode_index = 0
		clear_cpp_highlight()
		if cpp_explanation_text: 
			cpp_explanation_text.text = "💡 Click 'Next' to walk through this Stack explanation!"

func get_time_complexity() -> String:
	var ops = []
	if enqueue_counter > 0: ops.append("• Push: O(1)")
	if dequeue_counter > 0: ops.append("• Pop: O(1)")
	if peek_counter > 0: ops.append("• Peek: O(1)")
	if not queue.is_empty(): ops.append("• Top (Peek): O(1)")
	if timeline_log.size() > 0: ops.append("• Traversal (printing): O(n)")
	if ops.is_empty(): return "• Push/Pop/Peek: O(1)"
	return "\n".join(ops)

func get_space_complexity() -> String:
	var total_elements = queue.size() + waiting_elements.size() + dequeued_elements.size()
	return "O(n) — where n = %d (total elements handled)" % total_elements

func _refresh_dequeued_list() -> void:
	for child in dequeued_container.get_children():
		if child != dequeued_close_btn: child.queue_free()

	if dequeued_elements.is_empty():
		var lbl: Label = Label.new()
		lbl.text = "No popped elements yet."
		dequeued_container.add_child(lbl)
		return

	for i in range(dequeued_elements.size()):
		var value: int = dequeued_elements[i]
		var block := BLOCK_SCENE.instantiate() as Control
		var lbl := block.get_node_or_null("NumberLabel")
		if lbl and lbl is Label: lbl.text = str(value)
		var bg := block.get_node_or_null("Bg")
		if bg and bg is ColorRect: bg.color = colors[i % colors.size()]
		if block.get_script() != null: block.set_script(null)
		block.mouse_filter = Control.MOUSE_FILTER_IGNORE
		block.modulate = Color(0.85, 0.85, 0.85, 1.0)
		dequeued_container.add_child(block)

# ==============================================
#   FIX 1: _update_labels — no auto-showing Queue_full modal,
#   no hard-disabling of buttons. Only visual dimming.
# ==============================================
func _update_labels() -> void:
	enqueue_label.text = "Push Counter: %d" % enqueue_counter
	dequeue_label.text = "Pop Counter: %d" % dequeue_counter

	# Buttons always look the same and are always tappable.
	# Feedback messages handle communication of invalid actions.
	enqueue_btn.disabled = false
	dequeue_btn.disabled = false
	peek_btn.disabled = false
	enqueue_btn.modulate = Color.WHITE
	dequeue_btn.modulate = Color.WHITE
	peek_btn.modulate = Color.WHITE

func _hide_queue_full_panel() -> void:
	if Queue_full and Queue_full.visible:
		var tween = create_tween()
		tween.tween_property(Queue_full, "modulate:a", 0.0, 0.5)
		await tween.finished
		Queue_full.visible = false
		Queue_full.modulate.a = 1.0

func update_language_button_states() -> void:
	if cpp_lang_btn:
		cpp_lang_btn.modulate = Color(1, 1, 1, 1.0) if current_code_language == "cpp" else Color(1, 1, 1, 0.7)
		cpp_lang_btn.disabled = (current_code_language == "cpp")
	if python_lang_btn:
		python_lang_btn.modulate = Color(1, 1, 1, 1.0) if current_code_language == "python" else Color(1, 1, 1, 0.7)
		python_lang_btn.disabled = (current_code_language == "python")
	if java_lang_btn:
		java_lang_btn.modulate = Color(1, 1, 1, 1.0) if current_code_language == "java" else Color(1, 1, 1, 0.7)
		java_lang_btn.disabled = (current_code_language == "java")
	if c_lang_btn:
		c_lang_btn.modulate = Color(1, 1, 1, 1.0) if current_code_language == "c" else Color(1, 1, 1, 0.7)
		c_lang_btn.disabled = (current_code_language == "c")

func _resnap_blocks() -> void:
	var block_height = 64.0
	var block_index = 0
	
	for i in range(queue_container.get_child_count()):
		var child = queue_container.get_child(i)
		# Only reposition blocks, not labels
		if not child is Label and not child.is_queued_for_deletion():
			var y_pos = START_POSITION.y - block_index * (block_height + BLOCK_SPACING)
			child.position = Vector2(START_POSITION.x, y_pos)
			child.original_position = child.position
			
			# Update the corresponding label position with the GOOD offset (+100, +30)
			if block_index < index_labels.size() and is_instance_valid(index_labels[block_index]):
				var label_target_pos = Vector2(child.position.x + 100, child.position.y + 30)
				index_labels[block_index].position = label_target_pos
			
			block_index += 1

# ==============================================
#   FIX 3: _update_front_rear_visibility
#   TOP label sits directly LEFT of the top block.
#   BOTTOM label sits directly LEFT of the bottom block.
#   Uses the block's actual position in the QueueContainer.
# ==============================================
func _update_front_rear_visibility() -> void:
	if queue.size() > 0:
		if rear_icon:
			rear_icon.show()
			var top_y = START_POSITION.y - (queue.size() - 1) * (64.0 + BLOCK_SPACING)
			rear_icon.position.x = START_POSITION.x+400  # ← move left/right
			rear_icon.position.y = top_y + 520            # ← move up/down

		if front_icon:
			front_icon.show()
			front_icon.position.x = START_POSITION.x + 620  # ← move left/right
			front_icon.position.y = START_POSITION.y + 520  # ← move up/down
	else:
		if rear_icon: rear_icon.hide()
		if front_icon: front_icon.hide()
		
func show_cpp_explanation() -> void:
	if not cpp_explanation_text: return
	var tutorial_steps = _get_tutorial_steps_for_language()
	if tutorial_steps.is_empty(): return
	if cpp_tutorialcode_index >= tutorial_steps.size():
		cpp_tutorialcode_index = tutorial_steps.size() - 1
	var step = tutorial_steps[cpp_tutorialcode_index]
	
	if step is Dictionary and step.has("lines"):
		var lines = step["lines"]
		if lines is Vector2i:
			highlight_cpp_lines(lines.x, lines.y)
		elif lines is Array and lines.size() > 0:
			var start_line = lines[0] if lines[0] is int else 0
			var end_line = lines[lines.size() - 1] if lines[lines.size() - 1] is int else 0
			highlight_cpp_lines(start_line, end_line)
		if step.has("text"): cpp_explanation_text.text = step["text"]
	
	if cpp_next_button:
		cpp_next_button.text = "Next (Loop)" if cpp_tutorialcode_index >= tutorial_steps.size() - 1 else "Next"

func _get_tutorial_steps_for_language() -> Array:
	match current_code_language:
		"cpp": return cpp_tutorial_steps
		"python": return python_tutorial_steps
		"java": return java_tutorial_steps
		"c": return c_tutorial_steps
		_: return cpp_tutorial_steps

func highlight_cpp_lines(start_line: int, end_line: int) -> void:
	if not cpp_text: return
	clear_cpp_highlight()
	cpp_text.bbcode_enabled = true
	var full_text = cpp_text.text
	var lines = full_text.split("\n")
	if start_line < 0 or end_line >= lines.size(): return
	
	var new_text = ""
	for i in range(lines.size()):
		var line = lines[i]
		if i >= start_line and i <= end_line:
			new_text += "[bgcolor=#25d200]" + line + "[/bgcolor]"
		else:
			new_text += line
		if i < lines.size() - 1:
			new_text += "\n"
	cpp_text.text = new_text

func _create_index_label(index: int) -> Label:
	var index_label = Label.new()
	index_label.text = str(index)
	var index_font = load("res://assets/font/Planes_ValMore.ttf")
	if index_font:
		index_label.add_theme_font_override("font", index_font)
	index_label.add_theme_font_size_override("font_size", 28)
	index_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	index_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	index_label.add_theme_constant_override("outline_size", 4)
	index_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return index_label
	
func clear_cpp_highlight() -> void:
	if not cpp_text: return
	cpp_text.text = _generate_code_for_language(current_code_language)

func _clear_simulation_data() -> void:
	queue.clear()
	waiting_elements.clear()
	dequeued_elements.clear()
	timeline_log.clear()
	code_lines.clear()
	enqueue_counter = 0
	dequeue_counter = 0
	peek_counter = 0
	
	# Keep initial configuration for code generation
	# Don't clear initial_waiting_elements
	
	for child in queue_container.get_children(): child.queue_free()
	for child in dequeued_container.get_children():
		if child != dequeued_close_btn: child.queue_free()
	
	# Clear index labels
	for label in index_labels:
		if is_instance_valid(label):
			label.queue_free()
	index_labels.clear()
	
	_update_labels()
	_update_front_rear_visibility()
	_update_indicators()
	
	if dequeued_container and dequeued_container.visible: dequeued_container.hide()
	if waiting_popup and waiting_popup.visible: waiting_popup.hide()
	if timeline_popup and timeline_popup.visible: timeline_popup.hide()
	if complete_popup and complete_popup.visible: complete_popup.hide()
	if cpp_popup and cpp_popup.visible: cpp_popup.hide()
	current_popup = null


func reset_cpp_tutorial_state() -> void:
	cpp_tutorial_index = 0
	cpp_tutorialcode_index = 0
	if cpp_tutorial_panel: cpp_tutorial_panel.show()
	if cpp_text:
		clear_cpp_highlight()
		cpp_text.deselect()
	if cpp_explanation_text: cpp_explanation_text.text = "💡 Click 'Next' to walk through this code explanation!"
	if cpp_next_button:
		cpp_next_button.text = "Next"
		cpp_next_button.show()

# --- MISSING FUNCTIONS ADDED ---


func _on_WaitingElements_pressed() -> void:
	if tutorial_in_progress:
		return
	
	btn_sound.play()
	if waiting_popup.visible:
		waiting_popup.hide()
		current_popup = null
	else:
		if waiting_elements.is_empty():
			waiting_label.text = "No waiting elements left."
		else:
			waiting_label.text = "Waiting Elements:\n" + ", ".join(waiting_elements.map(func(x): return str(x)))
		waiting_popup.popup_centered()
		current_popup = waiting_popup

func _on_timeline_pressed() -> void:
	if tutorial_in_progress:
		return
	
	btn_sound.play()
	if timeline_popup.visible:
		timeline_popup.hide()
		current_popup = null
	else:
		if timeline_log.is_empty():
			timeline_label.text = "No events yet."
		else:
			timeline_label.text = "Timeline of Events:\n" + "\n".join(timeline_log)
		timeline_popup.popup_centered()
		current_popup = timeline_popup

func _on_dequeued_pressed() -> void:
	if tutorial_in_progress:
		return
	
	btn_sound.play()
	if dequeued_container.visible:
		dequeued_container.hide()
		current_popup = null
	else:
		_refresh_dequeued_list()
		dequeued_container.show()
		current_popup = dequeued_container

func _on_simulate_new_pressed() -> void:
	if tutorial_in_progress:
		return
	reset_cpp_tutorial_state()
	sim_confirmation.show()

func _on_cpp_close_pressed() -> void:
	btn_sound.play()
	reset_cpp_tutorial_state()
	if cpp_tutorial_panel: cpp_tutorial_panel.show()
	if cpp_popup: cpp_popup.hide()

func _on_cpp_code_button_pressed() -> void:
	btn_sound.play()
	reset_cpp_tutorial_state()
	if cpp_tutorial_panel: cpp_tutorial_panel.show()
	_show_cpp_popup()

func _on_next_button_pressed() -> void:
	btn_sound.play()
	if tutorial_in_progress:
		tutorial_step += 1
		_show_tutorial_step()

# ==============================================
#   INTRODUCTION POPUP LOGIC
# ==============================================

func show_introduction() -> void:
	print("Showing introduction popup...")
	if not intro_popup: return
	
	intro_step = 0
	intro_label.text = intro_texts[intro_step]
	
	if intro_next_btn and not intro_next_btn.is_connected("pressed", _on_intro_next_pressed):
		intro_next_btn.pressed.connect(_on_intro_next_pressed)
	if intro_skip_btn and not intro_skip_btn.is_connected("pressed", _on_intro_skip_pressed):
		intro_skip_btn.pressed.connect(_on_intro_skip_pressed)
	if intro_prev_btn and not intro_prev_btn.is_connected("pressed", _on_intro_prev_pressed):
		intro_prev_btn.pressed.connect(_on_intro_prev_pressed)

	_update_intro_buttons()
	intro_popup.show()
	_set_main_ui_enabled(false)

func _update_intro_buttons() -> void:
	if not intro_next_btn or not intro_prev_btn or not intro_skip_btn: return
	
	intro_prev_btn.visible = (intro_step > 0)
	
	if intro_step == intro_texts.size() - 1:
		intro_next_btn.text = "Got it"
		if intro_skip_btn: intro_skip_btn.visible = false
	else:
		intro_next_btn.text = "Next"
		if intro_skip_btn: intro_skip_btn.visible = true

func _on_intro_next_pressed() -> void:
	btn_sound.play()
	if intro_step < intro_texts.size() - 1:
		intro_step += 1
		intro_label.text = intro_texts[intro_step]
		_update_intro_buttons()
	else:
		if intro_popup: intro_popup.hide()
		_set_main_ui_enabled(true)

func _on_intro_skip_pressed() -> void:
	btn_sound.play()
	if intro_popup: intro_popup.hide()
	_set_main_ui_enabled(true)

func _on_intro_prev_pressed() -> void:
	btn_sound.play()
	if intro_step > 0:
		intro_step -= 1
		intro_label.text = intro_texts[intro_step]
		_update_intro_buttons()

func _on_help_button_pressed() -> void:
	btn_sound.play()
	get_node("HelpButton").disabled = true
	get_node("CppCodeButton").disabled = true
	start_tutorial()

func _on_cpp_next_button_pressed() -> void:
	btn_sound.play()
	
	var tutorial_steps = _get_tutorial_steps_for_language()
	cpp_tutorialcode_index = (cpp_tutorialcode_index + 1) % tutorial_steps.size()
	show_cpp_explanation()
	
	if cpp_tutorialcode_index == 0:
		if cpp_explanation_text:
			var _original_text = cpp_explanation_text.text
			cpp_explanation_text.text = "🔄 Looping back to start..."
			
			await get_tree().create_timer(0.8).timeout
			
			show_cpp_explanation()
		
		if cpp_next_button:
			var tween = create_tween()
			tween.tween_property(cpp_next_button, "modulate", Color(0.5, 1, 0.5, 1), 0.2)
			tween.tween_property(cpp_next_button, "modulate", Color.WHITE, 0.2)

func _on_close_pressed() -> void:
	if cpp_popup:
		cpp_popup.hide()
		reset_cpp_tutorial_state()
	btn_sound.play()

func _on_yes_pressed() -> void:
	"""User confirmed they want to simulate new - reset everything"""
	if tutorial_in_progress:
		print("Tutorial: Please complete the tutorial first")
		return
	
	btn_sound.play()
	sim_confirmation.hide()
	sim_success.show()
	
	var timer = get_tree().create_timer(2.0)
	await timer.timeout
	sim_success.hide()
	
	_clear_simulation_data()

	for child in queue_container.get_children():
		child.queue_free()

	for child in dequeued_container.get_children():
		if child != dequeued_close_btn:
			child.queue_free()
	
	if Queue_full and Queue_full.visible:
		Queue_full.hide()
	reset_cpp_tutorial_state()
	_update_labels()
	_update_front_rear_visibility()
	_update_indicators()
	
	# Show the initial choice modal again
	_show_config_modal()

func _on_no_pressed() -> void:
	btn_sound.play()
	sim_confirmation.hide()

func _on_ok_btn_pressed() -> void:
	waiting_popup.hide()
