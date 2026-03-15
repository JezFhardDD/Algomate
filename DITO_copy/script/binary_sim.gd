extends Control

# =======================================================
#   BINARY SEARCH - (Manual Popup Trigger + Green UI)
# =======================================================

# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton          
@onready var auto_btn: Button = $VBoxContainer/LinearStep          
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew
@onready var auto_search_btn: Button = get_node_or_null("VBoxContainer/AutoSearchButton")

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var compare_label: Label = $HBoxContainer2/Label
@onready var array_container: Control = $QueueContainer
@onready var dequeued_container: Control = $DequeuedContainer 

# --- POPUPS ---
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label

# --- TIMELINE POPUP ---
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: Label = $TimelinePopup/MainVBox/ScrollContainer/VBoxContainer/Label
@onready var timeline_close_btn: Button = get_node_or_null("TimelinePopup/MainVBox/CloseButton")

# Queue Full Warning
@onready var Queue_full: Panel = get_node_or_null("Queue_full")
@onready var anim_sprite: AnimatedSprite2D = get_node_or_null("Queue_full/AnimatedSprite2D")

# Simulation Complete popup
@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var process_label: Label = get_node_or_null("SimulationCompletePopup/VBoxContainer/ProcessLabel")

# --- C++ POPUP NODES ---
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_scroll: ScrollContainer = get_node_or_null("CppPopup/VBoxContainer/CodeScroll")
@onready var cpp_label: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/CodeScroll/CodeLabel")
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/close") as Button

# Code Walkthrough Nodes
@onready var cpp_next_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CppNextButton")
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_lbl: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")

# --- COMPILER INTEGRATION ---
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CompileButton")

# Top Right Button
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")
@onready var code_anim: AnimatedSprite2D = get_node_or_null("CppCodeButton/code_anim")

# --- SCENE RESOURCES ---
const BLOCK_SCENE := preload("res://BubbleBlock.tscn")
const POINTER_TEX := preload("res://assets/point_left.png")
const RESULT_POPUP_SCENE := preload("res://scene/ResultPopup.tscn")

# --- POINTERS ---
@onready var ptr_low: Node = $TextureRect/Low   
@onready var ptr_high: Node = $TextureRect/High   
@onready var ptr_mid: Node = $TextureRect/front2  
@onready var unused_ptr2: Node = get_node_or_null("TextureRect/rear2")

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
@onready var q_mark_sprite: AnimatedSprite2D = $HelpButton/Q_mark_anim_sprites

# --- LANGUAGE BUTTONS ---
@onready var cpp_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Cpp_btn
@onready var python_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Py_btn
@onready var java_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Java_btn
@onready var c_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/C_btn

# ==============================================
#   COMPILER INTEGRATION - API KEYS
# ==============================================
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

# --- BINARY SEARCH VARIABLES ---
var main_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []

var search_target: int = 0
var low_idx: int = 0
var high_idx: int = 0
var mid_idx: int = 0
var search_found: bool = false

var comparison_counter: int = 0
var sorting_complete: bool = false
var is_sorting: bool = false
var is_auto_playing: bool = false

# Code generation variables
var code_lines: Array[String] = []
var current_code_language: String = "cpp"

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

var BLOCK_WIDTH: float = 64.0 
var BLOCK_SPACING: float = 15.0
var START_POSITION: Vector2 = Vector2(50, 80)
var ANIM_SPEED: float = 2.0 

# --- DIALOGS ---
var target_input_dialog: ConfirmationDialog
var target_spinbox: SpinBox
var sort_info_popup: AcceptDialog

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

var intro_step: int = 0
var intro_texts = [
	"Welcome to Binary Search!\nBinary Search is a 'Divide and Conquer' algorithm. It is much faster than Linear Search but requires the list to be SORTED.",
	"The Algorithm:\n\n1. Find the Middle Element.\n2. Is Middle > Target? Discard the Right half.\n3. Is Middle < Target? Discard the Left half.\n4. Repeat until found.",
	"Visual Elements:\n\n• Low Pointer (Start)\n• High Pointer (End)\n• Mid Pointer (Current Check)",
	"How to Use:\n\n1. Click 'FIND ELEMENT' to set target.\n2. Click 'BINARY STEP' to divide and conquer."
]


var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var cpp_tutorial_data = [
	{ "lines": [0, 1, 2], "text": "1. Setup:\nInitialize 'low' to 0 and 'high' to array length - 1." },
	{ "lines": [4, 5], "text": "2. The Loop:\nWhile low is less than or equal to high..." },
	{ "lines": [6, 7], "text": "3. Calculate Mid:\nmid = low + (high - low) / 2." },
	{ "lines": [8, 9, 10], "text": "4. Check Match:\nIf arr[mid] == target, return index 'mid'. Found!" },
	{ "lines": [11, 12, 13], "text": "5. Ignore Left Half:\nIf arr[mid] < target, element must be in right half. low = mid + 1." },
	{ "lines": [14, 15, 16], "text": "6. Ignore Right Half:\nIf arr[mid] > target, element must be in left half. high = mid - 1." }
]

# ==============================================
#   READY
# ==============================================
func _ready() -> void:
	print("Program started — initializing Binary Search...")
	randomize()
	
	# Setup result popup
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
	
	# Connect result buttons
	try_again_result_btn.pressed.connect(_on_try_again_pressed)
	back_result_btn.pressed.connect(_on_back_pressed)
	translate_code_btn.pressed.connect(_on_translate_code_pressed)
	
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	# Initial pointer visibility
	if ptr_low: ptr_low.hide()
	if ptr_high: ptr_high.hide()
	if ptr_mid: ptr_mid.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	if cpp_code_button: cpp_code_button.hide()
	
	if sort_btn: sort_btn.text = "Find Element"
	if auto_btn: auto_btn.text = "Binary Step"
	
	if auto_search_btn:
		auto_search_btn.text = "Auto Search"
		_ensure_connected(auto_search_btn, "pressed", _on_auto_search_pressed)
	
	_setup_pointer_labels()
	
	_create_target_input_dialog()
	_create_sort_info_popup() 
	
	_connect_configuration_buttons()
	
	# Setup compiler
	_setup_compiler()
	
	_show_config_modal() 
	
	call_deferred("show_introduction")
	
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")
	
	_connect_language_buttons()

# ==============================================
#   COMPILER SETUP FUNCTIONS
# ==============================================
func _setup_compiler() -> void:
	"""Setup compiler button and popup"""
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
	
	var code = _generate_code_for_language(current_code_language)
	
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
	
	print("=== Binary Search Compile Request ===")
	print("Language: ", current_code_language, " → API: ", api_language)
	print("Script preview: ", code.substr(0, 50) + "...")
	
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
	var code = _generate_code_for_language(language)
	_compile_code(code)


func _on_compiler_output_closed() -> void:
	print("Compiler output closed")


func reset_cache_for_scene() -> void:
	if compiler_output_popup:
		compiler_output_popup.reset_cache_for_scene()
		print("Compiler cache reset for new simulation")

func _setup_pointer_labels():
	_set_node_label_text(ptr_low, "Low")
	_set_node_label_text(ptr_high, "High")
	_hide_node_label(ptr_mid)

func _set_node_label_text(node: Node, text: String):
	if node:
		var children = node.get_children()
		for c in children:
			if c is Label:
				c.text = text
				c.visible = true

func _hide_node_label(node: Node):
	if node:
		var children = node.get_children()
		for c in children:
			if c is Label:
				c.visible = false 

func _on_auto_search_pressed() -> void:
	if sorting_complete: return
	btn_sound.play()
	is_auto_playing = !is_auto_playing
	
	if auto_search_btn:
		auto_search_btn.text = "Pause" if is_auto_playing else "Auto Search"
	if auto_btn:
		auto_btn.disabled = is_auto_playing
		
	if is_auto_playing:
		_run_auto_sort()

func _run_auto_sort() -> void:
	while is_auto_playing and not sorting_complete:
		if is_sorting: await get_tree().process_frame 
		else:
			await _perform_sort_step()
			await get_tree().create_timer(ANIM_SPEED).timeout

# --- POPUP CREATION ---
func _create_target_input_dialog():
	target_input_dialog = ConfirmationDialog.new()
	target_input_dialog.title = "Find Element"
	target_input_dialog.min_size = Vector2(300, 150)
	var vbox = VBoxContainer.new()
	target_input_dialog.add_child(vbox)
	var lbl = Label.new()
	lbl.text = "Enter value to search:"
	vbox.add_child(lbl)
	target_spinbox = SpinBox.new()
	target_spinbox.min_value = 0
	target_spinbox.max_value = 100
	target_spinbox.value = 0
	target_spinbox.custom_minimum_size = Vector2(0, 40)
	vbox.add_child(target_spinbox)
	add_child(target_input_dialog)
	target_input_dialog.confirmed.connect(_on_target_confirmed)

# --- GREEN SORTING POPUP ---
func _create_sort_info_popup():
	sort_info_popup = AcceptDialog.new()
	sort_info_popup.title = "Sorting Required"
	sort_info_popup.dialog_text = "Binary Search requires a sorted array.\n\nClick OK to perform Bubble Sort..."
	sort_info_popup.min_size = Vector2(350, 150)
	
	# Apply Green Style
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.5, 0.2, 1.0) # Green background
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.0, 0.3, 0.1)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_right = 8
	style.corner_radius_bottom_left = 8
	
	# We apply this style to the internal panel
	sort_info_popup.add_theme_stylebox_override("panel", style)
	
	add_child(sort_info_popup)
	# Connect the OK button signal
	sort_info_popup.confirmed.connect(_on_sort_confirmed)

# --- TRIGGERED WHEN USER CLICKS OK ---
func _on_sort_confirmed():
	status_label.text = "Sorting Data..."
	_run_visual_bubble_sort()

func _on_target_confirmed():
	btn_sound.play()
	var new_target = int(target_spinbox.value)
	_reset_search_for_new_target(new_target)

func _reset_search_for_new_target(new_val: int):
	search_target = new_val
	status_label.text = "Target to Find: %d" % search_target
	timeline_log.clear()
	timeline_log.append("New Search. Target: %d" % search_target)
	_add_code_line("TARGET", 0, search_target)
	
	low_idx = 0
	high_idx = main_array.size() - 1
	mid_idx = 0
	
	search_found = false
	comparison_counter = 0
	sorting_complete = false
	is_auto_playing = false
	
	if auto_btn: auto_btn.disabled = false
	if sort_btn: sort_btn.disabled = false
	if auto_search_btn: 
		auto_search_btn.disabled = false
		auto_search_btn.text = "Auto Search"
	
	_update_pointers()
	
	for block in block_nodes:
		if block.has_method("set_highlight"): block.set_highlight(false)
		if block.has_method("reset_visuals"): block.reset_visuals()
		block.modulate = Color(1, 1, 1, 1)
		
	_update_ui_labels()

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
#   INITIALIZATION WITH VISUAL SORT
# ==============================================

func _initialize_with_elements(elements: Array[int]) -> void:
	# Reset cache for new simulation
	reset_cache_for_scene()
	
	# Clear code lines
	code_lines.clear()
	
	print("Initializing Array with:", elements)
	audio_player.play()
	
	main_array = elements.duplicate()
	# DO NOT SORT HERE - We will wait for popup
	
	block_nodes.clear()
	timeline_log.clear()
	code_lines.clear()
	
	# Add initial code line
	_add_code_line("INITIAL", 0, 0)
	
	_set_main_ui_enabled(false)
	status_label.text = "Waiting for Sort..."
	
	for child in array_container.get_children():
		child.queue_free()
	
	var current_x = START_POSITION.x
	for val in main_array:
		var new_block = BLOCK_SCENE.instantiate()
		new_block.value = val
		new_block.position = Vector2(current_x, START_POSITION.y)
		new_block.modulate.a = 0.0 
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(new_block, "modulate:a", 1.0, 0.5)
		array_container.add_child(new_block)
		block_nodes.append(new_block)
		current_x += new_block.size.x + BLOCK_SPACING
	
	_ensure_connected(sort_btn, "pressed", _on_step_pressed)
	_ensure_connected(auto_btn, "pressed", _on_auto_pressed)
	_ensure_connected(timeline_btn, "pressed", _on_timeline_pressed)
	_ensure_connected(simulate_new_btn, "pressed", _on_simulate_new_pressed)
	_ensure_connected(complete_ok_btn, "pressed", _on_complete_ok_pressed)
	_ensure_connected(show_cpp_btn, "pressed", _on_show_cpp_pressed)
	_ensure_connected(cpp_code_button, "pressed", _on_cpp_code_button_pressed)
	_ensure_connected(cpp_close_btn, "pressed", _on_cpp_close_pressed)
	
	if timeline_close_btn:
		if not timeline_close_btn.is_connected("pressed", _on_timeline_close_pressed):
			timeline_close_btn.pressed.connect(_on_timeline_close_pressed)

	if cpp_code_button: cpp_code_button.hide()
	
	# --- SHOW POPUP AND WAIT FOR OK ---
	sort_info_popup.popup_centered()
	# Code stops here conceptually until user clicks OK

# --- VISUAL BUBBLE SORT (SLOWER) ---
func _run_visual_bubble_sort():
	var n = block_nodes.size()
	
	for i in range(n - 1):
		for j in range(n - i - 1):
			
			# Highlight comparison
			block_nodes[j].modulate = Color(1, 1, 0, 1) # Yellow
			block_nodes[j+1].modulate = Color(1, 1, 0, 1)
			
			await get_tree().create_timer(1.0).timeout # Slower comparison
			
			# If needed, swap
			if block_nodes[j].value > block_nodes[j+1].value:
				
				# Visual Swap (Tween Positions)
				var nodeA = block_nodes[j]
				var nodeB = block_nodes[j+1]
				var posA = nodeA.position
				var posB = nodeB.position
				
				var tw = create_tween().set_parallel(true)
				tw.tween_property(nodeA, "position", posB, 1.0) # Slower movement
				tw.tween_property(nodeB, "position", posA, 1.0)
				await tw.finished
				
				# Data Swap
				var temp_val = main_array[j]
				main_array[j] = main_array[j+1]
				main_array[j+1] = temp_val
				
				var temp_node = block_nodes[j]
				block_nodes[j] = block_nodes[j+1]
				block_nodes[j+1] = temp_node
				
				_add_code_line("SWAP", j, main_array[j])
			
			# Reset Colors
			block_nodes[j].modulate = Color(1, 1, 1, 1)
			block_nodes[j+1].modulate = Color(1, 1, 1, 1)
	
	# --- SORTING DONE ---
	search_target = 0
	status_label.text = "Sorted! Click 'Find Element' to start."
	_set_main_ui_enabled(true)
	_update_ui_labels()

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

func _on_step_pressed() -> void:
	btn_sound.play()
	target_input_dialog.popup_centered()

func _on_auto_pressed() -> void:
	if is_sorting or sorting_complete or is_auto_playing: return
	if tutorial_in_progress: _handle_tutorial_step()
	btn_sound.play()
	_perform_sort_step()

func _perform_sort_step():
	is_sorting = true
	
	if low_idx > high_idx:
		status_label.text = "Finished. Target NOT found."
		timeline_log.append("Low > High. Target %d missing." % search_target)
		_add_code_line("NOT_FOUND", 0, search_target)
		_finish_simulation()
		is_sorting = false
		return
	
	mid_idx = low_idx + (high_idx - low_idx) / 2
	
	_update_pointers()
	_highlight_range()
	
	comparison_counter += 1
	var val = main_array[mid_idx]
	status_label.text = "Mid is index %d (Val: %d). Comparing..." % [mid_idx, val]
	timeline_log.append("Low:%d High:%d Mid:%d (Val:%d)" % [low_idx, high_idx, mid_idx, val])
	_add_code_line("COMPARE", mid_idx, val)
	
	await get_tree().create_timer(ANIM_SPEED * 0.8).timeout
	
	if val == search_target:
		search_found = true
		status_label.text = "FOUND %d at index %d!" % [val, mid_idx]
		timeline_log.append(" -> MATCH FOUND!")
		_add_code_line("FOUND", mid_idx, val)
		if block_nodes[mid_idx].has_method("set_sorted_visual"):
			block_nodes[mid_idx].set_sorted_visual()
		_finish_simulation()
	elif val < search_target:
		status_label.text = "%d < %d. Ignore Left Half." % [val, search_target]
		_add_code_line("MOVE_RIGHT", mid_idx, val)
		low_idx = mid_idx + 1
	else:
		status_label.text = "%d > %d. Ignore Right Half." % [val, search_target]
		_add_code_line("MOVE_LEFT", mid_idx, val)
		high_idx = mid_idx - 1
	
	_update_ui_labels()
	is_sorting = false

func _update_pointers():
	if block_nodes.is_empty(): return
	
	if low_idx >= 0 and low_idx < block_nodes.size():
		if ptr_low:
			ptr_low.show()
			var n = block_nodes[low_idx]
			ptr_low.global_position = n.global_position + Vector2(0, n.size.y + 10)
	elif ptr_low:
		ptr_low.hide()
		
	if high_idx >= 0 and high_idx < block_nodes.size():
		if ptr_high:
			ptr_high.show()
			var n = block_nodes[high_idx]
			
			if high_idx == low_idx:
				ptr_high.global_position = n.global_position + Vector2(20, -50)
			else:
				ptr_high.global_position = n.global_position + Vector2(20, n.size.y + 10)
	elif ptr_high:
		ptr_high.hide()
		
	if mid_idx >= 0 and mid_idx < block_nodes.size():
		if ptr_mid:
			ptr_mid.show()
			var n = block_nodes[mid_idx]
			if high_idx == low_idx and mid_idx == high_idx:
				ptr_mid.global_position = n.global_position + Vector2(-10, -50)
			else:
				ptr_mid.global_position = n.global_position + Vector2(16, -50) 
	elif ptr_mid:
		ptr_mid.hide()

func _highlight_range():
	for i in range(block_nodes.size()):
		if i < low_idx or i > high_idx:
			block_nodes[i].modulate = Color(0.3, 0.3, 0.3, 1)
		else:
			block_nodes[i].modulate = Color(1, 1, 1, 1)
			
	if mid_idx >= 0 and mid_idx < block_nodes.size():
		block_nodes[mid_idx].modulate = Color(1, 1, 0, 1)

func _finish_simulation():
	sorting_complete = true
	is_auto_playing = false
	
	if auto_btn: auto_btn.disabled = true
	if sort_btn: sort_btn.disabled = true
	if auto_search_btn: 
		auto_search_btn.text = "Auto Search"
		auto_search_btn.disabled = true
	
	timeline_log.append("--- SEARCH COMPLETE ---")
	_show_complete_popup()
	
	if cpp_code_button:
		cpp_code_button.show()
		if code_anim: code_anim.play("default")

func _update_ui_labels():
	compare_label.text = "Comparisons: %d" % [comparison_counter]

func _show_complete_popup() -> void:
	if complete_popup:
		var result_text = "Found" if search_found else "Not Found"
		var txt = "Binary Search Finished!\n\nTarget: %d\nResult: %s\nComparisons: %d" % [search_target, result_text, comparison_counter]
		if process_label: process_label.text = txt
		complete_popup.popup_centered()

func _on_timeline_pressed() -> void:
	btn_sound.play()
	if timeline_popup.visible:
		timeline_popup.hide()
	else:
		timeline_label.text = "Timeline:\n" + "\n".join(timeline_log)
		timeline_popup.popup_centered()

func _on_timeline_close_pressed() -> void:
	btn_sound.play()
	if timeline_popup:
		timeline_popup.hide()

# ==============================================
#   CODE GENERATION
# ==============================================

func _add_code_line(op: String, index: int, value: int) -> void:
	code_lines.append("%s|%d|%d" % [op, index, value])

func _generate_code_for_language(lang: String) -> String:
	match lang:
		"python": return _gen_python_code()
		"java": return _gen_java_code()
		"c": return _gen_c_code()
		_: return _gen_cpp_code()

func _gen_cpp_code() -> String:
	var code = "/* Binary Search Simulation - Operations Log */\n"
	code += "#include <iostream>\nusing namespace std;\n\n"
	code += "void printArray(int arr[], int n) {\n"
	code += "    cout << \"[\";\n"
	code += "    for(int i = 0; i < n; i++) {\n"
	code += "        cout << arr[i];\n"
	code += "        if(i < n-1) cout << \", \";\n"
	code += "    }\n"
	code += "    cout << \"]\" << endl;\n"
	code += "}\n\n"
	code += "int binarySearch(int arr[], int low, int high, int target) {\n"
	code += "    while(low <= high) {\n"
	code += "        int mid = low + (high - low) / 2;\n"
	code += "        cout << \"Checking mid \" << mid << \": \" << arr[mid] << endl;\n"
	code += "        \n"
	code += "        if(arr[mid] == target) {\n"
	code += "            cout << \"Found target at index \" << mid << \"!\" << endl;\n"
	code += "            return mid;\n"
	code += "        }\n"
	code += "        \n"
	code += "        if(arr[mid] < target) {\n"
	code += "            cout << arr[mid] << \" < \" << target << \", moving right\" << endl;\n"
	code += "            low = mid + 1;\n"
	code += "        } else {\n"
	code += "            cout << arr[mid] << \" > \" << target << \", moving left\" << endl;\n"
	code += "            high = mid - 1;\n"
	code += "        }\n"
	code += "    }\n"
	code += "    cout << \"Target not found\" << endl;\n"
	code += "    return -1;\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    int arr[] = {%s};\n" % _array_to_string(main_array)
	code += "    int n = sizeof(arr)/sizeof(arr[0]);\n"
	code += "    int target = %d;\n\n" % search_target
	code += "    cout << \"Initial array: \";\n"
	code += "    printArray(arr, n);\n"
	code += "    cout << \"Searching for: \" << target << endl << endl;\n\n"
	code += "    int result = binarySearch(arr, 0, n-1, target);\n\n"
	code += "    return 0;\n"
	code += "}\n"
	code += "/* Complexity: Time O(log n) | Space O(1) */"
	return code

func _gen_python_code() -> String:
	var code = "# Binary Search Simulation - Operations Log\n\n"
	code += "def print_array(arr):\n"
	code += "    print('[', end='')\n"
	code += "    for i in range(len(arr)):\n"
	code += "        print(arr[i], end='')\n"
	code += "        if i < len(arr) - 1:\n"
	code += "            print(', ', end='')\n"
	code += "    print(']')\n\n"
	code += "def binary_search(arr, target):\n"
	code += "    low, high = 0, len(arr) - 1\n"
	code += "    while low <= high:\n"
	code += "        mid = (low + high) // 2\n"
	code += "        print(f'Checking mid {mid}: {arr[mid]}')\n"
	code += "        if arr[mid] == target:\n"
	code += "            print(f'Found target at index {mid}!')\n"
	code += "            return mid\n"
	code += "        elif arr[mid] < target:\n"
	code += "            print(f'{arr[mid]} < {target}, moving right')\n"
	code += "            low = mid + 1\n"
	code += "        else:\n"
	code += "            print(f'{arr[mid]} > {target}, moving left')\n"
	code += "            high = mid - 1\n"
	code += "    print('Target not found')\n"
	code += "    return -1\n\n"
	code += "arr = [%s]\n" % _array_to_string(main_array)
	code += "target = %d\n\n" % search_target
	code += "print('Initial array: ', end='')\n"
	code += "print_array(arr)\n"
	code += "print(f'Searching for: {target}\\n')\n"
	code += "binary_search(arr, target)\n"
	code += "''' Complexity: Time O(log n) | Space O(1) '''"
	return code

func _gen_java_code() -> String:
	var code = "/* Binary Search Simulation - Operations Log */\n"
	code += "import java.util.*;\n\n"
	code += "public class BinarySearchSim {\n"
	code += "    public static void printArray(int[] arr) {\n"
	code += "        System.out.print(\"[\");\n"
	code += "        for(int i = 0; i < arr.length; i++) {\n"
	code += "            System.out.print(arr[i]);\n"
	code += "            if(i < arr.length-1) System.out.print(\", \");\n"
	code += "        }\n"
	code += "        System.out.println(\"]\");\n"
	code += "    }\n\n"
	code += "    public static int binarySearch(int[] arr, int target) {\n"
	code += "        int low = 0, high = arr.length - 1;\n"
	code += "        while(low <= high) {\n"
	code += "            int mid = low + (high - low) / 2;\n"
	code += "            System.out.println(\"Checking mid \" + mid + \": \" + arr[mid]);\n"
	code += "            if(arr[mid] == target) {\n"
	code += "                System.out.println(\"Found target at index \" + mid + \"!\");\n"
	code += "                return mid;\n"
	code += "            }\n"
	code += "            if(arr[mid] < target) {\n"
	code += "                System.out.println(arr[mid] + \" < \" + target + \", moving right\");\n"
	code += "                low = mid + 1;\n"
	code += "            } else {\n"
	code += "                System.out.println(arr[mid] + \" > \" + target + \", moving left\");\n"
	code += "                high = mid - 1;\n"
	code += "            }\n"
	code += "        }\n"
	code += "        System.out.println(\"Target not found\");\n"
	code += "        return -1;\n"
	code += "    }\n\n"
	code += "    public static void main(String[] args) {\n"
	code += "        int[] arr = {%s};\n" % _array_to_string(main_array)
	code += "        int target = %d;\n\n" % search_target
	code += "        System.out.print(\"Initial array: \");\n"
	code += "        printArray(arr);\n"
	code += "        System.out.println(\"Searching for: \" + target + \"\\n\");\n"
	code += "        binarySearch(arr, target);\n"
	code += "    }\n"
	code += "}\n"
	code += "/* Complexity: Time O(log n) | Space O(1) */"
	return code

func _gen_c_code() -> String:
	var code = "/* Binary Search Simulation - Operations Log */\n"
	code += "#include <stdio.h>\n\n"
	code += "void printArray(int arr[], int n) {\n"
	code += "    printf(\"[\");\n"
	code += "    for(int i = 0; i < n; i++) {\n"
	code += "        printf(\"%d\", arr[i]);\n"
	code += "        if(i < n-1) printf(\", \");\n"
	code += "    }\n"
	code += "    printf(\"]\\n\");\n"
	code += "}\n\n"
	code += "int binarySearch(int arr[], int low, int high, int target) {\n"
	code += "    while(low <= high) {\n"
	code += "        int mid = low + (high - low) / 2;\n"
	code += "        printf(\"Checking mid %d: %d\\n\", mid, arr[mid]);\n"
	code += "        if(arr[mid] == target) {\n"
	code += "            printf(\"Found target at index %d!\\n\", mid);\n"
	code += "            return mid;\n"
	code += "        }\n"
	code += "        if(arr[mid] < target) {\n"
	code += "            printf(\"%d < %d, moving right\\n\", arr[mid], target);\n"
	code += "            low = mid + 1;\n"
	code += "        } else {\n"
	code += "            printf(\"%d > %d, moving left\\n\", arr[mid], target);\n"
	code += "            high = mid - 1;\n"
	code += "        }\n"
	code += "    }\n"
	code += "    printf(\"Target not found\\n\");\n"
	code += "    return -1;\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    int arr[] = {%s};\n" % _array_to_string(main_array)
	code += "    int n = sizeof(arr)/sizeof(arr[0]);\n"
	code += "    int target = %d;\n\n" % search_target
	code += "    printf(\"Initial array: \");\n"
	code += "    printArray(arr, n);\n"
	code += "    printf(\"Searching for: %d\\n\\n\", target);\n"
	code += "    binarySearch(arr, 0, n-1, target);\n"
	code += "    return 0;\n"
	code += "}\n"
	code += "/* Complexity: Time O(log n) | Space O(1) */"
	return code

func _array_to_string(arr: Array) -> String:
	var parts: Array[String] = []
	for v in arr:
		parts.append(str(v))
	return ", ".join(parts)

# ==============================================
#   CODE POPUP
# ==============================================

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	if complete_popup: complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

func _show_cpp_popup() -> void:
	var code = _generate_code_for_language(current_code_language)
	
	if cpp_label:
		cpp_label.bbcode_enabled = true
		cpp_label.text = code
	
	cpp_popup.popup_centered()
	
	if current_code_language == "cpp":
		cpp_tutorial_step = 0
		if cpp_next_btn:
			if not cpp_next_btn.is_connected("pressed", _on_cpp_next_pressed):
				cpp_next_btn.pressed.connect(_on_cpp_next_pressed)
		_update_cpp_tutorial()

func _on_cpp_next_pressed() -> void:
	btn_sound.play()
	cpp_tutorial_step += 1
	if cpp_tutorial_step >= cpp_tutorial_data.size():
		cpp_tutorial_step = 0
	_update_cpp_tutorial()

func _update_cpp_tutorial() -> void:
	if cpp_tutorial_data.is_empty(): return
	var data = cpp_tutorial_data[cpp_tutorial_step]
	if cpp_explanation_lbl:
		cpp_explanation_lbl.bbcode_enabled = true
		cpp_explanation_lbl.text = data["text"]
	
	if cpp_label:
		var code = _generate_code_for_language(current_code_language)
		
		var lines = code.split("\n")
		var highlighted_code = ""
		var indices = data["lines"]
		for i in range(lines.size()):
			if i in indices:
				highlighted_code += "[color=yellow]" + lines[i] + "[/color]\n"
			else:
				highlighted_code += lines[i] + "\n"
		
		cpp_label.text = highlighted_code
		
		if cpp_scroll and indices.size() > 0:
			cpp_scroll.scroll_vertical = indices[0] * 25

func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()

# ==============================================
#   RESULT POPUP HANDLERS
# ==============================================

func _on_try_again_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_config_modal()

func _on_back_pressed() -> void:
	btn_sound.play()
	result_popup.hide()

func _show_result_popup(result: String, grade: Dictionary) -> void:
	if not result_popup:
		return
	
	if result == "PASS":
		result_title.text = "FOUND!"
		result_title.modulate = Color.GREEN
		if translate_code_btn:
			translate_code_btn.show()
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")
	else:
		result_title.text = "NOT FOUND"
		result_title.modulate = Color.RED
		if translate_code_btn:
			translate_code_btn.hide()
		if cpp_code_button:
			cpp_code_button.hide()
	
	score_summary.text = "Comparisons: %d" % grade.get("bad_moves", 0)
	accuracy_label.text = "Target: %d" % search_target
	time_used_label.text = "Low/High: %d/%d" % [low_idx, high_idx]
	coins_label.text = "+%d" % grade.get("coins", 0)
	
	result_popup.popup_centered()
	
	if grade.get("coins", 0) > 0 and coins_anim:
		coins_anim.play("default")

func show_feedback(text: String, color: Color, position: Vector2):
	var feedback_scene = preload("res://scene/FeedbackLabel.tscn")
	var label = feedback_scene.instantiate()
	label.text = text
	label.modulate = color
	label.global_position = position
	add_child(label)
	
	var anim_player: AnimationPlayer = label.get_node("AnimationPlayer")
	anim_player.play("notification_pop")
	anim_player.animation_finished.connect(func(_a): label.queue_free())

# ==============================================
#   CONFIG HANDLERS
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
		
		# Create label
		var label = Label.new()
		label.text = "Value %d" % (i + 1)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		# Create input
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
		var val = int(le.text) if le.text.is_valid_int() else int(le.placeholder_text)
		arr.append(val)
	config_elements_modal.hide()
	_set_main_ui_enabled(true)
	_initialize_with_elements(arr)

func _on_config_no_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	var count = randi_range(5, 7)
	var arr: Array[int] = []
	for i in count: arr.append(randi_range(1, 99))
	_set_main_ui_enabled(true)
	_initialize_with_elements(arr)

func _on_size_back_pressed(): config_size_modal.hide(); config_modal.show()
func _on_elements_back_pressed(): config_elements_modal.hide(); config_size_modal.show()

# ==============================================
#   INTRO LOGIC & TUTORIAL
# ==============================================

func show_introduction():
	if tutorial_overlay: tutorial_overlay.show()
	if not intro_popup: return
	intro_popup.show()
	_set_main_ui_enabled(false)
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

func _on_intro_prev_pressed():
	btn_sound.play()
	if intro_step > 0:
		intro_step -= 1
		_update_intro_text()

func _on_intro_skip_pressed():
	btn_sound.play()
	intro_popup.hide()
	_set_main_ui_enabled(false)

func start_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	tutorial_overlay.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{
			"node": sort_btn,
			"title": "FIND ELEMENT",
			"text": "Opens a popup to set the Target value.",
			"action": "highlight"
		},
		{
			"node": auto_btn,
			"title": "BINARY STEP",
			"text": "Executes ONE binary search division step.",
			"action": "highlight"
		},
		{
			"node": auto_search_btn,
			"title": "AUTO SEARCH",
			"text": "Starts/Pauses automatic searching.",
			"action": "highlight"
		},
		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View a scrollable history of comparisons.",
			"action": "highlight"
		},
		{
			"node": simulate_new_btn,
			"title": "SIMULATE NEW",
			"text": "Resets the simulation with new numbers.",
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

func _handle_tutorial_step():
	var step = tutorial_sequence[tutorial_sequence_index]
	if step["node"] == sort_btn:
		tutorial_sequence_index += 1
		show_tutorial_step()

func _on_next_button_pressed():
	tutorial_sequence_index += 1
	show_tutorial_step()

func end_tutorial():
	tutorial_in_progress = false
	tutorial_overlay.hide()
	if pointer_sprite:
		pointer_sprite.hide()
		if pointer_sprite.has_meta("tween"):
			pointer_sprite.get_meta("tween").kill()

func _set_main_ui_enabled(enabled: bool) -> void:
	if sort_btn: sort_btn.disabled = not enabled
	if auto_btn: auto_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled
	if simulate_new_btn: simulate_new_btn.disabled = not enabled
	if auto_search_btn: auto_search_btn.disabled = not enabled

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
	start_tutorial()
