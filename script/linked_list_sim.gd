extends Control

# ==============================================
#   UI NODES & REFERENCES
# ==============================================

# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton          
@onready var auto_btn: Button = $VBoxContainer/LinearStep          
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew
@onready var auto_search_btn: Button = get_node_or_null("VBoxContainer/AutoSearchButton")
@onready var help_btn: Button = get_node_or_null("HelpButton")

# --- CUSTOM MENU BUTTONS (Created in Editor) ---
@onready var insert_menu: MenuButton = $VBoxContainer/InsertMenu
@onready var delete_menu: MenuButton = $VBoxContainer/DeleteMenu
@onready var update_menu: MenuButton = $VBoxContainer/UpdateAtPos  # NEW: Update button

# --- INDICATORS ---
@onready var is_full_indicator: TextureRect = $isFull  # NEW: isFull indicator
@onready var is_empty_indicator: TextureRect = $isEmpty  # NEW: isEmpty indicator

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var compare_label: Label = $HBoxContainer2/Label
@onready var array_container: Control = $QueueContainer
@onready var dequeued_container: Control = $DequeuedContainer 

# --- POPUPS ---
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: Label = $TimelinePopup/MainVBox/ScrollContainer/VBoxContainer/Label
@onready var timeline_close_btn: Button = get_node_or_null("TimelinePopup/MainVBox/CloseButton")
@onready var Queue_full: Panel = get_node_or_null("Queue_full")
@onready var anim_sprite: AnimatedSprite2D = get_node_or_null("Queue_full/AnimatedSprite2D")
@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var process_label: Label = get_node_or_null("SimulationCompletePopup/VBoxContainer/ProcessLabel")

# --- CODE POPUP NODES ---
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_scroll: ScrollContainer = get_node_or_null("CppPopup/VBoxContainer/CodeScroll")
@onready var cpp_label: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/CodeScroll/CodeLabel")
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/close") as Button
@onready var cpp_next_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CppNextButton")
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_lbl: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")
@onready var code_anim: AnimatedSprite2D = get_node_or_null("CppCodeButton/code_anim")

# --- COMPILER INTEGRATION ---
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CompileButton")

# --- SCENE RESOURCES ---
const BLOCK_SCENE := preload("res://LinkedBlock.tscn")
const POINTER_TEX := preload("res://assets/point_left.png")
const RESULT_POPUP_SCENE := preload("res://scene/ResultPopup.tscn")

# --- bg texture and font ---
const DIALOG_BG_TEX = preload("res://assets/CONTAINER.png")
const CUSTOM_FONT = preload("res://assets/font/Planes_ValMore.ttf")

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

# --- INDEX LABELS ---
var index_labels: Array[Label] = []  # NEW: Store index label nodes
var INDEX_LABEL_OFFSET: float = 120.0  # NEW: Vertical offset for index labels

# ==============================================
#   STATE VARIABLES
# ==============================================
const API_KEYS = {
	"cpp": {"clientId": "f4fc8575ee6c45ca1baf697a28b9771e", "clientSecret": "7d8b060459fb304352f243b2a95194c04bf10503b1a06126043bc4f3cada366e"},
	"c": {"clientId": "f4fc8575ee6c45ca1baf697a28b9771e", "clientSecret": "7d8b060459fb304352f243b2a95194c04bf10503b1a06126043bc4f3cada366e"},
	"java": {"clientId": "f4fc8575ee6c45ca1baf697a28b9771e", "clientSecret": "7d8b060459fb304352f243b2a95194c04bf10503b1a06126043bc4f3cada366e"},
	"python": {"clientId": "f4fc8575ee6c45ca1baf697a28b9771e", "clientSecret": "7d8b060459fb304352f243b2a95194c04bf10503b1a06126043bc4f3cada366e"}
}

var main_array: Array[int] = []
var initial_elements: Array[int] = []      
var action_history: Array[Dictionary] = [] 
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []
var visual_links: Array[Line2D] = []

var search_target: int = 0
var current_idx: int = 0
var search_found: bool = false
var comparison_counter: int = 0
var swap_counter: int = 0 
var sorting_complete: bool = false
var is_sorting: bool = false
var is_auto_playing: bool = false
var simulation_ended: bool = false  # NEW: Track simulation ended state

var code_lines: Array[String] = []
var current_code_language: String = "cpp"
var max_array_size: int = 6  # NEW: Max size for linked list

# Result Popup Variables
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

# Layout Variables
var BLOCK_WIDTH: float = 64.0 
var BLOCK_SPACING: float = 40.0 
var START_POSITION: Vector2 = Vector2(50, 100)
var ANIM_SPEED: float = 1.5 

# --- INPUT DIALOG ELEMENTS ---
var target_input_dialog: ConfirmationDialog
var target_spinbox: SpinBox
var pos_input_dialog: ConfirmationDialog
var pos_spinbox: SpinBox
var val_spinbox: SpinBox
var val_label: Label 
var current_op_type: int = 0 

# --- TUTORIAL VARIABLES ---
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false
var intro_step: int = 0
var intro_texts = [
	"Welcome to Linked List Simulation!\nA Linked List is a linear data structure where elements are not stored in contiguous memory locations. Instead, elements are linked using pointers.",
	"The Pointers:\n\n• HEAD: Points to the first node.\n• TAIL: Points to the last node.\n• NEXT: Arrows linking one node to the next.",
	"Complexity:\n\nTime: O(N) for Search, O(1) for Insertion/Deletion at known pointers.\nSpace: O(N) for storing N nodes.",
	"Operations available:\n\n• INSERT: Add at Beginning, End, or a specific Position.\n• DELETE: Remove from Beginning, End, or a specific Position.\n• UPDATE: Update value at a specific Position.\n• SEARCH: Traverse the list to find a value."
]

var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0

var tutorial_data_map = {
	"cpp": [
		{ "lines": [0], "text": "1. Complexity: Time O(N), Space O(N)" },
		{ "lines": [4, 5, 6, 7], "text": "2. Structure:\nA Node contains data and a pointer to the next node." },
		{ "lines": [91, 92, 93], "text": "3. Traversal Loop:\nStart at the head. Loop continues as long as current is not NULL." },
		{ "lines": [94, 95, 96, 97], "text": "4. Checking Value:\nIf current node's data matches target 'value', print result." },
		{ "lines": [98, 99], "text": "5. Moving Forward:\nIf not a match, move current pointer to the NEXT node." }
	],
	"python": [
		{ "lines": [0], "text": "1. Complexity: Time O(N), Space O(N)" },
		{ "lines": [1, 2, 3, 4], "text": "2. Structure:\nA Node contains data and a reference to the next node." },
		{ "lines": [60, 61, 62], "text": "3. Traversal Loop:\nStart at the head. Loop continues as long as current is not None." },
		{ "lines": [63, 64, 65], "text": "4. Checking Value:\nIf current node's data matches target 'value', print found." },
		{ "lines": [66, 67], "text": "5. Moving Forward:\nIf not a match, move current pointer to the NEXT node." }
	],
	"java": [
		{ "lines": [0], "text": "1. Complexity: Time O(N), Space O(N)" },
		{ "lines": [1, 2, 3, 4], "text": "2. Structure:\nA Node contains data and a reference to the next node." },
		{ "lines": [85, 86, 87], "text": "3. Traversal Loop:\nStart at the head. Loop continues as long as current is not null." },
		{ "lines": [88, 89, 90, 91], "text": "4. Checking Value:\nIf current node's data matches target 'value', print result." },
		{ "lines": [92, 93], "text": "5. Moving Forward:\nIf not a match, move current pointer to the NEXT node." }
	],
	"c": [
		{ "lines": [0], "text": "1. Complexity: Time O(N), Space O(N)" },
		{ "lines": [4, 5, 6, 7], "text": "2. Structure:\nA Node contains data and a pointer to the next node." },
		{ "lines": [87, 88, 89], "text": "3. Traversal Loop:\nStart at the head. Loop continues as long as current is not NULL." },
		{ "lines": [90, 91, 92, 93], "text": "4. Checking Value:\nIf current node's data matches target 'value', print result." },
		{ "lines": [94, 95], "text": "5. Moving Forward:\nIf not a match, move current pointer to the NEXT node." }
	]
}

# ==============================================
#   READY
# ==============================================
func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	print("Program started — initializing Linked List visualizer...")
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
	
	try_again_result_btn.pressed.connect(_on_try_again_pressed)
	back_result_btn.pressed.connect(_on_back_pressed)
	translate_code_btn.pressed.connect(_on_translate_code_pressed)
	
	_setup_menu_buttons()
	_create_input_dialogs()
	
	if unused_ptr1: unused_ptr1.queue_free()
	if unused_ptr2: unused_ptr2.queue_free()
	
	if size_input:
		size_input.min_value = 1
		size_input.max_value = 6
		size_input.value = clamp(size_input.value, 1, 6)
	
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if cpp_code_button: cpp_code_button.hide()
	
	if sort_btn: sort_btn.text = "Find Element"
	if auto_btn: auto_btn.text = "Search Step"
	if auto_search_btn: auto_search_btn.text = "Auto Search"
	
	_ensure_connected(sort_btn, "pressed", _on_search_pressed)
	_ensure_connected(auto_btn, "pressed", _on_step_pressed)
	if auto_search_btn: _ensure_connected(auto_search_btn, "pressed", _on_auto_search_pressed)
	
	if help_btn: _ensure_connected(help_btn, "pressed", _on_help_button_pressed)
	if tutorial_next: _ensure_connected(tutorial_next, "pressed", _on_next_button_pressed)
	if cpp_next_btn: _ensure_connected(cpp_next_btn, "pressed", _on_cpp_next_pressed)
	
	_connect_configuration_buttons()
	_setup_compiler()
	
	# Setup update menu button
	_setup_update_menu()
	
	_show_config_modal() 
	call_deferred("show_introduction")
	
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")
	_connect_language_buttons()
	
	# Hide indicators initially
	if is_full_indicator: is_full_indicator.modulate = Color(0.3, 0.3, 0.3, 1)
	if is_empty_indicator: is_empty_indicator.modulate = Color(0.3, 0.3, 0.3, 1)

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
#   UPDATE MENU SETUP
# ==============================================
func _setup_update_menu():
	if update_menu:
		update_menu.custom_minimum_size = Vector2(250, 60)
		update_menu.add_theme_font_override("font", CUSTOM_FONT)
		update_menu.add_theme_font_size_override("font_size", 18)
		
		var update_popup = update_menu.get_popup()
		update_popup.clear()
		update_popup.add_item("Update at Position", 0)
		
		update_popup.add_theme_constant_override("item_start_padding", 30)
		update_popup.add_theme_constant_override("item_end_padding", 50)
		update_popup.add_theme_constant_override("v_separation", 24)
		
		var custom_bg_style = _get_texture_stylebox(DIALOG_BG_TEX)
		var hover_style = StyleBoxFlat.new()
		hover_style.bg_color = Color(1, 1, 1, 0.1)
		
		update_popup.add_theme_stylebox_override("panel", custom_bg_style)
		update_popup.add_theme_stylebox_override("hover", hover_style)
		update_popup.add_theme_font_override("font", CUSTOM_FONT)
		update_popup.add_theme_font_size_override("font_size", 16)
		update_popup.id_pressed.connect(_on_update_selected)

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
	var code = _generate_code_for_language(current_code_language)
	
	if compiler_output_popup and compiler_output_popup.has_cached_result(current_code_language):
		var cached = compiler_output_popup.get_cached_result(current_code_language)
		var fake_response = { "output": cached.output, "error": cached.error, "memory": cached.memory, "cpu": cached.cpu }
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
	if current_code_language == "python": api_language = "python3"
	
	var body = JSON.new().stringify({
		"clientId": keys["clientId"],
		"clientSecret": keys["clientSecret"],
		"script": code,
		"language": api_language,
		"versionIndex": _get_version_index(current_code_language)
	})
	http_request.request(url, headers, HTTPClient.METHOD_POST, body)

func _get_version_index(lang: String) -> String:
	match lang:
		"cpp": return "5"
		"c", "java", "python": return "4"
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
	
	if compiler_output_popup:
		compiler_output_popup.show_output(language, json.data, self, false)

func _on_recompile_requested(language: String) -> void:
	_compile_code(_generate_code_for_language(language))

func _on_compiler_output_closed() -> void:
	print("Compiler output closed")

func reset_cache_for_scene() -> void:
	if compiler_output_popup: compiler_output_popup.reset_cache_for_scene()

# ==============================================
#   DIALOG CREATION & MENU SETUP
# ==============================================
func _setup_menu_buttons():
	var custom_bg_style = _get_texture_stylebox(DIALOG_BG_TEX)
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = Color(1, 1, 1, 0.1) 
	
	if insert_menu:
		insert_menu.custom_minimum_size = Vector2(250, 60)
		insert_menu.add_theme_font_override("font", CUSTOM_FONT)
		insert_menu.add_theme_font_size_override("font_size", 18)
		
		var in_popup = insert_menu.get_popup()
		in_popup.clear()
		in_popup.add_item("Insert at Beginning", 0)
		in_popup.add_item("Insert at End", 1)
		in_popup.add_item("Insert at Position", 2)
		
		in_popup.add_theme_constant_override("item_start_padding", 30)
		in_popup.add_theme_constant_override("item_end_padding", 50)
		in_popup.add_theme_constant_override("v_separation", 24)
		
		in_popup.add_theme_stylebox_override("panel", custom_bg_style)
		in_popup.add_theme_stylebox_override("hover", hover_style)
		in_popup.add_theme_font_override("font", CUSTOM_FONT)
		in_popup.add_theme_font_size_override("font_size", 16)
		in_popup.id_pressed.connect(_on_insert_selected)
		
	if delete_menu:
		delete_menu.custom_minimum_size = Vector2(250, 60)
		delete_menu.add_theme_font_override("font", CUSTOM_FONT)
		delete_menu.add_theme_font_size_override("font_size", 18)
		
		var del_popup = delete_menu.get_popup()
		del_popup.clear()
		del_popup.add_item("Delete at Beginning", 0)
		del_popup.add_item("Delete at End", 1)
		del_popup.add_item("Delete at Position", 2)
		
		del_popup.add_theme_constant_override("item_start_padding", 30)
		del_popup.add_theme_constant_override("item_end_padding", 50)
		del_popup.add_theme_constant_override("v_separation", 24)
		
		del_popup.add_theme_stylebox_override("panel", custom_bg_style)
		del_popup.add_theme_stylebox_override("hover", hover_style)
		del_popup.add_theme_font_override("font", CUSTOM_FONT)
		del_popup.add_theme_font_size_override("font_size", 16)
		del_popup.id_pressed.connect(_on_delete_selected)

func _create_input_dialogs():
	var custom_bg_style = _get_texture_stylebox(DIALOG_BG_TEX)
	
	target_input_dialog = ConfirmationDialog.new()
	target_input_dialog.borderless = true
	target_input_dialog.min_size = Vector2i(350, 160)
	target_input_dialog.add_theme_stylebox_override("panel", custom_bg_style)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15)
	target_input_dialog.add_child(vbox)
	
	var lbl = Label.new()
	lbl.text = "Enter value:"
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.add_theme_font_override("font", CUSTOM_FONT)
	lbl.add_theme_font_size_override("font_size", 20)
	vbox.add_child(lbl)
	
	target_spinbox = SpinBox.new()
	target_spinbox.min_value = 0
	target_spinbox.max_value = 999
	target_spinbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	target_spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	target_spinbox.custom_minimum_size = Vector2(200, 50)
	target_spinbox.get_line_edit().add_theme_font_override("font", CUSTOM_FONT)
	target_spinbox.get_line_edit().add_theme_font_size_override("font_size", 18)
	vbox.add_child(target_spinbox)
	add_child(target_input_dialog)
	
	pos_input_dialog = ConfirmationDialog.new()
	pos_input_dialog.borderless = true
	pos_input_dialog.min_size = Vector2i(350, 260)
	pos_input_dialog.add_theme_stylebox_override("panel", custom_bg_style)
	
	var pvbox = VBoxContainer.new()
	pvbox.add_theme_constant_override("separation", 12) 
	pos_input_dialog.add_child(pvbox)
	
	var plbl = Label.new()
	plbl.text = "Enter Index (0 is Head):"
	plbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	plbl.add_theme_font_override("font", CUSTOM_FONT)
	plbl.add_theme_font_size_override("font_size", 18)
	pvbox.add_child(plbl)
	
	pos_spinbox = SpinBox.new()
	pos_spinbox.min_value = 0
	pos_spinbox.max_value = 999 
	pos_spinbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	pos_spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pos_spinbox.custom_minimum_size = Vector2(200, 50)
	pos_spinbox.get_line_edit().add_theme_font_override("font", CUSTOM_FONT)
	pos_spinbox.get_line_edit().add_theme_font_size_override("font_size", 16)
	pvbox.add_child(pos_spinbox)
	
	val_label = Label.new()
	val_label.text = "Enter Value to Insert/Update:"
	val_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	val_label.add_theme_font_override("font", CUSTOM_FONT)
	val_label.add_theme_font_size_override("font_size", 18)
	pvbox.add_child(val_label)
	
	val_spinbox = SpinBox.new()
	val_spinbox.min_value = 0
	val_spinbox.max_value = 999
	val_spinbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	val_spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	val_spinbox.custom_minimum_size = Vector2(200, 50)
	val_spinbox.get_line_edit().add_theme_font_override("font", CUSTOM_FONT)
	val_spinbox.get_line_edit().add_theme_font_size_override("font_size", 16)
	pvbox.add_child(val_spinbox)
	add_child(pos_input_dialog)
	
	pos_input_dialog.confirmed.connect(_on_pos_dialog_confirmed)
	
	call_deferred("_style_dialog_buttons", target_input_dialog)
	call_deferred("_style_dialog_buttons", pos_input_dialog)

func _style_dialog_buttons(dialog: ConfirmationDialog):
	var ok_btn = dialog.get_ok_button()
	var cancel_btn = dialog.get_cancel_button()
	
	for btn in [ok_btn, cancel_btn]:
		if btn:
			btn.add_theme_stylebox_override("normal", _get_modern_button_style(false))
			btn.add_theme_stylebox_override("hover", _get_modern_button_style(true))
			btn.add_theme_stylebox_override("pressed", _get_modern_button_style(false))
			btn.add_theme_font_override("font", CUSTOM_FONT)
			btn.add_theme_font_size_override("font_size", 16)
			
			if btn == cancel_btn:
				btn.add_theme_stylebox_override("normal", _get_modern_stylebox(Color(0.3, 0.3, 0.35, 1.0)))
				btn.add_theme_stylebox_override("hover", _get_modern_stylebox(Color(0.4, 0.4, 0.45, 1.0)))

func _disconnect_target_signals():
	if target_input_dialog.confirmed.is_connected(_on_search_confirmed): 
		target_input_dialog.confirmed.disconnect(_on_search_confirmed)
	if target_input_dialog.confirmed.is_connected(_insert_beginning): 
		target_input_dialog.confirmed.disconnect(_insert_beginning)
	if target_input_dialog.confirmed.is_connected(_insert_end): 
		target_input_dialog.confirmed.disconnect(_insert_end)

# ==============================================
#   LINKED LIST OPERATIONS
# ==============================================
func _on_insert_selected(id: int):
	if simulation_ended: return
	btn_sound.play()
	if is_sorting: return
	
	if main_array.size() >= max_array_size:
		status_label.text = "Max size of %d reached! Cannot insert more." % max_array_size
		if Queue_full:
			Queue_full.show()
			if anim_sprite: anim_sprite.play("default")
			await get_tree().create_timer(2.0).timeout
			Queue_full.hide()
		return
		
	target_input_dialog.title = "Insert Value"
	_disconnect_target_signals()
	
	if id == 0: 
		target_input_dialog.confirmed.connect(_insert_beginning)
		target_input_dialog.popup_centered()
	elif id == 1: 
		target_input_dialog.confirmed.connect(_insert_end)
		target_input_dialog.popup_centered()
	elif id == 2: 
		current_op_type = 0 
		val_label.show() 
		val_spinbox.show() 
		pos_spinbox.max_value = main_array.size()
		pos_input_dialog.popup_centered()

func _on_delete_selected(id: int):
	if simulation_ended: return
	btn_sound.play()
	if is_sorting: return
	
	if main_array.is_empty():
		status_label.text = "List is already empty!"
		return
		
	if id == 0: _delete_at(0)
	elif id == 1: _delete_at(main_array.size() - 1)
	elif id == 2: 
		current_op_type = 1 
		val_label.hide() 
		val_spinbox.hide() 
		pos_spinbox.max_value = main_array.size() - 1
		pos_input_dialog.popup_centered()

func _on_update_selected(id: int):
	if simulation_ended: return
	btn_sound.play()
	if is_sorting: return
	
	if main_array.is_empty():
		status_label.text = "List is empty! Nothing to update."
		return
	
	current_op_type = 2
	val_label.show()
	val_spinbox.show()
	pos_spinbox.max_value = main_array.size() - 1
	pos_input_dialog.popup_centered()

func _on_pos_dialog_confirmed():
	var pos = int(pos_spinbox.value)
	if current_op_type == 0:
		_insert_at(pos, int(val_spinbox.value))
	elif current_op_type == 1:
		_delete_at(pos)
	elif current_op_type == 2:
		_update_at(pos, int(val_spinbox.value))

func _insert_beginning(): _insert_at(0, int(target_spinbox.value))
func _insert_end(): _insert_at(main_array.size(), int(target_spinbox.value))

func _insert_at(index: int, val: int):
	if main_array.size() >= max_array_size: return 
	if index < 0 or index > main_array.size(): return
	
	_add_code_line("INSERT", index, val)
	action_history.append({"type": "insert", "index": index, "value": val})
	
	main_array.insert(index, val)
	var new_block = BLOCK_SCENE.instantiate()
	new_block.value = val
	new_block.modulate.a = 0.0 
	array_container.add_child(new_block)
	block_nodes.insert(index, new_block)
	
	# Create index label for new block
	var index_font = load("res://assets/font/Planes_ValMore.ttf")
	var index_label = Label.new()
	index_label.text = str(index)
	index_label.add_theme_font_override("font", index_font)
	index_label.add_theme_font_size_override("font_size", 32)
	index_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	index_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	index_label.add_theme_constant_override("outline_size", 4)
	array_container.add_child(index_label)
	index_labels.insert(index, index_label)
	
	timeline_log.append("Inserted %d at position %d" % [val, index])
	status_label.text = "Inserted %d into Linked List." % val
	_resnap_blocks()
	_update_indicators()

func _delete_at(index: int):
	if index < 0 or index >= main_array.size(): return
	
	_add_code_line("DELETE", index, main_array[index])
	action_history.append({"type": "delete", "index": index})
	
	var val = main_array.pop_at(index)
	var block = block_nodes.pop_at(index)
	var label = index_labels.pop_at(index)
	
	block.reparent(dequeued_container)
	label.reparent(dequeued_container)
	var tw = create_tween()
	tw.tween_property(block, "modulate:a", 0.0, ANIM_SPEED)
	tw.parallel().tween_property(label, "modulate:a", 0.0, ANIM_SPEED)
	tw.tween_callback(block.queue_free)
	tw.tween_callback(label.queue_free)
	
	timeline_log.append("Deleted %d from position %d" % [val, index])
	status_label.text = "Deleted %d from Linked List." % val
	_resnap_blocks()
	_update_indicators()

func _update_at(index: int, new_val: int):
	if index < 0 or index >= main_array.size(): return
	if simulation_ended: return
	
	var old_val = main_array[index]
	main_array[index] = new_val
	
	# Update block visual
	if index < block_nodes.size():
		block_nodes[index].value = new_val
		# Flash animation for update
		var flash_tween = create_tween().set_parallel()
		flash_tween.tween_property(block_nodes[index], "modulate", Color.YELLOW, 0.1)
		flash_tween.tween_property(block_nodes[index], "modulate", Color.WHITE, 0.2).set_delay(0.1)
	
	_add_code_line("UPDATE", index, new_val)
	action_history.append({"type": "update", "index": index, "old_value": old_val, "new_value": new_val})
	
	timeline_log.append("Updated position %d: %d → %d" % [index, old_val, new_val])
	status_label.text = "Updated position %d to %d" % [index, new_val]
	_update_indicators()

# ==============================================
#   VISUAL UPDATES (POINTERS, LINKS & INDEX LABELS)
# ==============================================
func _resnap_blocks() -> void:
	is_sorting = true
	var x = START_POSITION.x
	var index_font = load("res://assets/font/Planes_ValMore.ttf")
	
	for i in range(block_nodes.size()):
		var node = block_nodes[i]
		var target_pos = Vector2(x, START_POSITION.y)
		var tw = create_tween()
		tw.tween_property(node, "position", target_pos, ANIM_SPEED)
		if node.modulate.a < 1.0:
			tw.parallel().tween_property(node, "modulate:a", 1.0, ANIM_SPEED)
		
		# Update index label
		if i < index_labels.size():
			var label = index_labels[i]
			label.text = str(i)
			var label_target_pos = Vector2(x + (node.size.x / 2) - 15, START_POSITION.y + INDEX_LABEL_OFFSET)
			tw.parallel().tween_property(label, "position", label_target_pos, ANIM_SPEED)
		
		x += (node.size.x * node.scale.x) + BLOCK_SPACING
	
	await get_tree().create_timer(ANIM_SPEED + 0.1).timeout
	_draw_pointers_and_links()
	is_sorting = false

func _draw_pointers_and_links():
	for line in visual_links: line.queue_free()
	visual_links.clear()
	
	if block_nodes.is_empty():
		if ptr_left: ptr_left.hide()
		if ptr_right: ptr_right.hide()
		return
		
	if ptr_left:
		ptr_left.show()
		ptr_left.global_position = block_nodes[0].global_position + Vector2(16, -40)
		
	if ptr_right:
		ptr_right.show()
		var tail_node = block_nodes[block_nodes.size() - 1]
		ptr_right.global_position = tail_node.global_position + Vector2(16, (tail_node.size.y * tail_node.scale.y) + 10)
	
	for i in range(block_nodes.size() - 1):
		var n1 = block_nodes[i]
		var n2 = block_nodes[i+1]
		var start = n1.global_position + Vector2(n1.size.x * n1.scale.x, (n1.size.y * n1.scale.y) / 2.0)
		var end = n2.global_position + Vector2(0, (n2.size.y * n2.scale.y) / 2.0)
		
		var line = Line2D.new()
		line.width = 4
		line.default_color = Color(0.8, 0.8, 0.2)
		line.add_point(start)
		line.add_point(end)
		add_child(line)
		visual_links.append(line)

# ==============================================
#   INDICATOR FUNCTIONS
# ==============================================
func _update_indicators():
	if is_full_indicator:
		if main_array.size() >= max_array_size:
			is_full_indicator.modulate = Color(0, 1, 0, 1)  # Bright green when full
		else:
			is_full_indicator.modulate = Color(0.3, 0.3, 0.3, 1)  # Dark when not full
	
	if is_empty_indicator:
		if main_array.size() == 0:
			is_empty_indicator.modulate = Color(1, 0.5, 0.8, 1)  # Pink when empty
		else:
			is_empty_indicator.modulate = Color(0.3, 0.3, 0.3, 1)  # Dark when not empty

# ==============================================
#   INITIALIZATION
# ==============================================
func _initialize_with_elements(elements: Array[int]) -> void:
	reset_cache_for_scene()
	code_lines.clear()
	audio_player.play()
	simulation_ended = false
	
	main_array = elements.duplicate()
	initial_elements = elements.duplicate() 
	action_history.clear()
	
	_add_code_line("INITIAL", 0, 0)
	block_nodes.clear()
	index_labels.clear()
	timeline_log.clear()
	
	for child in array_container.get_children(): child.queue_free()
	
	var current_x = START_POSITION.x
	var index_font = load("res://assets/font/Planes_ValMore.ttf")
	
	for i in range(main_array.size()):
		var new_block = BLOCK_SCENE.instantiate()
		new_block.value = main_array[i]
		new_block.position = Vector2(current_x, START_POSITION.y)
		array_container.add_child(new_block)
		block_nodes.append(new_block)
		
		# Create index label below block
		var index_label = Label.new()
		index_label.text = str(i)
		index_label.position = Vector2(current_x + (new_block.size.x / 2) - 15, START_POSITION.y + INDEX_LABEL_OFFSET)
		index_label.add_theme_font_override("font", index_font)
		index_label.add_theme_font_size_override("font_size", 32)
		index_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		index_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		index_label.add_theme_constant_override("outline_size", 4)
		array_container.add_child(index_label)
		index_labels.append(index_label)
		
		current_x += (new_block.size.x * new_block.scale.x) + BLOCK_SPACING
		
	_draw_pointers_and_links()
	search_target = 0
	status_label.text = "Linked List Ready. Use Insert, Delete, Update, or Search."
	
	current_idx = 0
	search_found = false
	comparison_counter = 0
	sorting_complete = false
	is_auto_playing = false
	
	_ensure_connected(timeline_btn, "pressed", _on_timeline_pressed)
	_ensure_connected(simulate_new_btn, "pressed", _on_simulate_new_pressed)
	_ensure_connected(complete_ok_btn, "pressed", _on_complete_ok_pressed)
	_ensure_connected(show_cpp_btn, "pressed", _on_show_cpp_pressed)
	_ensure_connected(cpp_code_button, "pressed", _on_cpp_code_button_pressed)
	_ensure_connected(cpp_close_btn, "pressed", _on_cpp_close_pressed)
	if timeline_close_btn: _ensure_connected(timeline_close_btn, "pressed", _on_timeline_close_pressed)
	
	_update_ui_labels()
	_update_indicators()
	
	# Enable all buttons
	_set_main_ui_enabled(true)

func _set_main_ui_enabled(enabled: bool) -> void:
	if insert_menu: insert_menu.disabled = not enabled
	if delete_menu: delete_menu.disabled = not enabled
	if update_menu: update_menu.disabled = not enabled
	if sort_btn: sort_btn.disabled = not enabled
	if auto_btn: auto_btn.disabled = not enabled
	if auto_search_btn: auto_search_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled
	if simulate_new_btn: simulate_new_btn.disabled = not enabled
	if help_btn: help_btn.disabled = not enabled

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

# ==============================================
#   SEARCH TRAVERSAL LOGIC
# ==============================================
func _on_search_pressed() -> void:
	if simulation_ended: return
	btn_sound.play()
	target_input_dialog.title = "Search Linked List"
	_disconnect_target_signals()
	target_input_dialog.confirmed.connect(_on_search_confirmed)
	target_input_dialog.popup_centered()

func _on_search_confirmed():
	if simulation_ended: return
	btn_sound.play()
	search_target = int(target_spinbox.value)
	status_label.text = "Searching list for: %d" % search_target
	timeline_log.append("Started Traversal for: %d" % search_target)
	
	_add_code_line("SEARCH", 0, search_target)
	action_history.append({"type": "search", "value": search_target})
	
	current_idx = 0
	search_found = false
	comparison_counter = 0
	sorting_complete = false
	is_auto_playing = false
	
	if auto_btn: auto_btn.disabled = false
	if auto_search_btn: 
		auto_search_btn.disabled = false
		auto_search_btn.text = "Auto Search"
	
	for block in block_nodes:
		if block.has_method("set_highlight"): block.set_highlight(false)
		if block.has_method("reset_visuals"): block.reset_visuals()
		block.modulate = Color(1, 1, 1, 1)

func _on_auto_search_pressed() -> void:
	if sorting_complete or main_array.is_empty() or simulation_ended: return
	btn_sound.play()
	is_auto_playing = !is_auto_playing
	if auto_search_btn: auto_search_btn.text = "Pause" if is_auto_playing else "Auto Search"
	if auto_btn: auto_btn.disabled = is_auto_playing
	if is_auto_playing: _run_auto_sort()

func _on_step_pressed() -> void:
	if is_sorting or sorting_complete or simulation_ended: return
	btn_sound.play()
	_perform_sort_step()

func _run_auto_sort() -> void:
	while is_auto_playing and not sorting_complete and not simulation_ended:
		if is_sorting: await get_tree().process_frame 
		else:
			await _perform_sort_step()
			await get_tree().create_timer(ANIM_SPEED).timeout

func _perform_sort_step():
	is_sorting = true
	var n = main_array.size()
	
	if current_idx >= n:
		status_label.text = "Finished. Value NOT found in Linked List."
		timeline_log.append("Reached TAIL. %d not found." % search_target)
		_add_code_line("NOT_FOUND", 0, search_target)
		_finish_simulation()
		is_sorting = false
		return
	
	if ptr_left: 
		ptr_left.show()
		ptr_left.global_position = block_nodes[current_idx].global_position + Vector2(16, -40)
	
	if block_nodes[current_idx].has_method("set_highlight"):
		block_nodes[current_idx].set_highlight(true)
	
	# Also highlight index label
	if current_idx < index_labels.size():
		index_labels[current_idx].add_theme_color_override("font_color", Color(1, 1, 0, 1))
	
	comparison_counter += 1
	var val = main_array[current_idx]
	status_label.text = "Traversing node %d: %d == %d?" % [current_idx, val, search_target]
	timeline_log.append("Traversing node %d: Value %d" % [current_idx, val])
	_add_code_line("COMPARE", current_idx, val)
	
	await get_tree().create_timer(ANIM_SPEED * 0.8).timeout
	
	if val == search_target:
		search_found = true
		status_label.text = "FOUND %d at node index %d!" % [val, current_idx]
		timeline_log.append(" -> FOUND MATCH!")
		_add_code_line("FOUND", current_idx, val)
		if block_nodes[current_idx].has_method("set_sorted_visual"):
			block_nodes[current_idx].set_sorted_visual()
		_finish_simulation()
	else:
		status_label.text = "Not a match. Moving to NEXT pointer."
		if block_nodes[current_idx].has_method("set_highlight"):
			block_nodes[current_idx].set_highlight(false)
		# Reset index label color
		if current_idx < index_labels.size():
			index_labels[current_idx].add_theme_color_override("font_color", Color(1, 1, 1, 1))
		current_idx += 1
	
	_update_ui_labels()
	is_sorting = false

func _finish_simulation():
	sorting_complete = true
	is_auto_playing = false
	simulation_ended = true
	
	if auto_btn: auto_btn.disabled = true
	if auto_search_btn: 
		auto_search_btn.text = "Auto Search"
		auto_search_btn.disabled = true
	
	# Disable all operation buttons
	if insert_menu: insert_menu.disabled = true
	if delete_menu: delete_menu.disabled = true
	if update_menu: update_menu.disabled = true
	if sort_btn: sort_btn.disabled = true
	
	_draw_pointers_and_links() 
	timeline_log.append("--- TRAVERSAL COMPLETE ---")
	_show_complete_popup()
	
	# Show code button
	if cpp_code_button:
		cpp_code_button.show()
		if code_anim: code_anim.play("default")
	
	_update_indicators()

func _compute_grade() -> Dictionary:
	var passed = search_found
	return {
		"passed": passed,
		"accuracy": 100.0 if passed else 0.0,
		"correct_moves": 1 if passed else 0,
		"bad_moves": comparison_counter,
		"time_used": 0,
		"coins": 5 if passed else 0,
		"required": 60
	}

# ==============================================
#   UI & POPUPS
# ==============================================
func _update_ui_labels():
	compare_label.text = "Nodes Checked: %d" % [comparison_counter]

func _show_complete_popup() -> void:
	if complete_popup:
		var result_text = "Found" if search_found else "Not Found"
		var txt = "Traversal Finished!\n\nTarget: %d\nResult: %s\nNodes Checked: %d" % [search_target, result_text, comparison_counter]
		if process_label: process_label.text = txt
		complete_popup.popup_centered()

func _on_timeline_pressed() -> void:
	btn_sound.play()
	if timeline_popup.visible: timeline_popup.hide()
	else:
		timeline_label.text = "Timeline:\n" + "\n".join(timeline_log)
		timeline_popup.popup_centered()

func _on_timeline_close_pressed() -> void:
	btn_sound.play()
	if timeline_popup: timeline_popup.hide()

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
	var base_code = """/* Linked List Simulation - Operations Log */
#include <iostream>
using namespace std;

struct Node {
	int data;
	Node* next;
	Node(int val) : data(val), next(nullptr) {}
};

class LinkedList {
private:
	Node* head;
public:
	LinkedList() : head(nullptr) {}
	
	void printList() {
		Node* temp = head;
		cout << "[";
		while (temp != nullptr) {
			cout << temp->data;
			if (temp->next != nullptr) cout << ", ";
			temp = temp->next;
		}
		cout << "]" << endl;
	}
	
	void insertBeginning(int val) {
		Node* newNode = new Node(val);
		newNode->next = head;
		head = newNode;
		cout << "After insert " << val << " at beginning: ";
		printList();
	}
	
	void insertEnd(int val) {
		Node* newNode = new Node(val);
		if (head == nullptr) {
			head = newNode;
		} else {
			Node* temp = head;
			while (temp->next != nullptr) temp = temp->next;
			temp->next = newNode;
		}
		cout << "After insert " << val << " at end: ";
		printList();
	}
	
	void insertAtIndex(int index, int val) {
		if (index == 0) {
			insertBeginning(val);
			return;
		}
		Node* newNode = new Node(val);
		Node* temp = head;
		for (int i = 0; i < index - 1 && temp != nullptr; i++) {
			temp = temp->next;
		}
		if (temp == nullptr) return;
		newNode->next = temp->next;
		temp->next = newNode;
		cout << "After insert " << val << " at index " << index << ": ";
		printList();
	}
	
	void deleteBeginning() {
		if (head == nullptr) return;
		Node* temp = head;
		head = head->next;
		delete temp;
		cout << "After delete at beginning: ";
		printList();
	}
	
	void deleteEnd() {
		if (head == nullptr) return;
		if (head->next == nullptr) {
			delete head;
			head = nullptr;
		} else {
			Node* temp = head;
			while (temp->next->next != nullptr) temp = temp->next;
			delete temp->next;
			temp->next = nullptr;
		}
		cout << "After delete at end: ";
		printList();
	}
	
	void deleteAtIndex(int index) {
		if (index == 0) {
			deleteBeginning();
			return;
		}
		Node* temp = head;
		for (int i = 0; i < index - 1 && temp != nullptr; i++) {
			temp = temp->next;
		}
		if (temp == nullptr || temp->next == nullptr) return;
		Node* delNode = temp->next;
		temp->next = delNode->next;
		delete delNode;
		cout << "After delete at index " << index << ": ";
		printList();
	}
	
	void updateAtIndex(int index, int newVal) {
		if (head == nullptr) return;
		Node* temp = head;
		for (int i = 0; i < index && temp != nullptr; i++) {
			temp = temp->next;
		}
		if (temp == nullptr) return;
		int oldVal = temp->data;
		temp->data = newVal;
		cout << "After update at index " << index << " from " << oldVal << " to " << newVal << ": ";
		printList();
	}
	
	void linearSearch(int target) {
		Node* current = head;
		int index = 0;
		while (current != nullptr) {
			cout << "Checking node " << index << ": " << current->data << endl;
			if (current->data == target) {
				cout << "Found target at index " << index << "!" << endl;
				return;
			}
			current = current->next;
			index++;
		}
		cout << "Target not found" << endl;
	}
};

int main() {
	LinkedList list;"""
	
	var action_code = _build_action_code("cpp")
	return base_code + "\n\n" + action_code + "\n    return 0;\n}"

func _gen_python_code() -> String:
	var base_code = """# Linked List Simulation - Operations Log

class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None
    
    def print_list(self):
        temp = self.head
        print('[', end='')
        while temp:
            print(temp.data, end='')
            if temp.next:
                print(', ', end='')
            temp = temp.next
        print(']')
    
    def insert_beginning(self, val):
        new_node = Node(val)
        new_node.next = self.head
        self.head = new_node
        print(f'After insert {val} at beginning: ', end='')
        self.print_list()
    
    def insert_end(self, val):
        new_node = Node(val)
        if not self.head:
            self.head = new_node
        else:
            temp = self.head
            while temp.next:
                temp = temp.next
            temp.next = new_node
        print(f'After insert {val} at end: ', end='')
        self.print_list()
    
    def insert_at_index(self, index, val):
        if index == 0:
            self.insert_beginning(val)
            return
        new_node = Node(val)
        temp = self.head
        for _ in range(index - 1):
            if not temp:
                return
            temp = temp.next
        if not temp:
            return
        new_node.next = temp.next
        temp.next = new_node
        print(f'After insert {val} at index {index}: ', end='')
        self.print_list()
    
    def delete_beginning(self):
        if not self.head:
            return
        self.head = self.head.next
        print('After delete at beginning: ', end='')
        self.print_list()
    
    def delete_end(self):
        if not self.head:
            return
        if not self.head.next:
            self.head = None
        else:
            temp = self.head
            while temp.next.next:
                temp = temp.next
            temp.next = None
        print('After delete at end: ', end='')
        self.print_list()
    
    def delete_at_index(self, index):
        if index == 0:
            self.delete_beginning()
            return
        temp = self.head
        for _ in range(index - 1):
            if not temp:
                return
            temp = temp.next
        if not temp or not temp.next:
            return
        temp.next = temp.next.next
        print(f'After delete at index {index}: ', end='')
        self.print_list()
    
    def update_at_index(self, index, new_val):
        if not self.head:
            return
        temp = self.head
        for _ in range(index):
            if not temp:
                return
            temp = temp.next
        if not temp:
            return
        old_val = temp.data
        temp.data = new_val
        print(f'After update at index {index} from {old_val} to {new_val}: ', end='')
        self.print_list()
    
    def linear_search(self, target):
        current = self.head
        index = 0
        while current:
            print(f'Checking node {index}: {current.data}')
            if current.data == target:
                print(f'Found target at index {index}!')
                return True
            current = current.next
            index += 1
        print('Target not found')
        return False

if __name__ == '__main__':
	llist = LinkedList()"""
	
	var action_code = ""
	action_code += "    # Initial elements\n"
	for val in initial_elements:
		action_code += "    llist.insert_end(%d)\n" % val
	if initial_elements.size() > 0:
		action_code += "    print('Initial list: ', end='')\n"
		action_code += "    llist.print_list()\n\n"
	
	var step = 1
	for action in action_history:
		if action["type"] == "insert":
			if action["index"] == 0:
				action_code += "    # Step %d: Insert at beginning\n" % step
				action_code += "    llist.insert_beginning(%d)\n" % action["value"]
			elif action["index"] == initial_elements.size():
				action_code += "    # Step %d: Insert at end\n" % step
				action_code += "    llist.insert_end(%d)\n" % action["value"]
			else:
				action_code += "    # Step %d: Insert at index %d\n" % [step, action["index"]]
				action_code += "    llist.insert_at_index(%d, %d)\n" % [action["index"], action["value"]]
			step += 1
		elif action["type"] == "delete":
			if action["index"] == 0:
				action_code += "    # Step %d: Delete at beginning\n" % step
				action_code += "    llist.delete_beginning()\n"
			elif action["index"] == initial_elements.size() - 1:
				action_code += "    # Step %d: Delete at end\n" % step
				action_code += "    llist.delete_end()\n"
			else:
				action_code += "    # Step %d: Delete at index %d\n" % [step, action["index"]]
				action_code += "    llist.delete_at_index(%d)\n" % action["index"]
			step += 1
		elif action["type"] == "update":
			action_code += "    # Step %d: Update at index %d to %d\n" % [step, action["index"], action["new_value"]]
			action_code += "    llist.update_at_index(%d, %d)\n" % [action["index"], action["new_value"]]
			step += 1
		elif action["type"] == "search":
			action_code += "    # Step %d: Search for %d\n" % [step, action["value"]]
			action_code += "    llist.linear_search(%d)\n" % action["value"]
			step += 1
	
	return base_code + "\n" + action_code

func _gen_java_code() -> String:
	var base_code = """/* Linked List Simulation - Operations Log */
import java.util.*;

class Node {
	int data;
	Node next;
	Node(int val) { data = val; next = null; }
}

class LinkedList {
	Node head;
	LinkedList() { head = null; }
	
	void printList() {
		Node temp = head;
		System.out.print("[");
		while (temp != null) {
			System.out.print(temp.data);
			if (temp.next != null) System.out.print(", ");
			temp = temp.next;
		}
		System.out.println("]");
	}
	
	void insertBeginning(int val) {
		Node newNode = new Node(val);
		newNode.next = head;
		head = newNode;
		System.out.print("After insert " + val + " at beginning: ");
		printList();
	}
	
	void insertEnd(int val) {
		Node newNode = new Node(val);
		if (head == null) {
			head = newNode;
		} else {
			Node temp = head;
			while (temp.next != null) temp = temp.next;
			temp.next = newNode;
		}
		System.out.print("After insert " + val + " at end: ");
		printList();
	}
	
	void insertAtIndex(int index, int val) {
		if (index == 0) {
			insertBeginning(val);
			return;
		}
		Node newNode = new Node(val);
		Node temp = head;
		for (int i = 0; i < index - 1 && temp != null; i++) {
			temp = temp.next;
		}
		if (temp == null) return;
		newNode.next = temp.next;
		temp.next = newNode;
		System.out.print("After insert " + val + " at index " + index + ": ");
		printList();
	}
	
	void deleteBeginning() {
		if (head == null) return;
		head = head.next;
		System.out.print("After delete at beginning: ");
		printList();
	}
	
	void deleteEnd() {
		if (head == null) return;
		if (head.next == null) {
			head = null;
		} else {
			Node temp = head;
			while (temp.next.next != null) temp = temp.next;
			temp.next = null;
		}
		System.out.print("After delete at end: ");
		printList();
	}
	
	void deleteAtIndex(int index) {
		if (index == 0) {
			deleteBeginning();
			return;
		}
		Node temp = head;
		for (int i = 0; i < index - 1 && temp != null; i++) {
			temp = temp.next;
		}
		if (temp == null || temp.next == null) return;
		temp.next = temp.next.next;
		System.out.print("After delete at index " + index + ": ");
		printList();
	}
	
	void updateAtIndex(int index, int newVal) {
		if (head == null) return;
		Node temp = head;
		for (int i = 0; i < index && temp != null; i++) {
			temp = temp.next;
		}
		if (temp == null) return;
		int oldVal = temp.data;
		temp.data = newVal;
		System.out.print("After update at index " + index + " from " + oldVal + " to " + newVal + ": ");
		printList();
	}
	
	void linearSearch(int target) {
		Node current = head;
		int index = 0;
		while (current != null) {
			System.out.println("Checking node " + index + ": " + current.data);
			if (current.data == target) {
				System.out.println("Found target at index " + index + "!");
				return;
			}
			current = current.next;
			index++;
		}
		System.out.println("Target not found");
	}
}

public class Main {
	public static void main(String[] args) {
		LinkedList list = new LinkedList();"""
	
	var action_code = _build_action_code("java")
	return base_code + "\n" + action_code + "\n    }\n}"

func _gen_c_code() -> String:
	var base_code = """/* Linked List Simulation - Operations Log */
#include <stdio.h>
#include <stdlib.h>

struct Node {
	int data;
	struct Node* next;
};

void printList(struct Node* head) {
	struct Node* temp = head;
	printf("[");
	while (temp != NULL) {
		printf("%d", temp->data);
		if (temp->next != NULL) printf(", ");
		temp = temp->next;
	}
	printf("]\\n");
}

struct Node* createNode(int val) {
	struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
	newNode->data = val;
	newNode->next = NULL;
	return newNode;
}

struct Node* insertBeginning(struct Node* head, int val) {
	struct Node* newNode = createNode(val);
	newNode->next = head;
	head = newNode;
	printf("After insert %d at beginning: ", val);
	printList(head);
	return head;
}

struct Node* insertEnd(struct Node* head, int val) {
	struct Node* newNode = createNode(val);
	if (head == NULL) {
		head = newNode;
	} else {
		struct Node* temp = head;
		while (temp->next != NULL) temp = temp->next;
		temp->next = newNode;
	}
	printf("After insert %d at end: ", val);
	printList(head);
	return head;
}

struct Node* insertAtIndex(struct Node* head, int index, int val) {
	if (index == 0) {
		return insertBeginning(head, val);
	}
	struct Node* newNode = createNode(val);
	struct Node* temp = head;
	for (int i = 0; i < index - 1 && temp != NULL; i++) {
		temp = temp->next;
	}
	if (temp == NULL) return head;
	newNode->next = temp->next;
	temp->next = newNode;
	printf("After insert %d at index %d: ", val, index);
	printList(head);
	return head;
}

struct Node* deleteBeginning(struct Node* head) {
	if (head == NULL) return NULL;
	struct Node* temp = head;
	head = head->next;
	free(temp);
	printf("After delete at beginning: ");
	printList(head);
	return head;
}

struct Node* deleteEnd(struct Node* head) {
	if (head == NULL) return NULL;
	if (head->next == NULL) {
		free(head);
		return NULL;
	}
	struct Node* temp = head;
	while (temp->next->next != NULL) temp = temp->next;
	free(temp->next);
	temp->next = NULL;
	printf("After delete at end: ");
	printList(head);
	return head;
}

struct Node* deleteAtIndex(struct Node* head, int index) {
	if (index == 0) {
		return deleteBeginning(head);
	}
	struct Node* temp = head;
	for (int i = 0; i < index - 1 && temp != NULL; i++) {
		temp = temp->next;
	}
	if (temp == NULL || temp->next == NULL) return head;
	struct Node* delNode = temp->next;
	temp->next = delNode->next;
	free(delNode);
	printf("After delete at index %d: ", index);
	printList(head);
	return head;
}

struct Node* updateAtIndex(struct Node* head, int index, int newVal) {
	if (head == NULL) return head;
	struct Node* temp = head;
	for (int i = 0; i < index && temp != NULL; i++) {
		temp = temp->next;
	}
	if (temp == NULL) return head;
	int oldVal = temp->data;
	temp->data = newVal;
	printf("After update at index %d from %d to %d: ", index, oldVal, newVal);
	printList(head);
	return head;
}

void linearSearch(struct Node* head, int target) {
	struct Node* current = head;
	int index = 0;
	while (current != NULL) {
		printf("Checking node %d: %d\\n", index, current->data);
		if (current->data == target) {
			printf("Found target at index %d!\\n", index);
			return;
		}
		current = current->next;
		index++;
	}
	printf("Target not found\\n");
}"""
	
	var action_code = _build_action_code("c")
	return base_code + "\n\nint main() {\n    struct Node* head = NULL;\n" + action_code + "\n    return 0;\n}"

func _build_action_code(lang: String) -> String:
	var code = "\n"
	match lang:
		"cpp":
			code += "    // Initial elements\n"
			for val in initial_elements:
				code += "    list.insertEnd(%d);\n" % val
			if initial_elements.size() > 0:
				code += "    cout << \"Initial list: \";\n"
				code += "    list.printList();\n\n"
			
			var step = 1
			for action in action_history:
				if action["type"] == "insert":
					if action["index"] == 0:
						code += "    // Step %d: Insert at beginning\n    list.insertBeginning(%d);\n" % [step, action["value"]]
					elif action["index"] == initial_elements.size():
						code += "    // Step %d: Insert at end\n    list.insertEnd(%d);\n" % [step, action["value"]]
					else:
						code += "    // Step %d: Insert at index %d\n    list.insertAtIndex(%d, %d);\n" % [step, action["index"], action["index"], action["value"]]
					step += 1
				elif action["type"] == "delete":
					if action["index"] == 0:
						code += "    // Step %d: Delete at beginning\n    list.deleteBeginning();\n" % step
					elif action["index"] == initial_elements.size() - 1:
						code += "    // Step %d: Delete at end\n    list.deleteEnd();\n" % step
					else:
						code += "    // Step %d: Delete at index %d\n    list.deleteAtIndex(%d);\n" % [step, action["index"], action["index"]]
					step += 1
				elif action["type"] == "update":
					code += "    // Step %d: Update at index %d to %d\n    list.updateAtIndex(%d, %d);\n" % [step, action["index"], action["new_value"], action["index"], action["new_value"]]
					step += 1
				elif action["type"] == "search":
					code += "    // Step %d: Search for %d\n    list.linearSearch(%d);\n" % [step, action["value"], action["value"]]
					step += 1
		
		"python":
			code += "    # Initial elements\n"
			for val in initial_elements:
				code += "    llist.insert_end(%d)\n" % val
			if initial_elements.size() > 0:
				code += "    print('Initial list: ', end='')\n"
				code += "    llist.print_list()\n\n"
			
			var step = 1
			for action in action_history:
				if action["type"] == "insert":
					if action["index"] == 0:
						code += "    # Step %d: Insert at beginning\n" % step
						code += "    llist.insert_beginning(%d)\n" % action["value"]
					elif action["index"] == initial_elements.size():
						code += "    # Step %d: Insert at end\n" % step
						code += "    llist.insert_end(%d)\n" % action["value"]
					else:
						code += "    # Step %d: Insert at index %d\n" % [step, action["index"]]
						code += "    llist.insert_at_index(%d, %d)\n" % [action["index"], action["value"]]
					step += 1
				elif action["type"] == "delete":
					if action["index"] == 0:
						code += "    # Step %d: Delete at beginning\n" % step
						code += "    llist.delete_beginning()\n"
					elif action["index"] == initial_elements.size() - 1:
						code += "    # Step %d: Delete at end\n" % step
						code += "    llist.delete_end()\n"
					else:
						code += "    # Step %d: Delete at index %d\n" % [step, action["index"]]
						code += "    llist.delete_at_index(%d)\n" % action["index"]
					step += 1
				elif action["type"] == "update":
					code += "    # Step %d: Update at index %d to %d\n" % [step, action["index"], action["new_value"]]
					code += "    llist.update_at_index(%d, %d)\n" % [action["index"], action["new_value"]]
					step += 1
				elif action["type"] == "search":
					code += "    # Step %d: Search for %d\n" % [step, action["value"]]
					code += "    llist.linear_search(%d)\n" % action["value"]
					step += 1
		
		"java", "c":
			code += "        // Initial elements\n"
			for val in initial_elements:
				if lang == "c":
					code += "        head = insertEnd(head, %d);\n" % val
				else:
					code += "        list.insertEnd(%d);\n" % val
			if initial_elements.size() > 0:
				if lang == "java":
					code += "        System.out.print(\"Initial list: \");\n        list.printList();\n\n"
				else:
					code += "        printf(\"Initial list: \");\n        printList(head);\n\n"
			
			var step = 1
			for action in action_history:
				if action["type"] == "insert":
					if action["index"] == 0:
						code += "        // Step %d: Insert at beginning\n" % step
						if lang == "c": code += "        head = insertBeginning(head, %d);\n" % action["value"]
						else: code += "        list.insertBeginning(%d);\n" % action["value"]
					elif action["index"] == initial_elements.size():
						code += "        // Step %d: Insert at end\n" % step
						if lang == "c": code += "        head = insertEnd(head, %d);\n" % action["value"]
						else: code += "        list.insertEnd(%d);\n" % action["value"]
					else:
						code += "        // Step %d: Insert at index %d\n" % [step, action["index"]]
						if lang == "c": code += "        head = insertAtIndex(head, %d, %d);\n" % [action["index"], action["value"]]
						else: code += "        list.insertAtIndex(%d, %d);\n" % [action["index"], action["value"]]
					step += 1
				elif action["type"] == "delete":
					if action["index"] == 0:
						code += "        // Step %d: Delete at beginning\n" % step
						if lang == "c": code += "        head = deleteBeginning(head);\n"
						else: code += "        list.deleteBeginning();\n"
					elif action["index"] == initial_elements.size() - 1:
						code += "        // Step %d: Delete at end\n" % step
						if lang == "c": code += "        head = deleteEnd(head);\n"
						else: code += "        list.deleteEnd();\n"
					else:
						code += "        // Step %d: Delete at index %d\n" % [step, action["index"]]
						if lang == "c": code += "        head = deleteAtIndex(head, %d);\n" % action["index"]
						else: code += "        list.deleteAtIndex(%d);\n" % action["index"]
					step += 1
				elif action["type"] == "update":
					code += "        // Step %d: Update at index %d to %d\n" % [step, action["index"], action["new_value"]]
					if lang == "c": code += "        head = updateAtIndex(head, %d, %d);\n" % [action["index"], action["new_value"]]
					else: code += "        list.updateAtIndex(%d, %d);\n" % [action["index"], action["new_value"]]
					step += 1
				elif action["type"] == "search":
					code += "        // Step %d: Search for %d\n" % [step, action["value"]]
					if lang == "c": code += "        linearSearch(head, %d);\n" % action["value"]
					else: code += "        list.linearSearch(%d);\n" % action["value"]
					step += 1
	return code

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	if complete_popup: complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

func _show_cpp_popup() -> void:
	cpp_popup.popup_centered()
	cpp_tutorial_step = 0
	
	var code = _generate_code_for_language(current_code_language)
	if cpp_label:
		cpp_label.bbcode_enabled = true
		cpp_label.text = code
	
	if cpp_next_btn: cpp_next_btn.show()
	if cpp_tutorial_panel: cpp_tutorial_panel.show()
	_update_cpp_tutorial()

func _on_cpp_next_pressed() -> void:
	btn_sound.play()
	cpp_tutorial_step += 1
	var active_tutorial_data = tutorial_data_map[current_code_language]
	if cpp_tutorial_step >= active_tutorial_data.size(): cpp_tutorial_step = 0
	_update_cpp_tutorial()

func _update_cpp_tutorial() -> void:
	var active_tutorial_data = tutorial_data_map[current_code_language]
	if active_tutorial_data.is_empty(): return
	
	var data = active_tutorial_data[cpp_tutorial_step]
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
		
		if indices.size() > 0: 
			call_deferred("_scroll_to_highlight", indices[0])

func _scroll_to_highlight(line_index: int) -> void:
	var target_scroll = line_index * 26
	if cpp_scroll:
		var tween = create_tween()
		tween.tween_property(cpp_scroll, "scroll_vertical", target_scroll, 0.2).set_trans(Tween.TRANS_SINE)
	elif cpp_label:
		var scrollbar = cpp_label.get_v_scroll_bar()
		if scrollbar:
			var tween = create_tween()
			tween.tween_property(scrollbar, "value", target_scroll, 0.2).set_trans(Tween.TRANS_SINE)

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
	if not result_popup: return
	
	if result == "PASS":
		result_title.text = "FOUND!"
		result_title.modulate = Color.GREEN
	else:
		result_title.text = "NOT FOUND"
		result_title.modulate = Color.RED
		
	if translate_code_btn: translate_code_btn.show()
	
	score_summary.text = "Nodes Checked: %d" % grade.get("bad_moves", 0)
	accuracy_label.text = "Target: %d" % search_target
	time_used_label.text = "List Size: %d" % main_array.size()
	coins_label.text = "+%d" % grade.get("coins", 0)
	
	result_popup.popup_centered()
	if grade.get("coins", 0) > 0 and coins_anim: coins_anim.play("default")

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
	if size > max_array_size or size < 1: 
		if Queue_full:
			Queue_full.show()
			if anim_sprite: anim_sprite.play("default")
			await get_tree().create_timer(2.0).timeout
			Queue_full.hide()
		return
	max_array_size = size
	config_size_modal.hide()
	_show_config_elements_modal()

func _show_config_elements_modal() -> void:
	element_inputs.clear()
	for child in elements_container.get_children(): child.queue_free()
	
	var grid = GridContainer.new()
	grid.columns = 3 
	grid.add_theme_constant_override("h_separation", 20)
	grid.add_theme_constant_override("v_separation", 20)
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	elements_container.add_child(grid)
	
	var count = max_array_size
	for i in range(count):
		var le = LineEdit.new()
		le.placeholder_text = str(randi_range(1, 99))
		le.custom_minimum_size = Vector2(80, 50) 
		le.alignment = HORIZONTAL_ALIGNMENT_CENTER 
		le.max_length = 3 
		le.text_changed.connect(_on_element_input_changed.bind(le))
		element_inputs.append(le)
		grid.add_child(le)
	config_elements_modal.show()

func _on_element_input_changed(new_text: String, le: LineEdit) -> void:
	var filtered_text = ""
	for i in range(new_text.length()):
		var char = new_text[i]
		if (char >= "0" and char <= "9") or (i == 0 and char == "-"):
			filtered_text += char
	if filtered_text != new_text:
		le.text = filtered_text
		le.caret_column = filtered_text.length()

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
	var count = randi_range(1, max_array_size)
	var arr: Array[int] = []
	for i in count: arr.append(randi_range(1, 99))
	_set_main_ui_enabled(true)
	_initialize_with_elements(arr)

func _on_size_back_pressed(): config_size_modal.hide(); config_modal.show()
func _on_elements_back_pressed(): config_elements_modal.hide(); config_size_modal.show()

# ==============================================
#   INTRO & TUTORIAL SEQUENCE
# ==============================================
func show_introduction():
	if tutorial_overlay: tutorial_overlay.show()
	if not intro_popup: return
	intro_popup.show()
	intro_step = 0
	_update_intro_text()
	_ensure_connected(intro_prev_btn, "pressed", _on_intro_prev_pressed)
	_ensure_connected(intro_next_btn, "pressed", _on_intro_next_pressed)
	_ensure_connected(intro_skip_btn, "pressed", _on_intro_skip_pressed)

func _update_intro_text():
	if intro_label and intro_texts.size() > 0: 
		intro_label.text = intro_texts[intro_step]
	if intro_prev_btn: intro_prev_btn.visible = (intro_step > 0)
	if intro_next_btn: intro_next_btn.text = "Finish" if intro_step >= intro_texts.size() - 1 else "Next"

func _on_intro_next_pressed():
	btn_sound.play()
	if intro_step < intro_texts.size() - 1:
		intro_step += 1
		_update_intro_text()
	else:
		intro_popup.hide()
		if tutorial_overlay: tutorial_overlay.hide()

func _on_intro_prev_pressed():
	btn_sound.play()
	if intro_step > 0:
		intro_step -= 1
		_update_intro_text()

func _on_intro_skip_pressed():
	btn_sound.play()
	intro_popup.hide()
	if tutorial_overlay: tutorial_overlay.hide()

func _on_help_button_pressed():
	btn_sound.play()
	start_tutorial()

func start_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	if tutorial_overlay: tutorial_overlay.show()
	if tutorial_box: tutorial_box.show()
	
	tutorial_sequence = [
		{ "node": insert_menu, "title": "INSERT OPTIONS", "text": "Add new nodes to the Beginning, End, or a Specific Position." },
		{ "node": delete_menu, "title": "DELETE OPTIONS", "text": "Remove nodes from the Beginning, End, or a Specific Position." },
		{ "node": update_menu, "title": "UPDATE OPTIONS", "text": "Update value at a specific position. Automatically traverses to that position." },
		{ "node": sort_btn, "title": "FIND ELEMENT", "text": "Opens a popup to set the Target value you want to search for in the Linked List." },
		{ "node": auto_btn, "title": "SEARCH STEP", "text": "Executes one comparison step manually." },
		{ "node": timeline_btn, "title": "TIMELINE", "text": "View a history of all operations and comparisons." },
		{ "node": simulate_new_btn, "title": "SIMULATE NEW", "text": "Resets the simulation entirely to enter new numbers." },
		{ "node": is_full_indicator, "title": "FULL INDICATOR", "text": "Turns GREEN when list reaches maximum capacity (6 nodes)." },
		{ "node": is_empty_indicator, "title": "EMPTY INDICATOR", "text": "Turns PINK when list is empty, DARK when nodes exist." }
	]
	show_tutorial_step()

func show_tutorial_step() -> void:
	if tutorial_sequence_index >= tutorial_sequence.size():
		end_tutorial()
		return
		
	var step = tutorial_sequence[tutorial_sequence_index]
	if tutorial_text: tutorial_text.text = step["title"] + "\n\n" + step["text"]
	
	var node = step["node"]
	
	if node and pointer_sprite:
		pointer_sprite.texture = POINTER_TEX
		pointer_sprite.show()
		
		var pos_x = node.global_position.x + node.size.x + 30 
		var pos_y = node.global_position.y + (node.size.y / 2)
		pointer_sprite.global_position = Vector2(pos_x, pos_y)
		pointer_sprite.z_index = 100 
		
		if pointer_sprite.has_meta("tween"): pointer_sprite.get_meta("tween").kill()
		var tween = create_tween().set_loops()
		pointer_sprite.set_meta("tween", tween)
		pointer_sprite.offset = Vector2.ZERO
		tween.tween_property(pointer_sprite, "offset:x", -10.0, 0.5).set_trans(Tween.TRANS_SINE)
		tween.tween_property(pointer_sprite, "offset:x", 0.0, 0.5).set_trans(Tween.TRANS_SINE)
	else:
		if pointer_sprite: pointer_sprite.hide()

func _on_next_button_pressed():
	btn_sound.play()
	tutorial_sequence_index += 1
	show_tutorial_step()

func end_tutorial():
	tutorial_in_progress = false
	if tutorial_overlay: tutorial_overlay.hide()
	if pointer_sprite:
		pointer_sprite.hide()
		if pointer_sprite.has_meta("tween"): pointer_sprite.get_meta("tween").kill()

# ==============================================
#   HELPER / UTILS
# ==============================================
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

func _on_no_pressed(): 
	sim_confirmation.hide()
	cpp_code_button.hide()

func _on_yes_pressed():
	sim_confirmation.hide()
	sim_success.show()
	await get_tree().create_timer(1.0).timeout
	sim_success.hide()
	cpp_code_button.hide()
	_show_config_modal()

func _connect_language_buttons():
	if cpp_lang_btn: cpp_lang_btn.pressed.connect(_set_lang_and_show.bind("cpp"))
	if python_lang_btn: python_lang_btn.pressed.connect(_set_lang_and_show.bind("python"))
	if java_lang_btn: java_lang_btn.pressed.connect(_set_lang_and_show.bind("java"))
	if c_lang_btn: c_lang_btn.pressed.connect(_set_lang_and_show.bind("c"))

func _set_lang_and_show(lang: String):
	current_code_language = lang
	_show_cpp_popup()

func _get_modern_stylebox(bg_color: Color = Color(0.15, 0.15, 0.17, 1.0)) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = bg_color
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	style.shadow_color = Color(0, 0, 0, 0.4)
	style.shadow_size = 8
	style.shadow_offset = Vector2(0, 4)
	style.content_margin_left = 15
	style.content_margin_right = 15
	style.content_margin_top = 15
	style.content_margin_bottom = 15
	return style

func _get_modern_button_style(is_hover: bool = false) -> StyleBoxFlat:
	var style = _get_modern_stylebox(Color(0.25, 0.45, 0.85, 1.0) if is_hover else Color(0.2, 0.35, 0.7, 1.0))
	style.shadow_size = 2
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _get_texture_stylebox(tex: Texture2D) -> StyleBoxTexture:
	var style = StyleBoxTexture.new()
	style.texture = tex
	style.texture_margin_left = 16
	style.texture_margin_right = 16
	style.texture_margin_top = 16
	style.texture_margin_bottom = 16
	style.content_margin_left = 20
	style.content_margin_right = 20
	style.content_margin_top = 20
	style.content_margin_bottom = 20
	return style
