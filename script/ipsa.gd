extends Control

# --- COMPILER INTEGRATION ---
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = $CppPopup/VBoxContainer/HBoxContainer2/CompileButton

# --- MAIN BUTTONS ---
@onready var undo_btn: Button = $VBoxContainer/SortButton  # Repurposed as UNDO
@onready var redo_btn: Button = $VBoxContainer/WaitingElements  # Repurposed as REDO
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
@onready var formula_label: RichTextLabel = $FormulaLabel

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
@onready var slot_a_highlight: ColorRect = $SlotAHighlight
@onready var slot_b_highlight: ColorRect = $SlotBHighlight

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
@onready var help_btn: Button = $HelpButton
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
@onready var time_up_try_again_btn: Button = $TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/TryAgainButton
@onready var time_up_back_btn: Button = $TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/BackButton
@onready var try_again_btn_root: Button = $TryAgainButton
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

# --- TOPIC IDENTIFICATION (ADDED) ---

# --- INTERPOLATION SEARCH VARIABLES ---
var main_array: Array[int] = []
var initial_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []

var target_value: int = 0
var slot_a_index: int = -1  # Low index
var slot_b_index: int = -1  # High index
var current_pos_index: int = -1  # Calculated position
var revealed_indices: Array[bool] = []  # Track which blocks are revealed
var discarded_indices: Array[bool] = []  # Track which blocks are discarded (greyed out)
var target_found: bool = false
var target_found_index: int = -1

# Search space boundaries
var left_boundary: int = 0
var right_boundary: int = 0

# Phase tracking
enum InterpolationPhase { SELECT_SLOT_A, SELECT_SLOT_B, CALCULATE_POS, DECISION }
var current_phase: InterpolationPhase = InterpolationPhase.SELECT_SLOT_A

# Move history tracking
var slot_history: Array[Dictionary] = []
var pos_pick_history: Array[Dictionary] = []
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

# Intro Text - Updated for Interpolation Search
var intro_texts = [
	"""WELCOME TO INTERPOLATION SEARCH SIMULATION! 🔍
Interpolation Search is an improved Binary Search that works on SORTED and UNIFORMLY DISTRIBUTED arrays:
It estimates the position of the target using a formula. Time Complexity: O(log log n) average, O(n) worst case. Like looking up a word in a dictionary - you estimate where it might be!
""","""
Your task: Find the target by selecting boundaries and using the estimation formula!""",

	"""PHASE 1 - SELECT SLOTS (The Workbench) 🛠️
First, you need to load the variables for the formula:

• SLOT A (Low): Must be the LEFTMOST active (non-discarded) block
• SLOT B (High): Must be the RIGHTMOST active (non-discarded) block

""","""The target label will guide you which slot to select:
- "SELECT SLOT A (LOW)" → Pick the leftmost block
- "SELECT SLOT B (HIGH)" → Pick the rightmost block
✓ CORRECT: Picking the correct boundary blocks
✗ BAD: Picking discarded blocks or wrong boundaries""",

	"""PHASE 2 - THE FORMULA 🧮

Once both slots are selected, the formula calculates the estimated position:

pos = low + ⌊(target - arr[low]) × (high - low) ÷ (arr[high] - arr[low])⌋

""","""The formula label shows:
• The formula with current values substituted
• The calculated position result

You must tap the block at the CALCULATED POSITION to reveal it.
If you tap the wrong block, it counts as a mistake and nothing reveals!""",

	"""PHASE 3 - DECISION 🎯
After revealing the estimated position, decide:
• MATCH: If revealed value EQUALS target → YOU WIN!
• DISCARD LEFT: If revealed value < target → Discard left half
• DISCARD RIGHT: If revealed value > target → Discard right half

""","""✓ CORRECT: Choosing the right action based on comparison
✗ BAD: Wrong direction or matching when not equal

EDGE CASE: If arr[low] == arr[high] and not target → Target not in array!""",

"""DIFFICULTY LEVELS:
EASY: No timer, 4-5 elements
MEDIUM: 90 seconds, 7 elements
HARD: 60 seconds, 10 elements

Remember: The array is SORTED and UNIFORMLY DISTRIBUTED!"""
]

# --- CODE TUTORIAL DATA (Updated for Interpolation Search) ---
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

# 1. C++ DATA (Interpolation Search)
var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Function Definition:\nTakes sorted array and target." },
	{ "lines": [2], "text": "2. While Loop:\nContinue while in range and values allow estimation." },
	{ "lines": [3, 4], "text": "3. Interpolation Formula:\nEstimate position using value distribution." },
	{ "lines": [5, 6], "text": "4. Target Found:\nIf estimated position equals target, return." },
	{ "lines": [7, 8], "text": "5. Adjust Range:\nUpdate boundaries based on comparison." },
	{ "lines": [9, 10], "text": "6. Not Found:\nReturn -1 if target not in array." }
]

# 2. PYTHON DATA (Interpolation Search)
var python_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Function Definition:\nTakes sorted array and target." },
	{ "lines": [2], "text": "2. While Loop:\nContinue while in range." },
	{ "lines": [3, 4], "text": "3. Interpolation Formula:\nEstimate position." },
	{ "lines": [5, 6], "text": "4. Target Found:\nReturn index if match." },
	{ "lines": [7, 8], "text": "5. Adjust Range:\nUpdate boundaries." }
]

# 3. JAVA DATA (Interpolation Search)
var java_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Method Signature:\nStatic method returning integer index." },
	{ "lines": [2], "text": "2. While Loop:\nContinue while in range." },
	{ "lines": [3, 4], "text": "3. Interpolation Formula:\nCalculate estimated position." },
	{ "lines": [5, 6], "text": "4. Target Found:\nReturn index if match." },
	{ "lines": [7, 8], "text": "5. Adjust Range:\nUpdate boundaries." }
]

# 4. C DATA (Interpolation Search)
var c_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Function:\nReturns index or -1 if not found." },
	{ "lines": [2], "text": "2. While Loop:\nContinue while in range." },
	{ "lines": [3, 4], "text": "3. Interpolation Formula:\nEstimate position." },
	{ "lines": [5, 6], "text": "4. Target Found:\nReturn index if match." },
	{ "lines": [7, 8], "text": "5. Adjust Range:\nUpdate boundaries." }
]

enum SimMode { LECTURE, ASSESSMENT }
var sim_mode: SimMode = SimMode.ASSESSMENT
var difficulty: int = 2  # Will be overridden by Global

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

# ==============================================
#   SCREEN ORIENTATION MANAGEMENT (ADDED)
# ==============================================
func _enter_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	await get_tree().process_frame
	await get_tree().process_frame
	var current_size = get_viewport().get_visible_rect().size
	if current_size.y > current_size.x:
		get_tree().root.content_scale_size = Vector2i(int(current_size.y), int(current_size.x))
		
func _exit_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_PORTRAIT)
	 

func _get_array_size() -> int:
	match difficulty:
		1: return 4
		2: return 7
		3: return 10
	return 7

func _get_time_limit() -> float:
	match difficulty:
		1: return 0.0   # Easy - No timer
		2: return 90.0   # Medium - 90 seconds
		3: return 60.0   # Hard - 60 seconds
	return 90.0

# ==============================================
#   READY & INITIALIZATION (UPDATED)
# ==============================================
func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	# ADDED: Get difficulty from Global
	difficulty = Global.current_difficulty
	if difficulty == 0:
		difficulty = 2  # fallback to medium if not set
	
	# Setup audio
	tiktak_sound = AudioStreamPlayer.new()
	tiktak_sound.stream = TIKTAK_SFX
	add_child(tiktak_sound)
	try_again_btn_root.visible = false
	
	print("Program started — initializing Interpolation Search visualizer...")
	randomize()
	
	# Initialize result popup
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
	
	# Setup interpolation search buttons
	if match_btn:
		match_btn.text = "MATCH"
		match_btn.pressed.connect(_on_match_pressed)
	
	if discard_left_btn:
		discard_left_btn.text = "DISCARD LEFT"
		discard_left_btn.pressed.connect(_on_discard_left_pressed)
	
	if discard_right_btn:
		discard_right_btn.text = "DISCARD RIGHT"
		discard_right_btn.pressed.connect(_on_discard_right_pressed)
	
	# Setup highlights
	if current_highlight:
		current_highlight.hide()
		current_highlight.color = Color(0, 1, 0, 0.3)  # Green for calculated pos
	
	if slot_a_highlight:
		slot_a_highlight.hide()
		slot_a_highlight.color = Color(0, 0, 1, 0.3)  # Blue for Slot A
	
	if slot_b_highlight:
		slot_b_highlight.hide()
		slot_b_highlight.color = Color(1, 0, 0, 0.3)  # Red for Slot B
	
	# Setup formula label
	if formula_label:
		formula_label.bbcode_enabled = true
		formula_label.text = "Formula: pos = low + ⌊(target - arr[low]) × (high - low) ÷ (arr[high] - arr[low])⌋"
	
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
	
	if undo_btn: undo_btn.text = "UNDO"
	if redo_btn: redo_btn.text = "REDO"
	
	_start_assessment_mode()
	call_deferred("show_introduction")
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")
	
	_connect_language_buttons()
	
	# ADDED: Connect time up popup buttons
	if time_up_try_again_btn:
		if not time_up_try_again_btn.is_connected("pressed", _on_time_up_try_again_pressed):
			time_up_try_again_btn.pressed.connect(_on_time_up_try_again_pressed)
	if time_up_back_btn:
		if not time_up_back_btn.is_connected("pressed", _on_time_up_back_pressed):
			time_up_back_btn.pressed.connect(_on_time_up_back_pressed)
	
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
		if not try_again_result_btn.is_connected("pressed", _on_try_again_result_pressed):
			try_again_result_btn.pressed.connect(_on_try_again_result_pressed)
	if back_result_btn:
		if not back_result_btn.is_connected("pressed", _on_back_result_pressed):
			back_result_btn.pressed.connect(_on_back_result_pressed)
	if translate_code_btn:
		if not translate_code_btn.is_connected("pressed", _on_translate_code_pressed):
			translate_code_btn.pressed.connect(_on_translate_code_pressed)
	
	# Connect main buttons
	if undo_btn:
		if not undo_btn.is_connected("pressed", _on_undo_pressed):
			undo_btn.pressed.connect(_on_undo_pressed)
	if redo_btn:
		if not redo_btn.is_connected("pressed", _on_redo_pressed):
			redo_btn.pressed.connect(_on_redo_pressed)
	if timeline_btn:
		if not timeline_btn.is_connected("pressed", _on_timeline_pressed):
			timeline_btn.pressed.connect(_on_timeline_pressed)
	if try_again_btn_root:
		if not try_again_btn_root.is_connected("pressed", _on_try_again_root_pressed):
			try_again_btn_root.pressed.connect(_on_try_again_root_pressed)
	
	# Connect help button
	if help_btn:
		if not help_btn.is_connected("pressed", _on_help_button_pressed):
			help_btn.pressed.connect(_on_help_button_pressed)
	
	# Connect intro buttons
	_ensure_connected(intro_next_btn, "pressed", _on_intro_next_pressed)
	_ensure_connected(intro_prev_btn, "pressed", _on_intro_prev_pressed)
	_ensure_connected(intro_skip_btn, "pressed", _on_intro_skip_pressed)
	
	# Connect complete popup buttons
	if complete_ok_btn:
		if not complete_ok_btn.is_connected("pressed", _on_complete_ok_pressed):
			complete_ok_btn.pressed.connect(_on_complete_ok_pressed)
	if show_cpp_btn:
		if not show_cpp_btn.is_connected("pressed", _on_show_cpp_pressed):
			show_cpp_btn.pressed.connect(_on_show_cpp_pressed)
	
	# Connect code popup buttons
	if cpp_close_btn:
		if not cpp_close_btn.is_connected("pressed", _on_cpp_close_pressed):
			cpp_close_btn.pressed.connect(_on_cpp_close_pressed)
	if cpp_code_button:
		if not cpp_code_button.is_connected("pressed", _on_cpp_code_button_pressed):
			cpp_code_button.pressed.connect(_on_cpp_code_button_pressed)
	
	_update_difficulty_label()
	_setup_timeline_popup_for_mobile()
	
	# Setup compiler
	_setup_compiler()

func _ensure_connected(node: Node, sig: String, callable: Callable) -> void:
	if node and not node.is_connected(sig, callable):
		node.connect(sig, callable)

func _setup_timeline_popup_for_mobile():
	if not timeline_popup:
		return
	
	var scroll_container = timeline_popup.find_child("ScrollContainer", true, false)
	if scroll_container:
		scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
		scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		scroll_container.mouse_filter = Control.MOUSE_FILTER_STOP

# ==============================================
#   ASSESSMENT START (UPDATED)
# ==============================================
func _start_assessment_mode():
	# ADDED: Reset cache for new assessment
	reset_cache_for_scene()
	
	try_again_btn_root.visible = false
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
	
	# Hide code button initially
	if cpp_code_button:
		cpp_code_button.hide()
	
	# Kill any existing animations
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	# Reset timer FIRST
	assessment_time_limit = _get_time_limit()
	time_remaining = assessment_time_limit
	
	# Set clock based on difficulty
	if difficulty == 1:
		timer_label.hide()
		clock.visible = false
		clock.modulate = Color(1,1,1,0)
		clock.stop()
		timer_running = false  # Easy mode - no timer
	else:
		timer_label.show()
		clock.visible = true
		clock.modulate = Color(1, 1, 1, 1)
		clock.stop()  # Don't play yet - wait for intro
		timer_running = false  # Start false, will be enabled after intro

	# Reset all tracking variables
	mistake_counter = 0
	correct_moves = 0
	target_found = false
	target_found_index = -1
	slot_a_index = -1
	slot_b_index = -1
	current_pos_index = -1
	current_phase = InterpolationPhase.SELECT_SLOT_A
	
	revealed_indices.clear()
	discarded_indices.clear()
	slot_history.clear()
	pos_pick_history.clear()
	decision_history.clear()
	
	# Hide all highlights
	if current_highlight:
		current_highlight.hide()
	if slot_a_highlight:
		slot_a_highlight.hide()
	if slot_b_highlight:
		slot_b_highlight.hide()
	
	# Reset formula label
	if formula_label:
		formula_label.text = "Formula: pos = low + ⌊(target - arr[low]) × (high - low) ÷ (arr[high] - arr[low])⌋"
	
	# Reset any lingering block animations
	for block in block_nodes:
		if block.has_meta("compare_animation"):
			var anim = block.get_meta("compare_animation")
			if anim and anim.is_running():
				anim.kill()
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
	
	var size: int = _get_array_size()
	var arr: Array[int] = []
	
	# Generate a "mostly uniform" array with controlled variation
	# Start with a base arithmetic sequence, then add small perturbations
	
	var start = randi_range(5, 15)  # Start between 5-15
	var base_step = randi_range(5, 10)  # Base step between 5-10
	
	# Generate base arithmetic sequence - explicitly typed as Array[int]
	var base_arr: Array[int] = []
	for i in range(size):
		base_arr.append(start + i * base_step)
	
	# Add controlled perturbations to make it non-uniform but still sorted
	# We'll add small variations that preserve sorted order
	arr = base_arr.duplicate()  # Now this works since both are Array[int]
	
	# Apply 1-3 random perturbations
	var num_perturbations = randi_range(1, 3)
	for p in range(num_perturbations):
		var perturb_idx = randi_range(1, size - 2)  # Don't perturb ends too much
		var direction = 1 if randi() % 2 == 0 else -1
		var amount = randi_range(1, 3)  # Small perturbation
		
		# Apply perturbation while maintaining sorted order
		var new_val = arr[perturb_idx] + (direction * amount)
		
		# Check bounds and sorted order
		if new_val > arr[perturb_idx - 1] and new_val < arr[perturb_idx + 1] and new_val <= 99:
			arr[perturb_idx] = new_val
	
	# Sort again just to be safe (though perturbations should preserve order)
	arr.sort()
	
	# Ensure last element doesn't exceed 99
	while arr[size - 1] > 99:
		# Reduce the step for the last few elements
		for i in range(size):
			arr[i] = start + i * (base_step - 1)
		break
	
	print("Generated 'mostly uniform' array: ", arr)
	print("Base would have been: ", base_arr)
	
	# Select random target from array
	target_value = arr[randi() % arr.size()]
	
	_initialize_with_elements(arr)
	
	# Show target in target label
	_update_target_label()
	
	if status_label:
		status_label.text = "Phase 1: SELECT SLOT A (LOW) - Tap the LEFTMOST active block"
	
	# Log initial state
	timeline_log.append("[color=cyan]--- Assessment Started ---[/color]")
	timeline_log.append("[color=cyan]Initial sorted array: [%s][/color]" % _array_to_string(main_array))
	timeline_log.append("[color=gold]Target: %d[/color]" % target_value)
	
	_update_undo_redo_buttons()
	_update_difficulty_label()

func _array_to_string(arr: Array) -> String:
	var parts: Array[String] = []
	for v in arr:
		parts.append(str(v))
	return ", ".join(parts)

func _update_target_label():
	if target_label:
		var phase_text = ""
		match current_phase:
			InterpolationPhase.SELECT_SLOT_A:
				phase_text = "SELECT SLOT A (LOW)"
			InterpolationPhase.SELECT_SLOT_B:
				phase_text = "SELECT SLOT B (HIGH)"
			InterpolationPhase.CALCULATE_POS:
				phase_text = "TAP the calculated position (index %d)" % current_pos_index
			InterpolationPhase.DECISION:
				phase_text = "MID = %d | Choose: MATCH, DISCARD LEFT, or DISCARD RIGHT" % main_array[current_pos_index]
		
		target_label.text = "TARGET: %d | %s" % [target_value, phase_text]
		target_label.add_theme_color_override("font_color", Color(1, 0.8, 0, 1))  # Gold color
		target_label.add_theme_font_size_override("font_size", 35)

func _update_formula_label():
	if not formula_label:
		return
	
	if slot_a_index == -1 or slot_b_index == -1:
		formula_label.text = "Formula: pos = low + ⌊(target - arr[low]) × (high - low) ÷ (arr[high] - arr[low])⌋"
		return
	
	var low_val = main_array[slot_a_index]
	var high_val = main_array[slot_b_index]
	
	# Check for denominator zero case
	if high_val == low_val:
		formula_label.text = "[color=red]ERROR: arr[high] == arr[low] → Target not in remaining range![/color]"
		return
	
	var pos = _calculate_interpolation()
	current_pos_index = pos
	
	# Format the formula with current values - JUST TWO LINES
	var formula_text = "pos = low + ⌊(target - arr[low]) × (high - low) ÷ (arr[high] - arr[low])⌋\n"
	formula_text += "[color=yellow]pos = %d + ⌊(%d - %d) × (%d - %d) ÷ (%d - %d)⌋ = %d[/color]" % [
		slot_a_index, target_value, low_val, slot_b_index, slot_a_index, high_val, low_val, pos
	]
	
	formula_label.text = formula_text
	
	# REMOVED ALL SHAKING/ANIMATION CODE - blocks should NOT animate before being tapped
	
	# Just update the highlight position (visual cue, not animation)
	if current_highlight and pos >= 0 and pos < block_nodes.size():
		current_highlight.global_position = block_nodes[pos].global_position - Vector2(5, 5)
		current_highlight.size = block_nodes[pos].size + Vector2(10, 10)
		current_highlight.show()
	
	# Also update status label to guide user
	if status_label:
		status_label.text = "Phase 2: TAP the calculated position block (index %d)" % pos

func _calculate_interpolation() -> int:
	if slot_a_index == -1 or slot_b_index == -1:
		return -1
	
	var low_val = main_array[slot_a_index]
	var high_val = main_array[slot_b_index]
	
	# Handle denominator zero case
	if high_val == low_val:
		return -1
	
	var pos = slot_a_index + floor((target_value - low_val) * (slot_b_index - slot_a_index) / (high_val - low_val))
	return clamp(pos, slot_a_index, slot_b_index)  # Ensure within bounds

func _initialize_with_elements(elements: Array[int]) -> void:
	print("Initializing Sorted Array with:", elements, " Target:", target_value)
	audio_player.play()
	
	main_array = elements.duplicate()
	initial_array = elements.duplicate()
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
		
		# Blocks are NOT draggable in Interpolation Search
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
	
	_apply_discard_visuals()

func _safe_connect(node: Node, signal_name: String, method: Callable):
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
#   INTERPOLATION SEARCH CORE LOGIC
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
	
	match current_phase:
		InterpolationPhase.SELECT_SLOT_A:
			_handle_slot_a_selection(index)
		InterpolationPhase.SELECT_SLOT_B:
			_handle_slot_b_selection(index)
		InterpolationPhase.CALCULATE_POS:
			_handle_pos_selection(index)
		InterpolationPhase.DECISION:
			show_feedback(
				"Now in DECISION phase! Use MATCH or DISCARD buttons",
				Color.ORANGE,
				Vector2(block.global_position.x, START_POSITION.y - 20)
			)
	
	_update_timeline_display()
	_update_ui_labels()
	_update_undo_redo_buttons()

func _handle_slot_a_selection(index: int):
	# Slot A must be the leftmost active (non-discarded) block
	var correct_slot_a = left_boundary
	
	if index == correct_slot_a:
		# Correct slot A selection - REVEAL THE BLOCK
		_reveal_block(index)
		slot_a_index = index
		
		# Add null check for slot_a_highlight
		if slot_a_highlight:
			slot_a_highlight.global_position = block_nodes[index].global_position - Vector2(5, 5)
			slot_a_highlight.size = block_nodes[index].size + Vector2(10, 10)
			slot_a_highlight.show()
		
		correct_moves += 1
		show_feedback(
			"Good! Slot A (LOW) selected and revealed",
			Color.GREEN,
			Vector2(block_nodes[index].global_position.x, START_POSITION.y - 20)
		)
		timeline_log.append(
			"[color=green]Good: Selected and revealed Slot A at index[%d]: %d[/color]" % [index, main_array[index]]
		)
		
		# Track history
		var slot_data = {
			"type": "slot_a",
			"index": index,
			"value": main_array[index],
			"was_correct": true
		}
		slot_history.append(slot_data)
		move_history.append(slot_data)
		
		# Move to next phase
		current_phase = InterpolationPhase.SELECT_SLOT_B
		if status_label:
			status_label.text = "Phase 1: SELECT SLOT B (HIGH) - Tap the RIGHTMOST active block"
		_update_target_label()
	else:
		# Wrong slot A selection - DO NOT reveal
		mistake_counter += 1
		show_feedback(
			"Wrong! Slot A must be the LEFTMOST active block (index %d)" % correct_slot_a,
			Color.RED,
			Vector2(block_nodes[index].global_position.x, START_POSITION.y - 20)
		)
		timeline_log.append(
			"[color=red]Bad: Wrong Slot A selection at index[%d] (should be %d)[/color]" % [index, correct_slot_a]
		)
		
		var slot_data = {
			"type": "slot_a",
			"index": index,
			"value": main_array[index],
			"was_correct": false
		}
		slot_history.append(slot_data)
		move_history.append(slot_data)

func _handle_slot_b_selection(index: int):
	# Slot B must be the rightmost active (non-discarded) block
	var correct_slot_b = right_boundary
	
	if index == correct_slot_b:
		# Correct slot B selection - REVEAL THE BLOCK
		_reveal_block(index)
		slot_b_index = index
		
		# Add null check for slot_b_highlight
		if slot_b_highlight:
			slot_b_highlight.global_position = block_nodes[index].global_position - Vector2(5, 5)
			slot_b_highlight.size = block_nodes[index].size + Vector2(10, 10)
			slot_b_highlight.show()
		
		correct_moves += 1
		show_feedback(
			"Good! Slot B (HIGH) selected and revealed",
			Color.GREEN,
			Vector2(block_nodes[index].global_position.x, START_POSITION.y - 20)
		)
		timeline_log.append(
			"[color=green]Good: Selected and revealed Slot B at index[%d]: %d[/color]" % [index, main_array[index]]
		)
		
		# Track history
		var slot_data = {
			"type": "slot_b",
			"index": index,
			"value": main_array[index],
			"was_correct": true
		}
		slot_history.append(slot_data)
		move_history.append(slot_data)
		
		# Calculate position and move to next phase
		_update_formula_label()
		
		# Check for denominator zero case
		if main_array[slot_a_index] == main_array[slot_b_index]:
			show_feedback(
				"arr[low] == arr[high] → Target not in range!",
				Color.ORANGE,
				get_global_mouse_position()
			)
			# Discard everything
			for i in range(left_boundary, right_boundary + 1):
				discarded_indices[i] = true
				_reveal_block(i)
			_apply_discard_visuals()
			_end_assessment("sorted")
			return
		
		current_phase = InterpolationPhase.CALCULATE_POS
		if status_label:
			status_label.text = "Phase 2: TAP the calculated position block (index %d)" % current_pos_index
		_update_target_label()
		
		# Highlight the calculated position - add null check
		if current_highlight and current_pos_index >= 0 and current_pos_index < block_nodes.size():
			current_highlight.global_position = block_nodes[current_pos_index].global_position - Vector2(5, 5)
			current_highlight.size = block_nodes[current_pos_index].size + Vector2(10, 10)
			current_highlight.show()
	else:
		# Wrong slot B selection - DO NOT reveal
		mistake_counter += 1
		show_feedback(
			"Wrong! Slot B must be the RIGHTMOST active block (index %d)" % correct_slot_b,
			Color.RED,
			Vector2(block_nodes[index].global_position.x, START_POSITION.y - 20)
		)
		timeline_log.append(
			"[color=red]Bad: Wrong Slot B selection at index[%d] (should be %d)[/color]" % [index, correct_slot_b]
		)
		
		var slot_data = {
			"type": "slot_b",
			"index": index,
			"value": main_array[index],
			"was_correct": false
		}
		slot_history.append(slot_data)
		move_history.append(slot_data)

func _handle_pos_selection(index: int):
	if index != current_pos_index:
		mistake_counter += 1
		show_feedback(
			"Wrong! You need to tap the calculated position (index %d)" % current_pos_index,
			Color.RED,
			Vector2(block_nodes[index].global_position.x, START_POSITION.y - 20)
		)
		timeline_log.append(
			"[color=red]Bad: Tapped wrong position at index[%d] (should be %d)[/color]" % [index, current_pos_index]
		)
		
		var pos_data = {
			"type": "pos_pick",
			"index": index,
			"value": main_array[index],
			"was_correct": false
		}
		pos_pick_history.append(pos_data)
		move_history.append(pos_data)
		
		_update_timeline_display()
		_update_ui_labels()
		_update_undo_redo_buttons()
		return
	
	# Correct position tap
	var block = block_nodes[index]
	
	# Reveal the block's number
	_reveal_block(index)
	correct_moves += 1
	
	# Stop any existing animations on ALL blocks first
	for i in range(block_nodes.size()):
		if block_nodes[i].has_meta("compare_animation"):
			var old = block_nodes[i].get_meta("compare_animation")
			if old and old.is_running():
				old.kill()
		block_nodes[i].scale = Vector2(1.0, 1.0)
		if not discarded_indices[i] and i != slot_a_index and i != slot_b_index:
			block_nodes[i].modulate = Color.WHITE
	
	# Stop any existing animation on this specific block
	if block.has_meta("compare_animation"):
		var old_anim = block.get_meta("compare_animation")
		if old_anim and old_anim.is_running():
			old_anim.kill()
	
	# Clean simple looping pulse animation
	var tween = create_tween().set_loops()
	tween.tween_property(block, "scale", Vector2(1.2, 1.2), 0.3)
	tween.tween_property(block, "modulate", Color(1, 1, 0.5, 1), 0.3)
	tween.tween_property(block, "scale", Vector2(1.0, 1.0), 0.3)
	tween.tween_property(block, "modulate", Color.WHITE, 0.3)
	block.set_meta("compare_animation", tween)
	
	show_feedback(
		"Good! Now compare this value with the target",
		Color.GREEN,
		Vector2(block.global_position.x, START_POSITION.y - 20)
	)
	timeline_log.append(
		"[color=green]Good: Tapped calculated position at index[%d]: %d[/color]" % [index, main_array[index]]
	)
	
	var pos_data = {
		"type": "pos_pick",
		"index": index,
		"value": main_array[index],
		"was_correct": true
	}
	pos_pick_history.append(pos_data)
	move_history.append(pos_data)
	
	# Move to decision phase
	current_phase = InterpolationPhase.DECISION
	if status_label:
		status_label.text = "Phase 3: Choose MATCH, DISCARD LEFT, or DISCARD RIGHT"
	_update_target_label()
	_update_timeline_display()
	_update_ui_labels()
	_update_undo_redo_buttons()

func _reveal_block(index: int):
	if index >= 0 and index < block_nodes.size() and not revealed_indices[index]:
		block_nodes[index].hide_number(false)  # Show the number
		revealed_indices[index] = true

func _apply_discard_visuals():
	for i in range(block_nodes.size()):
		if discarded_indices[i]:
			# Make discarded blocks grey and unclickable
			block_nodes[i].modulate = Color(0.5, 0.5, 0.5, 0.7)  # Grey with some transparency
			# Also reveal their numbers if not already revealed
			_reveal_block(i)
		else:
			# Keep non-discarded blocks normal
			if i != current_pos_index and i != slot_a_index and i != slot_b_index:
				block_nodes[i].modulate = Color.WHITE

func _discard_range(discard_left: bool) -> bool:
	# Returns true if discard was correct, false otherwise
	if current_phase != InterpolationPhase.DECISION:
		show_feedback("Not in decision phase!", Color.ORANGE, get_global_mouse_position())
		return false
	
	if current_pos_index == -1:
		show_feedback("No position selected!", Color.ORANGE, get_global_mouse_position())
		return false
	
	var pos_value = main_array[current_pos_index]
	var is_correct: bool
	
	if discard_left:
		# Discard left means pos < target (we want to search right half)
		is_correct = (pos_value < target_value)
	else:
		# Discard right means pos > target (we want to search left half)
		is_correct = (pos_value > target_value)
	
	if is_correct:
		# Correct discard - STOP THE ANIMATION FIRST
		if current_pos_index >= 0 and current_pos_index < block_nodes.size():
			var block = block_nodes[current_pos_index]
			if block.has_meta("compare_animation"):
				var anim = block.get_meta("compare_animation")
				if anim and anim.is_running():
					anim.kill()
			block.scale = Vector2(1.0, 1.0)
			block.modulate = Color.WHITE
		
		if discard_left:
			# Discard everything from left_boundary to current_pos_index
			for i in range(left_boundary, current_pos_index + 1):
				if not discarded_indices[i]:
					discarded_indices[i] = true
					_reveal_block(i)
			# Update left boundary
			left_boundary = current_pos_index + 1
			show_feedback("Correct! Discarding left half", Color.GREEN, get_global_mouse_position())
			timeline_log.append(
				"[color=green]Good: Discarded left (pos %d < target %d)[/color]" % [pos_value, target_value]
			)
		else:
			# Discard everything from current_pos_index to right_boundary
			for i in range(current_pos_index, right_boundary + 1):
				if not discarded_indices[i]:
					discarded_indices[i] = true
					_reveal_block(i)
			# Update right boundary
			right_boundary = current_pos_index - 1
			show_feedback("Correct! Discarding right half", Color.GREEN, get_global_mouse_position())
			timeline_log.append(
				"[color=green]Good: Discarded right (pos %d > target %d)[/color]" % [pos_value, target_value]
			)
		
		correct_moves += 1
		
		# Track history
		var decision_data = {
			"type": "discard",
			"discard_left": discard_left,
			"pos_index": current_pos_index,
			"pos_value": pos_value,
			"was_correct": true
		}
		decision_history.append(decision_data)
		move_history.append(decision_data)
		
		# Hide highlights
		if current_highlight:
			if current_highlight.has_meta("pulse_tween"):
				var tween = current_highlight.get_meta("pulse_tween")
				if tween and tween.is_running():
					tween.kill()
			current_highlight.hide()
		
		if slot_a_highlight:
			slot_a_highlight.hide()
		if slot_b_highlight:
			slot_b_highlight.hide()
		
		# Reset slots for next iteration
		slot_a_index = -1
		slot_b_index = -1
		current_pos_index = -1
		
		# Apply visual changes
		_apply_discard_visuals()
		
		# Check if search space is empty
		if left_boundary > right_boundary:
			show_feedback("Search space empty! Target not found?", Color.ORANGE, get_global_mouse_position())
			_end_assessment("sorted")
			return true
		
		# Check if we've narrowed down to a single element
		if left_boundary == right_boundary:
			# Single element left - auto-reveal and check if it's the target
			_reveal_block(left_boundary)
			if main_array[left_boundary] == target_value:
				# Found the target!
				target_found = true
				target_found_index = left_boundary
				block_nodes[left_boundary].modulate = Color(1, 0.8, 0, 1)
				show_feedback(
					"Target found at index %d!" % left_boundary,
					Color(1, 0.8, 0, 1),
					block_nodes[left_boundary].global_position
				)
				timeline_log.append(
					"[color=gold]SUCCESS: Target %d found at index[%d]![/color]" % [target_value, left_boundary]
				)
				_end_assessment("sorted")
				return true
			else:
				# Single element but not target - not possible since target is in array
				show_feedback("Error: Target should be in array!", Color.RED, get_global_mouse_position())
				_end_assessment("sorted")
				return true
		
		# IMPORTANT: Reset to SELECT_SLOT_A phase for the new range
		current_phase = InterpolationPhase.SELECT_SLOT_A
		if status_label:
			status_label.text = "Phase 1: SELECT SLOT A (LOW) - Tap the LEFTMOST active block"
		_update_target_label()
		_update_formula_label()
		
		return true
	else:
		# Wrong discard
		mistake_counter += 1
		
		var feedback_msg = ""
		if discard_left:
			feedback_msg = "Wrong! Can't discard left because pos %d is NOT < target %d" % [pos_value, target_value]
		else:
			feedback_msg = "Wrong! Can't discard right because pos %d is NOT > target %d" % [pos_value, target_value]
		
		show_feedback(feedback_msg, Color.RED, get_global_mouse_position())
		timeline_log.append(
			"[color=red]Bad: Wrong discard decision (pos %d, target %d)[/color]" % [pos_value, target_value]
		)
		
		# Track history
		var decision_data = {
			"type": "discard",
			"discard_left": discard_left,
			"pos_index": current_pos_index,
			"pos_value": pos_value,
			"was_correct": false
		}
		decision_history.append(decision_data)
		move_history.append(decision_data)
		
		return false

func _on_match_pressed():
	btn_sound.play()
	
	if target_found:
		show_feedback("Target already found!", Color.ORANGE, get_global_mouse_position())
		return
	
	if current_phase != InterpolationPhase.DECISION:
		show_feedback("Not in decision phase! Complete previous steps first", Color.ORANGE, get_global_mouse_position())
		return
	
	if current_pos_index == -1:
		show_feedback("No position selected!", Color.ORANGE, get_global_mouse_position())
		return
	
	# Save state for undo
	_save_state()
	redo_stack.clear()
	
	var index = current_pos_index
	var value = main_array[index]
	var is_match = (value == target_value)
	
	# STOP THE ANIMATION on the current block
	if index >= 0 and index < block_nodes.size():
		var block = block_nodes[index]
		if block.has_meta("compare_animation"):
			var anim = block.get_meta("compare_animation")
			if anim and anim.is_running():
				anim.kill()
		block.scale = Vector2(1.0, 1.0)
		# Keep the block's modulate as normal (it's already revealed)
		if not target_found:
			block.modulate = Color.WHITE
	
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
		
		# Hide highlights
		if current_highlight:
			if current_highlight.has_meta("pulse_tween"):
				var tween = current_highlight.get_meta("pulse_tween")
				if tween and tween.is_running():
					tween.kill()
			current_highlight.hide()
		if slot_a_highlight:
			slot_a_highlight.hide()
		if slot_b_highlight:
			slot_b_highlight.hide()
		
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
		var block = block_nodes[index]
		var tween = create_tween().set_loops()
		tween.tween_property(block, "scale", Vector2(1.15, 1.15), 0.4)
		tween.tween_property(block, "scale", Vector2(1.0, 1.0), 0.4)
		block.set_meta("compare_animation", tween)
		
		# Wrong match - we stay in DECISION phase, but the animation is stopped
		# The block remains revealed but not animating
		if status_label:
			status_label.text = "Wrong match! Try DISCARD LEFT or DISCARD RIGHT"
	
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
		"slot_a": slot_a_index,
		"slot_b": slot_b_index,
		"current_pos": current_pos_index,
		"left_boundary": left_boundary,
		"right_boundary": right_boundary,
		"current_phase": current_phase,
		"target_found": target_found,
		"target_found_index": target_found_index,
		"mistakes": mistake_counter,
		"correct": correct_moves,
		"timeline": timeline_log.duplicate()  # ADDED: Save timeline
	}
	undo_stack.append(state)

func _restore_state(state: Dictionary) -> void:
	main_array = state["array"].duplicate()
	revealed_indices = state["revealed"].duplicate()
	discarded_indices = state["discarded"].duplicate()
	slot_a_index = state["slot_a"]
	slot_b_index = state["slot_b"]
	current_pos_index = state["current_pos"]
	left_boundary = state["left_boundary"]
	right_boundary = state["right_boundary"]
	current_phase = state["current_phase"]
	target_found = state["target_found"]
	target_found_index = state["target_found_index"]
	mistake_counter = state["mistakes"]
	correct_moves = state["correct"]
	timeline_log = state.get("timeline", timeline_log).duplicate()  # ADDED: Restore timeline
	
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
	
	# Restore highlights - add null checks
	if slot_a_highlight and slot_a_index >= 0 and not target_found:
		slot_a_highlight.global_position = block_nodes[slot_a_index].global_position - Vector2(5, 5)
		slot_a_highlight.size = block_nodes[slot_a_index].size + Vector2(10, 10)
		slot_a_highlight.show()
	
	if slot_b_highlight and slot_b_index >= 0 and not target_found:
		slot_b_highlight.global_position = block_nodes[slot_b_index].global_position - Vector2(5, 5)
		slot_b_highlight.size = block_nodes[slot_b_index].size + Vector2(10, 10)
		slot_b_highlight.show()
	
	if current_highlight and current_pos_index >= 0 and not target_found:
		current_highlight.global_position = block_nodes[current_pos_index].global_position - Vector2(5, 5)
		current_highlight.size = block_nodes[current_pos_index].size + Vector2(10, 10)
		current_highlight.show()
	
	_update_target_label()
	if slot_a_index >= 0 and slot_b_index >= 0:
		_update_formula_label()
	else:
		if formula_label:
			formula_label.text = "Formula: pos = low + ⌊(target - arr[low]) × (high - low) ÷ (arr[high] - arr[low])⌋"
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
#   PROCESS & TIMER (UPDATED)
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
	
	# Update timer display
	_update_timer_display()
	
	if time_remaining <= 10.0 and timer_running:
		if not tiktak_sound.playing:
			tiktak_sound.play()

func _update_timer_display():
	if not timer_label:
		return
	var total_seconds: int = int(time_remaining)
	var minutes: int = total_seconds / 60
	var seconds: int = total_seconds % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

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
#   UNDO/REDO FUNCTIONS (UPDATED)
# ==============================================

func _on_undo_pressed() -> void:  # Undo
	if not _can_undo():
		return
	
	if undo_stack.is_empty():
		return
	
	btn_sound.play()
	
	# Save current state to redo
	redo_stack.append({
		"array": main_array.duplicate(),
		"revealed": revealed_indices.duplicate(),
		"discarded": discarded_indices.duplicate(),
		"slot_a": slot_a_index,
		"slot_b": slot_b_index,
		"current_pos": current_pos_index,
		"left_boundary": left_boundary,
		"right_boundary": right_boundary,
		"current_phase": current_phase,
		"target_found": target_found,
		"target_found_index": target_found_index,
		"mistakes": mistake_counter,
		"correct": correct_moves,
		"timeline": timeline_log.duplicate()
	})
	
	# Restore previous state
	var state = undo_stack.pop_back()
	_restore_state(state)
	
	timeline_log.append("[color=gray]↩ Undo[/color]")
	_update_timeline_display()
	_update_undo_redo_buttons()
	_update_ui_labels()

func _on_redo_pressed() -> void:  # Redo
	if not _can_redo():
		return
	
	if redo_stack.is_empty():
		return
	
	btn_sound.play()
	
	# Save current state to undo
	undo_stack.append({
		"array": main_array.duplicate(),
		"revealed": revealed_indices.duplicate(),
		"discarded": discarded_indices.duplicate(),
		"slot_a": slot_a_index,
		"slot_b": slot_b_index,
		"current_pos": current_pos_index,
		"left_boundary": left_boundary,
		"right_boundary": right_boundary,
		"current_phase": current_phase,
		"target_found": target_found,
		"target_found_index": target_found_index,
		"mistakes": mistake_counter,
		"correct": correct_moves,
		"timeline": timeline_log.duplicate()
	})
	
	# Restore next state
	var state = redo_stack.pop_back()
	_restore_state(state)
	
	timeline_log.append("[color=gray]↪ Redo[/color]")
	_update_timeline_display()
	_update_undo_redo_buttons()
	_update_ui_labels()

func _can_undo() -> bool:
	if target_found or has_completed_assessment:
		return false
	if difficulty == 3:
		return false
	return not undo_stack.is_empty()

func _can_redo() -> bool:
	if target_found or has_completed_assessment:
		return false
	if difficulty == 3:
		return false
	return not redo_stack.is_empty()

func _update_undo_redo_buttons():
	if not undo_btn or not redo_btn:
		return
	
	var undo_allowed = _can_undo()
	var redo_allowed = _can_redo()
	
	undo_btn.disabled = not undo_allowed
	redo_btn.disabled = not redo_allowed
	
	# Visual feedback
	if undo_btn.disabled:
		undo_btn.modulate = Color(0.5, 0.5, 0.5, 0.5)
	else:
		undo_btn.modulate = Color(1, 1, 1, 1)
		
	if redo_btn.disabled:
		redo_btn.modulate = Color(0.5, 0.5, 0.5, 0.5)
	else:
		redo_btn.modulate = Color(1, 1, 1, 1)

func _update_difficulty_label():
	if not difficulty_label:
		return
	match difficulty:
		1: difficulty_label.text = "Difficulty: Easy"
		2: difficulty_label.text = "Difficulty: Medium"
		3: difficulty_label.text = "Difficulty: Hard "

# ==============================================
#   ASSESSMENT & GRADING (UPDATED with DB)
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
	
	return {
		"passed": passed,
		"accuracy": accuracy,
		"total_moves": total_moves,
		"correct_moves": correct_moves,
		"mistake_counter": mistake_counter,
		"time_used": time_used,
		"coins": 0,  # Will be overwritten if passed
		"required": required_threshold
	}

func _end_assessment(reason: String) -> void:
	if has_completed_assessment:
		return
	
	has_completed_assessment = true
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
		# If block is discarded but number not shown, reveal it too
		if discarded_indices[i] and not revealed_indices[i]:
			_reveal_block(i)
	
	# Disable all interactive buttons but leave blocks visible
	if undo_btn:
		undo_btn.disabled = true
	if redo_btn:
		redo_btn.disabled = true
	if match_btn:
		match_btn.disabled = true
	if discard_left_btn:
		discard_left_btn.disabled = true
	if discard_right_btn:
		discard_right_btn.disabled = true
	
	# Stop any block animations but keep their revealed/discarded state
	for block in block_nodes:
		if block.has_meta("compare_animation"):
			var anim = block.get_meta("compare_animation")
			if anim and anim.is_running():
				anim.kill()
		if block.has_meta("pulse_tween"):
			var tween = block.get_meta("pulse_tween")
			if tween and tween.is_running():
				tween.kill()
		# Don't reset block visuals - keep them as they are
	
	# Log completion
	timeline_log.append("[color=orange]--- Assessment Ended: %s ---[/color]" % reason.to_upper())
	_update_timeline_display()
	
	# FIXED: Database integration - record attempt always, complete level only on pass
	if reason == "timeout":
		DB.record_attempt(Global.current_topic, difficulty)
		_show_result_popup("FAIL", {})
		if time_up_popup:
			time_up_popup.popup_centered()
	else:
		var grade = _compute_grade()
		if grade["passed"]:
			# complete_level handles attempts internally
			coins_earned = DB.complete_level(Global.current_topic, difficulty)
			grade["coins"] = coins_earned
		else:
			DB.record_attempt(Global.current_topic, difficulty)
		_show_result_popup("PASS" if grade["passed"] else "FAIL", grade)

func _show_result_popup(result: String, grade_data: Dictionary = {}) -> void:
	if not result_popup:
		return
	
	if complete_popup and complete_popup.visible:
		complete_popup.hide()
	
	# Configure result popup based on outcome
	if result == "PASS":
		result_title.text = "PASSED!"
		result_title.modulate = Color(0, 1, 0)
		
		# Show translate code button only on PASS
		if translate_code_btn:
			translate_code_btn.show()
		
		# Show CppCodeButton only on PASS
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")
		
		try_again_btn_root.visible = false
	else:
		result_title.text = "FAILED!"
		result_title.modulate = Color(1, 0, 0)
		
		# Hide translate code button on FAIL
		if translate_code_btn:
			translate_code_btn.hide()
		
		# Hide CppCodeButton on FAIL
		if cpp_code_button:
			cpp_code_button.hide()
		
		try_again_btn_root.visible = true
	
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
		
		# ADDED: Ensure code buttons are hidden on timeout
		if translate_code_btn:
			translate_code_btn.hide()
		if cpp_code_button:
			cpp_code_button.hide()
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
#   TRY AGAIN FUNCTIONS (FIXED - Simplified)
# ==============================================

func _on_try_again_result_pressed():
	btn_sound.play()
	result_popup.hide()
	if time_up_popup and time_up_popup.visible:
		time_up_popup.hide()
	_cleanup_block_animations()
	_start_assessment_mode()
	call_deferred("show_introduction")

func _on_try_again_root_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	if time_up_popup and time_up_popup.visible:
		time_up_popup.hide()
	_cleanup_block_animations()
	_start_assessment_mode()
	call_deferred("show_introduction")

func _on_time_up_try_again_pressed() -> void:
	btn_sound.play()
	if time_up_popup: time_up_popup.hide()
	result_popup.hide()
	_cleanup_block_animations()
	_start_assessment_mode()
	call_deferred("show_introduction")

func _on_back_result_pressed():
	btn_sound.play()
	result_popup.hide()
	# DO NOT reset the game - just close the popup so player can review
	
	# Ensure buttons are disabled since game is over
	if undo_btn:
		undo_btn.disabled = true
	if redo_btn:
		redo_btn.disabled = true
	if match_btn:
		match_btn.disabled = true
	if discard_left_btn:
		discard_left_btn.disabled = true
	if discard_right_btn:
		discard_right_btn.disabled = true

func _on_time_up_back_pressed() -> void:
	btn_sound.play()
	if time_up_popup: time_up_popup.hide()

# ADDED: Helper function to clean up block animations
func _cleanup_block_animations() -> void:
	if current_tween:
		current_tween.kill()
		current_tween = null
	for block in block_nodes:
		if block.has_meta("compare_animation"):
			var anim = block.get_meta("compare_animation")
			if anim and anim.is_running():
				anim.kill()
		if block.has_meta("pulse_tween"):
			var tween = block.get_meta("pulse_tween")
			if tween and tween.is_running():
				tween.kill()
		block.scale = Vector2(1.0, 1.0)
		block.modulate = Color.WHITE

func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	# Small delay to ensure popup is hidden before showing code viewer
	await get_tree().process_frame
	_show_cpp_popup()

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
	var arr_str = ", ".join(initial_array.map(func(x): return str(x)))
	
	match current_code_language:
		"cpp":
			code = get_cpp_interpolation_code(arr_str, target_value)
			current_tutorial_data = cpp_tutorial_data
		"python":
			code = get_python_interpolation_code(arr_str, target_value)
			current_tutorial_data = python_tutorial_data
		"java":
			code = get_java_interpolation_code(arr_str, target_value)
			current_tutorial_data = java_tutorial_data
		"c":
			code = get_c_interpolation_code(arr_str, target_value)
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
			"cpp": base_code = get_cpp_interpolation_code(arr_str, target_value)
			"python": base_code = get_python_interpolation_code(arr_str, target_value)
			"java": base_code = get_java_interpolation_code(arr_str, target_value)
			"c": base_code = get_c_interpolation_code(arr_str, target_value)

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

func get_cpp_interpolation_code(arr: String, target: int) -> String:
	return """/* Interpolation Search - Time Complexity: O(log log n) average */
#include <iostream>
using namespace std;

int interpolationSearch(int arr[], int n, int target) {
	int low = 0, high = n - 1;
	
	while (low <= high && target >= arr[low] && target <= arr[high]) {
		if (low == high) {
			if (arr[low] == target) return low;
			return -1;
		}
		
		// Estimate position using interpolation formula
		int pos = low + ((target - arr[low]) * (high - low) / (arr[high] - arr[low]));
		
		if (arr[pos] == target)
			return pos;
		
		if (arr[pos] < target)
			low = pos + 1;
		else
			high = pos - 1;
	}
	return -1;
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
	
	int result = interpolationSearch(arr, n, target);
	
	if (result != -1)
		cout << "Element found at index: " << result << endl;
	else
		cout << "Element " << target << " not found in the array" << endl;
	
	return 0;
}""" % [arr, target]

func get_python_interpolation_code(arr: String, target: int) -> String:
	return """# Interpolation Search - Time Complexity: O(log log n) average
def interpolation_search(arr, target):
	low, high = 0, len(arr) - 1
	
	while low <= high and target >= arr[low] and target <= arr[high]:
		if low == high:
			return low if arr[low] == target else -1
		
		# Interpolation formula
		pos = low + ((target - arr[low]) * (high - low) // (arr[high] - arr[low]))
		
		if arr[pos] == target:
			return pos
		elif arr[pos] < target:
			low = pos + 1
		else:
			high = pos - 1
	
	return -1

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

result = interpolation_search(arr, target)

if result != -1:
	print(f"Element found at index: {result}")
else:
	print(f"Element {target} not found in the array")""" % [arr, target]

func get_java_interpolation_code(arr: String, target: int) -> String:
	return """/* Interpolation Search - Time Complexity: O(log log n) */
public class Main {
	static int search(int arr[], int target) {
		int low = 0, high = arr.length - 1;
		
		while (low <= high && target >= arr[low] && target <= arr[high]) {
			if (low == high) {
				return (arr[low] == target) ? low : -1;
			}
			
			int pos = low + ((target - arr[low]) * (high - low) / (arr[high] - arr[low]));
			
			if (arr[pos] == target)
				return pos;
			
			if (arr[pos] < target)
				low = pos + 1;
			else
				high = pos - 1;
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
		int arr[] = {%s};
		int target = %d;
		
		System.out.print("Array: ");
		printArray(arr);
		System.out.println("Searching for: " + target);
		
		int result = search(arr, target);
		
		if (result != -1)
			System.out.println("Element found at index: " + result);
		else
			System.out.println("Element " + target + " not found in the array");
	}
}""" % [arr, target]

func get_c_interpolation_code(arr: String, target: int) -> String:
	var code = """/* Interpolation Search - Time Complexity: O(log log n) */
#include <stdio.h>

int interpolationSearch(int arr[], int n, int target) {
	int low = 0, high = n - 1;
	
	while (low <= high && target >= arr[low] && target <= arr[high]) {
		if (low == high) {
			return (arr[low] == target) ? low : -1;
		}
		
		// Avoid division by zero
		if (arr[high] == arr[low]) {
			return -1;
		}
		
		int pos = low + ((target - arr[low]) * (high - low) / (arr[high] - arr[low]));
		
		if (arr[pos] == target)
			return pos;
		
		if (arr[pos] < target)
			low = pos + 1;
		else
			high = pos - 1;
	}
	return -1;
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
	int target = %d;
	
	printf("Array: ");
	printArray(arr, n);
	printf("Searching for: %%d\\n", target);
	
	int result = interpolationSearch(arr, n, target);
	
	if (result != -1)
		printf("Element found at index: %%d\\n", result);
	else
		printf("Element %%d not found in the array\\n", target);
	
	return 0;
}"""
	return code % [arr, target]


func _setup_compiler():
	"""Setup compiler button and popup"""
	if compile_btn:
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
			code = get_cpp_interpolation_code(arr_str, target_value)
		"c":
			code = get_c_interpolation_code(arr_str, target_value)
		"java":
			code = get_java_interpolation_code(arr_str, target_value)
		"python":
			code = get_python_interpolation_code(arr_str, target_value)
	
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
	var keys = APIManager.get_keys("KEY_C")
	
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
	var arr_str = ", ".join(initial_array.map(func(x): return str(x)))
	var code = ""
	
	match language:
		"cpp":
			code = get_cpp_interpolation_code(arr_str, target_value)
		"c":
			code = get_c_interpolation_code(arr_str, target_value)
		"java":
			code = get_java_interpolation_code(arr_str, target_value)
		"python":
			code = get_python_interpolation_code(arr_str, target_value)
	
	_compile_code(code)

func _on_compiler_output_closed():
	"""Called when compiler output popup is closed"""
	print("Compiler output closed")

# ADDED: reset_cache_for_scene function
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
			"text": "Press this when the revealed position value EQUALS the target",
			"action": "highlight"
		},
		{
			"node": discard_left_btn,
			"title": "DISCARD LEFT",
			"text": "Press this when the revealed position value is LESS than the target",
			"action": "highlight"
		},
		{
			"node": discard_right_btn,
			"title": "DISCARD RIGHT",
			"text": "Press this when the revealed position value is GREATER than the target",
			"action": "highlight"
		},
		{
			"node": undo_btn,
			"title": "UNDO",
			"text": "Reverses your last action (slot selection, pos tap, or discard decision)",
			"action": "highlight"
		},
		{
			"node": redo_btn,
			"title": "REDO",
			"text": "Reapplies an action that was undone",
			"action": "highlight"
		},
		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View your complete move history",
			"action": "highlight"
		},
		{
			"node": formula_label,
			"title": "FORMULA DISPLAY",
			"text": "Shows the interpolation formula with current values substituted in real-time",
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
	
	# Sort the array (required for interpolation search)
	arr.sort()
	
	# Check for duplicates and warn if found
	var has_duplicates = false
	for i in range(arr.size() - 1):
		if arr[i] == arr[i + 1]:
			has_duplicates = true
			break
	
	if has_duplicates:
		show_feedback("Warning: Duplicate values may affect interpolation search!", Color.YELLOW, Vector2(500, 200))
	
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
	var size = _get_array_size()
	var arr: Array[int] = []
	
	# Generate "mostly uniform" array
	var start = randi_range(5, 15)
	var base_step = randi_range(5, 10)
	
	# Generate base arithmetic sequence
	var base_arr = []
	for i in range(size):
		base_arr.append(start + i * base_step)
	
	# Add perturbations
	arr = base_arr.duplicate()
	var num_perturbations = randi_range(1, 3)
	for p in range(num_perturbations):
		var perturb_idx = randi_range(1, size - 2)
		var direction = 1 if randi() % 2 == 0 else -1
		var amount = randi_range(1, 3)
		
		var new_val = arr[perturb_idx] + (direction * amount)
		if new_val > arr[perturb_idx - 1] and new_val < arr[perturb_idx + 1] and new_val <= 99:
			arr[perturb_idx] = new_val
	
	arr.sort()
	
	# Ensure last element doesn't exceed 99
	while arr[size - 1] > 99:
		for i in range(size):
			arr[i] = start + i * (base_step - 1)
		break
	
	print("Custom 'mostly uniform' array: ", arr)
	
	_set_main_ui_enabled(true)
	help_btn.show()
	
	target_value = arr[randi() % arr.size()]
	_initialize_with_elements(arr)
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
		# Resume timer
		if difficulty != 1:
			timer_running = true
			clock.play()

func _on_intro_prev_pressed():
	btn_sound.play()
	if intro_step > 0:
		intro_step -= 1
		_update_intro_text()

func _on_intro_skip_pressed():
	btn_sound.play()
	intro_popup.hide()
	_set_main_ui_enabled(true)
	# Resume timer
	if difficulty != 1:
		timer_running = true
		clock.play()

func _set_main_ui_enabled(enabled: bool) -> void:
	if undo_btn: undo_btn.disabled = not enabled
	if redo_btn: redo_btn.disabled = not enabled
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
	reset_cache_for_scene()
	_show_config_modal()

func _on_no_pressed():
	sim_confirmation.hide()

func _on_help_button_pressed():
	btn_sound.play()
	start_tutorial()
