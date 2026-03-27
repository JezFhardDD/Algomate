extends Control

# Node paths
@onready var enqueue_btn: Button = $VBoxContainer/EnqueueButton
@onready var dequeue_btn: Button = $VBoxContainer/DequeueButton
@onready var waiting_btn: Button = $VBoxContainer/WaitingElements
@onready var dequeued_btn: Button = $VBoxContainer/DequeuedElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew
@onready var peek_btn: Button = $VBoxContainer/PeakButton

@onready var enqueue_label: Label = $HBoxContainer/Label
@onready var dequeue_label: Label = $HBoxContainer2/Label
@onready var queue_container: Control = $QueueContainer

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

# Tutorial variables
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false
var current_popup = null  # Track which popup is open during tutorial

# Settings
var MAX_QUEUE_SIZE: int = 5
var BLOCK_SPACING: float = 10.0
var START_POSITION: Vector2 = Vector2(80, 80)

# Runtime data
var queue: Array[int] = []
var waiting_elements: Array[int] = []
var dequeued_elements: Array[int] = []
var enqueue_counter: int = 0
var dequeue_counter: int = 0
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

# C++ Tutorial
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_text: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")
@onready var cpp_next_button: Button = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/NextButton")

var cpp_tutorial_index := 0
var cpp_tutorial_texts := [
	" This is the **C++ code** automatically generated from your queue simulation. Click 'Next' to walk through each part!",
	" The tutorial will loop back to the beginning when you reach the end.",
	" Use the Next button to navigate through the code explanations.",
	" This feature helps you connect the visual process with the actual implementation!"
]

var cpp_tutorialcode_index := 0
var current_tutorial_data: Array = [] 

# --- CODE TUTORIAL STEPS (QUEUE WITH LIVE PRINTS) ---
var cpp_tutorial_steps := [
	{"lines": Vector2i(0, 1), "text": "1. Imports: <iostream> for I/O and <queue> for the standard container."},
	{"lines": Vector2i(4, 7), "text": "2. Main Setup: We define the array and initialize a standard `queue<int>`."},
	{"lines": Vector2i(9, 18), "text": "3. Enqueue Loop: Iterate, push to the back, and use a copy to print the current queue state."},
	{"lines": Vector2i(20, 21), "text": "4. Print Initial: We display the front element of the queue before dequeuing."},
	{"lines": Vector2i(23, 33), "text": "5. Dequeue Loop: We get `front()`, `pop()` it, and print the remaining queue elements."},
	{"lines": Vector2i(35, 37), "text": "6. End: The simulation finishes when the queue is empty."}
]

var python_tutorial_steps := [
	{"lines": Vector2i(0, 4), "text": "1. Setup: In Python, we import `deque` to act efficiently as a queue."},
	{"lines": Vector2i(6, 8), "text": "2. Enqueue Loop: Use `append()` to add elements to the back and print the list."},
	{"lines": Vector2i(10, 11), "text": "3. Print: Display the initial queue front and start dequeuing."},
	{"lines": Vector2i(13, 15), "text": "4. Dequeue Loop: Use `popleft()` to remove the first element added and print the remaining queue."},
	{"lines": Vector2i(17, 17), "text": "5. End: The simulation finishes."},
	{"lines": Vector2i(19, 20), "text": "6. Execution: Run the main function."}
]

var java_tutorial_steps := [
	{"lines": Vector2i(0, 3), "text": "1. Imports & Class: Import the `Queue` interface and `LinkedList` class."},
	{"lines": Vector2i(4, 6), "text": "2. Setup: Initialize the array and the Queue object."},
	{"lines": Vector2i(8, 11), "text": "3. Enqueue Loop: Use `q.add(value)` to place items at the rear and print the state."},
	{"lines": Vector2i(13, 14), "text": "4. Print: Display the initial queue front using `q.peek()`."},
	{"lines": Vector2i(16, 19), "text": "5. Dequeue Loop: Use `q.poll()` to remove the front item and print the remaining queue."},
	{"lines": Vector2i(20, 22), "text": "6. End: Simulation complete."}
]

var c_tutorial_steps := [
	{"lines": Vector2i(0, 7), "text": "1. Struct Definition: In C, we manually define a Queue struct with front and rear pointers."},
	{"lines": Vector2i(9, 29), "text": "2. Helper Functions: Logic for `enqueue`, `dequeue`, `isEmpty`, and `printQueue`."},
	{"lines": Vector2i(31, 35), "text": "3. Main Setup: Initialize the queue struct and array."},
	{"lines": Vector2i(37, 42), "text": "4. Enqueue Loop: Add items using `enqueue()` and loop to print the updated queue."},
	{"lines": Vector2i(44, 45), "text": "5. Print Initial: Display the queue front."},
	{"lines": Vector2i(47, 52), "text": "6. Dequeue Loop: Remove items using `dequeue()` and print the remaining queue."}
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

# Compiler button
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CompileButton")

@onready var intro_popup: Panel = $TutorialOverlay/Intro_popup
@onready var intro_label: Label = $TutorialOverlay/Intro_popup/Label
@onready var intro_next_btn: Button = $TutorialOverlay/Intro_popup/next
@onready var intro_skip_btn: Button = $TutorialOverlay/Intro_popup/skip
@onready var intro_prev_btn: Button = $TutorialOverlay/Intro_popup/prev
@onready var sim_confirmation: Panel = $Simulate_new_confirmation
@onready var sim_success: Panel = $"simulate_new success"

var intro_step = 0
var intro_texts = [
	"Welcome to Queue Simulation!\nA queue is a linear data structure that follows the First-In-First-Out (FIFO) principle. In this simulation, you'll learn how queues work through interactive visualization.",
	"Queue Operations:\n\n• ENQUEUE: Add an element to the rear of the queue\n• DEQUEUE: Remove an element from the front of the queue\n• FRONT: View the first element without removing it\n• REAR: View the last element added",
	"Visual Elements:\n\n• Green blocks represent elements in the queue\n• Front indicator (F) shows where elements will be removed\n• Rear indicator (R) shows where new elements will be added\n• Waiting elements are shown in a separate list",
	"How to Use:\n\n1. Click ENQUEUE to add elements from waiting list\n2. Click DEQUEUE to remove elements from front\n3. View waiting/dequeued elements using buttons\n4. Check timeline for operation history\n5. Generate code to see implementation",
	"Ready to Start!\n\nClick 'Got it' to explore on your own. You can always access the tutorial from the Help button."
]

# Configuration variables
var element_inputs: Array[LineEdit] = []
var user_configuration_step = 1  # 1: Size, 2: Elements
# Add this with your other runtime data variables (around line 100)
var initial_waiting_elements: Array[int] = []  # Store the initial configuration
var is_dequeuing_active: bool = false

var INDEX_LABEL_OFFSET: float = 100.0 # Vertical offset for index labels

# Indicator and Labels
@onready var is_full_indicator: TextureRect = get_node_or_null("isFull")
@onready var is_empty_indicator: TextureRect = get_node_or_null("isEmpty")
var index_labels: Array[Label] = []  # Store index label nodes

# 🏁 Ready
func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	print(" Program started — initializing queue visualizer...")
	randomize()
	Queue_full.hide()
	
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
	
	_update_indicators()
func _enter_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	await get_tree().process_frame
	await get_tree().process_frame
	var current_size = get_viewport().get_visible_rect().size
	if current_size.y > current_size.x:
		get_tree().root.content_scale_size = Vector2i(int(current_size.y), int(current_size.x))

func _exit_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_PORTRAIT)
	 
	

func _connect_configuration_buttons() -> void:
	"""Connect all configuration modal buttons"""
	# Choice modal buttons
	if yes_btn:
		yes_btn.pressed.connect(_on_config_yes_pressed)
	
	if no_btn:
		no_btn.pressed.connect(_on_config_no_pressed)
	
	# Size modal buttons
	if size_back_btn:
		size_back_btn.pressed.connect(_on_size_back_pressed)
	
	if size_next_btn:
		size_next_btn.pressed.connect(_on_size_next_pressed)
	
	# Elements modal buttons
	if elements_back_btn:
		elements_back_btn.pressed.connect(_on_elements_back_pressed)
	
	if elements_done_btn:
		elements_done_btn.pressed.connect(_on_elements_done_pressed)

func _show_config_modal() -> void:
	"""Show the first modal asking if user wants to configure"""
	print(" Showing configuration choice modal...")
	
	# Hide other config modals
	config_size_modal.hide()
	config_elements_modal.hide()
	
	# Show the choice modal
	config_modal.show()
	
	# Disable main UI buttons while modal is open
	_set_main_ui_enabled(false)

func _show_config_size_modal() -> void:
	"""Show the second modal for array size input"""
	print(" Showing array size configuration modal...")
	
	user_configuration_step = 1
	
	# Set up the size input
	if size_input:
		size_input.min_value = 5
		size_input.max_value = 7
		size_input.value = 5
		size_label.text = "Please enter array size"

	config_modal.hide()
	config_elements_modal.hide()
	config_size_modal.show()

func _show_config_elements_modal() -> void:
	"""Show the third modal for array elements input"""
	print(" Showing array elements configuration modal...")
	
	user_configuration_step = 2
	element_inputs.clear()
	
	# Clear previous input boxes
	for child in elements_container.get_children():
		child.queue_free()
	
	# Create input boxes based on the selected size
	var array_size = int(size_input.value)
	elements_label.text = "Please enter array elements"
	
	# Create input boxes in a grid (5 per row)
	var grid = GridContainer.new()
	grid.columns = min(5, array_size)
	grid.custom_minimum_size = Vector2(500, 300)
	
	for i in range(array_size):
		# Create container for each input
		var element_box = VBoxContainer.new()
		element_box.custom_minimum_size = Vector2(100, 60)
		
		# Create label
		var label = Label.new()
		label.text = "Value %d" % (i + 1)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		var line_edit = LineEdit.new()
		line_edit.placeholder_text = "0-999"
		line_edit.text = str(randi_range(1, 99))
		line_edit.custom_minimum_size = Vector2(100, 80)
		line_edit.max_length = 3  # Maximum 3 digits
		line_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		# Connect validation
		line_edit.text_changed.connect(_on_element_input_changed.bind(line_edit))
		
		element_box.add_child(label)
		element_box.add_child(line_edit)
		grid.add_child(element_box)
		
		element_inputs.append(line_edit)
	
	elements_container.add_child(grid)
	

	config_size_modal.hide()
	config_elements_modal.show()

func _on_element_input_changed(new_text: String, line_edit: LineEdit) -> void:
	"""Validate that input contains only digits and is <= 999"""

	if new_text.is_empty():
		return

	if not new_text.is_valid_int():
		var digits_only = ""
		for char in new_text:
			if char.is_valid_int():
				digits_only += char
		
		line_edit.text = digits_only
		line_edit.caret_column = line_edit.text.length()
		return
	

	if new_text.is_valid_int():
		var num = int(new_text)
		if num > 999:
			line_edit.text = "999"
			line_edit.caret_column = 3


func _on_config_yes_pressed() -> void:
	"""User wants to configure - show size configuration modal"""
	btn_sound.play()
	
	# Hide the choice modal
	config_modal.hide()
	
	# Show the size configuration modal (first step)
	_show_config_size_modal()

func _on_config_no_pressed() -> void:
	"""User doesn't want to configure - use random size and elements"""
	# Reset cache for new simulation
	reset_cache_for_scene()
	
	btn_sound.play()
	
	# Use random size
	MAX_QUEUE_SIZE = randi_range(5, 7)
	print(" User chose random size:", MAX_QUEUE_SIZE)
	
	# Generate random elements
	var random_elements: Array[int] = []
	for i in range(MAX_QUEUE_SIZE):
		random_elements.append(randi_range(1, 99))
	
	# Close the choice modal
	config_modal.hide()
	
	# Enable main UI
	_set_main_ui_enabled(true)
	
	# Initialize with random elements
	_initialize_with_elements(random_elements)

func _on_size_back_pressed() -> void:
	"""Back button on size modal - go back to choice modal"""
	btn_sound.play()
	config_size_modal.hide()
	_show_config_modal()  # Go back to choice modal

func _on_size_next_pressed() -> void:
	"""Next button on size modal - proceed to elements input"""
	btn_sound.play()
	
	# Get the size value
	MAX_QUEUE_SIZE = int(size_input.value)
	print(" User configured queue size:", MAX_QUEUE_SIZE)
	
	# Proceed to elements configuration
	_show_config_elements_modal()

func _on_elements_back_pressed() -> void:
	"""Back button on elements modal - go back to size input"""
	btn_sound.play()
	config_elements_modal.hide()
	_show_config_size_modal()

func _on_elements_done_pressed() -> void:
	"""Done button on elements modal - finalize configuration"""
	btn_sound.play()
	
	# Collect values from all input boxes
	var elements_array: Array[int] = []
	var has_errors = false
	
	for i in range(element_inputs.size()):
		var line_edit = element_inputs[i]
		var value_text = line_edit.text.strip_edges()
		
		# Handle empty input (use default 1)
		if value_text.is_empty():
			value_text = "1"
			line_edit.text = "1"
		
		if not value_text.is_valid_int():
			# Show error
			line_edit.add_theme_color_override("font_color", Color.RED)
			has_errors = true
			print(" Error: Element", i + 1, "is not a valid number")
		else:
			var value = int(value_text)
			if value < 0 or value > 999:
				line_edit.add_theme_color_override("font_color", Color.RED)
				has_errors = true
				print(" Error: Element", i + 1, "must be between 0-999")
			else:
				elements_array.append(value)
				line_edit.remove_theme_color_override("font_color")
	
	if has_errors:
		print(" Please fix all errors before continuing")
		return
	
	print(" User configured elements:", elements_array)
	
	# Hide the modal
	config_elements_modal.hide()

	_set_main_ui_enabled(true)
	
	# Initialize simulation with configured elements
	_initialize_with_elements(elements_array)

func _initialize_with_elements(elements: Array[int]) -> void:
	reset_cache_for_scene()
	code_lines.clear()
	
	for lbl in index_labels:
		if is_instance_valid(lbl): lbl.queue_free()
	index_labels.clear()
	
	print(" Initializing simulation with queue size:", MAX_QUEUE_SIZE, " and elements:", elements)
	audio_player.play()
	waiting_elements = elements.duplicate()
	initial_waiting_elements = elements.duplicate()
	_add_code_line("INITIAL", 0, 0)
	
	if waiting_btn and not waiting_btn.is_connected("pressed", _on_waiting_pressed):
		waiting_btn.pressed.connect(_on_waiting_pressed)
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
	
	_update_labels()
	_update_front_rear_visibility()

# ADD THIS NEW FUNCTION RIGHT HERE (after _initialize_with_elements but before start_tutorial)
func _add_code_line(op: String, index: int, value: int) -> void:
	"""Add an operation to the code generation log"""
	code_lines.append("%s|%d|%d" % [op, index, value])


func start_tutorial() -> void:
	print("Tutorial starting...")
	btn_sound.play()
	
	# STOP THE SIMULATION AND CLEAR ALL DATA FIRST
	_clear_simulation_data()
	
	# Initialize tutorial state
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	tutorial_overlay.show()
	
	dim_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dim_bg.show()
	tutorial_box.show()
	
	# Define the tutorial sequence
	tutorial_sequence = [
		# Step 1: Enqueue button
		{
			"node": enqueue_btn,
			"text": "This is the ENQUEUE button. It adds new data into the queue. Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": null,
			"pre_action": "_setup_for_enqueue_tutorial"  # NEW: Prepare tutorial state
		},
		# Step 2: Dequeue button
		{
			"node": dequeue_btn,
			"text": "This is the DEQUEUE button. It removes data from the front of the queue (FIFO). Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": null,
			"pre_action": "_setup_for_dequeue_tutorial"  # NEW: Prepare tutorial state
		},
		# Step 3: Dequeued Elements button
		{
			"node": dequeued_btn,
			"text": "This button shows all dequeued elements — the ones already processed. Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": "dequeued"
		},
		{
			"node": peek_btn,
			"text": "This is the PEEK button. It lets you view the front element without removing it. Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": null,
			"pre_action": "_setup_for_peek_tutorial" # We'll create this function below
		},
		
		# ... (Next step: Dequeued Elements button) ...
		{
			"node": waiting_btn,
			"text": "Here you can view waiting elements that will enter the queue next. Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": "waiting"
		},
		# Step 5: Timeline button
		{
			"node": timeline_btn,
			"text": "The TIMELINE button shows a record of all enqueue and dequeue actions. Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": "timeline"
		},
		# Step 6: Simulate New button
		{
			"node": simulate_new_btn,
			"text": "This button restarts the simulation with new random data. Use it to practice again.",
			"action": "end",
			"highlight_only": true,
			"pointer_position": "none",
			"popup_to_close": null
		},
	]
	
	# Start the first step
	show_tutorial_step()

func show_tutorial_step() -> void:
	if tutorial_sequence_index >= tutorial_sequence.size():
		end_tutorial()
		return
	
	var step = tutorial_sequence[tutorial_sequence_index]
	var node = step["node"]
	var text = step["text"]
	var action = step["action"]
	var highlight_only = step["highlight_only"]
	var pointer_pos = step["pointer_position"]
	var popup_to_close = step["popup_to_close"]
	var pre_action = step.get("pre_action", "")
	
	# Execute pre-action if exists
	if pre_action != "" and has_method(pre_action):
		call(pre_action)
	
	# Close any popup that should be closed for this step
	if popup_to_close:
		match popup_to_close:
			"dequeued":
				if dequeued_container and dequeued_container.visible:
					dequeued_container.hide()
					if front2_icon: front2_icon.hide()
					if rear2_icon: rear2_icon.hide()
			"waiting":
				if waiting_popup and waiting_popup.visible:
					waiting_popup.hide()
			"timeline":
				if timeline_popup and timeline_popup.visible:
					timeline_popup.hide()
	
	# Set tutorial text
	tutorial_text.text = text
	
	# Configure Next button visibility
	if action == "press":
		tutorial_next.hide()
		# Only disable other buttons if this is a "press" step
		if node:
			enable_only_target_button(node)
	elif action == "next":
		tutorial_next.show()
		tutorial_next.text = "Next"
		# Enable all buttons for highlight-only steps
		enable_all_buttons()
		# Still highlight the target
		if node:
			node.disabled = false
	elif action == "end":
		tutorial_next.text = "Finish"
		tutorial_next.show()
		enable_all_buttons()
	
	# Show/hide pointer
	if pointer_pos == "center" and node:
		show_pointer_at_node(node)
	elif pointer_pos == "none":
		pointer_sprite.hide()
	
	# Apply visual effects
	if node:
		# Apply highlight effect
		apply_highlight_effect(node, highlight_only)
	else:
		# Clear highlight if no node
		clear_highlights()
	
	# Show the tutorial UI
	tutorial_box.show()

func show_pointer_at_node(node: Control) -> void:
	pointer_sprite.show()
	var node_rect = node.get_global_rect()
	
	# Calculate pointer position - placing it to the left of the button
	var pointer_pos = node_rect.position + Vector2(200, node_rect.size.y / 2 - 16)
	pointer_sprite.global_position = pointer_pos

func apply_highlight_effect(node: Control, highlight_only: bool) -> void:
	# Clear previous highlights
	clear_highlights()
	
	if highlight_only:
		# Just highlight with a subtle effect
		node.modulate = Color(1.2, 1.2, 0.8, 1)
		node.grab_focus()
	else:
		# Strong highlight for buttons that need to be pressed
		node.modulate = Color(2.0, 2.0, 0.5, 1)
		node.grab_focus()
		
		# Check if we already have a tween running for this node
		if node.has_meta("tween"):
			var existing_tween: Tween = node.get_meta("tween")
			if existing_tween and existing_tween.is_valid():
				existing_tween.stop()
				node.remove_meta("tween")
		
		# Create new tween with pulsing animation
		var tween = create_tween()
		tween.set_loops()
		node.set_meta("tween", tween)
		
		# Animate the modulate property
		tween.tween_property(node, "modulate", Color(1.5, 1.5, 0.3, 1), 0.5)
		tween.tween_property(node, "modulate", Color(2.0, 2.0, 0.5, 1), 0.5)

func clear_highlights() -> void:
	var nodes_to_clear = [enqueue_btn, dequeue_btn, peek_btn, waiting_btn, dequeued_btn, timeline_btn, simulate_new_btn, enqueue_label, dequeue_label]
	
	for node in nodes_to_clear:
		if node and node.has_meta("tween"):
			var tween: Tween = node.get_meta("tween")
			if tween and tween.is_valid():
				tween.stop()
			node.remove_meta("tween")
	
	# Reset all UI elements to normal
	if enqueue_btn: enqueue_btn.modulate = Color(1, 1, 1, 1)
	if dequeue_btn: dequeue_btn.modulate = Color(1, 1, 1, 1)
	if waiting_btn: waiting_btn.modulate = Color(1, 1, 1, 1)
	if dequeued_btn: dequeued_btn.modulate = Color(1, 1, 1, 1)
	if timeline_btn: timeline_btn.modulate = Color(1, 1, 1, 1)
	if simulate_new_btn: simulate_new_btn.modulate = Color(1, 1, 1, 1)
	if enqueue_label: enqueue_label.modulate = Color(1, 1, 1, 1)
	if dequeue_label: dequeue_label.modulate = Color(1, 1, 1, 1)
	if peek_btn: peek_btn.modulate = Color(1, 1, 1, 1)

func enable_only_target_button(target_node: Control) -> void:
	# Disable all buttons except the target
	if enqueue_btn: 
		enqueue_btn.disabled = true
		if target_node == enqueue_btn:
			enqueue_btn.disabled = false
	
	if dequeue_btn: 
		dequeue_btn.disabled = true
		if target_node == dequeue_btn:
			dequeue_btn.disabled = false
	
	if peek_btn: 
		peek_btn.disabled = true
		if target_node == peek_btn:
			peek_btn.disabled = false
	
	if waiting_btn: 
		waiting_btn.disabled = true
		if target_node == waiting_btn:
			waiting_btn.disabled = false
	
	if dequeued_btn: 
		dequeued_btn.disabled = true
		if target_node == dequeued_btn:
			dequeued_btn.disabled = false
	
	if timeline_btn: 
		timeline_btn.disabled = true
		if target_node == timeline_btn:
			timeline_btn.disabled = false
	
	if simulate_new_btn: 
		simulate_new_btn.disabled = true

func enable_all_buttons() -> void:
	# Enable all buttons
	if enqueue_btn: enqueue_btn.disabled = false
	if dequeue_btn: dequeue_btn.disabled = false
	if waiting_btn: waiting_btn.disabled = false
	if dequeued_btn: dequeued_btn.disabled = false
	if timeline_btn: timeline_btn.disabled = false
	if simulate_new_btn: simulate_new_btn.disabled = false
	if peek_btn: peek_btn.disabled = false

func end_tutorial() -> void:
	tutorial_in_progress = false
	tutorial_overlay.hide()
	clear_highlights()
	pointer_sprite.hide()
	current_popup = null
	
	if dequeued_container and dequeued_container.visible:
		dequeued_container.hide()
		if front2_icon: front2_icon.hide()
		if rear2_icon: rear2_icon.hide()
	if waiting_popup and waiting_popup.visible:
		waiting_popup.hide()
	if timeline_popup and timeline_popup.visible:
		timeline_popup.hide()
	
	_clear_simulation_data()
	
	for child in queue_container.get_children():
		child.queue_free()
	for child in dequeued_container.get_children():
		if child != dequeued_close_btn:
			child.queue_free()
	for lbl in index_labels:
		if is_instance_valid(lbl): lbl.queue_free()
	index_labels.clear()

	_update_labels()
	_update_front_rear_visibility()
	_show_config_modal()

func _on_enqueue_pressed() -> void:
	# Check if in tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == enqueue_btn and current_step["action"] == "press":
			# Perform tutorial enqueue
			_perform_tutorial_enqueue()
			return
		else:
			print("Tutorial: Please press the highlighted button first")
			return
	
	# Regular enqueue logic
	_perform_regular_enqueue()

func _perform_tutorial_enqueue() -> void:
	btn_sound.play()
	if waiting_elements.is_empty():
		waiting_elements = [10, 20, 30, 40, 50]
	if queue.size() >= MAX_QUEUE_SIZE:
		queue.clear()
		for child in queue_container.get_children():
			child.queue_free()
		for lbl in index_labels:
			if is_instance_valid(lbl): lbl.queue_free()
		index_labels.clear()
	
	var new_val: int = waiting_elements.pop_front()
	queue.append(new_val)
	enqueue_counter += 1
	timeline_log.append("Enqueued %d" % new_val)
	_add_code_line("ENQUEUE", queue.size() - 1, new_val)

	var new_block: Control = BLOCK_SCENE.instantiate() as Control
	if new_block.has_method("set"): new_block.set("value", new_val)
	queue_container.add_child(new_block)
	
	var index_label = _create_index_label(queue.size() - 1)
	queue_container.add_child(index_label)
	index_labels.append(index_label)
	
	var target_x = START_POSITION.x + (queue.size() - 1) * (new_block.size.x + BLOCK_SPACING)
	var final_pos = Vector2(target_x, START_POSITION.y)
	var label_final_pos = final_pos + Vector2(new_block.size.x / 2 - 15, INDEX_LABEL_OFFSET)
	
	new_block.position = final_pos + Vector2(200, 0) 
	new_block.modulate.a = 0
	index_label.position = label_final_pos + Vector2(200, 0)
	index_label.modulate.a = 0
	
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(new_block, "position", final_pos, 0.5)
	tween.tween_property(new_block, "modulate:a", 1.0, 0.4)
	tween.tween_property(index_label, "position", label_final_pos, 0.5)
	tween.tween_property(index_label, "modulate:a", 1.0, 0.4)

	_update_labels()
	_update_front_rear_visibility()
	tutorial_sequence_index += 1
	show_tutorial_step()

func _perform_regular_enqueue() -> void:
	if queue.size() >= MAX_QUEUE_SIZE:
		if queue.is_empty() and waiting_elements.is_empty():
			Queue_full.visible = true
		return

	btn_sound.play()
	var new_val: int = waiting_elements.pop_front()
	queue.append(new_val)
	enqueue_counter += 1
	timeline_log.append("Enqueued %d" % new_val)
	_add_code_line("ENQUEUE", queue.size() - 1, new_val)

	var new_block: Control = BLOCK_SCENE.instantiate() as Control
	if new_block.has_method("set"): new_block.set("value", new_val)
	queue_container.add_child(new_block)
	
	var index_label = _create_index_label(queue.size() - 1)
	queue_container.add_child(index_label)
	index_labels.append(index_label)
	
	var target_x = START_POSITION.x + (queue.size() - 1) * (new_block.size.x + BLOCK_SPACING)
	var final_pos = Vector2(target_x, START_POSITION.y)
	var label_final_pos = final_pos + Vector2(new_block.size.x / 2 - 15, INDEX_LABEL_OFFSET)
	
	new_block.position = final_pos + Vector2(200, 0) 
	new_block.modulate.a = 0
	index_label.position = label_final_pos + Vector2(200, 0)
	index_label.modulate.a = 0
	
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(new_block, "position", final_pos, 0.5)
	tween.tween_property(new_block, "modulate:a", 1.0, 0.4)
	tween.tween_property(index_label, "position", label_final_pos, 0.5)
	tween.tween_property(index_label, "modulate:a", 1.0, 0.4)

	_update_labels()
	_update_front_rear_visibility()

func _on_dequeue_pressed() -> void:
	if is_dequeuing_active: return

	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == dequeue_btn and current_step["action"] == "press":
			pass
		else:
			return

	if queue.is_empty(): return
	is_dequeuing_active = true
	btn_sound.play()
	
	var removed_val: int = queue.pop_front()
	dequeue_counter += 1
	dequeued_elements.append(removed_val)
	timeline_log.append("Dequeued %d" % removed_val)
	_add_code_line("DEQUEUE", 0, removed_val)

	var front_block = null
	for child in queue_container.get_children():
		if not child is Label and not child.is_queued_for_deletion():
			front_block = child
			break
			
	var front_label = null
	if index_labels.size() > 0:
		front_label = index_labels.pop_front()

	var exit_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	if front_block:
		exit_tween.tween_property(front_block, "position", front_block.position + Vector2(-200, 0), 0.4)
		exit_tween.tween_property(front_block, "modulate:a", 0.0, 0.3)
	if front_label:
		exit_tween.tween_property(front_label, "position", front_label.position + Vector2(-200, 0), 0.4)
		exit_tween.tween_property(front_label, "modulate:a", 0.0, 0.3)
	
	await exit_tween.finished

	if is_instance_valid(front_block):
		front_block.queue_free()
	if is_instance_valid(front_label):
		front_label.queue_free()

	_animate_queue_shift()
	_update_labels()
	_update_front_rear_visibility()

	is_dequeuing_active = false

	if queue.is_empty() and waiting_elements.is_empty():
		_show_complete_popup()
	
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == dequeue_btn and current_step["action"] == "press":
			tutorial_sequence_index += 1
			show_tutorial_step()

func _animate_queue_shift() -> void:
	var x = START_POSITION.x
	var shift_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	var i = 0
	for child in queue_container.get_children():
		if child is Label or child.is_queued_for_deletion(): continue
		
		shift_tween.tween_property(child, "position", Vector2(x, START_POSITION.y), 0.4)
		child.original_position = Vector2(x, START_POSITION.y)
		
		if i < index_labels.size():
			var lbl = index_labels[i]
			lbl.text = str(i)
			var label_target = Vector2(x + (child.size.x / 2) - 15, START_POSITION.y + INDEX_LABEL_OFFSET)
			shift_tween.tween_property(lbl, "position", label_target, 0.4)
		
		x += child.size.x + BLOCK_SPACING
		i += 1

func _on_waiting_pressed() -> void:
	# Check if in tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == waiting_btn and current_step["action"] == "press":
			pass
		else:
			print("Tutorial: Please press the highlighted button first")
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

	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == waiting_btn and current_step["action"] == "press":
			tutorial_sequence_index += 1
			show_tutorial_step()
			waiting_popup.hide()

func _on_timeline_pressed() -> void:
	# Check if in tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == timeline_btn and current_step["action"] == "press":
			pass
		else:
			print("Tutorial: Please press the highlighted button first")
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
	
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == timeline_btn and current_step["action"] == "press":
			tutorial_sequence_index += 1
			show_tutorial_step()
			timeline_popup.hide()

func _on_dequeued_pressed() -> void:
	# Check if in tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == dequeued_btn and current_step["action"] == "press":
			pass
		else:
			print("Tutorial: Please press the highlighted button first")
			return
	
	btn_sound.play()
	if dequeued_container.visible:
		dequeued_container.hide()
		if front2_icon: front2_icon.hide()
		if rear2_icon: rear2_icon.hide()
		current_popup = null
	else:
		_refresh_dequeued_list()
		dequeued_container.show()
		if front2_icon: front2_icon.show()
		if rear2_icon: rear2_icon.show()
		current_popup = dequeued_container
	
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == dequeued_btn and current_step["action"] == "press":
			tutorial_sequence_index += 1
			show_tutorial_step()

func _on_dequeued_close_pressed() -> void:
	btn_sound.play()
	dequeued_container.hide()
	if front2_icon: front2_icon.hide()
	if rear2_icon: rear2_icon.hide()
	current_popup = null


func _show_complete_popup() -> void:
	# Use the existing SimulationCompletePopup, not the ResultPopup scene
	if complete_popup:
		var total_processes = enqueue_counter + dequeue_counter
		var process_text = "Total Processes: %d\n→ Enqueue: %d\n→ Dequeue: %d" % [total_processes, enqueue_counter, dequeue_counter]

		if process_label:
			process_label.text = process_text

		complete_popup.popup_centered()
		print(" Showing 'Simulation Complete' popup...")

		if cpp_code_button:
			cpp_code_button.show()
			code_sprite.play("default")
	else:
		print("ERROR: complete_popup not found!")

func _compute_grade() -> Dictionary:
	var total_moves = enqueue_counter + dequeue_counter
	var passed = true
	
	return {
		"passed": passed,
		"accuracy": 100.0,
		"correct_moves": enqueue_counter,
		"bad_moves": dequeue_counter,
		"time_used": 0,
		"coins": 10,
		"required": 60
	}

func _on_complete_ok_pressed() -> void:
	btn_sound.play()
	if complete_popup:
		complete_popup.hide()

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	if complete_popup and complete_popup.visible:
		complete_popup.hide()
	_show_cpp_popup()

func _show_cpp_popup() -> void:
	btn_sound.play()
	
	# Reset tutorial state to ensure fresh start
	cpp_tutorialcode_index = 0
	
	if cpp_popup and cpp_text:
		# Generate code using INITIAL elements, not current waiting_elements
		var source_arr: Array = []
		if initial_waiting_elements.size() > 0:
			source_arr = initial_waiting_elements.duplicate()
		elif dequeued_elements.size() > 0:
			source_arr = dequeued_elements.duplicate()
		elif queue.size() > 0:
			source_arr = queue.duplicate()
		else:
			source_arr = [10, 20, 30]
			
		var code = generate_code_in_language(current_code_language, source_arr)
		
		cpp_text.text = code
		cpp_text.custom_minimum_size = Vector2(700, 420)
		
		# Update popup title based on language
		var lang_names = {
			"cpp": "C++ Code",
			"python": "Python Code", 
			"java": "Java Code",
			"c": "C Code",
			"javascript": "JavaScript Code"
		}
		cpp_popup.title = lang_names.get(current_code_language, "Code")
		
		# ENSURE TUTORIAL PANEL IS SHOWN
		if cpp_tutorial_panel:
			cpp_tutorial_panel.show()
			
		if cpp_explanation_text:
			# Reset to first explanation
			cpp_explanation_text.text = "💡 Click 'Next' to walk through this code explanation!"
		
		if cpp_next_button:
			cpp_next_button.show()
			cpp_next_button.text = "Next"
		
		# Reset highlighting and show first explanation
		clear_cpp_highlight()
		show_cpp_explanation()
		
		cpp_popup.popup_centered()
		
		# Update language buttons highlighting
		update_language_button_states()
		
		print(" Showing code in: ", current_code_language.to_upper())

func generate_code_in_language(lang: String, source_arr: Array) -> String:
	var arr_str := ", ".join(source_arr.map(func(x): return str(x)))
	var n = source_arr.size()
	
	match lang:
		"python":
			return generate_python_code(arr_str, n)
		"java":
			return generate_java_code(arr_str, n)
		"c":
			return generate_c_code(arr_str, n)
		_:  # Default to C++
			return generate_cpp_code(arr_str, n)

# ==============================================
#   CODE GENERATION FUNCTIONS (WITH LIVE PRINTS)
# ==============================================

func generate_cpp_code(arr_str: String, _n: int) -> String:
	return """#include <iostream>
#include <queue>
using namespace std;

int main() {
	int arr[] = { %s };
	int n = sizeof(arr) / sizeof(arr[0]);
	queue<int> q;

	for (int i = 0; i < n; ++i) {
		q.push(arr[i]);
		cout << "Enqueued " << arr[i] << " | Queue: ";
		queue<int> temp = q; // Copy to print without modifying
		while (!temp.empty()) {
			cout << temp.front() << " ";
			temp.pop();
		}
		cout << endl;
	}

	cout << "\\nInitial queue front: " << q.front() << endl;
	cout << "Dequeuing..." << endl;

	while (!q.empty()) {
		int dequeued = q.front();
		q.pop();
		cout << "Dequeued " << dequeued << " | Queue: ";
		queue<int> temp = q;
		while (!temp.empty()) {
			cout << temp.front() << " ";
			temp.pop();
		}
		cout << endl;
	}

	cout << "Simulation finished." << endl;
	return 0;
}
/*
 Complexity:
 Time: %s
 Space: %s
*/""" % [arr_str, get_time_complexity(), get_space_complexity()]

func generate_python_code(arr_str: String, _n: int) -> String:
	return """from collections import deque

def main():
	arr = [%s]
	q = deque()
	
	for value in arr:
		q.append(value)
		print(f"Enqueued {value} | Queue: {list(q)}")
	
	print(f"\\nInitial queue front: {q[0]}")
	print("Dequeuing...")
	
	while len(q) > 0:
		dequeued = q.popleft()
		print(f"Dequeued {dequeued} | Queue: {list(q)}")
	
	print("Simulation finished.")

if __name__ == "__main__":
	main()
'''
 Complexity:
 Time: %s
 Space: %s
'''""" % [arr_str, get_time_complexity(), get_space_complexity()]

func generate_java_code(arr_str: String, _n: int) -> String:
	return """import java.util.LinkedList;
import java.util.Queue;

public class QueueSim {
	public static void main(String[] args) {
		int[] arr = {%s};
		Queue<Integer> q = new LinkedList<>();
		
		for (int value : arr) {
			q.add(value);
			System.out.println("Enqueued " + value + " | Queue: " + q);
		}
		
		System.out.println("\\nInitial queue front: " + q.peek());
		System.out.println("Dequeuing...");
		
		while (!q.isEmpty()) {
			int dequeued = q.poll();
			System.out.println("Dequeued " + dequeued + " | Queue: " + q);
		}
		System.out.println("Simulation finished.");
	}
}
/*
 Complexity:
 Time: %s
 Space: %s
*/""" % [arr_str, get_time_complexity(), get_space_complexity()]

func generate_c_code(arr_str: String, _n: int) -> String:
	var code = """#include <stdio.h>
#define MAX_SIZE 100

typedef struct {
	int items[MAX_SIZE];
	int front;
	int rear;
} Queue;

void initQueue(Queue *q) { q->front = -1; q->rear = -1; }
int isFull(Queue *q) { return q->rear == MAX_SIZE - 1; }
int isEmpty(Queue *q) { return q->front == -1 || q->front > q->rear; }

void enqueue(Queue *q, int value) {
	if (isFull(q)) { printf("Queue full!\\n"); return; }
	if (q->front == -1) q->front = 0;
	q->items[++(q->rear)] = value;
}

int dequeue(Queue *q) {
	if (isEmpty(q)) { printf("Queue empty!\\n"); return -1; }
	return q->items[(q->front)++];
}

void printQueue(Queue *q) {
	if (isEmpty(q)) return;
	for (int i = q->front; i <= q->rear; i++) {
		printf("%d ", q->items[i]);
	}
}

int main() {
	int arr[] = {{ARR}};
	int n = sizeof(arr) / sizeof(arr[0]);
	Queue q;
	initQueue(&q);
	
	for (int i = 0; i < n; i++) {
		enqueue(&q, arr[i]);
		printf("Enqueued %d | Queue: ", arr[i]);
		printQueue(&q);
		printf("\\n");
	}
	
	printf("\\nInitial queue front: %d\\n", q.items[q.front]);
	printf("Dequeuing...\\n");
	
	while (!isEmpty(&q)) {
		int dequeued = dequeue(&q);
		printf("Dequeued %d | Queue: ", dequeued);
		printQueue(&q);
		printf("\\n");
	}
	
	printf("Simulation finished.\\n");
	return 0;
}
/*
 * COMPLEXITY:
 * Time: {TIME}
 * Space: {SPACE}
 */"""
	return code.replace("{ARR}", arr_str).replace("{TIME}", get_time_complexity()).replace("{SPACE}", get_space_complexity())

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
	"""Refresh the code display with current language"""
	if cpp_popup and cpp_popup.visible and cpp_text:
		var source_arr: Array = []
		if initial_waiting_elements.size() > 0:
			source_arr = initial_waiting_elements.duplicate()
		elif dequeued_elements.size() > 0:
			source_arr = dequeued_elements.duplicate()
		elif queue.size() > 0:
			source_arr = queue.duplicate()
		else:
			source_arr = [10, 20, 30]
		
		var code = generate_code_in_language(current_code_language, source_arr)
		cpp_text.text = code
		update_language_button_states()
		
		# Reset tutorial and highlighting
		cpp_tutorialcode_index = 0
		clear_cpp_highlight()
		if cpp_explanation_text:
			cpp_explanation_text.text = "💡 Click 'Next' to walk through this code explanation!"

func get_time_complexity() -> String:
	var ops = []
	# Basic Queue operations are always O(1)
	if enqueue_counter > 0:
		ops.append("• Enqueue (push): O(1)")
	if dequeue_counter > 0:
		ops.append("• Dequeue (pop): O(1)")
	if not queue.is_empty():
		ops.append("• Front/Rear access: O(1)")
	# Printing the whole queue takes O(n)
	if timeline_log.size() > 0:
		ops.append("• Traversal (printing): O(n)")
	
	if ops.is_empty():
		return "• Enqueue/Dequeue: O(1)"
		
	return "\n".join(ops)

func get_space_complexity() -> String:
	var total_elements = queue.size() + waiting_elements.size() + dequeued_elements.size()
	return "O(n) — where n = %d (total elements handled)" % total_elements

func _on_cpp_close_pressed() -> void:
	btn_sound.play()
	
	# Reset tutorial state when closing
	reset_cpp_tutorial_state()
	
	# Don't hide the tutorial panel, just reset it
	if cpp_tutorial_panel:
		cpp_tutorial_panel.show()
	
	if cpp_popup:
		cpp_popup.hide()

# ==============================================
# HELPER FUNCTIONS
# ==============================================

func _refresh_dequeued_list() -> void:
	for child in dequeued_container.get_children():
		if child != dequeued_close_btn:
			child.queue_free()

	if dequeued_elements.is_empty():
		var lbl: Label = Label.new()
		lbl.text = "No dequeued elements yet."
		dequeued_container.add_child(lbl)
		return

	for i in range(dequeued_elements.size()):
		var value: int = dequeued_elements[i]
		var block := BLOCK_SCENE.instantiate() as Control
		var lbl := block.get_node_or_null("NumberLabel")
		if lbl and lbl is Label:
			lbl.text = str(value)
		var bg := block.get_node_or_null("Bg")
		if bg and bg is ColorRect:
			bg.color = colors[i % colors.size()]
		if block.get_script() != null:
			block.set_script(null)
		block.mouse_filter = Control.MOUSE_FILTER_IGNORE
		block.modulate = Color(0.85, 0.85, 0.85, 1.0)
		dequeued_container.add_child(block)

func _update_labels() -> void:
	enqueue_label.text = "Enqueue Counter: %d" % enqueue_counter
	dequeue_label.text = "Dequeue Counter: %d" % dequeue_counter
	
	var queue_is_full = queue.size() >= MAX_QUEUE_SIZE
	enqueue_btn.disabled = waiting_elements.is_empty() or queue_is_full
	dequeue_btn.disabled = queue.is_empty()
	
	if queue_is_full:
		enqueue_btn.modulate = Color(0.7, 0.3, 0.3, 0.9)
		if Queue_full and not Queue_full.visible:
			Queue_full.visible = true
			anim_sprite.play("default")
			var timer = get_tree().create_timer(2.0)
			timer.timeout.connect(_hide_queue_full_panel)
	elif waiting_elements.is_empty():
		enqueue_btn.modulate = Color(0.5, 0.5, 0.5, 0.7)
	else:
		enqueue_btn.modulate = Color.WHITE
		
	if queue.is_empty():
		dequeue_btn.modulate = Color(0.5, 0.5, 0.5, 0.7)
	else:
		dequeue_btn.modulate = Color.WHITE
		
	if peek_btn:
		peek_btn.disabled = queue.is_empty()
		if queue.is_empty(): peek_btn.modulate = Color(0.5, 0.5, 0.5, 0.7)
		else: peek_btn.modulate = Color.WHITE
		
	_update_indicators()

func _hide_queue_full_panel() -> void:
	if Queue_full and Queue_full.visible:
		var tween = create_tween()
		tween.tween_property(Queue_full, "modulate:a", 0.0, 0.5)
		await tween.finished
		Queue_full.visible = false
		Queue_full.modulate.a = 1.0

func update_language_button_states() -> void:
	"""Update which language button is highlighted/active"""
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
	var x = START_POSITION.x
	var i = 0
	for child in queue_container.get_children():
		if child is Label or child.is_queued_for_deletion(): continue
		child.position = Vector2(x, START_POSITION.y)
		child.original_position = child.position
		
		if i < index_labels.size():
			var lbl = index_labels[i]
			lbl.text = str(i)
			lbl.position = Vector2(x + (child.size.x / 2) - 15, START_POSITION.y + INDEX_LABEL_OFFSET)
		
		x += child.size.x + BLOCK_SPACING
		i += 1

func _shift_blocks_left() -> void:
	_resnap_blocks()

func _update_front_rear_visibility() -> void:
	if queue.size() > 0:
		if front_icon: front_icon.show()
		if rear_icon: rear_icon.show()
	else:
		if front_icon: front_icon.hide()
		if rear_icon: rear_icon.hide()

# ==============================================
# SIMULATE NEW
# ==============================================

func _on_simulate_new_pressed() -> void:
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == simulate_new_btn and current_step["action"] == "press":
			pass
		else:
			print("Tutorial: Please press the highlighted button first")
			return
	reset_cpp_tutorial_state()
	sim_confirmation.show()
	

func _on_yes_pressed() -> void:
	if tutorial_in_progress: return
	btn_sound.play()
	sim_confirmation.hide()
	sim_success.show()
	
	var timer = get_tree().create_timer(2.0)
	await timer.timeout
	sim_success.hide()
	
	_clear_simulation_data()
	for child in queue_container.get_children(): child.queue_free()
	for child in dequeued_container.get_children():
		if child != dequeued_close_btn: child.queue_free()
	for lbl in index_labels:
		if is_instance_valid(lbl): lbl.queue_free()
	index_labels.clear()
	
	if Queue_full and Queue_full.visible: Queue_full.hide()
	reset_cpp_tutorial_state()
	_update_labels()
	_update_front_rear_visibility()
	_show_config_modal()

func _on_no_pressed() -> void:
	btn_sound.play()
	sim_confirmation.hide()

func _on_cpp_code_button_pressed() -> void:
	btn_sound.play()
	
	# Reset C++ tutorial state before showing popup
	reset_cpp_tutorial_state()
	
	# Ensure tutorial panel will be visible
	if cpp_tutorial_panel:
		cpp_tutorial_panel.show()
	
	# Show the popup
	_show_cpp_popup()

func _on_close_pressed() -> void:
	if cpp_popup:
		cpp_popup.hide()
		reset_cpp_tutorial_state()
	btn_sound.play()

func _on_help_button_pressed() -> void:
	btn_sound.play()
	get_node("HelpButton").disabled = true
	get_node("CppCodeButton").disabled = true
	# If tutorial is already running, restart it
	if tutorial_in_progress:
		end_tutorial()
		await get_tree().create_timer(0.1).timeout
	

	
	start_tutorial()

func _on_next_button_pressed() -> void:
	btn_sound.play()
	
	if not tutorial_in_progress:
		return
	
	if tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		
		if current_step["action"] == "next":
			tutorial_sequence_index += 1
			show_tutorial_step()
		elif current_step["action"] == "end":
			end_tutorial()

func _on_got_it_pressed() -> void:
	btn_sound.play()
	if Queue_full:
		Queue_full.hide()

func show_introduction() -> void:
	"""Show the introduction popup when the game starts"""
	print("Showing introduction popup...")
	
	if not intro_popup:
		print("Introduction popup not found!")
		return
	
	# Reset to first step
	intro_step = 0
	intro_label.text = intro_texts[intro_step]
	
	# Connect buttons if not already connected
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
	"""Update button text and visibility based on current step"""
	if not intro_next_btn or not intro_prev_btn or not intro_skip_btn:
		return
	
	# Show/hide Previous button (hide on first step)
	if intro_prev_btn:
		intro_prev_btn.visible = (intro_step > 0)
	
	# Update Next button text
	if intro_step == intro_texts.size() - 1:
		intro_next_btn.text = "Got it"
		if intro_skip_btn:
			intro_skip_btn.visible = false
	else:
		intro_next_btn.text = "Next"
		if intro_skip_btn:
			intro_skip_btn.visible = true

func _on_intro_next_pressed() -> void:
	btn_sound.play()
	
	if intro_step < intro_texts.size() - 1:
		intro_step += 1
		intro_label.text = intro_texts[intro_step]
		_update_intro_buttons()
	else:
		if intro_popup:
			intro_popup.hide()
		_set_main_ui_enabled(true)

func _on_intro_skip_pressed() -> void:
	btn_sound.play()
	
	if intro_popup:
		intro_popup.hide()
	_set_main_ui_enabled(true)

func _on_intro_prev_pressed() -> void:
	btn_sound.play()
	
	if intro_step > 0:
		intro_step -= 1
		intro_label.text = intro_texts[intro_step]
		_update_intro_buttons()

func _on_ok_btn_pressed() -> void:
	waiting_popup.hide()

func _set_main_ui_enabled(enabled: bool) -> void:
	"""Enable/disable main UI buttons"""
	if enqueue_btn: enqueue_btn.disabled = not enabled
	if dequeue_btn: dequeue_btn.disabled = not enabled
	if waiting_btn: waiting_btn.disabled = not enabled
	if dequeued_btn: dequeued_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled
	if simulate_new_btn: simulate_new_btn.disabled = not enabled
	get_node("HelpButton").disabled = not enabled
	get_node("CppCodeButton").disabled = not enabled
	if peek_btn: peek_btn.disabled = not enabled

# Add these missing functions at the end

func _on_block_dropped(dropped_block: Control) -> void:
	var children: Array = queue_container.get_children()
	var old_index: int = children.find(dropped_block)
	var center_x: float = dropped_block.position.x + dropped_block.size.x * 0.5
	var insert_index: int = 0
	for c in children:
		if c == dropped_block:
			continue
		var c_center: float = c.position.x + c.size.x * 0.5
		if center_x > c_center:
			insert_index += 1

	if old_index == 0 and insert_index > 0:
		print(" FIFO rule: front block cannot move!")
		dropped_block.position = dropped_block.original_position
		_resnap_blocks()
		return

	queue_container.move_child(dropped_block, insert_index)
	var moved_val: int = queue.pop_at(old_index)
	queue.insert(insert_index, moved_val)
	timeline_log.append("Moved %d from %d → %d" % [moved_val, old_index, insert_index])
	_add_code_line("MOVE", insert_index, moved_val)
	_resnap_blocks()

func start_cpp_code_tutorial() -> void:
	if not cpp_popup or not cpp_text or not cpp_tutorial_panel:
		print("C++ tutorial: Missing required nodes")
		return
	
	# Reset tutorial state
	cpp_tutorialcode_index = 0
	cpp_tutorial_panel.show()
	
	# Generate fresh code using initial elements
	var source_arr: Array = []
	if initial_waiting_elements.size() > 0:
		source_arr = initial_waiting_elements.duplicate()
	elif dequeued_elements.size() > 0:
		source_arr = dequeued_elements.duplicate()
	elif queue.size() > 0:
		source_arr = queue.duplicate()
	else:
		source_arr = [10, 20, 30]
	
	var code = generate_code_in_language(current_code_language, source_arr)
	cpp_text.text = code
	
	highlight_cpp_code()
	show_cpp_explanation()
	
	print("C++ tutorial started from step 0")

func highlight_cpp_code() -> void:
	if not cpp_text:
		return
	
	# Clear any existing highlighting
	cpp_text.remove_theme_stylebox_override("normal")
	
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 0.8, 0.15)
	sb.border_color = Color(1, 1, 0.2, 1)
	sb.set_border_width_all(4)
	cpp_text.add_theme_stylebox_override("normal", sb)
	
	# Clear any previous selection
	cpp_text.deselect()

func clear_cpp_highlight() -> void:
	if not cpp_text:
		return
	
	# Regenerate the original code using initial elements
	var source_arr: Array = []
	if initial_waiting_elements.size() > 0:
		source_arr = initial_waiting_elements.duplicate()
	elif dequeued_elements.size() > 0:
		source_arr = dequeued_elements.duplicate()
	elif queue.size() > 0:
		source_arr = queue.duplicate()
	else:
		source_arr = [10, 20, 30]
	
	var code = generate_code_in_language(current_code_language, source_arr)
	cpp_text.text = code

func show_cpp_explanation() -> void:
	if not cpp_explanation_text:
		return
	
	# Get the appropriate tutorial steps for current language
	var tutorial_steps = _get_tutorial_steps_for_language()
	
	if tutorial_steps.is_empty():
		return
	
	if cpp_tutorialcode_index >= tutorial_steps.size():
		cpp_tutorialcode_index = tutorial_steps.size() - 1
	
	var step = tutorial_steps[cpp_tutorialcode_index]
	
	# Handle both Vector2i and dictionary with "lines" field
	if step is Dictionary and step.has("lines"):
		var lines = step["lines"]
		if lines is Vector2i:
			highlight_cpp_lines(lines.x, lines.y)
		elif lines is Array:
			# If it's an array of line numbers, highlight the range from first to last
			if lines.size() > 0:
				var start_line = lines[0] if lines[0] is int else 0
				var end_line = lines[lines.size() - 1] if lines[lines.size() - 1] is int else 0
				highlight_cpp_lines(start_line, end_line)
		
		# Update explanation text
		if step.has("text"):
			cpp_explanation_text.text = step["text"]
	
	# Update button text based on position
	if cpp_next_button:
		if cpp_tutorialcode_index >= tutorial_steps.size() - 1:
			cpp_next_button.text = "Next (Loop)"
		else:
			cpp_next_button.text = "Next"

func _get_tutorial_steps_for_language() -> Array:
	match current_code_language:
		"cpp":
			return cpp_tutorial_steps
		"python":
			return python_tutorial_steps
		"java":
			return java_tutorial_steps
		"c":
			return c_tutorial_steps
		_:
			return cpp_tutorial_steps

func _on_cpp_next_button_pressed() -> void:
	btn_sound.play()
	
	var tutorial_steps = _get_tutorial_steps_for_language()
	
	# Calculate next index with loop (using modulo operator)
	cpp_tutorialcode_index = (cpp_tutorialcode_index + 1) % tutorial_steps.size()
	
	# Show the explanation for the new step
	show_cpp_explanation()
	
	# Visual feedback when looping (when index goes from last to 0)
	if cpp_tutorialcode_index == 0:
		# Show loop message briefly
		if cpp_explanation_text:
			var _original_text = cpp_explanation_text.text
			cpp_explanation_text.text = "🔄 Looping back to start..."
			
			# Wait briefly before showing first step
			await get_tree().create_timer(0.8).timeout
			
			# Now show the first explanation
			show_cpp_explanation()
		
		# Flash the button to indicate loop
		if cpp_next_button:
			var tween = create_tween()
			tween.tween_property(cpp_next_button, "modulate", Color(0.5, 1, 0.5, 1), 0.2)
			tween.tween_property(cpp_next_button, "modulate", Color.WHITE, 0.2)

func end_cpp_tutorial() -> void:
	cpp_tutorial_panel.hide()
	clear_cpp_highlight()
	_set_main_ui_enabled(true)
	enqueue_btn.disabled = true
	dequeue_btn.disabled = true
	print(" C++ tutorial finished.")

func highlight_cpp_lines(start_line: int, end_line: int) -> void:
	if not cpp_text:
		return
	
	clear_cpp_highlight()
	
	cpp_text.bbcode_enabled = true
	
	var full_text = cpp_text.text
	
	var lines = full_text.split("\n")
	

	if start_line < 0 or end_line >= lines.size():
		print("Warning: Cannot highlight lines %d-%d, text only has %d lines" % [start_line, end_line, lines.size()])
		return
	

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

func _clear_simulation_data() -> void:
	queue.clear()
	waiting_elements.clear()
	dequeued_elements.clear()
	timeline_log.clear()
	code_lines.clear()
	enqueue_counter = 0
	dequeue_counter = 0
	
	for child in queue_container.get_children():
		child.queue_free()
	for child in dequeued_container.get_children():
		if child != dequeued_close_btn: child.queue_free()
	for lbl in index_labels:
		if is_instance_valid(lbl): lbl.queue_free()
	index_labels.clear()
	
	_update_labels()
	_update_front_rear_visibility()
	
	if dequeued_container and dequeued_container.visible:
		dequeued_container.hide()
		if front2_icon: front2_icon.hide()
		if rear2_icon: rear2_icon.hide()
	if waiting_popup and waiting_popup.visible: waiting_popup.hide()
	if timeline_popup and timeline_popup.visible: timeline_popup.hide()
	if complete_popup and complete_popup.visible: complete_popup.hide()
	if cpp_popup and cpp_popup.visible: cpp_popup.hide()
	current_popup = null

func _setup_for_enqueue_tutorial() -> void:
	"""Prepare tutorial state for enqueue step"""
	# Ensure waiting elements exist for enqueue
	if waiting_elements.is_empty():
		waiting_elements = [10, 20, 30, 40, 50]  # Add some elements for tutorial
	
	# Ensure queue is not full
	while queue.size() >= MAX_QUEUE_SIZE:
		queue.pop_back()
	
	_update_labels()

func _setup_for_dequeue_tutorial() -> void:
	if queue.is_empty():
		queue = [10, 20, 30]
		for child in queue_container.get_children(): child.queue_free()
		for lbl in index_labels:
			if is_instance_valid(lbl): lbl.queue_free()
		index_labels.clear()
		
		for i in range(queue.size()):
			var new_block: Control = BLOCK_SCENE.instantiate() as Control
			if new_block.has_method("set"): new_block.set("value", queue[i])
			queue_container.add_child(new_block)
			var index_label = _create_index_label(i)
			queue_container.add_child(index_label)
			index_labels.append(index_label)
		_resnap_blocks()
	_update_labels()

func _setup_for_peek_tutorial() -> void:
	if queue.is_empty():
		queue = [10]
		for child in queue_container.get_children(): child.queue_free()
		for lbl in index_labels:
			if is_instance_valid(lbl): lbl.queue_free()
		index_labels.clear()
			
		var new_block: Control = BLOCK_SCENE.instantiate() as Control
		if new_block.has_method("set"): new_block.set("value", queue[0])
		queue_container.add_child(new_block)
		var index_label = _create_index_label(0)
		queue_container.add_child(index_label)
		index_labels.append(index_label)
		_resnap_blocks()
	_update_labels()

func reset_cpp_tutorial_state() -> void:
	"""Reset C++ tutorial to initial state"""
	print("Resetting C++ tutorial state...")
	
	cpp_tutorial_index = 0
	cpp_tutorialcode_index = 0
	
	# Don't hide the tutorial panel - just reset it
	if cpp_tutorial_panel:
		cpp_tutorial_panel.show()  # Ensure it's shown
	
	# Clear any C++ code highlighting
	if cpp_text:
		clear_cpp_highlight()
		cpp_text.deselect()
	
	# Reset C++ tutorial explanations to show from beginning
	if cpp_explanation_text:
		cpp_explanation_text.text = "💡 Click 'Next' to walk through this code explanation!"
	
	# Reset next button
	if cpp_next_button:
		cpp_next_button.text = "Next"
		cpp_next_button.show()

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
			if code_sprite:
				code_sprite.play("default")
	else:
		result_title.text = "SIMULATION ENDED"
		result_title.modulate = Color.YELLOW
		if translate_code_btn:
			translate_code_btn.show()
		if cpp_code_button:
			cpp_code_button.show()
			if code_sprite:
				code_sprite.play("default")
	
	score_summary.text = "Enqueues: %d | Dequeues: %d" % [grade.get("correct_moves", 0), grade.get("bad_moves", 0)]
	var total_ops = grade.get("correct_moves", 0) + grade.get("bad_moves", 0)
	accuracy_label.text = "Total Operations: %d" % total_ops
	time_used_label.text = "Queue Size: %d" % queue.size()
	coins_label.text = "+%d" % grade.get("coins", 0)
	
	result_popup.popup_centered()
	
	if grade.get("coins", 0) > 0 and coins_anim:
		coins_anim.play("default")

func _on_translate_code_pressed() -> void:
	btn_sound.play()
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
	
	# Use initial waiting elements for code generation
	var source_arr: Array = []
	if initial_waiting_elements.size() > 0:
		source_arr = initial_waiting_elements.duplicate()
	elif dequeued_elements.size() > 0:
		source_arr = dequeued_elements.duplicate()
	elif queue.size() > 0:
		source_arr = queue.duplicate()
	else:
		source_arr = [10, 20, 30]
	
	var code = generate_code_in_language(current_code_language, source_arr)
	
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
	
	print("=== Queue Compile Request ===")
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
	var source_arr: Array = []
	if initial_waiting_elements.size() > 0:
		source_arr = initial_waiting_elements.duplicate()
	elif dequeued_elements.size() > 0:
		source_arr = dequeued_elements.duplicate()
	elif queue.size() > 0:
		source_arr = queue.duplicate()
	else:
		source_arr = [10, 20, 30]
	
	var code = generate_code_in_language(language, source_arr)
	_compile_code(code)


func _on_compiler_output_closed() -> void:
	print("Compiler output closed")


func reset_cache_for_scene() -> void:
	if compiler_output_popup:
		compiler_output_popup.reset_cache_for_scene()
		print("Compiler cache reset for new simulation")

func _on_peek_pressed() -> void:
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == peek_btn and current_step["action"] == "press":
			pass
		else:
			print("Tutorial: Please press the highlighted button first")
			return

	btn_sound.play()

	if queue.is_empty():
		show_feedback("Queue is empty!", Color.RED, peek_btn.global_position + Vector2(100, 0))
		return

	var front_val: int = queue[0]
	timeline_log.append("Peeked at front element: %d" % front_val)
	
	if queue_container.get_child_count() > 0:
		var front_block = queue_container.get_child(0)
		if is_instance_valid(front_block):
			var tween = create_tween()
			tween.tween_property(front_block, "modulate", Color(1.5, 1.5, 0.5, 1.0), 0.2)
			tween.tween_property(front_block, "modulate", Color.WHITE, 0.2)

	show_feedback("Front: " + str(front_val), Color.GREEN, peek_btn.global_position + Vector2(100, -20))

	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == peek_btn and current_step["action"] == "press":
			tutorial_sequence_index += 1
			show_tutorial_step()

func _create_index_label(index: int) -> Label:
	var index_label = Label.new()
	index_label.text = str(index)
	var index_font = load("res://assets/font/Planes_ValMore.ttf")
	if index_font:
		index_label.add_theme_font_override("font", index_font)
	index_label.add_theme_font_size_override("font_size", 32)
	index_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	index_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	index_label.add_theme_constant_override("outline_size", 4)
	index_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return index_label

func _update_indicators() -> void:
	if is_full_indicator:
		if queue.size() >= MAX_QUEUE_SIZE:
			is_full_indicator.modulate = Color(0, 1, 0, 1) # Green
		else:
			is_full_indicator.modulate = Color(0.3, 0.3, 0.3, 1) # Dark gray
			
	if is_empty_indicator:
		if queue.is_empty():
			is_empty_indicator.modulate = Color(1, 0.5, 0.8, 1) # Pink
		else:
			is_empty_indicator.modulate = Color(0.3, 0.3, 0.3, 1) # Dark gray
