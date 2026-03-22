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
@onready var time_up_try_again_btn: Button = $TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/TryAgainButton
@onready var time_up_back_btn: Button = $TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/BackButton

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

# --- SELECTION SORT VARIABLES ---
var main_array: Array[int] = []
var initial_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []

# Selection sort specific tracking
var current_position: int = 0  # The position we're trying to fill with the minimum

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
	"Welcome to Selection Sort Simulation!\nSelection Sort finds the smallest element and puts it at the front, then finds the next smallest, and so on.",
	"The Algorithm:\n\n1. Find the minimum in the unsorted portion\n2. Swap it with the first element of the unsorted portion\n3. Move the boundary right\n4. Repeat until sorted",
	"Key Rule: You must swap the CURRENT MINIMUM into position!\n\n• Green blocks are sorted\n• Find the smallest number in the unsorted region\n• Swap it directly into the current position",
	"Buttons to use:\n\n• Undo – revert last move\n• Redo – reapply move\n• Timeline – view move history",
	"Difficulty Levels:\n\n1. Easy: Allows undos and redos, no timer\n2. Medium: Allows undos and redos, 90 seconds\n3. Hard: No undos/redos, 60 seconds"
]

# --- CODE TUTORIAL DATA ---
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

# 1. C++ DATA (Selection Sort)
var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Complexity Analysis:\nSelection Sort has O(n^2) Time Complexity, O(1) Space Complexity." },
	{ "lines": [2, 3], "text": "2. Imports & Setup:\nIncludes standard libraries." },
	{ "lines": [6], "text": "3. Outer Loop:\nMoves the boundary between sorted and unsorted portions." },
	{ "lines": [7], "text": "4. Find Minimum:\nAssume current position has the minimum." },
	{ "lines": [8, 9], "text": "5. Inner Loop:\nScan the unsorted portion to find the actual minimum." },
	{ "lines": [10, 11, 12, 13], "text": "6. The Swap:\nSwap the found minimum with the element at current position." }
]

# 2. PYTHON DATA (Selection Sort)
var python_tutorial_data = [
	{ "lines": [0, 1, 2], "text": "1. Complexity:\nTime O(n^2), Space O(1)." },
	{ "lines": [3, 4], "text": "2. Function Definition:\nDefine function and get array length." },
	{ "lines": [5], "text": "3. Outer Loop:\nControl boundary between sorted/unsorted." },
	{ "lines": [6], "text": "4. Assume Minimum:\nSet min_idx to current position." },
	{ "lines": [7, 8], "text": "5. Find Actual Minimum:\nScan unsorted portion." },
	{ "lines": [9, 10], "text": "6. The Swap:\nSwap if needed." }
]

# 3. JAVA DATA (Selection Sort)
var java_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Class Structure:\nAll code in a class." },
	{ "lines": [2, 3], "text": "2. Method Definition:\nDefine sort method." },
	{ "lines": [4], "text": "3. Outer Loop:\nControl boundary." },
	{ "lines": [5], "text": "4. Assume Minimum:\nSet min_idx." },
	{ "lines": [6, 7], "text": "5. Find Minimum:\nScan unsorted portion." },
	{ "lines": [8, 9, 10, 11], "text": "6. The Swap:\nSwap if min_idx changed." }
]

# 4. C DATA (Selection Sort)
var c_tutorial_data = [
	{ "lines": [0], "text": "1. Setup:\nInclude standard I/O." },
	{ "lines": [1, 2], "text": "2. Function Start:\nDeclare variables." },
	{ "lines": [3], "text": "3. Outer Loop:\nControl boundary." },
	{ "lines": [4], "text": "4. Assume Minimum:\nSet min_idx." },
	{ "lines": [5, 6], "text": "5. Find Minimum:\nScan unsorted portion." },
	{ "lines": [7, 8, 9], "text": "6. The Swap:\nSwap if needed." }
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
var sorted_array: Array[int] = []
const CURRENT_TOPIC = "selection_sort"
func _get_array_size() -> int:
	match difficulty:
		1: return 4
		2: return 5
		3: return 7
	return 5

func _get_time_limit() -> float:
	match difficulty:
		1: return 100000.0 # Easy
		2: return 90.0    # Medium
		3: return 60.0     # Hard
	return 90.0

func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
		# Add this at the beginning of _ready()
	difficulty = Global.current_difficulty
	if difficulty == 0:
		difficulty = 2
	tiktak_sound = AudioStreamPlayer.new()
	tiktak_sound.stream = TIKTAK_SFX
	add_child(tiktak_sound)
	try_again_button.visible = false
	
	print("Program started — initializing Selection Sort visualizer...")
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
	
	if sort_btn: sort_btn.text = "UNDO"
	if auto_btn: auto_btn.text = "REDO"
	
	_start_assessment_mode()
	call_deferred("show_introduction")
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")
	
	_connect_language_buttons()
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
		
func _setup_timeline_popup_for_mobile():
	if not timeline_popup:
		return
	
	var scroll_container = timeline_popup.find_child("ScrollContainer", true, false)
	if scroll_container:
		scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
		scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		scroll_container.mouse_filter = Control.MOUSE_FILTER_STOP

func _start_assessment_mode():
	reset_cache_for_scene()
	try_again_button.visible = false
	
	# Kill any existing animations
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	clock.visible = false
	clock.modulate = Color(1, 1, 1, 1)
	clock.stop()

	mistake_counter = 0
	correct_moves = 0
	comparison_counter = 0
	swap_counter = 0
	current_position = 0  # Will be updated after array is created
	sorting_complete = false
	is_sorting = false
	is_auto_playing = false
	has_completed_assessment = false
	completion_type = ""
	coins_earned = 0
	
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
	
	for i in range(size):
		arr.append(randi_range(1, 99))
	
	_initialize_with_elements(arr)
	
	# After creating array, find the first position that doesn't have the minimum
	_update_current_position()
	_update_undo_redo_buttons()

func _on_time_up_try_again_pressed() -> void:
	btn_sound.play()
	if time_up_popup: time_up_popup.hide()
	result_popup.hide()
	_start_assessment_mode()
	call_deferred("show_introduction")

func _on_time_up_back_pressed() -> void:
	btn_sound.play()
	if time_up_popup: time_up_popup.hide()
	
# Update _update_current_position to find the first index that doesn't have the correct sorted value
func _update_current_position():
	if main_array.is_empty() or sorted_array.is_empty():
		return
	
	# Find the first index where the value doesn't match the sorted array
	for i in range(main_array.size()):
		if main_array[i] != sorted_array[i]:
			current_position = i
			
			# Optional: Add status label update
			if status_label:
				var target_value = sorted_array[i]
				status_label.text = "Find %d and swap it into position %d" % [target_value, i]
			return
	
	# If all match, array is fully sorted
	current_position = main_array.size()
	if status_label:
		status_label.text = "Array is sorted!"
	
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
	sorted_array.sort()  # Store the correctly sorted version
	
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
	current_position = 0  # Reset to start
	
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
	
	_update_current_position()
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
			# In Selection Sort, elements before current_position should be in their final positions
			# But also any element that matches the sorted array at its index can be highlighted
			if main_array[i] == sorted_array[i]:
				# This element is in its correct final position
				block_nodes[i].set_sorted_visual(true)
				
				# Optional: Add a subtle glow or scale effect for recently sorted
				if i == current_position - 1 and i >= 0:
					# This element was just sorted in the last move
					var block = block_nodes[i]
					var original_scale = block.scale
					var tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
					tween.tween_property(block, "scale", original_scale * 1.1, 0.2)
					tween.tween_property(block, "scale", original_scale, 0.2)
			else:
				block_nodes[i].set_sorted_visual(false)
		
		if block_nodes[i].has_method("set_highlight"):
			# Highlight the current position we're trying to fill
			if i == current_position and current_position < main_array.size():
				block_nodes[i].set_highlight(true)
			else:
				block_nodes[i].set_highlight(false)


# ==============================================
#   CORE SELECTION SORT LOGIC
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
	
	# Validate Selection Sort move
	var validation = _validate_selection_move(old_index, insert_index)
	var is_valid = validation.valid
	var message = validation.message

	# Perform the swap
	var temp = main_array[old_index]
	main_array[old_index] = main_array[insert_index]
	main_array[insert_index] = temp
	
	# Update blocks array
	var temp_block = block_nodes[old_index]
	block_nodes[old_index] = block_nodes[insert_index]
	block_nodes[insert_index] = temp_block
	
	# Record the move for undo/redo
	var move_data = {
		"old_index": old_index,
		"new_index": insert_index,
		"was_valid": is_valid,
		"val1": val1,
		"val2": val2
	}
	move_history.append(move_data)
	
	# Animate the swap with smooth transition
	await _animate_swap(block_nodes[old_index], block_nodes[insert_index])
	
	# Always resnap blocks to ensure correct positioning
	_resnap_blocks()

	if is_valid:
		correct_moves += 1
		# Detailed timeline log for good moves
		timeline_log.append(
			"[color=green]Good swap: index[%d] (%d) ↔ index[%d] (%d) - %s[/color]" 
			% [old_index, val1, insert_index, val2, message]
		)

		show_feedback(
			message,
			Color.GREEN,
			Vector2(dropped_block.global_position.x, START_POSITION.y - 20)
		)
		
		# After a valid swap, update current_position
		_update_current_position()
		_update_sorted_visuals()
		swap_counter += 1
	else:
		mistake_counter += 1
		# Detailed timeline log for bad moves
		timeline_log.append(
			"[color=red]Bad move: index[%d] (%d) ↔ index[%d] (%d) - %s[/color]" 
			% [old_index, val1, insert_index, val2, message]
		)

		show_feedback(
			message,
			Color.RED,
			Vector2(dropped_block.global_position.x, START_POSITION.y - 20)
		)
	
	_update_timeline_display()
	_update_ui_labels()
	_update_undo_redo_buttons()
	
	if _check_if_sorted() and not has_completed_assessment:
		_end_assessment("sorted")
		return
		
func _swap_positions_instantly(node_a: Control, node_b: Control):
	var pos_a = node_a.position
	var pos_b = node_b.position
	node_a.position = pos_b
	node_b.position = pos_a
	
func _validate_selection_move(old_index: int, new_index: int) -> Dictionary:
	# First, ensure current_position is correct based on sorted_array
	_update_current_position()
	
	# If array is fully sorted
	if current_position >= main_array.size():
		return {
			"valid": false,
			"message": "Array is already sorted"
		}
	
	# The target value that should be at current_position according to sorted order
	var target_value = sorted_array[current_position]
	
	# Find where that target value currently is in the unsorted portion
	var target_index = -1
	for i in range(current_position, main_array.size()):
		if main_array[i] == target_value:
			target_index = i
			break
	
	# If we can't find the target value (shouldn't happen), something's wrong
	if target_index == -1:
		return {
			"valid": false,
			"message": "Error: Target value not found"
		}
	
	# Valid move: swapping the target value into current_position
	if (old_index == current_position and new_index == target_index) or \
	   (new_index == current_position and old_index == target_index):
		return {
			"valid": true,
			"message": "Good move! Swapping %d into position %d" % [target_value, current_position]
		}
	
	# Invalid move - give specific feedback
	if old_index == current_position or new_index == current_position:
		# Swapping current position with something other than the minimum
		return {
			"valid": false,
			"message": "Bad move! Need to swap the minimum value %d at index %d into position %d" % [target_value, target_index, current_position]
		}
	else:
		# Swapping two elements that don't involve current position
		return {
			"valid": false,
			"message": "Bad move! Swap must involve current position %d" % current_position
		}


func _resnap_blocks() -> void:
	var x = START_POSITION.x
	for i in range(block_nodes.size()):
		var child = block_nodes[i]
		var target_pos = Vector2(x, START_POSITION.y)
		var tween = create_tween()
		tween.tween_property(child, "position", target_pos, 0.2)  # Smooth animation
		x += child.size.x + BLOCK_SPACING

func _save_state() -> void:
	var state := {
		"array": main_array.duplicate(),
		"current_position": current_position,
		"mistakes": mistake_counter,
		"correct_moves": correct_moves,  # Add this
		"comparisons": comparison_counter,
		"swaps": swap_counter,
		"timeline": timeline_log.duplicate()  # Add this!
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
	
	if current_position >= main_array.size() - 1:
		_finish_simulation()
		is_sorting = false
		return
	
	# Find minimum in unsorted portion
	var min_idx = current_position
	for i in range(current_position + 1, main_array.size()):
		comparison_counter += 1
		
		if status_label:
			status_label.text = "Scanning: comparing %d with %d" % [main_array[min_idx], main_array[i]]
		
		if main_array[i] < main_array[min_idx]:
			min_idx = i
	
	# Swap if needed
	if min_idx != current_position:
		swap_counter += 1
		var val_at_pos = main_array[current_position]
		var min_val = main_array[min_idx]
		
		if status_label:
			status_label.text = "Swapping %d (min) with %d at position %d" % [min_val, val_at_pos, current_position]
		
		timeline_log.append(
			"[color=green]Auto: Swapped minimum %d at index %d into position %d (was %d)[/color]" 
			% [min_val, min_idx, current_position, val_at_pos]
		)
		
		var temp = main_array[current_position]
		main_array[current_position] = main_array[min_idx]
		main_array[min_idx] = temp
		
		var node_a = block_nodes[current_position]
		var node_b = block_nodes[min_idx]
		
		block_nodes[current_position] = node_b
		block_nodes[min_idx] = node_a
		
		await _animate_swap(node_a, node_b)
	else:
		if status_label:
			status_label.text = "Element %d already correct at position %d" % [main_array[current_position], current_position]
		timeline_log.append(
			"[color=green]Auto: Element %d already in correct position %d[/color]" 
			% [main_array[current_position], current_position]
		)
		await get_tree().create_timer(ANIM_SPEED * 0.5).timeout
	
	current_position += 1
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
		compare_label.text = "Correct Swaps: %d " % [correct_moves]
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
			code = get_cpp_selection_code(arr_str)
			current_tutorial_data = cpp_tutorial_data
		"python":
			code = get_python_selection_code(arr_str)
			current_tutorial_data = python_tutorial_data
		"java":
			code = get_java_selection_code(arr_str)
			current_tutorial_data = java_tutorial_data
		"c":
			code = get_c_selection_code(arr_str)
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
			"cpp": base_code = get_cpp_selection_code(arr_str)
			"python": base_code = get_python_selection_code(arr_str)
			"java": base_code = get_java_selection_code(arr_str)
			"c": base_code = get_c_selection_code(arr_str)

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

func get_cpp_selection_code(arr: String) -> String:
	return """/* Time Complexity: O(n^2)
   Space Complexity: O(1) */
#include <iostream>
using namespace std;

void selectionSort(int arr[], int n) {
	for (int i = 0; i < n - 1; i++) {
		int min_idx = i;
		for (int j = i + 1; j < n; j++) {
			if (arr[j] < arr[min_idx]) {
				min_idx = j;
			}
		}
		if (min_idx != i) {
			int temp = arr[i];
			arr[i] = arr[min_idx];
			arr[min_idx] = temp;
		}
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
	
	selectionSort(arr, n);
	
	cout << "Sorted array: ";
	printArray(arr, n);
	
	return 0;
}""" % arr

func get_python_selection_code(arr: String) -> String:
	return """# Time Complexity: O(n^2)
# Space Complexity: O(1)

def selection_sort(arr):
	n = len(arr)
	for i in range(n):
		min_idx = i
		for j in range(i + 1, n):
			if arr[j] < arr[min_idx]:
				min_idx = j
		if min_idx != i:
			arr[i], arr[min_idx] = arr[min_idx], arr[i]

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

selection_sort(arr)

print("Sorted array: ", end="")
print_array(arr)""" % arr

func get_java_selection_code(arr: String) -> String:
	return """/* Time Complexity: O(n^2) */
public class Main {
	static void sort(int arr[]) {
		int n = arr.length;
		for (int i = 0; i < n - 1; i++) {
			int min_idx = i;
			for (int j = i + 1; j < n; j++)
				if (arr[j] < arr[min_idx])
					min_idx = j;
			if (min_idx != i) {
				int temp = arr[i];
				arr[i] = arr[min_idx];
				arr[min_idx] = temp;
			}
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

func get_c_selection_code(arr: String) -> String:
	return """/* Time Complexity: O(n^2) */
#include <stdio.h>

void selectionSort(int arr[], int n) {
	for (int i = 0; i < n - 1; i++) {
		int min_idx = i;
		for (int j = i + 1; j < n; j++)
			if (arr[j] < arr[min_idx])
				min_idx = j;
		if (min_idx != i) {
			int temp = arr[i];
			arr[i] = arr[min_idx];
			arr[min_idx] = temp;
		}
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
	
	selectionSort(arr, n);
	
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
			code = get_cpp_selection_code(arr_str)
		"c":
			code = get_c_selection_code(arr_str)
		"java":
			code = get_java_selection_code(arr_str)
		"python":
			code = get_python_selection_code(arr_str)
	
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
			code = get_cpp_selection_code(arr_str)
		"c":
			code = get_c_selection_code(arr_str)
		"java":
			code = get_java_selection_code(arr_str)
		"python":
			code = get_python_selection_code(arr_str)
	
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
		tutorial_overlay.hide()
		_set_main_ui_enabled(true)
		# Add this line to restart timer:
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

func _on_waiting_pressed() -> void: # REDO
	if not _can_redo():
		return
	
	if redo_stack.is_empty():
		return
	
	var state = redo_stack.pop_back()
	
	undo_stack.append({
		"array": main_array.duplicate(),
		"current_position": current_position,
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

	# Detailed timeline log for redo
	timeline_log.append(
		"[color=gray]Redo: reapplied swap index[%d] (%d) ↔ index[%d] (%d)[/color]" 
		% [move["old_index"], move["val1"], move["new_index"], move["val2"]]
	)

	_update_timeline_display()
	_update_undo_redo_buttons()
	_update_ui_labels()
	_update_sorted_visuals()

# In _restore_state(), add correct_moves:
func _restore_state(state: Dictionary) -> void:
	main_array = state["array"].duplicate()
	sorted_array = main_array.duplicate()
	sorted_array.sort()
	current_position = state["current_position"]
	mistake_counter = state["mistakes"]
	correct_moves = state.get("correct_moves", 0)  # Add this with fallback
	comparison_counter = state["comparisons"]
	swap_counter = state.get("swaps", 0)
	timeline_log = state.get("timeline", timeline_log).duplicate()  # Add this

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

func _on_sort_button_pressed() -> void: # UNDO
	if not _can_undo():
		return
	
	if undo_stack.is_empty():
		return
	
	var state = undo_stack.pop_back()
	
	redo_stack.append({
		"array": main_array.duplicate(),
		"current_position": current_position,
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

	# Detailed timeline log for undo
	timeline_log.append(
		"[color=gray]Undo: reversed swap index[%d] (%d) ↔ index[%d] (%d)[/color]" 
		% [last_move["old_index"], last_move["val1"], last_move["new_index"], last_move["val2"]]
	)

	_update_timeline_display()
	_update_undo_redo_buttons()
	_update_ui_labels()
	_update_sorted_visuals()

func _on_try_again_button_pressed() -> void:
	btn_sound.play()
	time_up_popup.hide()
	result_popup.hide()
	_start_assessment_mode()
	await get_tree().process_frame
	_update_undo_redo_buttons()

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
	
	# REMOVE this hardcoded coin calculation
	# var coins = 0
	# match difficulty: ...
	
	return {
		"passed": passed,
		"accuracy": accuracy,
		"total_moves": total_moves,
		"correct_moves": correct_moves,
		"mistake_counter": mistake_counter,
		"time_used": time_used,
		"coins": 0,  # Set to 0, will be overwritten if passed
		"required": required_threshold
	}

func _end_assessment(reason: String) -> void:
	if has_completed_assessment:
		return
	
	has_completed_assessment = true
	completion_type = reason
	DB.record_attempt(CURRENT_TOPIC, difficulty)  # This records the attempt
	
	# Kill any animations
	if current_tween:
		current_tween.kill()
		current_tween = null
	
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
	
	if reason == "timeout":
		_show_result_popup("FAIL")
	else:
		var grade = _compute_grade()
		var result = "PASS" if grade["passed"] else "FAIL"
		
		# MISSING! Need to complete level if passed
		if grade["passed"]:
			coins_earned = DB.complete_level(CURRENT_TOPIC, difficulty)  # ← ADD THIS!
			grade["coins"] = coins_earned
		
		_show_result_popup(result, grade)

func _show_result_popup(result: String, grade_data: Dictionary = {}) -> void:
	if not result_popup:
		return
	
	if complete_popup and complete_popup.visible:
		complete_popup.hide()
	
	# Ensure code buttons are hidden at start
	if translate_code_btn:
		translate_code_btn.hide()
	if cpp_code_button:
		cpp_code_button.hide()
	
	if result == "PASS":
		result_title.text = "PASSED!"
		result_title.modulate = Color(0, 1, 0)
		# Show code buttons on pass
		if translate_code_btn:
			translate_code_btn.show()
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")
		try_again_button.visible = false
	else:
		result_title.text = "FAILED!"
		result_title.modulate = Color(1, 0, 0)
		# Explicitly hide code buttons on fail
		if translate_code_btn:
			translate_code_btn.hide()
		if cpp_code_button:
			cpp_code_button.hide()
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
		
		score_summary.text = "Correct: %d | Mistakes: %d" % [
			grade_data.get("correct_moves", 0), 
			grade_data.get("mistake_counter", 0)
		]
		accuracy_label.text = "Accuracy: %.1f%% (Need %.0f%%)" % [
			grade_data.get("accuracy", 0), 
			grade_data.get("required", 0)
		]
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

func _exit_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_PORTRAIT)
	# Swap back to portrait dimensions
	 
