extends Control

# --- COMPILER INTEGRATION ---
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = $CppPopup/VBoxContainer/HBoxContainer2/CompileButton

# --- MAIN BUTTONS ---
@onready var undo_btn: Button = $VBoxContainer/SortButton
@onready var redo_btn: Button = $VBoxContainer/WaitingElements
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
@onready var help_btn: Button = $HelpButton
@onready var q_mark_sprite: AnimatedSprite2D = $HelpButton/Q_mark_anim_sprites

# --- LANGUAGE BUTTONS ---
@onready var cpp_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Cpp_btn
@onready var python_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Py_btn
@onready var java_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Java_btn
@onready var c_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/C_btn

# --- TIMER ELEMENTS ---
@onready var timer_label: Label = $VBoxContainer/HBoxContainer/Label2
@onready var clock: AnimatedSprite2D = $VBoxContainer/HBoxContainer/AnimatedSprite2D
@onready var hbox = $VBoxContainer/HBoxContainer
@onready var time_up_popup: PopupPanel = $TimeUpPopup
@onready var time_up_try_again_btn: Button = $TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/TryAgainButton
@onready var time_up_back_btn: Button = $TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/BackButton
@onready var try_again_btn_root: Button = $TryAgainButton
@onready var difficulty_label: Label = $DiificultyLabel

# --- RESULT POPUP ---
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

# --- API KEYS ---
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

# --- AUDIO SFX ---
const TIKTAK_SFX := preload("res://assets/sfx/tiktak.mp3")
var tiktak_sound: AudioStreamPlayer

# --- TOPIC IDENTIFICATION ---
const CURRENT_TOPIC = "bubble_sort"

# --- BUBBLE SORT VARIABLES ---
var main_array: Array[int] = []
var initial_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []

var sort_i: int = 0  
var sort_j: int = 0 
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
var ANIM_SPEED: float = 1.0

var current_tween: Tween = null
var highlight_tween: Tween = null

var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

var intro_step: int = 0
var intro_texts = [
	"Welcome to Bubble Sort Assessment!\n\nBubble Sort repeatedly steps through the list, compares adjacent elements, and swaps them if they're in the wrong order.",
	"The Algorithm:\n\n1. Compare adjacent elements (j and j+1)\n2. If arr[j] > arr[j+1], SWAP them\n3. Move to next pair (j++)\n4. After each pass, the largest element 'bubbles' to the end",
	"Instructions:\n\n• The PULSING block is the LEFT element being compared (index j)\n• Drag the PULSING block to the RIGHT to swap with its neighbor\n• Green feedback = correct swap (left > right)\n• Red feedback = incorrect swap (left <= right)\n• Bad swaps still happen but count as mistakes!",
	"Scoring:\n\n✓ Correct swap = Good move\n✗ Wrong swap = Bad move\n\nAccuracy = Good moves / Total moves\n\nUndo/Redo available on Easy & Medium!",
	"Difficulty Levels:\n\nEasy: Undo/Redo allowed, no timer\nMedium: Undo/Redo allowed, 90 seconds\nHard: No Undo/Redo, 60 seconds"
]

# --- CODE TUTORIAL DATA ---
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Complexity Analysis:\nBubble Sort has O(n^2) Time Complexity, O(1) Space Complexity." },
	{ "lines": [2, 3], "text": "2. Imports & Setup:\nIncludes standard libraries." },
	{ "lines": [6], "text": "3. Outer Loop:\nControls number of passes through the array." },
	{ "lines": [7], "text": "4. Inner Loop:\nCompares adjacent elements, stopping before sorted portion." },
	{ "lines": [8, 9, 10, 11, 12], "text": "5. The Swap:\nIf left > right, swap them using a temporary variable." },
	{ "lines": [17, 18, 19, 20, 21], "text": "6. Main Function:\nInitialize array and call bubbleSort." }
]

var python_tutorial_data = [
	{ "lines": [0, 1, 2], "text": "1. Complexity:\nTime O(n^2), Space O(1)." },
	{ "lines": [3, 4], "text": "2. Function Definition:\nDefine function and get array length." },
	{ "lines": [5], "text": "3. Outer Loop:\nControl passes through array." },
	{ "lines": [6], "text": "4. Inner Loop:\nCompare adjacent elements up to sorted portion." },
	{ "lines": [7, 8], "text": "5. Python Swap:\nSwap in one line without temp variable." },
	{ "lines": [10, 11, 12], "text": "6. Execution:\nCreate array and call function." }
]

var java_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Class Structure:\nAll code in a class." },
	{ "lines": [2, 3], "text": "2. Method Definition:\nDefine sort method." },
	{ "lines": [4], "text": "3. Outer Loop:\nControl passes (n-1 times)." },
	{ "lines": [5], "text": "4. Inner Loop:\nCompare up to last unsorted element." },
	{ "lines": [6, 7, 8, 9, 10], "text": "5. The Swap:\nSwap using temporary integer." },
	{ "lines": [12, 13, 14, 15, 16], "text": "6. Main Method:\nCreate object and call sort." }
]

var c_tutorial_data = [
	{ "lines": [0], "text": "1. Setup:\nInclude standard I/O." },
	{ "lines": [1, 2], "text": "2. Function Start:\nDeclare variables." },
	{ "lines": [3], "text": "3. Outer Loop:\nControl passes." },
	{ "lines": [4], "text": "4. Inner Loop:\nCompare adjacent elements." },
	{ "lines": [5, 6, 7, 8], "text": "5. The Swap:\nSwap using temporary variable." },
	{ "lines": [9, 10, 11], "text": "6. Main:\nCreate array and call function." }
]

enum SimMode { LECTURE, ASSESSMENT }
var sim_mode: SimMode = SimMode.ASSESSMENT
var difficulty: int = 2

var time_remaining: float = 0.0
var timer_running: bool = false
var assessment_time_limit: float = 0.0

var undo_stack: Array = []
var redo_stack: Array = []
var move_history: Array = []
var move_redo_stack: Array = []

var has_completed_assessment: bool = false
var time_when_completed: float = 0.0
var coins_earned: int = 0
var completion_type: String = ""

# ==============================================
#   SCREEN ORIENTATION MANAGEMENT
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

# ==============================================
#   READY & INITIALIZATION
# ==============================================
func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	
	difficulty = Global.current_difficulty
	if difficulty == 0:
		difficulty = 2
	
	tiktak_sound = AudioStreamPlayer.new()
	tiktak_sound.stream = TIKTAK_SFX
	add_child(tiktak_sound)
	
	try_again_btn_root.visible = false
	
	print("Bubble Sort Assessment started — difficulty: ", difficulty)
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
	
	try_again_result_btn.pressed.connect(_on_try_again_result_pressed)
	back_result_btn.pressed.connect(_on_back_result_pressed)
	translate_code_btn.pressed.connect(_on_translate_code_pressed)
	
	if time_up_try_again_btn:
		time_up_try_again_btn.pressed.connect(_on_time_up_try_again_pressed)
	if time_up_back_btn:
		time_up_back_btn.pressed.connect(_on_time_up_back_pressed)
	
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
	
	if undo_btn: undo_btn.text = "UNDO"
	if redo_btn: redo_btn.text = "REDO"
	
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
	
	if try_again_btn_root:
		if not try_again_btn_root.is_connected("pressed", _on_try_again_root_pressed):
			try_again_btn_root.pressed.connect(_on_try_again_root_pressed)
	
	if help_btn:
		if not help_btn.is_connected("pressed", _on_help_button_pressed):
			help_btn.pressed.connect(_on_help_button_pressed)
	
	if timeline_close_btn:
		if not timeline_close_btn.is_connected("pressed", _on_timeline_close_pressed):
			timeline_close_btn.pressed.connect(_on_timeline_close_pressed)
	
	if complete_ok_btn:
		if not complete_ok_btn.is_connected("pressed", _on_complete_ok_pressed):
			complete_ok_btn.pressed.connect(_on_complete_ok_pressed)
	if show_cpp_btn:
		if not show_cpp_btn.is_connected("pressed", _on_show_cpp_pressed):
			show_cpp_btn.pressed.connect(_on_show_cpp_pressed)
	
	if cpp_close_btn:
		if not cpp_close_btn.is_connected("pressed", _on_cpp_close_pressed):
			cpp_close_btn.pressed.connect(_on_cpp_close_pressed)
	if cpp_code_button:
		if not cpp_code_button.is_connected("pressed", _on_cpp_code_button_pressed):
			cpp_code_button.pressed.connect(_on_cpp_code_button_pressed)
	
	if undo_btn:
		if not undo_btn.is_connected("pressed", _on_undo_pressed):
			undo_btn.pressed.connect(_on_undo_pressed)
	if redo_btn:
		if not redo_btn.is_connected("pressed", _on_redo_pressed):
			redo_btn.pressed.connect(_on_redo_pressed)
	if timeline_btn:
		if not timeline_btn.is_connected("pressed", _on_timeline_pressed):
			timeline_btn.pressed.connect(_on_timeline_pressed)
	
	_ensure_connected(intro_next_btn, "pressed", _on_intro_next_pressed)
	_ensure_connected(intro_prev_btn, "pressed", _on_intro_prev_pressed)
	_ensure_connected(intro_skip_btn, "pressed", _on_intro_skip_pressed)
	
	clock.centered = true
	clock.position = Vector2(0, 18)
	
	_update_difficulty_label()
	_setup_timeline_popup_for_mobile()
	_setup_compiler()

func _ensure_connected(node: Node, sig: String, callable: Callable) -> void:
	if node and not node.is_connected(sig, callable):
		node.connect(sig, callable)

func _get_array_size() -> int:
	match difficulty:
		1: return 4
		2: return 5
		3: return 7
	return 5

func _get_time_limit() -> float:
	match difficulty:
		1: return 0.0
		2: return 90.0
		3: return 60.0
	return 90.0

func _get_required_threshold() -> float:
	match difficulty:
		1: return 0.6
		2: return 0.75
		3: return 0.8
	return 0.7

func _update_difficulty_label() -> void:
	if not difficulty_label:
		return
	match difficulty:
		1: difficulty_label.text = "Difficulty: Easy"
		2: difficulty_label.text = "Difficulty: Medium"
		3: difficulty_label.text = "Difficulty: Hard"

func _setup_timeline_popup_for_mobile() -> void:
	if not timeline_popup:
		return
	var scroll_container = timeline_popup.find_child("ScrollContainer", true, false)
	if scroll_container:
		scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
		scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		scroll_container.mouse_filter = Control.MOUSE_FILTER_STOP

# ==============================================
#   COMPILER SETUP FUNCTIONS
# ==============================================
func _setup_compiler() -> void:
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

func _on_compile_button_pressed() -> void:
	btn_sound.play()
	var arr_str = ", ".join(initial_array.map(func(x): return str(x)))
	var code = _get_code_for_language(current_code_language, arr_str)
	
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

func _get_code_for_language(lang: String, arr_str: String) -> String:
	match lang:
		"cpp": return get_cpp_bubble_code(arr_str)
		"c": return get_c_bubble_code(arr_str)
		"java": return get_java_bubble_code(arr_str)
		"python": return get_python_bubble_code(arr_str)
	return get_cpp_bubble_code(arr_str)

func _compile_code(code: String) -> void:
	show_feedback("Compiling...", Color.YELLOW, Vector2(200, 200))
	var keys = API_KEYS[current_code_language]
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_compile_completed.bind(http_request, current_code_language))
	
	var url = "https://api.jdoodle.com/v1/execute"
	var headers = ["Content-Type: application/json"]
	
	var api_language = current_code_language
	match current_code_language:
		"python":
			api_language = "python3"
	
	var body = JSON.new().stringify({
		"clientId": keys["clientId"],
		"clientSecret": keys["clientSecret"],
		"script": code,
		"language": api_language,
		"versionIndex": _get_version_index(current_code_language)
	})
	
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

func _on_compile_completed(result, response_code, headers, body, http_request, language: String) -> void:
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

func _on_recompile_requested(language: String) -> void:
	var arr_str = ", ".join(initial_array.map(func(x): return str(x)))
	var code = _get_code_for_language(language, arr_str)
	_compile_code(code)

func _on_compiler_output_closed() -> void:
	print("Compiler output closed")

func reset_cache_for_scene() -> void:
	if compiler_output_popup:
		compiler_output_popup.reset_cache_for_scene()

# ==============================================
#   ASSESSMENT START
# ==============================================
func _start_assessment_mode() -> void:
	reset_cache_for_scene()
	try_again_btn_root.visible = false
	
	if current_tween:
		current_tween.kill()
		current_tween = null
	if highlight_tween:
		highlight_tween.kill()
		highlight_tween = null
	
	timer_running = false
	tiktak_sound.stop()
	
	mistake_counter = 0
	correct_moves = 0
	comparison_counter = 0
	swap_counter = 0
	sort_i = 0
	sort_j = 0
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
	
	assessment_time_limit = _get_time_limit()
	time_remaining = assessment_time_limit
	
	if difficulty == 1:
		timer_label.hide()
		clock.visible = false
		clock.modulate = Color(1,1,1,0)
		clock.stop()
		timer_running = false
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
	
	_update_undo_redo_buttons()
	_update_difficulty_label()
	
	timeline_log.append("[color=cyan]--- Assessment Started ---[/color]")
	timeline_log.append("[color=cyan]Initial array: [%s][/color]" % _array_to_string(main_array))

func _array_to_string(arr: Array) -> String:
	var parts: Array[String] = []
	for v in arr:
		parts.append(str(v))
	return ", ".join(parts)

# ==============================================
#   INITIALIZATION
# ==============================================
func _initialize_with_elements(elements: Array[int]) -> void:
	print("Initializing Array with:", elements)
	audio_player.play()
	
	main_array = elements.duplicate()
	initial_array = elements.duplicate()
	block_nodes.clear()
	
	if current_tween:
		current_tween.kill()
		current_tween = null
	if highlight_tween:
		highlight_tween.kill()
		highlight_tween = null
	
	sort_i = 0
	sort_j = 0
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

	_update_ui_labels()
	if cpp_code_button: cpp_code_button.hide()
	_update_current_highlight()

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
	
	if time_remaining <= 10.0 and timer_running and time_remaining > 0:
		if not tiktak_sound.playing:
			tiktak_sound.play()

func _on_time_up() -> void:
	tiktak_sound.stop()
	show_feedback("Time's Up!", Color.RED, START_POSITION)
	timer_running = false
	is_sorting = true
	_end_assessment("timeout")

# ==============================================
#   HIGHLIGHT & SORTED VISUALS
# ==============================================
func _update_current_highlight() -> void:
	if block_nodes.is_empty() or sorting_complete:
		return
	
	if highlight_tween:
		highlight_tween.kill()
		highlight_tween = null
	
	
	for i in range(block_nodes.size()):
		if not is_instance_valid(block_nodes[i]):
			continue
		if block_nodes[i].has_method("set_highlight"):
			block_nodes[i].set_highlight(false)
		block_nodes[i].scale = Vector2(1.0, 1.0)
		if block_nodes[i].has_method("set_sorted_visual"):
			block_nodes[i].set_sorted_visual(false)
	
	
	var highlight_index = -1
	for i in range(main_array.size() - 1):
		if main_array[i] > main_array[i + 1]:
			highlight_index = i
			break
	
	
	if highlight_index == -1:
		
		for i in range(block_nodes.size()):
			if not is_instance_valid(block_nodes[i]):
				continue
			if block_nodes[i].has_method("set_sorted_visual"):
				block_nodes[i].set_sorted_visual(true)
		if status_label:
			status_label.text = "Array is fully sorted!"
		sorting_complete = true
		return
	
	
	sort_j = highlight_index
	
	
	if highlight_index < block_nodes.size() and is_instance_valid(block_nodes[highlight_index]):
		if block_nodes[highlight_index].has_method("set_highlight"):
			block_nodes[highlight_index].set_highlight(true)
			highlight_tween = create_tween().set_loops()
			highlight_tween.tween_property(block_nodes[highlight_index], "scale", Vector2(1.15, 1.15), 0.6)
			highlight_tween.tween_property(block_nodes[highlight_index], "scale", Vector2(1.0, 1.0), 0.6)
		
		if status_label:
			status_label.text = "Element %d at index %d needs to swap RIGHT with index %d" % [main_array[highlight_index], highlight_index, highlight_index + 1]

func _resnap_blocks() -> void:
	var x = START_POSITION.x
	for i in range(block_nodes.size()):
		var child = block_nodes[i]
		if not is_instance_valid(child):
			continue
		var target_pos = Vector2(x, START_POSITION.y)
		var tween = create_tween()
		tween.tween_property(child, "position", target_pos, 0.2)
		x += child.size.x + BLOCK_SPACING

func _check_if_sorted() -> bool:
	for i in range(main_array.size() - 1):
		if main_array[i] > main_array[i + 1]:
			return false
	return true

func _update_ui_labels() -> void:
	if not compare_label:
		return
	compare_label.text = "Correct Swaps: %d | Mistakes: %d" % [correct_moves, mistake_counter]

# ==============================================
#   BLOCK DRAG & DROP (SWAP LOGIC)
# ==============================================
func _on_block_dropped(dropped_block: Control) -> void:
	if is_sorting or sorting_complete or has_completed_assessment:
		show_feedback("Cannot drag blocks!", Color.ORANGE, Vector2(dropped_block.global_position.x, START_POSITION.y - 20))
		_resnap_blocks()
		return
	
	var old_index: int = block_nodes.find(dropped_block)
	if old_index == -1:
		return

	var center_x: float = dropped_block.position.x + dropped_block.size.x * 0.5
	var new_index: int = 0
	
	for i in range(block_nodes.size()):
		var c = block_nodes[i]
		if c == dropped_block:
			continue
		var c_center: float = c.position.x + c.size.x * 0.5
		if center_x > c_center:
			new_index += 1
	
	if old_index == new_index:
		_resnap_blocks()
		return
	
	var moved_val = main_array[old_index]
	var target_val = main_array[new_index] if new_index < main_array.size() else null
	

	var is_valid = false
	var validation_message = ""
	
	if old_index == sort_j:
		
		if new_index == sort_j + 1:
			if main_array[sort_j] > main_array[sort_j + 1]:
				is_valid = true
				validation_message = "Good move! Swapping %d with %d fixes inversion" % [main_array[sort_j], main_array[sort_j + 1]]
			else:
				is_valid = false
				validation_message = "Bad move! %d <= %d - No swap needed here" % [main_array[sort_j], main_array[sort_j + 1]]
		else:
			is_valid = false
			validation_message = "Bad move! Highlighted block must swap with its RIGHT neighbor (index %d)" % (sort_j + 1)
	else:
		is_valid = false
		validation_message = "Bad move! You must drag the HIGHLIGHTED block (index %d)" % sort_j
	
	_save_undo_state()
	redo_stack.clear()
	
	var val = main_array.pop_at(old_index)
	main_array.insert(new_index, val)
	
	var moving_block = block_nodes[old_index]
	block_nodes.remove_at(old_index)
	block_nodes.insert(new_index, moving_block)
	
	var move_data = {
		"old_index": old_index,
		"new_index": new_index,
		"moved_val": moved_val,
		"target_val": target_val,
		"was_valid": is_valid
	}
	move_history.append(move_data)
	move_redo_stack.clear()
	
	if is_valid:
		correct_moves += 1
		swap_counter += 1
		timeline_log.append("[color=green]✓ Good move: %s[/color]" % validation_message)
		show_feedback(validation_message, Color.GREEN, Vector2(dropped_block.global_position.x, START_POSITION.y - 20))
	else:
		mistake_counter += 1
		timeline_log.append("[color=red]✗ Bad move: %s[/color]" % validation_message)
		show_feedback(validation_message, Color.RED, Vector2(dropped_block.global_position.x, START_POSITION.y - 20))
	
	comparison_counter += 1
	
	_resnap_blocks()
	_update_current_highlight()
	_update_ui_labels()
	_update_timeline_display()
	_update_undo_redo_buttons()
	
	if _check_if_sorted() and not has_completed_assessment:
		_end_assessment("sorted")

# ==============================================
#   UNDO / REDO
# ==============================================
func _save_undo_state() -> void:
	var state := {
		"array": main_array.duplicate(),
		"sort_i": sort_i,
		"sort_j": sort_j,
		"mistakes": mistake_counter,
		"correct_moves": correct_moves,
		"comparisons": comparison_counter,
		"swaps": swap_counter,
		"timeline": timeline_log.duplicate()
	}
	undo_stack.append(state)

func _on_undo_pressed() -> void:
	if not _can_undo() or undo_stack.is_empty():
		return
	
	btn_sound.play()
	
	redo_stack.append({
		"array": main_array.duplicate(),
		"sort_i": sort_i,
		"sort_j": sort_j,
		"mistakes": mistake_counter,
		"correct_moves": correct_moves,
		"comparisons": comparison_counter,
		"swaps": swap_counter,
		"timeline": timeline_log.duplicate()
	})
	
	var state = undo_stack.pop_back()
	_restore_state(state)
	
	if not move_history.is_empty():
		var last_move = move_history.pop_back()
		move_redo_stack.append(last_move)
		if last_move["was_valid"]:
			correct_moves -= 1
			swap_counter -= 1
		else:
			mistake_counter -= 1
		comparison_counter -= 1
	
	timeline_log.append("[color=gray]↩ Undo[/color]")
	_update_timeline_display()
	_update_undo_redo_buttons()
	_update_ui_labels()
	_update_current_highlight()

func _on_redo_pressed() -> void:
	if not _can_redo() or redo_stack.is_empty():
		return
	
	btn_sound.play()
	
	undo_stack.append({
		"array": main_array.duplicate(),
		"sort_i": sort_i,
		"sort_j": sort_j,
		"mistakes": mistake_counter,
		"correct_moves": correct_moves,
		"comparisons": comparison_counter,
		"swaps": swap_counter,
		"timeline": timeline_log.duplicate()
	})
	
	var state = redo_stack.pop_back()
	_restore_state(state)
	
	if not move_redo_stack.is_empty():
		var move = move_redo_stack.pop_back()
		move_history.append(move)
		if move["was_valid"]:
			correct_moves += 1
			swap_counter += 1
		else:
			mistake_counter += 1
		comparison_counter += 1
	
	timeline_log.append("[color=gray]↪ Redo[/color]")
	_update_timeline_display()
	_update_undo_redo_buttons()
	_update_ui_labels()
	_update_current_highlight()

func _restore_state(state: Dictionary) -> void:
	main_array = state["array"].duplicate()
	sort_i = state["sort_i"]
	sort_j = state["sort_j"]
	mistake_counter = state["mistakes"]
	correct_moves = state.get("correct_moves", 0)
	comparison_counter = state["comparisons"]
	swap_counter = state.get("swaps", 0)
	timeline_log = state.get("timeline", timeline_log).duplicate()
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

func _can_undo() -> bool:
	if sorting_complete or has_completed_assessment:
		return false
	if difficulty == 3:
		return false
	return not undo_stack.is_empty()

func _can_redo() -> bool:
	if sorting_complete or has_completed_assessment:
		return false
	if difficulty == 3:
		return false
	return not redo_stack.is_empty()

func _update_undo_redo_buttons() -> void:
	if not undo_btn or not redo_btn:
		return
	undo_btn.disabled = not _can_undo()
	redo_btn.disabled = not _can_redo()
	undo_btn.modulate = Color(0.5, 0.5, 0.5, 0.5) if undo_btn.disabled else Color(1, 1, 1, 1)
	redo_btn.modulate = Color(0.5, 0.5, 0.5, 0.5) if redo_btn.disabled else Color(1, 1, 1, 1)

# ==============================================
#   TIMELINE
# ==============================================
func _on_timeline_pressed() -> void:
	btn_sound.play()
	if timeline_popup.visible:
		timeline_popup.hide()
	else:
		var timeline_content = "\n".join(timeline_log) if not timeline_log.is_empty() else "[center]No moves yet[/center]"
		if timeline_label:
			timeline_label.bbcode_enabled = true
			timeline_label.text = timeline_content
		timeline_popup.popup_centered()

func _on_timeline_close_pressed() -> void:
	btn_sound.play()
	if timeline_popup:
		timeline_popup.hide()

func _update_timeline_display() -> void:
	if not timeline_label:
		return
	timeline_label.bbcode_enabled = true
	if timeline_log.is_empty():
		timeline_label.text = "[center]No actions yet[/center]"
	else:
		timeline_label.text = "\n".join(timeline_log)

# ==============================================
#   ASSESSMENT END & GRADING
# ==============================================
func _end_assessment(reason: String) -> void:
	if has_completed_assessment:
		return
	
	has_completed_assessment = true
	completion_type = reason
	
	if current_tween:
		current_tween.kill()
		current_tween = null
	if highlight_tween:
		highlight_tween.kill()
		highlight_tween = null
	
	timer_running = false
	tiktak_sound.stop()
	is_sorting = true
	is_auto_playing = false
	
	if undo_btn: undo_btn.disabled = true
	if redo_btn: redo_btn.disabled = true
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	
	timeline_log.append("[color=orange]--- Assessment Ended: %s ---[/color]" % reason.to_upper())
	_update_timeline_display()
	
	DB.record_attempt(CURRENT_TOPIC, difficulty)
	
	if reason == "timeout":
		_show_result_popup("FAIL", {})
		if time_up_popup:
			time_up_popup.popup_centered()
	else:
		var grade = _compute_grade()
		var result = "PASS" if grade["passed"] else "FAIL"
		if grade["passed"]:
			coins_earned = DB.complete_level(CURRENT_TOPIC, difficulty)
			grade["coins"] = coins_earned
		_show_result_popup(result, grade)

func _compute_grade() -> Dictionary:
	var total_moves = correct_moves + mistake_counter
	var accuracy = float(correct_moves) / max(total_moves, 1) * 100.0
	var threshold = _get_required_threshold() * 100.0
	var passed = accuracy >= threshold
	var time_used = assessment_time_limit - time_remaining if assessment_time_limit > 0 else 0.0
	
	return {
		"passed": passed,
		"accuracy": accuracy,
		"total_moves": total_moves,
		"correct_moves": correct_moves,
		"mistake_counter": mistake_counter,
		"time_used": time_used,
		"coins": 0,
		"required": threshold
	}

func _show_result_popup(result: String, grade: Dictionary = {}) -> void:
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
		if try_again_btn_root: try_again_btn_root.visible = false
	else:
		result_title.text = "FAILED!"
		result_title.modulate = Color(1, 0, 0)
		if translate_code_btn: translate_code_btn.hide()
		if cpp_code_button: cpp_code_button.hide()
		if try_again_btn_root: try_again_btn_root.visible = true
	
	if completion_type == "timeout":
		score_summary.text = "Time's Up! Assessment Failed."
		accuracy_label.text = "Accuracy: 0%"
		time_used_label.text = "Time: Expired"
		coins_label.text = "+0"
	else:
		var total_seconds = int(grade.get("time_used", 0))
		var minutes = total_seconds / 60
		var seconds = total_seconds % 60
		score_summary.text = "Correct: %d | Mistakes: %d" % [grade.get("correct_moves", 0), grade.get("mistake_counter", 0)]
		accuracy_label.text = "Accuracy: %.1f%% (Need %.0f%%)" % [grade.get("accuracy", 0), grade.get("required", 0)]
		time_used_label.text = "Time Used: %02d:%02d" % [minutes, seconds]
		coins_label.text = "+%d" % grade.get("coins", 0)
	
	result_popup.popup_centered()
	if grade.get("coins", 0) > 0 and coins_anim:
		coins_anim.play("default")

func _on_try_again_result_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	if time_up_popup and time_up_popup.visible:
		time_up_popup.hide()
	_start_assessment_mode()
	call_deferred("show_introduction")

func _on_back_result_pressed() -> void:
	btn_sound.play()
	result_popup.hide()

func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()

func _on_try_again_root_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	if time_up_popup and time_up_popup.visible:
		time_up_popup.hide()
	_start_assessment_mode()
	call_deferred("show_introduction")

func _on_time_up_try_again_pressed() -> void:
	btn_sound.play()
	if time_up_popup: time_up_popup.hide()
	result_popup.hide()
	_start_assessment_mode()
	call_deferred("show_introduction")

func _on_time_up_back_pressed() -> void:
	btn_sound.play()
	if time_up_popup: time_up_popup.hide()

# ==============================================
#   INTRO POPUP
# ==============================================
func show_introduction() -> void:
	if not intro_popup:
		return
	tutorial_overlay.show()
	if dim_bg:
		dim_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	intro_popup.show()
	intro_popup.mouse_filter = Control.MOUSE_FILTER_STOP
	timer_running = false
	intro_step = 0
	_update_intro_text()
	_ensure_connected(intro_prev_btn, "pressed", _on_intro_prev_pressed)
	_ensure_connected(intro_next_btn, "pressed", _on_intro_next_pressed)
	_ensure_connected(intro_skip_btn, "pressed", _on_intro_skip_pressed)

func _update_intro_text() -> void:
	if intro_label:
		intro_label.text = intro_texts[intro_step]
	if intro_prev_btn:
		intro_prev_btn.visible = (intro_step > 0)
	if intro_next_btn:
		intro_next_btn.text = "Finish" if intro_step >= intro_texts.size() - 1 else "Next"

func _on_intro_next_pressed() -> void:
	btn_sound.play()
	if intro_step < intro_texts.size() - 1:
		intro_step += 1
		_update_intro_text()
	else:
		intro_popup.hide()
		tutorial_overlay.hide()
		if difficulty != 1:
			timer_running = true
			clock.play()

func _on_intro_prev_pressed() -> void:
	btn_sound.play()
	if intro_step > 0:
		intro_step -= 1
		_update_intro_text()

func _on_intro_skip_pressed() -> void:
	btn_sound.play()
	intro_popup.hide()
	tutorial_overlay.hide()
	if difficulty != 1:
		timer_running = true
		clock.play()

# ==============================================
#   TUTORIAL (HELP BUTTON)
# ==============================================
func _on_help_button_pressed() -> void:
	btn_sound.play()
	_start_tutorial()

func _start_tutorial() -> void:
	if not tutorial_overlay or not tutorial_box or not tutorial_text or not tutorial_next:
		return
	
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	timer_running = false
	tutorial_overlay.show()
	if dim_bg:
		dim_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tutorial_box.show()
	
	tutorial_sequence = [
		{"node": undo_btn, "title": "UNDO", "text": "Reverts your last swap.\nAvailable on Easy & Medium only."},
		{"node": redo_btn, "title": "REDO", "text": "Reapplies an undone swap.\nAvailable on Easy & Medium only."},
		{"node": timeline_btn, "title": "TIMELINE", "text": "View a scrollable history of all your swaps."}
	]
	_show_tutorial_step()

func _show_tutorial_step() -> void:
	if tutorial_sequence_index >= tutorial_sequence.size():
		_end_tutorial()
		return
		
	var step = tutorial_sequence[tutorial_sequence_index]
	if tutorial_text:
		tutorial_text.text = step["title"] + "\n\n" + step["text"]
	
	tutorial_box.visible = true
	tutorial_text.visible = true
	tutorial_next.visible = true
	
	var node = step["node"]
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

func _on_next_button_pressed() -> void:
	btn_sound.play()
	tutorial_sequence_index += 1
	_show_tutorial_step()

func _end_tutorial() -> void:
	tutorial_in_progress = false
	tutorial_overlay.hide()
	if pointer_sprite:
		pointer_sprite.hide()
		if pointer_sprite.has_meta("tween"):
			pointer_sprite.get_meta("tween").kill()
	if difficulty != 1:
		timer_running = true

# ==============================================
#   CODE POPUP & WALKTHROUGH
# ==============================================
func _show_cpp_popup() -> void:
	var arr_str = ", ".join(initial_array.map(func(x): return str(x)))
	var code = _get_code_for_language(current_code_language, arr_str)
	
	match current_code_language:
		"cpp": current_tutorial_data = cpp_tutorial_data
		"python": current_tutorial_data = python_tutorial_data
		"java": current_tutorial_data = java_tutorial_data
		"c": current_tutorial_data = c_tutorial_data
	
	if cpp_text:
		cpp_text.text = code
	
	cpp_tutorial_step = 0
	
	if cpp_next_btn:
		if cpp_next_btn.is_connected("pressed", _on_cpp_next_pressed):
			cpp_next_btn.disconnect("pressed", _on_cpp_next_pressed)
		cpp_next_btn.pressed.connect(_on_cpp_next_pressed)
		cpp_next_btn.disabled = false
	
	if cpp_tutorial_panel:
		cpp_tutorial_panel.show()
	
	cpp_popup.popup_centered()
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
		cpp_explanation_lbl.bbcode_enabled = true
		cpp_explanation_lbl.text = data["text"]
	
	if cpp_text:
		var arr_str = ", ".join(initial_array.map(func(x): return str(x)))
		var base_code = _get_code_for_language(current_code_language, arr_str)
		var lines = base_code.split("\n")
		for line_idx in data["lines"]:
			if line_idx >= 0 and line_idx < lines.size():
				lines[line_idx] = "[bgcolor=#444400][color=yellow]" + lines[line_idx] + "[/color][/bgcolor]"
		cpp_text.bbcode_enabled = true
		cpp_text.text = "\n".join(lines)
		if data["lines"].size() > 0:
			var target_line = data["lines"][0]
			await get_tree().process_frame
			cpp_text.scroll_to_line(target_line)

func _on_cpp_close_pressed() -> void:
	btn_sound.play()
	if cpp_popup: cpp_popup.hide()

func _on_cpp_code_button_pressed() -> void:
	btn_sound.play()
	_show_cpp_popup()

func _on_complete_ok_pressed() -> void:
	btn_sound.play()
	if complete_popup: complete_popup.hide()

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	if complete_popup: complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

func _connect_language_buttons() -> void:
	if cpp_lang_btn:
		if not cpp_lang_btn.is_connected("pressed", _on_cpp_lang_pressed):
			cpp_lang_btn.pressed.connect(_on_cpp_lang_pressed)
	if python_lang_btn:
		if not python_lang_btn.is_connected("pressed", _on_python_lang_pressed):
			python_lang_btn.pressed.connect(_on_python_lang_pressed)
	if java_lang_btn:
		if not java_lang_btn.is_connected("pressed", _on_java_lang_pressed):
			java_lang_btn.pressed.connect(_on_java_lang_pressed)
	if c_lang_btn:
		if not c_lang_btn.is_connected("pressed", _on_c_lang_pressed):
			c_lang_btn.pressed.connect(_on_c_lang_pressed)

func _on_cpp_lang_pressed() -> void: btn_sound.play(); current_code_language = "cpp"; _show_cpp_popup()
func _on_python_lang_pressed() -> void: btn_sound.play(); current_code_language = "python"; _show_cpp_popup()
func _on_java_lang_pressed() -> void: btn_sound.play(); current_code_language = "java"; _show_cpp_popup()
func _on_c_lang_pressed() -> void: btn_sound.play(); current_code_language = "c"; _show_cpp_popup()

# ==============================================
#   UTILITY FUNCTIONS
# ==============================================
func show_feedback(text: String, color: Color, position: Vector2) -> void:
	var feedback_scene = preload("res://scene/FeedbackLabel.tscn")
	var label = feedback_scene.instantiate()
	label.text = text
	label.modulate = color
	label.global_position = position
	add_child(label)
	var anim_player: AnimationPlayer = label.get_node("AnimationPlayer")
	anim_player.play("notification_pop")
	anim_player.animation_finished.connect(func(_anim_name): label.queue_free())

# ==============================================
#   CONFIGURATION MODALS
# ==============================================
func _on_simulate_new_pressed() -> void:
	sim_confirmation.show()

func _on_yes_pressed() -> void:
	btn_sound.play()
	sim_confirmation.hide()
	sim_success.show()
	await get_tree().create_timer(1.0).timeout
	sim_success.hide()
	reset_cache_for_scene()
	_show_config_modal()

func _on_no_pressed() -> void:
	btn_sound.play()
	sim_confirmation.hide()

func _show_config_modal() -> void:
	config_modal.show()
	_set_main_ui_enabled(false)
	_connect_configuration_buttons()

func _set_main_ui_enabled(enabled: bool) -> void:
	if undo_btn: undo_btn.disabled = not enabled
	if redo_btn: redo_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled

func _connect_configuration_buttons() -> void:
	_ensure_connected(yes_btn, "pressed", _on_config_yes_pressed)
	_ensure_connected(no_btn, "pressed", _on_config_no_pressed)
	_ensure_connected(size_back_btn, "pressed", _on_size_back_pressed)
	_ensure_connected(size_next_btn, "pressed", _on_size_next_pressed)
	_ensure_connected(elements_back_btn, "pressed", _on_elements_back_pressed)
	_ensure_connected(elements_done_btn, "pressed", _on_elements_done_pressed)

func _on_config_yes_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	_show_config_size_modal()

func _on_config_no_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	var count = randi_range(5, 7)
	var arr: Array[int] = []
	for i in range(count):
		arr.append(randi_range(1, 99))
	_set_main_ui_enabled(true)
	help_btn.show()
	_initialize_with_elements(arr)

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

func _on_size_back_pressed() -> void:
	btn_sound.play()
	config_size_modal.hide()
	config_modal.show()

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

func _on_elements_back_pressed() -> void:
	btn_sound.play()
	config_elements_modal.hide()
	config_size_modal.show()

# ==============================================
#   CODE GENERATION FUNCTIONS
# ==============================================
func get_cpp_bubble_code(arr: String) -> String:
	return """/* Bubble Sort - Time Complexity: O(n^2), Space Complexity: O(1) */
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

void bubbleSort(int arr[], int n) {
	for (int i = 0; i < n - 1; i++) {
		for (int j = 0; j < n - i - 1; j++) {
			if (arr[j] > arr[j + 1]) {
				int temp = arr[j];
				arr[j] = arr[j + 1];
				arr[j + 1] = temp;
				cout << "After swapping indices " << j << " and " << j + 1 << ": ";
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
	
	bubbleSort(arr, n);
	
	cout << endl << "Sorted array: ";
	printArray(arr, n);
	
	return 0;
}""" % arr

func get_python_bubble_code(arr: String) -> String:
	return """# Bubble Sort - Time Complexity: O(n^2), Space Complexity: O(1)

def print_array(arr):
	print("[", end="")
	for i in range(len(arr)):
		print(arr[i], end="")
		if i < len(arr) - 1:
			print(", ", end="")
	print("]")

def bubble_sort(arr):
	n = len(arr)
	for i in range(n - 1):
		for j in range(0, n - i - 1):
			if arr[j] > arr[j + 1]:
				arr[j], arr[j + 1] = arr[j + 1], arr[j]
				print(f"After swapping indices {j} and {j + 1}: ", end="")
				print_array(arr)

arr = [%s]
print("Initial array: ", end="")
print_array(arr)
print()

bubble_sort(arr)

print()
print("Sorted array: ", end="")
print_array(arr)""" % arr

func get_java_bubble_code(arr: String) -> String:
	return """/* Bubble Sort - Time Complexity: O(n^2) */
public class Main {
	static void printArray(int arr[]) {
		System.out.print("[");
		for (int i = 0; i < arr.length; i++) {
			System.out.print(arr[i]);
			if (i < arr.length - 1) System.out.print(", ");
		}
		System.out.println("]");
	}
	
	static void bubbleSort(int arr[]) {
		int n = arr.length;
		for (int i = 0; i < n - 1; i++) {
			for (int j = 0; j < n - i - 1; j++) {
				if (arr[j] > arr[j + 1]) {
					int temp = arr[j];
					arr[j] = arr[j + 1];
					arr[j + 1] = temp;
					System.out.print("After swapping indices " + j + " and " + (j + 1) + ": ");
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
		
		bubbleSort(arr);
		
		System.out.println();
		System.out.print("Sorted array: ");
		printArray(arr);
	}
}""" % arr

func get_c_bubble_code(arr: String) -> String:
	return """/* Bubble Sort - Time Complexity: O(n^2) */
#include <stdio.h>

void printArray(int arr[], int n) {
	printf("[");
	for (int i = 0; i < n; i++) {
		printf("%%d", arr[i]);
		if (i < n - 1) printf(", ");
	}
	printf("]\\n");
}

void bubbleSort(int arr[], int n) {
	int i, j, temp;
	for (i = 0; i < n - 1; i++) {
		for (j = 0; j < n - i - 1; j++) {
			if (arr[j] > arr[j + 1]) {
				temp = arr[j];
				arr[j] = arr[j + 1];
				arr[j + 1] = temp;
				printf("After swapping indices %%d and %%d: ", j, j + 1);
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
	
	bubbleSort(arr, n);
	
	printf("\\nSorted array: ");
	printArray(arr, n);
	
	return 0;
}""" % arr
