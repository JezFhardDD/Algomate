extends Control
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = $CppPopup/VBoxContainer/HBoxContainer2/CompileButton
# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton
@onready var auto_btn: Button = $VBoxContainer/WaitingElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var match_btn: Button = $VBoxContainer/MatchButton

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var compare_label: Label = $MarginContainer/HBoxContainer2/TextureRect/Label
@onready var array_container: Control = $QueueContainer
@onready var dequeued_container: Control = $DequeuedContainer
@onready var target_label: Label = $TargetLabel

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

# --- POINTERS (Not used in Linear Search but kept for compatibility) ---
@onready var ptr_left: Node = $TextureRect/front
@onready var ptr_right: Node = $TextureRect/rear
@onready var unused_ptr1: Node = $TextureRect/front2
@onready var unused_ptr2: Node = $TextureRect/rear2

# --- VISUAL HIGHLIGHT ---
@onready var current_highlight: ColorRect = $CurrentHighlight

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

# RESULT POPUP RESOURCES
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

# --- LINEAR SEARCH VARIABLES ---
var main_array: Array[int] = []
var initial_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []

var target_value: int = 0
var current_selected_index: int = -1  # Currently tapped block (-1 means none)
var revealed_indices: Array[bool] = []  # Track which blocks are revealed
var target_found: bool = false
var target_found_index: int = -1

# Move history tracking
var reveal_history: Array[Dictionary] = []  # Track reveals
var match_history: Array[Dictionary] = []  # Track match attempts

var mistake_counter: int = 0
var correct_moves: int = 0

var BLOCK_WIDTH: float = 64.0
var BLOCK_SPACING: float = 15.0
var START_POSITION: Vector2 = Vector2(50, 80)

# Add tween tracking for cleanup
var current_tween: Tween = null

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false
var intro_step: int = 0
# Intro Text - Updated for Linear Search
var intro_texts = [
	"""WELCOME TO LINEAR SEARCH SIMULATION! 🔍
Linear Search is the simplest searching algorithm:
It checks each element ONE BY ONE from left to right. It stops when it finds the target element. Time Complexity: O(n) - checks up to 'n' elements
Your task: Find the target number by tapping blocks in order!""",

	"""HOW TO PLAY: 🎮

1. TAP blocks from LEFT to RIGHT to reveal numbers
2. When you find a number you think is the target, tap the MATCH button
3. If correct - you win! If wrong - mistake counted

""","""EXAMPLE:
Array: [1, 2, 3, 4, 5]  Target: 3
✓ Tap 1 → reveals 1
✓ Tap 2 → reveals 2  
✓ Tap 3 → reveals 3
✓ Tap MATCH → CORRECT! Target found!""",

	"""RULES & SCORING: 📊

✓ GOOD MOVE: Tapping blocks in correct left-to-right order
✗ BAD MOVE: Tapping blocks out of order
✓ GOOD MOVE: Correctly matching the target
✗ BAD MOVE: Matching the wrong number

""","""Special Rules:
• Already revealed blocks can be re-tapped (no penalty)
• Current selected block has YELLOW highlight
• Target is shown in GOLD at the top
• Found target turns GOLDEN""",

	"""DIFFICULTY LEVELS: ⏱️

EASY:
	
• No time limit
• 4 elements to search
• Perfect for learning

""","""MEDIUM:
	
• 90 second time limit
• 5 elements to search
• Tests your speed

""","""HARD:
	
• 60 second time limit! 
• 7 elements to search
• True test of linear search mastery

Press MATCH only when you're sure you've found the target!"""
]

# --- CODE TUTORIAL DATA (Updated for Linear Search) ---
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

# 1. C++ DATA (Linear Search)
var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Function Definition:\nLinear search takes array, size, and target." },
	{ "lines": [2, 3], "text": "2. For Loop:\nIterates through each element from left to right." },
	{ "lines": [4, 5], "text": "3. Comparison:\nChecks if current element equals target." },
	{ "lines": [6], "text": "4. Found:\nReturns index if element matches target." },
	{ "lines": [7, 8], "text": "5. Not Found:\nReturns -1 after checking all elements." }
]

# 2. PYTHON DATA (Linear Search)
var python_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Function Definition:\nTakes array and target as parameters." },
	{ "lines": [2], "text": "2. For Loop with enumerate:\nGets both index and value." },
	{ "lines": [3, 4], "text": "3. Comparison:\nIf element matches target, return index." },
	{ "lines": [5], "text": "4. Not Found:\nReturn -1 after loop ends." }
]

# 3. JAVA DATA (Linear Search)
var java_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Method Signature:\nStatic method returning integer index." },
	{ "lines": [2, 3], "text": "2. For Loop:\nIterate through array length." },
	{ "lines": [4, 5], "text": "3. Check:\nCompare array element with target." },
	{ "lines": [6], "text": "4. Return:\nReturn index if found." },
	{ "lines": [7, 8], "text": "5. Not Found:\nReturn -1 after loop." }
]

# 4. C DATA (Linear Search)
var c_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Function:\nReturns index or -1 if not found." },
	{ "lines": [2], "text": "2. For Loop:\nIterate through array." },
	{ "lines": [3, 4], "text": "3. If Condition:\nCheck if current element equals target." },
	{ "lines": [5], "text": "4. Return:\nReturn current index if found." },
	{ "lines": [6, 7], "text": "5. Not Found:\nReturn -1 after loop." }
]

enum SimMode { LECTURE, ASSESSMENT }
var sim_mode: SimMode = SimMode.ASSESSMENT
var difficulty := 2

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

func _get_array_size() -> int:
	match difficulty:
		1: return 4
		2: return 5
		3: return 7
	return 5

func _get_time_limit() -> float:
	match difficulty:
		1: return 100000.0 # Easy (no timer)
		2: return 90.0     # Medium (90 seconds)
		3: return 60.0     # Hard (60 seconds)
	return 90.0

func _ready() -> void:
	tiktak_sound = AudioStreamPlayer.new()
	tiktak_sound.stream = TIKTAK_SFX
	add_child(tiktak_sound)
	try_again_button.visible = false
	
	print("Program started — initializing Linear Search visualizer...")
	randomize()
	
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
	
	# Setup match button
	if match_btn:
		match_btn.text = "MATCH"
		match_btn.pressed.connect(_on_match_pressed)
	
	# Setup current highlight
	if current_highlight:
		current_highlight.hide()
		current_highlight.color = Color(1, 1, 0, 0.3)  # Semi-transparent yellow
	
	# Hide all modals initially
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	# Hide pointers (not used in Linear Search)
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if unused_ptr1: unused_ptr1.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	if cpp_code_button: cpp_code_button.hide()
	
	if sort_btn: sort_btn.text = "UNDO"
	if auto_btn: auto_btn.text = "REDO"
	
	_start_assessment_mode()
	call_deferred("show_introduction")
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")
	
	_connect_language_buttons()
	
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
	
	if try_again_result_btn:
		try_again_result_btn.pressed.connect(_on_try_again_result_pressed)
	if back_result_btn:
		back_result_btn.pressed.connect(_on_back_result_pressed)
	if translate_code_btn:
		translate_code_btn.pressed.connect(_on_translate_code_pressed)
	
	_update_difficulty_label()
	_setup_timeline_popup_for_mobile()
	_setup_compiler()

func _setup_timeline_popup_for_mobile():
	if not timeline_popup:
		return
	
	var scroll_container = timeline_popup.find_child("ScrollContainer", true, false)
	if scroll_container:
		scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
		scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		scroll_container.mouse_filter = Control.MOUSE_FILTER_STOP

func _start_assessment_mode():
	try_again_button.visible = false
	has_completed_assessment = false
	# Show and enable match button
	if match_btn:
		match_btn.show()
		match_btn.disabled = false
		match_btn.modulate = Color(1, 1, 1, 1)  # Full brightness
	
	# Kill any existing animations
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	clock.visible = false
	clock.modulate = Color(1, 1, 1, 1)
	clock.stop()

	# Reset all tracking variables
	mistake_counter = 0
	correct_moves = 0
	target_found = false
	target_found_index = -1
	current_selected_index = -1
	revealed_indices.clear()
	reveal_history.clear()
	match_history.clear()
	
	if current_highlight:
		current_highlight.hide()
	
	undo_stack.clear()
	redo_stack.clear()
	move_history.clear()
	move_redo_stack.clear()
	timeline_log.clear()
	
	_update_timeline_display()
	
	sim_mode = SimMode.ASSESSMENT
	assessment_time_limit = _get_time_limit()
	time_remaining = assessment_time_limit
	timer_running = true
	_update_difficulty_label()
	
	if difficulty == 1:
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
	
	var size: int = _get_array_size()
	var arr: Array[int] = []
	
	# Generate random array
	for i in range(size):
		arr.append(randi_range(1, 99))
	
	# Select random target from array
	target_value = arr[randi() % arr.size()]
	
	_initialize_with_elements(arr)
	
	# Show target in target label
	if target_label:
		target_label.text = "FIND: %d" % target_value
		target_label.add_theme_color_override("font_color", Color(1, 0.8, 0, 1))  # Gold color
		target_label.add_theme_font_size_override("font_size", 70)
	
	if status_label:
		status_label.text = "Tap blocks in order from left to right to reveal numbers"
	for block in block_nodes:
		if block.has_meta("pulse_tween"):
			var tween = block.get_meta("pulse_tween")
			if tween and tween.is_running():
				tween.kill()
		block.scale = Vector2(1.0, 1.0)
	_update_undo_redo_buttons()

func _process(delta: float) -> void:
	if sim_mode != SimMode.ASSESSMENT:
		return
	
	if not timer_running:
		return
	
	if target_found:
		timer_running = false
		return
	
	time_remaining -= delta
	
	if time_remaining <= 0:
		time_remaining = 0
		timer_running = false
		tiktak_sound.stop()
		_on_time_up()
	
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

func _initialize_with_elements(elements: Array[int]) -> void:
	print("Initializing Array with:", elements, " Target:", target_value)
	audio_player.play()
	
	main_array = elements.duplicate()
	initial_array = elements.duplicate()
	block_nodes.clear()
	timeline_log.clear()
	
	# Initialize revealed array (all false initially)
	revealed_indices.resize(main_array.size())
	for i in range(revealed_indices.size()):
		revealed_indices[i] = false
	
	# Kill any existing animations
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	for child in array_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	var current_x = START_POSITION.x
	for i in range(main_array.size()):
		var val = main_array[i]
		var new_block = BLOCK_SCENE.instantiate()
		new_block.value = val
		new_block.position = Vector2(current_x, START_POSITION.y)
		
		# Blocks are NOT draggable in Linear Search
		new_block.draggable = false
		
		# Connect block pressed signal
		if not new_block.is_connected("block_pressed", _on_block_pressed):
			new_block.connect("block_pressed", _on_block_pressed)
		
		# Initially hide the number
		new_block.hide_number(true)
		
		new_block.modulate.a = 0.0
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(new_block, "modulate:a", 1.0, 0.5)
		
		array_container.add_child(new_block)
		block_nodes.append(new_block)
		current_x += new_block.size.x + BLOCK_SPACING
	
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

func _safe_connect(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

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
#   LINEAR SEARCH CORE LOGIC
# ==============================================

func _on_block_pressed(block: Control) -> void:
	if target_found:
		show_feedback(
			"Target already found!",
			Color.ORANGE,
			Vector2(block.global_position.x, START_POSITION.y - 20)
		)
		return
	
	var index: int = block_nodes.find(block)
	if index == -1:
		return
	
	# Save state for undo
	_save_state()
	redo_stack.clear()
	
	# Check if block was already revealed
	var was_revealed = revealed_indices[index]
	
	# Determine if this is the correct next index
	var next_expected_index = _get_next_unrevealed_index()
	var is_correct_order = (index == next_expected_index)
	
	# Reveal the block (always reveal, but track correctness)
	if not was_revealed:
		_reveal_block(index)
	
	# Update current selection with visual feedback
	_update_current_selection(index)
	
	# Track in history
	var reveal_data = {
		"type": "reveal",
		"index": index,
		"value": main_array[index],
		"was_correct_order": is_correct_order,
		"was_revealed": was_revealed
	}
	reveal_history.append(reveal_data)
	move_history.append(reveal_data)
	
	if was_revealed:
		# Re-tapping a revealed block is allowed but doesn't count as a move
		show_feedback(
			"Block already revealed",
			Color.YELLOW,
			Vector2(block.global_position.x, START_POSITION.y - 20)
		)
		timeline_log.append(
			"[color=yellow]Re-tapped already revealed index[%d]: %d[/color]" % [index, main_array[index]]
		)
	elif is_correct_order:
		correct_moves += 1
		show_feedback(
			"Good! Tapped in correct order",
			Color.GREEN,
			Vector2(block.global_position.x, START_POSITION.y - 20)
		)
		timeline_log.append(
			"[color=green]Good: Revealed index[%d]: %d in correct order[/color]" % [index, main_array[index]]
		)
	else:
		mistake_counter += 1
		show_feedback(
			"Wrong order! Should tap index %d first" % next_expected_index,
			Color.RED,
			Vector2(block.global_position.x, START_POSITION.y - 20)
		)
		timeline_log.append(
			"[color=red]Bad: Tapped index[%d]: %d out of order (expected %d)[/color]" % 
			[index, main_array[index], next_expected_index]
		)
	
	_update_timeline_display()
	_update_ui_labels()
	_update_undo_redo_buttons()

# Add this new function for block visual feedback
func _update_current_selection(index: int):
	# First, reset any previous selected block
	if current_selected_index != -1 and current_selected_index < block_nodes.size():
		var old_block = block_nodes[current_selected_index]
		# Reset scale and any animations
		old_block.scale = Vector2(1.0, 1.0)
		if old_block.has_meta("pulse_tween"):
			var old_tween = old_block.get_meta("pulse_tween")
			if old_tween and old_tween.is_running():
				old_tween.kill()
	
	# Update current selected index
	current_selected_index = index
	
	# Apply visual feedback to new selected block
	if index >= 0 and index < block_nodes.size():
		var block = block_nodes[index]
		
		# OPTION 1: Constant subtle pulse (scale)
		var tween = create_tween().set_loops()  # Infinite loops
		tween.tween_property(block, "scale", Vector2(1.1, 1.1), 0.4)
		tween.tween_property(block, "scale", Vector2(1.0, 1.0), 0.4)
		block.set_meta("pulse_tween", tween)
		
		# OPTION 2: If you prefer color change instead, uncomment this:
		# block.modulate = Color(1, 1, 0.5, 1)  # Light yellow tint
		
		# OPTION 3: If you prefer constant shake, uncomment this:
		# var shake_tween = create_tween().set_loops()
		# var original_pos = block.position
		# shake_tween.tween_property(block, "position:x", original_pos.x + 3, 0.1)
		# shake_tween.tween_property(block, "position:x", original_pos.x - 3, 0.1)
		# block.set_meta("shake_tween", shake_tween)

func _get_next_unrevealed_index() -> int:
	for i in range(revealed_indices.size()):
		if not revealed_indices[i]:
			return i
	return -1  # All revealed

func _reveal_block(index: int):
	if index >= 0 and index < block_nodes.size() and not revealed_indices[index]:
		block_nodes[index].hide_number(false)  # Show the number
		revealed_indices[index] = true

func _update_current_highlight(index: int):
	current_selected_index = index
	
	# First, stop any existing animation on previously selected block
	if current_highlight and current_highlight.has_meta("shake_tween"):
		var old_tween = current_highlight.get_meta("shake_tween")
		if old_tween and old_tween.is_running():
			old_tween.kill()
	
	if current_highlight and index >= 0 and index < block_nodes.size():
		var block = block_nodes[index]
		
		# Position the highlight rectangle
		current_highlight.global_position = block.global_position - Vector2(5, 5)
		current_highlight.size = block.size + Vector2(10, 10)
		current_highlight.show()
		
		# Add a subtle constant shake/wobble animation
		var tween = create_tween().set_loops()  # Infinite loops
		tween.set_parallel(true)
		
		# Slight scale pulse
		tween.tween_property(current_highlight, "scale", Vector2(1.05, 1.05), 0.5)
		tween.tween_property(current_highlight, "scale", Vector2(0.95, 0.95), 0.5)
		
		# Store tween reference to kill later if needed
		current_highlight.set_meta("shake_tween", tween)
	elif current_highlight:
		current_highlight.hide()

func _on_match_pressed():
	btn_sound.play()
	
	if target_found:
		show_feedback("Target already found!", Color.ORANGE, get_global_mouse_position())
		return
	
	if current_selected_index == -1:
		show_feedback("Tap a block first!", Color.ORANGE, get_global_mouse_position())
		return
	
	# Save state for undo
	_save_state()
	redo_stack.clear()
	
	var index = current_selected_index
	var value = main_array[index]
	var is_match = (value == target_value)
	
	var match_data = {
		"type": "match",
		"index": index,
		"value": value,
		"was_match": is_match
	}
	match_history.append(match_data)
	move_history.append(match_data)
	
	if is_match:
		# SUCCESS! Target found
		target_found = true
		target_found_index = index
		correct_moves += 1
		
		# Highlight the found block in gold
		block_nodes[index].modulate = Color(1, 0.8, 0, 1)  # Gold color
		
		# Stop any animations on this block
		if block_nodes[index].has_meta("pulse_tween"):
			var tween = block_nodes[index].get_meta("pulse_tween")
			if tween and tween.is_running():
				tween.kill()
		
		show_feedback(
			"CORRECT! Target %d found!" % target_value,
			Color(1, 0.8, 0, 1),
			block_nodes[index].global_position
		)
		timeline_log.append(
			"[color=gold]SUCCESS: Target %d found at index[%d]![/color]" % [target_value, index]
		)
		
		if status_label:
			status_label.text = "Target found! Well done!"
		
		# Hide highlight
		if current_highlight:
			current_highlight.hide()
		
		# End the assessment - THIS MUST BE CALLED
		_end_assessment("sorted")
	else:
		# Wrong match attempt
		mistake_counter += 1
		show_feedback(
			"Wrong! Value %d is not the target %d" % [value, target_value],
			Color.RED,
			block_nodes[index].global_position
		)
		timeline_log.append(
			"[color=red]Wrong match: index[%d]: %d ≠ target %d[/color]" % [index, value, target_value]
		)
	
	_update_timeline_display()
	_update_ui_labels()
	_update_undo_redo_buttons()

func _resnap_blocks() -> void:
	# Not heavily used in Linear Search but kept for compatibility
	var x = START_POSITION.x
	for i in range(block_nodes.size()):
		var child = block_nodes[i]
		var target_pos = Vector2(x, START_POSITION.y)
		var tween = create_tween()
		tween.tween_property(child, "position", target_pos, 0.2)
		x += child.size.x + BLOCK_SPACING

func _save_state() -> void:
	var state := {
		"array": main_array.duplicate(),
		"revealed": revealed_indices.duplicate(),
		"current_selected": current_selected_index,
		"target_found": target_found,
		"target_found_index": target_found_index,
		"mistakes": mistake_counter,
		"correct": correct_moves
	}
	undo_stack.append(state)

# ==============================================
#   UI UPDATE FUNCTIONS
# ==============================================

func _update_ui_labels():
	var revealed_count = 0
	for revealed in revealed_indices:
		if revealed: revealed_count += 1
	
	compare_label.text = "Revealed: %d/%d | Correct: %d | Mistakes: %d" % [
		revealed_count, main_array.size(), correct_moves, mistake_counter
	]

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
	
	match current_code_language:
		"cpp":
			code = get_cpp_linear_code(arr_str, target_value)
			current_tutorial_data = cpp_tutorial_data
		"python":
			code = get_python_linear_code(arr_str, target_value)
			current_tutorial_data = python_tutorial_data
		"java":
			code = get_java_linear_code(arr_str, target_value)
			current_tutorial_data = java_tutorial_data
		"c":
			code = get_c_linear_code(arr_str, target_value)
			current_tutorial_data = c_tutorial_data
	
	cpp_text.text = code
	cpp_popup.popup_centered()
	
	cpp_tutorial_step = 0
	
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
			"cpp": base_code = get_cpp_linear_code(arr_str, target_value)
			"python": base_code = get_python_linear_code(arr_str, target_value)
			"java": base_code = get_java_linear_code(arr_str, target_value)
			"c": base_code = get_c_linear_code(arr_str, target_value)

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

func get_cpp_linear_code(arr: String, target: int) -> String:
	return """/* Linear Search - Time Complexity: O(n) */
#include <iostream>
using namespace std;

int linearSearch(int arr[], int n, int target) {
	for (int i = 0; i < n; i++) {
		if (arr[i] == target) {
			return i;  // Found at index i
		}
	}
	return -1;  // Not found
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
	int target = %d;
	
	cout << "Array: ";
	printArray(arr, n);
	cout << "Searching for: " << target << endl;
	
	int result = linearSearch(arr, n, target);
	
	if (result != -1)
		cout << "Element found at index: " << result << endl;
	else
		cout << "Element " << target << " not found in the array" << endl;
	
	return 0;
}""" % [arr, target]

func get_python_linear_code(arr: String, target: int) -> String:
	return """# Linear Search - Time Complexity: O(n)
def linear_search(arr, target):
	for i, value in enumerate(arr):
		if value == target:
			return i  # Found at index i
	return -1  # Not found

def print_array(arr):
	print("[", end="")
	for i in range(len(arr)):
		print(arr[i], end="")
		if i < len(arr) - 1:
			print(", ", end="")
	print("]")

arr = [%s]
target = %d

print("Array: ", end="")
print_array(arr)
print(f"Searching for: {target}")

result = linear_search(arr, target)

if result != -1:
	print(f"Element found at index: {result}")
else:
	print(f"Element {target} not found in the array")""" % [arr, target]

func get_java_linear_code(arr: String, target: int) -> String:
	var code = """/* Linear Search - Time Complexity: O(n) */
public class Main {
	static int search(int arr[], int target) {
		for (int i = 0; i < arr.length; i++) {
			if (arr[i] == target)
				return i;
		}
		return -1;
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
		int arr[] = {{ARR}};
		int target = {TARGET};
		
		System.out.print("Array: ");
		printArray(arr);
		System.out.println("Searching for: " + target);
		
		int result = search(arr, target);
		
		if (result != -1)
			System.out.println("Element found at index: " + result);
		else
			System.out.println("Element " + target + " not found in the array");
	}
}"""
	code = code.replace("{ARR}", arr)
	code = code.replace("{TARGET}", str(target))
	return code

func get_c_linear_code(arr: String, target: int) -> String:
	var code = """/* Linear Search - Time Complexity: O(n) */
#include <stdio.h>

int linearSearch(int arr[], int n, int target) {
	for (int i = 0; i < n; i++) {
		if (arr[i] == target)
			return i;
	}
	return -1;
}

void printArray(int arr[], int n) {
	printf("[");
	for (int i = 0; i < n; i++) {
		printf("%d", arr[i]);
		if (i < n - 1) printf(", ");
	}
	printf("]\\n");
}

int main() {
	int arr[] = {ARR};
	int n = sizeof(arr) / sizeof(arr[0]);
	int target = {TARGET};
	
	printf("Array: ");
	printArray(arr, n);
	printf("Searching for: %d\\n", target);
	
	int result = linearSearch(arr, n, target);
	
	if (result != -1)
		printf("Element found at index: %d\\n", result);
	else
		printf("Element %d not found in the array\\n", target);
	
	return 0;
}"""
	code = code.replace("{ARR}", arr)
	code = code.replace("{TARGET}", str(target))
	return code

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
			code = get_cpp_linear_code(arr_str, target_value)
		"c":
			code = get_c_linear_code(arr_str,target_value)
		"java":
			code = get_java_linear_code(arr_str, target_value)
		"python":
			code = get_python_linear_code(arr_str,target_value)
	
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
			code = get_cpp_linear_code(arr_str,target_value)
		"c":
			code = get_c_linear_code(arr_str,target_value)
		"java":
			code = get_java_linear_code(arr_str,target_value)
		"python":
			code = get_python_linear_code(arr_str, target_value)
	
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
			"node": match_btn,
			"title": "MATCH",
			"text": "Press this when you think the currently highlighted block contains the target number",
			"action": "highlight"
		},
		{
			"node": sort_btn,
			"title": "UNDO",
			"text": "Reverses your last action (reveal or match attempt)",
			"action": "highlight"
		},
		{
			"node": auto_btn,
			"title": "REDO",
			"text": "Reapplies an action that was undone",
			"action": "highlight"
		},

		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View your complete move history",
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
	
	# Select random target from custom array
	target_value = arr[randi() % arr.size()]
	_initialize_with_elements(arr)
	
	# Update target label
	if target_label:
		target_label.text = "FIND: %d" % target_value

func _on_config_no_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	var count = randi_range(5, 7)
	var arr: Array[int] = []
	for i in count: arr.append(randi_range(1, 99))
	_set_main_ui_enabled(true)
	help_btn.show()
	
	# Select random target from generated array
	target_value = arr[randi() % arr.size()]
	_initialize_with_elements(arr)
	
	# Update target label
	if target_label:
		target_label.text = "FIND: %d" % target_value

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
	if match_btn: match_btn.disabled = not enabled

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

func _on_waiting_pressed() -> void:  # Redo
	if not _can_redo():
		return
	
	if redo_stack.is_empty():
		return
	
	var state = redo_stack.pop_back()
	
	undo_stack.append({
		"array": main_array.duplicate(),
		"revealed": revealed_indices.duplicate(),
		"current_selected": current_selected_index,
		"target_found": target_found,
		"target_found_index": target_found_index,
		"mistakes": mistake_counter,
		"correct": correct_moves
	})
	
	_restore_state(state)

func _on_sort_button_pressed() -> void:  # Undo
	if not _can_undo():
		return
	
	if undo_stack.is_empty():
		return
	
	var state = undo_stack.pop_back()
	
	redo_stack.append({
		"array": main_array.duplicate(),
		"revealed": revealed_indices.duplicate(),
		"current_selected": current_selected_index,
		"target_found": target_found,
		"target_found_index": target_found_index,
		"mistakes": mistake_counter,
		"correct": correct_moves
	})
	
	_restore_state(state)

func _restore_state(state: Dictionary) -> void:
	main_array = state["array"].duplicate()
	revealed_indices = state["revealed"].duplicate()
	current_selected_index = state["current_selected"]
	target_found = state["target_found"]
	target_found_index = state["target_found_index"]
	mistake_counter = state["mistakes"]
	correct_moves = state["correct"]
	
	_rebuild_blocks_from_array()
	
	# Restore revealed states
	for i in range(block_nodes.size()):
		block_nodes[i].hide_number(not revealed_indices[i])
		if target_found and i == target_found_index:
			block_nodes[i].modulate = Color(1, 0.8, 0, 1)  # Gold for found target
	
	# Restore current selection visual
	if current_selected_index >= 0:
		_update_current_selection(current_selected_index)
	
	_update_ui_labels()
	_update_timeline_display()

func _rebuild_blocks_from_array() -> void:
	for child in array_container.get_children():
		child.queue_free()
	
	block_nodes.clear()
	
	var current_x: float = START_POSITION.x
	
	for i in range(main_array.size()):
		var val = main_array[i]
		var new_block = BLOCK_SCENE.instantiate()
		new_block.value = val
		new_block.position = Vector2(current_x, START_POSITION.y)
		
		new_block.draggable = false
		if not new_block.is_connected("block_pressed", _on_block_pressed):
			new_block.connect("block_pressed", _on_block_pressed)
		
		array_container.add_child(new_block)
		block_nodes.append(new_block)
		
		current_x += new_block.size.x + BLOCK_SPACING

func _on_try_again_button_pressed() -> void:
	btn_sound.play()
	time_up_popup.hide()
	result_popup.hide()
	
	# CRITICAL: Reset completion flag
	has_completed_assessment = false
	
	# Kill any lingering animations
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	# Reset any block animations
	for block in block_nodes:
		if block.has_meta("pulse_tween"):
			var tween = block.get_meta("pulse_tween")
			if tween and tween.is_running():
				tween.kill()
		block.scale = Vector2(1.0, 1.0)
		block.modulate = Color.WHITE
	
	# Start fresh assessment
	_start_assessment_mode()
	await get_tree().process_frame
	_update_undo_redo_buttons()

func _update_difficulty_label():
	if not difficulty_label:
		return
	match difficulty:
		1: difficulty_label.text = "Difficulty: Easy (No Timer)"
		2: difficulty_label.text = "Difficulty: Medium (90s)"
		3: difficulty_label.text = "Difficulty: Hard (60s)"

func _can_undo() -> bool:
	if target_found or not timer_running:
		return false
	
	if difficulty == 3:
		return false
	
	return true

func _can_redo() -> bool:
	if target_found or not timer_running:
		return false
	
	if difficulty == 3:
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
		sort_btn.modulate = Color(1, 1, 1, 1) if not undo_stack.is_empty() else Color(0.7, 0.7, 0.7, 1)
	else:
		sort_btn.modulate = Color(0.5, 0.5, 0.5, 0.5)
		
	if redo_allowed:
		auto_btn.modulate = Color(1, 1, 1, 1) if not redo_stack.is_empty() else Color(0.7, 0.7, 0.7, 1)
	else:
		auto_btn.modulate = Color(0.5, 0.5, 0.5, 0.5)

# ==============================================
#   ASSESSMENT & GRADING
# ==============================================

func _get_required_threshold() -> float:
	match difficulty:
		1: return 0.6
		2: return 0.75
		3: return 0.8
	return 0.7

func _compute_grade() -> Dictionary:
	var total_moves = correct_moves + mistake_counter
	var accuracy = float(correct_moves) / max(total_moves, 1) * 100
	var required_threshold = _get_required_threshold() * 100
	var passed = accuracy >= required_threshold
	
	var time_used = assessment_time_limit - time_remaining
	
	var coins = 0
	match difficulty:
		1: coins = 5 if not has_completed_assessment else 1
		2: coins = 10 if not has_completed_assessment else 3
		3: coins = 20 if not has_completed_assessment else 5
	
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

func _end_assessment(reason: String) -> void:
	print("END ASSESSMENT CALLED - Reason: ", reason, " Has completed: ", has_completed_assessment)
	if has_completed_assessment:
		print("Already completed, returning")
		return
	
	has_completed_assessment = true
	print("Now setting has_completed_assessment to true")
	completion_type = reason
	
	# Kill any animations
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	timer_running = false
	tiktak_sound.stop()
	
	# REVEAL ALL BLOCKS - regardless of pass/fail
	for i in range(block_nodes.size()):
		if not revealed_indices[i]:
			_reveal_block(i)  # Show the number
	
	# Disable all interactive buttons
	if sort_btn:
		sort_btn.disabled = true
	if auto_btn:
		auto_btn.disabled = true
	if match_btn:
		match_btn.disabled = true
	
	# Stop any block animations
	for block in block_nodes:
		if block.has_meta("pulse_tween"):
			var tween = block.get_meta("pulse_tween")
			if tween and tween.is_running():
				tween.kill()
	
	if reason == "timeout":
		_show_result_popup("FAIL")
	else:
		var grade = _compute_grade()
		var result = "PASS" if grade["passed"] else "FAIL"
		_show_result_popup(result, grade)

func _show_result_popup(result: String, grade_data: Dictionary = {}) -> void:
	if not result_popup:
		return
	
	if complete_popup and complete_popup.visible:
		complete_popup.hide()
	
	if result == "PASS":
		result_title.text = "PASSED!"
		result_title.modulate = Color(0, 1, 0)
		if translate_code_btn:
			translate_code_btn.show()
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")
		try_again_button.visible = false
	else:
		result_title.text = "FAILED!"
		result_title.modulate = Color(1, 0, 0)
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
	
	# CRITICAL: Reset completion flag
	has_completed_assessment = false
	
	# Kill any lingering animations
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	# Reset any block animations
	for block in block_nodes:
		if block.has_meta("pulse_tween"):
			var tween = block.get_meta("pulse_tween")
			if tween and tween.is_running():
				tween.kill()
		block.scale = Vector2(1.0, 1.0)
		block.modulate = Color.WHITE
	
	_start_assessment_mode()

func _on_back_result_pressed():
	btn_sound.play()
	result_popup.hide()

func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()
