extends Control

# Node paths
@onready var enqueue_btn: Button = $VBoxContainer/EnqueueButton
@onready var dequeue_btn: Button = $VBoxContainer/DequeueButton
@onready var waiting_btn: Button = $VBoxContainer/WaitingElements
@onready var dequeued_btn: Button = $VBoxContainer/DequeuedElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew

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
const BLOCK_SCENE := preload("res://QueueBlock.tscn")

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
	" This is the code automatically generated from your stack simulation.",
	" The tutorial will loop back to the beginning when you reach the end.",
	" Use the Next button to navigate through the code explanations.",
	" This feature helps you connect the visual process with the actual implementation!"
]

var cpp_tutorialcode_index := 0
var current_tutorial_data: Array = [] 

# --- CODE TUTORIAL STEPS (STACK) ---
var cpp_tutorial_steps := [
	{"lines": Vector2i(0, 2), "text": "1. Imports: <iostream> for I/O and <stack> for the standard container."},
	{"lines": Vector2i(3, 6), "text": "2. Main Setup: We define the array and initialize a standard `stack<int>`."},
	{"lines": Vector2i(7, 11), "text": "3. Push Loop: We iterate through the array and `push()` elements onto the top of the stack."},
	{"lines": Vector2i(12, 16), "text": "4. Print Initial: We display the stack state by copying it and popping until empty."},
	{"lines": Vector2i(17, 23), "text": "5. Pop Loop: We get `top()` and `pop()` elements one by one (LIFO) until empty."},
	{"lines": Vector2i(24, 28), "text": "6. End: The simulation finishes when the stack is empty."}
]

var python_tutorial_steps := [
	{"lines": Vector2i(0, 1), "text": "1. Setup: In Python, a standard list `[]` acts perfectly as a stack."},
	{"lines": Vector2i(3, 5), "text": "2. Main Setup: Define the list and create an empty stack."},
	{"lines": Vector2i(7, 9), "text": "3. Push: Use `append()` to add elements to the end (top) of the stack."},
	{"lines": Vector2i(11, 14), "text": "4. Print: Display the stack contents from bottom to top."},
	{"lines": Vector2i(16, 19), "text": "5. Pop: Use `pop()` without arguments to remove and return the last element added (LIFO)."},
	{"lines": Vector2i(21, 24), "text": "6. Execution: Run the main function."}
]

var java_tutorial_steps := [
	{"lines": Vector2i(0, 4), "text": "1. Imports & Class: Import the `Stack` class from java.util."},
	{"lines": Vector2i(5, 7), "text": "2. Setup: Initialize the array and the Stack object."},
	{"lines": Vector2i(9, 12), "text": "3. Push: Use `s.push(value)` to place items on top of the stack."},
	{"lines": Vector2i(14, 19), "text": "4. Print: Create a copy to safely print the stack's state."},
	{"lines": Vector2i(21, 25), "text": "5. Pop: Loop while the stack is not empty. `s.pop()` removes and returns the top item."},
	{"lines": Vector2i(27, 28), "text": "6. End: Simulation complete."}
]

var c_tutorial_steps := [
	{"lines": Vector2i(0, 9), "text": "1. Struct Definition: In C, we manually define a Stack struct with an array and a `top` index initialized to -1."},
	{"lines": Vector2i(11, 45), "text": "2. Helper Functions: Logic for `push`, `pop`, `isEmpty`, and `isFull`."},
	{"lines": Vector2i(47, 52), "text": "3. Main: Initialize the stack struct and array."},
	{"lines": Vector2i(54, 57), "text": "4. Push Loop: Add items using our custom `push` function. The `top` index increments."},
	{"lines": Vector2i(59, 63), "text": "5. Print: Iterate from index 0 up to `top`."},
	{"lines": Vector2i(65, 69), "text": "6. Pop Loop: Remove items using our custom `pop` function until `isEmpty` returns true."}
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

var current_code_language: String = "cpp"  # cpp, python, java, c, javascript

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
	"Stack Operations:\n\n• PUSH: Add an element to the top of the stack\n• POP: Remove an element from the top of the stack\n• TOP: View the highest element without removing it",
	"Visual Elements:\n\n• Green blocks represent elements in the stack\n• TOP indicator (R) shows where the next element will be added or removed\n• Elements are stacked from left to right (Left = Bottom, Right = Top)\n• Waiting elements are shown in a separate list",
	"How to Use:\n\n1. Click PUSH to add elements from waiting list to the top\n2. Click POP to remove elements from the top\n3. View waiting/popped elements using buttons\n4. Check timeline for operation history\n5. Generate code to see implementation",
	"Ready to Start!\n\nClick 'Got it' to explore on your own. You can always access the tutorial from the Help button."
]

# Configuration variables
var element_inputs: Array[LineEdit] = []
var user_configuration_step = 1  # 1: Size, 2: Elements

var is_dequeuing_active: bool = false

# 🏁 Ready
func _ready() -> void:
	print(" Program started — initializing stack visualizer...")
	randomize()
	Queue_full.hide()
	
	# UPDATE UI TEXTS TO STACK TERMINOLOGY
	if enqueue_btn: enqueue_btn.text = "PUSH"
	if dequeue_btn: dequeue_btn.text = "POP"
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
		size_input.min_value = 5
		size_input.max_value = 7
		size_input.value = 5
		size_label.text = "Please enter stack size"

	config_modal.hide()
	config_elements_modal.hide()
	config_size_modal.show()

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

func _initialize_with_elements(elements: Array[int]) -> void:
	audio_player.play()
	waiting_elements = elements.duplicate()
	
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
	
	if dequeued_container: dequeued_container.hide()
	if cpp_popup: cpp_popup.hide()
	if tutorial_overlay: tutorial_overlay.hide()
	if waiting_popup: waiting_popup.hide()
	if timeline_popup: timeline_popup.hide()
	
	_update_labels()
	_update_front_rear_visibility()

func start_tutorial() -> void:
	print("Tutorial starting...")
	btn_sound.play()
	_clear_simulation_data()
	
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	tutorial_overlay.show()
	dim_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dim_bg.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{
			"node": enqueue_btn,
			"text": "This is the PUSH button. It adds new data to the TOP of the stack. Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": null,
			"pre_action": "_setup_for_enqueue_tutorial"
		},
		{
			"node": dequeue_btn,
			"text": "This is the POP button. It removes data from the TOP of the stack (LIFO). Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": null,
			"pre_action": "_setup_for_dequeue_tutorial"
		},
		{
			"node": dequeued_btn,
			"text": "This button shows all POPPED elements — the ones already removed. Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": "dequeued"
		},
		{
			"node": waiting_btn,
			"text": "Here you can view waiting elements that will be pushed next. Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": "waiting"
		},
		{
			"node": timeline_btn,
			"text": "The TIMELINE button shows a record of all push and pop actions. Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": "timeline"
		},
		{
			"node": simulate_new_btn,
			"text": "This button restarts the simulation with new random data.",
			"action": "end",
			"highlight_only": true,
			"pointer_position": "none",
			"popup_to_close": null
		},
	]
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
	
	if pre_action != "" and has_method(pre_action): call(pre_action)
	
	if popup_to_close:
		match popup_to_close:
			"dequeued":
				if dequeued_container and dequeued_container.visible: dequeued_container.hide()
			"waiting":
				if waiting_popup and waiting_popup.visible: waiting_popup.hide()
			"timeline":
				if timeline_popup and timeline_popup.visible: timeline_popup.hide()
	
	tutorial_text.text = text
	
	if action == "press":
		tutorial_next.hide()
		if node: enable_only_target_button(node)
	elif action == "next":
		tutorial_next.show()
		tutorial_next.text = "Next"
		enable_all_buttons()
		if node: node.disabled = false
	elif action == "end":
		tutorial_next.text = "Finish"
		tutorial_next.show()
		enable_all_buttons()
	
	if pointer_pos == "center" and node: show_pointer_at_node(node)
	elif pointer_pos == "none": pointer_sprite.hide()
	
	if node: apply_highlight_effect(node, highlight_only)
	else: clear_highlights()
	tutorial_box.show()

func show_pointer_at_node(node: Control) -> void:
	pointer_sprite.show()
	var node_rect = node.get_global_rect()
	var pointer_pos = node_rect.position + Vector2(200, node_rect.size.y / 2 - 16)
	pointer_sprite.global_position = pointer_pos

func apply_highlight_effect(node: Control, highlight_only: bool) -> void:
	clear_highlights()
	if highlight_only:
		node.modulate = Color(1.2, 1.2, 0.8, 1)
		node.grab_focus()
	else:
		node.modulate = Color(2.0, 2.0, 0.5, 1)
		node.grab_focus()
		if node.has_meta("tween"):
			var existing_tween: Tween = node.get_meta("tween")
			if existing_tween and existing_tween.is_valid(): existing_tween.stop()
			node.remove_meta("tween")
		var tween = create_tween()
		tween.set_loops()
		node.set_meta("tween", tween)
		tween.tween_property(node, "modulate", Color(1.5, 1.5, 0.3, 1), 0.5)
		tween.tween_property(node, "modulate", Color(2.0, 2.0, 0.5, 1), 0.5)

func clear_highlights() -> void:
	var nodes_to_clear = [enqueue_btn, dequeue_btn, waiting_btn, dequeued_btn, timeline_btn, simulate_new_btn, enqueue_label, dequeue_label]
	for node in nodes_to_clear:
		if node and node.has_meta("tween"):
			var tween: Tween = node.get_meta("tween")
			if tween and tween.is_valid(): tween.stop()
			node.remove_meta("tween")
	if enqueue_btn: enqueue_btn.modulate = Color(1, 1, 1, 1)
	if dequeue_btn: dequeue_btn.modulate = Color(1, 1, 1, 1)
	if waiting_btn: waiting_btn.modulate = Color(1, 1, 1, 1)
	if dequeued_btn: dequeued_btn.modulate = Color(1, 1, 1, 1)
	if timeline_btn: timeline_btn.modulate = Color(1, 1, 1, 1)
	if simulate_new_btn: simulate_new_btn.modulate = Color(1, 1, 1, 1)
	if enqueue_label: enqueue_label.modulate = Color(1, 1, 1, 1)
	if dequeue_label: dequeue_label.modulate = Color(1, 1, 1, 1)

func enable_only_target_button(target_node: Control) -> void:
	if enqueue_btn: enqueue_btn.disabled = (target_node != enqueue_btn)
	if dequeue_btn: dequeue_btn.disabled = (target_node != dequeue_btn)
	if waiting_btn: waiting_btn.disabled = (target_node != waiting_btn)
	if dequeued_btn: dequeued_btn.disabled = (target_node != dequeued_btn)
	if timeline_btn: timeline_btn.disabled = (target_node != timeline_btn)
	if simulate_new_btn: simulate_new_btn.disabled = true

func enable_all_buttons() -> void:
	if enqueue_btn: enqueue_btn.disabled = false
	if dequeue_btn: dequeue_btn.disabled = false
	if waiting_btn: waiting_btn.disabled = false
	if dequeued_btn: dequeued_btn.disabled = false
	if timeline_btn: timeline_btn.disabled = false
	if simulate_new_btn: simulate_new_btn.disabled = false

func end_tutorial() -> void:
	tutorial_in_progress = false
	tutorial_overlay.hide()
	clear_highlights()
	pointer_sprite.hide()
	current_popup = null
	
	if dequeued_container and dequeued_container.visible: dequeued_container.hide()
	if waiting_popup and waiting_popup.visible: waiting_popup.hide()
	if timeline_popup and timeline_popup.visible: timeline_popup.hide()
	
	_clear_simulation_data()
	for child in queue_container.get_children(): child.queue_free()
	for child in dequeued_container.get_children():
		if child != dequeued_close_btn: child.queue_free()

	_update_labels()
	_update_front_rear_visibility()
	_show_config_modal()

func _on_enqueue_pressed() -> void:
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == enqueue_btn and current_step["action"] == "press":
			_perform_tutorial_enqueue()
			return
		else: return
	_perform_regular_enqueue()

func _perform_tutorial_enqueue() -> void:
	btn_sound.play()
	if waiting_elements.is_empty(): waiting_elements = [10, 20, 30, 40, 50]
	if queue.size() >= MAX_QUEUE_SIZE:
		queue.clear()
		for child in queue_container.get_children(): child.queue_free()
	
	var new_val: int = waiting_elements.pop_front()
	queue.append(new_val)
	enqueue_counter += 1
	timeline_log.append("Pushed %d to Top" % new_val)

	var new_block: Control = BLOCK_SCENE.instantiate() as Control
	if new_block.has_method("set"): new_block.set("value", new_val)
	queue_container.add_child(new_block)
	
	var target_x = START_POSITION.x + (queue.size() - 1) * (new_block.size.x + BLOCK_SPACING)
	var final_pos = Vector2(target_x, START_POSITION.y)
	
	# Drop from above for push visual
	new_block.position = final_pos + Vector2(0, -150) 
	new_block.modulate.a = 0
	
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(new_block, "position", final_pos, 0.4)
	tween.tween_property(new_block, "modulate:a", 1.0, 0.4)

	_update_labels()
	_update_front_rear_visibility()
	tutorial_sequence_index += 1
	show_tutorial_step()

func _perform_regular_enqueue() -> void:
	if queue.size() >= MAX_QUEUE_SIZE:
		if queue.is_empty() and waiting_elements.is_empty(): Queue_full.visible = true
		return

	btn_sound.play()
	var new_val: int = waiting_elements.pop_front()
	queue.append(new_val)
	enqueue_counter += 1
	timeline_log.append("Pushed %d to Top" % new_val)

	var new_block: Control = BLOCK_SCENE.instantiate() as Control
	if new_block.has_method("set"): new_block.set("value", new_val)
	queue_container.add_child(new_block)
	
	var target_x = START_POSITION.x + (queue.size() - 1) * (new_block.size.x + BLOCK_SPACING)
	var final_pos = Vector2(target_x, START_POSITION.y)
	
	# Drop from above
	new_block.position = final_pos + Vector2(0, -150) 
	new_block.modulate.a = 0
	
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(new_block, "position", final_pos, 0.4)
	tween.tween_property(new_block, "modulate:a", 1.0, 0.4)

	_update_labels()
	_update_front_rear_visibility()

func _on_dequeue_pressed() -> void:
	if is_dequeuing_active: return

	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] != dequeue_btn or current_step["action"] != "press": return

	if queue.is_empty(): return
	is_dequeuing_active = true
	btn_sound.play()

	# --- STACK LOGIC (LIFO): Remove from BACK ---
	var removed_val: int = queue.pop_back()
	dequeue_counter += 1
	dequeued_elements.append(removed_val)
	timeline_log.append("Popped %d from Top" % removed_val)

	# Get the last block
	var top_block = queue_container.get_child(queue_container.get_child_count() - 1)

	var exit_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	# Move UP instead of left for a stack pop
	exit_tween.tween_property(top_block, "position", top_block.position + Vector2(0, -100), 0.4)
	exit_tween.tween_property(top_block, "modulate:a", 0.0, 0.3)
	
	await exit_tween.finished

	if is_instance_valid(top_block):
		top_block.queue_free()

	# NO _animate_queue_shift() NEEDED FOR STACK!
	
	_update_labels()
	_update_front_rear_visibility()

	if queue.is_empty() and waiting_elements.is_empty():
		_show_complete_popup()
	
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == dequeue_btn and current_step["action"] == "press":
			tutorial_sequence_index += 1
			show_tutorial_step()
			
	is_dequeuing_active = false

func _on_WaitingElements_pressed() -> void:
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == waiting_btn and current_step["action"] == "press": pass
		else: return
	
	btn_sound.play()
	if waiting_popup.visible:
		waiting_popup.hide()
		current_popup = null
	else:
		if waiting_elements.is_empty(): waiting_label.text = "No waiting elements left."
		else: waiting_label.text = "Waiting Elements:\n" + ", ".join(waiting_elements.map(func(x): return str(x)))
		waiting_popup.popup_centered()
		current_popup = waiting_popup

	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == waiting_btn and current_step["action"] == "press":
			tutorial_sequence_index += 1
			show_tutorial_step()
			waiting_popup.hide()

func _on_timeline_pressed() -> void:
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == timeline_btn and current_step["action"] == "press": pass
		else: return
	
	btn_sound.play()
	if timeline_popup.visible:
		timeline_popup.hide()
		current_popup = null
	else:
		if timeline_log.is_empty(): timeline_label.text = "No events yet."
		else: timeline_label.text = "Timeline of Events:\n" + "\n".join(timeline_log)
		timeline_popup.popup_centered()
		current_popup = timeline_popup
	
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == timeline_btn and current_step["action"] == "press":
			tutorial_sequence_index += 1
			show_tutorial_step()
			timeline_popup.hide()

func _on_dequeued_pressed() -> void:
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == dequeued_btn and current_step["action"] == "press": pass
		else: return
	
	btn_sound.play()
	if dequeued_container.visible:
		dequeued_container.hide()
		current_popup = null
	else:
		_refresh_dequeued_list()
		dequeued_container.show()
		current_popup = dequeued_container
	
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == dequeued_btn and current_step["action"] == "press":
			tutorial_sequence_index += 1
			show_tutorial_step()

func _on_dequeued_close_pressed() -> void:
	btn_sound.play()
	dequeued_container.hide()
	current_popup = null

func _show_complete_popup() -> void:
	if complete_popup:
		var total_processes = enqueue_counter + dequeue_counter
		var process_text = "Total Processes: %d\n→ Pushes: %d\n→ Pops: %d" % [total_processes, enqueue_counter, dequeue_counter]
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
		var source_arr: Array = []
		if dequeued_elements.size() > 0: source_arr = dequeued_elements.duplicate()
		elif queue.size() > 0: source_arr = queue.duplicate()
		elif waiting_elements.size() > 0: source_arr = waiting_elements.duplicate()
		else: source_arr = [10, 20, 30]
			
		var code = generate_code_in_language(current_code_language, source_arr)
		cpp_text.text = code
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

func generate_code_in_language(lang: String, source_arr: Array) -> String:
	var arr_str := ", ".join(source_arr.map(func(x): return str(x)))
	var n = source_arr.size()
	match lang:
		"python": return generate_python_code(arr_str, n)
		"java": return generate_java_code(arr_str, n)
		"c": return generate_c_code(arr_str, n)
		_: return generate_cpp_code(arr_str, n)

func generate_cpp_code(arr_str: String, _n: int) -> String:
	return """#include <iostream>
#include <stack>
using namespace std;

int main() {
	int arr[] = { %s };
	int n = sizeof(arr) / sizeof(arr[0]);
	stack<int> s;

	for (int i = 0; i < n; ++i) 
		s.push(arr[i]);

	cout << "Initial stack top: " << s.top() << endl;

	cout << "Popping..." << endl;
	while (!s.empty()) {
		cout << "Popped: " << s.top() << endl;
		s.pop();
	}

	cout << "Simulation finished." << endl;
	return 0;
}

/*
---------------------------------------
 Time Complexity:
%s

 Space Complexity:
%s
---------------------------------------
*/
""" % [arr_str, get_time_complexity(), get_space_complexity()]

func generate_python_code(arr_str: String, _n: int) -> String:
	return """# Stack Simulation in Python
def main():
	arr = [%s]
	stack = []
	
	# Push all elements
	for value in arr:
		stack.append(value)
	
	print("Initial stack top:", stack[-1])
	print("Popping...")
	
	# Pop all elements (LIFO)
	while len(stack) > 0:
		print(f"Popped: {stack.pop()}")
	
	print("Simulation finished.")

if __name__ == "__main__":
	main()

'''
---------------------------------------
 Time Complexity:
%s

 Space Complexity:
%s
---------------------------------------
'''
""" % [arr_str, get_time_complexity(), get_space_complexity()]

func generate_java_code(arr_str: String, _n: int) -> String:
	return """import java.util.Stack;

public class StackSimulation {
	public static void main(String[] args) {
		int[] arr = {%s};
		Stack<Integer> s = new Stack<>();
		
		// Push all elements
		for (int value : arr) {
			s.push(value);
		}
		
		System.out.println("Initial stack top: " + s.peek());
		System.out.println("Popping...");
		
		// Pop all elements
		while (!s.isEmpty()) {
			System.out.println("Popped: " + s.pop());
		}
		
		System.out.println("Simulation finished.");
	}
}

/*
---------------------------------------
 Time Complexity:
%s

 Space Complexity:
%s
---------------------------------------
*/
""" % [arr_str, get_time_complexity(), get_space_complexity()]

func generate_c_code(arr_str: String, _n: int) -> String:
	return """#include <stdio.h>

#define MAX_SIZE 100

typedef struct {
	int items[MAX_SIZE];
	int top;
} Stack;

void initStack(Stack *s) {
	s->top = -1;
}

int isFull(Stack *s) {
	return s->top == MAX_SIZE - 1;
}

int isEmpty(Stack *s) {
	return s->top == -1;
}

void push(Stack *s, int value) {
	if (isFull(s)) {
		printf("Stack is full!\\n");
		return;
	}
	s->items[++(s->top)] = value;
}

int pop(Stack *s) {
	if (isEmpty(s)) {
		printf("Stack is empty!\\n");
		return -1;
	}
	return s->items[(s->top)--];
}

int main() {
	int arr[] = {%s};
	int n = sizeof(arr) / sizeof(arr[0]);
	Stack s;
	initStack(&s);
	
	// Push all elements
	for (int i = 0; i < n; i++) {
		push(&s, arr[i]);
	}
	
	printf("Initial stack top: %d\\n", s.items[s.top]);
	printf("Popping...\\n");
	
	// Pop all elements
	while (!isEmpty(&s)) {
		printf("Popped: %d\\n", pop(&s));
	}
	
	printf("Simulation finished.\\n");
	return 0;
}

/*
---------------------------------------
 Time Complexity:
%s

 Space Complexity:
%s
---------------------------------------
*/
""" % [arr_str, get_time_complexity(), get_space_complexity()]

func _on_cpp_lang_button_pressed() -> void:
	btn_sound.play(); current_code_language = "cpp"; refresh_code_display()
func _on_python_lang_button_pressed() -> void:
	btn_sound.play(); current_code_language = "python"; refresh_code_display()
func _on_java_lang_button_pressed() -> void:
	btn_sound.play(); current_code_language = "java"; refresh_code_display()
func _on_c_lang_button_pressed() -> void:
	btn_sound.play(); current_code_language = "c"; refresh_code_display()

func refresh_code_display() -> void:
	if cpp_popup and cpp_popup.visible and cpp_text:
		var source_arr: Array = []
		if dequeued_elements.size() > 0: source_arr = dequeued_elements.duplicate()
		elif queue.size() > 0: source_arr = queue.duplicate()
		elif waiting_elements.size() > 0: source_arr = waiting_elements.duplicate()
		else: source_arr = [10, 20, 30]
		
		cpp_text.text = generate_code_in_language(current_code_language, source_arr)
		update_language_button_states()
		cpp_tutorialcode_index = 0
		clear_cpp_highlight()
		if cpp_explanation_text: cpp_explanation_text.text = "💡 Click 'Next' to walk through this Stack explanation!"

func get_time_complexity() -> String:
	var ops = []
	if enqueue_counter > 0: ops.append("• Push: O(1)")
	if dequeue_counter > 0: ops.append("• Pop: O(1)")
	if not queue.is_empty(): ops.append("• Top (Peek): O(1)")
	if timeline_log.size() > 0: ops.append("• Traversal (printing): O(n)")
	if ops.is_empty(): return "• Push/Pop: O(1)"
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

func _update_labels() -> void:
	enqueue_label.text = "Push Counter: %d" % enqueue_counter
	dequeue_label.text = "Pop Counter: %d" % dequeue_counter
	
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
	var x = START_POSITION.x
	for child: Control in queue_container.get_children():
		child.position = Vector2(x, START_POSITION.y)
		child.original_position = child.position
		x += child.size.x + BLOCK_SPACING

func _update_front_rear_visibility() -> void:
	if queue.size() > 0:
		# Use rear_icon to show TOP of stack
		if rear_icon:
			rear_icon.show()
			var target_x = START_POSITION.x + (queue.size() - 1) * (64.0 + BLOCK_SPACING)
			rear_icon.position.x = target_x
	else:
		if rear_icon: rear_icon.hide()

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

func clear_cpp_highlight() -> void:
	if not cpp_text: return
	var source_arr: Array = []
	if dequeued_elements.size() > 0: source_arr = dequeued_elements.duplicate()
	elif queue.size() > 0: source_arr = queue.duplicate()
	elif waiting_elements.size() > 0: source_arr = waiting_elements.duplicate()
	else: source_arr = [10, 20, 30]
	cpp_text.text = generate_code_in_language(current_code_language, source_arr)

func _clear_simulation_data() -> void:
	queue.clear()
	waiting_elements.clear()
	dequeued_elements.clear()
	timeline_log.clear()
	enqueue_counter = 0
	dequeue_counter = 0
	
	for child in queue_container.get_children(): child.queue_free()
	for child in dequeued_container.get_children():
		if child != dequeued_close_btn: child.queue_free()
	
	_update_labels()
	_update_front_rear_visibility()
	
	if dequeued_container and dequeued_container.visible: dequeued_container.hide()
	if waiting_popup and waiting_popup.visible: waiting_popup.hide()
	if timeline_popup and timeline_popup.visible: timeline_popup.hide()
	if complete_popup and complete_popup.visible: complete_popup.hide()
	if cpp_popup and cpp_popup.visible: cpp_popup.hide()
	current_popup = null

func _setup_for_enqueue_tutorial() -> void:
	if waiting_elements.is_empty(): waiting_elements = [10, 20, 30, 40, 50]
	while queue.size() >= MAX_QUEUE_SIZE: queue.pop_back()
	_update_labels()

func _setup_for_dequeue_tutorial() -> void:
	if queue.is_empty():
		queue = [10, 20, 30]
		for child in queue_container.get_children(): child.queue_free()
		for i in range(queue.size()):
			var new_block: Control = BLOCK_SCENE.instantiate() as Control
			if new_block.has_method("set"): new_block.set("value", queue[i])
			queue_container.add_child(new_block)
		_resnap_blocks()
	_update_labels()

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

func _on_simulate_new_pressed() -> void:
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == simulate_new_btn and current_step["action"] == "press":
			pass
		else: return
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
	if not tutorial_in_progress: return
	if tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["action"] == "next":
			tutorial_sequence_index += 1
			show_tutorial_step()
		elif current_step["action"] == "end":
			end_tutorial()

# ==============================================
#   INTRODUCTION POPUP LOGIC (RESTORED)
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

func _on_intro_skip_pressed() -> void:
	btn_sound.play()
	if intro_popup: intro_popup.hide()

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
	# If tutorial is already running, restart it
	if tutorial_in_progress:
		end_tutorial()
		await get_tree().create_timer(0.1).timeout
	start_tutorial()

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

	# Clear visual elements
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
	
	# Show the initial choice modal again
	_show_config_modal()

func _on_no_pressed() -> void:
	btn_sound.play()
	sim_confirmation.hide()


func _on_ok_btn_pressed() -> void:
	waiting_popup.hide()
