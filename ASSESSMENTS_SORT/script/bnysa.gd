extends Control

# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton
@onready var auto_btn: Button = $VBoxContainer/WaitingElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var match_btn: Button = $VBoxContainer/MatchButton
@onready var discard_left_btn: Button = $VBoxContainer/DiscardLeftButton
@onready var discard_right_btn: Button = $VBoxContainer/DiscardRightButton

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

# --- POINTERS (Not heavily used but kept for compatibility) ---
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

# --- BINARY SEARCH VARIABLES ---
var main_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []

var target_value: int = 0
var current_mid_index: int = -1
var revealed_indices: Array[bool] = []  # Track which blocks are revealed
var discarded_indices: Array[bool] = []  # Track which blocks are discarded (greyed out)
var target_found: bool = false
var target_found_index: int = -1

# Search space boundaries
var left_boundary: int = 0
var right_boundary: int = 0

# Phase tracking
enum BinarySearchPhase { PICK_MID, DECISION }
var current_phase: BinarySearchPhase = BinarySearchPhase.PICK_MID

# Move history tracking
var mid_pick_history: Array[Dictionary] = []
var decision_history: Array[Dictionary] = []

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

# Intro Text - Updated for Binary Search
var intro_texts = [
	"""WELCOME TO BINARY SEARCH SIMULATION! 🔍
Binary Search is a FAST searching algorithm that works on SORTED arrays:
• It repeatedly divides the search interval in half
• Time Complexity: O(log n) - VERY efficient!
• Requires the array to be SORTED first
""","""
Your task: Find the target number by repeatedly picking the middle element!""",

	"""HOW TO PLAY: 🎮
PHASE 1 - PICK MIDDLE:
• Tap the MIDDLE element of the current search range
• For EVEN-sized arrays, pick the LOWER middle (example: [1,2,3,4] → pick 2)
• Correct pick reveals the number and moves to Decision Phase
• Wrong pick counts as mistake and element stays hidden

""","""PHASE 2 - DECISION:
• MATCH: If mid equals target → YOU WIN!
• DISCARD LEFT: If mid < target → discard left half (correct)
• DISCARD RIGHT: If mid > target → discard right half (correct)
• Wrong decisions count as mistakes and don't discard""",

	"""VISUAL CUES: 👁️

• DISCARDED elements turn GREY and cannot be tapped
• Current MIDDLE element gets YELLOW highlight/pulse
• REVEALED numbers stay visible
• Target is shown in GOLD at the top
• Found target turns GOLDEN

""","""EXAMPLE (Target: 7 in [1,3,5,7,9]):
1. Pick middle (index 2, value 5) → reveals 5
2. 5 < 7 → Press DISCARD LEFT (correct!)
3. New range [7,9] → pick middle (index 3, value 7)
4. Press MATCH → CORRECT! Target found!""",

	"""EVEN ARRAYS RULE: 📏

For arrays with EVEN length, always pick the LOWER middle:

[1,2,3,4] → pick 2 (index 1), NOT 3 (index 2)
[10,20,30,40,50,60] → pick 30 (index 2), NOT 40 (index 3)

""","""The system will validate and only accept the correct middle!
Wrong middle picks count as mistakes with explanatory feedback.""",

	"""DIFFICULTY LEVELS: ⏱️

EASY:
	
• No time limit
• 4 elements
• Perfect for learning binary search

""","""MEDIUM:
	
• 90 second time limit
• 7 elements
• Tests your binary search logic

""","""HARD:
	
• 60 second time limit! 
• 10 elements
• True test of binary search mastery

Press buttons carefully - each decision counts!"""
]

# --- CODE TUTORIAL DATA (Updated for Binary Search) ---
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

# 1. C++ DATA (Binary Search)
var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Function Definition:\nTakes sorted array, left, right, and target." },
	{ "lines": [2], "text": "2. While Loop:\nContinue while left <= right." },
	{ "lines": [3], "text": "3. Calculate Middle:\nFind the middle index (avoid overflow)." },
	{ "lines": [4, 5], "text": "4. Target Found:\nIf mid equals target, return index." },
	{ "lines": [6, 7], "text": "5. Discard Right:\nIf mid < target, search right half." },
	{ "lines": [8, 9], "text": "6. Discard Left:\nIf mid > target, search left half." },
	{ "lines": [10], "text": "7. Not Found:\nReturn -1 if target not in array." }
]

# 2. PYTHON DATA (Binary Search)
var python_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Function Definition:\nTakes sorted array and target." },
	{ "lines": [2, 3], "text": "2. Initialize Pointers:\nLeft and right boundaries." },
	{ "lines": [4], "text": "3. While Loop:\nContinue while left <= right." },
	{ "lines": [5], "text": "4. Find Middle:\nCalculate mid index." },
	{ "lines": [6, 7], "text": "5. Target Found:\nReturn index if match." },
	{ "lines": [8, 9], "text": "6. Adjust Range:\nUpdate left/right based on comparison." },
	{ "lines": [10], "text": "7. Not Found:\nReturn -1 after loop." }
]

# 3. JAVA DATA (Binary Search)
var java_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Method Signature:\nStatic method returning integer index." },
	{ "lines": [2, 3], "text": "2. Initialize Pointers:\nLeft and right boundaries." },
	{ "lines": [4], "text": "3. While Loop:\nContinue while left <= right." },
	{ "lines": [5], "text": "4. Calculate Mid:\nFind middle index." },
	{ "lines": [6, 7], "text": "5. Target Found:\nReturn index if match." },
	{ "lines": [8, 9], "text": "6. Adjust Range:\nUpdate left/right based on comparison." },
	{ "lines": [10], "text": "7. Not Found:\nReturn -1 after loop." }
]

# 4. C DATA (Binary Search)
var c_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Function:\nReturns index or -1 if not found." },
	{ "lines": [2], "text": "2. While Loop:\nContinue while left <= right." },
	{ "lines": [3], "text": "3. Calculate Mid:\nFind middle index." },
	{ "lines": [4, 5], "text": "4. Target Found:\nReturn index if match." },
	{ "lines": [6, 7], "text": "5. Adjust Left:\nIf mid < target, search right." },
	{ "lines": [8, 9], "text": "6. Adjust Right:\nIf mid > target, search left." },
	{ "lines": [10], "text": "7. Not Found:\nReturn -1." }
]

enum SimMode { LECTURE, ASSESSMENT }
var sim_mode: SimMode = SimMode.ASSESSMENT
var difficulty := 2

var time_remaining: float = 0.0
var timer_running: bool = false
var assessment_time_limit: float = 0.0
var intro_step: int = 0

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
		2: return 7
		3: return 10
	return 7

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
	
	print("Program started — initializing Binary Search visualizer...")
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
	
	# Setup binary search buttons
	if match_btn:
		match_btn.text = "MATCH"
		match_btn.pressed.connect(_on_match_pressed)
	
	if discard_left_btn:
		discard_left_btn.text = "DISCARD LEFT"
		discard_left_btn.pressed.connect(_on_discard_left_pressed)
	
	if discard_right_btn:
		discard_right_btn.text = "DISCARD RIGHT"
		discard_right_btn.pressed.connect(_on_discard_right_pressed)
	
	# Setup current highlight
	if current_highlight:
		current_highlight.hide()
		current_highlight.color = Color(1, 1, 0, 0.3)  # Semi-transparent yellow
	
	# Hide all modals initially
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	# Hide pointers
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
	
	# CRITICAL: Reset completion flag
	has_completed_assessment = false
	
	# Show and enable all buttons
	if match_btn:
		match_btn.show()
		match_btn.disabled = false
		match_btn.modulate = Color(1, 1, 1, 1)
	
	if discard_left_btn:
		discard_left_btn.show()
		discard_left_btn.disabled = false
		discard_left_btn.modulate = Color(1, 1, 1, 1)
	
	if discard_right_btn:
		discard_right_btn.show()
		discard_right_btn.disabled = false
		discard_right_btn.modulate = Color(1, 1, 1, 1)
	
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
	current_mid_index = -1
	current_phase = BinarySearchPhase.PICK_MID
	
	revealed_indices.clear()
	discarded_indices.clear()
	mid_pick_history.clear()
	decision_history.clear()
	
	if current_highlight:
		current_highlight.hide()
	
	# Reset any lingering block animations
	for block in block_nodes:
		if block.has_meta("pulse_tween"):
			var tween = block.get_meta("pulse_tween")
			if tween and tween.is_running():
				tween.kill()
		block.scale = Vector2(1.0, 1.0)
		block.modulate = Color.WHITE
	
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
	
	# Generate sorted random array (BINARY SEARCH REQUIRES SORTED ARRAY)
	for i in range(size):
		arr.append(randi_range(1, 99))
	arr.sort()  # CRITICAL: Sort the array for binary search
	
	# Select random target from array
	target_value = arr[randi() % arr.size()]
	
	_initialize_with_elements(arr)
	
	# Show target in target label
	_update_target_label()
	
	if status_label:
		status_label.text = "Phase 1: Pick the MIDDLE element"
	
	_update_undo_redo_buttons()

func _update_target_label():
	if target_label:
		if current_phase == BinarySearchPhase.PICK_MID:
			var even_hint = ""
			var current_range_size = right_boundary - left_boundary + 1
			if current_range_size % 2 == 0:
				even_hint = " (pick LOWER mid)"
			target_label.text = "TARGET: %d | Pick MIDDLE%s" % [target_value, even_hint]
		else:  # DECISION phase
			target_label.text = "TARGET: %d | MID = %d | Choose: MATCH, DISCARD LEFT, or DISCARD RIGHT" % [target_value, main_array[current_mid_index]]
		
		target_label.add_theme_color_override("font_color", Color(1, 0.8, 0, 1))  # Gold color
		target_label.add_theme_font_size_override("font_size", 40)

func _initialize_with_elements(elements: Array[int]) -> void:
	print("Initializing Sorted Array with:", elements, " Target:", target_value)
	audio_player.play()
	
	main_array = elements.duplicate()
	block_nodes.clear()
	timeline_log.clear()
	
	# Initialize tracking arrays
	revealed_indices.resize(main_array.size())
	discarded_indices.resize(main_array.size())
	for i in range(main_array.size()):
		revealed_indices[i] = false
		discarded_indices[i] = false
	
	# Set initial boundaries
	left_boundary = 0
	right_boundary = main_array.size() - 1
	
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
		
		# Blocks are NOT draggable in Binary Search
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
	
	# Apply initial discard states (none yet)
	_apply_discard_visuals()

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
#   BINARY SEARCH CORE LOGIC
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
	
	# Check if block is discarded
	if discarded_indices[index]:
		show_feedback(
			"This element is discarded!",
			Color.GRAY,
			Vector2(block.global_position.x, START_POSITION.y - 20)
		)
		return
	
	# Only allow picking middle during PICK_MID phase
	if current_phase != BinarySearchPhase.PICK_MID:
		show_feedback(
			"Now in DECISION phase! Use the buttons to MATCH or DISCARD",
			Color.ORANGE,
			Vector2(block.global_position.x, START_POSITION.y - 20)
		)
		return
	
	# Check if block is within current search boundaries
	if index < left_boundary or index > right_boundary:
		show_feedback(
			"This element is outside the current search range!",
			Color.ORANGE,
			Vector2(block.global_position.x, START_POSITION.y - 20)
		)
		return
	
	# Save state for undo
	_save_state()
	redo_stack.clear()
	
	# Calculate the correct middle index for current range
	var correct_mid = _calculate_mid_index()
	var is_correct_mid = (index == correct_mid)
	
	if is_correct_mid:
		# Correct middle pick
		current_mid_index = index
		_reveal_block(index)
		_update_current_highlight(index)
		
		# Move to decision phase
		current_phase = BinarySearchPhase.DECISION
		correct_moves += 1
		
		show_feedback(
			"Good! That's the correct middle element",
			Color.GREEN,
			Vector2(block.global_position.x, START_POSITION.y - 20)
		)
		timeline_log.append(
			"[color=green]Good: Picked correct middle index[%d]: %d[/color]" % [index, main_array[index]]
		)
		
		# Track history
		var pick_data = {
			"type": "pick_mid",
			"index": index,
			"value": main_array[index],
			"was_correct": true
		}
		mid_pick_history.append(pick_data)
		move_history.append(pick_data)
		
		# Update target label for decision phase
		_update_target_label()
		
		if status_label:
			status_label.text = "Phase 2: Choose MATCH, DISCARD LEFT, or DISCARD RIGHT"
	else:
		# Wrong middle pick
		mistake_counter += 1
		
		var range_size = right_boundary - left_boundary + 1
		var feedback_msg = ""
		
		if range_size % 2 == 0:
			feedback_msg = "Wrong! For even arrays, pick the LOWER middle (index %d)" % correct_mid
		else:
			feedback_msg = "Wrong! The correct middle is at index %d" % correct_mid
		
		show_feedback(
			feedback_msg,
			Color.RED,
			Vector2(block.global_position.x, START_POSITION.y - 20)
		)
		timeline_log.append(
			"[color=red]Bad: Picked wrong middle index[%d] (should be %d)[/color]" % [index, correct_mid]
		)
		
		# Track history
		var pick_data = {
			"type": "pick_mid",
			"index": index,
			"value": main_array[index],
			"was_correct": false
		}
		mid_pick_history.append(pick_data)
		move_history.append(pick_data)
	
	_update_timeline_display()
	_update_ui_labels()
	_update_undo_redo_buttons()

func _calculate_mid_index() -> int:
	# Returns the LOWER middle index for even-sized ranges
	return left_boundary + floor((right_boundary - left_boundary) / 2.0)

func _reveal_block(index: int):
	if index >= 0 and index < block_nodes.size() and not revealed_indices[index]:
		block_nodes[index].hide_number(false)  # Show the number
		revealed_indices[index] = true

func _update_current_highlight(index: int):
	# First, stop any existing animation on previously selected block
	if current_mid_index != -1 and current_mid_index < block_nodes.size():
		var old_block = block_nodes[current_mid_index]
		if old_block.has_meta("pulse_tween"):
			var old_tween = old_block.get_meta("pulse_tween")
			if old_tween and old_tween.is_running():
				old_tween.kill()
		old_block.scale = Vector2(1.0, 1.0)
	
	# Update current mid index
	current_mid_index = index
	
	# Apply visual feedback to new selected block
	if index >= 0 and index < block_nodes.size():
		var block = block_nodes[index]
		
		# Pulse animation
		var tween = create_tween().set_loops()  # Infinite loops
		tween.tween_property(block, "scale", Vector2(1.1, 1.1), 0.4)
		tween.tween_property(block, "scale", Vector2(1.0, 1.0), 0.4)
		block.set_meta("pulse_tween", tween)
		
		# Also position highlight rectangle (optional backup)
		if current_highlight:
			current_highlight.global_position = block.global_position - Vector2(5, 5)
			current_highlight.size = block.size + Vector2(10, 10)
			current_highlight.show()
	elif current_highlight:
		current_highlight.hide()

func _discard_range(discard_left: bool) -> bool:
	# Returns true if discard was correct, false otherwise
	if current_phase != BinarySearchPhase.DECISION:
		show_feedback("Not in decision phase!", Color.ORANGE, get_global_mouse_position())
		return false
	
	if current_mid_index == -1:
		show_feedback("No middle element selected!", Color.ORANGE, get_global_mouse_position())
		return false
	
	var mid_value = main_array[current_mid_index]
	var is_correct: bool
	
	if discard_left:
		# Discard left means mid < target (we want to search right half)
		is_correct = (mid_value < target_value)
	else:
		# Discard right means mid > target (we want to search left half)
		is_correct = (mid_value > target_value)
	
	if is_correct:
		# Correct discard
		if discard_left:
			# Discard everything from left_boundary to current_mid_index
			for i in range(left_boundary, current_mid_index + 1):
				if not discarded_indices[i]:
					discarded_indices[i] = true
					# Reveal discarded elements
					_reveal_block(i)
			# Update left boundary
			left_boundary = current_mid_index + 1
			show_feedback("Correct! Discarding left half", Color.GREEN, get_global_mouse_position())
			timeline_log.append(
				"[color=green]Good: Discarded left (mid %d < target %d)[/color]" % [mid_value, target_value]
			)
		else:
			# Discard everything from current_mid_index to right_boundary
			for i in range(current_mid_index, right_boundary + 1):
				if not discarded_indices[i]:
					discarded_indices[i] = true
					# Reveal discarded elements
					_reveal_block(i)
			# Update right boundary
			right_boundary = current_mid_index - 1
			show_feedback("Correct! Discarding right half", Color.GREEN, get_global_mouse_position())
			timeline_log.append(
				"[color=green]Good: Discarded right (mid %d > target %d)[/color]" % [mid_value, target_value]
			)
		
		correct_moves += 1
		
		# Track history
		var decision_data = {
			"type": "discard",
			"discard_left": discard_left,
			"mid_index": current_mid_index,
			"mid_value": mid_value,
			"was_correct": true
		}
		decision_history.append(decision_data)
		move_history.append(decision_data)
		
		# Apply visual changes
		_apply_discard_visuals()
		
		# Check if search space is empty
		if left_boundary > right_boundary:
			show_feedback("Search space empty! Target not found?", Color.ORANGE, get_global_mouse_position())
			_end_assessment("sorted")  # This will trigger grade calculation
			return true
		
		# Reset to PICK_MID phase
		current_phase = BinarySearchPhase.PICK_MID
		current_mid_index = -1
		if current_highlight:
			current_highlight.hide()
		
		# Update target label for pick mid phase
		_update_target_label()
		
		if status_label:
			status_label.text = "Phase 1: Pick the new MIDDLE element"
		
		return true
	else:
		# Wrong discard
		mistake_counter += 1
		
		var feedback_msg = ""
		if discard_left:
			feedback_msg = "Wrong! Can't discard left because mid %d is NOT < target %d" % [mid_value, target_value]
		else:
			feedback_msg = "Wrong! Can't discard right because mid %d is NOT > target %d" % [mid_value, target_value]
		
		show_feedback(feedback_msg, Color.RED, get_global_mouse_position())
		timeline_log.append(
			"[color=red]Bad: Wrong discard decision (mid %d, target %d)[/color]" % [mid_value, target_value]
		)
		
		# Track history
		var decision_data = {
			"type": "discard",
			"discard_left": discard_left,
			"mid_index": current_mid_index,
			"mid_value": mid_value,
			"was_correct": false
		}
		decision_history.append(decision_data)
		move_history.append(decision_data)
		
		return false

func _apply_discard_visuals():
	for i in range(block_nodes.size()):
		if discarded_indices[i]:
			# Make discarded blocks grey and unclickable
			block_nodes[i].modulate = Color(0.5, 0.5, 0.5, 0.7)  # Grey with some transparency
			# Also reveal their numbers if not already revealed
			_reveal_block(i)
		else:
			# Keep non-discarded blocks normal (unless they're the current mid, handled separately)
			if i != current_mid_index:
				block_nodes[i].modulate = Color.WHITE

func _on_match_pressed():
	btn_sound.play()
	
	if target_found:
		show_feedback("Target already found!", Color.ORANGE, get_global_mouse_position())
		return
	
	if current_phase != BinarySearchPhase.DECISION:
		show_feedback("Not in decision phase! Pick the middle element first", Color.ORANGE, get_global_mouse_position())
		return
	
	if current_mid_index == -1:
		show_feedback("No middle element selected!", Color.ORANGE, get_global_mouse_position())
		return
	
	# Save state for undo
	_save_state()
	redo_stack.clear()
	
	var index = current_mid_index
	var value = main_array[index]
	var is_match = (value == target_value)
	
	var match_data = {
		"type": "match",
		"index": index,
		"value": value,
		"was_match": is_match
	}
	decision_history.append(match_data)
	move_history.append(match_data)
	
	if is_match:
		# SUCCESS! Target found
		target_found = true
		target_found_index = index
		correct_moves += 1
		
		# Stop any animations on this block
		if block_nodes[index].has_meta("pulse_tween"):
			var tween = block_nodes[index].get_meta("pulse_tween")
			if tween and tween.is_running():
				tween.kill()
		
		# Highlight the found block in gold
		block_nodes[index].modulate = Color(1, 0.8, 0, 1)  # Gold color
		block_nodes[index].scale = Vector2(1.1, 1.1)  # Slightly larger
		
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
		
		# End the assessment
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

func _on_discard_left_pressed():
	btn_sound.play()
	_discard_range(true)

func _on_discard_right_pressed():
	btn_sound.play()
	_discard_range(false)

func _save_state() -> void:
	var state := {
		"array": main_array.duplicate(),
		"revealed": revealed_indices.duplicate(),
		"discarded": discarded_indices.duplicate(),
		"current_mid": current_mid_index,
		"left_boundary": left_boundary,
		"right_boundary": right_boundary,
		"current_phase": current_phase,
		"target_found": target_found,
		"target_found_index": target_found_index,
		"mistakes": mistake_counter,
		"correct": correct_moves
	}
	undo_stack.append(state)

func _restore_state(state: Dictionary) -> void:
	main_array = state["array"].duplicate()
	revealed_indices = state["revealed"].duplicate()
	discarded_indices = state["discarded"].duplicate()
	current_mid_index = state["current_mid"]
	left_boundary = state["left_boundary"]
	right_boundary = state["right_boundary"]
	current_phase = state["current_phase"]
	target_found = state["target_found"]
	target_found_index = state["target_found_index"]
	mistake_counter = state["mistakes"]
	correct_moves = state["correct"]
	
	_rebuild_blocks_from_array()
	
	# Restore revealed and discarded states
	for i in range(block_nodes.size()):
		block_nodes[i].hide_number(not revealed_indices[i])
		if discarded_indices[i]:
			block_nodes[i].modulate = Color(0.5, 0.5, 0.5, 0.7)
		elif target_found and i == target_found_index:
			block_nodes[i].modulate = Color(1, 0.8, 0, 1)
			block_nodes[i].scale = Vector2(1.1, 1.1)
		else:
			block_nodes[i].modulate = Color.WHITE
	
	# Restore current selection visual
	if current_mid_index >= 0 and not target_found:
		_update_current_highlight(current_mid_index)
	
	_update_target_label()
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

# ==============================================
#   PROCESS & TIMER
# ==============================================

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
		"discarded": discarded_indices.duplicate(),
		"current_mid": current_mid_index,
		"left_boundary": left_boundary,
		"right_boundary": right_boundary,
		"current_phase": current_phase,
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
		"discarded": discarded_indices.duplicate(),
		"current_mid": current_mid_index,
		"left_boundary": left_boundary,
		"right_boundary": right_boundary,
		"current_phase": current_phase,
		"target_found": target_found,
		"target_found_index": target_found_index,
		"mistakes": mistake_counter,
		"correct": correct_moves
	})
	
	_restore_state(state)

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
	
	_start_assessment_mode()
	await get_tree().process_frame
	_update_undo_redo_buttons()

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
	if has_completed_assessment:
		return
	
	has_completed_assessment = true
	completion_type = reason
	
	# Kill any animations but DON'T clear the blocks/state
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	timer_running = false
	tiktak_sound.stop()
	
	# REVEAL ALL BLOCKS - regardless of pass/fail
	for i in range(block_nodes.size()):
		if not revealed_indices[i]:
			_reveal_block(i)  # Show the number
		# If block is discarded but number not shown, reveal it too
		if discarded_indices[i] and not revealed_indices[i]:
			_reveal_block(i)
	
	# Disable all interactive buttons but leave blocks visible
	if sort_btn:
		sort_btn.disabled = true
	if auto_btn:
		auto_btn.disabled = true
	if match_btn:
		match_btn.disabled = true
	if discard_left_btn:
		discard_left_btn.disabled = true
	if discard_right_btn:
		discard_right_btn.disabled = true
	
	# Stop any block animations but keep their revealed/discarded state
	for block in block_nodes:
		if block.has_meta("pulse_tween"):
			var tween = block.get_meta("pulse_tween")
			if tween and tween.is_running():
				tween.kill()
		# Don't reset block visuals - keep them as they are
	
	if reason == "timeout":
		_show_result_popup("FAIL")
	else:
		var grade = _compute_grade()
		var result = "PASS" if grade["passed"] else "FAIL"
		_show_result_popup(result, grade)
		
func _on_back_result_pressed():
	btn_sound.play()
	result_popup.hide()
	# DO NOT reset the game - just close the popup so player can review
	
	# Ensure buttons are disabled since game is over
	if sort_btn:
		sort_btn.disabled = true
	if auto_btn:
		auto_btn.disabled = true
	if match_btn:
		match_btn.disabled = true
	if discard_left_btn:
		discard_left_btn.disabled = true
	if discard_right_btn:
		discard_right_btn.disabled = true
	
	# Show code button if passed (already handled in _show_result_popup)

func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	# Small delay to ensure popup is hidden before showing code viewer
	await get_tree().process_frame
	_show_cpp_popup()

func _show_result_popup(result: String, grade_data: Dictionary = {}) -> void:
	if not result_popup:
		return
	
	if complete_popup and complete_popup.visible:
		complete_popup.hide()
	
	if result == "PASS":
		result_title.text = "PASSED!"
		result_title.modulate = Color(0, 1, 0)
		
		# Show translate code button only on PASS
		if translate_code_btn:
			translate_code_btn.show()
		
		# Show CppCodeButton (direct child of root) only on PASS
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")
		
		try_again_button.visible = false
	else:
		result_title.text = "FAILED!"
		result_title.modulate = Color(1, 0, 0)
		
		# Hide translate code button on FAIL
		if translate_code_btn:
			translate_code_btn.hide()
		
		# Hide CppCodeButton on FAIL
		if cpp_code_button:
			cpp_code_button.hide()
		
		try_again_button.visible = true
	
	# Update timeline one last time to include all reveals
	_update_timeline_display()
	
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

# ==============================================
#   CODE VISUALIZER & TUTORIAL LOGIC
# ==============================================

func _connect_language_buttons():
	if cpp_lang_btn: cpp_lang_btn.pressed.connect(func(): _set_language("cpp"))
	if python_lang_btn: python_lang_btn.pressed.connect(func(): _set_language("python"))
	if java_lang_btn: java_lang_btn.pressed.connect(func(): _set_language("java"))
	if c_lang_btn: c_lang_btn.pressed.connect(func(): _set_language("c"))

func _set_language(lang: String):
	btn_sound.play()
	current_code_language = lang
	_show_cpp_popup()

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	if complete_popup: complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

func _show_cpp_popup() -> void:
	var code = ""
	var arr_str = ", ".join(main_array.map(func(x): return str(x)))
	
	match current_code_language:
		"cpp":
			code = get_cpp_binary_code(arr_str, target_value)
			current_tutorial_data = cpp_tutorial_data
		"python":
			code = get_python_binary_code(arr_str, target_value)
			current_tutorial_data = python_tutorial_data
		"java":
			code = get_java_binary_code(arr_str, target_value)
			current_tutorial_data = java_tutorial_data
		"c":
			code = get_c_binary_code(arr_str, target_value)
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
		var arr_str = ", ".join(main_array.map(func(x): return str(x)))
		
		match current_code_language:
			"cpp": base_code = get_cpp_binary_code(arr_str, target_value)
			"python": base_code = get_python_binary_code(arr_str, target_value)
			"java": base_code = get_java_binary_code(arr_str, target_value)
			"c": base_code = get_c_binary_code(arr_str, target_value)

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

func get_cpp_binary_code(arr: String, target: int) -> String:
	return """/* Binary Search - Time Complexity: O(log n) */
#include <iostream>
using namespace std;

int binarySearch(int arr[], int left, int right, int target) {
	while (left <= right) {
		int mid = left + (right - left) / 2;  // Avoid overflow
		
		if (arr[mid] == target)
			return mid;
		
		if (arr[mid] < target)
			left = mid + 1;  // Discard left half
		else
			right = mid - 1; // Discard right half
	}
	return -1;  // Not found
}

int main() {
	int arr[] = { %s };
	int n = sizeof(arr) / sizeof(arr[0]);
	int target = %d;
	int result = binarySearch(arr, 0, n - 1, target);
	
	if (result != -1)
		cout << "Element found at index: " << result;
	else
		cout << "Element not found";
	return 0;
}""" % [arr, target]

func get_python_binary_code(arr: String, target: int) -> String:
	return """# Binary Search - Time Complexity: O(log n)
def binary_search(arr, target):
	left, right = 0, len(arr) - 1
	
	while left <= right:
		mid = (left + right) // 2  # Integer division
		
		if arr[mid] == target:
			return mid
		elif arr[mid] < target:
			left = mid + 1  # Discard left
		else:
			right = mid - 1  # Discard right
	
	return -1  # Not found

arr = [%s]
target = %d
result = binary_search(arr, target)
if result != -1:
	print(f"Element found at index: {result}")
else:
	print("Element not found")""" % [arr, target]

func get_java_binary_code(arr: String, target: int) -> String:
	return """/* Binary Search - Time Complexity: O(log n) */
class BinarySearch {
	static int search(int arr[], int target) {
		int left = 0, right = arr.length - 1;
		
		while (left <= right) {
			int mid = left + (right - left) / 2;
			
			if (arr[mid] == target)
				return mid;
			
			if (arr[mid] < target)
				left = mid + 1;
			else
				right = mid - 1;
		}
		return -1;
	}
	
	public static void main(String args[]) {
		int arr[] = {%s};
		int target = %d;
		int result = search(arr, target);
		
		if (result != -1)
			System.out.println("Found at index: " + result);
		else
			System.out.println("Not found");
	}
}""" % [arr, target]

func get_c_binary_code(arr: String, target: int) -> String:
	return """/* Binary Search - Time Complexity: O(log n) */
#include <stdio.h>

int binarySearch(int arr[], int left, int right, int target) {
	while (left <= right) {
		int mid = left + (right - left) / 2;
		
		if (arr[mid] == target)
			return mid;
		
		if (arr[mid] < target)
			left = mid + 1;
		else
			right = mid - 1;
	}
	return -1;
}

int main() {
	int arr[] = {%s};
	int target = %d;
	int result = binarySearch(arr, 0, 5, target);
	
	if (result != -1)
		printf("Found at index: %d", result);
	else
		printf("Not found");
	return 0;
}""" % [arr, target]

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
			"text": "Press this when the current middle element equals the target",
			"action": "highlight"
		},
		{
			"node": discard_left_btn,
			"title": "DISCARD LEFT",
			"text": "Press this when the current middle is LESS than the target (search right)",
			"action": "highlight"
		},
		{
			"node": discard_right_btn,
			"title": "DISCARD RIGHT",
			"text": "Press this when the current middle is GREATER than the target (search left)",
			"action": "highlight"
		},
		{
			"node": sort_btn,
			"title": "UNDO",
			"text": "Reverses your last action (mid pick or discard decision)",
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
	
	# CRITICAL: Sort the array for binary search
	arr.sort()
	
	config_elements_modal.hide()
	_set_main_ui_enabled(true)
	help_btn.show()
	
	# Select random target from custom array
	target_value = arr[randi() % arr.size()]
	_initialize_with_elements(arr)
	
	# Update target label
	_update_target_label()

func _on_config_no_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	var count = randi_range(5, 7)
	var arr: Array[int] = []
	for i in count: arr.append(randi_range(1, 99))
	
	# CRITICAL: Sort the array for binary search
	arr.sort()
	
	_set_main_ui_enabled(true)
	help_btn.show()
	
	# Select random target from generated array
	target_value = arr[randi() % arr.size()]
	_initialize_with_elements(arr)
	
	# Update target label
	_update_target_label()

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
	if discard_left_btn: discard_left_btn.disabled = not enabled
	if discard_right_btn: discard_right_btn.disabled = not enabled

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
	_show_config_modal()

func _on_no_pressed():
	sim_confirmation.hide()

func _on_help_button_pressed():
	btn_sound.play()
	start_tutorial()
