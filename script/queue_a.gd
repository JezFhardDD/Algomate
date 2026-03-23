extends Control

# --- MAIN BUTTONS ---
@onready var undo_btn: Button = $VBoxContainer/InsertAtIButton
@onready var redo_btn: Button = $VBoxContainer/DeleteButton
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton

# --- HIDDEN BUTTONS ---
@onready var insert_end_btn: Button = $VBoxContainer/InsertAtEndButton
@onready var access_btn: Button = $VBoxContainer/AccessButton
@onready var end_sim_btn: Button = $VBoxContainer/SortButton
@onready var simulate_new_btn: Button = $VBoxContainer/WaitingElements

# --- LABELS ---
@onready var target_label: Label = $TargetLabel
@onready var command_progress_label: Label = $CommandProgressLabel
@onready var timer_label: Label = $VBoxContainer/HBoxContainer/Label2
@onready var clock: AnimatedSprite2D = $VBoxContainer/HBoxContainer/AnimatedSprite2D
@onready var difficulty_label: Label = $DiificultyLabel
@onready var correct_moves_label: Label = get_node_or_null("MarginContainer/HBoxContainer2/TextureRect/Label")

# --- ARRAY CONTAINER ---
@onready var array_container: Control = $QueueContainer

# --- SPAWN AREA ---
@onready var spawn_area: Control = get_node_or_null("SpawnArea")
@onready var spawn_slot: Control = get_node_or_null("SpawnArea/SpawnSlot")

# --- GARBAGE AREA ---
@onready var garbage_area: Area2D = $Area2D
@onready var garbage_sprite: Sprite2D = $Area2D/Sprite2D
@onready var garbage_collision: CollisionShape2D = $Area2D/CollisionShape2D

# --- TIMELINE POPUP ---
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: RichTextLabel = $TimelinePopup/MainVBox/ScrollContainer/VBoxContainer/RichTextLabel
@onready var timeline_close_btn: Button = get_node_or_null("TimelinePopup/MainVBox/CloseButton")

# --- POPUPS ---
@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup")
@onready var time_up_popup: PopupPanel = $TimeUpPopup
@onready var waiting_popup: Popup = $WaitingPopup
@onready var time_up_try_again_btn: Button = get_node_or_null("TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/TryAgainButton")
@onready var time_up_back_btn: Button = get_node_or_null("TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/BackButton")
@onready var try_again_btn_root: Button = get_node_or_null("TryAgainButton")

# --- CODE POPUP ---
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup")
@onready var cpp_text: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/ScrollContainer/RichTextLabel")
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/close")
@onready var cpp_next_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CppNextButton")
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_lbl: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")
@onready var cpp_scroll: ScrollContainer = get_node_or_null("CppPopup/VBoxContainer/ScrollContainer")
@onready var cpp_lang_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/Cpp_btn")
@onready var python_lang_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/Py_btn")
@onready var java_lang_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/Java_btn")
@onready var c_lang_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/C_btn")
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")
@onready var code_anim: AnimatedSprite2D = get_node_or_null("CppCodeButton/code_anim")

# --- COMPILER INTEGRATION ---
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CompileButton")

# --- AUDIO ---
@onready var btn_sound: AudioStreamPlayer2D = $btn_sound
@onready var audio_player: AudioStreamPlayer2D = $bgm

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

# --- RESULT POPUP ---
const RESULT_POPUP_SCENE := preload("res://scene/ResultPopup.tscn")
var result_popup: PopupPanel
var result_title: Label
var score_summary: Label
var accuracy_label: Label
var time_used_label: Label
var coins_label: Label
var coins_anim: AnimatedSprite2D
var try_again_result_btn: Button
var back_result_btn: Button

# --- BLOCK SCENE ---
const BLOCK_SCENE := preload("res://BubbleBlock.tscn")
const TIKTAK_SFX := preload("res://assets/sfx/tiktak.mp3")
var tiktak_sound: AudioStreamPlayer

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

# --- DIFFICULTY & TIMER ---
var difficulty: int = 2
var time_remaining: float = 0.0
var timer_running: bool = false
var assessment_time_limit: float = 0.0

# --- ARRAY STATE ---
var main_array: Array[int] = []
var block_nodes: Array[Control] = []
var max_array_size: int = 7
var BLOCK_SPACING: float = 30.0
var START_POSITION: Vector2 = Vector2(60, 80)

enum CommandType { ENQUEUE, DEQUEUE, PEEK }

var command_queue: Array = []
var current_command_index: int = 0
var commands_total: int = 0
var correct_moves: int = 0
var bad_moves: int = 0
var has_completed: bool = false
var completion_type: String = ""

var spawn_stack: Array[Control] = []
const SPAWN_STACK_OFFSET: Vector2 = Vector2(4, 12)

# --- UNDO / REDO ---
var undo_stack: Array = []
var redo_stack: Array = []

# --- TIMELINE & CODE ---
var timeline_log: Array[String] = []
var code_lines: Array[String] = []
var current_code_language: String = "cpp"
var cpp_walkthrough_steps: Array = []
var cpp_walkthrough_step: int = 0

# --- ANIMATION ---
var is_animating: bool = false
var ANIM_SPEED: float = 0.3
var _hovered_gap_index: int = -1
var _gap_tween: Tween = null
const GAP_OPEN_AMOUNT: float = 30.0

# --- INTRO ---
var intro_step: int = 0
var intro_texts: Array = [
	"WELCOME TO QUEUE ASSESSMENT!\n\nPut your queue knowledge to the test. The system will give you commands one at a time.",
	"COMMANDS:\n\n• Enqueue — add a new element to the BACK of the queue\n• Dequeue — remove the element from the FRONT of the queue\n• Peek — look at the FRONT element without removing it",
	"SPAWN AREA (upper left):\n\nBlocks waiting to be enqueued are stacked here. The top block is always the current one to drag.",
	"TRASH (upper right):\n\nDrag the FRONT block here during DEQUEUE commands. Wrong blocks snap back!",
	"SCORING:\n\n✓ Correct action = Good move\n✗ Wrong action = Bad move\n\nAccuracy = Good moves / Total moves\n\nUndo/Redo available on Easy & Medium!"
]

# --- TUTORIAL ---
var tutorial_step: int = 0
var tutorial_nodes: Array = []
var tutorial_in_progress: bool = false

# ==============================================
#   ORIENTATION HANDLING
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
#   READY
# ==============================================
func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	difficulty = Global.current_difficulty
	if difficulty == 0:
		difficulty = 1
	
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	randomize()

	# Setup tiktak
	tiktak_sound = AudioStreamPlayer.new()
	tiktak_sound.stream = TIKTAK_SFX
	add_child(tiktak_sound)

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
	try_again_result_btn.pressed.connect(_on_try_again_pressed)
	back_result_btn.pressed.connect(_on_back_pressed)

	# Connect translate code btn from result popup
	var translate_btn = result_popup.get_node_or_null("TextureRect/VBoxContainer/translate_code_btn")
	if translate_btn:
		translate_btn.pressed.connect(_on_translate_code_pressed)
		translate_btn.hide()

	# Hide unused buttons
	insert_end_btn.hide()
	access_btn.hide()
	end_sim_btn.hide()
	simulate_new_btn.hide()

	# Repurpose buttons
	undo_btn.text = "UNDO"
	redo_btn.text = "REDO"

	# Hide completion buttons by default
	if cpp_code_button: cpp_code_button.hide()
	if try_again_btn_root: 
		try_again_btn_root.pressed.connect(_on_try_again_root_pressed)
		try_again_btn_root.hide()

	# Show timer elements
	timer_label.show()
	clock.show()
	difficulty_label.show()

	# Connect TimeUpPopup buttons
	if time_up_try_again_btn:
		time_up_try_again_btn.pressed.connect(_on_time_up_try_again_pressed)
	if time_up_back_btn:
		time_up_back_btn.pressed.connect(_on_time_up_back_pressed)

	# Connect main buttons
	undo_btn.pressed.connect(_on_undo_pressed)
	redo_btn.pressed.connect(_on_redo_pressed)
	timeline_btn.pressed.connect(_on_timeline_pressed)
	if timeline_close_btn:
		timeline_close_btn.pressed.connect(_on_timeline_close_pressed)

	# Connect CppCodeButton and popup
	if cpp_code_button:
		cpp_code_button.pressed.connect(_on_cpp_code_button_pressed)
	if cpp_close_btn:
		cpp_close_btn.pressed.connect(_on_cpp_close_pressed)
	if cpp_next_btn:
		if not cpp_next_btn.is_connected("pressed", _on_cpp_next_pressed):
			cpp_next_btn.pressed.connect(_on_cpp_next_pressed)

	# Connect language buttons
	if cpp_lang_btn: cpp_lang_btn.pressed.connect(func(): _set_language("cpp"))
	if python_lang_btn: python_lang_btn.pressed.connect(func(): _set_language("python"))
	if java_lang_btn: java_lang_btn.pressed.connect(func(): _set_language("java"))
	if c_lang_btn: c_lang_btn.pressed.connect(func(): _set_language("c"))

	# Connect tutorial
	if tutorial_next:
		if not tutorial_next.is_connected("pressed", _on_tutorial_next_pressed):
			tutorial_next.pressed.connect(_on_tutorial_next_pressed)
	var help_btn = get_node_or_null("HelpButton")
	if help_btn:
		help_btn.pressed.connect(_on_help_pressed)

	# Connect intro buttons
	_ensure_connected(intro_next_btn, "pressed", _on_intro_next_pressed)
	_ensure_connected(intro_prev_btn, "pressed", _on_intro_prev_pressed)
	_ensure_connected(intro_skip_btn, "pressed", _on_intro_skip_pressed)

	# Setup compiler
	_setup_compiler()

	# Start
	_update_difficulty_label()
	_start_assessment()
	call_deferred("show_introduction")

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
	
	print("=== Queue Compile Request ===")
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
		print("Compiler cache reset for new assessment")


func _ensure_connected(node: Node, sig: String, callable: Callable) -> void:
	if node and not node.is_connected(sig, callable):
		node.connect(sig, callable)


func _get_command_count() -> int:
	match difficulty:
		1: return 5
		2: return 8
		3: return 12
	return 5


func _get_time_limit() -> float:
	match difficulty:
		1: return 0.0    # No timer
		2: return 60.0
		3: return 60.0
	return 60.0


func _get_threshold() -> float:
	match difficulty:
		1: return 0.6
		2: return 0.75
		3: return 0.8
	return 0.7


func _update_difficulty_label() -> void:
	if not difficulty_label: return
	match difficulty:
		1: difficulty_label.text = "Difficulty: Easy"
		2: difficulty_label.text = "Difficulty: Medium"
		3: difficulty_label.text = "Difficulty: Hard"


func _update_correct_moves_label() -> void:
	if correct_moves_label:
		correct_moves_label.text = "Correct Moves: %d" % correct_moves


# ==============================================
#   ASSESSMENT START
# ==============================================

func _start_assessment() -> void:
	reset_cache_for_scene()
	
	if not spawn_slot:
		push_error("spawn_slot is null! Check node path.")
		for child in get_children():
			print(child.name, " (", child.get_class(), ")")
		return

	timer_running = false
	time_remaining = 0.0

	main_array.clear()
	block_nodes.clear()
	timeline_log.clear()
	undo_stack.clear()
	redo_stack.clear()
	command_queue.clear()
	spawn_stack.clear()
	code_lines.clear()
	correct_moves = 0
	bad_moves = 0
	has_completed = false
	completion_type = ""
	current_command_index = 0
	is_animating = false
	_hovered_gap_index = -1

	if cpp_code_button: cpp_code_button.hide()
	if try_again_btn_root: try_again_btn_root.hide()

	for child in array_container.get_children():
		child.queue_free()
	for child in spawn_slot.get_children():
		child.queue_free()

	assessment_time_limit = _get_time_limit()
	time_remaining = assessment_time_limit

	if difficulty == 1:
		timer_label.hide()
		clock.hide()
		clock.stop()
	else:
		timer_label.show()
		clock.show()
		clock.stop()
		_update_timer_display()

	var initial_size = randi_range(3, 4)
	for i in range(initial_size):
		main_array.append(randi_range(1, 99))

	_add_code_line("INITIAL", 0, 0)

	_generate_commands()
	commands_total = command_queue.size()

	_rebuild_blocks_from_array()
	_build_spawn_stack()
	_show_current_command()
	_update_progress_label()
	_update_correct_moves_label()
	_update_undo_redo_buttons()

	timeline_log.append("[color=cyan]--- Assessment Started ---[/color]")
	timeline_log.append("[color=cyan]Initial queue: [%s][/color]" % _array_to_string(main_array))
	_update_timeline_display()


# ==============================================
#   COMMAND GENERATION (QUEUE-SPECIFIC)
# ==============================================

func _generate_commands() -> void:
	command_queue.clear()
	var total = _get_command_count()
	var simulated_array: Array[int] = main_array.duplicate()

	for i in range(total):
		var available: Array[CommandType] = []

		if simulated_array.size() < max_array_size:
			available.append(CommandType.ENQUEUE)
		if simulated_array.size() > 0:
			available.append(CommandType.DEQUEUE)
			available.append(CommandType.PEEK)

		if available.is_empty():
			break

		var chosen_type: CommandType = available[randi() % available.size()]
		var cmd = {}

		match chosen_type:
			CommandType.ENQUEUE:
				var val = randi_range(1, 99)
				cmd = { "type": CommandType.ENQUEUE, "index": simulated_array.size(), "value": val }
				simulated_array.insert(simulated_array.size(), val)

			CommandType.DEQUEUE:
				cmd = { "type": CommandType.DEQUEUE, "index": 0, "value": simulated_array[0] }
				simulated_array.remove_at(0)

			CommandType.PEEK:
				cmd = { "type": CommandType.PEEK, "index": 0, "value": simulated_array[0] }

		command_queue.append(cmd)


# ==============================================
#   SPAWN STACK
# ==============================================

func _build_spawn_stack() -> void:
	for child in spawn_slot.get_children():
		child.queue_free()
	spawn_stack.clear()
	await get_tree().process_frame

	var insert_cmds: Array = []
	for cmd in command_queue:
		if cmd["type"] == CommandType.ENQUEUE:
			insert_cmds.append(cmd)

	if insert_cmds.is_empty():
		return

	for i in range(insert_cmds.size() - 1, -1, -1):
		var cmd = insert_cmds[i]
		var block = BLOCK_SCENE.instantiate()
		block.value = cmd["value"]
		block.draggable = true

		var depth = insert_cmds.size() - 1 - i
		block.position = Vector2(depth * SPAWN_STACK_OFFSET.x, depth * abs(SPAWN_STACK_OFFSET.y))
		block.z_index = insert_cmds.size() - depth

		spawn_slot.add_child(block)
		await get_tree().process_frame
		block.original_position = block.global_position
		block.block_dropped.connect(_on_spawn_block_dropped)
		spawn_stack.push_front(block)

	_refresh_spawn_stack_visuals()


func _refresh_spawn_stack_visuals() -> void:
	var total = spawn_stack.size()
	for i in range(total):
		var block = spawn_stack[i]
		if not is_instance_valid(block): continue
		if i == 0:
			block.visible = true
			block.modulate = Color(1, 1, 1, 1.0)
			block.z_index = 100
			block.z_as_relative = false
			block.draggable = true
		elif i == 1:
			block.visible = true
			block.modulate = Color(1, 1, 1, 0.6)
			block.z_index = total - 1
			block.z_as_relative = true
			block.draggable = false
		elif i == 2:
			block.visible = true
			block.modulate = Color(1, 1, 1, 0.35)
			block.z_index = total - 2
			block.z_as_relative = true
			block.draggable = false
		else:
			block.visible = false
			block.z_index = 0
			block.z_as_relative = true
			block.draggable = false


func _get_current_spawn_block() -> Control:
	if spawn_stack.is_empty():
		return null
	return spawn_stack[0]


# ==============================================
#   COMMAND DISPLAY
# ==============================================

func _show_current_command() -> void:
	if current_command_index >= command_queue.size():
		_end_assessment("completed")
		return

	var cmd = command_queue[current_command_index]
	match cmd["type"]:
		CommandType.ENQUEUE:
			target_label.text = "Enqueue %d" % cmd["value"]
		CommandType.DEQUEUE:
			target_label.text = "Dequeue front element"
		CommandType.PEEK:
			target_label.text = "Peek at front element"

	_clear_all_highlights()
	if cmd["type"] == CommandType.DEQUEUE or cmd["type"] == CommandType.PEEK:
		if block_nodes.size() > 0 and is_instance_valid(block_nodes[0]):
			block_nodes[0].set_outline_color(
				Color.ORANGE if cmd["type"] == CommandType.DEQUEUE else Color.CYAN
			)

	var spawn_block = _get_current_spawn_block()
	if spawn_block:
		spawn_block.modulate.a = 1.0 if cmd["type"] == CommandType.ENQUEUE else 0.6


func _update_progress_label() -> void:
	if command_progress_label:
		command_progress_label.text = "Command: %d/%d" % [current_command_index + 1, commands_total]


func _clear_all_highlights() -> void:
	for block in block_nodes:
		if is_instance_valid(block):
			block.hide_outline()


# ==============================================
#   BLOCK PRESS HANDLER (PEEK command)
# ==============================================

func _on_block_pressed(block: Control) -> void:
	if has_completed or is_animating:
		return

	if current_command_index >= command_queue.size():
		return

	var cmd = command_queue[current_command_index]
	if cmd["type"] != CommandType.PEEK:
		return

	var pressed_index = block_nodes.find(block)
	if pressed_index == -1:
		return

	if pressed_index == cmd["index"]:
		correct_moves += 1
		_add_code_line("PEEK", 0, cmd["value"])
		_update_correct_moves_label()
		timeline_log.append("[color=green]✓ Peeked at front element: %d[/color]" % main_array[0])
		show_feedback("Correct! Front is %d" % main_array[0], Color.GREEN, block.global_position)

		block.set_highlight(true)
		await get_tree().create_timer(0.5).timeout
		if is_instance_valid(block):
			block.set_highlight(false)

		_save_state(true)
		_advance_command()
	else:
		bad_moves += 1
		timeline_log.append("[color=red]✗ Wrong peek: tapped wrong block[/color]")
		show_feedback("Wrong! Tap the front element", Color.RED, block.global_position)
		_save_state(false)
	_update_undo_redo_buttons()
	_update_timeline_display()


# ==============================================
#   SPAWN BLOCK DRAG & DROP (ENQUEUE)
# ==============================================

func _on_spawn_block_dropped(block: Control) -> void:
	_close_gap()
	
	if has_completed or is_animating:
		block.snap_back()
		return

	if current_command_index >= command_queue.size():
		block.snap_back()
		return

	var cmd = command_queue[current_command_index]

	if cmd["type"] != CommandType.ENQUEUE:
		bad_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=red]✗ Bad move: dragged spawn block during %s command[/color]" % _command_type_string(cmd["type"]))
		show_feedback("Wrong! Current command is not ENQUEUE", Color.RED, block.global_position)
		block.snap_back()
		_update_undo_redo_buttons()
		_update_timeline_display()
		return

	if _is_over_garbage(block):
		bad_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=red]✗ Bad move: dragged spawn block into trash[/color]")
		show_feedback("Can't trash a spawn block!", Color.RED, block.global_position)
		block.snap_back()
		_update_undo_redo_buttons()
		_update_timeline_display()
		return

	var drop_index = _get_drop_index(block)

	_save_state(false)

	if drop_index == cmd["index"]:
		correct_moves += 1
		_add_code_line("ENQUEUE", 0, cmd["value"])
		_update_correct_moves_label()
		timeline_log.append("[color=green]✓ Enqueued %d at back[/color]" % cmd["value"])
		show_feedback("Correct! Enqueued %d" % cmd["value"], Color.GREEN, block.global_position)

		spawn_stack.erase(block)
		block.queue_free()
		_refresh_spawn_stack_visuals()

		main_array.insert(cmd["index"], cmd["value"])

		_save_state(true)
		_advance_command()
		_rebuild_blocks_from_array()
	else:
		bad_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=red]✗ Wrong drop during Enqueue command[/color]")
		show_feedback("Wrong! Drag to the back ", Color.RED, block.global_position)
		block.snap_back()

	_update_undo_redo_buttons()
	_update_timeline_display()


# ==============================================
#   DROP INDEX DETECTION - HORIZONTAL
# ==============================================

func _get_drop_index(dropped_block: Control) -> int:
	var drop_x = dropped_block.global_position.x + 32.0  # Center X of dropped block

	if block_nodes.is_empty():
		return 0

	# Build list of block center X positions
	var centers: Array[float] = []
	for b in block_nodes:
		if is_instance_valid(b):
			centers.append(b.global_position.x + 32.0)

	# Before first block (drop to the left of the first block) → Insert at front (index 0)
	if drop_x <= centers[0]:
		return 0

	# After last block (drop to the right of the last block) → Insert at back (index = size)
	if drop_x >= centers[centers.size() - 1]:
		return centers.size()

	# Between blocks — find which gap
	for i in range(centers.size() - 1):
		var left = centers[i]
		var right = centers[i + 1]
		if drop_x > left and drop_x < right:
			return i + 1

	return block_nodes.size()


# ==============================================
#   ARRAY BLOCK DRAG & DROP (DEQUEUE)
# ==============================================

func _on_array_block_dropped(block: Control) -> void:
	if has_completed or is_animating:
		block.snap_back()
		return

	if current_command_index >= command_queue.size():
		block.snap_back()
		return

	var cmd = command_queue[current_command_index]
	var block_index = block_nodes.find(block)
	if block_index == -1:
		block.snap_back()
		return

	var dropped_on_garbage = _is_over_garbage(block)

	if not dropped_on_garbage:
		block.snap_back()
		return

	if cmd["type"] != CommandType.DEQUEUE:
		bad_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=red]✗ Bad move: dragged array block to trash during %s command[/color]" % _command_type_string(cmd["type"]))
		show_feedback("Wrong! Current command is not DEQUEUE", Color.RED, block.global_position)
		block.snap_back()
		_update_undo_redo_buttons()
		_update_timeline_display()
		return

	_save_state(false)

	if block_index == cmd["index"]:
		correct_moves += 1
		_add_code_line("DEQUEUE", 0, cmd["value"])
		_update_correct_moves_label()
		timeline_log.append("[color=green]✓ Dequeued front element: %d[/color]" % main_array[0])
		show_feedback("Correct! Dequeued front", Color.GREEN, block.global_position)

		_animate_block_into_trash(block)
		_animate_trash_eat()

		main_array.remove_at(block_index)
		block_nodes.remove_at(block_index)

		await get_tree().create_timer(0.4).timeout
		_save_state(true)
		_advance_command()
		_rebuild_blocks_from_array()
	else:
		bad_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=red]✗ Wrong block during Dequeue command[/color]")
		show_feedback("Wrong! Dequeue the front element", Color.RED, block.global_position)
		block.snap_back()

	_update_undo_redo_buttons()
	_update_timeline_display()


func _is_over_garbage(block: Control) -> bool:
	var block_rect = Rect2(block.global_position, block.size)
	var garbage_rect = Rect2(
		garbage_area.global_position - Vector2(85, 85),
		Vector2(170, 170)
	)
	return garbage_rect.intersects(block_rect)


# ==============================================
#   GARBAGE ANIMATIONS
# ==============================================

func _animate_block_into_trash(block: Control) -> void:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(block, "scale", Vector2(0.1, 0.1), 0.35)
	tween.tween_property(block, "modulate:a", 0.0, 0.35)
	tween.tween_property(block, "global_position", garbage_area.global_position, 0.35)
	await tween.finished
	block.queue_free()


func _animate_trash_eat() -> void:
	var original_scale = garbage_sprite.scale
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(garbage_sprite, "scale", original_scale * 1.3, 0.15)
	tween.tween_property(garbage_sprite, "scale", original_scale, 0.25)


func _animate_trash_hover(correct: bool) -> void:
	garbage_sprite.modulate = Color.GREEN if correct else Color.RED


func _animate_trash_hover_reset() -> void:
	garbage_sprite.modulate = Color.WHITE


# ==============================================
#   GAP OPENING FUNCTIONS (VISUAL FEEDBACK FOR ENQUEUE)
# ==============================================

func _open_gap_at(gap_index: int) -> void:
	"""Opens a gap at the specified index by shifting blocks apart"""
	if _hovered_gap_index == gap_index:
		return  # Already open at this gap
	_hovered_gap_index = gap_index

	if _gap_tween:
		_gap_tween.kill()
	_gap_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	for i in range(block_nodes.size()):
		var block = block_nodes[i]
		if not is_instance_valid(block):
			continue
		var base_x = START_POSITION.x + i * (64.0 + BLOCK_SPACING)
		var target_x: float
		
		if i < gap_index:
			# Blocks left of the gap shift slightly left
			target_x = base_x - GAP_OPEN_AMOUNT * 0.5
		else:
			# Blocks right of the gap shift right
			target_x = base_x + GAP_OPEN_AMOUNT * 0.5
			
		_gap_tween.tween_property(block, "position:x", target_x, 0.2)


func _close_gap() -> void:
	"""Closes any open gap by returning blocks to their original positions"""
	if _hovered_gap_index == -1:
		return
	_hovered_gap_index = -1

	if _gap_tween:
		_gap_tween.kill()
	_gap_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	for i in range(block_nodes.size()):
		var block = block_nodes[i]
		if not is_instance_valid(block):
			continue
		var base_x = START_POSITION.x + i * (64.0 + BLOCK_SPACING)
		_gap_tween.tween_property(block, "position:x", base_x, 0.2)


# ==============================================
#   COMMAND ADVANCEMENT
# ==============================================

func _advance_command() -> void:
	current_command_index += 1
	_update_progress_label()
	
	# Close any open gap
	_close_gap()

	if current_command_index >= command_queue.size():
		_end_assessment("completed")
		return

	_show_current_command()
	_update_timeline_display()


func _command_type_string(type: CommandType) -> String:
	match type:
		CommandType.ENQUEUE: return "ENQUEUE"
		CommandType.DEQUEUE: return "DEQUEUE"
		CommandType.PEEK: return "PEEK"
	return "UNKNOWN"


# ==============================================
#   UNDO / REDO
# ==============================================

func _save_state(was_correct: bool) -> void:
	var state = {
		"array": main_array.duplicate(),
		"command_index": current_command_index,
		"correct_moves": correct_moves,
		"bad_moves": bad_moves,
		"was_correct_move": was_correct,
		"timeline": timeline_log.duplicate(),
		"code_lines": code_lines.duplicate()
	}
	undo_stack.append(state)
	redo_stack.clear()


func _on_undo_pressed() -> void:
	if not _can_undo():
		return
	btn_sound.play()

	if undo_stack.is_empty():
		return

	redo_stack.append({
		"array": main_array.duplicate(),
		"command_index": current_command_index,
		"correct_moves": correct_moves,
		"bad_moves": bad_moves,
		"was_correct_move": false,
		"timeline": timeline_log.duplicate(),
		"code_lines": code_lines.duplicate()
	})

	var state = undo_stack.pop_back()
	_restore_state(state)
	timeline_log.append("[color=gray]↩ Undo performed[/color]")
	_update_timeline_display()
	_update_undo_redo_buttons()


func _on_redo_pressed() -> void:
	if not _can_redo():
		return
	btn_sound.play()

	if redo_stack.is_empty():
		return

	undo_stack.append({
		"array": main_array.duplicate(),
		"command_index": current_command_index,
		"correct_moves": correct_moves,
		"bad_moves": bad_moves,
		"was_correct_move": false,
		"timeline": timeline_log.duplicate(),
		"code_lines": code_lines.duplicate()
	})

	var state = redo_stack.pop_back()
	_restore_state(state)
	timeline_log.append("[color=gray]↪ Redo performed[/color]")
	_update_timeline_display()
	_update_undo_redo_buttons()


func _restore_state(state: Dictionary) -> void:
	main_array = state["array"].duplicate()
	current_command_index = state["command_index"]
	correct_moves = state["correct_moves"]
	bad_moves = state["bad_moves"]
	timeline_log = state["timeline"].duplicate()
	code_lines = state["code_lines"].duplicate()

	_rebuild_blocks_from_array()
	_rebuild_spawn_stack_to_command()
	_show_current_command()
	_update_progress_label()


func _rebuild_spawn_stack_to_command() -> void:
	for child in spawn_slot.get_children():
		child.queue_free()
	spawn_stack.clear()
	await get_tree().process_frame

	var insert_cmds: Array = []
	for i in range(current_command_index, command_queue.size()):
		if command_queue[i]["type"] == CommandType.ENQUEUE:
			insert_cmds.append(command_queue[i])

	for i in range(insert_cmds.size() - 1, -1, -1):
		var cmd = insert_cmds[i]
		var block = BLOCK_SCENE.instantiate()
		block.value = cmd["value"]
		block.draggable = true

		var depth = insert_cmds.size() - 1 - i
		block.position = Vector2(depth * SPAWN_STACK_OFFSET.x, depth * SPAWN_STACK_OFFSET.y)
		block.z_index = insert_cmds.size() - depth

		spawn_slot.add_child(block)
		await get_tree().process_frame
		block.original_position = block.global_position
		block.block_dropped.connect(_on_spawn_block_dropped)
		spawn_stack.push_front(block)

	_refresh_spawn_stack_visuals()


func _can_undo() -> bool:
	return difficulty != 3 and not undo_stack.is_empty() and not has_completed


func _can_redo() -> bool:
	return difficulty != 3 and not redo_stack.is_empty() and not has_completed


func _update_undo_redo_buttons() -> void:
	undo_btn.disabled = not _can_undo()
	redo_btn.disabled = not _can_redo()


# ==============================================
#   ARRAY REBUILD - HORIZONTAL LAYOUT (LEFT=FRONT, RIGHT=REAR)
# ==============================================

func _rebuild_blocks_from_array() -> void:
	# Close any open gap before rebuilding
	_close_gap()
	_hovered_gap_index = -1
	
	for child in array_container.get_children():
		child.queue_free()
	block_nodes.clear()

	await get_tree().process_frame

	var current_x = START_POSITION.x  # Use X coordinate for horizontal layout
	for i in range(main_array.size()):
		var val = main_array[i]
		var block = BLOCK_SCENE.instantiate()
		block.value = val
		block.draggable = true
		
		# Position horizontally: left to right (front to rear)
		block.position = Vector2(current_x, START_POSITION.y) 

		array_container.add_child(block)
		block_nodes.append(block)

		await get_tree().process_frame
		block.original_position = block.global_position

		block.block_dropped.connect(_on_array_block_dropped)
		block.block_pressed.connect(_on_block_pressed)

		# Fade in animation
		block.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(block, "modulate:a", 1.0, 0.25)

		# Move to the right for the next block
		current_x += 64.0 + BLOCK_SPACING 

	if current_command_index < command_queue.size():
		_show_current_command()


# ==============================================
#   DRAG HOVER CHECK
# ==============================================

func _process(delta: float) -> void:
	if timer_running and not has_completed and assessment_time_limit > 0.0:
		time_remaining -= delta
		if time_remaining <= 0:
			time_remaining = 0
			timer_running = false
			tiktak_sound.stop()
			_on_time_up()
		_update_timer_display()

		if time_remaining <= 10.0 and timer_running:
			if not tiktak_sound.playing:
				tiktak_sound.play()

	_check_drag_hover()


func _check_drag_hover() -> void:
	if has_completed:
		_close_gap()
		_animate_trash_hover_reset()
		return

	var dragging_spawn = false
	var dragging_array = false
	var dragged_block: Control = null
	var dragged_array_index: int = -1

	# Check spawn blocks (for ENQUEUE)
	for block in spawn_stack:
		if is_instance_valid(block) and block._dragging:
			dragging_spawn = true
			dragged_block = block
			break

	# Check array blocks (for DEQUEUE)
	if not dragging_spawn:
		for i in range(block_nodes.size()):
			var block = block_nodes[i]
			if is_instance_valid(block) and block._dragging:
				dragging_array = true
				dragged_block = block
				dragged_array_index = i
				break

	# GAP OPENING LOGIC - Only for ENQUEUE commands when dragging a spawn block
	if dragging_spawn and current_command_index < command_queue.size():
		var cmd = command_queue[current_command_index]
		if cmd["type"] == CommandType.ENQUEUE:
			# Calculate where the drop would happen
			var drop_index = _get_drop_index(dragged_block)
			_open_gap_at(drop_index)
		else:
			_close_gap()
	else:
		_close_gap()

	# Garbage hover color logic
	var any_hovering = dragged_block != null and _is_over_garbage(dragged_block)
	if any_hovering:
		var cmd = command_queue[current_command_index] if current_command_index < command_queue.size() else null
		var correct_hover = (
			cmd != null and
			cmd["type"] == CommandType.DEQUEUE and
			dragging_array and
			dragged_array_index == cmd["index"]
		)
		_animate_trash_hover(correct_hover)
	else:
		_animate_trash_hover_reset()


func _update_timer_display() -> void:
	if not timer_label:
		return
	var total_seconds = int(time_remaining)
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]


func _on_time_up() -> void:
	show_feedback("Time's Up!", Color.RED, Vector2(400, 300))
	DB.record_attempt(Global.current_topic, difficulty)
	_end_assessment("timeout")
	if time_up_popup:
		time_up_popup.popup_centered()


# ==============================================
#   ASSESSMENT END & GRADING
# ==============================================

func _end_assessment(reason: String) -> void:
	if has_completed:
		return
	has_completed = true
	completion_type = reason
	timer_running = false
	tiktak_sound.stop()

	undo_btn.disabled = true
	redo_btn.disabled = true

	timeline_log.append("[color=orange]--- Assessment Ended: %s ---[/color]" % reason.to_upper())
	_update_timeline_display()

	if reason == "timeout":
		_show_result_popup("FAIL", {})
		if time_up_popup:
			time_up_popup.popup_centered()
	else:
		var grade = _compute_grade()
		_show_result_popup("PASS" if grade["passed"] else "FAIL", grade)


func _compute_grade() -> Dictionary:
	var total_moves = correct_moves + bad_moves
	var accuracy = float(correct_moves) / max(total_moves, 1) * 100.0
	var threshold = _get_threshold() * 100.0
	var passed = accuracy >= threshold
	var time_used = assessment_time_limit - time_remaining if assessment_time_limit > 0.0 else 0.0

	var coins_earned = 0
	if passed:
		coins_earned = DB.complete_level(Global.current_topic, difficulty)
	else:
		DB.record_attempt(Global.current_topic, difficulty)

	return {
		"passed": passed,
		"accuracy": accuracy,
		"correct_moves": correct_moves,
		"bad_moves": bad_moves,
		"time_used": time_used,
		"coins": coins_earned,
		"threshold": threshold
	}


func _show_result_popup(result: String, grade: Dictionary) -> void:
	if not result_popup:
		return

	var translate_btn = result_popup.get_node_or_null("TextureRect/VBoxContainer/translate_code_btn")

	if result == "PASS":
		result_title.text = "PASSED!"
		result_title.modulate = Color.GREEN
		if translate_btn:
			translate_btn.show()
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")
		if try_again_btn_root:
			try_again_btn_root.hide()
	else:
		result_title.text = "FAILED!"
		result_title.modulate = Color.RED
		if translate_btn:
			translate_btn.hide()
		if cpp_code_button:
			cpp_code_button.hide()
		if try_again_btn_root:
			try_again_btn_root.show()

	if completion_type == "timeout":
		score_summary.text = "Time's Up! Assessment Failed."
		accuracy_label.text = "Accuracy: N/A"
		time_used_label.text = "Time: Expired"
		coins_label.text = "+0"
		if try_again_btn_root:
			try_again_btn_root.show()
	else:
		var mins = int(grade.get("time_used", 0)) / 60
		var secs = int(grade.get("time_used", 0)) % 60
		score_summary.text = "Correct: %d | Wrong: %d" % [grade.get("correct_moves", 0), grade.get("bad_moves", 0)]
		accuracy_label.text = "Accuracy: %.1f%% (Need %.0f%%)" % [grade.get("accuracy", 0.0), grade.get("threshold", 0.0)]
		time_used_label.text = "Time Used: %02d:%02d" % [mins, secs]
		coins_label.text = "+%d" % grade.get("coins", 0)

	result_popup.popup_centered()
	if grade.get("coins", 0) > 0 and coins_anim:
		coins_anim.play("default")


func _on_try_again_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	if time_up_popup and time_up_popup.visible:
		time_up_popup.hide()
	_start_assessment()
	call_deferred("show_introduction")


func _on_try_again_root_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	if time_up_popup and time_up_popup.visible:
		time_up_popup.hide()
	_start_assessment()
	call_deferred("show_introduction")


func _on_back_pressed() -> void:
	btn_sound.play()
	result_popup.hide()


func _on_time_up_try_again_pressed() -> void:
	btn_sound.play()
	if time_up_popup: time_up_popup.hide()
	result_popup.hide()
	_start_assessment()
	call_deferred("show_introduction")


func _on_time_up_back_pressed() -> void:
	btn_sound.play()
	if time_up_popup: time_up_popup.hide()


# ==============================================
#   CODE GENERATION - QUEUE OPERATIONS
# ==============================================

func _add_code_line(op: String, index: int, value: int) -> void:
	code_lines.append("%s|%d|%d" % [op, index, value])


func _generate_code_for_language(lang: String) -> String:
	match lang:
		"python": return _gen_python()
		"java": return _gen_java()
		"c": return _gen_c()
		_: return _gen_cpp()


func _gen_cpp() -> String:
	var code = "/* Queue Assessment - Operations Log */\n"
	code += "#include <iostream>\n#include <queue>\nusing namespace std;\n\n"
	code += "void printQueue(queue<int> q) {\n"
	code += "    cout << \"[\";\n"
	code += "    while (!q.empty()) {\n"
	code += "        cout << q.front();\n"
	code += "        q.pop();\n"
	code += "        if (!q.empty()) cout << \", \";\n"
	code += "    }\n"
	code += "    cout << \"]\" << endl;\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    queue<int> q;\n"
	for v in main_array:
		code += "    q.push(%d);\n" % v
	code += "    cout << \"Initial queue: \";\n"
	code += "    printQueue(q);\n\n"
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		match op:
			"ENQUEUE":
				code += "    // Enqueue %d\n" % val
				code += "    q.push(%d);\n" % val
				code += "    cout << \"After enqueue %d: \";\n" % val
				code += "    printQueue(q);\n\n"
			"DEQUEUE":
				code += "    // Dequeue front element\n"
				code += "    cout << \"Dequeued: \" << q.front() << endl;\n"
				code += "    q.pop();\n"
				code += "    cout << \"After dequeue: \";\n"
				code += "    printQueue(q);\n\n"
			"PEEK":
				code += "    // Peek front element\n"
				code += "    cout << \"Front of queue: \" << q.front() << endl;\n\n"
	code += "    return 0;\n}"
	return code


func _gen_python() -> String:
	var code = "# Queue Assessment - Operations Log\n\n"
	code += "from collections import deque\n\n"
	code += "q = deque(["
	for i in range(main_array.size()):
		if i > 0: code += ", "
		code += str(main_array[i])
	code += "])\n"
	code += "print('Initial queue:', list(q))\n\n"
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		match op:
			"ENQUEUE":
				code += "# Enqueue %d\n" % val
				code += "q.append(%d)\n" % val
				# FIXED: Use f-string format
				code += "print(f\"After enqueue %d: {list(q)}\")\n\n" % val
			"DEQUEUE":
				code += "# Dequeue front element\n"
				code += "print('Dequeued:', q[0])\n"
				code += "q.popleft()\n"
				code += "print('After dequeue:', list(q))\n\n"
			"PEEK":
				code += "# Peek front element\n"
				code += "print('Front of queue:', q[0])\n\n"
	return code


func _gen_java() -> String:
	var code = "/* Queue Assessment - Operations Log */\n"
	code += "import java.util.*;\n\n"
	code += "public class Main {\n"
	code += "    public static void printQueue(Queue<Integer> q) {\n"
	code += "        System.out.print(\"[\");\n"
	code += "        Iterator<Integer> it = q.iterator();\n"
	code += "        while (it.hasNext()) {\n"
	code += "            System.out.print(it.next());\n"
	code += "            if (it.hasNext()) System.out.print(\", \");\n"
	code += "        }\n"
	code += "        System.out.println(\"]\");\n"
	code += "    }\n\n"
	code += "    public static void main(String[] args) {\n"
	code += "        Queue<Integer> q = new LinkedList<>();\n"
	for v in main_array:
		code += "        q.offer(%d);\n" % v
	code += "        System.out.print(\"Initial queue: \");\n"
	code += "        printQueue(q);\n\n"
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		match op:
			"ENQUEUE":
				code += "        // Enqueue %d\n" % val
				code += "        q.offer(%d);\n" % val
				code += "        System.out.print(\"After enqueue %d: \");\n" % val
				code += "        printQueue(q);\n\n"
			"DEQUEUE":
				code += "        // Dequeue front element\n"
				code += "        System.out.println(\"Dequeued: \" + q.poll());\n"
				code += "        System.out.print(\"After dequeue: \");\n"
				code += "        printQueue(q);\n\n"
			"PEEK":
				code += "        // Peek front element\n"
				code += "        System.out.println(\"Front of queue: \" + q.peek());\n\n"
	code += "    }\n"
	code += "}"
	return code


func _gen_c() -> String:
	var code = "/* Queue Assessment - Operations Log */\n"
	code += "#include <stdio.h>\n"
	code += "#include <stdlib.h>\n\n"
	code += "#define MAX 100\n\n"
	code += "int queue[MAX];\n"
	code += "int front = 0, rear = -1;\n\n"
	code += "void enqueue(int val) {\n"
	code += "    if (rear < MAX-1) queue[++rear] = val;\n"
	code += "}\n\n"
	code += "int dequeue() {\n"
	code += "    return queue[front++];\n"
	code += "}\n\n"
	code += "int peek() {\n"
	code += "    return queue[front];\n"
	code += "}\n\n"
	code += "int isEmpty() {\n"
	code += "    return front > rear;\n"
	code += "}\n\n"
	code += "void printQueue() {\n"
	code += "    printf(\"[\");\n"
	code += "    for (int i = front; i <= rear; i++) {\n"
	code += "        printf(\"%d\", queue[i]);\n"
	code += "        if (i < rear) printf(\", \");\n"
	code += "    }\n"
	code += "    printf(\"]\\n\");\n"
	code += "}\n\n"
	code += "int main() {\n"
	for v in main_array:
		code += "    enqueue(%d);\n" % v
	code += "    printf(\"Initial queue: \");\n"
	code += "    printQueue();\n\n"
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		match op:
			"ENQUEUE":
				code += "    // Enqueue %d\n" % val
				code += "    enqueue(%d);\n" % val
				code += "    printf(\"After enqueue %d: \");\n" % val
				code += "    printQueue();\n\n"
			"DEQUEUE":
				code += "    // Dequeue front element\n"
				code += "    printf(\"Dequeued: %d\\n\", peek());\n"
				code += "    dequeue();\n"
				code += "    printf(\"After dequeue: \");\n"
				code += "    printQueue();\n\n"
			"PEEK":
				code += "    // Peek front element\n"
				code += "    printf(\"Front of queue: %d\\n\", peek());\n\n"
	code += "    return 0;\n}"
	return code


# ==============================================
#   CODE POPUP
# ==============================================

func _show_cpp_popup() -> void:
	var code = _generate_code_for_language(current_code_language)
	if cpp_text:
		cpp_text.bbcode_enabled = true
		cpp_text.text = code
	
	cpp_walkthrough_steps = _build_walkthrough_steps()
	cpp_walkthrough_step = 0
	
	if cpp_next_btn:
		if cpp_next_btn.pressed.is_connected(_on_cpp_next_pressed):
			cpp_next_btn.pressed.disconnect(_on_cpp_next_pressed)
		cpp_next_btn.pressed.connect(_on_cpp_next_pressed)
		cpp_next_btn.disabled = false
	
	if cpp_tutorial_panel:
		cpp_tutorial_panel.show()
	
	cpp_popup.popup_centered()
	_update_cpp_walkthrough()


func _set_language(lang: String) -> void:
	btn_sound.play()
	current_code_language = lang
	_show_cpp_popup()


func _on_cpp_code_button_pressed() -> void:
	btn_sound.play()
	_show_cpp_popup()


func _on_cpp_close_pressed() -> void:
	btn_sound.play()
	if cpp_popup: cpp_popup.hide()


func _on_cpp_next_pressed() -> void:
	btn_sound.play()
	cpp_walkthrough_step += 1
	if cpp_walkthrough_step >= cpp_walkthrough_steps.size():
		cpp_walkthrough_step = 0
	_update_cpp_walkthrough()


func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()


func _update_cpp_walkthrough() -> void:
	if cpp_walkthrough_steps.is_empty():
		if cpp_explanation_lbl:
			cpp_explanation_lbl.bbcode_enabled = true
			cpp_explanation_lbl.text = "No walkthrough available."
		return
	
	var step = cpp_walkthrough_steps[cpp_walkthrough_step]
	
	if cpp_explanation_lbl:
		cpp_explanation_lbl.bbcode_enabled = true
		cpp_explanation_lbl.text = step["explanation"]
	
	if cpp_text:
		var code = _generate_code_for_language(current_code_language)
		var lines = code.split("\n")
		var result = ""
		for i in range(lines.size()):
			var highlighted = false
			for hl in step["lines"]:
				if i == hl:
					highlighted = true
					break
			if highlighted:
				result += "[bgcolor=#444400][color=yellow]" + lines[i].replace("[", "[lb]") + "[/color][/bgcolor]\n"
			else:
				result += lines[i].replace("[", "[lb]") + "\n"
		cpp_text.bbcode_enabled = true
		cpp_text.text = result
		if step["lines"].size() > 0:
			await get_tree().process_frame
			cpp_text.scroll_to_line(step["lines"][0])


func _build_walkthrough_steps() -> Array:
	var steps = []
	steps.append({
		"lines": [0, 1, 2],
		"explanation": "[b]Setup[/b]\nQueue initialized with starting values.\nFront is the first element (left side)."
	})
	var line_offset = 8
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		match op:
			"ENQUEUE":
				steps.append({
					"lines": [line_offset, line_offset + 1],
					"explanation": "[b]Enqueue[/b]\nAdded value [color=green]%d[/color] to the back of the queue (right side)." % val
				})
				line_offset += 4
			"DEQUEUE":
				steps.append({
					"lines": [line_offset, line_offset + 1, line_offset + 2],
					"explanation": "[b]Dequeue[/b]\nRemoved front element [color=red]%d[/color] from the queue (left side).\nNext element becomes the new front." % val
				})
				line_offset += 5
			"PEEK":
				steps.append({
					"lines": [line_offset],
					"explanation": "[b]Peek[/b]\nViewed front element [color=cyan]%d[/color] without removing it." % val
				})
				line_offset += 2
	return steps


# ==============================================
#   TIMELINE
# ==============================================

func _on_timeline_pressed() -> void:
	btn_sound.play()
	if timeline_popup.visible:
		timeline_popup.hide()
		return
	if timeline_label:
		timeline_label.bbcode_enabled = true
		timeline_label.text = (
			"\n".join(timeline_log) if not timeline_log.is_empty() else "[center]No actions yet[/center]"
		)
	timeline_popup.popup_centered()
	await get_tree().process_frame
	var scroll = get_node_or_null("TimelinePopup/MainVBox/ScrollContainer")
	if scroll:
		scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value


func _on_timeline_close_pressed() -> void:
	btn_sound.play()
	if timeline_popup:
		timeline_popup.hide()


func _update_timeline_display() -> void:
	if not timeline_label:
		return
	timeline_label.bbcode_enabled = true
	timeline_label.text = "[b]TIMELINE:[/b]\n\n" + (
		"\n".join(timeline_log) if not timeline_log.is_empty() else "[center]No actions yet[/center]"
	)


# ==============================================
#   UTILITY
# ==============================================

func show_feedback(text: String, color: Color, position: Vector2) -> void:
	var feedback_scene = preload("res://scene/FeedbackLabel.tscn")
	var label = feedback_scene.instantiate()
	label.text = text
	label.modulate = color
	label.global_position = position
	add_child(label)
	var anim = label.get_node("AnimationPlayer")
	anim.play("notification_pop")
	anim.animation_finished.connect(func(_a): label.queue_free())


func _array_to_string(arr: Array) -> String:
	var parts: Array[String] = []
	for v in arr:
		parts.append(str(v))
	return ", ".join(parts)


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

	var prev = get_node_or_null("TutorialOverlay/Intro_popup/prev")
	var next = get_node_or_null("TutorialOverlay/Intro_popup/next")
	var skip = get_node_or_null("TutorialOverlay/Intro_popup/skip")

	if prev and not prev.is_connected("pressed", _on_intro_prev_pressed):
		prev.mouse_filter = Control.MOUSE_FILTER_STOP
		prev.pressed.connect(_on_intro_prev_pressed)
	if next and not next.is_connected("pressed", _on_intro_next_pressed):
		next.mouse_filter = Control.MOUSE_FILTER_STOP
		next.pressed.connect(_on_intro_next_pressed)
	if skip and not skip.is_connected("pressed", _on_intro_skip_pressed):
		skip.mouse_filter = Control.MOUSE_FILTER_STOP
		skip.pressed.connect(_on_intro_skip_pressed)


func _update_intro_text() -> void:
	var label = get_node_or_null("TutorialOverlay/Intro_popup/Label")
	var prev = get_node_or_null("TutorialOverlay/Intro_popup/prev")
	var next = get_node_or_null("TutorialOverlay/Intro_popup/next")
	if label:
		label.text = intro_texts[intro_step]
	if prev:
		prev.visible = (intro_step > 0)
	if next:
		next.text = "Finish" if intro_step >= intro_texts.size() - 1 else "Next"


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
			target_label.show()
			command_progress_label.show()


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
		target_label.show()
		command_progress_label.show()


# ==============================================
#   TUTORIAL (HELP BUTTON)
# ==============================================

func _on_help_pressed() -> void:
	btn_sound.play()
	_start_tutorial()


func _start_tutorial() -> void:
	if not tutorial_overlay or not tutorial_box:
		return
	tutorial_in_progress = true
	tutorial_step = 0
	tutorial_nodes = [
		undo_btn,
		redo_btn,
		timeline_btn,
		spawn_area,
		garbage_area,
		target_label
	]
	tutorial_overlay.show()
	if dim_bg:
		dim_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tutorial_box.show()
	tutorial_next.mouse_filter = Control.MOUSE_FILTER_STOP
	tutorial_next.disabled = false
	tutorial_next.z_index = 100
	_show_tutorial_step()


func _show_tutorial_step() -> void:
	if tutorial_step >= tutorial_nodes.size():
		_end_tutorial()
		return

	match tutorial_step:
		0: tutorial_text.text = "UNDO\n\nReverts your last action.\nAvailable on Easy & Medium only."
		1: tutorial_text.text = "REDO\n\nReapplies an undone action.\nAvailable on Easy & Medium only."
		2: tutorial_text.text = "TIMELINE\n\nView history of all your moves."
		3: tutorial_text.text = "SPAWN AREA\n\nBlocks to enqueue are stacked here.\nDrag the top block to the BACK (rightmost position)."
		4: tutorial_text.text = "TRASH\n\nDrag the FRONT block here during DEQUEUE commands."
		5: tutorial_text.text = "COMMAND LABEL\n\nShows your current task.\nRead carefully before acting!"

	if tutorial_step == 4:
		if pointer_sprite:
			pointer_sprite.texture = load("res://assets/point_left.png")
			pointer_sprite.show()
			pointer_sprite.global_position = garbage_area.global_position + Vector2(100, 0)
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
		return

	var node = tutorial_nodes[tutorial_step]
	if node and pointer_sprite:
		pointer_sprite.texture = load("res://assets/point_left.png")
		pointer_sprite.show()
		var pos_x = node.global_position.x + node.size.x + 30
		var pos_y = node.global_position.y + node.size.y * 0.5
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


func _on_tutorial_next_pressed() -> void:
	btn_sound.play()
	tutorial_step += 1
	_show_tutorial_step()


func _end_tutorial() -> void:
	tutorial_in_progress = false
	tutorial_overlay.hide()
	if pointer_sprite:
		pointer_sprite.hide()
		if pointer_sprite.has_meta("tween"):
			pointer_sprite.get_meta("tween").kill()
