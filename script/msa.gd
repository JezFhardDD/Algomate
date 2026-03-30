extends Control

# ==============================================
#   NODE REFERENCES
# ==============================================

@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = $CppPopup/VBoxContainer/HBoxContainer2/CompileButton

# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton  # Undo
@onready var auto_btn: Button = $VBoxContainer/WaitingElements  # Redo
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var pass_btn: Button = $VBoxContainer/PassButton
@onready var time_up_try_again_btn: Button = $TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/TryAgainButton
@onready var time_up_back_btn: Button = $TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/BackButton

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var compare_label: Label = $MarginContainer/HBoxContainer2/TextureRect/Label
@onready var array_container: Control = $QueueContainer
@onready var dequeued_container: Control = $DequeuedContainer
@onready var try_again_btn_root: Button = $TryAgainButton

# --- POPUPS ---
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label
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
@onready var ptr_extra1: Node = $TextureRect/front2
@onready var ptr_extra2: Node = $TextureRect/rear2

# --- VISUAL NODES ---
@onready var merge_status_label: Label = $MergeStatusLabel
@onready var left_subarray_outline: ColorRect = $LeftSubarrayOutline
@onready var right_subarray_outline: ColorRect = $RightSubarrayOutline

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
@onready var time_up_popup: PopupPanel = $TimeUpPopup
@onready var try_again_button: Button = $TryAgainButton
@onready var difficulty_label: Label = $DiificultyLabel

# ==============================================
#   CONSTANTS & VARIABLES
# ==============================================

const TIKTAK_SFX := preload("res://assets/sfx/tiktak.mp3")
const BLOCK_WIDTH: float = 64.0
const BLOCK_SPACING: float = 15.0
const START_POSITION: Vector2 = Vector2(50, 80)
const FLOATING_OFFSET: float = -60.0
const ANIM_SPEED: float = 0.2

var tiktak_sound: AudioStreamPlayer

# --- CORE ARRAY VARIABLES ---
var main_array: Array[int] = []
var initial_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []
var sorted_array: Array[int] = []

# --- MERGE SORT STATE ---
enum MergePhase { IDLE, MERGING }
var current_phase: MergePhase = MergePhase.IDLE
var merge_stages: Array = []  # List of subarrays: [start, end]
var current_stage_index: int = 0
var current_subarray_start: int = 0
var current_subarray_end: int = 0
var current_sort_position: int = 0  # Position we're filling
var current_min_index: int = 0      # Index of smallest element

# --- GENERAL VARIABLES ---
var comparison_counter: int = 0
var swap_counter: int = 0
var correct_moves: int = 0
var mistake_counter: int = 0
var sorting_complete: bool = false
var is_sorting: bool = false
var is_animating: bool = false

# Tween tracking
var current_tween: Tween = null

# Undo/Redo stacks
var undo_stack: Array = []
var redo_stack: Array = []

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

# Intro Text
var intro_step: int = 0
var intro_texts = [
	"WELCOME TO MERGE SORT SIMULATION! 🎯\n\nMerge Sort is a 'divide and conquer' algorithm that:\n1. Divides the array into smaller subarrays\n2. Sorts each subarray\n3. Merges them back together",
	"THE MERGE PROCESS 🔄\n\n• Two adjacent sorted subarrays are compared\n• Elements 'float up' to show they're being merged\n• Compare the leftmost elements of each subarray\n• The smaller element gets placed in the merged result",
	"HOW TO PLAY 🎮\n\n• Two blocks will float up for comparison\n• If left > right, DRAG them to swap\n• If left <= right, click PASS\n• Correct swaps/passes increase your score\n• Wrong moves are allowed but count as mistakes",
	"VISUAL CUES 👁️\n\n• BLUE outline = Left subarray\n• YELLOW outline = Right subarray\n• Floating blocks = Currently being merged\n• GREEN blocks = Sorted and locked",
	"DIFFICULTY LEVELS 📊\n\nEASY (Size 4): No time limit\nMEDIUM (Size 5): 90 seconds\nHARD (Size 7): 60 seconds\n\nUndo/Redo are disabled in Hard mode!"
]

# --- CODE TUTORIAL DATA ---
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Complexity Analysis:\nTime: O(n log n) | Space: O(n)" },
	{ "lines": [3, 4, 5], "text": "2. Merge Function:\nCombines two sorted subarrays." },
	{ "lines": [8, 9, 10], "text": "3. Comparison Loop:\nCompare elements from left and right subarrays." },
	{ "lines": [14, 15], "text": "4. Copy Remaining:\nAdd any leftover elements." },
	{ "lines": [21, 22, 23], "text": "5. Iterative Merge Sort:\nControl subarray sizes (1,2,4...)." }
]

var python_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Merge Function:\nTakes array and indices." },
	{ "lines": [2, 3], "text": "2. Create temp arrays:\nCopy left and right portions." },
	{ "lines": [6, 7, 8], "text": "3. Merge Loop:\nPick smaller element from L or R." },
	{ "lines": [10, 11], "text": "4. Cleanup:\nCopy remaining elements." }
]

var java_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Merge Method:\nStatic helper function." },
	{ "lines": [2, 3, 4], "text": "2. Create temp arrays:\nL[] and R[] for left/right." },
	{ "lines": [7, 8, 9], "text": "3. Comparison:\nMerge while both arrays have elements." },
	{ "lines": [13, 14, 15], "text": "4. Sort Method:\nIterative approach with width." }
]

var c_tutorial_data = [
	{ "lines": [0], "text": "1. Includes:\nStandard libraries." },
	{ "lines": [1, 2, 3], "text": "2. Merge Function:\nClassic merge implementation." },
	{ "lines": [5, 6, 7], "text": "3. Comparison:\nWhile i < n1 and j < n2." },
	{ "lines": [13, 14, 15], "text": "4. Iterative Sort:\nLoop over subarray sizes." }
]

# --- ASSESSMENT VARIABLES ---
enum SimMode { LECTURE, ASSESSMENT }
var sim_mode: SimMode = SimMode.ASSESSMENT
var difficulty := 3
var time_remaining: float = 0.0
var timer_running: bool = false
var assessment_time_limit: float = 0.0
var has_completed_assessment: bool = false
var coins_earned: int = 0
var completion_type: String = ""

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

# ==============================================
#   READY & INITIALIZATION
# ==============================================

func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	difficulty = Global.current_difficulty
	if difficulty == 0:
		difficulty = 3
	
	tiktak_sound = AudioStreamPlayer.new()
	tiktak_sound.stream = TIKTAK_SFX
	add_child(tiktak_sound)
	try_again_button.visible = false
	
	print("Program started — initializing Merge Sort visualizer...")
	randomize()
	
	_setup_result_popup()
	
	sim_mode = SimMode.ASSESSMENT
	assessment_time_limit = _get_time_limit()
	time_remaining = assessment_time_limit
	timer_running = false
	set_process(true)
	
	# Hide UI elements initially
	_hide_initial_ui()
	
	# Setup buttons
	if sort_btn: sort_btn.text = "UNDO"
	if auto_btn: auto_btn.text = "REDO"
	if pass_btn: pass_btn.text = "PASS"
	
	_start_assessment_mode()
	call_deferred("show_introduction")
	
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")
	
	_connect_signals()
	_connect_language_buttons()
	_update_difficulty_label()
	_setup_timeline_popup_for_mobile()
	_setup_compiler()

func _setup_result_popup():
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
	
	try_again_result_btn.pressed.connect(_on_try_again_result_pressed)
	back_result_btn.pressed.connect(_on_back_result_pressed)
	translate_code_btn.pressed.connect(_on_translate_code_pressed)

func _hide_initial_ui():
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if ptr_extra1: ptr_extra1.hide()
	if ptr_extra2: ptr_extra2.hide()
	
	if left_subarray_outline: left_subarray_outline.hide()
	if right_subarray_outline: right_subarray_outline.hide()
	if merge_status_label: merge_status_label.hide()

func _connect_signals():
	_ensure_connected(pass_btn, "pressed", _on_pass_pressed)
	_ensure_connected(sort_btn, "pressed", _on_sort_button_pressed)
	_ensure_connected(auto_btn, "pressed", _on_waiting_pressed)
	_ensure_connected(timeline_btn, "pressed", _on_timeline_pressed)
	_ensure_connected(complete_ok_btn, "pressed", _on_complete_ok_pressed)
	_ensure_connected(show_cpp_btn, "pressed", _on_show_cpp_pressed)
	_ensure_connected(cpp_code_button, "pressed", _on_cpp_code_button_pressed)
	_ensure_connected(cpp_close_btn, "pressed", _on_cpp_close_pressed)
	_ensure_connected(try_again_btn_root, "pressed", _on_try_again_root_pressed)
	_ensure_connected(time_up_try_again_btn, "pressed", _on_time_up_try_again_pressed)
	_ensure_connected(time_up_back_btn, "pressed", _on_time_up_back_pressed)
	_ensure_connected(tutorial_next, "pressed", _on_next_button_pressed)
	_ensure_connected(sim_yes_btn, "pressed", _on_yes_pressed)
	_ensure_connected(sim_no_btn, "pressed", _on_no_pressed)
	
	if timeline_close_btn:
		timeline_close_btn.pressed.connect(_on_timeline_close_pressed)
	
	clock.centered = true
	clock.position = Vector2(0, 18)

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

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
#   ARRAY & BLOCK MANAGEMENT
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
	
	if current_tween:
		current_tween.kill()
		current_tween = null
	
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
	
	_update_ui_labels()
	if cpp_code_button: cpp_code_button.hide()

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

func _resnap_blocks():
	print("=== _resnap_blocks called ===")
	var x = START_POSITION.x
	for i in range(block_nodes.size()):
		var target_y = START_POSITION.y
		# Check if this block is in the current floating subarray
		if current_phase == MergePhase.MERGING and i >= current_subarray_start and i <= current_subarray_end:
			target_y = START_POSITION.y + FLOATING_OFFSET
			print("Block ", i, " should float at y: ", target_y)
		else:
			print("Block ", i, " should be at ground y: ", target_y)
		
		var target_pos = Vector2(x, target_y)
		var tween = create_tween()
		tween.tween_property(block_nodes[i], "position", target_pos, ANIM_SPEED)
		x += block_nodes[i].size.x + BLOCK_SPACING
	
	await get_tree().create_timer(ANIM_SPEED).timeout

func _snap_block_back(block: Control):
	var index = block_nodes.find(block)
	if index != -1:
		var target_x = START_POSITION.x
		for i in range(index):
			target_x += block_nodes[i].size.x + BLOCK_SPACING
		
		var target_y = START_POSITION.y
		if current_phase == MergePhase.MERGING and index >= current_subarray_start and index <= current_subarray_end:
			target_y = START_POSITION.y + FLOATING_OFFSET
		
		var tween = create_tween()
		tween.tween_property(block, "position", Vector2(target_x, target_y), 0.2)
		await tween.finished

# ==============================================
#   MERGE SORT LOGIC
# ==============================================

func _init_merge_sort():
	_build_merge_stages()
	current_stage_index = 0
	_start_next_stage()

func _build_merge_stages():
	merge_stages.clear()
	var n = main_array.size()
	
	var size = 2
	while size <= n:
		for start in range(0, n, size):
			var end = min(start + size - 1, n - 1)
			merge_stages.append([start, end])
		size *= 2
	
	# CRITICAL FIX: For arrays where size doesn't reach n (like 7), add final full array pass
	if size > n and size / 2 < n:
		# Add the full array as one final pass
		merge_stages.append([0, n - 1])
	
	print("Merge stages: ", merge_stages)

func _start_next_stage():
	print("=== _start_next_stage called ===")
	print("current_stage_index: ", current_stage_index)
	print("merge_stages size: ", merge_stages.size())
	
	if current_stage_index >= merge_stages.size():
		print("All sorting complete!")
		# Make sure all blocks are at ground level
		for i in range(block_nodes.size()):
			if block_nodes[i]:
				var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
				tween.tween_property(block_nodes[i], "position:y", START_POSITION.y, ANIM_SPEED)
		if _check_if_sorted():
			_end_assessment("sorted")
		return
	
	current_subarray_start = merge_stages[current_stage_index][0]
	current_subarray_end = merge_stages[current_stage_index][1]
	current_sort_position = current_subarray_start
	current_phase = MergePhase.MERGING
	
	print("=== Sorting subarray ", current_subarray_start, "-", current_subarray_end, " ===")
	print("block_nodes size: ", block_nodes.size())
	
	# CRITICAL: For the final pass (full array), reset all blocks to normal color first
	if current_subarray_start == 0 and current_subarray_end == main_array.size() - 1:
		print("!!! FINAL FULL ARRAY PASS - Resetting all blocks !!!")
		for i in range(block_nodes.size()):
			if block_nodes[i]:
				# Reset visual state
				if block_nodes[i].has_method("set_highlight"):
					block_nodes[i].set_highlight(false)
				block_nodes[i].modulate = Color(1, 1, 1, 1)
				block_nodes[i].draggable = true
	
	print("Floating blocks from ", current_subarray_start, " to ", current_subarray_end)
	
	# Float ALL blocks in this subarray
	for i in range(current_subarray_start, current_subarray_end + 1):
		if i < block_nodes.size() and block_nodes[i]:
			print("Floating block at index: ", i, " value: ", main_array[i])
			var target_y = START_POSITION.y + FLOATING_OFFSET
			var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(block_nodes[i], "position:y", target_y, ANIM_SPEED)
		else:
			print("ERROR: Cannot float block at index ", i, " - out of bounds or null")
	
	# Show outline
	_show_subarray_outline(current_subarray_start, current_subarray_end)
	
	# Find first minimum
	print("Calling _find_min_in_unsorted")
	_find_min_in_unsorted()

func _show_subarray_outline(start: int, end: int):
	print("=== _show_subarray_outline called with start=", start, " end=", end)
	if not left_subarray_outline:
		print("left_subarray_outline is null")
		return
	
	if start < block_nodes.size() and end < block_nodes.size():
		var first_block = block_nodes[start]
		var last_block = block_nodes[end]
		
		if first_block and last_block:
			left_subarray_outline.global_position = first_block.global_position - Vector2(10, 10)
			left_subarray_outline.size = Vector2(
				(last_block.global_position.x + last_block.size.x) - first_block.global_position.x + 20,
				first_block.size.y + 20
			)
			left_subarray_outline.color = Color(0, 0.5, 1, 0.3)
			left_subarray_outline.show()
			right_subarray_outline.hide()
			print("Outline shown from ", first_block.global_position, " to ", last_block.global_position)
		else:
			print("First or last block is null")
	else:
		print("Start or end out of bounds - start:", start, " end:", end, " block_nodes size:", block_nodes.size())

func _find_min_in_unsorted():
	print("=== _find_min_in_unsorted called ===")
	
	if current_sort_position > current_subarray_end:
		_complete_subarray()
		return
	
	# Find smallest from current_sort_position to end
	current_min_index = current_sort_position
	var min_value = main_array[current_min_index]
	
	for i in range(current_sort_position + 1, current_subarray_end + 1):
		if i < main_array.size():
			if main_array[i] < min_value:
				min_value = main_array[i]
				current_min_index = i
	
	# Clear old highlights
	_clear_highlights()
	
	# Highlight the smallest
	if current_min_index < block_nodes.size() and block_nodes[current_min_index]:
		block_nodes[current_min_index].set_highlight(true)
		block_nodes[current_min_index].draggable = true
	
	# Update pointers
	_update_pointers(current_sort_position, current_min_index)
	
	# Update status label
	if status_label:
		if current_min_index == current_sort_position:
			status_label.text = "✓ %d is correct. Click PASS." % main_array[current_min_index]
		else:
			status_label.text = "➡️ Drag HIGHLIGHTED block (%d) to position %d" % [main_array[current_min_index], current_sort_position]


func _update_pointers(left_idx: int, right_idx: int):
	if block_nodes.is_empty(): return
	
	if ptr_left: ptr_left.show()
	if ptr_right: ptr_right.show()
	
	if left_idx >= 0 and left_idx < block_nodes.size() and block_nodes[left_idx]:
		var node = block_nodes[left_idx]
		if ptr_left:
			ptr_left.global_position = node.global_position + Vector2(16, node.size.y -200)
			ptr_left.modulate = Color(0, 0, 1, 1)
	
	if right_idx >= 0 and right_idx < block_nodes.size() and block_nodes[right_idx]:
		var node = block_nodes[right_idx]
		if ptr_right:
			ptr_right.global_position = node.global_position + Vector2(16, node.size.y + 30)
			ptr_right.modulate = Color(1, 1, 0, 1)

func _clear_highlights():
	for i in range(block_nodes.size()):
		if block_nodes[i] and block_nodes[i].has_method("set_highlight"):
			block_nodes[i].set_highlight(false)

func _complete_subarray():
	print("Subarray ", current_subarray_start, "-", current_subarray_end, " sorted!")
	timeline_log.append("[color=green]--- Subarray [%d-%d] sorted! ---[/color]" % [current_subarray_start, current_subarray_end])
	
	# Drop blocks back down
	for i in range(current_subarray_start, current_subarray_end + 1):
		if i < block_nodes.size() and block_nodes[i]:
			var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(block_nodes[i], "position:y", START_POSITION.y, ANIM_SPEED)
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if left_subarray_outline: left_subarray_outline.hide()
	_clear_highlights()
	
	# Update UI labels when subarray completes
	_update_ui_labels()
	_update_timeline_display()
	
	# Move to next stage
	current_stage_index += 1
	_start_next_stage()

# ==============================================
#   USER ACTIONS
# ==============================================

func _on_pass_pressed():
	if has_completed_assessment or sorting_complete:
		return
	
	if current_phase != MergePhase.MERGING:
		return
	
	if current_sort_position > current_subarray_end:
		_complete_subarray()
		return
	
	# Check if the element at current_sort_position is the smallest in the remaining array
	if current_min_index == current_sort_position:
		# CORRECT PASS
		correct_moves += 1
		comparison_counter += 1
		timeline_log.append("[color=green]✓ PASS: %d already correct at position %d[/color]" % [main_array[current_sort_position], current_sort_position])
		show_feedback("Correct PASS! %d is in place" % main_array[current_sort_position], Color.GREEN, block_nodes[current_sort_position].global_position)
		
		if block_nodes[current_sort_position].has_method("set_sorted_visual"):
			block_nodes[current_sort_position].set_sorted_visual()
		
		current_sort_position += 1
		
		if current_sort_position > current_subarray_end:
			_complete_subarray()
		else:
			_find_min_in_unsorted()
	else:
		# WRONG PASS - should have swapped
		mistake_counter += 1
		comparison_counter += 1
		timeline_log.append("[color=red]✗ WRONG PASS: %d should be moved to position %d[/color]" % [main_array[current_min_index], current_sort_position])
		show_feedback("Wrong PASS! Drag %d to position %d!" % [main_array[current_min_index], current_sort_position], Color.RED, block_nodes[current_sort_position].global_position)
		
		# Flash red on the block that should be moved
		if current_min_index < block_nodes.size() and block_nodes[current_min_index]:
			var original_color = block_nodes[current_min_index].modulate
			block_nodes[current_min_index].modulate = Color(1, 0.5, 0.5, 1)
			await get_tree().create_timer(0.3).timeout
			block_nodes[current_min_index].modulate = original_color
		
		# IMPORTANT: Update UI labels even on wrong moves
		_update_ui_labels()
		_update_timeline_display()
		return  # Don't proceed to next position
	
	# Update UI labels after correct moves
	_update_ui_labels()
	_update_timeline_display()
	_update_undo_redo_buttons()

func _on_block_dropped(dropped_block: Control) -> void:
	print("=== _on_block_dropped called ===")
	
	if has_completed_assessment or sorting_complete:
		_snap_block_back(dropped_block)
		return
	
	if current_phase != MergePhase.MERGING:
		_snap_block_back(dropped_block)
		return
	
	var old_index = block_nodes.find(dropped_block)
	if old_index == -1:
		return
	
	# Check if this is the highlighted minimum element
	if old_index != current_min_index:
		# WRONG BLOCK DRAGGED
		mistake_counter += 1
		timeline_log.append("[color=red]✗ WRONG BLOCK: Dragged block %d (should drag %d)[/color]" % [main_array[old_index], main_array[current_min_index]])
		show_feedback("Wrong block! Drag the HIGHLIGHTED block!", Color.RED, dropped_block.global_position)
		
		# Flash the correct block
		if current_min_index < block_nodes.size() and block_nodes[current_min_index]:
			var original_color = block_nodes[current_min_index].modulate
			block_nodes[current_min_index].modulate = Color(1, 0.5, 0.5, 1)
			await get_tree().create_timer(0.5).timeout
			block_nodes[current_min_index].modulate = original_color
		
		_snap_block_back(dropped_block)
		
		# Update UI labels after wrong move
		_update_ui_labels()
		_update_timeline_display()
		return
	
	if current_sort_position > current_subarray_end:
		_complete_subarray()
		_snap_block_back(dropped_block)
		return
	
	# Find drop position
	var center_x = dropped_block.position.x + dropped_block.size.x * 0.5
	var drop_index = 0
	for i in range(block_nodes.size()):
		var c = block_nodes[i]
		var c_center = c.position.x + c.size.x * 0.5
		if center_x > c_center:
			drop_index += 1
	
	# Check if dropped at correct position
	if drop_index != current_sort_position:
		# WRONG DROP POSITION
		mistake_counter += 1
		timeline_log.append("[color=red]✗ WRONG POSITION: Dropped at %d (should be %d)[/color]" % [drop_index, current_sort_position])
		show_feedback("Wrong position! Drop at %d!" % current_sort_position, Color.RED, dropped_block.global_position)
		
		# Flash the target position
		if current_sort_position < block_nodes.size() and block_nodes[current_sort_position]:
			var original_color = block_nodes[current_sort_position].modulate
			block_nodes[current_sort_position].modulate = Color(1, 0.5, 0.5, 1)
			await get_tree().create_timer(0.5).timeout
			block_nodes[current_sort_position].modulate = original_color
		
		_snap_block_back(dropped_block)
		
		# Update UI labels after wrong move
		_update_ui_labels()
		_update_timeline_display()
		return
	
	# CORRECT SWAP
	_save_state()
	
	var moving_val = main_array.pop_at(old_index)
	main_array.insert(current_sort_position, moving_val)
	
	var moving_block = block_nodes.pop_at(old_index)
	block_nodes.insert(current_sort_position, moving_block)
	
	is_animating = true
	await _resnap_blocks()
	is_animating = false
	
	correct_moves += 1
	swap_counter += 1
	comparison_counter += 1
	timeline_log.append("[color=green]✓ SWAP: Moved %d to position %d[/color]" % [moving_val, current_sort_position])
	show_feedback("Correct! %d placed at %d" % [moving_val, current_sort_position], Color.GREEN, dropped_block.global_position)
	
	if block_nodes[current_sort_position].has_method("set_sorted_visual"):
		block_nodes[current_sort_position].set_sorted_visual()
	
	current_sort_position += 1
	
	if current_sort_position > current_subarray_end:
		_complete_subarray()
	else:
		_find_min_in_unsorted()
	
	# Update UI labels after correct move
	_update_ui_labels()
	_update_timeline_display()
	_update_undo_redo_buttons()

# ==============================================
#   UNDO/REDO
# ==============================================

func _save_state() -> void:
	var state := {
		"array": main_array.duplicate(),
		"current_stage_index": current_stage_index,
		"current_subarray_start": current_subarray_start,
		"current_subarray_end": current_subarray_end,
		"current_sort_position": current_sort_position,
		"current_min_index": current_min_index,
		"current_phase": current_phase,
		"correct_moves": correct_moves,
		"mistake_counter": mistake_counter,
		"comparison_counter": comparison_counter,
		"swap_counter": swap_counter,
		"timeline": timeline_log.duplicate()
	}
	undo_stack.append(state)

func _restore_state(state: Dictionary) -> void:
	main_array = state["array"].duplicate()
	timeline_log = state.get("timeline", timeline_log).duplicate()
	
	current_stage_index = state["current_stage_index"]
	current_subarray_start = state["current_subarray_start"]
	current_subarray_end = state["current_subarray_end"]
	current_sort_position = state["current_sort_position"]
	current_min_index = state["current_min_index"]
	current_phase = state["current_phase"]
	correct_moves = state["correct_moves"]
	mistake_counter = state["mistake_counter"]
	comparison_counter = state["comparison_counter"]
	swap_counter = state["swap_counter"]
	
	_rebuild_blocks_from_array()
	
	if current_phase == MergePhase.MERGING:
		for i in range(current_subarray_start, current_subarray_end + 1):
			if i < block_nodes.size() and block_nodes[i]:
				var target_y = START_POSITION.y + FLOATING_OFFSET
				var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
				tween.tween_property(block_nodes[i], "position:y", target_y, ANIM_SPEED)
		_show_subarray_outline(current_subarray_start, current_subarray_end)
		_find_min_in_unsorted()
	else:
		if left_subarray_outline: left_subarray_outline.hide()
		if right_subarray_outline: right_subarray_outline.hide()
		if ptr_left: ptr_left.hide()
		if ptr_right: ptr_right.hide()
		_clear_highlights()

func _on_sort_button_pressed() -> void:  # UNDO
	if has_completed_assessment or sorting_complete or not _can_undo() or undo_stack.is_empty():
		return
	
	btn_sound.play()
	var state = undo_stack.pop_back()
	
	redo_stack.append({
		"array": main_array.duplicate(),
		"current_stage_index": current_stage_index,
		"current_subarray_start": current_subarray_start,
		"current_subarray_end": current_subarray_end,
		"current_sort_position": current_sort_position,
		"current_min_index": current_min_index,
		"current_phase": current_phase,
		"correct_moves": correct_moves,
		"mistake_counter": mistake_counter,
		"comparison_counter": comparison_counter,
		"swap_counter": swap_counter
	})
	
	_restore_state(state)
	timeline_log.append("[color=gray]Undo: reverted last action[/color]")
	_update_timeline_display()
	_update_ui_labels()
	_update_undo_redo_buttons()

func _on_waiting_pressed() -> void:  # REDO
	if has_completed_assessment or sorting_complete or not _can_redo() or redo_stack.is_empty():
		return
	
	btn_sound.play()
	var state = redo_stack.pop_back()
	
	undo_stack.append({
		"array": main_array.duplicate(),
		"current_stage_index": current_stage_index,
		"current_subarray_start": current_subarray_start,
		"current_subarray_end": current_subarray_end,
		"current_sort_position": current_sort_position,
		"current_min_index": current_min_index,
		"current_phase": current_phase,
		"correct_moves": correct_moves,
		"mistake_counter": mistake_counter,
		"comparison_counter": comparison_counter,
		"swap_counter": swap_counter
	})
	
	_restore_state(state)
	timeline_log.append("[color=gray]Redo: reapplied action[/color]")
	_update_timeline_display()
	_update_ui_labels()
	_update_undo_redo_buttons()

func _can_undo() -> bool:
	return not sorting_complete and timer_running and difficulty != 3

func _can_redo() -> bool:
	return not sorting_complete and timer_running and difficulty != 3

func _update_undo_redo_buttons():
	if not sort_btn or not auto_btn:
		return
	
	var undo_allowed = _can_undo()
	var redo_allowed = _can_redo()
	
	sort_btn.disabled = not undo_allowed
	auto_btn.disabled = not redo_allowed
	
	sort_btn.modulate = Color(1, 1, 1, 1) if undo_allowed and not undo_stack.is_empty() else Color(0.5, 0.5, 0.5, 0.5)
	auto_btn.modulate = Color(1, 1, 1, 1) if redo_allowed and not redo_stack.is_empty() else Color(0.5, 0.5, 0.5, 0.5)

# ==============================================
#   UI HELPERS
# ==============================================

func _update_ui_labels():
	compare_label.text = "Correct: %d | Mistakes: %d | Comparisons: %d | Swaps: %d" % [correct_moves, mistake_counter, comparison_counter, swap_counter]
	
	# Force immediate update
	compare_label.queue_redraw()

func _check_if_sorted() -> bool:
	for i in range(main_array.size() - 1):
		if main_array[i] > main_array[i + 1]:
			return false
	return true

func show_feedback(text: String, color: Color, position: Vector2) -> void:
	var feedback_scene = preload("res://scene/FeedbackLabel.tscn")
	var label = feedback_scene.instantiate()
	label.text = text
	label.modulate = color
	label.global_position = position + Vector2(0, -20)
	add_child(label)
	
	var anim_player: AnimationPlayer = label.get_node("AnimationPlayer")
	anim_player.play("notification_pop")
	anim_player.animation_finished.connect(func(_a): label.queue_free())

func _set_main_ui_enabled(enabled: bool) -> void:
	if sort_btn: sort_btn.disabled = not enabled
	if auto_btn: auto_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled
	if pass_btn: pass_btn.disabled = not enabled

# ==============================================
#   ASSESSMENT & GRADING
# ==============================================

func _get_array_size() -> int:
	match difficulty:
		1: return 4
		2: return 5
		3: return 7
	return 5

func _get_time_limit() -> float:
	match difficulty:
		1: return 0
		2: return 90.0
		3: return 60.0
	return 90.0

func _update_difficulty_label():
	if difficulty_label:
		match difficulty:
			1: difficulty_label.text = "Difficulty: Easy"
			2: difficulty_label.text = "Difficulty: Medium"
			3: difficulty_label.text = "Difficulty: Hard"

func _start_assessment_mode():
	reset_cache_for_scene()
	try_again_button.visible = false
	
	if pass_btn:
		pass_btn.disabled = false
		pass_btn.modulate = Color(1, 1, 1, 1)
	
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
	sorting_complete = false
	is_sorting = false
	is_animating = false
	has_completed_assessment = false
	completion_type = ""
	coins_earned = 0
	
	undo_stack.clear()
	redo_stack.clear()
	timeline_log.clear()
	
	sim_mode = SimMode.ASSESSMENT
	assessment_time_limit = _get_time_limit()
	time_remaining = assessment_time_limit
	timer_running = true
	_update_difficulty_label()
	
	if cpp_code_button: cpp_code_button.hide()
	if translate_code_btn: translate_code_btn.hide()
	
	if difficulty == 1:
		timer_label.hide()
		timer_running = false
		clock.visible = false
		clock.stop()
	else:
		timer_label.show()
		timer_running = false
		await get_tree().process_frame
		clock.visible = true
		clock.modulate = Color(1, 1, 1, 1)
		clock.stop()
	
	var size: int = _get_array_size()
	var arr: Array[int] = []
	for i in range(size):
		arr.append(randi_range(1, 99))
	
	_initialize_with_elements(arr)
	_init_merge_sort()
	_update_undo_redo_buttons()

func _process(delta: float) -> void:
	if sim_mode != SimMode.ASSESSMENT or not timer_running or sorting_complete:
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
	
	if time_remaining <= 10.0 and timer_running and not tiktak_sound.playing:
		tiktak_sound.play()

func _on_time_up() -> void:
	tiktak_sound.stop()
	show_feedback("Time's Up!", Color.RED, START_POSITION)
	timer_running = false
	is_sorting = true
	_end_assessment("timeout")

func _end_assessment(reason: String) -> void:
	if has_completed_assessment:
		return
	
	has_completed_assessment = true
	completion_type = reason
	
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	timer_running = false
	tiktak_sound.stop()
	is_sorting = true
	is_animating = false
	
	if sort_btn: sort_btn.disabled = true
	if auto_btn: auto_btn.disabled = true
	if pass_btn: pass_btn.disabled = true
	if timeline_btn: timeline_btn.disabled = false
	
	for block in block_nodes:
		if block:
			block.draggable = false
			block.modulate = Color(0.8, 0.8, 0.8, 1)
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if left_subarray_outline: left_subarray_outline.hide()
	if right_subarray_outline: right_subarray_outline.hide()
	
	for i in range(block_nodes.size()):
		if block_nodes[i] and block_nodes[i].has_method("set_highlight"):
			block_nodes[i].set_highlight(false)
	
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

func _compute_grade() -> Dictionary:
	var total_moves = correct_moves + mistake_counter
	
	if total_moves == 0:
		return {
			"passed": true,
			"accuracy": 100.0,
			"total_moves": 0,
			"correct_moves": 0,
			"mistake_counter": 0,
			"time_used": assessment_time_limit - time_remaining,
			"coins": 0,
			"required": _get_required_threshold() * 100
		}
	
	# Accuracy based on correct moves vs total moves
	var accuracy = float(correct_moves) / max(total_moves, 1) * 100
	var required_threshold = _get_required_threshold() * 100
	var passed = accuracy >= required_threshold
	var time_used = assessment_time_limit - time_remaining
	coins_earned = 0
	
	print("Grade calculation:")
	print("  Correct moves: ", correct_moves)
	print("  Mistakes: ", mistake_counter)
	print("  Total moves: ", total_moves)
	print("  Accuracy: ", accuracy, "%")
	print("  Required: ", required_threshold, "%")
	print("  Passed: ", passed)
	
	return {
		"passed": passed,
		"accuracy": accuracy,
		"total_moves": total_moves,
		"correct_moves": correct_moves,
		"mistake_counter": mistake_counter,
		"time_used": time_used,
		"coins": 0,
		"required": required_threshold
	}

func _get_required_threshold() -> float:
	match difficulty:
		1: return 0.6
		2: return 0.75
		3: return 0.8
	return 0.7

func _show_result_popup(result: String, grade_data: Dictionary = {}) -> void:
	if not result_popup:
		return
	
	if complete_popup and complete_popup.visible:
		complete_popup.hide()
	
	if result == "PASS":
		result_title.text = "PASSED!"
		result_title.modulate = Color(0, 1, 0)
		if translate_code_btn: translate_code_btn.show()
		if cpp_code_button: cpp_code_button.show()
		if code_anim: code_anim.play("default")
		try_again_button.visible = false
	else:
		result_title.text = "FAILED!"
		result_title.modulate = Color(1, 0, 0)
		if translate_code_btn: translate_code_btn.hide()
		if cpp_code_button: cpp_code_button.hide()
		try_again_button.visible = true
	
	if completion_type == "timeout":
		score_summary.text = "Time's Up!"
		accuracy_label.text = "Accuracy: 0%"
		var total_seconds = int(assessment_time_limit)
		var minutes = total_seconds / 60
		var seconds = total_seconds % 60
		time_used_label.text = "Time: %02d:%02d" % [minutes, seconds]
		coins_label.text = "+0"
		if translate_code_btn: translate_code_btn.hide()
		if cpp_code_button: cpp_code_button.hide()
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

func _on_try_again_button_pressed():
	btn_sound.play()
	result_popup.hide()
	for block in block_nodes:
		if block:
			block.draggable = true
			block.modulate = Color.WHITE
	_start_assessment_mode()
	await get_tree().process_frame
	_update_undo_redo_buttons()

func _on_try_again_result_pressed():
	btn_sound.play()
	result_popup.hide()
	for block in block_nodes:
		if block:
			block.draggable = true
			block.modulate = Color.WHITE
	_start_assessment_mode()
	await get_tree().process_frame
	_update_undo_redo_buttons()

func _on_back_result_pressed():
	btn_sound.play()
	result_popup.hide()

# ==============================================
#   CODE VISUALIZER & TUTORIAL
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
			code = get_cpp_merge_code(arr_str)
			current_tutorial_data = cpp_tutorial_data
		"python":
			code = get_python_merge_code(arr_str)
			current_tutorial_data = python_tutorial_data
		"java":
			code = get_java_merge_code(arr_str)
			current_tutorial_data = java_tutorial_data
		"c":
			code = get_c_merge_code(arr_str)
			current_tutorial_data = c_tutorial_data
	
	if cpp_text:
		cpp_text.text = code
	
	cpp_popup.popup_centered()
	cpp_tutorial_step = 0
	
	if cpp_next_btn and not cpp_next_btn.is_connected("pressed", _on_cpp_next_pressed):
		cpp_next_btn.pressed.connect(_on_cpp_next_pressed)
	
	if cpp_tutorial_panel:
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
			"cpp": base_code = get_cpp_merge_code(arr_str)
			"python": base_code = get_python_merge_code(arr_str)
			"java": base_code = get_java_merge_code(arr_str)
			"c": base_code = get_c_merge_code(arr_str)
		
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

func get_cpp_merge_code(arr: String) -> String:
	return """/* Merge Sort - Time Complexity: O(n log n) */
#include <iostream>
#include <algorithm>
using namespace std;

void printArray(int arr[], int n) {
	cout << "[";
	for (int i = 0; i < n; i++) {
		cout << arr[i];
		if (i < n - 1) cout << ", ";
	}
	cout << "]" << endl;
}

void merge(int arr[], int left, int mid, int right) {
	int n1 = mid - left + 1;
	int n2 = right - mid;
	
	int L[n1], R[n2];
	
	for (int i = 0; i < n1; i++)
		L[i] = arr[left + i];
	for (int j = 0; j < n2; j++)
		R[j] = arr[mid + 1 + j];
	
	int i = 0, j = 0, k = left;
	
	while (i < n1 && j < n2) {
		if (L[i] <= R[j]) {
			arr[k] = L[i];
			i++;
		} else {
			arr[k] = R[j];
			j++;
		}
		k++;
		cout << "After comparing " << (i > 0 ? L[i-1] : L[0]) << " and " << (j > 0 ? R[j-1] : R[0]) << ": ";
		printArray(arr, right - left + 1);
	}
	
	while (i < n1) {
		arr[k] = L[i];
		i++;
		k++;
		cout << "After copying from left: ";
		printArray(arr, right - left + 1);
	}
	
	while (j < n2) {
		arr[k] = R[j];
		j++;
		k++;
		cout << "After copying from right: ";
		printArray(arr, right - left + 1);
	}
	
	cout << "Merge of [" << left << "-" << right << "] complete: ";
	printArray(arr, right - left + 1);
}

void mergeSort(int arr[], int n) {
	for (int width = 1; width < n; width *= 2) {
		cout << "\\n=== Merging width = " << width << " ===" << endl;
		for (int i = 0; i < n; i += 2 * width) {
			int left = i;
			int mid = min(i + width - 1, n - 1);
			int right = min(i + 2 * width - 1, n - 1);
			
			if (mid < right) {
				cout << "\\nMerging [" << left << "-" << mid << "] and [" << mid+1 << "-" << right << "]:" << endl;
				merge(arr, left, mid, right);
			}
		}
		cout << "After width " << width << ": ";
		printArray(arr, n);
	}
}

int main() {
	int arr[] = { %s };
	int n = sizeof(arr) / sizeof(arr[0]);
	
	cout << "Initial array (unsorted): ";
	printArray(arr, n);
	cout << endl;
	
	mergeSort(arr, n);
	
	cout << endl << "Sorted array: ";
	printArray(arr, n);
	
	return 0;
}""" % arr

func get_python_merge_code(arr: String) -> String:
	return """# Merge Sort - Time Complexity: O(n log n)

def print_array(arr, sub_arr=False):
	if sub_arr:
		print("[", end="")
		for i in range(len(arr)):
			print(arr[i], end="")
			if i < len(arr) - 1:
				print(", ", end="")
		print("]")
	else:
		print("[", end="")
		for i in range(len(arr)):
			print(arr[i], end="")
			if i < len(arr) - 1:
				print(", ", end="")
		print("]")

def merge(arr, left, mid, right):
	n1 = mid - left + 1
	n2 = right - mid
	
	L = arr[left:mid + 1]
	R = arr[mid + 1:right + 1]
	
	i = j = 0
	k = left
	
	while i < n1 and j < n2:
		if L[i] <= R[j]:
			arr[k] = L[i]
			i += 1
		else:
			arr[k] = R[j]
			j += 1
		k += 1
		print(f"  After comparing {L[i-1 if i > 0 else 0]} and {R[j-1 if j > 0 else 0]}: ", end="")
		print_array(arr[left:right+1], True)
	
	while i < n1:
		arr[k] = L[i]
		i += 1
		k += 1
		print("  After copying from left: ", end="")
		print_array(arr[left:right+1], True)
	
	while j < n2:
		arr[k] = R[j]
		j += 1
		k += 1
		print("  After copying from right: ", end="")
		print_array(arr[left:right+1], True)
	
	print(f"  Merge of [{left}-{right}] complete: ", end="")
	print_array(arr[left:right+1], True)

def merge_sort(arr):
	n = len(arr)
	width = 1
	while width < n:
		print(f"\\n=== Merging width = {width} ===")
		for i in range(0, n, 2 * width):
			left = i
			mid = min(i + width - 1, n - 1)
			right = min(i + 2 * width - 1, n - 1)
			
			if mid < right:
				print(f"\\nMerging [{left}-{mid}] and [{mid+1}-{right}]:")
				merge(arr, left, mid, right)
		print(f"After width {width}: ", end="")
		print_array(arr)
		width *= 2

arr = [%s]
print("Initial array (unsorted): ", end="")
print_array(arr)
print()

merge_sort(arr)

print()
print("Sorted array: ", end="")
print_array(arr)""" % arr

func get_java_merge_code(arr: String) -> String:
	return """// Merge Sort - Time Complexity: O(n log n)
import java.util.*;

public class Main {
	static void printArray(int[] arr) {
		System.out.print("[");
		for (int i = 0; i < arr.length; i++) {
			System.out.print(arr[i]);
			if (i < arr.length - 1) System.out.print(", ");
		}
		System.out.println("]");
	}
	
	static void printSubArray(int[] arr, int left, int right) {
		System.out.print("[");
		for (int i = left; i <= right; i++) {
			System.out.print(arr[i]);
			if (i < right) System.out.print(", ");
		}
		System.out.println("]");
	}
	
	static void merge(int[] arr, int left, int mid, int right) {
		int n1 = mid - left + 1;
		int n2 = right - mid;
		
		int[] L = new int[n1];
		int[] R = new int[n2];
		
		for (int i = 0; i < n1; i++)
			L[i] = arr[left + i];
		for (int j = 0; j < n2; j++)
			R[j] = arr[mid + 1 + j];
		
		int i = 0, j = 0, k = left;
		
		while (i < n1 && j < n2) {
			if (L[i] <= R[j]) {
				arr[k] = L[i];
				i++;
			} else {
				arr[k] = R[j];
				j++;
			}
			k++;
			System.out.print("  After comparing: ");
			printSubArray(arr, left, right);
		}
		
		while (i < n1) {
			arr[k] = L[i];
			i++;
			k++;
			System.out.print("  After copying from left: ");
			printSubArray(arr, left, right);
		}
		
		while (j < n2) {
			arr[k] = R[j];
			j++;
			k++;
			System.out.print("  After copying from right: ");
			printSubArray(arr, left, right);
		}
		
		System.out.print("  Merge of [" + left + "-" + right + "] complete: ");
		printSubArray(arr, left, right);
	}
	
	static void sort(int[] arr) {
		int n = arr.length;
		for (int width = 1; width < n; width *= 2) {
			System.out.println("\\n=== Merging width = " + width + " ===");
			for (int i = 0; i < n; i += 2 * width) {
				int left = i;
				int mid = Math.min(i + width - 1, n - 1);
				int right = Math.min(i + 2 * width - 1, n - 1);
				
				if (mid < right) {
					System.out.println("\\nMerging [" + left + "-" + mid + "] and [" + (mid+1) + "-" + right + "]:");
					merge(arr, left, mid, right);
				}
			}
			System.out.print("After width " + width + ": ");
			printArray(arr);
		}
	}
	
	public static void main(String[] args) {
		int[] arr = {%s};
		
		System.out.print("Initial array (unsorted): ");
		printArray(arr);
		System.out.println();
		
		sort(arr);
		
		System.out.println();
		System.out.print("Sorted array: ");
		printArray(arr);
	}
}""" % arr

func get_c_merge_code(arr: String) -> String:
	return """/* Merge Sort - Time Complexity: O(n log n) */
#include <stdio.h>
#include <stdlib.h>

void printArray(int arr[], int n) {
	printf("[");
	for (int i = 0; i < n; i++) {
		printf("%%d", arr[i]);
		if (i < n - 1) printf(", ");
	}
	printf("]\\n");
}

void printSubArray(int arr[], int left, int right) {
	printf("[");
	for (int i = left; i <= right; i++) {
		printf("%%d", arr[i]);
		if (i < right) printf(", ");
	}
	printf("]\\n");
}

void merge(int arr[], int left, int mid, int right) {
	int n1 = mid - left + 1;
	int n2 = right - mid;
	
	int L[n1], R[n2];
	
	for (int i = 0; i < n1; i++)
		L[i] = arr[left + i];
	for (int j = 0; j < n2; j++)
		R[j] = arr[mid + 1 + j];
	
	int i = 0, j = 0, k = left;
	
	while (i < n1 && j < n2) {
		if (L[i] <= R[j]) {
			arr[k] = L[i];
			i++;
		} else {
			arr[k] = R[j];
			j++;
		}
		k++;
		printf("  After comparing: ");
		printSubArray(arr, left, right);
	}
	
	while (i < n1) {
		arr[k] = L[i];
		i++;
		k++;
		printf("  After copying from left: ");
		printSubArray(arr, left, right);
	}
	
	while (j < n2) {
		arr[k] = R[j];
		j++;
		k++;
		printf("  After copying from right: ");
		printSubArray(arr, left, right);
	}
	
	printf("  Merge of [%%d-%%d] complete: ", left, right);
	printSubArray(arr, left, right);
}

void mergeSort(int arr[], int n) {
	for (int width = 1; width < n; width *= 2) {
		printf("\\n=== Merging width = %%d ===\\n", width);
		for (int i = 0; i < n; i += 2 * width) {
			int left = i;
			int mid = (i + width - 1 < n - 1) ? i + width - 1 : n - 1;
			int right = (i + 2 * width - 1 < n - 1) ? i + 2 * width - 1 : n - 1;
			
			if (mid < right) {
				printf("\\nMerging [%%d-%%d] and [%%d-%%d]:\\n", left, mid, mid + 1, right);
				merge(arr, left, mid, right);
			}
		}
		printf("After width %%d: ", width);
		printArray(arr, n);
	}
}

int main() {
	int arr[] = {%s};
	int n = sizeof(arr) / sizeof(arr[0]);
	
	printf("Initial array (unsorted): ");
	printArray(arr, n);
	printf("\\n");
	
	mergeSort(arr, n);
	
	printf("\\nSorted array: ");
	printArray(arr, n);
	
	return 0;
}""" % arr

func _on_cpp_close_pressed(): 
	btn_sound.play()
	cpp_popup.hide()

func _on_cpp_code_button_pressed(): 
	btn_sound.play()
	_show_cpp_popup()

func _on_complete_ok_pressed(): 
	btn_sound.play()
	complete_popup.hide()

# ==============================================
#   COMPILER INTEGRATION
# ==============================================

const COMPILER_API_KEYS = {
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

func _on_compile_button_pressed():
	btn_sound.play()
	
	var code = ""
	var arr_str = ", ".join(initial_array.map(func(x): return str(x)))
	
	match current_code_language:
		"cpp": code = get_cpp_merge_code(arr_str)
		"c": code = get_c_merge_code(arr_str)
		"java": code = get_java_merge_code(arr_str)
		"python": code = get_python_merge_code(arr_str)
	
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

func _compile_code(code: String):
	show_feedback("Compiling...", Color.YELLOW, Vector2(200, 200))
	
	var keys = COMPILER_API_KEYS[current_code_language]
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_compile_completed.bind(http_request, current_code_language))
	
	var url = "https://api.jdoodle.com/v1/execute"
	var headers = ["Content-Type: application/json"]
	
	var api_language = current_code_language
	if current_code_language == "python":
		api_language = "python3"
	
	var body = JSON.new().stringify({
		"clientId": keys["clientId"],
		"clientSecret": keys["clientSecret"],
		"script": code,
		"language": api_language,
		"versionIndex": _get_version_index(current_code_language)
	})
	
	print("=== Simulation Compile Request ===")
	print("Language: ", current_code_language, " → API: ", api_language)
	
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

func _on_compile_completed(result, response_code, headers, body, http_request, language: String):
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

func _on_recompile_requested(language: String):
	var arr_str = ", ".join(initial_array.map(func(x): return str(x)))
	var code = ""
	match language:
		"cpp": code = get_cpp_merge_code(arr_str)
		"c": code = get_c_merge_code(arr_str)
		"java": code = get_java_merge_code(arr_str)
		"python": code = get_python_merge_code(arr_str)
	_compile_code(code)

func _on_compiler_output_closed():
	print("Compiler output closed")

func reset_cache_for_scene():
	if compiler_output_popup:
		compiler_output_popup.reset_cache_for_scene()
		print("Compiler cache reset for new simulation")

# ==============================================
#   CONFIGURATION
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
		var val = int(le.text) if le.text.is_valid_int() else randi_range(1, 99)
		arr.append(val)
	config_elements_modal.hide()
	_set_main_ui_enabled(true)
	help_btn.show()
	_initialize_with_elements(arr)
	_init_merge_sort()

func _on_config_no_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	var count = randi_range(5, 7)
	var arr: Array[int] = []
	for i in count: arr.append(randi_range(1, 99))
	_set_main_ui_enabled(true)
	help_btn.show()
	_initialize_with_elements(arr)
	_init_merge_sort()

func _on_size_back_pressed(): 
	config_size_modal.hide()
	config_modal.show()

func _on_elements_back_pressed(): 
	config_elements_modal.hide()
	config_size_modal.show()

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

# ==============================================
#   TIMELINE
# ==============================================

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
	# Force scroll to bottom to show latest action
	var scroll_container = timeline_popup.find_child("ScrollContainer", true, false)
	if scroll_container and timeline_popup.visible:
		await get_tree().process_frame
		scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max

func _setup_timeline_popup_for_mobile():
	if not timeline_popup:
		return
	var scroll_container = timeline_popup.find_child("ScrollContainer", true, false)
	if scroll_container:
		scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
		scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		scroll_container.mouse_filter = Control.MOUSE_FILTER_STOP

# ==============================================
#   INTRO & TUTORIAL
# ==============================================

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
		{"node": sort_btn, "title": "UNDO", "text": "Reverts your last action. Disabled in Hard mode.", "action": "highlight"},
		{"node": auto_btn, "title": "REDO", "text": "Reapplies an undone action. Disabled in Hard mode.", "action": "highlight"},
		{"node": pass_btn, "title": "PASS", "text": "Click PASS when the element is already in correct position.", "action": "highlight"},
		{"node": timeline_btn, "title": "TIMELINE", "text": "View your complete move history.", "action": "highlight"}
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

func _on_help_button_pressed():
	btn_sound.play()
	start_tutorial()

# ==============================================
#   TIMER CALLBACKS
# ==============================================

func _on_time_up_try_again_pressed() -> void:
	btn_sound.play()
	if time_up_popup: time_up_popup.hide()
	result_popup.hide()
	_start_assessment_mode()
	call_deferred("show_introduction")

func _on_time_up_back_pressed() -> void:
	btn_sound.play()
	if time_up_popup: time_up_popup.hide()

func _on_try_again_root_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	if time_up_popup and time_up_popup.visible:
		time_up_popup.hide()
	_start_assessment_mode()
	call_deferred("show_introduction")

func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()
