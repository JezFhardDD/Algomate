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

# Gap indicator label
@onready var gap_label: Label = Label.new()
@onready var pass_btn: Button = $VBoxContainer/PassButton

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

# --- SHELL SORT VARIABLES ---
var main_array: Array[int] = []
var initial_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []
var sorted_array: Array[int] = []

# Shell sort specific tracking
var current_gap: int = 0
var gap_sequence: Array[int] = []
var current_gap_index: int = 0
var current_index: int = 0  # Current element being processed in the gap pass
var comparison_partner: int = -1  # The element at i - gap that we're comparing with

var comparison_counter: int = 0
var swap_counter: int = 0
var sorting_complete: bool = false
var is_sorting: bool = false
var is_auto_playing: bool = false

var mistake_counter: int = 0
var correct_moves: int = 0

var BLOCK_WIDTH: float = 64.0
var BLOCK_SPACING: float = 15.0
var START_POSITION: Vector2 = Vector2(50, 80)
var ANIM_SPEED: float = 0.2

# Add tween tracking for cleanup
var current_tween: Tween = null

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

# Intro Text
var intro_step: int = 0
var intro_texts = [
	"Welcome to Shell Sort Simulation!\nShell Sort is like Insertion Sort but with gaps that shrink over time.",
	"The Algorithm:\n\n1. Start with a large gap (array size/2)\n2. Perform Insertion Sort on elements gap apart\n3. Shrink the gap and repeat\n4. Final pass with gap=1 is standard Insertion Sort",
	"Visual Guide:\n• White highlight = Current element\n• Green highlight = Comparison partner (i - gap)\n• Connect them mentally to understand the gap",
	"Buttons to use:\n\n• Undo – revert last move\n• Redo – reapply move\n• Timeline – view move history",
	"Difficulty Levels:\n\n1. Easy: Size 4, gap sequence 2→1\n2. Medium: Size 5, gap sequence 2→1\n3. Hard: Size 7, gap sequence 3→1"
]

# --- CODE TUTORIAL DATA ---
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

# 1. C++ DATA (Shell Sort)
var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Complexity Analysis:\nShell Sort has O(n log n) to O(n²) time complexity depending on gap sequence." },
	{ "lines": [2, 3], "text": "2. Imports & Setup:\nIncludes standard libraries." },
	{ "lines": [6, 7], "text": "3. Gap Sequence:\nStart with large gap, shrink by half each time." },
	{ "lines": [8], "text": "4. Gap Pass:\nPerform insertion sort with current gap." },
	{ "lines": [9, 10], "text": "5. Element Selection:\nStart from gap index and go through array." },
	{ "lines": [11, 12, 13], "text": "6. Comparison & Shift:\nCompare with element gap positions back, shift if needed." }
]

# 2. PYTHON DATA (Shell Sort)
var python_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Complexity:\nTime depends on gap sequence." },
	{ "lines": [2, 3], "text": "2. Function Definition:\nDefine function and get array length." },
	{ "lines": [4, 5], "text": "3. Gap Loop:\nShrink gap each iteration." },
	{ "lines": [6, 7], "text": "4. Insertion Sort with Gap:\nProcess elements with current gap." },
	{ "lines": [8, 9], "text": "5. Shift Elements:\nMove larger elements forward." },
	{ "lines": [10], "text": "6. Place Element:\nInsert at correct position." }
]

# 3. JAVA DATA (Shell Sort)
var java_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Class Structure:\nAll code in a class." },
	{ "lines": [2, 3], "text": "2. Method Definition:\nDefine sort method." },
	{ "lines": [4, 5], "text": "3. Gap Loop:\nControl gap sequence." },
	{ "lines": [6, 7], "text": "4. Element Loop:\nProcess each element with current gap." },
	{ "lines": [8, 9, 10], "text": "5. Shift Loop:\nMove larger elements forward." },
	{ "lines": [11], "text": "6. Insert:\nPlace element in correct position." }
]

# 4. C DATA (Shell Sort)
var c_tutorial_data = [
	{ "lines": [0], "text": "1. Setup:\nInclude standard I/O." },
	{ "lines": [1, 2], "text": "2. Function Start:\nDeclare variables." },
	{ "lines": [3, 4], "text": "3. Gap Loop:\nShrink gap each iteration." },
	{ "lines": [5, 6], "text": "4. Element Loop:\nProcess each element." },
	{ "lines": [7, 8, 9], "text": "5. Shift Loop:\nMove larger elements." },
	{ "lines": [10], "text": "6. Insert:\nPlace element in correct position." }
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
var is_shaking: bool = false
var shake_tween: Tween = null
var is_animating: bool = false
var repeat_current_gap: bool = false

func _get_array_size() -> int:
	match difficulty:
		1: return 4
		2: return 5
		3: return 7
	return 5

func _get_gap_sequence() -> Array[int]:
	match difficulty:
		1: return [2, 1]
		2: return [2, 1]
		3: return [3, 1]
	return [2, 1]

func _get_time_limit() -> float:
	match difficulty:
		1: return 0 # Easy
		2: return 90.0    # Medium
		3: return 60.0     # Hard
	return 90.0

func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	difficulty = Global.current_difficulty
	if difficulty == 0:
		difficulty = 1
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	tiktak_sound = AudioStreamPlayer.new()
	tiktak_sound.stream = TIKTAK_SFX
	add_child(tiktak_sound)
	try_again_button.visible = false
	
	# Setup gap indicator
	gap_label = Label.new()
	gap_label.name = "GapLabel"
	gap_label.add_theme_font_size_override("font_size", 30)
	gap_label.add_theme_color_override("font_color", Color(1, 1, 0))
	gap_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	gap_label.add_theme_constant_override("outline_size", 8)
	var font = load("res://assets/font/Planes_ValMore.ttf")
	if font:
		gap_label.add_theme_font_override("font", font)
	gap_label.position = Vector2(500, 30)
	add_child(gap_label)
	
	print("Program started — initializing Shell Sort visualizer...")
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
	
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if unused_ptr1: unused_ptr1.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	if cpp_code_button: cpp_code_button.hide()
	var time_up_try = get_node_or_null("TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/TryAgainButton")
	var time_up_back = get_node_or_null("TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/BackButton")
	if time_up_try:
		time_up_try.pressed.connect(_on_time_up_try_again_pressed)
	if time_up_back:
		time_up_back.pressed.connect(_on_time_up_back_pressed)
	if sort_btn: sort_btn.text = "UNDO"
	if auto_btn: auto_btn.text = "REDO"
	if pass_btn: pass_btn.text = "PASS"
	
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
	
	if pass_btn:
		if not pass_btn.is_connected("pressed", _on_pass_pressed):
			pass_btn.pressed.connect(_on_pass_pressed)
	
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
	
	_update_sorted_visuals()
	_setup_compiler()
	
func _enter_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Swap width and height to match landscape
	var current_size = get_viewport().get_visible_rect().size
	if current_size.y > current_size.x:  # Still thinks it's portrait
		get_tree().root.content_scale_size = Vector2i(int(current_size.y), int(current_size.x))

func _on_time_up_try_again_pressed() -> void:
	btn_sound.play()
	if time_up_popup: time_up_popup.hide()
	result_popup.hide()
	_start_assessment_mode()
	call_deferred("show_introduction")

func _on_time_up_back_pressed() -> void:
	btn_sound.play()
	if time_up_popup: time_up_popup.hide()
	
func _on_pass_pressed() -> void:
	btn_sound.play()
	
	if sorting_complete or is_sorting or is_shaking or is_animating:
		return
	
	# Check if current comparison doesn't need a swap
	if comparison_partner >= 0 and current_index < main_array.size():
		var current_val = main_array[current_index]
		var partner_val = main_array[comparison_partner]
		
		# For Shell Sort, we need to consider the gap
		# Elements are in correct order if the left is <= right
		var is_correct_order = partner_val <= current_val
		
		if is_correct_order:
			correct_moves += 1
			timeline_log.append(
				"[color=green]Good pass: index[%d]: %d <= index[%d]: %d (gap=%d)[/color]" 
				% [comparison_partner, partner_val, current_index, current_val, current_gap]
			)
			show_feedback(
				"Good pass!",
				Color.GREEN,
				Vector2(block_nodes[current_index].global_position.x, START_POSITION.y - 20)
			)
			
			# Advance to next element
			_advance_to_next_element()
			_update_ui_labels()
			comparison_counter += 1
		else:
			# Should have swapped instead of passed
			mistake_counter += 1
			timeline_log.append(
				"[color=red]Bad pass: should swap index[%d]: %d with index[%d]: %d[/color]" 
				% [comparison_partner, partner_val, current_index, current_val]
			)
			show_feedback(
				"Should swap!",
				Color.RED,
				Vector2(block_nodes[current_index].global_position.x, START_POSITION.y - 20)
			)
			
			# Still advance to prevent getting stuck
			_advance_to_next_element()
			
func _setup_timeline_popup_for_mobile():
	if not timeline_popup:
		return
	
	var scroll_container = timeline_popup.find_child("ScrollContainer", true, false)
	if scroll_container:
		scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
		scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		scroll_container.mouse_filter = Control.MOUSE_FILTER_STOP

# Update _start_assessment_mode to enable the pass button
func _start_assessment_mode():
	try_again_button.visible = false
	
	# Enable pass button
	if pass_btn:
		pass_btn.disabled = false
		pass_btn.modulate = Color(1, 1, 1, 1)
	
	# Kill any existing animations
	if current_tween:
		current_tween.kill()
		current_tween = null
	if shake_tween:
		shake_tween.kill()
		shake_tween = null
	
	clock.visible = false
	clock.modulate = Color(1, 1, 1, 1)
	clock.stop()

	mistake_counter = 0
	correct_moves = 0
	comparison_counter = 0
	swap_counter = 0
	sorting_complete = false
	is_sorting = false
	is_auto_playing = false
	is_shaking = false
	is_animating = false
	has_completed_assessment = false
	completion_type = ""
	coins_earned = 0
	
	undo_stack.clear()
	redo_stack.clear()
	move_history.clear()
	move_redo_stack.clear()
	timeline_log.clear()
	
	# Initialize gap sequence
	gap_sequence = _get_gap_sequence()
	current_gap_index = 0
	current_gap = gap_sequence[current_gap_index] if gap_sequence.size() > 0 else 1
	current_index = current_gap  # Start from gap index
	
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
		timer_running = false  # Don't start yet
		await get_tree().process_frame
		clock.visible = true
		clock.modulate = Color(1, 1, 1, 1)
		clock.stop()  # Don't play yet
	
	var size: int = _get_array_size()
	var arr: Array[int] = []
	
	for i in range(size):
		arr.append(randi_range(1, 99))
	
	_initialize_with_elements(arr)
	
	# After array is created, show the first comparison
	_update_gap_indicator()
	
	# Force an immediate update of comparisons
	call_deferred("_force_initial_comparison")
	_update_undo_redo_buttons()
	
func _force_initial_comparison():
	# Small delay to ensure nodes are ready
	await get_tree().process_frame
	await get_tree().process_frame
	
	if block_nodes.size() > 0 and current_index < block_nodes.size():
		_update_comparison_and_visuals()
		
		# Log the start of the pass
		timeline_log.append("--- Starting gap %d pass ---" % current_gap)

func _update_gap_indicator():
	if gap_label:
		gap_label.text = "Current Gap: %d" % current_gap
		# Position it nicely
		gap_label.position = Vector2(500, 30)

func _update_highlights():
	# Clear all highlights first
	for i in range(block_nodes.size()):
		if block_nodes[i] and block_nodes[i].has_method("set_highlight"):
			block_nodes[i].set_highlight(false)
	
	# Highlight current element (white)
	if current_index < block_nodes.size() and block_nodes[current_index]:
		if block_nodes[current_index].has_method("set_highlight"):
			block_nodes[current_index].set_highlight(true)
	
	# Highlight comparison partner (green) - this would need a new method
	# For now, we'll use a different visual cue or just rely on the line/pointer
	if comparison_partner >= 0 and comparison_partner < block_nodes.size() and block_nodes[comparison_partner]:
		# This would need a set_comparison_highlight method in BubbleBlock.gd
		# For now, we'll just use the pointer
		pass
	
	# Update pointers to show the gap connection
	_update_pointers(current_index, comparison_partner)

func _update_pointers(left_idx: int, right_idx: int):
	if block_nodes.is_empty(): return
	if ptr_left: ptr_left.show()
	if ptr_right: ptr_right.show()
	
	if left_idx >= 0 and left_idx < block_nodes.size() and block_nodes[left_idx]:
		var node = block_nodes[left_idx]
		if ptr_left:
			ptr_left.global_position = node.global_position + Vector2(16, node.size.y + 10)
	
	if right_idx >= 0 and right_idx < block_nodes.size() and block_nodes[right_idx]:
		var node_next = block_nodes[right_idx]
		if ptr_right:
			ptr_right.global_position = node_next.global_position + Vector2(16, node_next.size.y + 10)

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
	is_sorting = true
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
	print("Initializing Array with:", elements)
	audio_player.play()
	
	main_array = elements.duplicate()
	initial_array = elements.duplicate()
	sorted_array = elements.duplicate()
	sorted_array.sort()
	
	block_nodes.clear()
	timeline_log.clear()
	
	# Kill any existing animations
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	comparison_counter = 0
	swap_counter = 0
	sorting_complete = false
	is_auto_playing = false
	
	for child in array_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	var current_x = START_POSITION.x
	for val in main_array:
		var new_block = BLOCK_SCENE.instantiate()
		new_block.value = val
		new_block.position = Vector2(current_x, START_POSITION.y)
		
		new_block.draggable = true
		if not new_block.is_connected("block_dropped", _on_block_dropped):
			new_block.connect("block_dropped", _on_block_dropped)
		
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
	
	_update_sorted_visuals()

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

func _update_sorted_visuals():
	if block_nodes.is_empty() or sorted_array.is_empty():
		return
	
	for i in range(block_nodes.size()):
		if block_nodes[i] == null:
			continue
			
		if block_nodes[i].has_method("set_sorted_visual"):
			# Element is sorted if it matches the sorted array at this position
			if main_array[i] == sorted_array[i]:
				block_nodes[i].set_sorted_visual(true)
			else:
				block_nodes[i].set_sorted_visual(false)
		
		if block_nodes[i].has_method("set_highlight"):
			block_nodes[i].set_highlight(false)

# ==============================================
#   CORE SHELL SORT LOGIC
# ==============================================

func _advance_to_next_element():
	# Move to next element in current gap pass
	current_index += 1
	
	# If we've processed all elements with current gap
	if current_index >= main_array.size():
		# Check if the array is fully sorted
		if _check_if_sorted():
			_end_assessment("sorted")
			return
		
		# For gaps > 1, always move to next gap (no repeating)
		if current_gap > 1:
			current_gap_index += 1
			if current_gap_index < gap_sequence.size():
				current_gap = gap_sequence[current_gap_index]
				current_index = current_gap
				timeline_log.append("--- Gap changed to %d ---" % current_gap)
				_update_gap_indicator()
			else:
				# No more gaps but array not sorted? This shouldn't happen
				# Fall back to gap=1 as safety
				current_gap = 1
				current_index = 1
				timeline_log.append("--- Safety: using gap 1 ---")
				_update_gap_indicator()
		
		# For gap=1, repeat passes until sorted
		else: # current_gap == 1
			if not _check_if_sorted():
				# Repeat gap=1 from the beginning
				current_index = 1
				timeline_log.append("--- Repeating gap 1 pass ---")
				_update_gap_indicator()
			else:
				_end_assessment("sorted")
				return
	
	# Update comparison partner and show visual indicators
	_update_comparison_and_visuals()
	
func _update_comparison_and_visuals():
	if current_index >= main_array.size():
		return
	
	# Update comparison partner based on current gap
	if current_gap == 1:
		# For gap=1, we compare with the previous element (standard Insertion Sort)
		comparison_partner = current_index - 1
	else:
		# For larger gaps, compare with element gap positions back
		comparison_partner = current_index - current_gap
	
	# If no valid partner, advance to next element
	if comparison_partner < 0:
		_advance_to_next_element()
		return
	
	# Update pointers to show the comparison
	_update_pointers(comparison_partner, current_index)
	
	# Show status label
	if status_label:
		status_label.text = "Gap %d: Comparing index[%d]: %d with index[%d]: %d" % [
			current_gap,
			comparison_partner, main_array[comparison_partner],
			current_index, main_array[current_index]
		]
	
	# Only shake if not already animating
	if not is_animating and not is_shaking:
		# Trigger shake animation for the two blocks being compared
		_shake_comparison_blocks()
	
	_update_highlights()

func _shake_comparison_blocks():
	if is_shaking or comparison_partner < 0 or current_index >= block_nodes.size():
		return
	
	is_shaking = true
	is_animating = true
	
	# Kill any existing shake tween
	if shake_tween:
		shake_tween.kill()
		shake_tween = null
	
	var block1 = block_nodes[comparison_partner]
	var block2 = block_nodes[current_index]
	
	if not block1 or not block2:
		is_shaking = false
		is_animating = false
		return
	
	# Store original positions
	var original_pos1 = block1.position
	var original_pos2 = block2.position
	
	# Create shake animation
	shake_tween = create_tween().set_parallel(false)
	
	# Shake left-right 3 times quickly
	for i in range(3):
		var offset = 5 if i % 2 == 0 else -5
		shake_tween.tween_property(block1, "position:x", original_pos1.x + offset, 0.05)
		shake_tween.parallel().tween_property(block2, "position:x", original_pos2.x + offset, 0.05)
		shake_tween.tween_interval(0.05)
	
	# Return to original positions
	shake_tween.tween_property(block1, "position", original_pos1, 0.05)
	shake_tween.parallel().tween_property(block2, "position", original_pos2, 0.05)
	
	# Add a small delay after shake before allowing actions
	shake_tween.tween_interval(0.2)
	
	await shake_tween.finished
	is_shaking = false
	is_animating = false



func _on_block_dropped(dropped_block: Control) -> void:
	if is_sorting or sorting_complete or is_shaking or is_animating:
		show_feedback(
			"Cannot drag blocks!!",
			Color.ORANGE,
			Vector2(dropped_block.global_position.x, START_POSITION.y - 20)
		)
		_resnap_blocks()
		return
	
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
		if c == dropped_block:
			continue
		var c_center: float = c.position.x + c.size.x * 0.5
		if center_x > c_center:
			insert_index += 1
	
	if old_index == insert_index:
		_resnap_blocks()
		return
	
	# Get values before swap for logging
	var val1 = main_array[old_index]
	var val2 = main_array[insert_index]
	
	# Validate Shell Sort move
	var validation = _validate_shell_move(old_index, insert_index)
	var is_valid = validation.valid
	var message = validation.message

	# Perform the swap (any distance allowed in Shell Sort)
	var temp = main_array[old_index]
	main_array[old_index] = main_array[insert_index]
	main_array[insert_index] = temp
	
	# Update blocks array
	var temp_block = block_nodes[old_index]
	block_nodes[old_index] = block_nodes[insert_index]
	block_nodes[insert_index] = temp_block
	
	# Set animating state
	is_animating = true
	
	# Animate the swap with smooth transition
	await _animate_swap(block_nodes[old_index], block_nodes[insert_index])
	
	# Always resnap blocks to ensure correct positioning
	await _resnap_blocks()
	
	# Clear animating state
	is_animating = false

	if is_valid:
		correct_moves += 1
		# Detailed timeline log for good moves
		timeline_log.append(
			"[color=green]Good move: swapped index[%d]: %d with index[%d]: %d (gap=%d)[/color]" 
			% [old_index, val1, insert_index, val2, current_gap]
		)

		show_feedback(
			message,
			Color.GREEN,
			Vector2(dropped_block.global_position.x, START_POSITION.y - 20)
		)
		
		# Advance to next element
		_advance_to_next_element()
		_update_sorted_visuals()
		swap_counter += 1
	else:
		mistake_counter += 1
		# Detailed timeline log for bad moves
		timeline_log.append(
			"[color=red]Bad move: swapped index[%d]: %d with index[%d]: %d[/color]" 
			% [old_index, val1, insert_index, val2]
		)

		show_feedback(
			message,
			Color.RED,
			Vector2(dropped_block.global_position.x, START_POSITION.y - 20)
		)
		
		# Even for bad moves, we need to advance to prevent getting stuck
		_advance_to_next_element()
	
	_update_timeline_display()
	_update_ui_labels()
	_update_undo_redo_buttons()
	
	if _check_if_sorted() and not has_completed_assessment:
		_end_assessment("sorted")
		return


func _validate_shell_move(old_index: int, new_index: int) -> Dictionary:
	# In Shell Sort, valid moves are:
	# 1. Swapping the current element with its comparison partner (i - gap)
	# 2. The swap should put the smaller element at the lower index
	
	# Calculate the comparison partner for current_index
	var expected_partner = current_index - current_gap
	
	# Check if this swap involves the current element and its expected partner
	if (old_index == current_index and new_index == expected_partner) or \
	   (new_index == current_index and old_index == expected_partner):
		
		# Check if the swap would put smaller element at lower index
		if main_array[old_index] < main_array[new_index]:
			# Smaller element at higher index, swapping would put it at lower index
			return {
				"valid": true,
				"message": "Good move!"
			}
		else:
			# Already in correct order, no need to swap
			return {
				"valid": false,
				"message": "Elements already in order"
			}
	
	# Check if this is a valid shift (insertion) - moving the current element left by multiple of gap
	if old_index == current_index and new_index < old_index and (old_index - new_index) % current_gap == 0:
		# Moving current element left by multiple of gap
		# Check if all elements between are larger
		var valid = true
		for i in range(new_index, old_index, current_gap):
			if main_array[i] < main_array[old_index]:
				valid = false
				break
		
		if valid:
			return {
				"valid": true,
				"message": "Good move!"
			}
	
	# Also allow swapping any two elements that are gap apart if they're out of order
	# This helps with multiple passes
	if abs(old_index - new_index) == current_gap:
		if (old_index < new_index and main_array[old_index] > main_array[new_index]) or \
		   (new_index < old_index and main_array[new_index] > main_array[old_index]):
			return {
				"valid": true,
				"message": "Good move!"
			}
	
	return {
		"valid": false,
		"message": "Bad move"
	}

func _resnap_blocks():
	var x = START_POSITION.x
	var tweens = []
	
	for i in range(block_nodes.size()):
		var child = block_nodes[i]
		var target_pos = Vector2(x, START_POSITION.y)
		var tween = create_tween()
		tween.tween_property(child, "position", target_pos, 0.2)
		tweens.append(tween)
		x += child.size.x + BLOCK_SPACING
	
	# Wait for the last tween to finish
	if tweens.size() > 0:
		await tweens[-1].finished

func _save_state() -> void:
	var state := {
		"array": main_array.duplicate(),
		"current_gap": current_gap,
		"current_gap_index": current_gap_index,
		"current_index": current_index,
		"mistakes": mistake_counter,
		"comparisons": comparison_counter,
		"swaps": swap_counter
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
	else: sort_btn.disabled = false

func _run_auto_sort() -> void:
	while is_auto_playing and not sorting_complete:
		if is_sorting: 
			await get_tree().process_frame
		else:
			await _perform_sort_step()
			await get_tree().create_timer(ANIM_SPEED).timeout

func _perform_sort_step():
	is_sorting = true
	
	# Process current gap pass
	var gap = current_gap
	var i = current_index
	
	if i >= main_array.size():
		# Move to next gap
		current_gap_index += 1
		if current_gap_index < gap_sequence.size():
			current_gap = gap_sequence[current_gap_index]
			current_index = current_gap
			timeline_log.append("--- Gap changed to %d ---" % current_gap)
			_update_gap_indicator()
			is_sorting = false
			return
		else:
			_finish_simulation()
			is_sorting = false
			return
	
	# Perform insertion for element at i with current gap
	var temp = main_array[i]
	var j = i
	
	comparison_counter += 1
	
	if status_label:
		status_label.text = "Gap %d: Inserting %d" % [gap, temp]
	
	# Show comparison
	_update_pointers(j, j - gap)
	await get_tree().create_timer(ANIM_SPEED * 0.3).timeout
	
	# Shift elements
	while j >= gap and main_array[j - gap] > temp:
		main_array[j] = main_array[j - gap]
		
		# Update blocks
		var node_a = block_nodes[j]
		var node_b = block_nodes[j - gap]
		block_nodes[j] = node_b
		block_nodes[j - gap] = node_a
		
		await _animate_swap(node_a, node_b)
		
		j -= gap
		comparison_counter += 1
		swap_counter += 1
	
	# Place temp in correct position
	if j != i:
		main_array[j] = temp
		# Blocks already updated in shifts
		timeline_log.append("Inserted %d at position %d (gap=%d)" % [temp, j, gap])
	
	current_index += 1
	_update_sorted_visuals()
	
	_update_ui_labels()
	is_sorting = false

func _animate_swap(node_a: Control, node_b: Control):
	var pos_a = node_a.position
	var pos_b = node_b.position
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(node_a, "position", pos_b, ANIM_SPEED)
	tween.tween_property(node_b, "position", pos_a, ANIM_SPEED)
	await tween.finished

func _finish_simulation():
	sorting_complete = true
	is_auto_playing = false
	
	# Kill any animations
	if current_tween:
		current_tween.kill()
		current_tween = null
	if shake_tween:
		shake_tween.kill()
		shake_tween = null
	
	if status_label:
		status_label.text = "Sorted!"
	if auto_btn:
		auto_btn.text = "Auto Sort"
		auto_btn.disabled = true
	if sort_btn:
		sort_btn.disabled = true
	if pass_btn:
		pass_btn.disabled = true
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	
	timeline_log.append("--- SORTING COMPLETE ---")
	
	# Only show complete popup in lecture mode
	if sim_mode != SimMode.ASSESSMENT:
		_show_complete_popup()
	
	if cpp_code_button:
		cpp_code_button.show()
		if code_anim: code_anim.play("default")
	_update_undo_redo_buttons()

func _update_ui_labels():
	if sim_mode == SimMode.ASSESSMENT:
		compare_label.text = "Correct Moves: %d " % [correct_moves]
	else:
		compare_label.text = "Comparisons: %d | Swaps: %d" % [comparison_counter, swap_counter]

func _show_complete_popup() -> void:
	if complete_popup:
		var txt = "Sorting Finished!\n\nTotal Comparisons: %d\nTotal Swaps: %d" % [comparison_counter, swap_counter]
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
	
	match current_code_language:
		"cpp":
			code = get_cpp_shell_code(arr_str)
			current_tutorial_data = cpp_tutorial_data
		"python":
			code = get_python_shell_code(arr_str)
			current_tutorial_data = python_tutorial_data
		"java":
			code = get_java_shell_code(arr_str)
			current_tutorial_data = java_tutorial_data
		"c":
			code = get_c_shell_code(arr_str)
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
			"cpp": base_code = get_cpp_shell_code(arr_str)
			"python": base_code = get_python_shell_code(arr_str)
			"java": base_code = get_java_shell_code(arr_str)
			"c": base_code = get_c_shell_code(arr_str)

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

func get_cpp_shell_code(arr: String) -> String:
	return """/* Shell Sort - Time Complexity: O(n log n) to O(n²) depending on gap sequence */
#include <iostream>
using namespace std;

void printArray(int arr[], int n) {
	cout << "[";
	for (int i = 0; i < n; i++) {
		cout << arr[i];
		if (i < n - 1) cout << ", ";
	}
	cout << "]" << endl;
}

void shellSort(int arr[], int n) {
	for (int gap = n/2; gap > 0; gap /= 2) {
		cout << "\\n--- Gap = " << gap << " ---" << endl;
		for (int i = gap; i < n; i++) {
			int temp = arr[i];
			int j;
			for (j = i; j >= gap && arr[j - gap] > temp; j -= gap) {
				arr[j] = arr[j - gap];
				cout << "After shifting arr[" << j << "] = arr[" << j - gap << "]: ";
				printArray(arr, n);
			}
			if (j != i) {
				arr[j] = temp;
				cout << "After inserting " << temp << " at index " << j << ": ";
				printArray(arr, n);
			}
		}
	}
}

int main() {
	int arr[] = { %s };
	int n = sizeof(arr) / sizeof(arr[0]);
	
	cout << "Initial array: ";
	printArray(arr, n);
	cout << endl;
	
	shellSort(arr, n);
	
	cout << endl << "Sorted array: ";
	printArray(arr, n);
	
	return 0;
}""" % arr

func get_python_shell_code(arr: String) -> String:
	return """# Shell Sort - Time Complexity: O(n log n) to O(n²) depending on gap sequence

def print_array(arr):
	print("[", end="")
	for i in range(len(arr)):
		print(arr[i], end="")
		if i < len(arr) - 1:
			print(", ", end="")
	print("]")

def shell_sort(arr):
	n = len(arr)
	gap = n // 2
	while gap > 0:
		print(f"\\n--- Gap = {gap} ---")
		for i in range(gap, n):
			temp = arr[i]
			j = i
			while j >= gap and arr[j - gap] > temp:
				arr[j] = arr[j - gap]
				print(f"After shifting arr[{j}] = arr[{j - gap}]: ", end="")
				print_array(arr)
				j -= gap
			if j != i:
				arr[j] = temp
				print(f"After inserting {temp} at index {j}: ", end="")
				print_array(arr)
		gap //= 2

arr = [%s]
print("Initial array: ", end="")
print_array(arr)
print()

shell_sort(arr)

print()
print("Sorted array: ", end="")
print_array(arr)""" % arr

func get_java_shell_code(arr: String) -> String:
	return """/* Shell Sort - Time Complexity: O(n log n) to O(n²) depending on gap sequence */
public class Main {
	static void printArray(int arr[]) {
		System.out.print("[");
		for (int i = 0; i < arr.length; i++) {
			System.out.print(arr[i]);
			if (i < arr.length - 1) System.out.print(", ");
		}
		System.out.println("]");
	}
	
	static void shellSort(int arr[]) {
		int n = arr.length;
		for (int gap = n/2; gap > 0; gap /= 2) {
			System.out.println("\\n--- Gap = " + gap + " ---");
			for (int i = gap; i < n; i++) {
				int temp = arr[i];
				int j;
				for (j = i; j >= gap && arr[j - gap] > temp; j -= gap) {
					arr[j] = arr[j - gap];
					System.out.print("After shifting arr[" + j + "] = arr[" + (j - gap) + "]: ");
					printArray(arr);
				}
				if (j != i) {
					arr[j] = temp;
					System.out.print("After inserting " + temp + " at index " + j + ": ");
					printArray(arr);
				}
			}
		}
	}
	
	public static void main(String args[]) {
		int arr[] = {%s};
		
		System.out.print("Initial array: ");
		printArray(arr);
		System.out.println();
		
		shellSort(arr);
		
		System.out.println();
		System.out.print("Sorted array: ");
		printArray(arr);
	}
}""" % arr

func get_c_shell_code(arr: String) -> String:
	return """/* Shell Sort - Time Complexity: O(n log n) to O(n²) depending on gap sequence */
#include <stdio.h>

void printArray(int arr[], int n) {
	printf("[");
	for (int i = 0; i < n; i++) {
		printf("%%d", arr[i]);
		if (i < n - 1) printf(", ");
	}
	printf("]\\n");
}

void shellSort(int arr[], int n) {
	for (int gap = n/2; gap > 0; gap /= 2) {
		printf("\\n--- Gap = %%d ---\\n", gap);
		for (int i = gap; i < n; i++) {
			int temp = arr[i];
			int j;
			for (j = i; j >= gap && arr[j - gap] > temp; j -= gap) {
				arr[j] = arr[j - gap];
				printf("After shifting arr[%%d] = arr[%%d]: ", j, j - gap);
				printArray(arr, n);
			}
			if (j != i) {
				arr[j] = temp;
				printf("After inserting %%d at index %%d: ", temp, j);
				printArray(arr, n);
			}
		}
	}
}

int main() {
	int arr[] = {%s};
	int n = sizeof(arr) / sizeof(arr[0]);
	
	printf("Initial array: ");
	printArray(arr, n);
	printf("\\n");
	
	shellSort(arr, n);
	
	printf("\\nSorted array: ");
	printArray(arr, n);
	
	return 0;
}""" % arr



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
			code = get_cpp_shell_code(arr_str)
		"c":
			code = get_c_shell_code(arr_str)
		"java":
			code = get_java_shell_code(arr_str)
		"python":
			code = get_python_shell_code(arr_str)
	
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
	var keys = APIManager.get_keys("KEY_B")
	
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
			code = get_cpp_shell_code(arr_str)
		"c":
			code = get_c_shell_code(arr_str)
		"java":
			code = get_java_shell_code(arr_str)
		"python":
			code = get_python_shell_code(arr_str)
	
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
			"node": pass_btn,
			"title": "PASS",
			"text": "Skips the current comparison, confirming that the elements are already in the correct relative order and allowing the algorithm to move to the next step.",
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
	if difficulty != 1:
		timer_running = true
		clock.play()

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
		"current_gap": current_gap,
		"current_gap_index": current_gap_index,
		"current_index": current_index,
		"mistakes": mistake_counter,
		"comparisons": comparison_counter,
		"swaps": swap_counter
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

	# Timeline log for redo
	timeline_log.append(
		"[color=gray]Redo: reapplied swap index[%d]: %d with index[%d]: %d[/color]" 
		% [move["old_index"], move["val1"], move["new_index"], move["val2"]]
	)

	_update_timeline_display()
	_update_undo_redo_buttons()
	_update_ui_labels()
	_update_sorted_visuals()
	_update_gap_indicator()
	_update_highlights()

func _restore_state(state: Dictionary) -> void:
	main_array = state["array"].duplicate()
	sorted_array = main_array.duplicate()
	sorted_array.sort()
	current_gap = state["current_gap"]
	current_gap_index = state["current_gap_index"]
	current_index = state["current_index"]
	mistake_counter = state["mistakes"]
	comparison_counter = state["comparisons"]
	swap_counter = state.get("swaps", 0)
	
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
		"current_gap": current_gap,
		"current_gap_index": current_gap_index,
		"current_index": current_index,
		"mistakes": mistake_counter,
		"comparisons": comparison_counter,
		"swaps": swap_counter
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

	# Timeline log for undo
	timeline_log.append(
		"[color=gray]Undo: reversed swap index[%d]: %d with index[%d]: %d[/color]" 
		% [last_move["old_index"], last_move["val1"], last_move["new_index"], last_move["val2"]]
	)

	_update_timeline_display()
	_update_undo_redo_buttons()
	_update_ui_labels()
	_update_sorted_visuals()
	_update_gap_indicator()
	_update_highlights()

func _on_try_again_button_pressed() -> void:
	btn_sound.play()
	if time_up_popup: time_up_popup.hide()
	result_popup.hide()
	_start_assessment_mode()
	call_deferred("show_introduction")
	
	# Extra safety to ensure pass button is enabled
	if pass_btn:
		pass_btn.disabled = false

func _on_back_button_pressed() -> void:
	time_up_popup.hide()

func _update_difficulty_label():
	if not difficulty_label:
		return
	match difficulty:
		1: difficulty_label.text = "Difficulty: Easy"
		2: difficulty_label.text = "Difficulty: Medium"
		3: difficulty_label.text = "Difficulty: Hard"

func _can_undo() -> bool:
	if sorting_complete or not timer_running:
		return false
	
	if difficulty == 3:
		return false
	
	return true

func _can_redo() -> bool:
	if sorting_complete or not timer_running:
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

func _check_if_sorted() -> bool:
	for i in range(main_array.size() - 1):
		if main_array[i] > main_array[i + 1]:
			return false
	return true

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
		"coins": 0,  # Set by DB in _end_assessment if passed
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
	if shake_tween:
		shake_tween.kill()
		shake_tween = null
	
	timer_running = false
	tiktak_sound.stop()
	is_sorting = true
	is_auto_playing = false
	
	if sort_btn:
		sort_btn.disabled = true
	if auto_btn:
		auto_btn.disabled = true
	if pass_btn:
		pass_btn.disabled = true
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	
	# ALWAYS use ResultPopup for assessment mode
	if reason == "sorted":
		var grade = _compute_grade()
		if grade["passed"]:
			coins_earned = DB.complete_level(Global.current_topic, difficulty)
			grade["coins"] = coins_earned
		else:
			DB.record_attempt(Global.current_topic, difficulty)
		_show_result_popup("PASS" if grade["passed"] else "FAIL", grade)
	else:
		DB.record_attempt(Global.current_topic, difficulty)
		_show_result_popup("FAIL")
		if time_up_popup:
			time_up_popup.popup_centered()

func _show_result_popup(result: String, grade_data: Dictionary = {}) -> void:
	if not result_popup:
		return
	
	if complete_popup and complete_popup.visible:
		complete_popup.hide()
	
	if result == "PASS":
		result_title.text = "PASSED!"
		result_title.modulate = Color(0, 1, 0)
		if translate_code_btn: translate_code_btn.show()
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")
		try_again_button.visible = false
	else:
		result_title.text = "FAILED!"
		result_title.modulate = Color(1, 0, 0)
		if translate_code_btn: translate_code_btn.hide()  # ADD
		if cpp_code_button: cpp_code_button.hide()         # ADD
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
	if time_up_popup and time_up_popup.visible:
		time_up_popup.hide()
	_start_assessment_mode()
	call_deferred("show_introduction")


func _on_back_result_pressed():
	btn_sound.play()
	result_popup.hide()

func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()

func _exit_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_PORTRAIT)
	# Swap back to portrait dimensions
	 
	
