extends Control

# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton  # Undo
@onready var auto_btn: Button = $VBoxContainer/WaitingElements  # Redo
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var pass_btn: Button = $VBoxContainer/PassButton

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
@onready var ptr_extra1: Node = $TextureRect/front2
@onready var ptr_extra2: Node = $TextureRect/rear2

# --- MERGE SORT VISUAL NODES ---
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

# --- CORE ARRAY VARIABLES ---
var main_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []
var sorted_array: Array[int] = []

# --- MERGE SORT SPECIFIC VARIABLES ---
enum MergePhase { IDLE, MERGING }
var current_phase: MergePhase = MergePhase.IDLE

# Current merge operation
var current_width: int = 1  # Size of subarrays being merged
var left_start: int = 0      # Start of left subarray
var left_index: int = 0      # Current position in left subarray
var right_index: int = 0     # Current position in right subarray
var mid_point: int = 0       # End of left subarray
var right_end: int = 0       # End of right subarray

# Visual tracking
var left_highlight_idx: int = -1
var right_highlight_idx: int = -1

# --- GENERAL VARIABLES ---
var comparison_counter: int = 0
var swap_counter: int = 0
var correct_moves: int = 0
var mistake_counter: int = 0
var sorting_complete: bool = false
var is_sorting: bool = false

var BLOCK_WIDTH: float = 64.0
var BLOCK_SPACING: float = 15.0
var START_POSITION: Vector2 = Vector2(50, 80)
var FLOATING_OFFSET: float = -60.0  # How high blocks float during merge
var ANIM_SPEED: float = 0.2

# Tween tracking
var current_tween: Tween = null
var is_animating: bool = false

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

# 1. C++ DATA (Merge Sort)
var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Complexity Analysis:\nTime: O(n log n) | Space: O(n)" },
	{ "lines": [3, 4, 5], "text": "2. Merge Function:\nCombines two sorted subarrays." },
	{ "lines": [8, 9, 10], "text": "3. Comparison Loop:\nCompare elements from left and right subarrays." },
	{ "lines": [14, 15], "text": "4. Copy Remaining:\nAdd any leftover elements." },
	{ "lines": [21, 22, 23], "text": "5. Iterative Merge Sort:\nControl subarray sizes (1,2,4...)." }
]

# 2. PYTHON DATA
var python_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Merge Function:\nTakes array and indices." },
	{ "lines": [2, 3], "text": "2. Create temp arrays:\nCopy left and right portions." },
	{ "lines": [6, 7, 8], "text": "3. Merge Loop:\nPick smaller element from L or R." },
	{ "lines": [10, 11], "text": "4. Cleanup:\nCopy remaining elements." }
]

# 3. JAVA DATA
var java_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Merge Method:\nStatic helper function." },
	{ "lines": [2, 3, 4], "text": "2. Create temp arrays:\nL[] and R[] for left/right." },
	{ "lines": [7, 8, 9], "text": "3. Comparison:\nMerge while both arrays have elements." },
	{ "lines": [13, 14, 15], "text": "4. Sort Method:\nIterative approach with width." }
]

# 4. C DATA
var c_tutorial_data = [
	{ "lines": [0], "text": "1. Includes:\nStandard libraries." },
	{ "lines": [1, 2, 3], "text": "2. Merge Function:\nClassic merge implementation." },
	{ "lines": [5, 6, 7], "text": "3. Comparison:\nWhile i < n1 and j < n2." },
	{ "lines": [13, 14, 15], "text": "4. Iterative Sort:\nLoop over subarray sizes." }
]

enum SimMode { LECTURE, ASSESSMENT }
var sim_mode: SimMode = SimMode.ASSESSMENT
var difficulty := 3

var time_remaining: float = 0.0
var timer_running: bool = false
var assessment_time_limit: float = 0.0

# Grade tracking
var has_completed_assessment: bool = false
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
		1: return 100000.0  # Easy (no timer)
		2: return 900.0     # Medium (15 min)
		3: return 60.0      # Hard (1 min)
	return 90.0

func _ready() -> void:
	tiktak_sound = AudioStreamPlayer.new()
	tiktak_sound.stream = TIKTAK_SFX
	add_child(tiktak_sound)
	try_again_button.visible = false
	
	print("Program started — initializing Merge Sort visualizer...")
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
	
	# Hide all modals initially
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	# Hide pointers initially
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if ptr_extra1: ptr_extra1.hide()
	if ptr_extra2: ptr_extra2.hide()
	
	# Hide merge sort visual elements
	if left_subarray_outline: left_subarray_outline.hide()
	if right_subarray_outline: right_subarray_outline.hide()
	if merge_status_label: merge_status_label.hide()
	
	# Setup buttons
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
	
	if sort_btn:
		if not sort_btn.is_connected("pressed", _on_sort_button_pressed):
			sort_btn.pressed.connect(_on_sort_button_pressed)
	
	if auto_btn:
		if not auto_btn.is_connected("pressed", _on_waiting_pressed):
			auto_btn.pressed.connect(_on_waiting_pressed)
	
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
	
	# Enable buttons
	if pass_btn:
		pass_btn.disabled = false
		pass_btn.modulate = Color(1, 1, 1, 1)
	
	# Kill any existing animations
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	clock.visible = false
	clock.modulate = Color(1, 1, 1, 1)
	clock.stop()
	
	# Reset counters
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
	
	# Clear undo/redo stacks
	undo_stack.clear()
	redo_stack.clear()
	
	timeline_log.clear()
	
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
	
	# Initialize merge sort and start immediately
	_init_merge_sort()
	_update_undo_redo_buttons()

func _init_merge_sort():
	current_width = 1
	left_start = 0
	current_phase = MergePhase.IDLE
	
	# Calculate first merge operation
	_advance_to_next_merge()

func _advance_to_next_merge():
	var n = main_array.size()
	
	print("Advancing merge - Width: ", current_width, " Left Start: ", left_start, " Array: ", main_array)
	
	# Check if array is already sorted
	if _check_if_sorted():
		print("Array is sorted! Ending assessment.")
		_end_assessment("sorted")
		return
	
	# If width is greater than or equal to array size, do one final merge of the whole array
	if current_width >= n:
		print("Final merge of whole array")
		left_start = 0
		mid_point = n - 1
		right_end = n - 1
		# For final merge, we just need to check if it's sorted
		if _check_if_sorted():
			_end_assessment("sorted")
		else:
			# If not sorted, something went wrong - but we'll just end
			_end_assessment("sorted")
		return
	
	# Find next valid merge
	while left_start < n:
		mid_point = min(left_start + current_width - 1, n - 1)
		right_end = min(left_start + 2 * current_width - 1, n - 1)
		
		print("  Checking merge: left_start=", left_start, " mid=", mid_point, " right_end=", right_end)
		
		# Only merge if we have two subarrays and the right subarray has elements
		if mid_point < n - 1 and right_end > mid_point:
			print("  Valid merge found!")
			# Initialize merge state
			left_index = left_start
			right_index = mid_point + 1
			current_phase = MergePhase.MERGING
			
			# Show outlines
			_show_subarray_outlines(left_start, mid_point, right_end)
			
			# Float the blocks being merged
			_float_merge_blocks()
			
			# Force a small delay to ensure blocks are repositioned before highlighting
			await get_tree().process_frame
			
			# Highlight first comparison
			_highlight_current_comparison()
			
			if status_label:
				status_label.text = "Merging [%d-%d] with [%d-%d]" % [left_start, mid_point, mid_point+1, right_end]
			
			return
		else:
			print("  No valid merge, skipping to next")
			left_start += 2 * current_width
	
	# If we get here, we've processed all merges for this width
	print("No more merges for width ", current_width, ", increasing width")
	current_width *= 2
	left_start = 0
	
	# Try again with new width
	_advance_to_next_merge()

func _show_subarray_outlines(left: int, mid: int, right: int):
	if not left_subarray_outline or not right_subarray_outline:
		return
	
	if left <= mid and left < block_nodes.size() and mid < block_nodes.size():
		var first_left = block_nodes[left]
		var last_left = block_nodes[mid]
		
		left_subarray_outline.global_position = first_left.global_position - Vector2(10, 10)
		left_subarray_outline.size = Vector2(
			(last_left.global_position.x + last_left.size.x) - first_left.global_position.x + 20,
			first_left.size.y + 20
		)
		left_subarray_outline.color = Color(0, 0, 1, 0.2)  # Blue
		left_subarray_outline.show()
	
	if mid+1 <= right and mid+1 < block_nodes.size() and right < block_nodes.size():
		var first_right = block_nodes[mid+1]
		var last_right = block_nodes[right]
		
		right_subarray_outline.global_position = first_right.global_position - Vector2(10, 10)
		right_subarray_outline.size = Vector2(
			(last_right.global_position.x + last_right.size.x) - first_right.global_position.x + 20,
			first_right.size.y + 20
		)
		right_subarray_outline.color = Color(1, 1, 0, 0.2)  # Yellow
		right_subarray_outline.show()

func _float_merge_blocks():
	# Float all blocks in the current merge range
	for i in range(left_start, right_end + 1):
		if i < block_nodes.size() and block_nodes[i]:
			var target_y = START_POSITION.y + FLOATING_OFFSET
			var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(block_nodes[i], "position:y", target_y, ANIM_SPEED)

func _highlight_current_comparison():
	# Clear previous highlights
	for i in range(block_nodes.size()):
		if block_nodes[i] and block_nodes[i].has_method("set_highlight"):
			block_nodes[i].set_highlight(false)
	
	# Ensure indices are valid
	if left_index < block_nodes.size() and left_index <= mid_point:
		if block_nodes[left_index] and block_nodes[left_index].has_method("set_highlight"):
			block_nodes[left_index].set_highlight(true)
			left_highlight_idx = left_index
	
	if right_index < block_nodes.size() and right_index <= right_end:
		if block_nodes[right_index] and block_nodes[right_index].has_method("set_highlight"):
			block_nodes[right_index].set_highlight(true)
			right_highlight_idx = right_index
	
	# Update pointers
	_update_pointers(left_index, right_index)
	
	if merge_status_label:
		merge_status_label.text = "Compare: %d vs %d" % [main_array[left_index], main_array[right_index]]
		merge_status_label.show()

func _update_pointers(left_idx: int, right_idx: int):
	if block_nodes.is_empty(): return
	
	if ptr_left: ptr_left.show()
	if ptr_right: ptr_right.show()
	
	if left_idx >= 0 and left_idx < block_nodes.size() and block_nodes[left_idx]:
		var node = block_nodes[left_idx]
		if ptr_left:
			ptr_left.global_position = node.global_position + Vector2(16, node.size.y + 30)
			ptr_left.modulate = Color(0, 0, 1, 1)  # Blue for left
	
	if right_idx >= 0 and right_idx < block_nodes.size() and block_nodes[right_idx]:
		var node = block_nodes[right_idx]
		if ptr_right:
			ptr_right.global_position = node.global_position + Vector2(16, node.size.y + 30)
			ptr_right.modulate = Color(1, 1, 0, 1)  # Yellow for right

func _on_pass_pressed():
	# BLOCK ALL MOVES if assessment is complete
	if has_completed_assessment or sorting_complete:
		show_feedback("Assessment complete! Start a new simulation.", Color.GRAY, get_global_mouse_position())
		return
	
	if is_animating or current_phase != MergePhase.MERGING:
		return
	
	btn_sound.play()
	_save_state()  # Save for undo
	
	# Check if current comparison should be passed (left <= right)
	if main_array[left_index] <= main_array[right_index]:
		# Good pass
		correct_moves += 1
		timeline_log.append(
			"[color=green]Good pass: %d <= %d[/color]" % [main_array[left_index], main_array[right_index]]
		)
		show_feedback("Good pass!", Color.GREEN, block_nodes[left_index].global_position)
		
		# Move to next element in left subarray
		left_index += 1
	else:
		# Bad pass (should have swapped)
		mistake_counter += 1
		timeline_log.append(
			"[color=red]Bad pass: %d > %d, should swap[/color]" % [main_array[left_index], main_array[right_index]]
		)
		show_feedback("Should swap!", Color.RED, block_nodes[left_index].global_position)
		
		# Still advance to next comparison (don't get stuck)
		left_index += 1
	
	_check_merge_progress()
	_update_undo_redo_buttons()
	
	# Always check if sorted after any move
	if _check_if_sorted() and not has_completed_assessment:
		print("Array is sorted! Ending assessment.")
		_end_assessment("sorted")

func _on_block_dropped(dropped_block: Control) -> void:
	# BLOCK ALL MOVES if assessment is complete
	if has_completed_assessment or sorting_complete:
		show_feedback("Assessment complete! Start a new simulation.", Color.GRAY, dropped_block.global_position)
		_snap_block_back(dropped_block)
		return
	
	if is_animating:
		show_feedback("Cannot drag now!", Color.ORANGE, dropped_block.global_position)
		_snap_block_back(dropped_block)
		return
	
	var old_index = block_nodes.find(dropped_block)
	if old_index == -1:
		return
	
	var center_x: float = dropped_block.position.x + dropped_block.size.x * 0.5
	var insert_index: int = 0
	
	_save_state()  # Save for undo
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
		_snap_block_back(dropped_block)
		return
	
	# Get values before swap for logging
	var val1 = main_array[old_index]
	var val2 = main_array[insert_index]
	
	# Determine if this is a swap between the current comparison blocks
	var is_comparison_swap = false
	
	if current_phase == MergePhase.MERGING:
		# Check if this swap involves the current left_index and right_index
		if (old_index == left_index and insert_index == right_index) or \
		   (old_index == right_index and insert_index == left_index):
			is_comparison_swap = true
			print("Swapping comparison blocks: ", val1, " and ", val2)
	
	# Perform the swap
	var temp = main_array[old_index]
	main_array[old_index] = main_array[insert_index]
	main_array[insert_index] = temp
	
	# Update blocks array
	var temp_block = block_nodes[old_index]
	block_nodes[old_index] = block_nodes[insert_index]
	block_nodes[insert_index] = temp_block
	
	# Animate
	is_animating = true
	await _animate_swap(block_nodes[old_index], block_nodes[insert_index])
	await _resnap_blocks()
	is_animating = false
	
	# Validate the move AFTER the swap (check the new order)
	var is_good_move = false
	var message = ""
	
	if current_phase == MergePhase.MERGING and is_comparison_swap:
		# This was a swap between the two blocks being compared
		# After swap, check if the left block is now <= right block
		if main_array[left_index] <= main_array[right_index]:
			# Good swap - they were out of order and now are in order
			is_good_move = true
			message = "Good swap!"
			print("Good swap! Now ", main_array[left_index], " <= ", main_array[right_index])
		else:
			# Bad swap - they were already in order and now are out of order
			is_good_move = false
			message = "Bad swap! Elements now out of order."
			print("Bad swap! Now ", main_array[left_index], " > ", main_array[right_index])
	elif current_phase == MergePhase.MERGING:
		# Swapping blocks that aren't the current comparison
		is_good_move = false
		message = "Swap only the highlighted blocks!"
	else:
		is_good_move = false
		message = "Not in merge phase!"
	
	if is_good_move:
		correct_moves += 1
		timeline_log.append(
			"[color=green]Good swap: %d ↔ %d[/color]" % [val1, val2]
		)
		show_feedback(message, Color.GREEN, dropped_block.global_position)
		swap_counter += 1
		
		# After good swap, advance both pointers
		left_index += 1
		right_index += 1
		print("Advancing pointers after good swap - left: ", left_index, " right: ", right_index)
		_check_merge_progress()
	else:
		mistake_counter += 1
		timeline_log.append(
			"[color=red]Bad swap: %d ↔ %d - %s[/color]" % [val1, val2, message]
		)
		show_feedback(message, Color.RED, dropped_block.global_position)
		# Don't advance comparison for bad swaps
	
	_update_timeline_display()
	_update_ui_labels()
	_update_undo_redo_buttons()
	
	# Always check if sorted after any move
	if _check_if_sorted() and not has_completed_assessment:
		print("Array is sorted! Ending assessment.")
		_end_assessment("sorted")

func _check_merge_progress():
	# Ensure indices are within bounds
	if left_index < 0 or right_index < 0:
		return
	
	print("Checking progress - left_idx: ", left_index, " right_idx: ", right_index, " mid: ", mid_point, " right_end: ", right_end)
	
	# Check if left subarray is exhausted
	if left_index > mid_point:
		print("Left subarray exhausted")
		# All left elements placed, copy remaining right elements
		while right_index <= right_end and right_index < block_nodes.size():
			print("  Auto-advancing right element at index ", right_index, " value: ", main_array[right_index])
			right_index += 1
			comparison_counter += 1
		
		_finish_current_merge()
		return
	
	# Check if right subarray is exhausted
	if right_index > right_end:
		print("Right subarray exhausted")
		# All right elements placed, copy remaining left elements
		while left_index <= mid_point and left_index < block_nodes.size():
			print("  Auto-advancing left element at index ", left_index, " value: ", main_array[left_index])
			left_index += 1
			comparison_counter += 1
		
		_finish_current_merge()
		return
	
	# Continue with next comparison
	print("Continuing with next comparison: ", main_array[left_index], " vs ", main_array[right_index])
	_highlight_current_comparison()
	comparison_counter += 1


func _advance_comparison(moved_left: bool):
	if moved_left:
		# Moved past left element (pass)
		left_index += 1
	else:
		# After swap, we move both pointers? In merge sort, after placing an element,
		# we move the pointer from which we took the element
		# For simplicity, we'll increment both after a swap
		left_index += 1
		right_index += 1
	
	# Check if left subarray is exhausted
	if left_index > mid_point:
		# All left elements placed, move remaining right elements (auto-pass)
		while right_index <= right_end:
			right_index += 1
			comparison_counter += 1
		
		_finish_current_merge()
		return
	
	# Check if right subarray is exhausted
	if right_index > right_end:
		# All right elements placed, move remaining left elements (auto-pass)
		while left_index <= mid_point:
			left_index += 1
			comparison_counter += 1
		
		_finish_current_merge()
		return
	
	# Continue with next comparison
	_highlight_current_comparison()
	comparison_counter += 1

func _finish_current_merge():
	# Drop blocks back down
	for i in range(left_start, right_end + 1):
		if i < block_nodes.size() and block_nodes[i]:
			var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(block_nodes[i], "position:y", START_POSITION.y, ANIM_SPEED)
	
	# Hide outlines
	if left_subarray_outline: left_subarray_outline.hide()
	if right_subarray_outline: right_subarray_outline.hide()
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	
	# Clear highlights
	for i in range(block_nodes.size()):
		if block_nodes[i] and block_nodes[i].has_method("set_highlight"):
			block_nodes[i].set_highlight(false)
	
	timeline_log.append(
		"[color=green]--- Merge of size %d complete ---[/color]" % current_width
	)
	
	# Move to next merge in the same width
	left_start += 2 * current_width
	current_phase = MergePhase.IDLE
	
	# Check if we've processed all merges for this width
	if left_start >= main_array.size():
		# Move to next width
		var previous_width = current_width
		current_width *= 2
		left_start = 0
		print("Moving from width ", previous_width, " to width ", current_width)
		
		# Check if we've exceeded array size
		if current_width >= main_array.size():
			# Final merge with width = array size
			current_width = main_array.size()
			print("Final merge with width ", current_width)
	
	# Always try to advance to next merge, even if we think we're done
	# The array might still be unsorted
	_advance_to_next_merge()
	_update_ui_labels()

func _animate_swap(node_a: Control, node_b: Control):
	var pos_a = node_a.position
	var pos_b = node_b.position
	
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(node_a, "position", pos_b, ANIM_SPEED)
	tween.tween_property(node_b, "position", pos_a, ANIM_SPEED)
	await tween.finished

func _resnap_blocks():
	var x = START_POSITION.x
	var tweens = []
	
	for i in range(block_nodes.size()):
		var target_y = START_POSITION.y
		if current_phase == MergePhase.MERGING and i >= left_start and i <= right_end:
			target_y = START_POSITION.y + FLOATING_OFFSET
		
		var target_pos = Vector2(x, target_y)
		var tween = create_tween()
		tween.tween_property(block_nodes[i], "position", target_pos, ANIM_SPEED)
		tweens.append(tween)
		
		x += block_nodes[i].size.x + BLOCK_SPACING
	
	if tweens.size() > 0:
		await tweens[-1].finished

func _snap_block_back(block: Control):
	var index = block_nodes.find(block)
	if index != -1:
		var target_x = START_POSITION.x
		for i in range(index):
			target_x += block_nodes[i].size.x + BLOCK_SPACING
		
		var target_y = START_POSITION.y
		if current_phase == MergePhase.MERGING and index >= left_start and index <= right_end:
			target_y = START_POSITION.y + FLOATING_OFFSET
		
		var tween = create_tween()
		tween.tween_property(block, "position", Vector2(target_x, target_y), 0.2)
		await tween.finished

func _save_state() -> void:
	var state := {
		"array": main_array.duplicate(),
		"current_width": current_width,
		"left_start": left_start,
		"left_index": left_index,
		"right_index": right_index,
		"mid_point": mid_point,
		"right_end": right_end,
		"current_phase": current_phase,
		"correct_moves": correct_moves,
		"mistake_counter": mistake_counter,
		"comparison_counter": comparison_counter,
		"swap_counter": swap_counter
	}
	undo_stack.append(state)

func _restore_state(state: Dictionary) -> void:
	main_array = state["array"].duplicate()
	sorted_array = main_array.duplicate()
	sorted_array.sort()
	
	current_width = state["current_width"]
	left_start = state["left_start"]
	left_index = state["left_index"]
	right_index = state["right_index"]
	mid_point = state["mid_point"]
	right_end = state["right_end"]
	current_phase = state["current_phase"]
	correct_moves = state["correct_moves"]
	mistake_counter = state["mistake_counter"]
	comparison_counter = state["comparison_counter"]
	swap_counter = state["swap_counter"]
	
	_rebuild_blocks_from_array()
	
	# Restore visual state
	if current_phase == MergePhase.MERGING:
		_show_subarray_outlines(left_start, mid_point, right_end)
		_float_merge_blocks()
		_highlight_current_comparison()
	else:
		if left_subarray_outline: left_subarray_outline.hide()
		if right_subarray_outline: right_subarray_outline.hide()
		if ptr_left: ptr_left.hide()
		if ptr_right: ptr_right.hide()
		for i in range(block_nodes.size()):
			if block_nodes[i] and block_nodes[i].has_method("set_highlight"):
				block_nodes[i].set_highlight(false)

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

func _on_sort_button_pressed() -> void:  # UNDO
	if has_completed_assessment or sorting_complete:
		return
	
	if not _can_undo():
		return
	
	if undo_stack.is_empty():
		return
	
	btn_sound.play()
	
	var state = undo_stack.pop_back()
	
	redo_stack.append({
		"array": main_array.duplicate(),
		"current_width": current_width,
		"left_start": left_start,
		"left_index": left_index,
		"right_index": right_index,
		"mid_point": mid_point,
		"right_end": right_end,
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
	if has_completed_assessment or sorting_complete:
		return
	
	if not _can_redo():
		return
	
	if redo_stack.is_empty():
		return
	
	btn_sound.play()
	
	var state = redo_stack.pop_back()
	
	undo_stack.append({
		"array": main_array.duplicate(),
		"current_width": current_width,
		"left_start": left_start,
		"left_index": left_index,
		"right_index": right_index,
		"mid_point": mid_point,
		"right_end": right_end,
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
	if sorting_complete or not timer_running:
		return false
	
	if difficulty == 3:  # Hard mode - no undo/redo
		return false
	
	return true

func _can_redo() -> bool:
	if sorting_complete or not timer_running:
		return false
	
	if difficulty == 3:  # Hard mode - no undo/redo
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

func _initialize_with_elements(elements: Array[int]) -> void:
	print("Initializing Array with:", elements)
	audio_player.play()
	
	main_array = elements.duplicate()
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

func show_feedback(text: String, color: Color, position: Vector2) -> void:
	var feedback_scene = preload("res://scene/FeedbackLabel.tscn")
	var label = feedback_scene.instantiate()
	
	label.text = text
	label.modulate = color
	label.global_position = position + Vector2(0, -20)
	
	add_child(label)
	
	var anim_player: AnimationPlayer = label.get_node("AnimationPlayer")
	anim_player.play("notification_pop")
	
	anim_player.animation_finished.connect(
		func(_anim_name):
			label.queue_free()
	)

func _check_if_sorted() -> bool:
	for i in range(main_array.size() - 1):
		if main_array[i] > main_array[i + 1]:
			return false
	return true

func _update_ui_labels():
	compare_label.text = "Correct: %d | Mistakes: %d | Swaps: %d" % [correct_moves, mistake_counter, swap_counter]

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
	
	if total_moves == 0:
		return {
			"passed": true,
			"accuracy": 100.0,
			"total_moves": 0,
			"correct_moves": 0,
			"mistake_counter": 0,
			"time_used": assessment_time_limit - time_remaining,
			"coins": _get_coins_for_difficulty(true),
			"required": _get_required_threshold() * 100
		}
	
	var accuracy = float(correct_moves) / max(total_moves, 1) * 100
	var required_threshold = _get_required_threshold() * 100
	var passed = accuracy >= required_threshold
	
	var time_used = assessment_time_limit - time_remaining
	var coins = _get_coins_for_difficulty(passed)
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

func _get_coins_for_difficulty(passed: bool) -> int:
	if not passed:
		return 0
	
	match difficulty:
		1: return 5
		2: return 10
		3: return 20
	return 5

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
	is_sorting = true
	is_animating = false  # Ensure animation flag is reset
	
	# Disable ALL interactive elements
	if sort_btn:
		sort_btn.disabled = true
	if auto_btn:
		auto_btn.disabled = true
	if pass_btn:
		pass_btn.disabled = true
	if timeline_btn:
		timeline_btn.disabled = false  # Keep timeline viewable
	
	# Make all blocks non-draggable
	for block in block_nodes:
		if block:
			block.draggable = false
			# Optional: dim them slightly to indicate completion
			block.modulate = Color(0.8, 0.8, 0.8, 1)
	
	# Hide pointers and outlines
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if left_subarray_outline: left_subarray_outline.hide()
	if right_subarray_outline: right_subarray_outline.hide()
	
	# Clear any highlights
	for i in range(block_nodes.size()):
		if block_nodes[i] and block_nodes[i].has_method("set_highlight"):
			block_nodes[i].set_highlight(false)
	
	if reason == "sorted":
		var grade = _compute_grade()
		var result = "PASS" if grade["passed"] else "FAIL"
		_show_result_popup(result, grade)
	else:  # timeout
		_show_result_popup("FAIL")

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
	
	# Make sure all blocks are draggable again for the new simulation
	for block in block_nodes:
		if block:
			block.draggable = true
			block.modulate = Color.WHITE  # Reset color
	
	_start_assessment_mode()
	await get_tree().process_frame
	_update_undo_redo_buttons()
	
func _on_try_again_result_pressed():
	btn_sound.play()
	result_popup.hide()
	
	# Make sure all blocks are draggable again for the new simulation
	for block in block_nodes:
		if block:
			block.draggable = true
			block.modulate = Color.WHITE  # Reset color
	
	_start_assessment_mode()
	await get_tree().process_frame
	_update_undo_redo_buttons()

func _on_back_result_pressed():
	btn_sound.play()
	result_popup.hide()

func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()

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
	var arr_str = ", ".join(main_array.map(func(x): return str(x)))
	
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
	
	if cpp_next_btn:
		if not cpp_next_btn.is_connected("pressed", _on_cpp_next_pressed):
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
		var arr_str = ", ".join(main_array.map(func(x): return str(x)))
		
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
using namespace std;

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
	}
	
	while (i < n1) {
		arr[k] = L[i];
		i++;
		k++;
	}
	
	while (j < n2) {
		arr[k] = R[j];
		j++;
		k++;
	}
}

void mergeSort(int arr[], int n) {
	for (int width = 1; width < n; width *= 2) {
		for (int i = 0; i < n; i += 2 * width) {
			int left = i;
			int mid = min(i + width - 1, n - 1);
			int right = min(i + 2 * width - 1, n - 1);
			
			if (mid < right)
				merge(arr, left, mid, right);
		}
	}
}

int main() {
	int arr[] = { %s };
	int n = sizeof(arr) / sizeof(arr[0]);
	mergeSort(arr, n);
	return 0;
}""" % arr

func get_python_merge_code(arr: String) -> String:
	return """# Merge Sort - Time Complexity: O(n log n)
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
	
	while i < n1:
		arr[k] = L[i]
		i += 1
		k += 1
	
	while j < n2:
		arr[k] = R[j]
		j += 1
		k += 1

def merge_sort(arr):
	n = len(arr)
	width = 1
	while width < n:
		for i in range(0, n, 2 * width):
			left = i
			mid = min(i + width - 1, n - 1)
			right = min(i + 2 * width - 1, n - 1)
			
			if mid < right:
				merge(arr, left, mid, right)
		width *= 2

arr = [%s]
merge_sort(arr)""" % arr

func get_java_merge_code(arr: String) -> String:
	return """// Merge Sort - Time Complexity: O(n log n)
class MergeSort {
	void merge(int arr[], int left, int mid, int right) {
		int n1 = mid - left + 1;
		int n2 = right - mid;
		
		int L[] = new int[n1];
		int R[] = new int[n2];
		
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
		}
		
		while (i < n1) {
			arr[k] = L[i];
			i++;
			k++;
		}
		
		while (j < n2) {
			arr[k] = R[j];
			j++;
			k++;
		}
	}
	
	void sort(int arr[]) {
		int n = arr.length;
		for (int width = 1; width < n; width *= 2) {
			for (int i = 0; i < n; i += 2 * width) {
				int left = i;
				int mid = Math.min(i + width - 1, n - 1);
				int right = Math.min(i + 2 * width - 1, n - 1);
				
				if (mid < right)
					merge(arr, left, mid, right);
			}
		}
	}
	
	public static void main(String args[]) {
		int arr[] = {%s};
		MergeSort ob = new MergeSort();
		ob.sort(arr);
	}
}""" % arr

func get_c_merge_code(arr: String) -> String:
	return """/* Merge Sort - Time Complexity: O(n log n) */
#include <stdio.h>
#include <stdlib.h>

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
	}
	
	while (i < n1) {
		arr[k] = L[i];
		i++;
		k++;
	}
	
	while (j < n2) {
		arr[k] = R[j];
		j++;
		k++;
	}
}

void mergeSort(int arr[], int n) {
	for (int width = 1; width < n; width *= 2) {
		for (int i = 0; i < n; i += 2 * width) {
			int left = i;
			int mid = (i + width - 1 < n - 1) ? i + width - 1 : n - 1;
			int right = (i + 2 * width - 1 < n - 1) ? i + 2 * width - 1 : n - 1;
			
			if (mid < right)
				merge(arr, left, mid, right);
		}
	}
}

int main() {
	int arr[] = {%s};
	int n = sizeof(arr) / sizeof(arr[0]);
	mergeSort(arr, n);
	return 0;
}""" % arr

# ==============================================
#   CONFIGURATION & INTRO
# ==============================================

func _connect_configuration_buttons() -> void:
	_ensure_connected(yes_btn, "pressed", _on_config_yes_pressed)
	_ensure_connected(no_btn, "pressed", _on_config_no_pressed)
	_ensure_connected(size_back_btn, "pressed", _on_size_back_pressed)
	_ensure_connected(size_next_btn, "pressed", _on_size_next_pressed)
	_ensure_connected(elements_back_btn, "pressed", _on_elements_back_pressed)
	_ensure_connected(elements_done_btn, "pressed", _on_elements_done_pressed)

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

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

func _update_difficulty_label():
	if not difficulty_label:
		return
	match difficulty:
		1: difficulty_label.text = "Difficulty: Easy"
		2: difficulty_label.text = "Difficulty: Medium"
		3: difficulty_label.text = "Difficulty: Hard"

func _on_cpp_close_pressed(): 
	btn_sound.play()
	cpp_popup.hide()

func _on_cpp_code_button_pressed(): 
	btn_sound.play()
	_show_cpp_popup()

func _on_complete_ok_pressed(): 
	btn_sound.play()
	complete_popup.hide()

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

# ==============================================
#   TUTORIAL FUNCTIONS
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
			"text": "Reverts your last action. Disabled in Hard mode.",
			"action": "highlight"
		},
		{
			"node": auto_btn,
			"title": "REDO",
			"text": "Reapplies an undone action. Disabled in Hard mode.",
			"action": "highlight"
		},
		{
			"node": pass_btn,
			"title": "PASS",
			"text": "Click PASS when the left element is <= the right element.",
			"action": "highlight"
		},
		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View your complete move history.",
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
#   INTRO FUNCTIONS
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
	if pass_btn: pass_btn.disabled = not enabled
