extends Control
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = $CppPopup/VBoxContainer/HBoxContainer2/CompileButton
# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton
@onready var auto_btn: Button = $VBoxContainer/WaitingElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var compare_label: Label = $MarginContainer/HBoxContainer2/TextureRect/Label
@onready var array_container: Control = $QueueContainer
@onready var dequeued_container: Control = $DequeuedContainer

# --- POPUPS ---
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label

# --- TIMELINE POPUP ---
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: RichTextLabel = $TimelinePopup/MainVBox/ScrollContainer/VBoxContainer/RichTextLabel
@onready var timeline_close_btn: Button = get_node_or_null("TimelinePopup/MainVBox/CloseButton")

# Queue Full Warning
@onready var Queue_full: Panel = get_node_or_null("Queue_full")
@onready var anim_sprite: AnimatedSprite2D = get_node_or_null("Queue_full/AnimatedSprite2D")

# Simulation Complete popup
@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var process_label: Label = get_node_or_null("SimulationCompletePopup/VBoxContainer/ProcessLabel")

# --- CODE VIEW POPUP NODES ---
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_text: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/ScrollContainer/RichTextLabel") as RichTextLabel
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/close") as Button

# Code Walkthrough Nodes
@onready var cpp_next_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CppNextButton")
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_lbl: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")

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
@onready var sim_yes_btn: Button = $Simulate_new_confirmation/yes
@onready var sim_no_btn: Button = $Simulate_new_confirmation/no
@onready var help_btn:Button = $HelpButton
@onready var q_mark_sprite: AnimatedSprite2D = $HelpButton/Q_mark_anim_sprites

# --- LANGUAGE BUTTONS ---
@onready var cpp_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Cpp_btn
@onready var python_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Py_btn
@onready var java_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Java_btn
@onready var c_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/C_btn

@onready var timer_label: Label = $VBoxContainer/HBoxContainer/Label2
@onready var clock = $VBoxContainer/HBoxContainer/AnimatedSprite2D
@onready var hbox = $VBoxContainer/HBoxContainer
@onready var time_up_popup: PopupPanel = $TimeUpPopup
@onready var try_again_button: Button = $TryAgainButton
@onready var difficulty_label: Label = $DiificultyLabel

const TIKTAK_SFX := preload("res://assets/sfx/tiktak.mp3")
var tiktak_sound: AudioStreamPlayer

#RESULT POPUP RESOURCES
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

# --- INSERTION SORT VARIABLES ---
var main_array: Array[int] = []
var initial_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []

# Insertion sort specific tracking
var current_index: int = 1  # Start from second element (index 1)
var insert_position: int = 0  # Where the current element should be inserted
var is_comparing: bool = false  # Are we in comparison phase?
var comparison_counter: int = 0
var insertion_counter: int = 0
var sorting_complete: bool = false
var is_sorting: bool = false
var is_auto_playing: bool = false

var mistake_counter: int = 0
var correct_moves: int = 0

var BLOCK_WIDTH: float = 64.0
var BLOCK_SPACING: float = 15.0
var START_POSITION: Vector2 = Vector2(50, 80)
var ANIM_SPEED: float = 1.0

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

# Intro Text
var intro_step: int = 0
var intro_texts = [
	"Welcome to Insertion Sort Simulation!\nInsertion Sort builds the final sorted array one element at a time by repeatedly inserting elements into their correct position.",
	"The Algorithm:\n\n1. Start with the second element (index 1)\n2. Compare it with elements before it\n3. Shift larger elements right\n4. Insert the element in its correct position\n5. Move to next unsorted element",
	"Instructions:\n\n• Drag a block to insert it into the sorted portion\n• Green = correct insertion position\n• Red = incorrect insertion position\n• Only correct insertions progress the algorithm",
	"Buttons to use:\n\n• Undo – revert last move\n• Redo – reapply move\n• Timeline – view move history",
	"Difficulty Levels:\n\n1. Easy: Allows undos and redos\n-No timer\n\n2. Medium: Allows undos and redos\n-90 seconds timer\n\n3. Hard: No undos and redos\n-60 seconds timer"
]

# --- CODE TUTORIAL DATA ---
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

# 1. C++ DATA (Insertion Sort)
var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Complexity Analysis:\nInsertion Sort has O(n^2) Time Complexity in worst case, O(1) Space Complexity." },
	{ "lines": [2, 3], "text": "2. Imports & Setup:\nIncludes standard libraries." },
	{ "lines": [4, 5], "text": "3. Outer Loop:\nIterates from index 1 to n-1. This represents the 'key' element to insert." },
	{ "lines": [6, 7], "text": "4. Key Selection:\nStore current element as key. This is the element we're inserting." },
	{ "lines": [8, 9], "text": "5. Inner Loop:\nCompare key with elements before it, shifting larger elements right." },
	{ "lines": [10, 11], "text": "6. Insertion:\nPlace the key in its correct position." }
]

# 2. PYTHON DATA (Insertion Sort)
var python_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Complexity:\nTime is O(n^2). Space is O(1)." },
	{ "lines": [2, 3], "text": "2. Function Definition:\nDefines the function and gets the array length." },
	{ "lines": [4], "text": "3. Outer Loop:\nIterates through unsorted elements starting from index 1." },
	{ "lines": [5, 6], "text": "4. Key Selection:\nStore current element as key and set initial position." },
	{ "lines": [7, 8], "text": "5. Shift Phase:\nMove larger elements to the right to make space." },
	{ "lines": [9], "text": "6. Insert Phase:\nPlace the key in its correct position." }
]

# 3. JAVA DATA (Insertion Sort)
var java_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Class Structure:\nAll code in a class." },
	{ "lines": [2, 3], "text": "2. Method Definition:\nDefine the sort method." },
	{ "lines": [4], "text": "3. Outer Loop:\nIterate through unsorted elements." },
	{ "lines": [5, 6], "text": "4. Key Selection:\nStore current element as key." },
	{ "lines": [7, 8, 9], "text": "5. Shift Phase:\nMove larger elements to the right." },
	{ "lines": [10], "text": "6. Insert Phase:\nPlace key in correct position." }
]

# 4. C DATA (Insertion Sort)
var c_tutorial_data = [
	{ "lines": [0], "text": "1. Setup:\nInclude standard I/O." },
	{ "lines": [1, 2], "text": "2. Function Start:\nDeclare variables." },
	{ "lines": [3], "text": "3. Outer Loop:\nIterate through array." },
	{ "lines": [4, 5], "text": "4. Key Selection:\nSet current element as key." },
	{ "lines": [6, 7], "text": "5. Shift Phase:\nMove elements to create space." },
	{ "lines": [8], "text": "6. Insert Phase:\nPlace key in correct position." }
]

enum SimMode { LECTURE, ASSESSMENT }
var sim_mode: SimMode = SimMode.ASSESSMENT
var difficulty := 2  # 1 easy, 2 medium, 3 hard

var time_remaining: float = 0.0
var timer_running: bool = false
var assessment_time_limit: float = 0.0

var undo_stack: Array = []
var redo_stack: Array = []
var move_history: Array = []
var move_redo_stack: Array = []

# Grade tracking
var has_completed_assessment: bool = false
var time_when_completed: float = 0.0
var coins_earned: int = 0
var completion_type: String = ""
var current_target_tween: Tween = null

func _get_array_size() -> int:
	match difficulty:
		1: return 4
		2: return 5
		3: return 7
	return 5

func _get_time_limit() -> float:
	match difficulty:
		1: return 100000.0 # Easy
		2: return 13.0    # Medium
		3: return 60.0    # Hard
	return 90.0

func _ready() -> void:
	print("=== DEBUG: Node References ===")
	print("array_container: ", array_container)
	print("block_nodes size: ", block_nodes.size())
	print("main_array size: ", main_array.size())
	tiktak_sound = AudioStreamPlayer.new()
	tiktak_sound.stream = TIKTAK_SFX
	add_child(tiktak_sound)
	try_again_button.visible = false
	print(" Program started — initializing Insertion Sort visualizer...")
	randomize()
	await get_tree().process_frame
	if not array_container:
		print("ERROR: array_container not found!")
		return
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
	
	sim_mode = SimMode.ASSESSMENT
	assessment_time_limit = _get_time_limit()
	time_remaining = assessment_time_limit
	timer_running = false
	set_process(true)
	
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	# Force hide pointers
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if unused_ptr1: unused_ptr1.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	if cpp_code_button: cpp_code_button.hide()
	
	# Rename Buttons
	if sort_btn: sort_btn.text = "UNDO"
	if auto_btn: auto_btn.text = "REDO"
	
	_start_assessment_mode()
	call_deferred("show_introduction")
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")
	
	_connect_language_buttons()
	
	# Connect signals
	if tutorial_next:
		if not tutorial_next.is_connected("pressed", _on_next_button_pressed):
			tutorial_next.pressed.connect(_on_next_button_pressed)
			
	if sim_yes_btn:
		if not sim_yes_btn.is_connected("pressed", _on_yes_pressed):
			sim_yes_btn.pressed.connect(_on_yes_pressed)
			
	if sim_no_btn:
		if not sim_no_btn.is_connected("pressed", _on_no_pressed):
			sim_no_btn.pressed.connect(_on_no_pressed)
	
	clock.centered = true
	clock.position = Vector2(0, 18)
	
	# Connect result popup buttons
	if try_again_result_btn:
		try_again_result_btn.pressed.connect(_on_try_again_result_pressed)
	if back_result_btn:
		back_result_btn.pressed.connect(_on_back_result_pressed)
	if translate_code_btn:
		translate_code_btn.pressed.connect(_on_translate_code_pressed)
	
	_update_difficulty_label()
	_setup_timeline_popup_for_mobile()
	
	# Highlight the current element being processed
	_highlight_current_element()
	_setup_compiler()

func _setup_timeline_popup_for_mobile():
	if not timeline_popup:
		return
	
	var scroll_container = timeline_popup.find_child("ScrollContainer", true, false)
	if scroll_container:
		scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
		scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		scroll_container.mouse_filter = Control.MOUSE_FILTER_STOP

# Update the restart functions to kill the tween
func _start_assessment_mode():
	try_again_button.visible = false  # Always hide when restarting
	
	# Kill any existing tween animation
	if current_target_tween:
		current_target_tween.kill()
		current_target_tween = null
	
	clock.visible = false
	clock.modulate = Color(1, 1, 1, 1)
	clock.stop()

	# Reset ALL state variables
	mistake_counter = 0
	correct_moves = 0
	comparison_counter = 0
	insertion_counter = 0
	current_index = 1  # Start from second element
	insert_position = 0
	is_comparing = false
	sorting_complete = false
	is_sorting = false
	is_auto_playing = false
	has_completed_assessment = false
	completion_type = ""
	coins_earned = 0
	
	# Clear history stacks
	undo_stack.clear()
	redo_stack.clear()
	move_history.clear()
	move_redo_stack.clear()
	timeline_log.clear()
	
	# Reset UI
	_update_timeline_display()
	
	sim_mode = SimMode.ASSESSMENT
	assessment_time_limit = _get_time_limit()
	time_remaining = assessment_time_limit
	timer_running = true
	_update_difficulty_label()
	
	# Handle clock visibility based on difficulty
	if difficulty == 1: # Easy
		timer_label.hide()
		timer_running = false
		clock.visible = false
		clock.modulate = Color(1,1,1,0)
		clock.stop()
	else:
		timer_label.show()
		timer_running = true
		await get_tree().process_frame
		clock.visible = true
		clock.modulate = Color(1, 1, 1, 1)
		clock.play()
	
	# Generate new array
	var size: int = _get_array_size()
	var arr: Array[int] = []
	
	for i in range(size):
		arr.append(randi_range(1, 99))
	
	_initialize_with_elements(arr)
	_update_undo_redo_buttons()

func _process(delta: float) -> void:
	if sim_mode != SimMode.ASSESSMENT:
		return
	
	if not timer_running:
		return
	
	if sorting_complete:
		timer_running = false
		return
	
	time_remaining -= delta
	
	if time_remaining <= 0:
		time_remaining = 0
		timer_running = false
		tiktak_sound.stop()
		_on_time_up()
	
	# Update timer label
	if timer_label:
		var total_seconds: int = int(time_remaining)
		var minutes: int = total_seconds / 60
		var seconds: int = total_seconds % 60
		timer_label.text = "%02d:%02d" % [minutes, seconds]
	
	if time_remaining <= 10.0 and timer_running:
		if not tiktak_sound.playing:
			tiktak_sound.play()

func _on_time_up() -> void:
	tiktak_sound.stop()
	show_feedback("Time's Up!", Color.RED, START_POSITION)
	timer_running = false
	is_sorting = true  # disables dragging
	
	# Note: TryAgainButton visibility is handled by _end_assessment which calls _show_result_popup
	_end_assessment("timeout")

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
# Also update the _initialize_with_elements function to reset the tween
func _initialize_with_elements(elements: Array[int]) -> void:
	print("Initializing Array with:", elements)
	if not array_container:
		print("ERROR: array_container is null!")
		return
	audio_player.play()
	
	main_array = elements.duplicate()
	initial_array = elements.duplicate()
	block_nodes.clear()
	timeline_log.clear()
	
	# Reset all state variables
	comparison_counter = 0
	insertion_counter = 0
	sorting_complete = false
	is_auto_playing = false
	mistake_counter = 0
	correct_moves = 0
	
	# Kill any existing tween animation
	if current_target_tween:
		current_target_tween.kill()
		current_target_tween = null
	
	# Clear history stacks
	undo_stack.clear()
	redo_stack.clear()
	move_history.clear()
	move_redo_stack.clear()
	
	# Clear existing children
	for child in array_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	var current_x = START_POSITION.x
	for i in range(main_array.size()):
		var val = main_array[i]
		var new_block = BLOCK_SCENE.instantiate()
		if not new_block:
			print("ERROR: Failed to instantiate block scene!")
			continue
		new_block.value = val
		new_block.position = Vector2(current_x, START_POSITION.y)
		
		new_block.draggable = true
		if not new_block.is_connected("block_dropped", _on_block_dropped):
			new_block.connect("block_dropped", _on_block_dropped)
		
		# Initial visual
		new_block.modulate.a = 0.0
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(new_block, "modulate:a", 1.0, 0.5)
		
		array_container.add_child(new_block)
		block_nodes.append(new_block)
		current_x += new_block.size.x + BLOCK_SPACING
	
	print("Blocks created: ", block_nodes.size())
	
	# Connect signals
	_safe_connect(timeline_btn, "pressed", _on_timeline_pressed)
	_safe_connect(complete_ok_btn, "pressed", _on_complete_ok_pressed)
	_safe_connect(show_cpp_btn, "pressed", _on_show_cpp_pressed)
	_safe_connect(cpp_code_button, "pressed", _on_cpp_code_button_pressed)
	_safe_connect(cpp_close_btn, "pressed", _on_cpp_close_pressed)
	
	if timeline_close_btn:
		if not timeline_close_btn.is_connected("pressed", _on_timeline_close_pressed):
			timeline_close_btn.pressed.connect(_on_timeline_close_pressed)

	_update_ui_labels()
	if cpp_code_button: cpp_code_button.hide()
	
	# Set initial target
	_update_current_target()


func _safe_connect(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

# Update the highlight function to show sorted vs unsorted regions
func _highlight_current_element():
	# This function is now replaced by _update_current_target()
	_update_current_target()

func show_feedback(text: String, color: Color, position: Vector2) -> void:
	var feedback_scene = preload("res://scene/FeedbackLabel.tscn")
	var label = feedback_scene.instantiate()

	label.text = text
	label.modulate = color
	
	var adjusted_position = position + Vector2(0, 1000)
	label.global_position = adjusted_position
	
	add_child(label)

	var anim_player: AnimationPlayer = label.get_node("AnimationPlayer")
	anim_player.play("notification_pop")

	anim_player.animation_finished.connect(
		func(_anim_name):
			label.queue_free()
	)

# ==============================================
#   CORRECTED INSERTION SORT VALIDATION
# ==============================================
func _on_block_dropped(dropped_block: Control) -> void:
	if is_sorting or sorting_complete:
		show_feedback(
			"Cannot drag blocks!!",
			Color.ORANGE,
			Vector2(dropped_block.global_position.x, START_POSITION.y - 20)
		)
		_resnap_blocks()
		return
	
	# Safety check - ensure the block is in block_nodes
	var old_index: int = block_nodes.find(dropped_block)
	if old_index == -1:
		print("Error: Dropped block not found in block_nodes")
		return
	
	var center_x: float = dropped_block.position.x + dropped_block.size.x * 0.5
	var insert_index: int = 0
	
	_save_state()
	redo_stack.clear()
	
	# Find where block was dropped
	for i in range(block_nodes.size()):
		var c = block_nodes[i]
		if c == null or c == dropped_block:
			continue
		var c_center: float = c.position.x + c.size.x * 0.5
		if center_x > c_center:
			insert_index += 1
	
	if old_index == insert_index:
		_resnap_blocks()
		return
	
	# Validate the move for Insertion Sort
	var validation = _validate_insertion_move(old_index, insert_index)
	var is_valid = validation.valid
	var message = validation.message
	
	# Store the value being moved
	var moving_value = main_array[old_index]
	
	# Perform the insertion (shifting elements)
	if old_index < insert_index:
		# Moving right - should be invalid in proper insertion sort
		# But we'll still allow it physically for learning purposes
		for i in range(old_index, insert_index):
			main_array[i] = main_array[i + 1]
		main_array[insert_index] = moving_value
		
		# Update blocks
		var moving_block = block_nodes[old_index]
		block_nodes.remove_at(old_index)
		block_nodes.insert(insert_index, moving_block)
	else:
		# Moving left (THIS IS INSERTION SORT)
		# Shift elements to the right to make space
		for i in range(old_index, insert_index, -1):
			main_array[i] = main_array[i - 1]
		main_array[insert_index] = moving_value
		
		# Update blocks
		var moving_block = block_nodes[old_index]
		block_nodes.remove_at(old_index)
		block_nodes.insert(insert_index, moving_block)
	
	# Record the move
	var move_data = {
		"old_index": old_index,
		"new_index": insert_index,
		"was_valid": is_valid,
		"value": moving_value
	}
	move_history.append(move_data)
	move_redo_stack.clear()
	
	if is_valid:
		correct_moves += 1
		timeline_log.append(
			"[color=green]Good move: %d moved from %d to %d[/color]" 
			% [moving_value, old_index, insert_index]
		)
		
		show_feedback(
			message,
			Color.GREEN,
			Vector2(dropped_block.global_position.x, START_POSITION.y - 20)
		)
	else:
		mistake_counter += 1
		timeline_log.append(
			"[color=red]Bad move: %s[/color]" % message
		)
		
		show_feedback(
			message,
			Color.RED,
			Vector2(dropped_block.global_position.x, START_POSITION.y - 20)
		)
	
	# ALWAYS update the visual state based on the current array
	_update_current_target()
	
	_update_timeline_display()
	_resnap_blocks()
	_update_ui_labels()
	_update_undo_redo_buttons()
	
	# Check if array is fully sorted
	if _check_if_sorted():
		_end_assessment("sorted")

func _update_current_target():
	# Safety check - ensure block_nodes is valid and not empty
	if block_nodes.is_empty():
		print("Warning: block_nodes is empty in _update_current_target")
		return
	
	# Kill any existing tween animation
	if current_target_tween:
		current_target_tween.kill()
		current_target_tween = null
	
	# Get the current target element (leftmost element that has a greater element to its left)
	var target = _get_current_target_index()
	
	# Reset all highlights and scales first
	for i in range(block_nodes.size()):
		# Safety check - ensure the block exists
		if block_nodes[i] == null:
			continue
			
		if block_nodes[i].has_method("set_highlight"):
			block_nodes[i].set_highlight(false)
		
		# Reset scale for all blocks
		block_nodes[i].scale = Vector2(1.0, 1.0)
	
	# If array is fully sorted, no target to highlight
	if target >= main_array.size():
		# But still update sorted visuals for all elements
		for i in range(block_nodes.size()):
			if block_nodes[i] == null:
				continue
			if block_nodes[i].has_method("set_sorted_visual"):
				# Check if all elements up to i are sorted
				var is_sorted_up_to_i = true
				for j in range(i):
					if j + 1 >= main_array.size():
						break
					if main_array[j] > main_array[j + 1]:
						is_sorted_up_to_i = false
						break
				
				if is_sorted_up_to_i:
					block_nodes[i].set_sorted_visual(true)
				else:
					block_nodes[i].set_sorted_visual(false)
		return
	
	# Highlight and animate the target element
	if target < block_nodes.size() and block_nodes[target] != null:
		if block_nodes[target].has_method("set_highlight"):
			block_nodes[target].set_highlight(true)
			
			# Create a new pulsing animation for the current target
			current_target_tween = create_tween().set_loops()
			current_target_tween.tween_property(block_nodes[target], "scale", Vector2(1.15, 1.15), 0.6)
			current_target_tween.tween_property(block_nodes[target], "scale", Vector2(1.0, 1.0), 0.6)
	
	# Update sorted visuals for elements that are in correct position
	for i in range(block_nodes.size()):
		if block_nodes[i] == null:
			continue
			
		if block_nodes[i].has_method("set_sorted_visual"):
			# Check if all elements up to i are sorted
			var is_sorted_up_to_i = true
			for j in range(i):
				if j + 1 >= main_array.size():
					break
				if main_array[j] > main_array[j + 1]:
					is_sorted_up_to_i = false
					break
			
			# An element is in correct position if:
			# 1. All elements before it are sorted (is_sorted_up_to_i is true)
			# 2. AND it's less than or equal to the next element (or it's the last element)
			var is_correct_position = is_sorted_up_to_i
			if i < main_array.size() - 1:
				is_correct_position = is_correct_position and main_array[i] <= main_array[i + 1]
			
			if is_correct_position:
				block_nodes[i].set_sorted_visual(true)
			else:
				block_nodes[i].set_sorted_visual(false)
				
func _check_element_sorted():
	# Check each element's position
	for i in range(main_array.size()):
		var is_correct = true
		
		# Check if all elements before i are smaller
		for j in range(i):
			if main_array[j] > main_array[j + 1]:
				is_correct = false
				break
		
		# Update visual
		if block_nodes[i].has_method("set_sorted_visual"):
			if is_correct and i <= current_index:
				block_nodes[i].set_sorted_visual(true)
			else:
				block_nodes[i].set_sorted_visual(false)
	
	# Update current_index to first unsorted element
	for i in range(1, main_array.size()):
		if main_array[i] < main_array[i - 1]:
			current_index = i
			_highlight_current_element()
			return
	
	# If we get here, array is sorted
	current_index = main_array.size()
			
func _validate_insertion_move(old_index: int, new_index: int) -> Dictionary:
	# Safety checks
	if old_index < 0 or old_index >= main_array.size() or new_index < 0 or new_index >= main_array.size():
		return {
			"valid": false,
			"message": "Invalid indices"
		}
	
	# RULE 1: Must be adjacent swap (|old_index - new_index| == 1)
	if abs(old_index - new_index) != 1:
		return {
			"valid": false,
			"message": "Can only swap adjacent elements"
		}
	
	# Get the current target element (the one that should be moved)
	var target_index = _get_current_target_index()
	
	# If array is sorted, no moves should be valid
	if target_index >= main_array.size():
		return {
			"valid": false,
			"message": "Array is already sorted"
		}
	
	# RULE 2: The element being moved must be the current target
	if old_index != target_index:
		return {
			"valid": false,
			"message": "Not the element that needs to be moved"
		}
	
	# Get the values being swapped
	var left_val = main_array[old_index]
	var right_val = main_array[new_index]
	
	# Determine direction
	if new_index < old_index:  # Moving left
		# RULE 3: When moving left, the right element must be less than left element
		if left_val >= right_val:
			return {
				"valid": false,
				"message": "Cannot move larger element left"
			}
		
		return {
			"valid": true,
			"message": "Good move! Element moving left"
		}
	
	else:  # Moving right (new_index > old_index)
		# In proper insertion sort, we never move elements right
		return {
			"valid": false,
			"message": "Cannot move element right in insertion sort"
		}

func _is_valid_insertion_move(old_index: int, new_index: int) -> bool:
	# In insertion sort:
	# 1. The element being moved must come from the unsorted portion (index >= current_index)
	# 2. It must be inserted into the sorted portion (index < current_index)
	# 3. After insertion, the sorted portion should remain sorted
	
	# Check if source is from unsorted region
	if old_index < current_index:
		return false
	
	# Check if destination is in sorted region
	if new_index >= current_index:
		return false
	
	# Check if the sorted portion would remain sorted after insertion
	# The value being inserted should be greater than or equal to the element before
	# and less than or equal to the element after (if they exist)
	var value = main_array[new_index]  # Value after move (it's already updated)
	
	# Check left neighbor (if exists)
	if new_index > 0:
		if value < main_array[new_index - 1]:
			return false
	
	# Check right neighbor (if exists and within sorted portion)
	if new_index + 1 < current_index:
		if value > main_array[new_index + 1]:
			return false
	
	return true
	
func _get_current_target_index() -> int:
	# Safety check
	if main_array.is_empty():
		return 0
	
	# Find the leftmost element that has a greater element to its left
	# This is the element that should be moved next in insertion sort
	for i in range(1, main_array.size()):
		if main_array[i] < main_array[i - 1]:
			return i
	
	# If no such element exists, array is sorted
	return main_array.size()
	
func _resnap_blocks() -> void:
	var x = START_POSITION.x
	for i in range(block_nodes.size()):
		var child = block_nodes[i]
		var target_pos = Vector2(x, START_POSITION.y)
		create_tween().tween_property(child, "position", target_pos, 0.2)
		x += child.size.x + BLOCK_SPACING

func _save_state() -> void:
	var state := {
		"array": main_array.duplicate(),
		"current_index": current_index,
		"mistakes": mistake_counter,
		"comparisons": comparison_counter,
		"insertions": insertion_counter
	}
	undo_stack.append(state)

# ==============================================
#   AUTO SORT (for testing/lecture mode)
# ==============================================

func _on_auto_pressed() -> void:
	if sorting_complete: return
	btn_sound.play()
	is_auto_playing = !is_auto_playing
	auto_btn.text = "Pause" if is_auto_playing else "Auto Sort"
	sort_btn.disabled = is_auto_playing
	
	if is_auto_playing: _run_auto_sort()

func _run_auto_sort() -> void:
	while is_auto_playing and not sorting_complete:
		if is_sorting: 
			await get_tree().process_frame
		else:
			await _perform_insertion_step()
			await get_tree().create_timer(ANIM_SPEED).timeout

# Update the auto sort to match the correct algorithm
func _perform_insertion_step():
	is_sorting = true
	
	if current_index >= main_array.size():
		_finish_simulation()
		is_sorting = false
		return
	
	# Get current element to insert
	var key = main_array[current_index]
	var j = current_index - 1
	
	if status_label:
		status_label.text = "Inserting %d into sorted portion" % key
	
	# Show which element we're working with
	_highlight_current_element()
	
	# Animate the shifting process
	var shifted_positions = []
	var original_positions = []
	
	# Store original positions for animation
	for idx in range(block_nodes.size()):
		original_positions.append(block_nodes[idx].position)
	
	# Find correct position and shift
	var insert_at = j + 1
	while j >= 0 and main_array[j] > key:
		# Shift right
		main_array[j + 1] = main_array[j]
		shifted_positions.append(j)
		j -= 1
		comparison_counter += 1
	
	insert_at = j + 1
	
	# If we actually moved something
	if insert_at != current_index:
		# Insert the key
		main_array[insert_at] = key
		
		# Animate the shifts and insertion
		await _animate_insertion_process(insert_at, current_index, shifted_positions)
		insertion_counter += 1
		
		timeline_log.append("Inserted %d at position %d" % [key, insert_at])
	else:
		# Element was already in correct position
		timeline_log.append("Element %d already in correct position" % key)
		await get_tree().create_timer(ANIM_SPEED * 0.5).timeout
	
	current_index += 1
	_highlight_current_element()
	
	_update_ui_labels()
	is_sorting = false
func _animate_insertion_process(insert_idx: int, source_idx: int, shifted_indices: Array):
	if block_nodes.is_empty():
		return
	
	# First, animate the shifts
	for idx in shifted_indices:
		if idx + 1 < block_nodes.size():
			var node = block_nodes[idx]
			var target_pos = block_nodes[idx + 1].position
			
			var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(node, "position", target_pos, ANIM_SPEED * 0.3)
			await tween.finished
	
	# Then, move the key element to its new position
	if insert_idx < block_nodes.size() and source_idx < block_nodes.size():
		var key_node = block_nodes[source_idx]
		var target_pos = block_nodes[insert_idx].position
		
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(key_node, "position", target_pos, ANIM_SPEED * 0.5)
		await tween.finished
	
	# Rebuild the visual order to match the array
	_rebuild_blocks_from_array()
	
func _animate_shift(from_idx: int, to_idx: int):
	if from_idx < 0 or from_idx >= block_nodes.size() or to_idx < 0 or to_idx >= block_nodes.size():
		return
	
	var node = block_nodes[from_idx]
	var target_pos = block_nodes[to_idx].position
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(node, "position", target_pos, ANIM_SPEED * 0.5)
	await tween.finished
	
	# Update array of nodes
	var temp = block_nodes[from_idx]
	block_nodes[from_idx] = block_nodes[to_idx]
	block_nodes[to_idx] = temp

func _animate_insertion(insert_idx: int, source_idx: int, value: int):
	if insert_idx < 0 or insert_idx >= block_nodes.size() or source_idx < 0 or source_idx >= block_nodes.size():
		return
	
	# Create a new block for the inserted element
	var new_block = BLOCK_SCENE.instantiate()
	new_block.value = value
	new_block.position = block_nodes[source_idx].position
	new_block.draggable = true
	new_block.connect("block_dropped", _on_block_dropped)
	
	# Remove the old block
	var old_block = block_nodes[source_idx]
	block_nodes.remove_at(source_idx)
	old_block.queue_free()
	
	# Insert new block
	block_nodes.insert(insert_idx, new_block)
	array_container.add_child(new_block)
	
	_resnap_blocks()
	await get_tree().create_timer(ANIM_SPEED).timeout

func _update_pointers(left_idx: int, right_idx: int):
	if block_nodes.is_empty(): return
	if ptr_left: ptr_left.show()
	if ptr_right: ptr_right.show()
	
	if left_idx >= 0 and left_idx < block_nodes.size():
		var node = block_nodes[left_idx]
		if ptr_left:
			ptr_left.global_position = node.global_position + Vector2(16, node.size.y + 10)
	
	if right_idx >= 0 and right_idx < block_nodes.size():
		var node_next = block_nodes[right_idx]
		if ptr_right:
			ptr_right.global_position = node_next.global_position + Vector2(16, node_next.size.y + 10)

# Also update _finish_simulation to kill the tween when sorting is complete
func _finish_simulation():
	sorting_complete = true
	is_auto_playing = false
	
	# Kill the target animation
	if current_target_tween:
		current_target_tween.kill()
		current_target_tween = null
	
	# Add null checks for all UI elements
	if status_label:
		status_label.text = "Sorted!"
	if auto_btn:
		auto_btn.text = "Auto Sort"
		auto_btn.disabled = true
	if sort_btn:
		sort_btn.disabled = true
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	
	timeline_log.append("--- SORTING COMPLETE ---")
	_show_complete_popup()
	
	if cpp_code_button:
		cpp_code_button.show()
		if code_anim: code_anim.play("default")
	_update_undo_redo_buttons()

func _update_ui_labels():
	if sim_mode == SimMode.ASSESSMENT:
		compare_label.text = "Correct Insertions: %d " % [correct_moves]
	else:
		compare_label.text = "Comparisons: %d | Insertions: %d" % [comparison_counter, insertion_counter]

func _show_complete_popup() -> void:
	# This is for lecture mode only
	if sim_mode != SimMode.ASSESSMENT and complete_popup:
		var txt = "Sorting Finished!\n\nTotal Comparisons: %d\nTotal Insertions: %d" % [comparison_counter, insertion_counter]
		if process_label: process_label.text = txt
		complete_popup.popup_centered()

func _on_timeline_pressed() -> void:
	btn_sound.play()
	if timeline_popup.visible:
		timeline_popup.hide()
	else:
		var timeline_content = ""
		if timeline_log.is_empty():
			timeline_content = "[center]No moves yet[/center]"
		else:
			timeline_content = "\n".join(timeline_log)
		
		timeline_label.bbcode_enabled = true
		timeline_label.text = timeline_content
		
		var scroll_container = timeline_popup.find_child("ScrollContainer", true, false)
		if scroll_container:
			scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
			scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
			scroll_container.mouse_filter = Control.MOUSE_FILTER_STOP
		
		timeline_popup.popup_centered()
		
		await get_tree().process_frame
		
		if scroll_container:
			scroll_container.scroll_vertical = 0

func _on_timeline_close_pressed() -> void:
	btn_sound.play()
	if timeline_popup:
		timeline_popup.hide()

func _update_timeline_display() -> void:
	if not timeline_label:
		return
	
	timeline_label.bbcode_enabled = true
	timeline_label.bbcode_text = "[b]Timeline:[/b]\n" + "\n".join(timeline_log)

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	if complete_popup: complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

# ==============================================
#   CODE VISUALIZER & TUTORIAL LOGIC
# ==============================================

func _show_cpp_popup() -> void:
	var code = ""
	var arr_str = ", ".join(initial_array.map(func(x): return str(x)))
	
	# Select Code and Tutorial Data based on Language
	match current_code_language:
		"cpp":
			code = get_cpp_insertion_code(arr_str)
			current_tutorial_data = cpp_tutorial_data
		"python":
			code = get_python_insertion_code(arr_str)
			current_tutorial_data = python_tutorial_data
		"java":
			code = get_java_insertion_code(arr_str)
			current_tutorial_data = java_tutorial_data
		"c":
			code = get_c_insertion_code(arr_str)
			current_tutorial_data = c_tutorial_data
	
	cpp_text.text = code
	cpp_popup.popup_centered()
	
	# Reset tutorial step
	cpp_tutorial_step = 0
	
	# Connect Button if needed
	if cpp_next_btn:
		if not cpp_next_btn.is_connected("pressed", _on_cpp_next_pressed):
			cpp_next_btn.pressed.connect(_on_cpp_next_pressed)
	
	cpp_tutorial_panel.show()
	_update_cpp_tutorial()

func _on_cpp_next_pressed() -> void:
	btn_sound.play()
	cpp_tutorial_step += 1
	if cpp_tutorial_step >= current_tutorial_data.size():
		cpp_tutorial_step = 0
	_update_cpp_tutorial()

func _update_cpp_tutorial() -> void:
	if current_tutorial_data.is_empty(): 
		return
	
	var data = current_tutorial_data[cpp_tutorial_step]
	
	if cpp_explanation_lbl:
		cpp_explanation_lbl.text = data["text"]
	
	if cpp_text:
		var base_code = ""
		var arr_str = ", ".join(initial_array.map(func(x): return str(x)))
		
		match current_code_language:
			"cpp": base_code = get_cpp_insertion_code(arr_str)
			"python": base_code = get_python_insertion_code(arr_str)
			"java": base_code = get_java_insertion_code(arr_str)
			"c": base_code = get_c_insertion_code(arr_str)

		var lines = base_code.split("\n")
		
		for line_idx in data["lines"]:
			if line_idx >= 0 and line_idx < lines.size():
				lines[line_idx] = "[bgcolor=#444400]" + lines[line_idx] + "[/bgcolor]"
		
		cpp_text.bbcode_enabled = true
		cpp_text.text = "\n".join(lines)
		
		if data["lines"].size() > 0:
			var target_line = data["lines"][0]
			await get_tree().process_frame 
			cpp_text.scroll_to_line(target_line)

# --- CODE GENERATION FUNCTIONS (Insertion Sort) ---

func get_cpp_insertion_code(arr: String) -> String:
	return """/* Time Complexity: O(n^2)
   Space Complexity: O(1) */
#include <iostream>
using namespace std;

void insertionSort(int arr[], int n) {
	for (int i = 1; i < n; i++) {
		int key = arr[i];
		int j = i - 1;
		
		while (j >= 0 && arr[j] > key) {
			arr[j + 1] = arr[j];
			j--;
		}
		arr[j + 1] = key;
	}
}

void printArray(int arr[], int n) {
	cout << "[";
	for (int i = 0; i < n; i++) {
		cout << arr[i];
		if (i < n - 1) cout << ", ";
	}
	cout << "]" << endl;
}

int main() {
	int arr[] = { %s };
	int n = sizeof(arr) / sizeof(arr[0]);
	
	cout << "Initial array (unsorted): ";
	printArray(arr, n);
	
	insertionSort(arr, n);
	
	cout << "Sorted array: ";
	printArray(arr, n);
	
	return 0;
}""" % arr

func get_python_insertion_code(arr: String) -> String:
	return """# Time Complexity: O(n^2)
# Space Complexity: O(1)

def insertion_sort(arr):
	for i in range(1, len(arr)):
		key = arr[i]
		j = i - 1
		while j >= 0 and arr[j] > key:
			arr[j + 1] = arr[j]
			j -= 1
		arr[j + 1] = key

def print_array(arr):
	print("[", end="")
	for i in range(len(arr)):
		print(arr[i], end="")
		if i < len(arr) - 1:
			print(", ", end="")
	print("]")

arr = [%s]
print("Initial array (unsorted): ", end="")
print_array(arr)

insertion_sort(arr)

print("Sorted array: ", end="")
print_array(arr)""" % arr

func get_java_insertion_code(arr: String) -> String:
	return """public class Main {
	static void sort(int arr[]) {
		for (int i = 1; i < arr.length; i++) {
			int key = arr[i];
			int j = i - 1;
			while (j >= 0 && arr[j] > key) {
				arr[j + 1] = arr[j];
				j--;
			}
			arr[j + 1] = key;
		}
	}
	
	static void printArray(int arr[]) {
		System.out.print("[");
		for (int i = 0; i < arr.length; i++) {
			System.out.print(arr[i]);
			if (i < arr.length - 1) System.out.print(", ");
		}
		System.out.println("]");
	}
	
	public static void main(String args[]) {
		int arr[] = {%s};
		Main ob = new Main();
		
		System.out.print("Initial array (unsorted): ");
		ob.printArray(arr);
		
		ob.sort(arr);
		
		System.out.print("Sorted array: ");
		ob.printArray(arr);
	}
}""" % arr

func get_c_insertion_code(arr: String) -> String:
	return """/* Time Complexity: O(n^2) */
#include <stdio.h>

void insertionSort(int arr[], int n) {
	for (int i = 1; i < n; i++) {
		int key = arr[i];
		int j = i - 1;
		while (j >= 0 && arr[j] > key) {
			arr[j + 1] = arr[j];
			j--;
		}
		arr[j + 1] = key;
	}
}

void printArray(int arr[], int n) {
	printf("[");
	for (int i = 0; i < n; i++) {
		printf("%%d", arr[i]);
		if (i < n - 1) printf(", ");
	}
	printf("]\\n");
}

int main() {
	int arr[] = {%s};
	int n = sizeof(arr) / sizeof(arr[0]);
	
	printf("Initial array (unsorted): ");
	printArray(arr, n);
	
	insertionSort(arr, n);
	
	printf("Sorted array: ");
	printArray(arr, n);
	
	return 0;
}""" % arr

# ==============================================
#   COMPILER INTEGRATION
# ==============================================

# API Keys (copy these from your compiler.gd)
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

func _setup_compiler():
	"""Setup compiler button and popup"""
	if compile_btn:
		# Disconnect any existing connections to avoid duplicates
		if compile_btn.is_connected("pressed", _on_compile_button_pressed):
			compile_btn.disconnect("pressed", _on_compile_button_pressed)
		compile_btn.pressed.connect(_on_compile_button_pressed)
	
	# Load the compiler output popup
	if compiler_output_popup == null:
		var popup_scene = preload("res://scene/CompilerOutput.tscn")
		compiler_output_popup = popup_scene.instantiate()
		add_child(compiler_output_popup)
		
		# Connect signals
		compiler_output_popup.recompile_requested.connect(_on_recompile_requested)
		compiler_output_popup.closed.connect(_on_compiler_output_closed)

func _on_compile_button_pressed():
	"""Called when Compile button is pressed in the code popup"""
	btn_sound.play()
	
	# Get the current code based on selected language
	var code = ""
	var arr_str = ", ".join(initial_array.map(func(x): return str(x)))
	
	match current_code_language:
		"cpp":
			code = get_cpp_insertion_code(arr_str)
		"c":
			code = get_c_insertion_code(arr_str)
		"java":
			code = get_java_insertion_code(arr_str)
		"python":
			code = get_python_insertion_code(arr_str)
	
	# Check if we have cached result for this language
	if compiler_output_popup and compiler_output_popup.has_cached_result(current_code_language):
		# Show cached result without recompiling
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
		# Compile the code
		_compile_code(code)

func _compile_code(code: String):
	"""Send code to JDoodle API"""
	show_feedback("Compiling...", Color.YELLOW, Vector2(200, 200))
	
	# Get API keys for current language
	var keys = API_KEYS[current_code_language]
	
	# Prepare API request
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_compile_completed.bind(http_request, current_code_language))
	
	var url = "https://api.jdoodle.com/v1/execute"
	var headers = ["Content-Type: application/json"]
	
	# Map language to JDoodle API expected format
	var api_language = current_code_language
	match current_code_language:
		"python":
			api_language = "python3"  # JDoodle expects "python3" not "python"
	
	var body = JSON.new().stringify({
		"clientId": keys["clientId"],
		"clientSecret": keys["clientSecret"],
		"script": code,
		"language": api_language,
		"versionIndex": _get_version_index(current_code_language)
	})
	
	print("=== Simulation Compile Request ===")
	print("Language: ", current_code_language, " → API: ", api_language)
	print("Script preview: ", code.substr(0, 50) + "...")
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		show_feedback("Network error!", Color.RED, Vector2(200, 200))

func _get_version_index(lang: String) -> String:
	match lang:
		"cpp": return "5"     # C++17
		"c": return "4"       # C17
		"java": return "4"    # Java 17
		"python": return "4"  # Python 3
		_: return "0"

func _on_compile_completed(result, response_code, headers, body, http_request, language: String):
	"""Handle compilation response"""
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
	
	# Show the output popup (false = from simulation, so landscape sizing)
	if compiler_output_popup:
		compiler_output_popup.show_output(language, response, self, false)

func _on_recompile_requested(language: String):
	"""Handle recompile request from popup"""
	# Get the current code and recompile
	var arr_str = ", ".join(initial_array.map(func(x): return str(x)))
	var code = ""
	
	match language:
		"cpp":
			code = get_cpp_insertion_code(arr_str)
		"c":
			code = get_c_insertion_code(arr_str)
		"java":
			code = get_java_insertion_code(arr_str)
		"python":
			code = get_python_insertion_code(arr_str)
	
	_compile_code(code)

func _on_compiler_output_closed():
	"""Called when compiler output popup is closed"""
	print("Compiler output closed")

# Add reset_cache_for_scene function (to be called when generating new simulation)
func reset_cache_for_scene():
	"""Reset compiler cache when starting new simulation"""
	if compiler_output_popup:
		compiler_output_popup.reset_cache_for_scene()
		print("Compiler cache reset for new simulation")

# ==============================================
#   APP TUTORIAL
# ==============================================

func start_tutorial() -> void:
	print("=== STARTING TUTORIAL ===")
	if not tutorial_overlay or not tutorial_box or not tutorial_text or not tutorial_next:
		print("ERROR: Tutorial nodes are not properly set up!")
		return
	
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	
	_set_main_ui_enabled(false)
	
	tutorial_overlay.show()
	dim_bg.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{
			"node": sort_btn,
			"title": "UNDO",
			"text": "Allows the user to reverse one or more of their previous actions, returning the game state to a previous point",
			"action": "highlight"
		},
		{
			"node": auto_btn,
			"title": "REDO",
			"text": "Reverses the effect of an Undo command, allowing the user to reapply an action that was previously undone",
			"action": "highlight"
		},
		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View a scrollable history of swaps.",
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
	
	if step["action"] == "press":
		tutorial_next.hide()
		node.disabled = false
	else:
		tutorial_next.show()

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

# ==============================================
#   CONFIG & INTRO
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
	btn_sound.play()
	var arr: Array[int] = []
	for le in element_inputs:
		var val = 0
		if le.text.is_valid_int():
			val = int(le.text)
		else:
			val = randi_range(1, 99)
		arr.append(val)
	config_elements_modal.hide()
	_set_main_ui_enabled(true)
	help_btn.show()
	_initialize_with_elements(arr)

func _on_config_no_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	var count = randi_range(5, 7)
	var arr: Array[int] = []
	for i in count: arr.append(randi_range(1, 99))
	_set_main_ui_enabled(true)
	help_btn.show()
	_initialize_with_elements(arr)

func _on_size_back_pressed(): config_size_modal.hide(); config_modal.show()
func _on_elements_back_pressed(): config_elements_modal.hide(); config_size_modal.show()

func show_introduction():
	if not intro_popup: return
	intro_popup.show()
	_set_main_ui_enabled(false)
	timer_running = false
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
		timer_running = true

func _on_intro_prev_pressed():
	btn_sound.play()
	if intro_step > 0:
		intro_step -= 1
		_update_intro_text()

func _on_intro_skip_pressed():
	btn_sound.play()
	intro_popup.hide()
	_set_main_ui_enabled(true)
	timer_running = true

func _set_main_ui_enabled(enabled: bool) -> void:
	if sort_btn: sort_btn.disabled = not enabled
	if auto_btn: auto_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled

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
	reset_cache_for_scene()
	_show_config_modal()

func _on_no_pressed():
	sim_confirmation.hide()

func _on_help_button_pressed():
	btn_sound.play()
	start_tutorial()

# ==============================================
#   UNDO/REDO FUNCTIONS
# ==============================================

func _on_waiting_pressed() -> void:
	if not _can_redo():
		return
	
	if redo_stack.is_empty():
		return
	
	var state = redo_stack.pop_back()
	
	undo_stack.append({
		"array": main_array.duplicate(),
		"current_index": current_index,
		"mistakes": mistake_counter,
		"comparisons": comparison_counter,
		"insertions": insertion_counter
	})
	
	_restore_state(state)

	if move_redo_stack.is_empty():
		return
	
	var move = move_redo_stack.pop_back()
	move_history.append(move)

	if move["was_valid"]:
		correct_moves += 1
	else:
		mistake_counter += 1

	timeline_log.append(
		"[color=gray]Redo: move from %d to %d[/color]" 
		% [move["old_index"], move["new_index"]]
	)

	_update_timeline_display()
	_update_undo_redo_buttons()
	_update_ui_labels()
	_highlight_current_element()

func _restore_state(state: Dictionary) -> void:
	main_array = state["array"].duplicate()
	current_index = state["current_index"]
	mistake_counter = state["mistakes"]
	comparison_counter = state["comparisons"]
	insertion_counter = state.get("insertions", 0)
	
	_rebuild_blocks_from_array()

func _rebuild_blocks_from_array() -> void:
	for child in array_container.get_children():
		child.queue_free()
	
	block_nodes.clear()
	
	var current_x: float = START_POSITION.x
	
	for val in main_array:
		var new_block = BLOCK_SCENE.instantiate()
		new_block.value = val
		new_block.position = Vector2(current_x, START_POSITION.y)
		
		new_block.draggable = true
		if not new_block.is_connected("block_dropped", _on_block_dropped):
			new_block.connect("block_dropped", _on_block_dropped)
		
		array_container.add_child(new_block)
		block_nodes.append(new_block)
		
		current_x += new_block.size.x + BLOCK_SPACING

func _on_sort_button_pressed() -> void:
	if not _can_undo():
		return
	
	if undo_stack.is_empty():
		return
	
	var state = undo_stack.pop_back()
	
	redo_stack.append({
		"array": main_array.duplicate(),
		"current_index": current_index,
		"mistakes": mistake_counter,
		"comparisons": comparison_counter,
		"insertions": insertion_counter
	})
	
	_restore_state(state)

	if move_history.is_empty():
		return
	
	var last_move = move_history.pop_back()
	move_redo_stack.append(last_move)

	if last_move["was_valid"]:
		correct_moves -= 1
	else:
		mistake_counter -= 1

	timeline_log.append(
		"[color=gray]Undo: move from %d to %d[/color]" 
		% [last_move["old_index"], last_move["new_index"]]
	)

	_update_timeline_display()
	_update_undo_redo_buttons()
	_update_ui_labels()
	_highlight_current_element()

func _on_try_again_button_pressed() -> void:
	btn_sound.play()
	time_up_popup.hide()
	result_popup.hide()  # Also hide result popup if it's showing
	_start_assessment_mode()
	await get_tree().process_frame
	_update_undo_redo_buttons()

func _on_back_button_pressed() -> void:
	time_up_popup.hide()

func _update_difficulty_label():
	if not difficulty_label:
		return
	match difficulty:
		1:
			difficulty_label.text = "Difficulty: Easy"
		2:
			difficulty_label.text = "Difficulty: Medium"
		3:
			difficulty_label.text = "Difficulty: Hard"

func _can_undo() -> bool:
	if sorting_complete or not timer_running:
		return false
	
	if difficulty == 3:  # Hard mode
		return false
	
	return true

func _can_redo() -> bool:
	if sorting_complete or not timer_running:
		return false
	
	if difficulty == 3:  # Hard mode
		return false
	
	return true

func _update_undo_redo_buttons():
	if not sort_btn or not auto_btn:
		return
	
	var undo_allowed = _can_undo()
	var redo_allowed = _can_redo()
	
	sort_btn.disabled = not undo_allowed
	auto_btn.disabled = not redo_allowed
	
	if undo_allowed:
		if undo_stack.is_empty():
			sort_btn.modulate = Color(0.7, 0.7, 0.7, 1)
		else:
			sort_btn.modulate = Color(1, 1, 1, 1)
	else:
		sort_btn.modulate = Color(0.5, 0.5, 0.5, 0.5)
		
	if redo_allowed:
		if redo_stack.is_empty():
			auto_btn.modulate = Color(0.7, 0.7, 0.7, 1)
		else:
			auto_btn.modulate = Color(1, 1, 1, 1)
	else:
		auto_btn.modulate = Color(0.5, 0.5, 0.5, 0.5)

# ==============================================
#   ASSESSMENT & GRADING
# ==============================================

func _check_if_sorted() -> bool:
	for i in range(main_array.size() - 1):
		if main_array[i] > main_array[i + 1]:
			return false
	return true

func _get_required_threshold() -> float:
	match difficulty:
		1: return 0.6  # Easy: 60%
		2: return 0.75 # Medium: 75%
		3: return 0.8  # Hard: 80%
	return 0.7

func _compute_grade() -> Dictionary:
	var total_moves = correct_moves + mistake_counter
	var accuracy = float(correct_moves) / max(total_moves, 1) * 100
	var required_threshold = _get_required_threshold() * 100
	var passed = accuracy >= required_threshold
	
	var time_used = assessment_time_limit - time_remaining
	
	var coins = 0
	match difficulty:
		1:
			coins = 5 if not has_completed_assessment else 1
		2:
			coins = 10 if not has_completed_assessment else 3
		3:
			coins = 20 if not has_completed_assessment else 5
	
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

# Also update _end_assessment to kill the tween
func _end_assessment(reason: String) -> void:
	if has_completed_assessment:
		return
	
	has_completed_assessment = true
	completion_type = reason
	
	# Kill the target animation
	if current_target_tween:
		current_target_tween.kill()
		current_target_tween = null
	
	timer_running = false
	tiktak_sound.stop()
	is_sorting = true
	is_auto_playing = false
	
	if sort_btn:
		sort_btn.disabled = true
	if auto_btn:
		auto_btn.disabled = true
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	
	# Use ResultPopup for assessment mode, not SimulationCompletePopup
	if reason == "sorted":
		var grade = _compute_grade()
		var result = "PASS" if grade["passed"] else "FAIL"
		_show_result_popup(result, grade)
	else: # timeout
		_show_result_popup("FAIL")


func _show_result_popup(result: String, grade_data: Dictionary = {}) -> void:
	if not result_popup:
		return
	
	# Hide the simulation complete popup if it's showing
	if complete_popup and complete_popup.visible:
		complete_popup.hide()
	
	if result == "PASS":
		result_title.text = "PASSED!"
		result_title.modulate = Color(0, 1, 0)  # Green
		if translate_code_btn:
			translate_code_btn.show()
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")
		# Hide TryAgainButton on pass
		try_again_button.visible = false
	else:
		result_title.text = "FAILED!"
		result_title.modulate = Color(1, 0, 0)  # Red
		# Show TryAgainButton on fail
		try_again_button.visible = true
	
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
	
	result_popup.popup_centered()
	
	if grade_data.get("coins", 0) > 0 and coins_anim:
		coins_anim.play("default")


func _on_try_again_result_pressed():
	btn_sound.play()
	result_popup.hide()
	_start_assessment_mode()

func _on_back_result_pressed():
	btn_sound.play()
	result_popup.hide()

func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()
