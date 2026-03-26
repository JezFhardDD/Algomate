extends Control

# --- LABELS & CONTAINERS ---
@onready var array_size_label: Label = $MarginContainer/HBoxContainer2/TextureRect/Label
@onready var action_modal: Panel = $ArrayActionModal
@onready var modal_title: Label = $ArrayActionModal/ModalContent/ModalTitle
@onready var single_input_row: HBoxContainer = $ArrayActionModal/ModalContent/InputContainer/SingleInputRow
@onready var double_input_container: VBoxContainer = $ArrayActionModal/ModalContent/InputContainer/DoubleInputContainer
@onready var confirm_btn: Button = $ArrayActionModal/ModalContent/ActionButtons/ConfirmButton
@onready var cancel_btn: Button = $ArrayActionModal/ModalContent/ActionButtons/CancelButton
@onready var intro_popup: Panel = $TutorialOverlay/Intro_popup
@onready var index_spin: SpinBox = find_child("IndexSpinBox", true, false)
@onready var value_spin: SpinBox = find_child("ValueSpinBox", true, false)
@onready var insert_index_spin: SpinBox = find_child("InsertIndexSpinBox", true, false)

# --- MAIN BUTTONS (Repurposed) ---
@onready var end_sim_btn: Button = $VBoxContainer/SortButton  # Former Undo button
@onready var simulate_new_btn: Button = $VBoxContainer/WaitingElements  # Former Redo button
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton

# --- NEW ARRAY SIMULATION BUTTONS ---
@onready var access_btn: Button = $VBoxContainer/AccessButton
@onready var insert_end_btn: Button = $VBoxContainer/InsertAtEndButton
@onready var insert_i_btn: Button = $VBoxContainer/InsertAtIButton
@onready var delete_btn: Button = $VBoxContainer/DeleteButton
@onready var replace_btn: Button = $VBoxContainer/ReplaceButton  # NEW: Replace button

# --- LABELS & CONTAINERS ---
@onready var array_container: Control = $QueueContainer
@onready var dequeued_container: Control = $DequeuedContainer

# --- INDICATORS ---
@onready var is_full_indicator: TextureRect = $IsFull  # NEW: isFull indicator
@onready var is_empty_indicator: TextureRect = $IsEmpty  # NEW: isEmpty indicator

# --- POPUPS & MODALS ---
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

# Top Right Buttons
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")
@onready var code_anim: AnimatedSprite2D = get_node_or_null("CppCodeButton/code_anim")

# --- COMPILER INTEGRATION ---
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CompileButton")

# --- SCENE RESOURCES ---
const BLOCK_SCENE := preload("res://BubbleBlock.tscn")
const RESULT_POPUP_SCENE := preload("res://scene/ResultPopup.tscn")

# --- TUTORIAL OVERLAY ---
@onready var tutorial_overlay: CanvasLayer = $TutorialOverlay
@onready var dim_bg: ColorRect = $TutorialOverlay/DimBackground
@onready var tutorial_box: Panel = $TutorialOverlay/TutorialBox
@onready var tutorial_text: Label = $TutorialOverlay/TutorialBox/VBoxContainer/TutorialText
@onready var tutorial_next: Button = $TutorialOverlay/TutorialBox/VBoxContainer/NextButton
@onready var pointer_sprite: Sprite2D = $TutorialOverlay/PointerSprite

# --- INTRO POPUP ---
@onready var intro_label: Label = $TutorialOverlay/Intro_popup/Label
@onready var intro_next_btn: Button = $TutorialOverlay/Intro_popup/next
@onready var intro_skip_btn: Button = $TutorialOverlay/Intro_popup/skip
@onready var intro_prev_btn: Button = $TutorialOverlay/Intro_popup/prev

# --- AUDIO ---
@onready var audio_player = $bgm
@onready var btn_sound = $btn_sound

# --- CONFIGURATION MODALS (For array setup) ---
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

# ADD these new onready vars at the top with the others:
@onready var end_sim_confirmation: Panel = get_node_or_null("End_simulation_confirmation")
@onready var end_sim_yes_btn: Button = get_node_or_null("End_simulation_confirmation/yes")
@onready var end_sim_no_btn: Button = get_node_or_null("End_simulation_confirmation/no")

@onready var cpp_scroll: ScrollContainer = get_node_or_null("CppPopup/VBoxContainer/ScrollContainer")

# --- ARRAY SIMULATION VARIABLES ---
var main_array: Array[int] = []
var block_nodes: Array[Control] = []
var index_labels: Array[Label] = []  # NEW: Store index label nodes
var timeline_log: Array[String] = []
var action_count: int = 0  # Total actions performed
var max_array_size: int = 7  # Default max, will be set during config
var current_array_size: int = 0

# Animation constants
var BLOCK_WIDTH: float = 64.0
var BLOCK_SPACING: float = 15.0
var START_POSITION: Vector2 = Vector2(50, 80)
var INDEX_LABEL_OFFSET: float = 100.0 # NEW: Vertical offset for index labels
var ANIM_SPEED: float = 0.3

# Store code lines with operation type and array state
var code_operations: Array = []  # Store {type, details, array_state}

# For animations
var is_animating: bool = false
var current_tween: Tween = null

# For code generation
var code_lines: Array[String] = []
var current_language: String = "cpp"
var ui_enabled: bool = true  # Track UI state
var tutorial_step: int = 0
var tutorial_nodes = []
# Add these with the other variable declarations around line 100-120
var intro_step: int = 0
var intro_texts = [
	"WELCOME TO ARRAY SIMULATION!\n\nLearn how arrays work through interactive visualization. Arrays are fundamental data structures that store elements in contiguous memory locations.",
	
	"ARRAY BASICS:\n\n• Arrays have a FIXED maximum capacity (5-7)\n• Elements are accessed by INDEX (starting at 0)\n• Inserting/Deleting causes elements to SHIFT\n• Watch the array size indicator to track capacity",
	
	"ACCESS OPERATION:\n\n• Click ACCESS [i] to view an element\n• Enter an index to see its value\n• The element will SHAKE and HIGHLIGHT for 5 seconds\n• Access doesn't modify the array",
	
	"INSERT OPERATIONS:\n\n• INSERT AT END - Adds element to the end (slides in from right)\n• INSERT AT [i] - Adds element at any position (drops in from above)\n• Existing elements shift right to make room\n• Button disabled when array is full",
	
	"DELETE OPERATION:\n\n• DELETE [i] - Removes element at any index\n• The block fades out and slides down\n• Remaining elements shift left to fill the gap\n• Button disabled when array is empty",
	
	"REPLACE OPERATION:\n\n• REPLACE [i] - Updates an existing element with a new value\n• Enter index and new value\n• The block will flash yellow and update instantly\n• Great for modifying values without changing array size",  # NEW: Replace tutorial
	
	"SIMULATION CONTROLS:\n\n• SIMULATE NEW - Start over with new array\n• END SIMULATION - View summary of all actions\n• TIMELINE - See history of all operations\n• CODE VIEW - See your actions translated to code",
	
	"CODE TRANSLATION:\n\nEvery action you perform is translated to real code!\nClick the CODE button to view your simulation in:\n• C++\n• Python\n• Java\n• C"
]
var simulation_ended: bool = false
var _highlight_timers: Dictionary = {}  # track active highlight timers per index
var cpp_walkthrough_step: int = 0
var cpp_walkthrough_steps: Array = []  # Will be built dynamically
var tutorial_in_progress: bool = false

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

# Enum for action modal
enum ActionType { ACCESS, INSERT_AT_END, INSERT_AT_INDEX, DELETE, REPLACE }  # NEW: Added REPLACE

# ==============================================
#   READY FUNCTION
# ==============================================
func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	print("Array Simulation starting...")
	randomize()
	
	# Play background music
	if audio_player:
		audio_player.stream = load("res://assets/sfx/bgm.mp3")
		audio_player.play()
		audio_player.bus = "Music"  # Optional: set audio bus
	
	$DiificultyLabel.hide()
	$VBoxContainer/HBoxContainer/AnimatedSprite2D.hide()
	$VBoxContainer/HBoxContainer/Label2.hide()
	
	end_sim_btn.text = "SIMULATE NEW"
	simulate_new_btn.text = "END SIMULATION"
	
	$TextureRect/front.hide()
	$TextureRect/rear.hide()
	$TextureRect/front2.hide()
	$TextureRect/rear2.hide()
	
	_setup_array_buttons()
	_setup_action_modal()
	_setup_compiler()  # Add compiler setup
	action_modal.set_main_scene(self)
	
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	action_modal.hide()
	if Queue_full: Queue_full.hide()
	if end_sim_confirmation: end_sim_confirmation.hide()
	
	_connect_configuration_buttons()
	if cpp_code_button:
		cpp_code_button.hide()
		if code_anim: code_anim.play("default")
	if sim_yes_btn: sim_yes_btn.pressed.connect(_on_sim_yes_pressed)
	if sim_no_btn: sim_no_btn.pressed.connect(_on_sim_no_pressed)
	
	# Connect end simulation confirmation buttons
	if end_sim_yes_btn: end_sim_yes_btn.pressed.connect(_on_end_sim_yes_pressed)
	if end_sim_no_btn: end_sim_no_btn.pressed.connect(_on_end_sim_no_pressed)
	
	if timeline_btn: timeline_btn.pressed.connect(_on_timeline_pressed)
	if timeline_close_btn: timeline_close_btn.pressed.connect(_on_timeline_close_pressed)
	
	if tutorial_next:
		if not tutorial_next.is_connected("pressed", _on_next_button_pressed):
			tutorial_next.pressed.connect(_on_next_button_pressed)
	
	var close_btn = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton")
	if close_btn and not close_btn.is_connected("pressed", _on_complete_ok_pressed):
		close_btn.pressed.connect(_on_complete_ok_pressed)
	
	if cpp_code_button: cpp_code_button.pressed.connect(_on_cpp_code_button_pressed)
	if cpp_close_btn: cpp_close_btn.pressed.connect(_on_cpp_close_pressed)
	if show_cpp_btn: show_cpp_btn.pressed.connect(_on_show_cpp_pressed)
	
	# FIX: Clean single connection for each button
	if end_sim_btn:
		end_sim_btn.pressed.connect(_on_simulate_new_pressed)  # SortButton = Simulate New
	if simulate_new_btn:
		simulate_new_btn.pressed.connect(_on_end_simulation_pressed)  # WaitingElements = End Simulation
	
	_connect_language_buttons()
	
	if tutorial_next:
		if not tutorial_next.is_connected("pressed", _on_next_button_pressed):
			tutorial_next.pressed.connect(_on_next_button_pressed)
	if help_btn:
		help_btn.pressed.connect(_on_help_button_pressed)
		if q_mark_sprite: q_mark_sprite.play("default")
	
	call_deferred("_show_config_modal")
	call_deferred("show_introduction")
	
	_update_array_size_label()
	_update_indicators()  # NEW: Update indicators on start

func _enter_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Swap width and height to match landscape
	var current_size = get_viewport().get_visible_rect().size
	if current_size.y > current_size.x:  # Still thinks it's portrait
		get_tree().root.content_scale_size = Vector2i(int(current_size.y), int(current_size.x))
		
# ==============================================
#   COMPILER SETUP FUNCTIONS
# ==============================================
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
	var code = _generate_code_for_language(current_language)
	
	# Check if we have cached result for this language
	if compiler_output_popup and compiler_output_popup.has_cached_result(current_language):
		# Show cached result without recompiling
		var cached = compiler_output_popup.get_cached_result(current_language)
		var fake_response = {
			"output": cached.output,
			"error": cached.error,
			"memory": cached.memory,
			"cpu": cached.cpu
		}
		compiler_output_popup.show_output(current_language, fake_response, self, false)
		show_feedback("Using cached result!", Color.YELLOW, Vector2(200, 200))
	else:
		# Compile the code
		_compile_code(code)

func _compile_code(code: String):
	"""Send code to JDoodle API"""
	show_feedback("Compiling...", Color.YELLOW, Vector2(200, 200))
	
	# Get API keys for current language
	var keys = API_KEYS[current_language]
	
	# Prepare API request
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_compile_completed.bind(http_request, current_language))
	
	var url = "https://api.jdoodle.com/v1/execute"
	var headers = ["Content-Type: application/json"]
	
	# Map language to JDoodle API expected format
	var api_language = current_language
	match current_language:
		"python":
			api_language = "python3"  # JDoodle expects "python3" not "python"
	
	var body = JSON.new().stringify({
		"clientId": keys["clientId"],
		"clientSecret": keys["clientSecret"],
		"script": code,
		"language": api_language,
		"versionIndex": _get_version_index(current_language)
	})
	
	print("=== Simulation Compile Request ===")
	print("Language: ", current_language, " → API: ", api_language)
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
	var code = _generate_code_for_language(language)
	_compile_code(code)

func _on_compiler_output_closed():
	"""Called when compiler output popup is closed"""
	print("Compiler output closed")

func reset_cache_for_scene():
	"""Reset compiler cache when starting new simulation"""
	if compiler_output_popup:
		compiler_output_popup.reset_cache_for_scene()
		print("Compiler cache reset for new simulation")

# ==============================================
#   UI STATE FUNCTIONS
# ==============================================
func set_ui_enabled(enabled: bool):
	ui_enabled = enabled
	
	var buttons = [
		access_btn, insert_end_btn, insert_i_btn, delete_btn, replace_btn,  # NEW: Added replace_btn
		end_sim_btn, simulate_new_btn, timeline_btn, help_btn,
		cpp_code_button
	]
	
	for btn in buttons:
		if btn:
			btn.disabled = not enabled

func _set_config_ui_disabled(disabled: bool):
	var buttons = [
		access_btn, insert_end_btn, insert_i_btn, delete_btn, replace_btn,  # NEW: Added replace_btn
		end_sim_btn, simulate_new_btn, timeline_btn
	]
	for btn in buttons:
		if btn:
			btn.disabled = disabled

func _apply_simulation_ended_state():
	simulation_ended = true
	if access_btn: access_btn.disabled = true
	if insert_end_btn: insert_end_btn.disabled = true
	if insert_i_btn: insert_i_btn.disabled = true
	if delete_btn: delete_btn.disabled = true
	if replace_btn: replace_btn.disabled = true  # NEW: Disable replace
	if simulate_new_btn: simulate_new_btn.disabled = true  # This is End Simulation btn
	if end_sim_btn: end_sim_btn.disabled = false   # Simulate New - still enabled
	if timeline_btn: timeline_btn.disabled = false

# ==============================================
#   INPUT HANDLING
# ==============================================
func _input(event):
	if not ui_enabled and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Never block if any config modal is visible
			if config_modal.visible or config_size_modal.visible or config_elements_modal.visible:
				return
			# Never block intro popup
			if intro_popup and intro_popup.visible:
				return
			# Never block tutorial box
			if tutorial_box and tutorial_box.visible:
				return
			accept_event()

# ==============================================
#   BUTTON SETUP FUNCTIONS
# ==============================================
func _setup_array_buttons():
	if access_btn:
		access_btn.text = "ACCESS [i]"
		access_btn.pressed.connect(_on_access_button_pressed)
	
	if insert_end_btn:
		insert_end_btn.text = "INSERT AT END"
		insert_end_btn.pressed.connect(_on_insert_end_button_pressed)
	
	if insert_i_btn:
		insert_i_btn.text = "INSERT AT [i]"
		insert_i_btn.pressed.connect(_on_insert_i_button_pressed)
	
	if delete_btn:
		delete_btn.text = "DELETE [i]"
		delete_btn.pressed.connect(_on_delete_button_pressed)
	
	if replace_btn:  # NEW: Setup replace button
		replace_btn.text = "REPLACE [i]"
		replace_btn.pressed.connect(_on_replace_button_pressed)

func _setup_action_modal():
	print("Setting up action modal...")
	print("Action modal children: ", action_modal.get_children())
	if not action_modal:
		print("Warning: action_modal not found")
		return
	if action_modal:
		# Optionally connect to any custom signals from the modal
		pass
	if cancel_btn:
		cancel_btn.pressed.connect(_on_action_modal_cancel)
	if confirm_btn:
		confirm_btn.pressed.connect(_on_action_modal_confirm)
	
	# Check and configure spin boxes with null safety
	if index_spin:
		index_spin.min_value = 0
		index_spin.max_value = 0  # Will be updated dynamically
		index_spin.step = 1
		index_spin.rounded = true
	else:
		print("Warning: index_spin not found")
	
	if value_spin:
		value_spin.min_value = 1
		value_spin.max_value = 99
		value_spin.step = 1
		value_spin.rounded = true
	else:
		print("Warning: value_spin not found")
	
	if insert_index_spin:
		insert_index_spin.min_value = 0
		insert_index_spin.max_value = 0
		insert_index_spin.step = 1
		insert_index_spin.rounded = true
	else:
		print("Warning: insert_index_spin not found")
	
	# Hide modal initially
	if action_modal:
		action_modal.hide()

# ==============================================
#   ARRAY CONFIGURATION
# ==============================================
func _connect_configuration_buttons():
	if yes_btn: yes_btn.pressed.connect(_on_config_yes_pressed)
	if no_btn: no_btn.pressed.connect(_on_config_no_pressed)
	if size_back_btn: size_back_btn.pressed.connect(_on_size_back_pressed)
	if size_next_btn: size_next_btn.pressed.connect(_on_size_next_pressed)
	if elements_back_btn: elements_back_btn.pressed.connect(_on_elements_back_pressed)
	if elements_done_btn: elements_done_btn.pressed.connect(_on_elements_done_pressed)

func _show_config_modal():
	# FIX 3: Do NOT call set_ui_enabled(false) here — _input will block
	# left-side buttons anyway since ui_enabled stays false from sim flow.
	# Instead just disable the left buttons directly and keep modal clickable.
	_set_config_ui_disabled(true)
	
	# Reconnect every time to fix simulate-new flow
	if yes_btn:
		if yes_btn.pressed.is_connected(_on_config_yes_pressed):
			yes_btn.pressed.disconnect(_on_config_yes_pressed)
		yes_btn.pressed.connect(_on_config_yes_pressed)
	if no_btn:
		if no_btn.pressed.is_connected(_on_config_no_pressed):
			no_btn.pressed.disconnect(_on_config_no_pressed)
		no_btn.pressed.connect(_on_config_no_pressed)
	
	config_modal.show()

func _on_config_yes_pressed():
	btn_sound.play()
	config_modal.hide()
	# FIX 3: Reconnect size modal next button too
	if size_next_btn:
		if size_next_btn.pressed.is_connected(_on_size_next_pressed):
			size_next_btn.pressed.disconnect(_on_size_next_pressed)
		size_next_btn.pressed.connect(_on_size_next_pressed)
	if size_back_btn:
		if size_back_btn.pressed.is_connected(_on_size_back_pressed):
			size_back_btn.pressed.disconnect(_on_size_back_pressed)
		size_back_btn.pressed.connect(_on_size_back_pressed)
	config_size_modal.show()

func _on_config_no_pressed():
	btn_sound.play()
	config_modal.hide()
	var size = randi_range(5, 7)
	var arr = []
	for i in range(size):
		arr.append(randi_range(1, 99))
	_initialize_array(arr)
	set_ui_enabled(true)
	_set_config_ui_disabled(false)
	simulation_ended = false

func _on_size_next_pressed():
	btn_sound.play()
	max_array_size = int(size_input.value)
	config_size_modal.hide()
	# FIX 3: Reconnect elements modal buttons too
	if elements_done_btn:
		if elements_done_btn.pressed.is_connected(_on_elements_done_pressed):
			elements_done_btn.pressed.disconnect(_on_elements_done_pressed)
		elements_done_btn.pressed.connect(_on_elements_done_pressed)
	if elements_back_btn:
		if elements_back_btn.pressed.is_connected(_on_elements_back_pressed):
			elements_back_btn.pressed.disconnect(_on_elements_back_pressed)
		elements_back_btn.pressed.connect(_on_elements_back_pressed)
	_show_config_elements_modal()


func _on_size_back_pressed():
	btn_sound.play()
	config_size_modal.hide()
	config_modal.show()


# FIX: Bigger inputs, 2 per row using GridContainer columns = 2
func _show_config_elements_modal():
	for child in elements_container.get_children():
		child.queue_free()
	
	var grid = GridContainer.new()
	grid.columns = 2  # 2 per row
	grid.add_theme_constant_override("h_separation", 20)
	grid.add_theme_constant_override("v_separation", 20)
	elements_container.add_child(grid)
	
	for i in range(max_array_size):
		var element_box = VBoxContainer.new()
		element_box.custom_minimum_size = Vector2(270, 0)
		
		var label = Label.new()
		label.text = "Index %d" % i
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		var font = load("res://assets/font/Planes_ValMore.ttf")
		if font:
			label.add_theme_font_override("font", font)
		label.add_theme_font_size_override("font_size", 20)
		
		var line_edit = LineEdit.new()
		line_edit.placeholder_text = "1-99"
		line_edit.add_theme_color_override("font_placeholder_color", Color(1, 1, 1, 0.5))
		line_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
		line_edit.max_length = 3
		line_edit.custom_minimum_size = Vector2(160, 70)  # Bigger
		line_edit.text_changed.connect(_on_element_input_changed.bind(line_edit))
		
		var style = StyleBoxTexture.new()
		style.texture = load("res://assets/CONTAINER.png")
		style.texture_margin_left = 8
		style.texture_margin_top = 8
		style.texture_margin_right = 8
		style.texture_margin_bottom = 8
		line_edit.add_theme_stylebox_override("normal", style)
		
		element_box.add_child(label)
		element_box.add_child(line_edit)
		grid.add_child(element_box)
	
	config_elements_modal.show()

func _on_element_input_changed(new_text: String, line_edit: LineEdit):
	if new_text.is_empty():
		return
	if not new_text.is_valid_int():
		line_edit.text = new_text.trim_suffix(new_text[-1])
	else:
		var val = int(new_text)
		if val < 1 or val > 99:
			line_edit.text = new_text.trim_suffix(new_text[-1])

func _on_elements_done_pressed():
	btn_sound.play()
	
	var arr: Array = []
	var grid = elements_container.get_child(0)
	
	for child in grid.get_children():
		var element_box = child as VBoxContainer
		if element_box and element_box.get_child_count() > 1:
			var line_edit = element_box.get_child(1) as LineEdit
			if line_edit and not line_edit.text.is_empty() and line_edit.text.is_valid_int():
				arr.append(int(line_edit.text))
	
	config_elements_modal.hide()
	_set_config_ui_disabled(false)
	_initialize_array(arr)
	set_ui_enabled(true)
	simulation_ended = false  # Reset ended state on new simulation

func _on_elements_back_pressed():
	btn_sound.play()
	config_elements_modal.hide()
	config_size_modal.show()

# ==============================================
#   ARRAY INITIALIZATION & VISUALIZATION
# ==============================================
func _initialize_array(elements):
	var typed_array: Array[int] = []
	for val in elements:
		typed_array.append(int(val))
	
	main_array = typed_array
	current_array_size = main_array.size()
	
	for child in array_container.get_children():
		child.queue_free()
	
	block_nodes.clear()
	index_labels.clear()
	timeline_log.clear()
	action_count = 0
	code_operations.clear()  # Clear operations list
	code_lines.clear()
	
	# Reset cache for new simulation
	reset_cache_for_scene()
	
	# FIX 2: Log initial state to timeline
	timeline_log.append("[color=cyan]--- Simulation Started ---[/color]")
	timeline_log.append("[color=cyan]Initial array: [%s] (size %d/%d)[/color]" % [_array_to_string(main_array), current_array_size, max_array_size])
	
	# Store initial array state
	_add_code_line("Initial list = " + _array_to_string(main_array), main_array.duplicate())
	
	await get_tree().process_frame
	
	_create_blocks_from_array()
	_update_array_size_label()
	_update_indicators()
	show_feedback("Array Simulation Ready", Color.GREEN, Vector2(500, 300))
	_update_button_states()
	_update_timeline_display()

func _create_blocks_from_array():
	var current_x = START_POSITION.x
	var index_font = load("res://assets/font/Planes_ValMore.ttf")  # NEW: Load font for indices
	
	for i in range(main_array.size()):
		# Create block
		var new_block = BLOCK_SCENE.instantiate()
		new_block.value = main_array[i]
		new_block.position = Vector2(current_x, START_POSITION.y)
		new_block.draggable = false  # Blocks not draggable in array simulation
		
		# Fade in animation
		new_block.modulate.a = 0.0
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(new_block, "modulate:a", 1.0, 0.5)
		
		array_container.add_child(new_block)
		block_nodes.append(new_block)
		
		# NEW: Create index label below the block
		var index_label = Label.new()
		index_label.text = str(i)
		index_label.position = Vector2(current_x + (new_block.size.x / 2) - 15, START_POSITION.y + INDEX_LABEL_OFFSET)
		index_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		index_label.add_theme_font_override("font", index_font)
		index_label.add_theme_font_size_override("font_size", 32)  # Large font size (32)
		index_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		index_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		index_label.add_theme_constant_override("outline_size", 4)
		array_container.add_child(index_label)
		index_labels.append(index_label)
		
		current_x += new_block.size.x + BLOCK_SPACING

# NEW: Update indicator colors based on array state
# NEW: Update indicator colors based on array state
# Update indicator colors based on array state
# Update indicator colors based on array state (with debug)
func _update_indicators():
	# Get the nodes
	var is_full_node = get_node_or_null("isFull") as TextureRect
	var is_empty_node = get_node_or_null("isEmpty") as TextureRect
	
	print("Updating indicators - Full node: ", is_full_node, " Empty node: ", is_empty_node)
	print("Array size: ", current_array_size, "/", max_array_size)
	
	if not is_full_node or not is_empty_node:
		print("ERROR: Could not find indicator nodes!")
		return
	
	# Update isFull indicator
	if current_array_size >= max_array_size:
		# Array is FULL: bright green
		is_full_node.modulate = Color(0, 1, 0, 1)
		print("Array FULL - setting isFull to green")
	else:
		# Array NOT full: dark gray
		is_full_node.modulate = Color(0.3, 0.3, 0.3, 1)
		print("Array NOT full - setting isFull to dark gray")
	
	# Update isEmpty indicator
	if current_array_size == 0:
		# Array is EMPTY: bright pink
		is_empty_node.modulate = Color(1, 0.5, 0.8, 1)
		print("Array EMPTY - setting isEmpty to pink")
	else:
		# Array NOT empty: dark gray
		is_empty_node.modulate = Color(0.3, 0.3, 0.3, 1)
		print("Array NOT empty - setting isEmpty to dark gray")

# NEW: Update index label positions (called after animations)
func _update_index_labels():
	var current_x = START_POSITION.x
	var index_font = load("res://assets/font/Planes_ValMore.ttf")
	
	for i in range(block_nodes.size()):
		var block = block_nodes[i]
		var label = index_labels[i]
		
		# Update label text (index might have changed after insert/delete)
		label.text = str(i)
		
		# Update position to stay below block
		label.position = Vector2(current_x + (block.size.x / 2) - 15, START_POSITION.y + INDEX_LABEL_OFFSET)
		
		current_x += block.size.x + BLOCK_SPACING

# ==============================================
#   UI UPDATE FUNCTIONS
# ==============================================
func _update_array_size_label():
	var label = get_node_or_null("MarginContainer/HBoxContainer2/TextureRect/Label")
	if label:
		label.text = "Array Size: %d/%d" % [current_array_size, max_array_size]

func _update_button_states():
	# Buttons are ALWAYS fully visible - no visual indication of state
	if insert_end_btn:
		insert_end_btn.modulate = Color(1, 1, 1, 1.0)  # Always full opacity
	
	if insert_i_btn:
		insert_i_btn.modulate = Color(1, 1, 1, 1.0)
	
	if delete_btn:
		delete_btn.modulate = Color(1, 1, 1, 1.0)
	
	if access_btn:
		access_btn.modulate = Color(1, 1, 1, 1.0)
	
	if replace_btn:  # NEW: Replace button always visible
		replace_btn.modulate = Color(1, 1, 1, 1.0)
	
	# Don't disable buttons - they should always be clickable
	insert_end_btn.disabled = false
	insert_i_btn.disabled = false
	delete_btn.disabled = false
	access_btn.disabled = false
	replace_btn.disabled = false  # NEW: Always enabled, validation happens in action

func show_status_message(message: String):
	# Fix this - it was hardcoded to "Array Simulation Ready"
	show_feedback(message, Color.GREEN, Vector2(500, 300))

# ==============================================
#   ACTION HANDLERS
# ==============================================
func _on_access_button_pressed():
	btn_sound.play()
	if current_array_size == 0:
		show_feedback("Array is empty! No elements to access.", Color.ORANGE, get_global_mouse_position())
		return
	
	action_modal.show_for_action(ActionType.ACCESS, current_array_size - 1, 
		func(index): _execute_access(index))

func _on_insert_end_button_pressed():
	btn_sound.play()
	if current_array_size >= max_array_size:
		show_feedback("Array is full! Can't insert more elements.", Color.ORANGE, get_global_mouse_position())
		return
	
	action_modal.show_for_action(ActionType.INSERT_AT_END, max_array_size - current_array_size,
		func(value): _execute_insert_end(value))

func _on_insert_i_button_pressed():
	btn_sound.play()
	if current_array_size >= max_array_size:
		show_feedback("Array is full! Can't insert more elements.", Color.ORANGE, get_global_mouse_position())
		return
	
	action_modal.show_for_action(ActionType.INSERT_AT_INDEX, current_array_size,
		func(value, index): _execute_insert_at_index(value, index))

func _on_delete_button_pressed():
	btn_sound.play()
	if current_array_size == 0:
		show_feedback("Array is empty! Nothing to delete.", Color.ORANGE, get_global_mouse_position())
		return
	
	action_modal.show_for_action(ActionType.DELETE, current_array_size - 1,
		func(index): _execute_delete(index))

# NEW: Replace button handler
func _on_replace_button_pressed():
	btn_sound.play()
	if current_array_size == 0:
		show_feedback("Array is empty! Nothing to replace.", Color.ORANGE, get_global_mouse_position())
		return
	
	action_modal.show_for_action(ActionType.REPLACE, current_array_size - 1,
		func(value, index): _execute_replace(index, value))

func _execute_access(index: int):
	if index < 0 or index >= current_array_size:
		show_feedback("Index out of bounds!", Color.RED, Vector2(500, 300))
		return
	
	# Extra safety: block_nodes must also have this index
	if index >= block_nodes.size():
		show_feedback("Index out of bounds!", Color.RED, Vector2(500, 300))
		return
	
	action_count += 1
	var value = main_array[index]
	
	timeline_log.append("[color=yellow]Accessed element at [%d]: %d[/color]" % [index, value])
	_add_code_line("Access at index[%d] = %d" % [index, value])
	_highlight_block(index, 1.0)
	show_feedback("Value at [%d] = %d" % [index, value], Color.YELLOW, block_nodes[index].global_position)
	_update_array_size_label()
	_update_timeline_display()
	_update_indicators()  # NEW: Update indicators

func _execute_insert_end(value: int):
	if current_array_size >= max_array_size:
		show_feedback("Array is full!", Color.ORANGE, Vector2(500, 300))
		return
	
	action_count += 1
	main_array.append(value)
	current_array_size += 1
	_animate_insert_end(value)
	timeline_log.append("[color=green]Inserted %d at end[/color]" % value)
	
	# Store operation with array state AFTER the operation
	_add_code_line("After insert %d at end = %s" % [value, _array_to_string(main_array)], main_array.duplicate())
	
	show_feedback("Inserted %d at end" % value, Color.GREEN, Vector2(500, 350))
	_update_button_states()
	_update_array_size_label()
	_update_timeline_display()
	_update_indicators()

func _execute_insert_at_index(value: int, index: int):
	if index < 0 or index > current_array_size:
		show_feedback("Index out of bounds!", Color.RED, Vector2(500, 300))
		return
	if current_array_size >= max_array_size:
		show_feedback("Array is full!", Color.ORANGE, Vector2(500, 300))
		return
	
	action_count += 1
	main_array.insert(index, value)
	current_array_size += 1
	_animate_insert_at_index(index, value)
	timeline_log.append("[color=green]Inserted %d at index [%d][/color]" % [value, index])
	
	# Store operation with array state AFTER the operation
	_add_code_line("After insert %d at index[%d] = %s" % [value, index, _array_to_string(main_array)], main_array.duplicate())
	
	show_feedback("Inserted %d at index [%d]" % [value, index], Color.GREEN, Vector2(500, 350))
	_update_button_states()
	_update_array_size_label()
	_update_timeline_display()
	_update_indicators()

func _execute_delete(index: int):
	if index < 0 or index >= current_array_size:
		show_feedback("Index out of bounds!", Color.RED, Vector2(500, 300))
		return
	
	# FIX 4: Cancel any active highlight timer for this block
	if _highlight_timers.has(index):
		if is_instance_valid(_highlight_timers[index]):
			_highlight_timers[index].cancel()
		_highlight_timers.erase(index)
		# Also turn off highlight before deletion
		if index < block_nodes.size() and is_instance_valid(block_nodes[index]):
			block_nodes[index].set_highlight(false)
	
	action_count += 1
	var deleted_value = main_array[index]
	main_array.remove_at(index)
	current_array_size -= 1
	_animate_delete(index)
	timeline_log.append("[color=red]Deleted element at [%d]: %d[/color]" % [index, deleted_value])
	
	# Store operation with array state AFTER the operation
	_add_code_line("After delete at index[%d] = %s" % [index, _array_to_string(main_array)], main_array.duplicate())
	
	show_feedback("Deleted element at [%d]" % index, Color.ORANGE, Vector2(500, 350))
	_update_button_states()
	_update_array_size_label()
	_update_timeline_display()
	_update_indicators()

# NEW: Execute replace operation
func _execute_replace(index: int, value: int):
	if index < 0 or index >= current_array_size:
		show_feedback("Index out of bounds!", Color.RED, Vector2(500, 300))
		return
	
	if value < 1 or value > 99:
		show_feedback("Value must be between 1 and 99!", Color.ORANGE, Vector2(500, 300))
		return
	
	action_count += 1
	var old_value = main_array[index]
	main_array[index] = value
	
	# Update block visual
	if index < block_nodes.size():
		block_nodes[index].value = value
		# Flash animation for replace
		var flash_tween = create_tween().set_parallel()
		flash_tween.tween_property(block_nodes[index], "modulate", Color.YELLOW, 0.1)
		flash_tween.tween_property(block_nodes[index], "modulate", Color.WHITE, 0.2).set_delay(0.1)
	
	timeline_log.append("[color=cyan]Replaced element at [%d]: %d → %d[/color]" % [index, old_value, value])
	
	# Store operation with array state AFTER the operation
	_add_code_line("After replace at index[%d] from %d to %d = %s" % [index, old_value, value, _array_to_string(main_array)], main_array.duplicate())
	
	show_feedback("Replaced [%d]: %d → %d" % [index, old_value, value], Color.CYAN, Vector2(500, 350))
	_update_array_size_label()
	_update_timeline_display()
	_update_indicators()

# ==============================================
#   ANIMATIONS
# ==============================================
func _animate_insert_end(value: int):
	is_animating = true
	
	# Calculate position for new block
	var new_x = START_POSITION.x
	for i in range(main_array.size() - 1):  # Skip the new one
		new_x += block_nodes[i].size.x + BLOCK_SPACING
	
	# Create new block off-screen to the right
	var new_block = BLOCK_SCENE.instantiate()
	new_block.value = value
	new_block.position = Vector2(new_x + 200, START_POSITION.y)  # Start off-screen
	new_block.modulate.a = 1.0
	new_block.draggable = false
	array_container.add_child(new_block)
	
	# NEW: Create index label for new block
	var index_label = Label.new()
	index_label.text = str(block_nodes.size())
	index_label.position = Vector2(new_x + (new_block.size.x / 2) - 15, START_POSITION.y + INDEX_LABEL_OFFSET)
	var index_font = load("res://assets/font/Planes_ValMore.ttf")
	index_label.add_theme_font_override("font", index_font)
	index_label.add_theme_font_size_override("font_size", 32)
	index_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	index_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	index_label.add_theme_constant_override("outline_size", 4)
	array_container.add_child(index_label)
	
	# Slide in animation
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(new_block, "position:x", new_x, ANIM_SPEED)
	tween.parallel().tween_property(index_label, "position:x", new_x + (new_block.size.x / 2) - 15, ANIM_SPEED)
	
	# Fade in (already visible, but we'll do a quick scale pop)
	tween.parallel().tween_property(new_block, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(new_block, "scale", Vector2(1.0, 1.0), 0.1)
	
	block_nodes.append(new_block)
	index_labels.append(index_label)
	
	await tween.finished
	is_animating = false
	
	# Update all index labels after insertion
	_update_index_labels()

func _animate_insert_at_index(index: int, value: int):
	is_animating = true
	
	# Shift existing blocks to the right first
	var tweens = []
	for i in range(index, block_nodes.size()):
		var block = block_nodes[i]
		var target_x = START_POSITION.x
		for j in range(i + 1):  # +1 because we're inserting before them
			target_x += block_nodes[j].size.x + BLOCK_SPACING
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(block, "position:x", target_x, ANIM_SPEED * 0.7)
		tweens.append(tween)
		
		# Also shift index labels
		var label = index_labels[i]
		var label_target_x = target_x + (block.size.x / 2) - 15
		tween.parallel().tween_property(label, "position:x", label_target_x, ANIM_SPEED * 0.7)
	
	# Wait for shifts to complete
	if tweens.size() > 0:
		await tweens[-1].finished
	
	# Calculate position for new block
	var new_x = START_POSITION.x
	for i in range(index):
		new_x += block_nodes[i].size.x + BLOCK_SPACING
	
	# Create new block above
	var new_block = BLOCK_SCENE.instantiate()
	new_block.value = value
	new_block.position = Vector2(new_x, START_POSITION.y - 100)  # Start above
	new_block.modulate.a = 1.0
	new_block.draggable = false
	array_container.add_child(new_block)
	
	# Create index label for new block
	var index_label = Label.new()
	index_label.text = str(index)
	index_label.position = Vector2(new_x + (new_block.size.x / 2) - 15, START_POSITION.y + INDEX_LABEL_OFFSET - 100)
	var index_font = load("res://assets/font/Planes_ValMore.ttf")
	index_label.add_theme_font_override("font", index_font)
	index_label.add_theme_font_size_override("font_size", 32)
	index_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	index_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	index_label.add_theme_constant_override("outline_size", 4)
	array_container.add_child(index_label)
	
	# Insert into block_nodes and index_labels
	block_nodes.insert(index, new_block)
	index_labels.insert(index, index_label)
	
	# Drop down animation
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(new_block, "position:y", START_POSITION.y, ANIM_SPEED)
	tween.parallel().tween_property(index_label, "position:y", START_POSITION.y + INDEX_LABEL_OFFSET, ANIM_SPEED)
	tween.parallel().tween_property(new_block, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(new_block, "scale", Vector2(1.0, 1.0), 0.1)
	
	await tween.finished
	is_animating = false
	
	# Update all index labels after insertion
	_update_index_labels()

func _animate_delete(index: int):
	is_animating = true
	
	var deleted_block = block_nodes[index]
	var deleted_label = index_labels[index]
	
	# Fade out and slide down animation
	var tween = create_tween().set_parallel()
	tween.tween_property(deleted_block, "modulate:a", 0.0, ANIM_SPEED)
	tween.tween_property(deleted_block, "position:y", START_POSITION.y + 100, ANIM_SPEED)
	tween.tween_property(deleted_block, "scale", Vector2(0.8, 0.8), ANIM_SPEED)
	tween.tween_property(deleted_label, "modulate:a", 0.0, ANIM_SPEED)
	tween.tween_property(deleted_label, "position:y", START_POSITION.y + INDEX_LABEL_OFFSET + 100, ANIM_SPEED)
	
	await tween.finished
	
	# Remove the block and label
	deleted_block.queue_free()
	deleted_label.queue_free()
	block_nodes.remove_at(index)
	index_labels.remove_at(index)
	
	# Shift remaining blocks left
	var tweens = []
	for i in range(index, block_nodes.size()):
		var block = block_nodes[i]
		var target_x = START_POSITION.x
		for j in range(i):
			target_x += block_nodes[j].size.x + BLOCK_SPACING
		var shift_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		shift_tween.tween_property(block, "position:x", target_x, ANIM_SPEED)
		tweens.append(shift_tween)
		
		# Shift labels
		var label = index_labels[i]
		var label_target_x = target_x + (block.size.x / 2) - 15
		shift_tween.parallel().tween_property(label, "position:x", label_target_x, ANIM_SPEED)
	
	if tweens.size() > 0:
		await tweens[-1].finished
	
	is_animating = false
	
	# Update index labels after deletion
	_update_index_labels()

func _highlight_block(index: int, duration: float):
	if index < 0 or index >= block_nodes.size():
		return
	
	var block = block_nodes[index]
	if not is_instance_valid(block):
		return
	
	# Cancel any existing highlight timer for this index
	if _highlight_timers.has(index):
		if is_instance_valid(_highlight_timers[index]):
			_highlight_timers[index].cancel()
		_highlight_timers.erase(index)
	
	block.set_highlight(true)
	
	# Shake animation
	var original_x = block.position.x
	var shake_tween = create_tween().set_parallel(false)
	for i in range(3):
		var offset = 5 if i % 2 == 0 else -5
		shake_tween.tween_property(block, "position:x", original_x + offset, 0.05)
		shake_tween.tween_property(block, "position:x", original_x, 0.05)
	
	# Use a stored timer so we can cancel it if block gets deleted
	var timer = get_tree().create_timer(duration)
	_highlight_timers[index] = timer
	
	await timer.timeout
	
	# Only remove highlight if block still exists
	if is_instance_valid(block):
		block.set_highlight(false)
	
	if _highlight_timers.has(index):
		_highlight_timers.erase(index)

# ==============================================
#   ACTION MODAL FUNCTIONS
# ==============================================
func _on_action_modal_confirm():
	# This is handled by the callbacks in the button handlers
	action_modal.hide()

func _on_action_modal_cancel():
	btn_sound.play()
	action_modal.hide()

# ==============================================
#   SIMULATION CONTROL
# ==============================================
func _on_end_simulation_pressed():
	btn_sound.play()
	if end_sim_confirmation:
		end_sim_confirmation.show()
	else:
		# Fallback if node not found
		_show_summary_popup()

func _on_simulate_new_pressed():
	btn_sound.play()
	sim_confirmation.show()

func _on_sim_yes_pressed():
	btn_sound.play()
	sim_confirmation.hide()
	sim_success.show()
	simulation_ended = false
	# FIX 1: Hide code button on new simulation
	if cpp_code_button:
		cpp_code_button.hide()
	show_feedback("Creating new simulation...", Color.GREEN, Vector2(500, 300))
	await get_tree().create_timer(2.0).timeout
	sim_success.hide()
	_show_config_modal()

func _on_sim_no_pressed():
	btn_sound.play()
	sim_confirmation.hide()

func _on_end_sim_yes_pressed():
	btn_sound.play()
	if end_sim_confirmation: end_sim_confirmation.hide()
	timeline_log.append("[color=orange]--- Simulation Ended ---[/color]")
	timeline_log.append("[color=orange]Final array: [%s] | Total actions: %d[/color]" % [_array_to_string(main_array), action_count])
	_update_timeline_display()
	_show_summary_popup()
	_apply_simulation_ended_state()
	# FIX 1: Show code button now
	if cpp_code_button:
		cpp_code_button.show()
		if code_anim: code_anim.play("default")

func _on_end_sim_no_pressed():
	btn_sound.play()
	if end_sim_confirmation: end_sim_confirmation.hide()

func _show_summary_popup():
	if not complete_popup:
		return
	
	# Update process label with summary
	var summary = "Total Actions: %d\n\nFinal Array: %s" % [action_count, _array_to_string(main_array)]
	if process_label:
		process_label.text = summary
	
	# Update code view with final state
	_add_code_line("Simulation ended. Final array = " + _array_to_string(main_array))
	
	complete_popup.popup_centered()
	
	# Show code button
	if cpp_code_button:
		cpp_code_button.show()
		if code_anim: code_anim.play("default")
	
	show_feedback("Simulation Complete!", Color.GREEN, Vector2(500, 300))

# ==============================================
#   TIMELINE FUNCTIONS
# ==============================================
func _on_timeline_pressed():
	btn_sound.play()
	if timeline_popup.visible:
		timeline_popup.hide()
		return
	
	# FIX 2: Always rebuild from timeline_log when opening
	if timeline_label:
		timeline_label.bbcode_enabled = true
		if timeline_log.is_empty():
			timeline_label.text = "[center]No actions yet[/center]"
		else:
			timeline_label.text = "\n".join(timeline_log)
	
	timeline_popup.popup_centered()
	
	# Auto-scroll to bottom
	await get_tree().process_frame
	var scroll = get_node_or_null("TimelinePopup/MainVBox/ScrollContainer")
	if scroll:
		scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value

func _on_timeline_close_pressed():
	btn_sound.play()
	if timeline_popup:
		timeline_popup.hide()

func _update_timeline_display():
	if not timeline_label:
		return
	timeline_label.bbcode_enabled = true
	if timeline_log.is_empty():
		timeline_label.text = "[center]No actions yet[/center]"
	else:
		timeline_label.text = "[b]TIMELINE:[/b]\n\n" + "\n".join(timeline_log)

# ==============================================
#   CODE GENERATION & TRANSLATION
# ==============================================
func _add_code_line(line: String, array_state: Array = []):
	# Store the operation with the array state at that moment
	var operation = {
		"line": line,
		"array": array_state.duplicate() if array_state.size() > 0 else []
	}
	code_operations.append(operation)
	code_lines.append(line)
	_update_code_view()

func _array_to_string(arr: Array) -> String:
	var result = ""
	for i in range(arr.size()):
		if i > 0:
			result += ", "
		result += str(arr[i])
	return result

func _update_code_view():
	# This will be called when generating code for any language
	var code = _generate_code_for_language(current_language)
	if cpp_text:
		cpp_text.text = code

func _generate_code_for_language(lang: String) -> String:
	var code = ""
	
	match lang:
		"cpp":
			code = _generate_cpp_code()
		"python":
			code = _generate_python_code()
		"java":
			code = _generate_java_code()
		"c":
			code = _generate_c_code()
	
	return code

# FIXED: Proper C++ code generation with correct formatting
# FIXED: Proper C++ code generation with clean operation messages
func _generate_cpp_code() -> String:
	var code = "/* Array Simulation Log */\n"
	code += "#include <iostream>\n"
	code += "#include <vector>\n"
	code += "using namespace std;\n\n"
	code += "void printArray(vector<int>& arr) {\n"
	code += "    cout << \"[\";\n"
	code += "    for (int i = 0; i < arr.size(); i++) {\n"
	code += "        cout << arr[i];\n"
	code += "        if (i < arr.size() - 1) cout << \", \";\n"
	code += "    }\n"
	code += "    cout << \"]\" << endl;\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    vector<int> arr;\n\n"
	
	# Generate actual array operations from stored operations
	for op in code_operations:
		var line = op["line"]
		var array_state = op["array"]
		
		if line.begins_with("Initial list"):
			var nums = line.split(" = ")[1]
			code += "    // " + line + "\n"
			code += "    arr = {" + nums + "};\n"
			code += "    cout << \"Initial array: \";\n"
			code += "    printArray(arr);\n\n"
		
		elif line.begins_with("After insert") and "end" in line:
			# Extract value from "After insert 42 at end = ..."
			var value = line.split(" ")[2]
			code += "    // " + line + "\n"
			code += "    arr.push_back(" + value + ");\n"
			code += "    cout << \"After insert \" << " + value + " << \" at end: \";\n"
			code += "    printArray(arr);\n\n"
		
		elif line.begins_with("After insert") and "index" in line:
			# Extract value and index from "After insert 45 at index[2] = ..."
			var parts = line.split(" ")
			var value = parts[2]  # "45"
			var index_part = parts[4]  # "index[2]"
			var index = index_part.replace("index[", "").replace("]", "")
			code += "    // " + line + "\n"
			code += "    arr.insert(arr.begin() + " + index + ", " + value + ");\n"
			code += "    cout << \"After insert \" << " + value + " << \" at index[\" << " + index + " << \"]: \";\n"
			code += "    printArray(arr);\n\n"
		
		elif line.begins_with("After delete"):
			# Extract index from "After delete at index[2] = ..."
			var parts = line.split(" ")
			var index_part = parts[3]  # "index[2]"
			var index = index_part.replace("index[", "").replace("]", "")
			code += "    // " + line + "\n"
			code += "    arr.erase(arr.begin() + " + index + ");\n"
			code += "    cout << \"After delete at index[\" << " + index + " << \"]: \";\n"
			code += "    printArray(arr);\n\n"
		
		elif line.begins_with("After replace"):
			# Extract index and values from "After replace at index[2] from 45 to 90 = ..."
			var parts = line.split(" ")
			var index_part = parts[3]  # "index[2]"
			var index = index_part.replace("index[", "").replace("]", "")
			var old_val = parts[5]  # "45"
			var new_val = parts[7]  # "90"
			code += "    // " + line + "\n"
			code += "    arr[" + index + "] = " + new_val + ";\n"
			code += "    cout << \"After replace at index[\" << " + index + " << \"] from " + old_val + " to " + new_val + ": \";\n"
			code += "    printArray(arr);\n\n"
		
		elif line.begins_with("Access"):
			# Extract index from "Access at index[3] = 4"
			var parts = line.split(" ")
			var index_part = parts[2]  # "index[3]"
			var index = index_part.replace("index[", "").replace("]", "")
			code += "    // " + line + "\n"
			code += "    cout << \"Access at index[\" << " + index + " << \"] = \" << arr[" + index + "] << endl;\n\n"
	
	code += "    return 0;\n"
	code += "}"
	return code

# FIXED: Proper Python code generation with clean operation messages
func _generate_python_code() -> String:
	var code = "# Array Simulation Log\n\n"
	code += "def print_array(arr):\n"
	code += "    print('[', end='')\n"
	code += "    for i in range(len(arr)):\n"
	code += "        print(arr[i], end='')\n"
	code += "        if i < len(arr) - 1:\n"
	code += "            print(', ', end='')\n"
	code += "    print(']')\n\n"
	code += "def main():\n"
	code += "    arr = []\n\n"
	
	for op in code_operations:
		var line = op["line"]
		
		if line.begins_with("Initial list"):
			var nums = line.split(" = ")[1]
			code += "    # " + line + "\n"
			code += "    arr = [" + nums + "]\n"
			code += "    print('Initial array: ', end='')\n"
			code += "    print_array(arr)\n\n"
		
		elif line.begins_with("After insert") and "end" in line:
			var value = line.split(" ")[2]
			code += "    # " + line + "\n"
			code += "    arr.append(" + value + ")\n"
			code += "    print(f'After insert " + value + " at end: ', end='')\n"
			code += "    print_array(arr)\n\n"
		
		elif line.begins_with("After insert") and "index" in line:
			var parts = line.split(" ")
			var value = parts[2]
			var index_part = parts[4]
			var index = index_part.replace("index[", "").replace("]", "")
			code += "    # " + line + "\n"
			code += "    arr.insert(" + index + ", " + value + ")\n"
			code += "    print(f'After insert " + value + " at index[" + index + "]: ', end='')\n"
			code += "    print_array(arr)\n\n"
		
		elif line.begins_with("After delete"):
			var parts = line.split(" ")
			var index_part = parts[3]
			var index = index_part.replace("index[", "").replace("]", "")
			code += "    # " + line + "\n"
			code += "    del arr[" + index + "]\n"
			code += "    print(f'After delete at index[" + index + "]: ', end='')\n"
			code += "    print_array(arr)\n\n"
		
		elif line.begins_with("After replace"):
			var parts = line.split(" ")
			var index_part = parts[3]
			var index = index_part.replace("index[", "").replace("]", "")
			var old_val = parts[5]
			var new_val = parts[7]
			code += "    # " + line + "\n"
			code += "    arr[" + index + "] = " + new_val + "\n"
			code += "    print(f'After replace at index[" + index + "] from " + old_val + " to " + new_val + ": ', end='')\n"
			code += "    print_array(arr)\n\n"
		
		elif line.begins_with("Access"):
			var parts = line.split(" ")
			var index_part = parts[2]
			var index = index_part.replace("index[", "").replace("]", "")
			code += "    # " + line + "\n"
			code += "    print(f'Access at index[" + index + "] = {arr[" + index + "]}')\n\n"
	
	code += "if __name__ == '__main__':\n"
	code += "    main()"
	return code

# FIXED: Proper Java code generation with clean operation messages
func _generate_java_code() -> String:
	var code = "/* Array Simulation Log */\n"
	code += "import java.util.*;\n\n"
	code += "public class ArraySimulation {\n"
	code += "    public static void printArray(ArrayList<Integer> arr) {\n"
	code += "        System.out.print(\"[\");\n"
	code += "        for (int i = 0; i < arr.size(); i++) {\n"
	code += "            System.out.print(arr.get(i));\n"
	code += "            if (i < arr.size() - 1) System.out.print(\", \");\n"
	code += "        }\n"
	code += "        System.out.println(\"]\");\n"
	code += "    }\n\n"
	code += "    public static void main(String[] args) {\n"
	code += "        ArrayList<Integer> arr = new ArrayList<>();\n\n"
	
	for op in code_operations:
		var line = op["line"]
		
		if line.begins_with("Initial list"):
			var nums_str = line.split(" = ")[1]
			var nums = nums_str.split(", ")
			code += "        // " + line + "\n"
			code += "        arr = new ArrayList<>(Arrays.asList("
			for i in range(nums.size()):
				if i > 0: code += ", "
				code += nums[i]
			code += "));\n"
			code += "        System.out.print(\"Initial array: \");\n"
			code += "        printArray(arr);\n\n"
		
		elif line.begins_with("After insert") and "end" in line:
			var value = line.split(" ")[2]
			code += "        // " + line + "\n"
			code += "        arr.add(" + value + ");\n"
			code += "        System.out.print(\"After insert " + value + " at end: \");\n"
			code += "        printArray(arr);\n\n"
		
		elif line.begins_with("After insert") and "index" in line:
			var parts = line.split(" ")
			var value = parts[2]
			var index_part = parts[4]
			var index = index_part.replace("index[", "").replace("]", "")
			code += "        // " + line + "\n"
			code += "        arr.add(" + index + ", " + value + ");\n"
			code += "        System.out.print(\"After insert " + value + " at index[" + index + "]: \");\n"
			code += "        printArray(arr);\n\n"
		
		elif line.begins_with("After delete"):
			var parts = line.split(" ")
			var index_part = parts[3]
			var index = index_part.replace("index[", "").replace("]", "")
			code += "        // " + line + "\n"
			code += "        arr.remove(" + index + ");\n"
			code += "        System.out.print(\"After delete at index[" + index + "]: \");\n"
			code += "        printArray(arr);\n\n"
		
		elif line.begins_with("After replace"):
			var parts = line.split(" ")
			var index_part = parts[3]
			var index = index_part.replace("index[", "").replace("]", "")
			var old_val = parts[5]
			var new_val = parts[7]
			code += "        // " + line + "\n"
			code += "        arr.set(" + index + ", " + new_val + ");\n"
			code += "        System.out.print(\"After replace at index[" + index + "] from " + old_val + " to " + new_val + ": \");\n"
			code += "        printArray(arr);\n\n"
		
		elif line.begins_with("Access"):
			var parts = line.split(" ")
			var index_part = parts[2]
			var index = index_part.replace("index[", "").replace("]", "")
			code += "        // " + line + "\n"
			code += "        System.out.println(\"Access at index[" + index + "] = \" + arr.get(" + index + "));\n\n"
	
	code += "    }\n"
	code += "}"
	return code

# FIXED: Proper C code generation with clean operation messages
func _generate_c_code() -> String:
	var code = "/* Array Simulation Log */\n"
	code += "#include <stdio.h>\n\n"
	code += "void printArray(int arr[], int size) {\n"
	code += "    printf(\"[\");\n"
	code += "    for (int i = 0; i < size; i++) {\n"
	code += "        printf(\"%d\", arr[i]);\n"
	code += "        if (i < size - 1) printf(\", \");\n"
	code += "    }\n"
	code += "    printf(\"]\\n\");\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    int arr[" + str(max_array_size) + "];\n"
	code += "    int size = 0;\n\n"
	
	var array_index = 0
	for op in code_operations:
		var line = op["line"]
		
		if line.begins_with("Initial list"):
			var nums_str = line.split(" = ")[1]
			var nums = nums_str.split(", ")
			code += "    // " + line + "\n"
			code += "    size = " + str(nums.size()) + ";\n"
			for i in range(nums.size()):
				code += "    arr[" + str(i) + "] = " + nums[i] + ";\n"
			code += "    printf(\"Initial array: \");\n"
			code += "    printArray(arr, size);\n\n"
		
		elif line.begins_with("After insert") and "end" in line:
			var value = line.split(" ")[2]
			code += "    // " + line + "\n"
			code += "    arr[size] = " + value + ";\n"
			code += "    size++;\n"
			code += "    printf(\"After insert " + value + " at end: \");\n"
			code += "    printArray(arr, size);\n\n"
		
		elif line.begins_with("After insert") and "index" in line:
			var parts = line.split(" ")
			var value = parts[2]
			var index_part = parts[4]
			var index = index_part.replace("index[", "").replace("]", "")
			code += "    // " + line + "\n"
			code += "    // Shift elements to the right\n"
			code += "    for (int i = size; i > " + index + "; i--) {\n"
			code += "        arr[i] = arr[i-1];\n"
			code += "    }\n"
			code += "    arr[" + index + "] = " + value + ";\n"
			code += "    size++;\n"
			code += "    printf(\"After insert " + value + " at index[" + index + "]: \");\n"
			code += "    printArray(arr, size);\n\n"
		
		elif line.begins_with("After delete"):
			var parts = line.split(" ")
			var index_part = parts[3]
			var index = index_part.replace("index[", "").replace("]", "")
			code += "    // " + line + "\n"
			code += "    // Shift elements to the left\n"
			code += "    for (int i = " + index + "; i < size - 1; i++) {\n"
			code += "        arr[i] = arr[i+1];\n"
			code += "    }\n"
			code += "    size--;\n"
			code += "    printf(\"After delete at index[" + index + "]: \");\n"
			code += "    printArray(arr, size);\n\n"
		
		elif line.begins_with("After replace"):
			var parts = line.split(" ")
			var index_part = parts[3]
			var index = index_part.replace("index[", "").replace("]", "")
			var old_val = parts[5]
			var new_val = parts[7]
			code += "    // " + line + "\n"
			code += "    arr[" + index + "] = " + new_val + ";\n"
			code += "    printf(\"After replace at index[" + index + "] from " + old_val + " to " + new_val + ": \");\n"
			code += "    printArray(arr, size);\n\n"
		
		elif line.begins_with("Access"):
			var parts = line.split(" ")
			var index_part = parts[2]
			var index = index_part.replace("index[", "").replace("]", "")
			code += "    // " + line + "\n"
			code += "    printf(\"Access at index[" + index + "] = %d\\n\", arr[" + index + "]);\n\n"
	
	code += "    return 0;\n"
	code += "}"
	return code

# ==============================================
#   LANGUAGE BUTTON FUNCTIONS
# ==============================================
func _connect_language_buttons():
	if cpp_lang_btn: cpp_lang_btn.pressed.connect(func(): _set_language("cpp"))
	if python_lang_btn: python_lang_btn.pressed.connect(func(): _set_language("python"))
	if java_lang_btn: java_lang_btn.pressed.connect(func(): _set_language("java"))
	if c_lang_btn: c_lang_btn.pressed.connect(func(): _set_language("c"))

func _set_language(lang: String):
	btn_sound.play()
	current_language = lang
	_show_cpp_popup()

func _on_show_cpp_pressed():
	btn_sound.play()
	if complete_popup: complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

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
#   CODE POPUP WITH WALKTHROUGH
# ==============================================
func _show_cpp_popup():
	var code = _generate_code_for_language(current_language)
	if cpp_text:
		cpp_text.bbcode_enabled = true
		cpp_text.text = code
	
	cpp_walkthrough_steps = _build_walkthrough_steps(current_language)
	cpp_walkthrough_step = 0
	
	if cpp_next_btn:
		if cpp_next_btn.pressed.is_connected(_on_cpp_next_pressed):
			cpp_next_btn.pressed.disconnect(_on_cpp_next_pressed)
		cpp_next_btn.pressed.connect(_on_cpp_next_pressed)
		cpp_next_btn.mouse_filter = Control.MOUSE_FILTER_STOP
		cpp_next_btn.disabled = false
	
	if cpp_tutorial_panel:
		cpp_tutorial_panel.show()
	
	cpp_popup.popup_centered()
	_update_cpp_walkthrough()

func _on_cpp_next_pressed():
	btn_sound.play()
	cpp_walkthrough_step += 1
	if cpp_walkthrough_step >= cpp_walkthrough_steps.size():
		cpp_walkthrough_step = 0
	_update_cpp_walkthrough()

func _update_cpp_walkthrough():
	if cpp_walkthrough_steps.is_empty():
		if cpp_explanation_lbl:
			cpp_explanation_lbl.bbcode_enabled = true
			cpp_explanation_lbl.text = "No walkthrough available."
		return
	
	var step = cpp_walkthrough_steps[cpp_walkthrough_step]
	var highlight_lines = step["lines"]
	var explanation = step["explanation"]
	
	# Update explanation
	if cpp_explanation_lbl:
		cpp_explanation_lbl.bbcode_enabled = true
		cpp_explanation_lbl.text = explanation
	
	if cpp_text:
		var code = _generate_code_for_language(current_language)
		var lines = code.split("\n")
		
		# Build highlighted code
		var highlighted_lines = lines.duplicate()
		for line_idx in highlight_lines:
			if line_idx >= 0 and line_idx < highlighted_lines.size():
				highlighted_lines[line_idx] = "[bgcolor=#444400]" + highlighted_lines[line_idx] + "[/bgcolor]"
		
		cpp_text.bbcode_enabled = true
		cpp_text.text = "\n".join(highlighted_lines)
		
		# Scroll to highlighted line
		if highlight_lines.size() > 0:
			var target_line = highlight_lines[0] if highlight_lines is Array else highlight_lines
			await get_tree().process_frame
			cpp_text.scroll_to_line(target_line)

func _build_walkthrough_steps(lang: String) -> Array:
	var steps = []
	
	match lang:
		"cpp":
			steps.append({
				"lines": [0, 1, 2, 3],
				"explanation": "[b]Includes & Setup[/b]\nImports iostream and vector libraries.\nusing namespace std; avoids typing std:: everywhere."
			})
			steps.append({
				"lines": [5, 6, 7, 8, 9, 10, 11, 12, 13],
				"explanation": "[b]printArray Function[/b]\nLoops through the vector and prints each element.\nComma-separated output with brackets."
			})
			steps.append({
				"lines": [15, 16],
				"explanation": "[b]Main Function & Array Init[/b]\nDeclares a dynamic vector<int>.\nAll operations happen on this vector."
			})
			# Dynamic steps per action
			for i in range(code_lines.size()):
				var line = code_lines[i]
				if line.begins_with("Initial list"):
					steps.append({
						"lines": [18 + i * 4, 18 + i * 4 + 3],
						"explanation": "[b]Initial Array[/b]\nSets up the array with your starting values:\n[color=yellow]%s[/color]" % line.split(" = ")[1]
					})
				elif line.begins_with("After insert") or line.begins_with("After delete") or line.begins_with("After replace"):  # NEW: Added replace
					var parts = line.split(" = ")
					var result = parts[1] if parts.size() > 1 else ""
					steps.append({
						"lines": [18 + i * 4, 18 + i * 4 + 2],
						"explanation": "[b]Array Operation[/b]\nResult after the operation:\n[color=green]%s[/color]" % result
					})
				elif line.begins_with("Access"):
					steps.append({
						"lines": [18 + i * 3, 18 + i * 3 + 1],
						"explanation": "[b]Array Access[/b]\nReads the value at a given index.\nDoes not modify the array.\n[color=yellow]%s[/color]" % line
					})
				elif line.begins_with("Simulation ended"):
					steps.append({
						"lines": [18 + i * 4, 18 + i * 4 + 2],
						"explanation": "[b]Final Array[/b]\nThe array after all operations.\n[color=cyan]%s[/color]" % line.split(" = ")[1]
					})
		
		"python":
			steps.append({
				"lines": [0, 1],
				"explanation": "[b]Print Function[/b]\nHelper function to display array with brackets."
			})
			steps.append({
				"lines": [3, 4, 5, 6, 7, 8, 9, 10],
				"explanation": "[b]print_array Function[/b]\nLoops through list and prints elements with commas."
			})
			steps.append({
				"lines": [12, 13],
				"explanation": "[b]Main & Init[/b]\nDefines main() and creates empty list."
			})
			# Dynamic steps per action
			for i in range(code_lines.size()):
				var line = code_lines[i]
				if line.begins_with("Initial list"):
					steps.append({
						"lines": [15 + i * 4, 15 + i * 4 + 3],
						"explanation": "[b]Initial Array[/b]\n[color=yellow]%s[/color]" % line.split(" = ")[1]
					})
				elif line.begins_with("After insert") or line.begins_with("After delete") or line.begins_with("After replace"):  # NEW: Added replace
					steps.append({
						"lines": [15 + i * 4, 15 + i * 4 + 2],
						"explanation": "[b]Operation Result[/b]\n[color=green]%s[/color]" % (line.split(" = ")[1] if " = " in line else "")
					})
				elif line.begins_with("Access"):
					steps.append({
						"lines": [15 + i * 3, 15 + i * 3],
						"explanation": "[b]Access[/b]\n[color=yellow]%s[/color]" % line
					})
		
		"java", "c":
			# Generic structural steps
			steps.append({
				"lines": range(0, 3),
				"explanation": "[b]Imports & Setup[/b]\nImports necessary libraries."
			})
			steps.append({
				"lines": range(3, 12),
				"explanation": "[b]Print Function[/b]\nHelper to display array contents."
			})
			steps.append({
				"lines": range(12, 15),
				"explanation": "[b]Main & Init[/b]\nEntry point and array declaration."
			})
			# Dynamic steps per action
			for i in range(code_lines.size()):
				var line = code_lines[i]
				if line.begins_with("Initial list"):
					steps.append({
						"lines": [15 + i * 5, 15 + i * 5 + 4],
						"explanation": "[b]Initial Array[/b]\n[color=yellow]%s[/color]" % (line.split(" = ")[1] if " = " in line else line)
					})
				elif line.begins_with("After insert") or line.begins_with("After delete") or line.begins_with("After replace"):  # NEW: Added replace
					steps.append({
						"lines": [15 + i * 5, 15 + i * 5 + 2],
						"explanation": "[b]Operation Result[/b]\n[color=green]%s[/color]" % (line.split(" = ")[1] if " = " in line else "")
					})
				elif line.begins_with("Access"):
					steps.append({
						"lines": [15 + i * 4, 15 + i * 4],
						"explanation": "[b]Access[/b]\n[color=yellow]%s[/color]" % line
					})
	
	return steps

# ==============================================
#   UTILITY FUNCTIONS
# ==============================================
func show_feedback(text: String, color: Color, position: Vector2):
	var feedback_scene = preload("res://scene/FeedbackLabel.tscn")
	var label = feedback_scene.instantiate()
	label.text = text
	label.modulate = color
	label.global_position = position
	
	# Create or get a high-layer CanvasLayer for feedback
	var feedback_layer = get_node_or_null("FeedbackLayer")
	if not feedback_layer:
		feedback_layer = CanvasLayer.new()
		feedback_layer.name = "FeedbackLayer"
		feedback_layer.layer = 100  # High layer to appear above everything
		add_child(feedback_layer)
	
	feedback_layer.add_child(label)
	
	var anim_player: AnimationPlayer = label.get_node("AnimationPlayer")
	anim_player.play("notification_pop")
	anim_player.animation_finished.connect(func(_a): 
		label.queue_free()
	)

# ==============================================
#   INTRODUCTION FUNCTIONS
# ==============================================
func show_introduction():
	if not intro_popup:
		print("intro_popup not found")
		return

	print("Showing introduction")
	set_ui_enabled(false)

	tutorial_overlay.show()
	
	# FIX: Make sure these don't eat mouse input
	if dim_bg:
		dim_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tutorial_overlay.layer = 10  # Ensure it's on top visually
	
	intro_popup.show()
	intro_popup.mouse_filter = Control.MOUSE_FILTER_STOP  # Popup itself catches input
	
	intro_step = 0
	_update_intro_text()

	var prev = get_node_or_null("TutorialOverlay/Intro_popup/prev")
	var next = get_node_or_null("TutorialOverlay/Intro_popup/next")
	var skip = get_node_or_null("TutorialOverlay/Intro_popup/skip")

	print("prev: ", prev, " next: ", next, " skip: ", skip)

	if prev and not prev.is_connected("pressed", _on_intro_prev_pressed):
		prev.mouse_filter = Control.MOUSE_FILTER_STOP
		prev.pressed.connect(_on_intro_prev_pressed)
	if next and not next.is_connected("pressed", _on_intro_next_pressed):
		next.mouse_filter = Control.MOUSE_FILTER_STOP
		next.pressed.connect(_on_intro_next_pressed)
	if skip and not skip.is_connected("pressed", _on_intro_skip_pressed):
		skip.mouse_filter = Control.MOUSE_FILTER_STOP
		skip.pressed.connect(_on_intro_skip_pressed)

func _update_intro_text():
	var label = get_node_or_null("TutorialOverlay/Intro_popup/Label")
	var prev = get_node_or_null("TutorialOverlay/Intro_popup/prev")
	var next = get_node_or_null("TutorialOverlay/Intro_popup/next")

	if label and intro_texts.size() > 0:
		label.text = intro_texts[intro_step]
		print("Updated intro text to step ", intro_step)

	if prev:
		prev.visible = (intro_step > 0)

	if next:
		next.text = "Finish" if intro_step >= intro_texts.size() - 1 else "Next"

func _on_intro_next_pressed():
	btn_sound.play()
	print("Next pressed, step: ", intro_step)
	
	if intro_step < intro_texts.size() - 1:
		intro_step += 1
		_update_intro_text()
	else:
		# Last page - close intro
		intro_popup.hide()
		set_ui_enabled(true)
		print("Introduction finished")

func _on_intro_prev_pressed():
	btn_sound.play()
	print("Prev pressed, step: ", intro_step)
	
	if intro_step > 0:
		intro_step -= 1
		_update_intro_text()

func _on_intro_skip_pressed():
	btn_sound.play()
	print("Skip pressed")
	intro_popup.hide()
	set_ui_enabled(true)

func _on_help_button_pressed():
	btn_sound.play()
	start_tutorial()

# ==============================================
#   TUTORIAL FUNCTIONS
# ==============================================
func start_tutorial():
	if not tutorial_overlay or not tutorial_box or not tutorial_text or not tutorial_next:
		print("ERROR: Tutorial nodes not found")
		return
	
	set_ui_enabled(false)
	
	# Updated tutorial nodes to include indicators
	tutorial_nodes = [
		access_btn, 
		insert_end_btn, 
		insert_i_btn, 
		delete_btn, 
		replace_btn,
		end_sim_btn, 
		simulate_new_btn, 
		timeline_btn, 
		array_size_label,
		get_node_or_null("isFull"),  # Added isFull indicator
		get_node_or_null("isEmpty")   # Added isEmpty indicator
	]
	
	tutorial_step = 0
	tutorial_overlay.show()
	
	if dim_bg:
		dim_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	tutorial_box.show()
	tutorial_box.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Force next button to be on top and clickable
	tutorial_next.mouse_filter = Control.MOUSE_FILTER_STOP
	tutorial_next.z_index = 100
	tutorial_next.disabled = false
	
	_show_tutorial_step()

func _show_tutorial_step():
	if tutorial_step >= tutorial_nodes.size():
		_end_tutorial()
		return
	
	var node = tutorial_nodes[tutorial_step]
	if not node:
		tutorial_step += 1
		_show_tutorial_step()
		return
	
	match tutorial_step:
		0: tutorial_text.text = "ACCESS [i]\n\nClick to enter an index.\nThe element will highlight and show its value."
		1: tutorial_text.text = "INSERT AT END\n\nAdds element to end.\nButton shows feedback when array is full."
		2: tutorial_text.text = "INSERT AT [i]\n\nInsert at any position.\nElements shift right to make room."
		3: tutorial_text.text = "DELETE [i]\n\nRemoves element at index.\nElements shift left to fill the gap."
		4: tutorial_text.text = "REPLACE [i]\n\nUpdates an element at a specific index with a new value.\nDoes not change array size."
		5: tutorial_text.text = "SIMULATE NEW\n\nStart over with a new array.\nA confirmation will appear."
		6: tutorial_text.text = "END SIMULATION\n\nFinish and view action summary."
		7: tutorial_text.text = "TIMELINE\n\nView history of all operations."
		8: tutorial_text.text = "ARRAY SIZE\n\nShows current size vs max capacity."
		9: tutorial_text.text = "FULL INDICATOR\n\nTurns GREEN when array reaches maximum capacity.\nTurns DARK when there's still space available."
		10: tutorial_text.text = "EMPTY INDICATOR\n\nTurns RED when array has no elements.\nTurns DARK when the array contains data."
	
	if pointer_sprite:
		pointer_sprite.texture = load("res://assets/point_left.png")
		pointer_sprite.show()
		
		var pos_x = node.global_position.x + node.size.x + 50
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
	
	tutorial_box.visible = true
	tutorial_text.visible = true
	tutorial_next.visible = true
	
	# FIX: Make sure next button is always on top and clickable
	tutorial_next.mouse_filter = Control.MOUSE_FILTER_STOP
	tutorial_next.z_index = 10

func _on_next_button_pressed():
	btn_sound.play()
	tutorial_step += 1
	_show_tutorial_step()
	
func _end_tutorial():
	tutorial_in_progress = false
	tutorial_overlay.hide()
	
	if pointer_sprite:
		pointer_sprite.hide()
		if pointer_sprite.has_meta("tween"):
			pointer_sprite.get_meta("tween").kill()
	
	# FIX: Restore correct state depending on whether simulation is ended or not
	if simulation_ended:
		_apply_simulation_ended_state()
	else:
		set_ui_enabled(true)
	
	show_feedback("Tutorial complete! Start experimenting!", Color.GREEN, Vector2(500, 300))
func _exit_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_PORTRAIT)
	# Swap back to portrait dimensions
