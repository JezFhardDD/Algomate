extends Control

#  Node paths
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

#  Timeline popup
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: Label = $TimelinePopup/VBoxContainer/Label

#  Simulation Complete popup
@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button

#  C++ Popup
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_label: Label = get_node_or_null("CppPopup/VBoxContainer/Label") as Label
@onready var cpp_text: TextEdit = get_node_or_null("CppPopup/VBoxContainer/TextEdit") as TextEdit
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/Button") as Button

#  Top-right shortcut button (NEW)
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")

#  Queue block scene
const BLOCK_SCENE := preload("res://QueueBlock.tscn")

#  Front/Rear indicators
@onready var rear_icon: Node = $TextureRect/rear
@onready var front_icon: Node = $TextureRect/front
@onready var rear2_icon: Node = $TextureRect/rear2
@onready var front2_icon: Node = $TextureRect/front2

#  Tutorial system
@onready var tutorial_overlay: CanvasLayer = $TutorialOverlay
@onready var dim_bg: ColorRect = $TutorialOverlay/DimBackground
@onready var tutorial_box: Panel = $TutorialOverlay/TutorialBox
@onready var tutorial_text: Label = $TutorialOverlay/TutorialBox/TutorialText
@onready var tutorial_next: Button = $TutorialOverlay/TutorialBox/NextButton
@onready var pointer_sprite: Sprite2D = $TutorialOverlay/PointerSprite
@onready var process_label: Label = $SimulationCompletePopup/VBoxContainer/ProcessLabel
@onready var audio_player = $bgm
@onready var btn_sound = $btn_sound

@onready var config_modal: Panel = $ConfigChoiceModal # Ensure this path is correct
@onready var size_input: SpinBox = $ConfigChoiceModal/SpinBox
@onready var yes_btn: Button = $ConfigChoiceModal/yesButton
@onready var no_btn: Button = $ConfigChoiceModal/NoButton

# Tutorial variables
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false
var current_popup = null  # Track which popup is open during tutorial

#  Settings
var MAX_QUEUE_SIZE: int = 5
var BLOCK_SPACING: float = 10.0
var START_POSITION: Vector2 = Vector2(80, 80)

#  Runtime data
var queue: Array[int] = []
var waiting_elements: Array[int] = []
var dequeued_elements: Array[int] = []
var enqueue_counter: int = 0
var dequeue_counter: int = 0
var timeline_log: Array[String] = []

#  Colors
var colors: Array[Color] = [
	Color8(29, 209, 235),
	Color8(0, 128, 0),
	Color8(144, 238, 144),
	Color8(255, 230, 0),
	Color8(255, 165, 0),
	Color8(220, 53, 69)
]

#  C++ Tutorial
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_text: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")
@onready var cpp_next_button: Button = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/NextButton")

var cpp_tutorial_index := 0
var cpp_tutorial_texts := [
	" This is the **C++ code** automatically generated from your queue simulation.",
	" The **array and its size** are dynamically replaced based on your simulation data.",
	" The **enqueue and dequeue operations** here follow the exact sequence of actions you performed in the simulation.",
	" This feature helps you connect the visual process with the actual C++ implementation!"
]

var cpp_tutorialcode_index := 0
var cpp_tutorial_steps := [
	{
		"lines": Vector2i(0, 2),
		"text": " These are the library imports. <iostream> is for input/output, and <queue> is for the queue container."
	},
	{
		"lines": Vector2i(3, 6),
		"text": " Here, the `main()` function starts. The array is filled with your simulation's data."
	},
	{
		"lines": Vector2i(7, 11),
		"text": " This section enqueues the elements into the queue using a for loop."
	},
	{
		"lines": Vector2i(12, 16),
		"text": " This part prints the current queue contents to visualize the initial state."
	},
	{
		"lines": Vector2i(17, 23),
		"text": " This loop dequeues and displays each element — matching your simulation sequence!"
	},
	{
		"lines": Vector2i(24, 28),
		"text": " The program ends after showing that the queue is empty — simulation complete!"
	}
]

# 🧮 Complexity display
@onready var complexity_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/ComplexityPanel")
@onready var time_label: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/ComplexityPanel/VBoxContainer/TimeLabel")
@onready var space_label: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/ComplexityPanel/VBoxContainer/SpaceLabel")

# to configure size and elements
@onready var config_size_elements_modal: Panel = $ConfigSizeElementsModal
@onready var size_input_detailed: SpinBox = $ConfigSizeElementsModal/SizeSpinBox
@onready var elements_input: TextEdit = $ConfigSizeElementsModal/ElementsTextEdit
@onready var random_elements_btn: Button = $ConfigSizeElementsModal/RandomElementsButton
@onready var confirm_btn: Button = $ConfigSizeElementsModal/ConfirmButton
@onready var cancel_btn: Button = $ConfigSizeElementsModal/CancelButton

# 🏁 Ready
func _ready() -> void:
	print(" Program started — initializing queue visualizer...")
	randomize()
	
	# Hide both modals initially
	config_modal.hide()
	if config_size_elements_modal:
		config_size_elements_modal.hide()
	
	# Connect config modal buttons
	if yes_btn:
		yes_btn.pressed.connect(_on_config_yes_pressed)
	if no_btn:
		no_btn.pressed.connect(_on_config_no_pressed)
	
	# Show the configuration choice modal
	_show_config_modal()

# Configuration modal functions
func _show_config_modal() -> void:
	"""Show the first modal asking if user wants to configure"""
	print(" Showing configuration choice modal...")
	
	# Show the choice modal
	config_modal.show()
	
	# Disable main UI buttons while modal is open
	_set_main_ui_enabled(false)

func _on_config_yes_pressed() -> void:
	"""User wants to configure - show detailed configuration modal"""
	btn_sound.play()
	
	# Hide the choice modal
	config_modal.hide()
	
	# Show the detailed configuration modal
	_show_config_detailed_modal()

func _show_config_detailed_modal() -> void:
	"""Show the modal for configuring size and elements"""
	print(" Showing detailed configuration modal...")
	
	# Set up the detailed modal
	if config_size_elements_modal:
		# Set default size (5-7 range)
		size_input_detailed.min_value = 5
		size_input_detailed.max_value = 7
		size_input_detailed.value = 5
		
		# Generate and show random elements as default
		_update_elements_input()
		
		# Connect buttons if not already connected
		if random_elements_btn and not random_elements_btn.is_connected("pressed", _on_random_elements_pressed):
			random_elements_btn.pressed.connect(_on_random_elements_pressed)
		
		if confirm_btn and not confirm_btn.is_connected("pressed", _on_config_confirm_pressed):
			confirm_btn.pressed.connect(_on_config_confirm_pressed)
		
		if cancel_btn and not cancel_btn.is_connected("pressed", _on_config_cancel_pressed):
			cancel_btn.pressed.connect(_on_config_cancel_pressed)
		
		# Show the modal
		config_size_elements_modal.show()
	else:
		print("ERROR: ConfigSizeElementsModal not found!")
		# Fall back to random configuration
		_on_config_no_pressed()

func _update_elements_input() -> void:
	"""Generate and display random elements based on current size"""
	if not elements_input:
		return
	
	var current_size = int(size_input_detailed.value)
	var elements = []
	
	for i in range(current_size):
		elements.append(str(randi_range(1, 99)))
	
	elements_input.text = ", ".join(elements)

func _on_random_elements_pressed() -> void:
	"""Generate new random elements"""
	btn_sound.play()
	_update_elements_input()

func _on_config_confirm_pressed() -> void:
	"""User confirmed configuration with size and elements"""
	btn_sound.play()
	
	# Get the user's queue size
	MAX_QUEUE_SIZE = int(size_input_detailed.value)
	
	# Parse the elements input
	var elements_text = elements_input.text.strip_edges()
	var elements_array: Array[int] = []  # Explicitly type this as Array[int]
	
	if elements_text.is_empty():
		# Generate random elements
		for i in range(MAX_QUEUE_SIZE):
			elements_array.append(randi_range(1, 99))
	else:
		# Parse comma-separated values
		var parts = elements_text.split(",")
		for part in parts:
			var trimmed = part.strip_edges()
			if trimmed.is_valid_int():
				elements_array.append(int(trimmed))
		
		# Ensure we have exactly MAX_QUEUE_SIZE elements
		while elements_array.size() < MAX_QUEUE_SIZE:
			elements_array.append(randi_range(1, 99))
		while elements_array.size() > MAX_QUEUE_SIZE:
			elements_array.pop_back()
	
	print(" User configured queue size:", MAX_QUEUE_SIZE)
	print(" User configured elements:", elements_array)
	
	# Hide the detailed modal
	config_size_elements_modal.hide()
	
	# Enable main UI
	_set_main_ui_enabled(true)
	
	# Initialize with configured elements
	_initialize_with_elements(elements_array)

func _on_config_cancel_pressed() -> void:
	"""User cancelled detailed configuration - go back to choice"""
	btn_sound.play()
	
	# Hide the detailed modal
	config_size_elements_modal.hide()
	
	# Show the choice modal again
	_show_config_modal()

func _on_config_no_pressed() -> void:
	"""User doesn't want to configure - use random size and elements"""
	btn_sound.play()
	
	# Use random size as before
	MAX_QUEUE_SIZE = randi_range(5, 7)
	print(" User chose random size:", MAX_QUEUE_SIZE)
	
	# Generate random elements
	var random_elements: Array[int] = []  # Explicitly type this as Array[int]
	for i in range(MAX_QUEUE_SIZE):
		random_elements.append(randi_range(1, 99))
	
	# Close the choice modal
	config_modal.hide()
	
	# Enable main UI
	_set_main_ui_enabled(true)
	
	# Initialize with random elements
	_initialize_with_elements(random_elements)

func _set_main_ui_enabled(enabled: bool) -> void:
	"""Enable/disable main UI buttons"""
	if enqueue_btn: enqueue_btn.disabled = not enabled
	if dequeue_btn: dequeue_btn.disabled = not enabled
	if waiting_btn: waiting_btn.disabled = not enabled
	if dequeued_btn: dequeued_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled
	if simulate_new_btn: simulate_new_btn.disabled = not enabled

# Main initialization function
func _initialize_with_elements(elements: Array[int]) -> void:
	"""Initialize the simulation with specific elements"""
	print(" Initializing simulation with queue size:", MAX_QUEUE_SIZE, " and elements:", elements)
	
	audio_player.play()
	
	# Set waiting elements to the configured elements
	waiting_elements = elements.duplicate()
	
	# Connect main UI buttons
	if enqueue_btn: 
		if not enqueue_btn.is_connected("pressed", _on_enqueue_pressed):
			enqueue_btn.pressed.connect(_on_enqueue_pressed)
	if dequeue_btn: 
		if not dequeue_btn.is_connected("pressed", _on_dequeue_pressed):
			dequeue_btn.pressed.connect(_on_dequeue_pressed)
	
	# Connect other buttons
	if waiting_btn: 
		if not waiting_btn.is_connected("pressed", _on_WaitingElements_pressed):
			waiting_btn.pressed.connect(_on_WaitingElements_pressed)
	if dequeued_btn: 
		if not dequeued_btn.is_connected("pressed", _on_dequeued_pressed):
			dequeued_btn.pressed.connect(_on_dequeued_pressed)
	if timeline_btn: 
		if not timeline_btn.is_connected("pressed", _on_timeline_pressed):
			timeline_btn.pressed.connect(_on_timeline_pressed)
	if simulate_new_btn: 
		if not simulate_new_btn.is_connected("pressed", _on_simulate_new_pressed):
			simulate_new_btn.pressed.connect(_on_simulate_new_pressed)
	
	# Connect popup buttons
	if complete_ok_btn: 
		if not complete_ok_btn.is_connected("pressed", _on_complete_ok_pressed):
			complete_ok_btn.pressed.connect(_on_complete_ok_pressed)
	if show_cpp_btn: 
		if not show_cpp_btn.is_connected("pressed", _on_show_cpp_pressed):
			show_cpp_btn.pressed.connect(_on_show_cpp_pressed)
	
	if dequeued_close_btn: 
		if not dequeued_close_btn.is_connected("pressed", _on_dequeued_close_pressed):
			dequeued_close_btn.pressed.connect(_on_dequeued_close_pressed)
	
	# Connect C++ buttons
	if cpp_close_btn: 
		if not cpp_close_btn.is_connected("pressed", _on_cpp_close_pressed):
			cpp_close_btn.pressed.connect(_on_cpp_close_pressed)
	
	# Connect top-right "C++ Code" button
	if cpp_code_button:
		if not cpp_code_button.is_connected("pressed", _on_cpp_code_button_pressed):
			cpp_code_button.pressed.connect(_on_cpp_code_button_pressed)
		cpp_code_button.hide()
	
	# Connect tutorial buttons
	if tutorial_next: 
		if not tutorial_next.is_connected("pressed", _on_next_button_pressed):
			tutorial_next.pressed.connect(_on_next_button_pressed)
	
	# Hide popups initially
	if dequeued_container: dequeued_container.hide()
	if cpp_popup: cpp_popup.hide()
	if tutorial_overlay: tutorial_overlay.hide()
	if waiting_popup: waiting_popup.hide()
	if timeline_popup: timeline_popup.hide()
	
	_update_labels()
	_update_front_rear_visibility()
	print(" Initialization complete — ready to simulate!\n")

# TUTORIAL FUNCTIONS
func start_tutorial() -> void:
	print("Tutorial starting...")
	btn_sound.play()
	
	# Initialize tutorial state
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	tutorial_overlay.show()
	
	dim_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	dim_bg.show()
	tutorial_box.show()
	
	# Define the tutorial sequence based on your requirements
	tutorial_sequence = [
		# Step 1: Enqueue button (needs to be pressed)
		{
			"node": enqueue_btn,
			"text": "This is the ENQUEUE button. It adds new data into the queue. Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": null
		},
		# Step 2: Dequeue button (needs to be pressed)
		{
			"node": dequeue_btn,
			"text": "This is the DEQUEUE button. It removes data from the front of the queue (FIFO). Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": null
		},
		# Step 3: Dequeued Elements button (needs to be pressed)
		{
			"node": dequeued_btn,
			"text": "This button shows all dequeued elements — the ones already processed. Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": "dequeued"
		},
		# Step 4: Waiting Elements button (needs to be pressed)
		{
			"node": waiting_btn,
			"text": "Here you can view waiting elements that will enter the queue next. Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": "waiting"
		},
		# Step 5: Timeline button (needs to be pressed)
		{
			"node": timeline_btn,
			"text": "The TIMELINE button shows a record of all enqueue and dequeue actions. Press this button to continue.",
			"action": "press",
			"highlight_only": false,
			"pointer_position": "center",
			"popup_to_close": "timeline"
		},
		# Step 6: Timeline button (highlight only - explanation)
		{
			"node": timeline_btn,
			"text": "The TIMELINE shows your simulation history. You can review all actions performed.",
			"action": "next",
			"highlight_only": true,
			"pointer_position": "none",
			"popup_to_close": null
		},
		# Step 7: Simulate New button (highlight only - explanation)
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
	
	# Debug print
	print("Pointer at: ", pointer_pos, " | Button at: ", node_rect.position)
	
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
		# First, stop any existing tween
		if node.has_meta("tween"):
			var existing_tween: Tween = node.get_meta("tween")
			if existing_tween and existing_tween.is_valid():
				existing_tween.stop()
				node.remove_meta("tween")
		
		# Create new tween with pulsing animation
		var tween = create_tween()
		tween.set_loops()
		
		# Store tween reference in node metadata
		node.set_meta("tween", tween)
		
		# Animate the modulate property
		tween.tween_property(node, "modulate", Color(1.5, 1.5, 0.3, 1), 0.5)
		tween.tween_property(node, "modulate", Color(2.0, 2.0, 0.5, 1), 0.5)

func clear_highlights() -> void:
	# Stop any running tweens first
	var nodes_to_clear = [enqueue_btn, dequeue_btn, waiting_btn, dequeued_btn, timeline_btn, simulate_new_btn, enqueue_label, dequeue_label]
	
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

func enable_only_target_button(target_node: Control) -> void:
	# Disable all buttons except the target
	if enqueue_btn: enqueue_btn.disabled = (target_node != enqueue_btn)
	if dequeue_btn: dequeue_btn.disabled = (target_node != dequeue_btn)
	if waiting_btn: waiting_btn.disabled = (target_node != waiting_btn)
	if dequeued_btn: dequeued_btn.disabled = (target_node != dequeued_btn)
	if timeline_btn: timeline_btn.disabled = (target_node != timeline_btn)
	if simulate_new_btn: simulate_new_btn.disabled = true  # Always disabled during press steps

func enable_all_buttons() -> void:
	# Enable all buttons
	if enqueue_btn: enqueue_btn.disabled = false
	if dequeue_btn: dequeue_btn.disabled = false
	if waiting_btn: waiting_btn.disabled = false
	if dequeued_btn: dequeued_btn.disabled = false
	if timeline_btn: timeline_btn.disabled = false
	if simulate_new_btn: simulate_new_btn.disabled = false

func end_tutorial() -> void:
	print("Tutorial finished!")
	tutorial_in_progress = false
	tutorial_overlay.hide()
	clear_highlights()
	pointer_sprite.hide()
	current_popup = null
	
	# Close any open popups
	if dequeued_container and dequeued_container.visible:
		dequeued_container.hide()
		if front2_icon: front2_icon.hide()
		if rear2_icon: rear2_icon.hide()
	if waiting_popup and waiting_popup.visible:
		waiting_popup.hide()
	if timeline_popup and timeline_popup.visible:
		timeline_popup.hide()
	
	# Clear all simulation data
	queue.clear()
	waiting_elements.clear()
	dequeued_elements.clear()
	timeline_log.clear()
	enqueue_counter = 0
	dequeue_counter = 0
	
	# Clear visual blocks
	for child in queue_container.get_children():
		child.queue_free()
	
	for child in dequeued_container.get_children():
		if child != dequeued_close_btn:
			child.queue_free()
	
	# Reset UI labels
	_update_labels()
	_update_front_rear_visibility()
	
	# Show configuration modal again to start fresh
	_show_config_modal()
	
	# Re-enable all buttons
	enable_all_buttons()
	
	print("Tutorial completed - simulation reset to start fresh!")

# Helper function to advance tutorial after popup is handled
func advance_tutorial_after_popup() -> void:
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		# Check if this button matches the current tutorial step
		if current_step["action"] == "press":
			# Tutorial step completed
			tutorial_sequence_index += 1
			show_tutorial_step()

# ➕ Enqueue
func _on_enqueue_pressed() -> void:
	# Check if in tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == enqueue_btn and current_step["action"] == "press":
			pass  # We'll do the enqueue action below
		else:
			# If this is not the target button in tutorial, don't do anything
			print("Tutorial: Please press the highlighted button first")
			return
	
	# Regular enqueue logic (this should run whether in tutorial or not)
	if queue.size() >= MAX_QUEUE_SIZE:
		print("❌ Queue full!")
		return
	if waiting_elements.is_empty():
		return

	btn_sound.play()
	var new_val: int = waiting_elements.pop_front()
	queue.append(new_val)
	enqueue_counter += 1
	timeline_log.append("Enqueued %d" % new_val)

	var new_block: Control = BLOCK_SCENE.instantiate() as Control
	if new_block.has_method("set"): new_block.set("value", new_val)
	
	queue_container.add_child(new_block)
	
	# --- START ANIMATION ---
	# Calculate final position
	var target_x = START_POSITION.x + (queue.size() - 1) * (new_block.size.x + BLOCK_SPACING)
	var final_pos = Vector2(target_x, START_POSITION.y)
	
	# Start from right and transparent
	new_block.position = final_pos + Vector2(200, 0) 
	new_block.modulate.a = 0
	
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(new_block, "position", final_pos, 0.5)
	tween.tween_property(new_block, "modulate:a", 1.0, 0.4)
	# --- END ANIMATION ---

	_update_labels()
	_update_front_rear_visibility()
	
	# Now check if we need to advance tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == enqueue_btn and current_step["action"] == "press":
			# Tutorial step completed
			tutorial_sequence_index += 1
			show_tutorial_step()

# ➖ Dequeue
func _on_dequeue_pressed() -> void:
	# Check if in tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == dequeue_btn and current_step["action"] == "press":
			pass  # We'll do the dequeue action below
		else:
			# If this is not the target button in tutorial, don't do anything
			print("Tutorial: Please press the highlighted button first")
			return
	
	# Regular dequeue logic
	if queue.is_empty():
		return

	btn_sound.play()
	var removed_val: int = queue.pop_front()
	dequeue_counter += 1
	dequeued_elements.append(removed_val)
	timeline_log.append("Dequeued %d" % removed_val)

	var front_block = queue_container.get_child(0)
	
	# --- START EXIT ANIMATION ---
	var exit_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	exit_tween.tween_property(front_block, "position", front_block.position + Vector2(-200, 0), 0.4)
	exit_tween.tween_property(front_block, "modulate:a", 0.0, 0.3)
	
	await exit_tween.finished
	front_block.queue_free()
	# --- END EXIT ANIMATION ---

	# Shift remaining blocks
	_animate_queue_shift()
	
	_update_labels()
	_update_front_rear_visibility()

	if queue.is_empty() and waiting_elements.is_empty():
		_show_complete_popup()
	
	# Now check if we need to advance tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == dequeue_btn and current_step["action"] == "press":
			# Tutorial step completed
			tutorial_sequence_index += 1
			show_tutorial_step()

func _animate_queue_shift() -> void:
	var x = START_POSITION.x
	var shift_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	for child: Control in queue_container.get_children():
		# Skip the block that is currently being freed
		if child.is_queued_for_deletion(): continue
		
		shift_tween.tween_property(child, "position", Vector2(x, START_POSITION.y), 0.4)
		child.original_position = Vector2(x, START_POSITION.y)
		x += child.size.x + BLOCK_SPACING

# 👁️ Waiting Elements popup
func _on_WaitingElements_pressed() -> void:
	# Check if in tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == waiting_btn and current_step["action"] == "press":
			pass  # We'll show the popup below
		else:
			# If this is not the target button in tutorial, don't do anything
			print("Tutorial: Please press the highlighted button first")
			return
	
	print("\n Waiting Elements button pressed")
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
	
	# Now check if we need to advance tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == waiting_btn and current_step["action"] == "press":
			# Tutorial step completed
			tutorial_sequence_index += 1
			show_tutorial_step()

# 🎉 Simulation complete popup
func _show_complete_popup() -> void:
	if complete_popup:
		var total_processes = enqueue_counter + dequeue_counter
		var process_text = "Total Processes: %d\n→ Enqueue: %d\n→ Dequeue: %d" % [total_processes, enqueue_counter, dequeue_counter]

		if process_label:
			process_label.text = process_text

		complete_popup.popup_centered()
		print("📢 Showing 'Simulation Complete' popup...")

	# Show the top-right C++ button once simulation finishes
	if cpp_code_button:
		cpp_code_button.show()

func _on_complete_ok_pressed() -> void:
	print(" Simulation Complete popup closed.")
	if complete_popup:
		complete_popup.hide()

# 💻 Show C++ code popup
func _on_show_cpp_pressed() -> void:
	print(" Show C++ Code button pressed.")
	btn_sound.play()
	if complete_popup and complete_popup.visible:
		complete_popup.hide()
	_show_cpp_popup()

#  NEW — shared function to show C++ popup (used by both buttons)
func _show_cpp_popup() -> void:
	var source_arr: Array = []
	if dequeued_elements.size() > 0:
		source_arr = dequeued_elements.duplicate()
	elif queue.size() > 0:
		source_arr = queue.duplicate()
	elif waiting_elements.size() > 0:
		source_arr = waiting_elements.duplicate()
	else:
		source_arr = [10, 20, 30]

	var arr_str := ", ".join(source_arr.map(func(x): return str(x)))
	
	var cpp_code := """#include <iostream>
#include <queue>
using namespace std;

int main() {
	int arr[] = { %s };
	int n = sizeof(arr) / sizeof(arr[0]);
	queue<int> q;

	for (int i = 0; i < n; ++i) 
		q.push(arr[i]);

	cout << "Initial queue:";
	queue<int> copy = q;
	while (!copy.empty()) {
		cout << " " << copy.front();
		copy.pop();
	}
	cout << endl;

	cout << "Dequeuing..." << endl;
	while (!q.empty()) {
		cout << "Dequeued: " << q.front() << endl;
		q.pop();
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

	if cpp_popup and cpp_text:
		cpp_text.editable = false
		cpp_text.text = cpp_code
		cpp_text.custom_minimum_size = Vector2(700, 420)
		cpp_popup.popup_centered()
		print(" C++ code populated into CppPopup/TextEdit.")

	start_cpp_code_tutorial()

# 🧮 Dynamic Complexity Functions
func get_time_complexity() -> String:
	var ops = []
	if enqueue_counter > 0:
		ops.append("• Enqueue (push): O(1)")
	if dequeue_counter > 0:
		ops.append("• Dequeue (pop): O(1)")
	if not queue.is_empty():
		ops.append("• Front/Rear access: O(1)")
	if timeline_log.size() > 0:
		ops.append("• Traversal (printing): O(n)")
	return "\n".join(ops)

func get_space_complexity() -> String:
	var total_elements = queue.size() + waiting_elements.size() + dequeued_elements.size()
	return "O(n) — where n = %d (total elements handled in this simulation)" % total_elements

func _on_cpp_close_pressed() -> void:
	btn_sound.play()
	print("❌ Closing C++ popup.")
	if cpp_popup:
		cpp_popup.hide()

#  Timeline
func _on_timeline_pressed() -> void:
	# Check if in tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == timeline_btn and current_step["action"] == "press":
			pass  # We'll show the popup below
		else:
			# If this is not the target button in tutorial, don't do anything
			print("Tutorial: Please press the highlighted button first")
			return
	
	print("\n Timeline button pressed")
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
	
	# Now check if we need to advance tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == timeline_btn and current_step["action"] == "press":
			# Tutorial step completed
			tutorial_sequence_index += 1
			show_tutorial_step()

#  Dequeued list
func _on_dequeued_pressed() -> void:
	# Check if in tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == dequeued_btn and current_step["action"] == "press":
			pass  # We'll show the popup below
		else:
			# If this is not the target button in tutorial, don't do anything
			print("Tutorial: Please press the highlighted button first")
			return
	
	print("\n Dequeued elements button pressed")
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
	
	# Now check if we need to advance tutorial
	if tutorial_in_progress and tutorial_sequence_index < tutorial_sequence.size():
		var current_step = tutorial_sequence[tutorial_sequence_index]
		if current_step["node"] == dequeued_btn and current_step["action"] == "press":
			# Tutorial step completed
			tutorial_sequence_index += 1
			show_tutorial_step()

func _on_dequeued_close_pressed() -> void:
	print(" DequeuedContainer closed")
	btn_sound.play()
	dequeued_container.hide()
	if front2_icon: front2_icon.hide()
	if rear2_icon: rear2_icon.hide()
	current_popup = null

#  Refresh dequeued list
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

#  Helpers
func _update_labels() -> void:
	enqueue_label.text = "Enqueue Counter: %d" % enqueue_counter
	dequeue_label.text = "Dequeue Counter: %d" % dequeue_counter
	enqueue_btn.disabled = waiting_elements.is_empty()

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
	_resnap_blocks()

func _resnap_blocks() -> void:
	var x = START_POSITION.x
	for child: Control in queue_container.get_children():
		child.position = Vector2(x, START_POSITION.y)
		child.original_position = child.position
		x += child.size.x + BLOCK_SPACING

func _shift_blocks_left() -> void:
	_resnap_blocks()

func _update_front_rear_visibility() -> void:
	if queue.size() > 0:
		if front_icon: front_icon.show()
		if rear_icon: rear_icon.show()
	else:
		if front_icon: front_icon.hide()
		if rear_icon: rear_icon.hide()

# 🔄 Reset simulation
func _on_simulate_new_pressed() -> void:
	# Check if in tutorial
	if tutorial_in_progress:
		# Simulate New button should not be pressable during tutorial
		print("Tutorial: Please complete the tutorial first")
		return
	
	print("\n Simulation restarted")
	btn_sound.play()
	
	# Clear everything
	queue.clear()
	waiting_elements.clear()
	dequeued_elements.clear()
	timeline_log.clear()
	enqueue_counter = 0
	dequeue_counter = 0

	for child in queue_container.get_children():
		child.queue_free()
	for child in dequeued_container.get_children():
		if child != dequeued_close_btn:
			child.queue_free()

	# Generate new random configuration
	MAX_QUEUE_SIZE = randi_range(5, 7)
	var random_elements: Array[int] = []  # Explicitly type this as Array[int]
	for i in range(MAX_QUEUE_SIZE):
		var new_val = randi_range(1, 99)
		random_elements.append(new_val)
	
	print(" Simulation reset complete. New size:", MAX_QUEUE_SIZE, " elements:", random_elements)
	
	# Initialize with new random elements
	_initialize_with_elements(random_elements)
	
	# Hide C++ button when restarting
	if cpp_code_button:
		cpp_code_button.hide()

#  Shortcut button handler (NEW)
func _on_cpp_code_button_pressed() -> void:
	print(" Top-right C++ Code button pressed.")
	btn_sound.play()
	_show_cpp_popup()

func _on_close_pressed() -> void:
	get_node("CppPopup").visible = false
	btn_sound.play()

func start_cpp_code_tutorial() -> void:
	if not cpp_popup or not cpp_text or not cpp_tutorial_panel:
		return
	cpp_tutorial_index = 0
	cpp_tutorial_panel.show()
	highlight_cpp_code()
	show_cpp_explanation()

func highlight_cpp_code() -> void:
	# Add a glowing style around the TextEdit
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 0.8, 0.15)
	sb.border_color = Color(1, 1, 0.2, 1)
	sb.set_border_width_all(4)  # ✅ Correct setter for Godot 4
	cpp_text.add_theme_stylebox_override("normal", sb)

func clear_cpp_highlight() -> void:
	cpp_text.remove_theme_stylebox_override("normal")

func show_cpp_explanation() -> void:
	if cpp_tutorial_index >= cpp_tutorial_steps.size():
		end_cpp_tutorial()
		return
	
	var step = cpp_tutorial_steps[cpp_tutorial_index]
	var lines = step["lines"]
	cpp_explanation_text.text = step["text"]
	highlight_cpp_lines(lines.x, lines.y)

func _on_cpp_next_button_pressed() -> void:
	btn_sound.play()
	cpp_tutorial_index += 1
	show_cpp_explanation()

func end_cpp_tutorial() -> void:
	cpp_tutorial_panel.hide()
	clear_cpp_highlight()
	print(" C++ tutorial finished.")

func highlight_cpp_lines(start_line: int, end_line: int) -> void:
	clear_cpp_highlight()
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 0.8, 0.2)
	sb.border_color = Color(1, 1, 0.2, 1)
	sb.set_border_width_all(2)
	cpp_text.add_theme_stylebox_override("normal", sb)
	
	# Highlight specific lines by selecting them
	cpp_text.select(start_line, 0, end_line, 0)

# TUTORIAL BUTTON HANDLERS
func _on_help_button_pressed() -> void:
	print("Help button pressed!")
	btn_sound.play()
	
	# If tutorial is already running, restart it
	if tutorial_in_progress:
		end_tutorial()
		await get_tree().create_timer(0.1).timeout
	
	# Start the tutorial
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
