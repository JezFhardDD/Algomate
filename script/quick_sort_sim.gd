extends Control


# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton
@onready var auto_btn: Button = $VBoxContainer/WaitingElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew

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

# --- C++ POPUP NODES (SCROLLABLE SETUP) ---
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
# References for ScrollContainer + RichTextLabel
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

# --- QUICK SORT VARIABLES ---
var main_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []

# Iterative Quick Sort State
var quick_stack: Array = []  # Stores [low, high] ranges
var current_low: int = 0
var current_high: int = 0
var partition_index: int = 0 # 'i' in algorithm
var scan_index: int = 0      # 'j' in algorithm
var pivot_idx: int = 0
var is_partitioning: bool = false # Are we inside the partition loop?

var comparison_counter: int = 0
var swap_counter: int = 0
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
var BLOCK_SPACING: float = 50.0
var START_POSITION: Vector2 = Vector2(50, 80)
var ANIM_SPEED: float = 1.2 # Standard speed for Quick Sort

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

var index_labels: Array[Label] = []
var INDEX_LABEL_OFFSET: float = 100.0
var current_tween: Tween = null

# Intro Text
var intro_step: int = 0
var intro_texts = [
	"Welcome to Quick Sort!\n\nThis is a 'Divide and Conquer' algorithm. It's much faster than Insertion Sort for large lists.",
	"The Pivot:\n\nWe pick an element (usually the last one) to be the 'Pivot'.",
	"Partitioning:\n\nWe rearrange the array so that everything smaller than the Pivot goes to the left, and everything larger goes to the right.",
	"Complexity:\n\nTime: O(n log n) on average.\nSpace: O(log n) for stack space."
]

# Code Tutorial Data (RE-MAPPED TO NEW PRINTS)
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0

var cpp_tutorial_data = [
	{ "lines": [3, 4, 5, 6, 7], "text": "[b]Complexity Analysis:[/b]\n• [b]Time:[/b] [color=green]O(n log n)[/color] (Avg), [color=red]O(n²)[/color] (Worst).\n• [b]Space:[/b] [color=orange]O(log n)[/color] due to recursion stack." },
	{ "lines": [16, 17, 18], "text": "1. Partition Function:\nTakes the last element as the 'pivot'." },
	{ "lines": [19, 20, 21], "text": "2. Pointers:\n'i' tracks the boundary of smaller elements. 'j' scans the array." },
	{ "lines": [22, 23, 24, 25], "text": "3. The Swap:\nIf arr[j] is smaller than pivot, we swap it with arr[i]." },
	{ "lines": [29, 30, 31], "text": "4. Place Pivot:\nSwap the pivot into the slot after 'i'. It is now sorted." },
	{ "lines": [36, 37, 38, 39, 40], "text": "5. Recursive Calls:\nSort left of pivot, then print, then sort right of pivot." }
]

var python_tutorial_data = [
	{ "lines": [0], "text": "[b]Complexity Analysis:[/b]\n• [b]Time:[/b] [color=green]O(n log n)[/color] (Avg).\n• [b]Space:[/b] [color=orange]O(log n)[/color]." },
	{ "lines": [2, 3], "text": "1. Partition Function:\nTakes the last element as the 'pivot'." },
	{ "lines": [4, 5], "text": "2. Pointers:\n'i' tracks the boundary of smaller elements. 'j' scans." },
	{ "lines": [6, 7, 8], "text": "3. The Swap:\nIf arr[j] is smaller than pivot, we swap them." },
	{ "lines": [9, 10], "text": "4. Place Pivot:\nSwap the pivot into its final sorted position." },
	{ "lines": [12, 13, 14, 15, 16], "text": "5. Recursive Calls:\nSort left of pivot, print state, then sort right." }
]

var java_tutorial_data = [
	{ "lines": [0], "text": "[b]Complexity Analysis:[/b]\n• [b]Time:[/b] [color=green]O(n log n)[/color] (Avg).\n• [b]Space:[/b] [color=orange]O(log n)[/color]." },
	{ "lines": [1, 2], "text": "1. Partition Function:\nTakes the last element as the 'pivot'." },
	{ "lines": [3, 4], "text": "2. Pointers:\n'i' tracks the boundary of smaller elements. 'j' scans." },
	{ "lines": [5, 6, 7, 8, 9, 10], "text": "3. The Swap:\nIf arr[j] is smaller than pivot, we swap them using a temp int." },
	{ "lines": [12, 13, 14, 15], "text": "4. Place Pivot:\nSwap the pivot into its final sorted position." },
	{ "lines": [18, 19, 20, 21, 22, 23], "text": "5. Recursive Calls:\nSort left of pivot, print the array, then sort right." }
]

var c_tutorial_data = [
	{ "lines": [1], "text": "[b]Complexity Analysis:[/b]\n• [b]Time:[/b] [color=green]O(n log n)[/color] (Avg).\n• [b]Space:[/b] [color=orange]O(log n)[/color]." },
	{ "lines": [10, 11, 12], "text": "1. Partition Function:\nTakes the last element as the 'pivot'." },
	{ "lines": [13, 14, 15], "text": "2. Pointers:\n'i' tracks the boundary of smaller elements. 'j' scans." },
	{ "lines": [16, 17, 18, 19], "text": "3. The Swap:\nIf arr[j] is smaller than pivot, we swap them using our helper." },
	{ "lines": [23, 24, 25], "text": "4. Place Pivot:\nSwap the pivot into its final sorted position." },
	{ "lines": [30, 31, 32, 33, 34], "text": "5. Recursive Calls:\nSort left of pivot, print the array, then sort right." }
]

# ==============================================
#   READY
# ==============================================
func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	print("Program started — initializing Quick Sort visualizer...")
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
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if unused_ptr1: unused_ptr1.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	if cpp_code_button: cpp_code_button.hide()
	
	if sort_btn: sort_btn.text = "Next Step"
	if auto_btn: auto_btn.text = "Auto Sort"
	
	_connect_configuration_buttons()
	
	# Setup compiler
	_setup_compiler()
	
	_show_config_modal() 
	
	call_deferred("show_introduction")
	
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")
	
	_connect_language_buttons()

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
	
	print("=== Quick Sort Compile Request ===")
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
#  INITIALIZATION
# ==============================================

func _initialize_with_elements(elements: Array[int]) -> void:
	# Reset cache for new simulation
	reset_cache_for_scene()
	
	# Clear code lines
	code_lines.clear()
	
	print("Initializing Array with:", elements)
	audio_player.play()
	
	main_array = elements.duplicate()
	block_nodes.clear()
	index_labels.clear()  # Clear index labels
	timeline_log.clear()
	
	# Initialize Quick Sort Vars
	quick_stack = []
	quick_stack.append([0, main_array.size() - 1])
	is_partitioning = false
	
	comparison_counter = 0
	swap_counter = 0
	sorting_complete = false
	is_auto_playing = false
	
	# Log initial array
	_add_code_line("INITIAL", 0, 0)
	
	for child in array_container.get_children():
		child.queue_free()
	
	var current_x = START_POSITION.x
	var block_width = 64.0
	
	for i in range(main_array.size()):
		var val = main_array[i]
		
		var new_block = BLOCK_SCENE.instantiate()
		new_block.value = val
		new_block.position = Vector2(current_x, START_POSITION.y)
		
		if new_block.has_signal("block_dropped"):
			new_block.connect("block_dropped", _on_block_dropped)
		
		new_block.modulate.a = 0.0 
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(new_block, "modulate:a", 1.0, 0.5)
		
		array_container.add_child(new_block)
		block_nodes.append(new_block)
		
		# Create index label below block
		var index_label = Label.new()
		index_label.text = str(i)
		index_label.position = Vector2(current_x + 25, START_POSITION.y + INDEX_LABEL_OFFSET)
		index_label.add_theme_font_override("font", load("res://assets/font/Planes_ValMore.ttf"))
		index_label.add_theme_font_size_override("font_size", 28)
		index_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		index_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		index_label.add_theme_constant_override("outline_size", 4)
		array_container.add_child(index_label)
		index_labels.append(index_label)
		
		current_x += block_width + BLOCK_SPACING
	
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

	_update_ui_labels()
	if cpp_code_button: cpp_code_button.hide()

func _update_index_labels():
	var block_width = 64.0
	for i in range(index_labels.size()):
		var target_x = START_POSITION.x + i * (block_width + BLOCK_SPACING)
		index_labels[i].position = Vector2(target_x + 25, START_POSITION.y + INDEX_LABEL_OFFSET)
		index_labels[i].text = str(i)
		
func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

# ==============================================
#  DRAG AND DROP LOGIC
# ==============================================

func _on_block_dropped(dropped_block: Control) -> void:
	if is_sorting or comparison_counter > 0:
		print("Cannot drag blocks while sorting!")
		_resnap_blocks()
		return
		
	var children: Array = array_container.get_children()
	var old_index: int = block_nodes.find(dropped_block)
	var center_x: float = dropped_block.position.x + dropped_block.size.x * 0.5
	var insert_index: int = 0
	
	for c in block_nodes:
		if c == dropped_block: continue
		var c_center: float = c.position.x + c.size.x * 0.5
		if center_x > c_center:
			insert_index += 1
	
	if old_index != insert_index:
		var val = main_array.pop_at(old_index)
		main_array.insert(insert_index, val)
		block_nodes.remove_at(old_index)
		block_nodes.insert(insert_index, dropped_block)
		timeline_log.append("User moved %d from index %d to %d" % [val, old_index, insert_index])
		_add_code_line("MOVE", insert_index, val)
		
		# Update index labels after drag and drop
		_update_index_labels()
	
	_resnap_blocks()

func _resnap_blocks() -> void:
	var x = START_POSITION.x
	var block_width = 64.0
	
	for i in range(block_nodes.size()):
		var node = block_nodes[i]
		var target_pos = Vector2(x, START_POSITION.y)
		create_tween().tween_property(node, "position", target_pos, ANIM_SPEED)
		x += block_width + BLOCK_SPACING
	
	# Update index labels after blocks reposition
	_update_index_labels()

# ==============================================
#  QUICK SORT LOGIC (ITERATIVE)
# ==============================================

func _on_step_pressed() -> void:
	if is_sorting or sorting_complete: return
	if tutorial_in_progress: _handle_tutorial_step()
	btn_sound.play()
	_perform_sort_step()

func _on_auto_pressed() -> void:
	if sorting_complete: return
	btn_sound.play()
	is_auto_playing = !is_auto_playing
	auto_btn.text = "Pause" if is_auto_playing else "Auto Sort"
	if is_auto_playing: _run_auto_sort()

func _run_auto_sort() -> void:
	while is_auto_playing and not sorting_complete:
		if is_sorting: await get_tree().process_frame 
		else:
			await _perform_sort_step()
			await get_tree().create_timer(ANIM_SPEED).timeout

func _perform_sort_step():
	is_sorting = true
	
	# -- PHASE 1: PICK NEXT RANGE FROM STACK --
	if not is_partitioning:
		if quick_stack.is_empty():
			# SORTING COMPLETE
			for node in block_nodes:
				if node.has_method("set_sorted_visual"): node.set_sorted_visual()
			_finish_simulation()
			is_sorting = false
			return
		
		# Pop the next range
		var range_indices = quick_stack.pop_back()
		current_low = range_indices[0]
		current_high = range_indices[1]
		
		if current_low >= current_high:
			# Single element, already sorted
			is_sorting = false
			return
		
		# Set up for partitioning
		pivot_idx = current_high
		partition_index = current_low - 1 # 'i'
		scan_index = current_low          # 'j'
		is_partitioning = true
		
		status_label.text = "Pivot picked: %d" % main_array[pivot_idx]
		timeline_log.append("Partitioning range [%d, %d] with Pivot: %d" % [current_low, current_high, main_array[pivot_idx]])
		_add_code_line("PIVOT", pivot_idx, main_array[pivot_idx])
		
		# Highlight Pivot
		if block_nodes[pivot_idx].has_method("set_highlight"):
			block_nodes[pivot_idx].set_highlight(true)
		# Highlight pivot index label
		if pivot_idx < index_labels.size():
			index_labels[pivot_idx].add_theme_color_override("font_color", Color(1, 0.5, 0, 1))
			
		is_sorting = false
		return 

	# -- PHASE 2: PARTITION LOOP --
	if is_partitioning:
		if scan_index < current_high:
			# Update Pointers
			_update_pointers(partition_index + 1, scan_index)
			
			# Compare arr[j] with Pivot
			comparison_counter += 1
			var val_j = main_array[scan_index]
			var val_pivot = main_array[pivot_idx]
			
			status_label.text = "Comparing %d vs Pivot %d" % [val_j, val_pivot]
			_add_code_line("COMPARE", scan_index, val_j)
			
			if block_nodes[scan_index].has_method("set_highlight"):
				block_nodes[scan_index].set_highlight(true)
			
			# Highlight index label for scan index
			if scan_index < index_labels.size():
				index_labels[scan_index].add_theme_color_override("font_color", Color(1, 1, 0, 1))
			
			await get_tree().create_timer(ANIM_SPEED * 0.5).timeout
			
			if val_j < val_pivot:
				partition_index += 1
				# Swap if needed
				if partition_index != scan_index:
					swap_counter += 1
					status_label.text = "%d < %d. Swapping." % [val_j, val_pivot]
					_add_code_line("SWAP", partition_index, val_j)
					
					var temp = main_array[partition_index]
					main_array[partition_index] = main_array[scan_index]
					main_array[scan_index] = temp
					
					var node_p = block_nodes[partition_index]
					var node_s = block_nodes[scan_index]
					block_nodes[partition_index] = node_s
					block_nodes[scan_index] = node_p
					
					await _animate_swap(node_p, node_s)
					
					# Update index labels after swap
					_update_index_labels()
			else:
				status_label.text = "%d >= %d. No swap." % [val_j, val_pivot]
			
			# Reset highlight for scan index
			if block_nodes[scan_index].has_method("set_highlight"):
				block_nodes[scan_index].set_highlight(false)
			if scan_index < index_labels.size():
				index_labels[scan_index].add_theme_color_override("font_color", Color(1, 1, 1, 1))
				
			scan_index += 1
			
		else:
			# -- PHASE 3: PLACE PIVOT --
			var final_pivot_pos = partition_index + 1
			
			if final_pivot_pos != current_high:
				swap_counter += 1
				_add_code_line("PIVOT_PLACE", final_pivot_pos, main_array[current_high])
				var temp = main_array[final_pivot_pos]
				main_array[final_pivot_pos] = main_array[current_high]
				main_array[current_high] = temp
				
				var node_a = block_nodes[final_pivot_pos]
				var node_b = block_nodes[current_high]
				block_nodes[final_pivot_pos] = node_b
				block_nodes[current_high] = node_a
				
				status_label.text = "Placing pivot in correct spot."
				await _animate_swap(node_a, node_b)
				
				# Update index labels after swap
				_update_index_labels()
			
			# Pivot is now at final_pivot_pos
			if block_nodes[final_pivot_pos].has_method("set_highlight"):
				block_nodes[final_pivot_pos].set_highlight(false)
			# Reset pivot index label color
			if final_pivot_pos < index_labels.size():
				index_labels[final_pivot_pos].add_theme_color_override("font_color", Color(1, 1, 1, 1))
			if pivot_idx < index_labels.size() and pivot_idx != final_pivot_pos:
				index_labels[pivot_idx].add_theme_color_override("font_color", Color(1, 1, 1, 1))
			
			# Push Right side first (so Left is processed next)
			if final_pivot_pos + 1 < current_high:
				quick_stack.append([final_pivot_pos + 1, current_high])
			if current_low < final_pivot_pos - 1:
				quick_stack.append([current_low, final_pivot_pos - 1])
				
			is_partitioning = false
			
			if ptr_left: ptr_left.hide()
			if ptr_right: ptr_right.hide()
	
	_update_ui_labels()
	is_sorting = false

func _animate_swap(node_a: Control, node_b: Control):
	var pos_a = node_a.position
	var pos_b = node_b.position
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(node_a, "position", pos_b, ANIM_SPEED)
	tween.tween_property(node_b, "position", pos_a, ANIM_SPEED)
	await tween.finished
	node_a.position = pos_b
	node_b.position = pos_a
	
	# Update index labels after swap
	_update_index_labels()

func _update_pointers(left_idx: int, right_idx: int):
	if block_nodes.is_empty(): return
	if ptr_left: ptr_left.show()
	if ptr_right: ptr_right.show()
	
	if left_idx < block_nodes.size() and left_idx >= 0:
		var node = block_nodes[left_idx]
		if ptr_left:
			# Adjusted pointer position: higher above the block
			ptr_left.global_position = node.global_position + Vector2(16, node.size.y - 120)
	
	if right_idx < block_nodes.size() and right_idx >= 0:
		var node = block_nodes[right_idx]
		if ptr_right:
			# Adjusted pointer position: higher above the block
			ptr_right.global_position = node.global_position + Vector2(16, node.size.y - 150)

func _finish_simulation():
	sorting_complete = true
	is_auto_playing = false
	status_label.text = "Sorted!"
	auto_btn.text = "Auto Sort"
	auto_btn.disabled = true
	sort_btn.disabled = true
	
	# Reset index label colors
	for label in index_labels:
		label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	
	timeline_log.append("--- SORTING COMPLETE ---")
	_show_complete_popup()
	
	if cpp_code_button:
		cpp_code_button.show()
		if code_anim: code_anim.play("default")

# ==============================================
#  UI & POPUPS
# ==============================================

func _update_ui_labels():
	compare_label.text = "Comparisons: %d | Swaps: %d" % [comparison_counter, swap_counter]

func _show_complete_popup() -> void:
	if complete_popup:
		var txt = "Sorting Finished!\n\nTotal Comparisons: %d\nTotal Swaps: %d" % [comparison_counter, swap_counter]
		if process_label: process_label.text = txt
		complete_popup.popup_centered()
		
		# Show code button
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")

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
#  CODE GENERATION
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
	var code = "/* Quick Sort Simulation - Operations Log */\n"
	code += "#include <iostream>\nusing namespace std;\n\n"
	code += "void printArray(int arr[], int n) {\n"
	code += "    cout << \"[\";\n"
	code += "    for(int i = 0; i < n; i++) {\n"
	code += "        cout << arr[i];\n"
	code += "        if(i < n-1) cout << \", \";\n"
	code += "    }\n"
	code += "    cout << \"]\" << endl;\n"
	code += "}\n\n"
	code += "int partition(int arr[], int low, int high) {\n"
	code += "    int pivot = arr[high];\n"
	code += "    int i = (low - 1);\n\n"
	code += "    for(int j = low; j <= high - 1; j++) {\n"
	code += "        if(arr[j] < pivot) {\n"
	code += "            i++;\n"
	code += "            int temp = arr[i];\n"
	code += "            arr[i] = arr[j];\n"
	code += "            arr[j] = temp;\n"
	code += "        }\n"
	code += "    }\n"
	code += "    int temp = arr[i+1];\n"
	code += "    arr[i+1] = arr[high];\n"
	code += "    arr[high] = temp;\n"
	code += "    return (i + 1);\n"
	code += "}\n\n"
	code += "void quickSort(int arr[], int low, int high, int n) {\n"
	code += "    if(low < high) {\n"
	code += "        int pi = partition(arr, low, high);\n"
	code += "        cout << \"Pivot placed at index \" << pi << \": \";\n"
	code += "        printArray(arr, n);\n"
	code += "        quickSort(arr, low, pi - 1, n);\n"
	code += "        quickSort(arr, pi + 1, high, n);\n"
	code += "    }\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    int arr[] = {%s};\n" % _array_to_string(main_array)
	code += "    int n = sizeof(arr)/sizeof(arr[0]);\n\n"
	code += "    cout << \"Initial array: \";\n"
	code += "    printArray(arr, n);\n\n"
	code += "    quickSort(arr, 0, n-1, n);\n\n"
	code += "    cout << \"Sorted array: \";\n"
	code += "    printArray(arr, n);\n"
	code += "    return 0;\n"
	code += "}\n"
	code += "/* Complexity: Time O(n log n) avg | Space O(log n) */"
	return code

func _gen_python_code() -> String:
	var code = "# Quick Sort Simulation - Operations Log\n\n"
	code += "def print_array(arr):\n"
	code += "    print('[', end='')\n"
	code += "    for i in range(len(arr)):\n"
	code += "        print(arr[i], end='')\n"
	code += "        if i < len(arr) - 1:\n"
	code += "            print(', ', end='')\n"
	code += "    print(']')\n\n"
	code += "def partition(arr, low, high):\n"
	code += "    pivot = arr[high]\n"
	code += "    i = low - 1\n"
	code += "    for j in range(low, high):\n"
	code += "        if arr[j] < pivot:\n"
	code += "            i += 1\n"
	code += "            arr[i], arr[j] = arr[j], arr[i]\n"
	code += "    arr[i+1], arr[high] = arr[high], arr[i+1]\n"
	code += "    return i+1\n\n"
	code += "def quick_sort(arr, low, high):\n"
	code += "    if low < high:\n"
	code += "        pi = partition(arr, low, high)\n"
	code += "        print(f'Pivot placed at index {pi}: ', end='')\n"
	code += "        print_array(arr)\n"
	code += "        quick_sort(arr, low, pi-1)\n"
	code += "        quick_sort(arr, pi+1, high)\n\n"
	code += "arr = [%s]\n" % _array_to_string(main_array)
	code += "print('Initial array: ', end='')\n"
	code += "print_array(arr)\n\n"
	code += "quick_sort(arr, 0, len(arr)-1)\n\n"
	code += "print('Sorted array: ', end='')\n"
	code += "print_array(arr)\n"
	code += "''' Complexity: Time O(n log n) avg | Space O(log n) '''"
	return code

func _gen_java_code() -> String:
	var code = "/* Quick Sort Simulation - Operations Log */\n"
	code += "import java.util.*;\n\n"
	code += "public class QuickSortSim {\n"
	code += "    public static void printArray(int[] arr) {\n"
	code += "        System.out.print(\"[\");\n"
	code += "        for(int i = 0; i < arr.length; i++) {\n"
	code += "            System.out.print(arr[i]);\n"
	code += "            if(i < arr.length-1) System.out.print(\", \");\n"
	code += "        }\n"
	code += "        System.out.println(\"]\");\n"
	code += "    }\n\n"
	code += "    public static int partition(int[] arr, int low, int high) {\n"
	code += "        int pivot = arr[high];\n"
	code += "        int i = (low - 1);\n"
	code += "        for(int j = low; j < high; j++) {\n"
	code += "            if(arr[j] < pivot) {\n"
	code += "                i++;\n"
	code += "                int temp = arr[i];\n"
	code += "                arr[i] = arr[j];\n"
	code += "                arr[j] = temp;\n"
	code += "            }\n"
	code += "        }\n"
	code += "        int temp = arr[i+1];\n"
	code += "        arr[i+1] = arr[high];\n"
	code += "        arr[high] = temp;\n"
	code += "        return i+1;\n"
	code += "    }\n\n"
	code += "    public static void sort(int[] arr, int low, int high) {\n"
	code += "        if(low < high) {\n"
	code += "            int pi = partition(arr, low, high);\n"
	code += "            System.out.print(\"Pivot placed at index \" + pi + \": \");\n"
	code += "            printArray(arr);\n"
	code += "            sort(arr, low, pi-1);\n"
	code += "            sort(arr, pi+1, high);\n"
	code += "        }\n"
	code += "    }\n\n"
	code += "    public static void main(String[] args) {\n"
	code += "        int[] arr = {%s};\n" % _array_to_string(main_array)
	code += "        System.out.print(\"Initial array: \");\n"
	code += "        printArray(arr);\n\n"
	code += "        sort(arr, 0, arr.length-1);\n\n"
	code += "        System.out.print(\"Sorted array: \");\n"
	code += "        printArray(arr);\n"
	code += "    }\n"
	code += "}\n"
	code += "/* Complexity: Time O(n log n) avg | Space O(log n) */"
	return code

func _gen_c_code() -> String:
	var code = "/* Quick Sort Simulation - Operations Log */\n"
	code += "#include <stdio.h>\n\n"
	code += "void printArray(int arr[], int n) {\n"
	code += "    printf(\"[\");\n"
	code += "    for(int i = 0; i < n; i++) {\n"
	code += "        printf(\"%d\", arr[i]);\n"
	code += "        if(i < n-1) printf(\", \");\n"
	code += "    }\n"
	code += "    printf(\"]\\n\");\n"
	code += "}\n\n"
	code += "int partition(int arr[], int low, int high) {\n"
	code += "    int pivot = arr[high];\n"
	code += "    int i = (low - 1);\n\n"
	code += "    for(int j = low; j <= high - 1; j++) {\n"
	code += "        if(arr[j] < pivot) {\n"
	code += "            i++;\n"
	code += "            int temp = arr[i];\n"
	code += "            arr[i] = arr[j];\n"
	code += "            arr[j] = temp;\n"
	code += "        }\n"
	code += "    }\n"
	code += "    int temp = arr[i+1];\n"
	code += "    arr[i+1] = arr[high];\n"
	code += "    arr[high] = temp;\n"
	code += "    return (i + 1);\n"
	code += "}\n\n"
	code += "void quickSort(int arr[], int low, int high, int n) {\n"
	code += "    if(low < high) {\n"
	code += "        int pi = partition(arr, low, high);\n"
	code += "        printf(\"Pivot placed at index %d: \", pi);\n"
	code += "        printArray(arr, n);\n"
	code += "        quickSort(arr, low, pi - 1, n);\n"
	code += "        quickSort(arr, pi + 1, high, n);\n"
	code += "    }\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    int arr[] = {%s};\n" % _array_to_string(main_array)
	code += "    int n = sizeof(arr)/sizeof(arr[0]);\n\n"
	code += "    printf(\"Initial array: \");\n"
	code += "    printArray(arr, n);\n\n"
	code += "    quickSort(arr, 0, n-1, n);\n\n"
	code += "    printf(\"Sorted array: \");\n"
	code += "    printArray(arr, n);\n"
	code += "    return 0;\n"
	code += "}\n"
	code += "/* Complexity: Time O(n log n) avg | Space O(log n) */"
	return code

func _array_to_string(arr: Array) -> String:
	var parts: Array[String] = []
	for v in arr:
		parts.append(str(v))
	return ", ".join(parts)

# ==============================================
#  CODE GENERATION & TUTORIAL
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
	
	cpp_tutorial_step = 0
	if cpp_next_btn:
		if not cpp_next_btn.is_connected("pressed", _on_cpp_next_pressed):
			cpp_next_btn.pressed.connect(_on_cpp_next_pressed)
	_update_cpp_tutorial()

func _on_cpp_next_pressed() -> void:
	btn_sound.play()
	cpp_tutorial_step += 1
	var max_steps = 0
	match current_code_language:
		"cpp": max_steps = cpp_tutorial_data.size()
		"python": max_steps = python_tutorial_data.size()
		"java": max_steps = java_tutorial_data.size()
		"c": max_steps = c_tutorial_data.size()
		
	if cpp_tutorial_step >= max_steps:
		cpp_tutorial_step = 0
	_update_cpp_tutorial()

func _update_cpp_tutorial() -> void:
	var data = {}
	match current_code_language:
		"cpp": data = cpp_tutorial_data[cpp_tutorial_step]
		"python": data = python_tutorial_data[cpp_tutorial_step]
		"java": data = java_tutorial_data[cpp_tutorial_step]
		"c": data = c_tutorial_data[cpp_tutorial_step]
	
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
		
		cpp_label.bbcode_enabled = true
		cpp_label.text = highlighted_code
		
		# --- AUTO SCROLL FIX ---
		if cpp_scroll and indices.size() > 0:
			var target_scroll = indices[0] * 20
			var tween = create_tween()
			tween.tween_property(cpp_scroll, "scroll_vertical", target_scroll, 0.2).set_trans(Tween.TRANS_SINE)

func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()

# ==============================================
#  RESULT POPUP HANDLERS
# ==============================================

func _on_try_again_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_config_modal()

func _on_back_pressed() -> void:
	btn_sound.play()
	result_popup.hide()

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
#  CONFIG HANDLERS
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
	grid.add_theme_constant_override("h_separation", 35)
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
#  INTRO LOGIC & TUTORIAL (CRITICAL)
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
	_set_main_ui_enabled(true)

# --- TUTORIAL MAIN ---

func start_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	tutorial_overlay.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{
			"node": sort_btn,
			"title": "NEXT STEP",
			"text": "Executes one comparison or pivot selection.",
			"action": "highlight"
		},
		{
			"node": auto_btn,
			"title": "AUTO SORT",
			"text": "Starts/Pauses the automatic quick sort.",
			"action": "highlight"
		},
		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View a scrollable history of pivots and swaps.",
			"action": "highlight"
		},
		{
			"node": simulate_new_btn,
			"title": "SIMULATE NEW",
			"text": "Resets the simulation.",
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

# ==============================================
#  HELPER / UTILS
# ==============================================

func _set_main_ui_enabled(enabled: bool) -> void:
	if sort_btn: sort_btn.disabled = not enabled
	if auto_btn: auto_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled
	if simulate_new_btn: simulate_new_btn.disabled = not enabled

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
