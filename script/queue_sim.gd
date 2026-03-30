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

# Top-right shortcut button
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
		"clientId": "f4fc8575ee6c45ca1baf697a28b9771e",
		"clientSecret": "7d8b060459fb304352f243b2a95194c04bf10503b1a06126043bc4f3cada366e"
	},
	"c": {
		"clientId": "f4fc8575ee6c45ca1baf697a28b9771e",
		"clientSecret": "7d8b060459fb304352f243b2a95194c04bf10503b1a06126043bc4f3cada366e"
	},
	"java": {
		"clientId": "f4fc8575ee6c45ca1baf697a28b9771e",
		"clientSecret": "7d8b060459fb304352f243b2a95194c04bf10503b1a06126043bc4f3cada366e"
	},
	"python": {
		"clientId": "f4fc8575ee6c45ca1baf697a28b9771e",
		"clientSecret": "7d8b060459fb304352f243b2a95194c04bf10503b1a06126043bc4f3cada366e"
	}
}

# Tutorial variables — now purely Next-based, no button pressing required
var tutorial_step: int = 0
var tutorial_nodes: Array = []
var tutorial_texts: Array = []
var tutorial_in_progress: bool = false
var current_popup = null

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
var peek_counter: int = 0
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
var cpp_tutorialcode_index := 0
var current_tutorial_data: Array = []

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

# Complexity display
@onready var complexity_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/ComplexityPanel")
@onready var time_label: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/ComplexityPanel/VBoxContainer/TimeLabel")
@onready var space_label: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/ComplexityPanel/VBoxContainer/SpaceLabel")

# Queue full panel
@onready var Queue_full: Panel = $Queue_full

# Animated sprites
@onready var anim_sprite: AnimatedSprite2D = $Queue_full/AnimatedSprite2D
@onready var q_mark_sprite: AnimatedSprite2D = $HelpButton/Q_mark_anim_sprites
@onready var code_sprite: AnimatedSprite2D = $CppCodeButton/code_anim

# Compiler
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
	"Queue Operations:\n\n• ENQUEUE: Add an element to the rear of the queue\n• DEQUEUE: Remove an element from the front of the queue\n• PEEK: View the first element without removing it\n• REAR: View the last element added",
	"Visual Elements:\n\n• Green blocks represent elements in the queue\n• Front indicator shows where elements will be removed\n• Rear indicator shows where new elements will be added\n• Waiting elements are shown in a separate list",
	"How to Use:\n\n1. Click ENQUEUE to add elements from waiting list\n2. Click DEQUEUE to remove elements from front\n3. View waiting/dequeued elements using buttons\n4. Check timeline for operation history\n5. Generate code to see implementation",
	"Ready to Start!\n\nClick 'Got it' to explore on your own. You can always access the tutorial from the Help button."
]

# Configuration variables
var element_inputs: Array[LineEdit] = []
var user_configuration_step = 1
var initial_waiting_elements: Array[int] = []
var is_dequeuing_active: bool = false

var INDEX_LABEL_OFFSET: float = 100.0

# Indicators
@onready var is_full_indicator: TextureRect = get_node_or_null("isFull")
@onready var is_empty_indicator: TextureRect = get_node_or_null("isEmpty")
var index_labels: Array[Label] = []

# ==============================================
#   READY
# ==============================================
func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	print("Program started — initializing queue visualizer...")
	randomize()
	Queue_full.hide()

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

	try_again_result_btn.pressed.connect(_on_try_again_pressed)
	back_result_btn.pressed.connect(_on_back_pressed)
	translate_code_btn.pressed.connect(_on_translate_code_pressed)

	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()

	_connect_configuration_buttons()
	_setup_compiler()
	q_mark_sprite.play("default")
	call_deferred("show_introduction")
	_show_config_modal

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

# ==============================================
#   CONFIGURATION
# ==============================================

func _connect_configuration_buttons() -> void:
	if yes_btn: yes_btn.pressed.connect(_on_config_yes_pressed)
	if no_btn: no_btn.pressed.connect(_on_config_no_pressed)
	if size_back_btn: size_back_btn.pressed.connect(_on_size_back_pressed)
	if size_next_btn: size_next_btn.pressed.connect(_on_size_next_pressed)
	if elements_back_btn: elements_back_btn.pressed.connect(_on_elements_back_pressed)
	if elements_done_btn: elements_done_btn.pressed.connect(_on_elements_done_pressed)

func _show_config_modal() -> void:
	config_size_modal.hide()
	config_elements_modal.hide()
	config_modal.show()
	_set_main_ui_enabled(false)

func _show_config_size_modal() -> void:
	user_configuration_step = 1
	if size_input:
		size_input.min_value = 5
		size_input.max_value = 7
		size_input.value = 5
		size_label.text = "Please enter array size"
	config_modal.hide()
	config_elements_modal.hide()
	config_size_modal.show()
	_set_main_ui_enabled(false)

func _show_config_elements_modal() -> void:
	user_configuration_step = 2
	element_inputs.clear()
	for child in elements_container.get_children():
		child.queue_free()

	var array_size = int(size_input.value)
	elements_label.text = "Please enter array elements"

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
	_set_main_ui_enabled(false)

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
	_show_config_size_modal()

func _on_config_no_pressed() -> void:
	reset_cache_for_scene()
	btn_sound.play()
	MAX_QUEUE_SIZE = randi_range(5, 7)
	var random_elements: Array[int] = []
	for i in range(MAX_QUEUE_SIZE):
		random_elements.append(randi_range(1, 99))
	config_modal.hide()
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

func _on_elements_back_pressed() -> void:
	btn_sound.play()
	config_elements_modal.hide()
	_show_config_size_modal()

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
	_set_main_ui_enabled(true)
	_initialize_with_elements(elements_array)

# ==============================================
#   INITIALIZE
# ==============================================

func _initialize_with_elements(elements: Array[int]) -> void:
	reset_cache_for_scene()
	code_lines.clear()
	for lbl in index_labels:
		if is_instance_valid(lbl): lbl.queue_free()
	index_labels.clear()

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

func _add_code_line(op: String, index: int, value: int) -> void:
	code_lines.append("%s|%d|%d" % [op, index, value])

# ==============================================
#   TUTORIAL — Next-based, no button pressing required
#   Order: enqueue, dequeue, peek, dequeued elements,
#          waiting elements, timeline, simulate new,
#          enqueue counter, dequeue counter, isfull, isempty
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

	# Nodes in the order requested
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
		"ENQUEUE BUTTON\nAdds a new element to the REAR of the queue.\nElements are added from the waiting list (FIFO).",
		"DEQUEUE BUTTON\nRemoves the element at the FRONT of the queue.\nFollows First-In-First-Out (FIFO) order.",
		"PEEK BUTTON\nViews the front element without removing it.\nThe element will briefly flash to show its value.",
		"DEQUEUED ELEMENTS\nShows all elements that have already been dequeued from the queue.",
		"WAITING ELEMENTS\nShows the list of elements waiting to be enqueued into the queue.",
		"TIMELINE\nShows a history of all enqueue, dequeue, and peek operations performed.",
		"SIMULATE NEW\nRestarts the simulation from scratch with a brand new queue.",
		"ENQUEUE COUNTER\nTracks the total number of enqueue operations performed so far.",
		"DEQUEUE COUNTER\nTracks the total number of dequeue operations performed so far.",
		"FULL INDICATOR\nTurns GREEN when the queue has reached its maximum capacity.\nTurns DARK when there is still space available.",
		"EMPTY INDICATOR\nTurns PINK when the queue has no elements.\nTurns DARK when the queue contains data."
	]

	tutorial_step = 0
	_show_tutorial_step()

	tutorial_next.mouse_filter = Control.MOUSE_FILTER_STOP
	tutorial_next.z_index = 100
	tutorial_next.disabled = false
	tutorial_next.show()
	tutorial_next.text = "Next"

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

	# Pointer follows the highlighted node
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

	# Highlight current node, reset all others
	for n in tutorial_nodes:
		if n and is_instance_valid(n):
			n.modulate = Color(1, 1, 1, 1)
	node.modulate = Color(1.5, 1.5, 0.8, 1)

	# Update Next button text on last step
	if tutorial_step == tutorial_nodes.size() - 1:
		tutorial_next.text = "Finish"
	else:
		tutorial_next.text = "Next"

	tutorial_box.visible = true
	tutorial_text.visible = true
	tutorial_next.visible = true

func _end_tutorial() -> void:
	tutorial_in_progress = false
	tutorial_overlay.hide()

	if pointer_sprite:
		pointer_sprite.hide()
		if pointer_sprite.has_meta("tween"):
			pointer_sprite.get_meta("tween").kill()

	# Reset all modulates
	for node in tutorial_nodes:
		if node and is_instance_valid(node):
			node.modulate = Color(1, 1, 1, 1)

	if dequeued_container and dequeued_container.visible: dequeued_container.hide()
	if waiting_popup and waiting_popup.visible: waiting_popup.hide()
	if timeline_popup and timeline_popup.visible: timeline_popup.hide()

	_set_main_ui_enabled(true)
	show_feedback("Tutorial complete! Start experimenting.", Color.GREEN, Vector2(500, 300))

# ==============================================
#   ENQUEUE
# ==============================================

func _on_enqueue_pressed() -> void:
	if tutorial_in_progress: return

	if queue.size() >= MAX_QUEUE_SIZE:
		# Show queue full panel only when enqueue is pressed and queue is full
		if Queue_full and not Queue_full.visible:
			Queue_full.visible = true
			anim_sprite.play("default")
			var timer = get_tree().create_timer(2.0)
			timer.timeout.connect(_hide_queue_full_panel)
		show_feedback("Cannot enqueue! Queue is full.", Color.ORANGE, get_global_mouse_position())
		return

	if waiting_elements.is_empty():
		show_feedback("No waiting elements to enqueue!", Color.ORANGE, get_global_mouse_position())
		return

	_perform_regular_enqueue()

func _perform_regular_enqueue() -> void:
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

# ==============================================
#   DEQUEUE
# ==============================================

func _on_dequeue_pressed() -> void:
	if is_dequeuing_active: return
	if tutorial_in_progress: return

	if queue.is_empty():
		show_feedback("Cannot dequeue! Queue is empty.", Color.ORANGE, get_global_mouse_position())
		return

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

	if is_instance_valid(front_block): front_block.queue_free()
	if is_instance_valid(front_label): front_label.queue_free()

	_animate_queue_shift()
	_update_labels()
	_update_front_rear_visibility()

	is_dequeuing_active = false

	if queue.is_empty() and waiting_elements.is_empty():
		_show_complete_popup()

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

# ==============================================
#   PEEK
# ==============================================

func _on_peek_pressed() -> void:
	if tutorial_in_progress: return
	
	if queue.is_empty():
		show_feedback("Cannot peek! Queue is empty.", Color.ORANGE, get_global_mouse_position())
		return
	
	btn_sound.play()
	var front_val: int = queue[0]
	peek_counter += 1  # Increment peek counter
	timeline_log.append("Peeked at front element: %d" % front_val)
	_add_code_line("PEEK", 0, front_val)  # Add peek to code lines
	
	# Flash animation for the front block
	if queue_container.get_child_count() > 0:
		var front_block = queue_container.get_child(0)
		if is_instance_valid(front_block) and not front_block is Label:
			var tween = create_tween()
			tween.tween_property(front_block, "modulate", Color(1.5, 1.5, 0.5, 1.0), 0.2)
			tween.tween_property(front_block, "modulate", Color.WHITE, 0.2)
	
	show_feedback("Front: %d" % front_val, Color.CYAN, get_global_mouse_position())

# ==============================================
#   WAITING / DEQUEUED / TIMELINE
# ==============================================

func _on_waiting_pressed() -> void:
	if tutorial_in_progress: return
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
	if tutorial_in_progress: return
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
	if tutorial_in_progress: return
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

func _on_dequeued_close_pressed() -> void:
	btn_sound.play()
	dequeued_container.hide()
	if front2_icon: front2_icon.hide()
	if rear2_icon: rear2_icon.hide()
	current_popup = null

# ==============================================
#   SIMULATE NEW
# ==============================================

func _on_simulate_new_pressed() -> void:
	if tutorial_in_progress: return
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

# ==============================================
#   LABELS & UI STATE
# ==============================================

func _update_labels() -> void:
	enqueue_label.text = "Enqueue Counter: %d" % enqueue_counter
	dequeue_label.text = "Dequeue Counter: %d" % dequeue_counter

	# Buttons are NEVER hard-disabled here and NEVER change color.
	# _set_main_ui_enabled() handles disabling during config/tutorial.
	# Feedback messages communicate why an action can't be done.
	enqueue_btn.disabled = false
	dequeue_btn.disabled = false
	peek_btn.disabled = false
	enqueue_btn.modulate = Color.WHITE
	dequeue_btn.modulate = Color.WHITE
	peek_btn.modulate = Color.WHITE

	_update_indicators()

func _set_main_ui_enabled(enabled: bool) -> void:
	if enqueue_btn: enqueue_btn.disabled = not enabled
	if dequeue_btn: dequeue_btn.disabled = not enabled
	if waiting_btn: waiting_btn.disabled = not enabled
	if dequeued_btn: dequeued_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled
	if simulate_new_btn: simulate_new_btn.disabled = not enabled
	if peek_btn: peek_btn.disabled = not enabled
	get_node("HelpButton").disabled = not enabled
	get_node("CppCodeButton").disabled = not enabled

func _hide_queue_full_panel() -> void:
	if Queue_full and Queue_full.visible:
		var tween = create_tween()
		tween.tween_property(Queue_full, "modulate:a", 0.0, 0.5)
		await tween.finished
		Queue_full.visible = false
		Queue_full.modulate.a = 1.0

func _update_front_rear_visibility() -> void:
	if queue.size() > 0:
		if front_icon: front_icon.show()
		if rear_icon: rear_icon.show()
	else:
		if front_icon: front_icon.hide()
		if rear_icon: rear_icon.hide()

func _update_indicators() -> void:
	if is_full_indicator:
		if queue.size() >= MAX_QUEUE_SIZE:
			is_full_indicator.modulate = Color(0, 1, 0, 1)
		else:
			is_full_indicator.modulate = Color(0.3, 0.3, 0.3, 1)
	if is_empty_indicator:
		if queue.is_empty():
			is_empty_indicator.modulate = Color(1, 0.5, 0.8, 1)
		else:
			is_empty_indicator.modulate = Color(0.3, 0.3, 0.3, 1)

# ==============================================
#   COMPLETE POPUP
# ==============================================

func _show_complete_popup() -> void:
	if complete_popup:
		var total_processes = enqueue_counter + dequeue_counter + peek_counter
		var process_text = "Total Processes: %d\n→ Enqueue: %d\n→ Dequeue: %d\n→ Peek: %d" % [total_processes, enqueue_counter, dequeue_counter, peek_counter]
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

# ==============================================
#   CODE POPUP
# ==============================================

func _show_cpp_popup() -> void:
	btn_sound.play()
	cpp_tutorialcode_index = 0
	if cpp_popup and cpp_text:
		var source_arr: Array = []
		if initial_waiting_elements.size() > 0: source_arr = initial_waiting_elements.duplicate()
		elif dequeued_elements.size() > 0: source_arr = dequeued_elements.duplicate()
		elif queue.size() > 0: source_arr = queue.duplicate()
		else: source_arr = [10, 20, 30]

		var code = generate_code_in_language(current_code_language, source_arr)
		cpp_text.text = code
		cpp_text.custom_minimum_size = Vector2(700, 420)

		var lang_names = {"cpp": "C++ Code", "python": "Python Code", "java": "Java Code", "c": "C Code"}
		cpp_popup.title = lang_names.get(current_code_language, "Code")

		if cpp_tutorial_panel: cpp_tutorial_panel.show()
		if cpp_explanation_text: cpp_explanation_text.text = "💡 Click 'Next' to walk through this code explanation!"
		if cpp_next_button:
			cpp_next_button.show()
			cpp_next_button.text = "Next"

		clear_cpp_highlight()
		show_cpp_explanation()
		cpp_popup.popup_centered()
		update_language_button_states()

func generate_code_in_language(lang: String, source_arr: Array) -> String:
	var arr_str := ", ".join(source_arr.map(func(x): return str(x)))
	var n = source_arr.size()
	match lang:
		"python": return generate_python_code(arr_str, n)
		"java": return generate_java_code(arr_str, n)
		"c": return generate_c_code(arr_str, n)
		_: return generate_cpp_code(arr_str, n)

func generate_cpp_code(arr_str: String, _n: int) -> String:
	# Build the operations sequence from code_lines
	var ops_code = ""
	for line in code_lines:
		var parts = line.split("|")
		if parts.size() >= 3:
			var op = parts[0]
			var index = int(parts[1])
			var value = int(parts[2])
			match op:
				"ENQUEUE":
					ops_code += "    cout << \"Enqueued " + str(value) + " to queue...\" << endl;\n"
					ops_code += "    q.push(" + str(value) + ");\n"
					ops_code += "    cout << \"Queue after enqueue: \";\n"
					ops_code += "    printQueue(q);\n"
					ops_code += "    cout << endl;\n\n"
				"DEQUEUE":
					ops_code += "    cout << \"Dequeuing front element...\" << endl;\n"
					ops_code += "    cout << \"Dequeued: \" << q.front() << endl;\n"
					ops_code += "    q.pop();\n"
					ops_code += "    if(!q.empty()) {\n"
					ops_code += "        cout << \"Queue after dequeue: \";\n"
					ops_code += "        printQueue(q);\n"
					ops_code += "        cout << endl;\n"
					ops_code += "    } else {\n"
					ops_code += "        cout << \"Queue is now empty.\" << endl;\n"
					ops_code += "    }\n\n"
				"PEEK":
					ops_code += "    cout << \"Peeking at front element...\" << endl;\n"
					ops_code += "    if(!q.empty()) {\n"
					ops_code += "        cout << \"Front element: \" << q.front() << endl;\n"
					ops_code += "        cout << \"Queue remains: \";\n"
					ops_code += "        printQueue(q);\n"
					ops_code += "        cout << endl;\n"
					ops_code += "    }\n\n"
				"INITIAL":
					ops_code += "    cout << \"Initial queue: \";\n"
					ops_code += "    printQueue(q);\n"
					ops_code += "    cout << endl;\n\n"
	
	return """#include <iostream>
#include <queue>
using namespace std;

void printQueue(queue<int> q) {
    cout << "[";
    while(!q.empty()) {
        cout << q.front();
        q.pop();
        if(!q.empty()) cout << ", ";
    }
    cout << "]";
}

int main() {
    queue<int> q;
    cout << "=== QUEUE SIMULATION ===" << endl;
    
    // Operation sequence from simulation
    {OPS}
    
    cout << "\\n=== SIMULATION FINISHED ===" << endl;
    return 0;
}
/* Complexity: Enqueue: O(1), Dequeue: O(1), Peek: O(1) | Space: O(n) */""".replace("{OPS}", ops_code)

func generate_python_code(arr_str: String, _n: int) -> String:
	# Build the operations sequence from code_lines
	var ops_code = ""
	for line in code_lines:
		var parts = line.split("|")
		if parts.size() >= 3:
			var op = parts[0]
			var index = int(parts[1])
			var value = int(parts[2])
			match op:
				"ENQUEUE":
					ops_code += "    print(f\"Enqueued " + str(value) + " to queue...\")\n"
					ops_code += "    q.append(" + str(value) + ")\n"
					ops_code += "    print(f\"Queue after enqueue: {list(q)}\")\n"
					ops_code += "    print()\n\n"
				"DEQUEUE":
					ops_code += "    print(\"Dequeuing front element...\")\n"
					ops_code += "    if q:\n"
					ops_code += "        print(f\"Dequeued: {q[0]}\")\n"
					ops_code += "        q.popleft()\n"
					ops_code += "        if q:\n"
					ops_code += "            print(f\"Queue after dequeue: {list(q)}\")\n"
					ops_code += "        else:\n"
					ops_code += "            print(\"Queue is now empty.\")\n"
					ops_code += "    print()\n\n"
				"PEEK":
					ops_code += "    print(\"Peeking at front element...\")\n"
					ops_code += "    if q:\n"
					ops_code += "        print(f\"Front element: {q[0]}\")\n"
					ops_code += "        print(f\"Queue remains: {list(q)}\")\n"
					ops_code += "    print()\n\n"
				"INITIAL":
					ops_code += "    print(f\"Initial queue: {list(q)}\")\n"
					ops_code += "    print()\n\n"
	
	return """from collections import deque

def main():
    q = deque()
    print("=== QUEUE SIMULATION ===")
    print()
    
    # Operation sequence from simulation
{OPS}
    
    print("\\n=== SIMULATION FINISHED ===")

if __name__ == "__main__":
    main()
''' Complexity: Enqueue: O(1), Dequeue: O(1), Peek: O(1) | Space: O(n) '''""".replace("{OPS}", ops_code)

func generate_java_code(arr_str: String, _n: int) -> String:
	# Build the operations sequence from code_lines
	var ops_code = ""
	for line in code_lines:
		var parts = line.split("|")
		if parts.size() >= 3:
			var op = parts[0]
			var index = int(parts[1])
			var value = int(parts[2])
			match op:
				"ENQUEUE":
					ops_code += "        System.out.println(\"Enqueued " + str(value) + " to queue...\");\n"
					ops_code += "        q.add(" + str(value) + ");\n"
					ops_code += "        System.out.println(\"Queue after enqueue: \" + q);\n"
					ops_code += "        System.out.println();\n\n"
				"DEQUEUE":
					ops_code += "        System.out.println(\"Dequeuing front element...\");\n"
					ops_code += "        if(!q.isEmpty()) {\n"
					ops_code += "            System.out.println(\"Dequeued: \" + q.peek());\n"
					ops_code += "            q.poll();\n"
					ops_code += "            if(!q.isEmpty()) {\n"
					ops_code += "                System.out.println(\"Queue after dequeue: \" + q);\n"
					ops_code += "            } else {\n"
					ops_code += "                System.out.println(\"Queue is now empty.\");\n"
					ops_code += "            }\n"
					ops_code += "        }\n"
					ops_code += "        System.out.println();\n\n"
				"PEEK":
					ops_code += "        System.out.println(\"Peeking at front element...\");\n"
					ops_code += "        if(!q.isEmpty()) {\n"
					ops_code += "            System.out.println(\"Front element: \" + q.peek());\n"
					ops_code += "            System.out.println(\"Queue remains: \" + q);\n"
					ops_code += "        }\n"
					ops_code += "        System.out.println();\n\n"
				"INITIAL":
					ops_code += "        System.out.println(\"Initial queue: \" + q);\n"
					ops_code += "        System.out.println();\n\n"
	
	return """import java.util.LinkedList;
import java.util.Queue;

public class QueueSim {
    public static void main(String[] args) {
        Queue<Integer> q = new LinkedList<>();
        System.out.println("=== QUEUE SIMULATION ===");
        
        // Operation sequence from simulation
        {OPS}
        
        System.out.println("\\n=== SIMULATION FINISHED ===");
    }
}
/* Complexity: Enqueue: O(1), Dequeue: O(1), Peek: O(1) | Space: O(n) */""".replace("{OPS}", ops_code)

func generate_c_code(arr_str: String, _n: int) -> String:
	# Build the operations sequence from code_lines
	var ops_code = ""
	for line in code_lines:
		var parts = line.split("|")
		if parts.size() >= 3:
			var op = parts[0]
			var index = int(parts[1])
			var value = int(parts[2])
			match op:
				"ENQUEUE":
					ops_code += "    printf(\"Enqueued " + str(value) + " to queue...\\n\");\n"
					ops_code += "    enqueue(&q, " + str(value) + ");\n"
					ops_code += "    printf(\"Queue after enqueue: \");\n"
					ops_code += "    printQueue(&q);\n"
					ops_code += "    printf(\"\\n\\n\");\n\n"
				"DEQUEUE":
					ops_code += "    printf(\"Dequeuing front element...\\n\");\n"
					ops_code += "    if(!isEmpty(&q)) {\n"
					ops_code += "        printf(\"Dequeued: %d\\n\", peek(&q));\n"
					ops_code += "        dequeue(&q);\n"
					ops_code += "        if(!isEmpty(&q)) {\n"
					ops_code += "            printf(\"Queue after dequeue: \");\n"
					ops_code += "            printQueue(&q);\n"
					ops_code += "            printf(\"\\n\");\n"
					ops_code += "        } else {\n"
					ops_code += "            printf(\"Queue is now empty.\\n\");\n"
					ops_code += "        }\n"
					ops_code += "    }\n"
					ops_code += "    printf(\"\\n\");\n\n"
				"PEEK":
					ops_code += "    printf(\"Peeking at front element...\\n\");\n"
					ops_code += "    if(!isEmpty(&q)) {\n"
					ops_code += "        printf(\"Front element: %d\\n\", peek(&q));\n"
					ops_code += "        printf(\"Queue remains: \");\n"
					ops_code += "        printQueue(&q);\n"
					ops_code += "        printf(\"\\n\");\n"
					ops_code += "    }\n"
					ops_code += "    printf(\"\\n\");\n\n"
				"INITIAL":
					ops_code += "    printf(\"Initial queue: \");\n"
					ops_code += "    printQueue(&q);\n"
					ops_code += "    printf(\"\\n\\n\");\n\n"
	
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
int peek(Queue *q) { return isEmpty(q) ? -1 : q->items[q->front]; }

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
	printf("[");
	for (int i = q->front; i <= q->rear; i++) {
		printf("%d", q->items[i]);
		if(i < q->rear) printf(", ");
	}
	printf("]");
}

int main() {
	Queue q;
	initQueue(&q);
	printf("=== QUEUE SIMULATION ===\\n\\n");
	
	// Operation sequence from simulation
	{OPS}
	
	printf("\\n=== SIMULATION FINISHED ===\\n");
	return 0;
}
/* Complexity: Enqueue: O(1), Dequeue: O(1), Peek: O(1) | Space: O(n) */"""
	
	return code.replace("{OPS}", ops_code)

func get_time_complexity() -> String:
	var ops = []
	if enqueue_counter > 0: ops.append("Enqueue: O(1)")
	if dequeue_counter > 0: ops.append("Dequeue: O(1)")
	if peek_counter > 0: ops.append("Peek: O(1)")  # Add this line
	if not queue.is_empty(): ops.append("Front access: O(1)")
	if timeline_log.size() > 0: ops.append("Traversal: O(n)")
	if ops.is_empty(): return "Enqueue/Dequeue/Peek: O(1)"
	return ", ".join(ops)

func get_space_complexity() -> String:
	var total_elements = queue.size() + waiting_elements.size() + dequeued_elements.size()
	return "O(n) where n=%d" % total_elements

# ==============================================
#   LANGUAGE BUTTONS
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
		var source_arr: Array = []
		if initial_waiting_elements.size() > 0: source_arr = initial_waiting_elements.duplicate()
		elif dequeued_elements.size() > 0: source_arr = dequeued_elements.duplicate()
		elif queue.size() > 0: source_arr = queue.duplicate()
		else: source_arr = []
		cpp_text.text = generate_code_in_language(current_code_language, source_arr)
		update_language_button_states()
		cpp_tutorialcode_index = 0
		clear_cpp_highlight()
		if cpp_explanation_text:
			cpp_explanation_text.text = "💡 Click 'Next' to walk through this code explanation!"

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

# ==============================================
#   CODE HIGHLIGHT / TUTORIAL
# ==============================================

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
			highlight_cpp_lines(lines[0], lines[lines.size() - 1])
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

func clear_cpp_highlight() -> void:
	if not cpp_text: return
	var source_arr: Array = []
	if initial_waiting_elements.size() > 0: source_arr = initial_waiting_elements.duplicate()
	elif dequeued_elements.size() > 0: source_arr = dequeued_elements.duplicate()
	elif queue.size() > 0: source_arr = queue.duplicate()
	else: source_arr = [10, 20, 30]
	cpp_text.text = generate_code_in_language(current_code_language, source_arr)

func _on_cpp_next_button_pressed() -> void:
	btn_sound.play()
	var tutorial_steps = _get_tutorial_steps_for_language()
	cpp_tutorialcode_index = (cpp_tutorialcode_index + 1) % tutorial_steps.size()
	show_cpp_explanation()
	if cpp_tutorialcode_index == 0:
		if cpp_explanation_text:
			cpp_explanation_text.text = "🔄 Looping back to start..."
			await get_tree().create_timer(0.8).timeout
			show_cpp_explanation()
		if cpp_next_button:
			var tween = create_tween()
			tween.tween_property(cpp_next_button, "modulate", Color(0.5, 1, 0.5, 1), 0.2)
			tween.tween_property(cpp_next_button, "modulate", Color.WHITE, 0.2)

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

func _on_close_pressed() -> void:
	if cpp_popup:
		cpp_popup.hide()
		reset_cpp_tutorial_state()
	btn_sound.play()

# ==============================================
#   HELPER FUNCTIONS
# ==============================================

func _refresh_dequeued_list() -> void:
	for child in dequeued_container.get_children():
		if child != dequeued_close_btn: child.queue_free()
	if dequeued_elements.is_empty():
		var lbl: Label = Label.new()
		lbl.text = "No dequeued elements yet."
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

func _clear_simulation_data() -> void:
	queue.clear()
	waiting_elements.clear()
	dequeued_elements.clear()
	timeline_log.clear()
	code_lines.clear()
	enqueue_counter = 0
	dequeue_counter = 0
	peek_counter = 0
	for child in queue_container.get_children(): child.queue_free()
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

func _create_index_label(index: int) -> Label:
	var index_label = Label.new()
	index_label.text = str(index)
	var index_font = load("res://assets/font/Planes_ValMore.ttf")
	if index_font: index_label.add_theme_font_override("font", index_font)
	index_label.add_theme_font_size_override("font_size", 32)
	index_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	index_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	index_label.add_theme_constant_override("outline_size", 4)
	index_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return index_label

func _on_block_dropped(dropped_block: Control) -> void:
	var children: Array = queue_container.get_children()
	var old_index: int = children.find(dropped_block)
	var center_x: float = dropped_block.position.x + dropped_block.size.x * 0.5
	var insert_index: int = 0
	for c in children:
		if c == dropped_block: continue
		if center_x > c.position.x + c.size.x * 0.5:
			insert_index += 1
	if old_index == 0 and insert_index > 0:
		dropped_block.position = dropped_block.original_position
		_resnap_blocks()
		return
	queue_container.move_child(dropped_block, insert_index)
	var moved_val: int = queue.pop_at(old_index)
	queue.insert(insert_index, moved_val)
	timeline_log.append("Moved %d from %d → %d" % [moved_val, old_index, insert_index])
	_add_code_line("MOVE", insert_index, moved_val)
	_resnap_blocks()

# ==============================================
#   INTRODUCTION POPUP
# ==============================================

func show_introduction() -> void:
	if not intro_popup: return
	tutorial_overlay.show() 
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
		intro_skip_btn.visible = false
	else:
		intro_next_btn.text = "Next"
		intro_skip_btn.visible = true

func _on_intro_next_pressed() -> void:
	btn_sound.play()
	if intro_step < intro_texts.size() - 1:
		intro_step += 1
		intro_label.text = intro_texts[intro_step]
		_update_intro_buttons()
	else:
		intro_popup.hide()
		tutorial_overlay.hide()    # ← add this
		_show_config_modal()       # ← show config AFTER intro finishes

func _on_intro_skip_pressed() -> void:
	btn_sound.play()
	intro_popup.hide()
	tutorial_overlay.hide()        # ← add this
	_show_config_modal()           # ← show config AFTER intro finishes

func _on_intro_prev_pressed() -> void:
	btn_sound.play()
	if intro_step > 0:
		intro_step -= 1
		intro_label.text = intro_texts[intro_step]
		_update_intro_buttons()

func _on_ok_btn_pressed() -> void:
	waiting_popup.hide()

# ==============================================
#   TUTORIAL NEXT BUTTON
# ==============================================

func _on_next_button_pressed() -> void:
	btn_sound.play()
	if not tutorial_in_progress: return
	tutorial_step += 1
	_show_tutorial_step()

func _on_help_button_pressed() -> void:
	btn_sound.play()
	get_node("HelpButton").disabled = true
	get_node("CppCodeButton").disabled = true
	start_tutorial()

# ==============================================
#   RESULT POPUP
# ==============================================

func _compute_grade() -> Dictionary:
	return {
		"passed": true,
		"accuracy": 100.0,
		"correct_moves": enqueue_counter,
		"bad_moves": dequeue_counter,
		"time_used": 0,
		"coins": 10,
		"required": 60
	}

func _on_try_again_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_config_modal()

func _on_back_pressed() -> void:
	btn_sound.play()
	result_popup.hide()

func _show_result_popup(result: String, grade: Dictionary) -> void:
	if not result_popup: return
	if result == "PASS":
		result_title.text = "SIMULATION COMPLETE!"
		result_title.modulate = Color.GREEN
	else:
		result_title.text = "SIMULATION ENDED"
		result_title.modulate = Color.YELLOW
	if translate_code_btn: translate_code_btn.show()
	if cpp_code_button:
		cpp_code_button.show()
		if code_sprite: code_sprite.play("default")
	score_summary.text = "Enqueues: %d | Dequeues: %d" % [grade.get("correct_moves", 0), grade.get("bad_moves", 0)]
	accuracy_label.text = "Total Operations: %d" % [grade.get("correct_moves", 0) + grade.get("bad_moves", 0)]
	time_used_label.text = "Queue Size: %d" % queue.size()
	coins_label.text = "+%d" % grade.get("coins", 0)
	result_popup.popup_centered()
	if grade.get("coins", 0) > 0 and coins_anim: coins_anim.play("default")

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
#   COMPILER
# ==============================================

func _setup_compiler() -> void:
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
	var source_arr: Array = []
	if initial_waiting_elements.size() > 0: source_arr = initial_waiting_elements.duplicate()
	elif dequeued_elements.size() > 0: source_arr = dequeued_elements.duplicate()
	elif queue.size() > 0: source_arr = queue.duplicate()
	else: source_arr = [10, 20, 30]
	var code = generate_code_in_language(current_code_language, source_arr)
	if compiler_output_popup and compiler_output_popup.has_cached_result(current_code_language):
		var cached = compiler_output_popup.get_cached_result(current_code_language)
		compiler_output_popup.show_output(current_code_language, {"output": cached.output, "error": cached.error, "memory": cached.memory, "cpu": cached.cpu}, self, false)
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
	if current_code_language == "python": api_language = "python3"
	var body = JSON.new().stringify({
		"clientId": keys["clientId"],
		"clientSecret": keys["clientSecret"],
		"script": code,
		"language": api_language,
		"versionIndex": _get_version_index(current_code_language)
	})
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
	if json.parse(body.get_string_from_utf8()) != OK:
		show_feedback("Parse error!", Color.RED, Vector2(200, 200))
		return
	if compiler_output_popup:
		compiler_output_popup.show_output(language, json.data, self, false)

func _on_recompile_requested(language: String) -> void:
	var source_arr: Array = []
	if initial_waiting_elements.size() > 0: source_arr = initial_waiting_elements.duplicate()
	elif dequeued_elements.size() > 0: source_arr = dequeued_elements.duplicate()
	elif queue.size() > 0: source_arr = queue.duplicate()
	else: source_arr = [10, 20, 30]
	_compile_code(generate_code_in_language(language, source_arr))

func _on_compiler_output_closed() -> void:
	print("Compiler output closed")

func reset_cache_for_scene() -> void:
	if compiler_output_popup:
		compiler_output_popup.reset_cache_for_scene()

func _on_got_it_pressed() -> void:
	btn_sound.play()
	if Queue_full: Queue_full.hide()
