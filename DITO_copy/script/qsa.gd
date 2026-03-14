extends Control
const TREE_NODE_BUTTON = preload("res://scene/TreeNodeButton.tscn")
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = $CppPopup/VBoxContainer/HBoxContainer2/CompileButton
# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton
@onready var auto_btn: Button = $VBoxContainer/WaitingElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton

# --- QUICK SORT BUTTONS ---
@onready var pivot_btn: Button = $VBoxContainer/PivotButton
@onready var move_i_btn: Button = $VBoxContainer/MoveIButton
@onready var move_j_btn: Button = $VBoxContainer/MoveJButton
@onready var place_pivot_btn: Button = $VBoxContainer/PlacePivotButton

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $StatusLabel
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

# --- QUICK SORT VISUAL NODES ---
@onready var recursion_map: Control = $RecursionMap
@onready var subarray_outline_left: ColorRect = $SubArrayOutlineLeft
@onready var subarray_outline_right: ColorRect = $SubArrayOutlineRight
@onready var pivot_indicator: Sprite2D = $PivotIndicator
@onready var quick_status_label: Label = $QuickStatusLabel

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

# --- CORE ARRAY VARIABLES ---f
var main_array: Array[int] = []
var initial_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []
var sorted_array: Array[int] = []

# --- QUICK SORT SPECIFIC VARIABLES ---
enum QuickSortPhase { PIVOT_SELECTION, PARTITIONING, PIVOT_PLACEMENT }
var quick_phase: QuickSortPhase = QuickSortPhase.PIVOT_SELECTION

# Partition tracking
var current_subarray_start: int = 0
var current_subarray_end: int = 0
var pivot_index: int = -1
var pivot_value: int = 0
var pointer_i: int = -1  # Left pointer (finds > pivot)
var pointer_j: int = -1  # Right pointer (finds < pivot)
var i_locked: bool = false
var j_locked: bool = false

# Recursion tree data structure
class SubarrayNode:
	var start: int
	var end: int
	var pivot_pos: int = -1
	var parent: SubarrayNode = null
	var left_child: SubarrayNode = null
	var right_child: SubarrayNode = null
	var is_active: bool = false
	
	func _init(s: int, e: int):
		start = s
		end = e

var recursion_root: SubarrayNode = null
var current_node: SubarrayNode = null
var all_nodes: Array[SubarrayNode] = []  # For navigation

# --- GENERAL VARIABLES ---
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
	# Page 1: Welcome and Basic Concept
	"""WELCOME TO QUICK SORT SIMULATION! 🎯

Quick Sort is a 'divide and conquer' algorithm that sorts by:
1. Selecting a 'pivot' element
2. Partitioning the array around the pivot
3. Recursively sorting the resulting subarrays"""
,
"""Time Complexity:
• Average Case: O(n log n)
• Worst Case: O(n²) - rare with good pivot selection
• Best Case: O(n log n)

Space Complexity: O(log n) for recursion stack""",

"""Think of it like organizing a deck of cards by picking one card
and arranging all others around it - smaller ones on the left,
larger ones on the right!""",

	# Page 2: The Partitioning Process
	"""THE PARTITIONING DANCE STEPS💃
1. PIVOT SELECTION:
   • You tap any block in the current subarray to choose it as the pivot
   • The pivot is highlighted with a CROWN 👑
   • If not at the end, it performs a 'Safe Haven' swap to the last position
""","""
2. THE TWO POINTERS:
   • Pointer i (BLUE) → Starts at the LEFT, looks for elements >= pivot
   • Pointer j (YELLOW) ← Starts at the RIGHT (before pivot), looks for elements <= pivot
""","""3. POINTER MOVEMENT:
   • Click 'MOVE i' to advance the blue pointer one step right
   • Click 'MOVE j' to advance the yellow pointer one step left
   • Each pointer STOPS when it finds an element that satisfies its condition
   • Locked pointers glow bright yellow!""",

	# Page 3: Swapping and Crossover
	"""SWAPPING & CROSSOVER RULES
WHEN BOTH POINTERS ARE LOCKED:
• i has found an element >= pivot
• j has found an element <= pivot
• The two highlighted blocks should be swapped
• Drag one block onto the other to perform the swap
• After swap, both pointers unlock and continue moving
""","""
POINTER CROSSOVER:
• When i moves past j (i > j), the partitioning phase is complete!
• All elements on the left are <= pivot
• All elements on the right are >= pivot
• Click 'PLACE PIVOT' to put the pivot in its final position
""","""WHAT COUNTS AS CORRECT:
✓ Swapping when both pointers are locked AND elements are out of order
✓ Placing the pivot at the crossover point
✓ Moving pointers correctly (one step at a time)
""","""WHAT MARKS AS WRONG:
✗ Swapping before both pointers are locked
✗ Moving a locked pointer
✗ Swapping non-highlighted blocks""",

	# Page 4: Recursion and Visual Guide
	"""THE RECURSION MAP & VISUAL CUES 🗺️
RECURSION MAP (TOP CENTER):
• Shows the tree structure of your partitions
• Click any unsorted subarray node to jump directly to it
• Node colors:
RED = Currently active subarray
WHITE = Waiting to be processed
BLACK = Already sorted
""","""VISUAL CUES:
• 👑 CROWN = Current pivot
• 🔵 BLUE POINTER = Pointer i (looking for >= pivot)
• 🟡 YELLOW POINTER = Pointer j (looking for <= pivot)
• 💚 GREEN BLOCKS = Elements in their final sorted position (locked)
""","""SMART DETECTION:
• Subarrays with 1 element are automatically sorted
• Already-sorted subarrays glow green without requiring partitioning
• The game recognizes when you're done and moves on!""",

	# Page 5: Controls and Difficulty
	"""GAME CONTROLS & DIFFICULTY
BUTTONS (LEFT SIDE):
PIVOT - Activates pivot selection
MOVE i → - Advances the blue pointer one step
MOVE j ← - Advances the yellow pointer one step
PLACE PIVOT - Locks pivot in position after pointers cross
TIMELINE - View your complete move history
""","""
DIFFICULTY LEVELS:
EASY (Size 4):
• No time limit
• Perfect for learning the basics
• Gentle introduction to partitioning
""","""
MEDIUM (Size 5):
• 75 seconds time limit
• More elements to organize
• Tests your understanding
""","""
HARD (Size 7):
• 1 minute time limit! ⏰
• Complex array with more elements
• True test of Quick Sort mastery
""","""
GRADING:
• Pass: 75% accuracy (Medium) or 80% accuracy (Hard)
• Correct moves: Valid swaps and pivot placements
• Mistakes: Invalid swaps or pointer moves
• Timer pressure adds to the challenge!""",
"""TIPS FOR SUCCESS:
• Always ensure both pointers are locked before swapping
• Remember: i looks for >= pivot, j looks for <= pivot
• Use the recursion map to navigate complex partitions
• The timer ticks faster in the last 10 seconds - stay calm!"""
]

# --- CODE TUTORIAL DATA ---
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

# 1. C++ DATA (Quick Sort)
var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Partition function:\nRearranges array around pivot." },
	{ "lines": [2, 3], "text": "2. Pivot selection:\nUsually last element." },
	{ "lines": [4, 5], "text": "3. Pointer i:\nFinds elements greater than pivot." },
	{ "lines": [6, 7], "text": "4. Pointer j:\nFinds elements smaller than pivot." },
	{ "lines": [8, 9], "text": "5. Swap when both pointers stop." },
	{ "lines": [10, 11], "text": "6. Place pivot in final position." }
]

# 2. PYTHON DATA (Quick Sort)
var python_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Quick sort function:\nRecursive implementation." },
	{ "lines": [2, 3], "text": "2. Base case:\nArray with 0 or 1 element." },
	{ "lines": [4, 5], "text": "3. Pivot selection:\nChoose pivot element." },
	{ "lines": [6, 7], "text": "4. Partition:\nCreate left and right lists." },
	{ "lines": [8, 9], "text": "5. Recursive calls:\nSort subarrays." }
]

# 3. JAVA DATA (Quick Sort)
var java_tutorial_data = [
	{ "lines": [0, 1], "text": "1. QuickSort class:\nContains sort and partition methods." },
	{ "lines": [2, 3], "text": "2. sort() method:\nRecursive function." },
	{ "lines": [4, 5], "text": "3. partition() method:\nCore logic." },
	{ "lines": [6, 7], "text": "4. Pointer movement:\nFind elements to swap." },
	{ "lines": [8, 9], "text": "5. Swap elements:\nPlace in correct partition." }
]

# 4. C DATA (Quick Sort)
var c_tutorial_data = [
	{ "lines": [0], "text": "1. swap function:\nUtility to exchange elements." },
	{ "lines": [1, 2], "text": "2. partition function:\nMain partitioning logic." },
	{ "lines": [3, 4], "text": "3. Pointer initialization:\nStart i at low-1." },
	{ "lines": [5, 6], "text": "4. Partition loop:\nCompare with pivot." },
	{ "lines": [7, 8], "text": "5. quickSort function:\nRecursive calls." }
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
# Add to tracking variables section
var pivot_placements: int = 0  # Count of successful pivot placements
var pointer_movements: int = 0  # Count of pointer moves (i and j)
var sorted_subarrays_detected: int = 0  # Auto-sorted subarrays
var total_expected_pivots: int = 0  # How many pivots should be placed
var potential_swaps: int = 0  # Maximum possible swaps needed

# New: Track phases completed
var phases_completed: Array = []  # Store which phases were done correctly

func _get_array_size() -> int:
	match difficulty:
		1: return 4
		2: return 5
		3: return 7
	return 5

func _get_time_limit() -> float:
	match difficulty:
		1: return 100000.0 # Easy
		2: return 900.0    # Medium
		3: return 60.0     # Hard
	return 90.0

func _ready() -> void:
	tiktak_sound = AudioStreamPlayer.new()
	tiktak_sound.stream = TIKTAK_SFX
	add_child(tiktak_sound)
	try_again_button.visible = false
	
	print("Program started — initializing Quick Sort visualizer...")
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
	if unused_ptr1: unused_ptr1.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	# Hide Quick Sort visual elements initially
	subarray_outline_left.hide()
	subarray_outline_right.hide()
	pivot_indicator.hide()
	if quick_status_label:
		quick_status_label.hide()
	
	# Set Z-index for proper layering
	subarray_outline_left.z_index = 5
	subarray_outline_right.z_index = 5
	pivot_indicator.z_index = 15
	if ptr_left: ptr_left.z_index = 20
	if ptr_right: ptr_right.z_index = 20
	
	# Setup buttons
	if sort_btn: sort_btn.text = "UNDO"
	if auto_btn: auto_btn.text = "REDO"
	
	# Setup Quick Sort buttons
	_setup_quick_sort_buttons()
	
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
	
	# Connect viewport resize signal
	get_viewport().size_changed.connect(_on_viewport_resized)
	_setup_compiler()

func _setup_quick_sort_buttons():
	if pivot_btn:
		pivot_btn.pressed.connect(_on_pivot_button_pressed)
	if move_i_btn:
		move_i_btn.pressed.connect(_on_move_i_pressed)
	if move_j_btn:
		move_j_btn.pressed.connect(_on_move_j_pressed)
	if place_pivot_btn:
		place_pivot_btn.pressed.connect(_on_place_pivot_pressed)

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
	
	# Show Quick Sort buttons, hide any Shell Sort specific ones
	pivot_btn.show()
	move_i_btn.show()
	move_j_btn.show()
	place_pivot_btn.show()
		# HIDE undo/redo/pass buttons
	if sort_btn:  # Undo button
		sort_btn.hide()
	if auto_btn:  # Redo button
		auto_btn.hide()
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
	pivot_placements = 0
	pointer_movements = 0
	sorted_subarrays_detected = 0
	total_expected_pivots = 0
	potential_swaps = 0
	phases_completed.clear()
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
	await get_tree().process_frame
	# Initialize Quick Sort
	_init_quick_sort()
	
	_update_undo_redo_buttons()

func _init_quick_sort():
	# Initialize recursion tree
	current_subarray_start = 0
	current_subarray_end = main_array.size() - 1
	recursion_root = SubarrayNode.new(0, main_array.size() - 1)
	current_node = recursion_root
	all_nodes = [recursion_root]
	
	# NEW: Check if the entire array is already sorted
	if _is_subarray_sorted(0, main_array.size() - 1):
		_mark_subarray_sorted(0, main_array.size() - 1)
		if status_label:
			status_label.text = "Array already sorted!"
		_end_assessment("sorted")
		return
	
	# Reset pointers
	pivot_index = -1
	pointer_i = -1
	pointer_j = -1
	i_locked = false
	j_locked = false
	quick_phase = QuickSortPhase.PIVOT_SELECTION
	
	total_expected_pivots = _calculate_expected_pivots(0, main_array.size() - 1)
	potential_swaps = _calculate_potential_swaps(main_array)
	# Update UI with null checks
	if status_label:
		status_label.text = "Select a pivot block by tapping it"
	
	_update_quick_sort_buttons()
	
	# Hide outlines initially
	if subarray_outline_left:
		subarray_outline_left.hide()
	if subarray_outline_right:
		subarray_outline_right.hide()
	if pivot_indicator:
		pivot_indicator.hide()
	
	# Build recursion map
	_build_recursion_map()
	
	# Position quick status label
	if quick_status_label:
		quick_status_label.text = "Phase: Select Pivot"
		quick_status_label.show()
		_position_quick_status_label()
		
func _calculate_expected_pivots(start: int, end: int) -> int:
	# Each non-trivial subarray (size > 1) needs a pivot
	if start >= end:
		return 0
	
	var size = end - start + 1
	if size <= 1:
		return 0
	
	# Rough estimate: each element becomes a pivot once in its lifetime
	# For Quick Sort, approximately log2(n) * n? Let's simplify:
	return int(ceil(log(size) / log(2)))  # Height of recursion tree

func _calculate_potential_swaps(arr: Array) -> int:
	# Count inversions as potential swaps needed
	var inversions = 0
	for i in range(arr.size()):
		for j in range(i + 1, arr.size()):
			if arr[i] > arr[j]:
				inversions += 1
	return inversions
	
func _position_quick_status_label():
	if quick_status_label:
		var viewport_size = get_viewport().size
		quick_status_label.position = Vector2(
			(viewport_size.x - quick_status_label.size.x) / 2,
			viewport_size.y - 120
		)

func _on_viewport_resized():
	_position_quick_status_label()
	_update_subarray_outlines()
	_update_pivot_indicator()
	_build_recursion_map()

func _update_quick_sort_buttons():
	# Update button states based on current phase
	match quick_phase:
		QuickSortPhase.PIVOT_SELECTION:
			pivot_btn.disabled = false
			move_i_btn.disabled = true
			move_j_btn.disabled = true
			place_pivot_btn.disabled = true
			if quick_status_label:
				quick_status_label.text = "Phase: Select Pivot - Tap any block"
		
		QuickSortPhase.PARTITIONING:
			pivot_btn.disabled = true
			move_i_btn.disabled = i_locked
			move_j_btn.disabled = j_locked
			place_pivot_btn.disabled = true
			if quick_status_label:
				var status = "Phase: Partitioning - "
				if i_locked and j_locked:
					status += "Both locked! Swap highlighted blocks"
				elif i_locked:
					status += "i locked, move j"
				elif j_locked:
					status += "j locked, move i"
				else:
					status += "Move pointers"
				quick_status_label.text = status
		
		QuickSortPhase.PIVOT_PLACEMENT:
			pivot_btn.disabled = true
			move_i_btn.disabled = true
			move_j_btn.disabled = true
			place_pivot_btn.disabled = false
			if quick_status_label:
				quick_status_label.text = "Phase: Place Pivot - Click PLACE PIVOT button"

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

func _on_block_dropped(dropped_block: Control) -> void:
	if is_sorting or sorting_complete or is_shaking or is_animating:
		show_feedback(
			"Cannot drag blocks!!",
			Color.ORANGE,
			Vector2(dropped_block.global_position.x, START_POSITION.y - 20)
		)
		# Snap back immediately
		await _snap_block_back(dropped_block)
		return
	
	var old_index: int = block_nodes.find(dropped_block)
	if old_index == -1:
		print("Error: Dropped block not found in block_nodes")
		return
	
	# Handle pivot selection phase
	if quick_phase == QuickSortPhase.PIVOT_SELECTION:
		var valid = _handle_pivot_selection(old_index)
		if not valid:
			# Snap back if invalid pivot selection
			await _snap_block_back(dropped_block)
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
		# Snap back to original position
		await _snap_block_back(dropped_block)
		return
	
	# Get values before swap for logging
	var val1 = main_array[old_index]
	var val2 = main_array[insert_index]
	
	# Validate Quick Sort move
	var validation = _validate_quick_sort_move(old_index, insert_index)
	var is_valid = validation.valid
	var message = validation.message

	# Perform the swap in array
	var temp = main_array[old_index]
	main_array[old_index] = main_array[insert_index]
	main_array[insert_index] = temp
	
	# Update blocks array
	var temp_block = block_nodes[old_index]
	block_nodes[old_index] = block_nodes[insert_index]
	block_nodes[insert_index] = temp_block
	
	# Set animating state
	is_animating = true
	
	# Animate the swap
	await _animate_swap(block_nodes[old_index], block_nodes[insert_index])
	
	# Always resnap blocks to ensure proper positioning
	await _resnap_blocks()
	
	# Clear animating state
	is_animating = false

	if is_valid:
		correct_moves += 1
		timeline_log.append(
			"[color=green]Good swap: index[%d]:%d ↔ index[%d]:%d[/color]" 
			% [old_index, val1, insert_index, val2]
		)
		show_feedback(
			message,
			Color.GREEN,
			Vector2(dropped_block.global_position.x, START_POSITION.y - 20)
		)
		swap_counter += 1
		
		# After valid swap, unlock pointers and continue
		if quick_phase == QuickSortPhase.PARTITIONING:
			i_locked = false
			j_locked = false
			_update_pointers(pointer_i, pointer_j)
			_update_quick_sort_buttons()
			
			# Check if this swap completed the partition
			# For your example: swapping 41 and 21 is correct because 41 > pivot(23) and 21 < pivot(23)
			# After swap, we should continue with pointers
	else:
		mistake_counter += 1
		timeline_log.append(
			"[color=red]Bad swap: index[%d]:%d ↔ index[%d]:%d[/color]" 
			% [old_index, val1, insert_index, val2]
		)
		show_feedback(
			message,
			Color.RED,
			Vector2(dropped_block.global_position.x, START_POSITION.y - 20)
		)
		
		# For BAD moves only: swap back to original positions
		# Swap array back
		temp = main_array[old_index]
		main_array[old_index] = main_array[insert_index]
		main_array[insert_index] = temp
		
		# Swap blocks back
		temp_block = block_nodes[old_index]
		block_nodes[old_index] = block_nodes[insert_index]
		block_nodes[insert_index] = temp_block
		
		# Animate swap back
		is_animating = true
		await _animate_swap(block_nodes[old_index], block_nodes[insert_index])
		await _resnap_blocks()
		is_animating = false
	
	_update_timeline_display()
	_update_ui_labels()
	_update_undo_redo_buttons()
	_update_subarray_outlines()
	
	# Check if sorting is complete after valid moves
	if is_valid and _check_if_sorted() and not has_completed_assessment:
		_end_assessment("sorted")
		return
		
func _snap_block_back(block: Control) -> void:
	var index = block_nodes.find(block)
	if index != -1:
		var target_x = START_POSITION.x
		for i in range(index):
			target_x += block_nodes[i].size.x + BLOCK_SPACING
		
		var target_pos = Vector2(target_x, START_POSITION.y)
		var tween = create_tween()
		tween.tween_property(block, "position", target_pos, 0.2)
		await tween.finished
		
func _handle_pivot_selection(selected_index: int):
	# Check if block is within current subarray
	if selected_index < current_subarray_start or selected_index > current_subarray_end:
		show_feedback("Select pivot from current subarray!", Color.RED, 
					 block_nodes[selected_index].global_position)
		return false
	#check if blocks is already a locked pivot (sorted)
	if not block_nodes[selected_index].draggable:
		show_feedback("This block is already sorted! Choose another pivot.", Color.RED, block_nodes[selected_index].global_position)
		return false
	
	
	pivot_index = selected_index
	pivot_value = main_array[pivot_index]
	
	# Highlight pivot with crown
	_highlight_pivot(pivot_index)
	
	timeline_log.append(
		"[color=purple]Pivot %d selected at index[%d][/color]" % [pivot_value, pivot_index]
	)
	
	# If pivot not at end, perform "Safe Haven" swap
	if pivot_index != current_subarray_end:
		_safe_haven_swap(pivot_index, current_subarray_end)
	else:
		# Move to partitioning phase directly
		quick_phase = QuickSortPhase.PARTITIONING
		_initialize_pointers()
		status_label.text = "Partitioning: Use Move i/Move j buttons"
		_update_quick_sort_buttons()

func _safe_haven_swap(from_idx: int, to_idx: int):
	_save_state()
	
	# Swap in array
	var temp = main_array[from_idx]
	main_array[from_idx] = main_array[to_idx]
	main_array[to_idx] = temp
	
	# Swap blocks
	var temp_block = block_nodes[from_idx]
	block_nodes[from_idx] = block_nodes[to_idx]
	block_nodes[to_idx] = temp_block
	
	# Animate
	is_animating = true
	await _animate_swap(block_nodes[from_idx], block_nodes[to_idx])
	await _resnap_blocks()
	is_animating = false
	
	# Update pivot index
	pivot_index = to_idx
	_highlight_pivot(pivot_index)
	
	timeline_log.append(
		"[color=yellow]Safe Haven: Pivot moved to end (index %d → %d)[/color]" % [from_idx, to_idx]
	)
	
	# Move to partitioning phase
	quick_phase = QuickSortPhase.PARTITIONING
	_initialize_pointers()
	status_label.text = "Partitioning: Use Move i/Move j buttons"
	_update_quick_sort_buttons()

func _highlight_pivot(index: int):
	if index >= 0 and index < block_nodes.size() and block_nodes[index]:
		# Update crown position
		_update_pivot_indicator()
		
		# Set the pivot visual
		block_nodes[index].set_pivot_visual(true)

func _update_pivot_indicator():
	if not pivot_indicator:
		return
	
	if pivot_index >= 0 and pivot_index < block_nodes.size() and block_nodes[pivot_index]:
		var block = block_nodes[pivot_index]
		pivot_indicator.global_position = block.global_position + Vector2(
			(block.size.x - pivot_indicator.texture.get_width()) / 2,
			-40
		)
		pivot_indicator.show()
	else:
		pivot_indicator.hide()

func _is_subarray_sorted(start_idx: int, end_idx: int) -> bool:
	if start_idx >= end_idx:
		return true
	
	for i in range(start_idx, end_idx):
		if main_array[i] > main_array[i + 1]:
			return false
	return true
	
func _mark_subarray_sorted(start_idx: int, end_idx: int):
	# Mark all blocks in this subarray as sorted
	for i in range(start_idx, end_idx + 1):
		if i < block_nodes.size() and block_nodes[i]:
			block_nodes[i].draggable = false
			block_nodes[i].set_sorted_visual(true)
			sorted_array[i] = main_array[i]
	
	# Count this as a correct "virtual" operation
	sorted_subarrays_detected += 1
	correct_moves += 1  # They correctly identified it's sorted
	
	timeline_log.append(
		"[color=green]--- Subarray [%d-%d] already sorted! ---[/color]" % [start_idx, end_idx]
	)
	
	# Animate
	for i in range(start_idx, end_idx + 1):
		if i < block_nodes.size() and block_nodes[i]:
			var block = block_nodes[i]
			var original_scale = block.scale
			var tween = create_tween().set_parallel(false)
			tween.tween_property(block, "scale", original_scale * 1.1, 0.1)
			tween.tween_property(block, "scale", original_scale, 0.1)

func _initialize_pointers():
	pointer_i = current_subarray_start
	pointer_j = current_subarray_end - 1  # One before pivot
	i_locked = false
	j_locked = false
	
	_update_pointers(pointer_i, pointer_j)
	_check_pointer_locks()

func _update_pointers(left_idx: int, right_idx: int):
	if block_nodes.is_empty(): return
	if ptr_left: ptr_left.show()
	if ptr_right: ptr_right.show()
	
	if left_idx >= 0 and left_idx < block_nodes.size() and block_nodes[left_idx]:
		var node = block_nodes[left_idx]
		if ptr_left:
			ptr_left.global_position = node.global_position + Vector2(16, node.size.y + 10)
			ptr_left.modulate = Color(0, 0, 1, 1)  # Blue for i
	
	if right_idx >= 0 and right_idx < block_nodes.size() and block_nodes[right_idx]:
		var node = block_nodes[right_idx]
		if ptr_right:
			ptr_right.global_position = node.global_position + Vector2(16, node.size.y + 10)
			ptr_right.modulate = Color(1, 1, 0, 1)  # Yellow for j

func _on_move_i_pressed():
	btn_sound.play()
	
	if quick_phase != QuickSortPhase.PARTITIONING or i_locked:
		return
	pointer_movements += 1
	# Move i one step right
	pointer_i += 1
	
	# Check if crossed j
	if pointer_i > pointer_j:
		_handle_pointer_crossover()
		return
	
	# Update visual
	_update_pointers(pointer_i, pointer_j)
	_check_pointer_locks()
	
	timeline_log.append(
		"[color=cyan]Pointer i moved to index[%d]: %d[/color]" % [pointer_i, main_array[pointer_i]]
	)

func _on_move_j_pressed():
	btn_sound.play()
	
	if quick_phase != QuickSortPhase.PARTITIONING or j_locked:
		return
	
	# Move j one step left
	pointer_movements += 1
	pointer_j -= 1
	
	# Check if crossed i
	if pointer_j < pointer_i:
		_handle_pointer_crossover()
		return
	
	# Update visual
	_update_pointers(pointer_i, pointer_j)
	_check_pointer_locks()
	
	timeline_log.append(
		"[color=cyan]Pointer j moved to index[%d]: %d[/color]" % [pointer_j, main_array[pointer_j]]
	)

func _check_pointer_locks():
	# Check if i is locked (found element >= pivot)
	if not i_locked and pointer_i <= pointer_j:
		if main_array[pointer_i] >= pivot_value:
			i_locked = true
			show_feedback("i locked! Found element >= pivot", Color.YELLOW, 
						 block_nodes[pointer_i].global_position)
			timeline_log.append(
				"[color=yellow]Pointer i locked at index[%d]: %d (>= pivot %d)[/color]" % 
				[pointer_i, main_array[pointer_i], pivot_value]
			)
	
	# Check if j is locked (found element <= pivot)
	if not j_locked and pointer_j >= pointer_i:
		if main_array[pointer_j] <= pivot_value:
			j_locked = true
			show_feedback("j locked! Found element <= pivot", Color.YELLOW,
						 block_nodes[pointer_j].global_position)
			timeline_log.append(
				"[color=yellow]Pointer j locked at index[%d]: %d (<= pivot %d)[/color]" % 
				[pointer_j, main_array[pointer_j], pivot_value]
			)
	
	# If both locked, highlight swap candidates
	if i_locked and j_locked:
		_highlight_swap_candidates()
	
	_update_quick_sort_buttons()

func _highlight_swap_candidates():
	# Highlight the two blocks that should be swapped
	if pointer_i < block_nodes.size() and block_nodes[pointer_i]:
		block_nodes[pointer_i].set_highlight(true)
	if pointer_j < block_nodes.size() and block_nodes[pointer_j]:
		block_nodes[pointer_j].set_highlight(true)

func _handle_pointer_crossover():
	# Pointers crossed - move to pivot placement phase
	quick_phase = QuickSortPhase.PIVOT_PLACEMENT
	status_label.text = "Pointers crossed! Click PLACE PIVOT"
	
	# Hide pointers
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	
	timeline_log.append(
		"[color=green]--- Pointers crossed at i=%d, j=%d ---[/color]" % [pointer_i, pointer_j]
	)
	
	_update_quick_sort_buttons()

func _validate_quick_sort_move(old_index: int, new_index: int) -> Dictionary:
	# Only allow swaps during partitioning phase when both pointers locked
	if quick_phase != QuickSortPhase.PARTITIONING:
		return {
			"valid": false,
			"message": "Can only swap during partitioning"
		}
	
	# Check if both pointers are locked
	if not i_locked or not j_locked:
		return {
			"valid": false,
			"message": "Move pointers until both are locked first"
		}
	
	# Valid swap must be between locked i and j positions
	if (old_index == pointer_i and new_index == pointer_j) or \
	   (old_index == pointer_j and new_index == pointer_i):
		
		# Check if swap improves partitioning (puts smaller on left)
		if main_array[pointer_i] > main_array[pointer_j]:
			return {
				"valid": true,
				"message": "Good swap!"
			}
		else:
			return {
				"valid": false,
				"message": "Swap doesn't improve partition"
			}
	
	return {
		"valid": false,
		"message": "Swap only the highlighted blocks"
	}
	
func _on_pass_pressed() -> void:
	btn_sound.play()
	if quick_phase != QuickSortPhase.PARTITIONING:
		show_feedback("Can only pass during partitioning!", Color.ORANGE, get_global_mouse_position())
		return
	if not i_locked or not j_locked:
		show_feedback("Move pointers until both are locked first!", Color.ORANGE, get_global_mouse_position())
		return
	
	# Check if elements are already in correct order relative to pivot
	if main_array[pointer_i] <= pivot_value and main_array[pointer_j] >= pivot_value:
		correct_moves += 1
		timeline_log.append(
			"[color=green]Good pass: elements already in correct order[/color]"
		)
		show_feedback("Good pass!", Color.GREEN, get_global_mouse_position())
		# Unlock pointers and continue
		i_locked = false
		j_locked = false
		_update_pointers(pointer_i, pointer_j)
		_update_quick_sort_buttons()
	else:
		mistake_counter +=1
		timeline_log.append(
			"[color=red]Bad pass: should swap the highlighted blocks[/color]")
		show_feedback("Should swap!", Color.RED, get_global_mouse_position())
	
	
	
	
	
	
	
	
func _on_place_pivot_pressed():
	btn_sound.play()
	
	if quick_phase != QuickSortPhase.PIVOT_PLACEMENT:
		return
	correct_moves += 1
	pivot_placements += 1
	# Swap pivot into final position (at pointer_i)
	_place_pivot_at(pointer_i)
	
	# Lock pivot as sorted
	_lock_pivot(pointer_i)
	
	# Update recursion tree
	current_node.pivot_pos = pointer_i
	
	# Create subarrays
	_create_subarrays(pointer_i)
	
	# Update recursion map
	_build_recursion_map()
	
	# NEW: Check if left subarray is already sorted before moving to it
	if current_node.left_child and _is_subarray_sorted(current_node.left_child.start, current_node.left_child.end):
		_mark_subarray_sorted(current_node.left_child.start, current_node.left_child.end)
		current_node.left_child.pivot_pos = current_node.left_child.start  # Mark as processed
	
	# NEW: Check if right subarray is already sorted before moving to it
	if current_node.right_child and _is_subarray_sorted(current_node.right_child.start, current_node.right_child.end):
		_mark_subarray_sorted(current_node.right_child.start, current_node.right_child.end)
		current_node.right_child.pivot_pos = current_node.right_child.start  # Mark as processed
	
	# Move to next subarray or complete
	_advance_to_next_subarray()

func _place_pivot_at(position: int):
	_save_state()
	
	# Swap pivot (at end) with position
	var temp = main_array[pivot_index]
	main_array[pivot_index] = main_array[position]
	main_array[position] = temp
	
	# Swap blocks
	var temp_block = block_nodes[pivot_index]
	block_nodes[pivot_index] = block_nodes[position]
	block_nodes[position] = temp_block
	
	# Animate
	is_animating = true
	await _animate_swap(block_nodes[pivot_index], block_nodes[position])
	await _resnap_blocks()
	is_animating = false
	
	# Update pivot position
	pivot_index = position
	
	timeline_log.append(
		"[color=purple]Pivot %d placed at final position %d[/color]" % [pivot_value, pivot_index]
	)

func _lock_pivot(index: int):
	# Make block undraggable and green
	if block_nodes[index]:
		block_nodes[index].draggable = false
		block_nodes[index].set_sorted_visual(true)
	
	# Update sorted_array for reference
	sorted_array[index] = main_array[index]
	
	# Remove crown
	if pivot_indicator:
		pivot_indicator.hide()
	#ping animation
	var block = block_nodes[index]
	var original_scale = block.scale
	var tween = create_tween(). set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(block, "scale", original_scale * 1.2, 0.2)
	tween.tween_property(block, "scale", original_scale, 0.2)

func _create_subarrays(pivot_pos: int):
	# Create left subarray (start to pivot_pos-1)
	var left_start = current_subarray_start
	var left_end = pivot_pos - 1
	
	# Create right subarray (pivot_pos+1 to end)
	var right_start = pivot_pos + 1
	var right_end = current_subarray_end
	
	# Update recursion tree
	if left_start <= left_end:
		current_node.left_child = SubarrayNode.new(left_start, left_end)
		current_node.left_child.parent = current_node
		all_nodes.append(current_node.left_child)
		timeline_log.append(
			"[color=blue]Created left subarray [%d-%d][/color]" % [left_start, left_end]
		)
	
	if right_start <= right_end:
		current_node.right_child = SubarrayNode.new(right_start, right_end)
		current_node.right_child.parent = current_node
		all_nodes.append(current_node.right_child)
		timeline_log.append(
			"[color=yellow]Created right subarray [%d-%d][/color]" % [right_start, right_end]
		)
	
	# Update outlines
	_update_subarray_outlines()

func _update_subarray_outlines():
	if not subarray_outline_left or not subarray_outline_right:
		return
	
	if block_nodes.is_empty():
		subarray_outline_left.hide()
		subarray_outline_right.hide()
		return
	
	subarray_outline_left.hide()
	subarray_outline_right.hide()
	
	# Show outlines for current node's children
	if current_node:
		if current_node.left_child and current_node.left_child.start <= current_node.left_child.end:
			var left_start = current_node.left_child.start
			var left_end = current_node.left_child.end
			
			if left_start < block_nodes.size() and left_end < block_nodes.size():
				var first_block = block_nodes[left_start]
				var last_block = block_nodes[left_end]
				
				var left_pos = first_block.global_position - Vector2(10, 10)
				var left_width = (last_block.global_position.x + last_block.size.x) - first_block.global_position.x + 20
				var left_height = first_block.size.y + 20
				
				subarray_outline_left.global_position = left_pos
				subarray_outline_left.size = Vector2(left_width, left_height)
				subarray_outline_left.show()
		
		if current_node.right_child and current_node.right_child.start <= current_node.right_child.end:
			var right_start = current_node.right_child.start
			var right_end = current_node.right_child.end
			
			if right_start < block_nodes.size() and right_end < block_nodes.size():
				var first_block = block_nodes[right_start]
				var last_block = block_nodes[right_end]
				
				var right_pos = first_block.global_position - Vector2(10, 10)
				var right_width = (last_block.global_position.x + last_block.size.x) - first_block.global_position.x + 20
				var right_height = first_block.size.y + 20
				
				subarray_outline_right.global_position = right_pos
				subarray_outline_right.size = Vector2(right_width, right_height)
				subarray_outline_right.show()

func _advance_to_next_subarray():
	# Find next unsorted subarray (depth-first)
	if current_node.left_child and current_node.left_child.pivot_pos == -1:
		# Before activating, check if it's already sorted
		if _is_subarray_sorted(current_node.left_child.start, current_node.left_child.end):
			_mark_subarray_sorted(current_node.left_child.start, current_node.left_child.end)
			current_node.left_child.pivot_pos = current_node.left_child.start
			# Continue to next after marking
			_advance_to_next_subarray()
			return
		else:
			_set_active_subarray(current_node.left_child)
			
	elif current_node.right_child and current_node.right_child.pivot_pos == -1:
		# Before activating, check if it's already sorted
		if _is_subarray_sorted(current_node.right_child.start, current_node.right_child.end):
			_mark_subarray_sorted(current_node.right_child.start, current_node.right_child.end)
			current_node.right_child.pivot_pos = current_node.right_child.start
			# Continue to next after marking
			_advance_to_next_subarray()
			return
		else:
			_set_active_subarray(current_node.right_child)
	else:
		# Go up to parent and look for unsorted
		var parent = current_node.parent
		while parent:
			if parent.right_child and parent.right_child.pivot_pos == -1:
				# Check if right child is sorted
				if _is_subarray_sorted(parent.right_child.start, parent.right_child.end):
					_mark_subarray_sorted(parent.right_child.start, parent.right_child.end)
					parent.right_child.pivot_pos = parent.right_child.start
					current_node = parent
					_advance_to_next_subarray()
					return
				else:
					_set_active_subarray(parent.right_child)
					return
			parent = parent.parent
			current_node = parent
		
		# No unsorted subarrays left - check if complete
		_check_quick_sort_complete()

func _set_active_subarray(node: SubarrayNode):
	current_node = node
	current_subarray_start = node.start
	current_subarray_end = node.end
	
	timeline_log.append(
		"[color=gray]Navigated to subarray [%d-%d][/color]" % [node.start, node.end]
	)
	
	# NEW: Check if this subarray is already sorted
	if _is_subarray_sorted(current_subarray_start, current_subarray_end):
		# Mark entire subarray as sorted
		_mark_subarray_sorted(current_subarray_start, current_subarray_end)
		
		# Update node in recursion tree
		current_node.pivot_pos = current_subarray_start  # Mark as processed
		
		# Show feedback
		if status_label:
			status_label.text = "Subarray already sorted! Moving on..."
		
		# Wait a moment then move to next subarray
		await get_tree().create_timer(0.5).timeout
		_advance_to_next_subarray()
		return
	
	# Reset for new partition (only if not already sorted)
	quick_phase = QuickSortPhase.PIVOT_SELECTION
	pivot_index = -1
	if pivot_indicator:
		pivot_indicator.hide()
	
	if status_label:
		status_label.text = "Select a pivot for the new subarray"
	
	# Clear highlights
	for block in block_nodes:
		block.set_highlight(false)
	
	# Update visuals
	_update_subarray_outlines()
	_build_recursion_map()
	_update_quick_sort_buttons()
	
	# Hide pointers
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()




func _check_quick_sort_complete():
	# Check if all nodes have pivots placed
	for node in all_nodes:
		if node.pivot_pos == -1 and node.start <= node.end:
			return  # Still unsorted
	
	# All done!
	_end_assessment("sorted")



func _check_array_fully_sorted() -> bool:
	for i in range(main_array.size() - 1):
		if main_array[i] > main_array[i + 1]:
			return false
	return true

func _build_recursion_map():
	# Clear existing map
	for child in recursion_map.get_children():
		child.queue_free()
	
	if not recursion_root:
		return
	
	# Create tree visualization
	_create_tree_node(recursion_root, 0, recursion_map.size.x / 2)

func _create_tree_node(node: SubarrayNode, depth: int, x_pos: float):
	var node_btn = TREE_NODE_BUTTON.instantiate()
	
	# Set the text
	if node.pivot_pos != -1:
		node_btn.text = "[%d-%d]\np%d" % [node.start, node.end, main_array[node.pivot_pos]]
	else:
		node_btn.text = "[%d-%d]" % [node.start, node.end]
	
	# Text colors based on state
	if node == current_node:
		node_btn.add_theme_color_override("font_color", Color(1, 0, 0))
	elif node.pivot_pos != -1:
		node_btn.add_theme_color_override("font_color", Color(0,0,0))
	else:
		node_btn.add_theme_color_override("font_color", Color(1, 1, 1))
	
	node_btn.pressed.connect(_on_tree_node_pressed.bind(node))
	
	node_btn.position = Vector2(x_pos - 60, 20 + depth * 60)
	node_btn.size = Vector2(120, 50)
	
	recursion_map.add_child(node_btn)
	
	if node.left_child:
		_create_tree_node(node.left_child, depth + 1, x_pos - 100)
	if node.right_child:
		_create_tree_node(node.right_child, depth + 1, x_pos + 100)

func _on_tree_node_pressed(node: SubarrayNode):
	if node.pivot_pos != -1:
		show_feedback("This partition is already sorted!", Color.GRAY, get_global_mouse_position())
		return
	
	# Jump to that subarray
	_set_active_subarray(node)

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
	
	if tweens.size() > 0:
		await tweens[-1].finished

func _animate_swap(node_a: Control, node_b: Control):
	var pos_a = node_a.position
	var pos_b = node_b.position
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(node_a, "position", pos_b, ANIM_SPEED)
	tween.tween_property(node_b, "position", pos_a, ANIM_SPEED)
	await tween.finished

func _save_state() -> void:
	var state := {
		"array": main_array.duplicate(),
		"quick_phase": quick_phase,
		"pivot_index": pivot_index,
		"pivot_value": pivot_value,
		"pointer_i": pointer_i,
		"pointer_j": pointer_j,
		"i_locked": i_locked,
		"j_locked": j_locked,
		"current_subarray_start": current_subarray_start,
		"current_subarray_end": current_subarray_end,
		"mistakes": mistake_counter,
		"comparisons": comparison_counter,
		"swaps": swap_counter
	}
	undo_stack.append(state)

func _restore_state(state: Dictionary) -> void:
	main_array = state["array"].duplicate()
	sorted_array = main_array.duplicate()
	sorted_array.sort()
	
	quick_phase = state["quick_phase"]
	pivot_index = state["pivot_index"]
	pivot_value = state["pivot_value"]
	pointer_i = state["pointer_i"]
	pointer_j = state["pointer_j"]
	i_locked = state["i_locked"]
	j_locked = state["j_locked"]
	current_subarray_start = state["current_subarray_start"]
	current_subarray_end = state["current_subarray_end"]
	mistake_counter = state["mistakes"]
	comparison_counter = state["comparisons"]
	swap_counter = state.get("swaps", 0)
	
	_rebuild_blocks_from_array()
	_update_pivot_indicator()
	_update_subarray_outlines()
	_update_pointers(pointer_i, pointer_j)
	_update_quick_sort_buttons()

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

func _update_ui_labels():
	compare_label.text = "Correct Moves: %d " % [correct_moves]
	if pivot_placements > 0:
		compare_label.text += " | Pivots: %d" % pivot_placements

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
		"quick_phase": quick_phase,
		"pivot_index": pivot_index,
		"pivot_value": pivot_value,
		"pointer_i": pointer_i,
		"pointer_j": pointer_j,
		"i_locked": i_locked,
		"j_locked": j_locked,
		"current_subarray_start": current_subarray_start,
		"current_subarray_end": current_subarray_end,
		"mistakes": mistake_counter,
		"comparisons": comparison_counter,
		"swaps": swap_counter
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
		"quick_phase": quick_phase,
		"pivot_index": pivot_index,
		"pivot_value": pivot_value,
		"pointer_i": pointer_i,
		"pointer_j": pointer_j,
		"i_locked": i_locked,
		"j_locked": j_locked,
		"current_subarray_start": current_subarray_start,
		"current_subarray_end": current_subarray_end,
		"mistakes": mistake_counter,
		"comparisons": comparison_counter,
		"swaps": swap_counter
	})
	
	_restore_state(state)

func _on_try_again_button_pressed() -> void:
	btn_sound.play()
	time_up_popup.hide()
	result_popup.hide()
	_start_assessment_mode()
	await get_tree().process_frame
	_update_undo_redo_buttons()

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
	for block in block_nodes:
		if block.draggable:
			pass
	return true

func _get_required_threshold() -> float:
	match difficulty:
		1: return 0.6
		2: return 0.75
		3: return 0.8
	return 0.7

func _compute_grade() -> Dictionary:
	var total_moves = correct_moves + mistake_counter
	
	# If no moves were made at all (array already sorted)
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

func _count_sorted_opportunities() -> int:
	# Count how many subarrays might be auto-sorted
	var count = 0
	for node in all_nodes:
		if node.pivot_pos == -1 and node.start <= node.end:
			if _is_subarray_sorted(node.start, node.end):
				count += 1
	return count
	
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
	if pivot_btn:
		pivot_btn.disabled = true
	if move_i_btn:
		move_i_btn.disabled = true
	if move_j_btn:
		move_j_btn.disabled = true
	if place_pivot_btn:
		place_pivot_btn.disabled = true
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	
	if reason == "sorted":
		var grade = _compute_grade()
		var result = "PASS" if grade["passed"] else "FAIL"
		_show_result_popup(result, grade)
	else: # timeout
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
		
		# Enhanced summary
		if grade_data.has("summary"):
			score_summary.text = grade_data["summary"]
		else:
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

# ==============================================
#   PROCESS & TIMER
# ==============================================

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
			code = get_cpp_quick_code(arr_str)
			current_tutorial_data = cpp_tutorial_data
		"python":
			code = get_python_quick_code(arr_str)
			current_tutorial_data = python_tutorial_data
		"java":
			code = get_java_quick_code(arr_str)
			current_tutorial_data = java_tutorial_data
		"c":
			code = get_c_quick_code(arr_str)
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
			"cpp": base_code = get_cpp_quick_code(arr_str)
			"python": base_code = get_python_quick_code(arr_str)
			"java": base_code = get_java_quick_code(arr_str)
			"c": base_code = get_c_quick_code(arr_str)

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

func get_cpp_quick_code(arr: String) -> String:
	return """/* Quick Sort - Time Complexity: O(n log n) average, O(n²) worst */
#include <iostream>
using namespace std;

int partition(int arr[], int low, int high) {
	int pivot = arr[high];  // Choose last element as pivot
	int i = low - 1;        // Index of smaller element
	
	for (int j = low; j < high; j++) {
		if (arr[j] < pivot) {
			i++;
			swap(arr[i], arr[j]);
		}
	}
	swap(arr[i + 1], arr[high]);
	return i + 1;
}

void quickSort(int arr[], int low, int high) {
	if (low < high) {
		int pi = partition(arr, low, high);
		quickSort(arr, low, pi - 1);
		quickSort(arr, pi + 1, high);
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
	
	quickSort(arr, 0, n - 1);
	
	cout << "Sorted array: ";
	printArray(arr, n);
	
	return 0;
}""" % arr

func get_python_quick_code(arr: String) -> String:
	return """# Quick Sort - Time Complexity: O(n log n) average
def quick_sort(arr):
	if len(arr) <= 1:
		return arr
	pivot = arr[-1]  # Choose last element as pivot
	left = [x for x in arr[:-1] if x <= pivot]
	right = [x for x in arr[:-1] if x > pivot]
	return quick_sort(left) + [pivot] + quick_sort(right)

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

sorted_arr = quick_sort(arr)

print("Sorted array: ", end="")
print_array(sorted_arr)""" % arr

func get_java_quick_code(arr: String) -> String:
	return """/* Quick Sort - Time Complexity: O(n log n) */
public class Main {
	static int partition(int arr[], int low, int high) {
		int pivot = arr[high];
		int i = low - 1;
		for (int j = low; j < high; j++) {
			if (arr[j] < pivot) {
				i++;
				int temp = arr[i];
				arr[i] = arr[j];
				arr[j] = temp;
			}
		}
		int temp = arr[i + 1];
		arr[i + 1] = arr[high];
		arr[high] = temp;
		return i + 1;
	}
	
	static void sort(int arr[], int low, int high) {
		if (low < high) {
			int pi = partition(arr, low, high);
			sort(arr, low, pi - 1);
			sort(arr, pi + 1, high);
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
		
		System.out.print("Initial array (unsorted): ");
		printArray(arr);
		
		sort(arr, 0, arr.length - 1);
		
		System.out.print("Sorted array: ");
		printArray(arr);
	}
}""" % arr

func get_c_quick_code(arr: String) -> String:
	return """/* Quick Sort - Time Complexity: O(n log n) */
#include <stdio.h>

void swap(int* a, int* b) {
	int t = *a;
	*a = *b;
	*b = t;
}

int partition(int arr[], int low, int high) {
	int pivot = arr[high];
	int i = low - 1;
	
	for (int j = low; j < high; j++) {
		if (arr[j] < pivot) {
			i++;
			swap(&arr[i], &arr[j]);
		}
	}
	swap(&arr[i + 1], &arr[high]);
	return i + 1;
}

void quickSort(int arr[], int low, int high) {
	if (low < high) {
		int pi = partition(arr, low, high);
		quickSort(arr, low, pi - 1);
		quickSort(arr, pi + 1, high);
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
	
	quickSort(arr, 0, n - 1);
	
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
			code = get_cpp_quick_code(arr_str)
		"c":
			code = get_c_quick_code(arr_str)
		"java":
			code = get_java_quick_code(arr_str)
		"python":
			code = get_python_quick_code(arr_str)
	
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
			code = get_cpp_quick_code(arr_str)
		"c":
			code = get_c_quick_code(arr_str)
		"java":
			code = get_java_quick_code(arr_str)
		"python":
			code = get_python_quick_code(arr_str)
	
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
#   BUTTON CALLBACKS (Unchanged from original)
# ==============================================

func _on_pivot_button_pressed():
	btn_sound.play()
	# Pivot button just prompts user to tap a block
	status_label.text = "Tap any block to select it as pivot"

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
	reset_cache_for_scene()
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
			"node": pivot_btn,
			"title": "PIVOT",
			"text": "Click this button then tap any block to select it as the pivot. The pivot will be highlighted with a crown.",
			"action": "highlight"
		},
		{
			"node": move_i_btn,
			"title": "MOVE i",
			"text": "Moves the left pointer (blue) one step right. It stops when it finds an element greater than or equal to the pivot.",
			"action": "highlight"
		},
		{
			"node": move_j_btn,
			"title": "MOVE j",
			"text": "Moves the right pointer (yellow) one step left. It stops when it finds an element less than or equal to the pivot.",
			"action": "highlight"
		},
		{
			"node": place_pivot_btn,
			"title": "PLACE PIVOT",
			"text": "After pointers cross, click this to place the pivot in its final sorted position.",
			"action": "highlight"
		},
		{
			"node": recursion_map,
			"title": "RECURSION MAP",
			"text": "Shows the recursive structure. Click any unsorted subarray to jump to it.",
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
#   CONFIGURATION & INTRO FUNCTIONS
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
	_init_quick_sort()

func _on_config_no_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	var count = randi_range(5, 7)
	var arr: Array[int] = []
	for i in count: arr.append(randi_range(1, 99))
	_set_main_ui_enabled(true)
	help_btn.show()
	_initialize_with_elements(arr)
	_init_quick_sort()

func _on_size_back_pressed(): 
	config_size_modal.hide()
	config_modal.show()

func _on_elements_back_pressed(): 
	config_elements_modal.hide()
	config_size_modal.show()

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
	if pivot_btn: pivot_btn.disabled = not enabled
	if move_i_btn: move_i_btn.disabled = not enabled
	if move_j_btn: move_j_btn.disabled = not enabled
	if place_pivot_btn: place_pivot_btn.disabled = not enabled
