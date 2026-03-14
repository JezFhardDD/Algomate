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
@onready var target_label: Label = get_node_or_null("TargetLabel")
@onready var command_progress_label: Label = get_node_or_null("CommandProgressLabel")
@onready var timer_label: Label = get_node_or_null("VBoxContainer/HBoxContainer/Label2")
@onready var clock: AnimatedSprite2D = get_node_or_null("VBoxContainer/HBoxContainer/AnimatedSprite2D")
@onready var difficulty_label: Label = get_node_or_null("DiificultyLabel")
@onready var head_label: Label = get_node_or_null("HeadLabel")
@onready var tail_label: Label = get_node_or_null("TailLabel")
@onready var correct_moves_label: Label = get_node_or_null("MarginContainer/HBoxContainer2/TextureRect/Label")

# --- CONTAINERS ---
@onready var array_container: Control = get_node_or_null("QueueContainer")
@onready var arrow_layer: Control = get_node_or_null("ArrowLayer")

# --- SPAWN AREA ---
@onready var spawn_area: Control = get_node_or_null("SpawnArea")
@onready var spawn_slot: Control = get_node_or_null("SpawnArea/SpawnSlot")

# --- GARBAGE AREA ---
@onready var garbage_area: Area2D = get_node_or_null("Area2D")
@onready var garbage_sprite: Sprite2D = get_node_or_null("Area2D/Sprite2D")

# --- TIMELINE POPUP ---
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: RichTextLabel = $TimelinePopup/MainVBox/ScrollContainer/VBoxContainer/RichTextLabel
@onready var timeline_close_btn: Button = get_node_or_null("TimelinePopup/MainVBox/CloseButton")

# --- POPUPS ---
@onready var time_up_popup: PopupPanel = get_node_or_null("TimeUpPopup")
@onready var time_up_try_again_btn: Button = get_node_or_null("TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/TryAgainButton")
@onready var time_up_back_btn: Button = get_node_or_null("TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/BackButton")

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

# --- COMPILER INTEGRATION ---
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CompileButton")

# --- TUTORIAL OVERLAY ---
@onready var tutorial_overlay: CanvasLayer = $TutorialOverlay
@onready var dim_bg: ColorRect = $TutorialOverlay/DimBackground
@onready var tutorial_box: Panel = $TutorialOverlay/TutorialBox
@onready var tutorial_text: Label = $TutorialOverlay/TutorialBox/VBoxContainer/TutorialText
@onready var tutorial_next: Button = $TutorialOverlay/TutorialBox/VBoxContainer/NextButton
@onready var pointer_sprite: Sprite2D = $TutorialOverlay/PointerSprite
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

# --- AUDIO ---
@onready var btn_sound: AudioStreamPlayer2D = $btn_sound
@onready var audio_player: AudioStreamPlayer2D = $bgm
@onready var try_again_btn_root: Button = get_node_or_null("TryAgainButton")

# --- BLOCK & AUDIO RESOURCES ---
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
var difficulty: int = 1
var time_remaining: float = 0.0
var timer_running: bool = false
var assessment_time_limit: float = 0.0

# --- LINKED LIST STATE ---
var linked_list: Array[int] = []       # Values in order head to tail
var node_blocks: Array[Control] = []   # Visual blocks matching linked_list
var max_list_size: int = 6
var NODE_SPACING: float = 110.0        # Wide spacing to fit arrows
var START_POSITION: Vector2 = Vector2(0, 100)

# --- ARROW DRAWING ---
var arrow_color: Color = Color.CYAN
var arrow_color_lit: Color = Color.YELLOW
var lit_arrow_indices: Array[int] = []  # Which arrows are lit during traverse
const ARROW_WIDTH: float = 4.0
const ARROWHEAD_SIZE: float = 11.0

# --- COMMAND SYSTEM ---
enum CommandType { INSERT_HEAD, INSERT_TAIL, DELETE_VALUE, FIND_VALUE, TRAVERSE }

var command_queue: Array = []
var current_command_index: int = 0
var commands_total: int = 0
var correct_moves: int = 0
var bad_moves: int = 0
var has_completed: bool = false
var completion_type: String = ""

# Each command: { "type": CommandType, "value": int }

# --- TRAVERSE STATE ---
var traverse_current_step: int = 0     # Which node user needs to tap next
var traverse_target_index: int = 0     # Index of target node in linked_list
var traverse_visited: Array[int] = []  # Indices of correctly tapped nodes

# --- SPAWN STACK ---
var spawn_stack: Array[Control] = []
const SPAWN_STACK_OFFSET: Vector2 = Vector2(4, 6)

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
var _hovered_gap: String = ""          # "head" or "tail" or ""
var _gap_tween: Tween = null

# --- INTRO ---
var intro_step: int = 0
var intro_texts: Array = [
	"WELCOME TO LINKED LIST ASSESSMENT!\n\nTest your knowledge of linked list operations. Commands are given one at a time.",
	"STRUCTURE:\n\nNodes are connected HEAD → TAIL. Each node points to the next via an arrow. There are no indexes!",
	"INSERT COMMANDS:\n\n• Insert at Head — drag spawn block to the leftmost position\n• Insert at Tail — drag spawn block to the rightmost position",
	"DELETE & FIND:\n\n• Delete node with value X — find and drag the correct node to trash\n• Find node with value X — tap the correct node\n\nNo hints — scan the list yourself!",
	"TRAVERSE:\n\n• Traverse to value X — tap nodes one by one from HEAD toward the target value\n• Each correct tap lights up green\n• Wrong tap = bad move, but continue from where you are!",
	"SCORING:\n\nAccuracy = Good moves / Total moves\nUndo/Redo available on Easy & Medium!"
]

# --- TUTORIAL ---
var tutorial_step: int = 0
var tutorial_nodes: Array = []
var tutorial_in_progress: bool = false


func _ready() -> void:
	randomize()

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

	var translate_btn = result_popup.get_node_or_null("TextureRect/VBoxContainer/translate_code_btn")
	if translate_btn:
		translate_btn.pressed.connect(_on_translate_code_pressed)

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
	if try_again_btn_root: try_again_btn_root.hide()

	# Timer elements
	timer_label.show()
	clock.show()
	difficulty_label.show()

	# Connect main buttons
	undo_btn.pressed.connect(_on_undo_pressed)
	redo_btn.pressed.connect(_on_redo_pressed)
	timeline_btn.pressed.connect(_on_timeline_pressed)
	if timeline_close_btn:
		timeline_close_btn.pressed.connect(_on_timeline_close_pressed)

	# Connect TimeUpPopup
	if time_up_try_again_btn:
		time_up_try_again_btn.pressed.connect(_on_time_up_try_again_pressed)
	if time_up_back_btn:
		time_up_back_btn.pressed.connect(_on_time_up_back_pressed)

	# Connect TryAgainButton root
	if try_again_btn_root:
		try_again_btn_root.pressed.connect(_on_try_again_root_pressed)

	# Connect CppCodeButton
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

	_ensure_connected(intro_next_btn, "pressed", _on_intro_next_pressed)
	_ensure_connected(intro_prev_btn, "pressed", _on_intro_prev_pressed)
	_ensure_connected(intro_skip_btn, "pressed", _on_intro_skip_pressed)

	# Setup compiler
	_setup_compiler()

	# Setup ArrowLayer script
	if arrow_layer:
		arrow_layer.draw.connect(_on_arrow_layer_draw)

	_update_difficulty_label()
	_start_assessment()
	call_deferred("show_introduction")


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
		1: return 0.0
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
	
	print("=== Linked List Compile Request ===")
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


# ==============================================
#   ASSESSMENT START
# ==============================================

func _start_assessment() -> void:
	if not spawn_slot:
		push_error("spawn_slot is null!")
		return

	# Reset cache for new assessment
	reset_cache_for_scene()

	timer_running = false
	time_remaining = 0.0

	linked_list.clear()
	node_blocks.clear()
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
	cpp_walkthrough_step = 0
	cpp_walkthrough_steps.clear()
	traverse_current_step = 0
	traverse_target_index = 0
	traverse_visited.clear()
	lit_arrow_indices.clear()

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

	# Pre-fill with 3-4 nodes
	var initial_size = randi_range(3, 4)
	for i in range(initial_size):
		linked_list.append(randi_range(1, 99))

	_add_code_line("INITIAL", 0, 0)
	_generate_commands()
	commands_total = command_queue.size()

	await _rebuild_list_visuals()
	_build_spawn_stack()
	_show_current_command()
	_update_progress_label()
	_update_correct_moves_label()
	_update_undo_redo_buttons()

	timeline_log.append("[color=cyan]--- Assessment Started ---[/color]")
	timeline_log.append("[color=cyan]Initial list: [%s][/color]" % _list_to_string(linked_list))
	_update_timeline_display()


# ==============================================
#   COMMAND GENERATION
# ==============================================

func _generate_commands() -> void:
	command_queue.clear()
	var total = _get_command_count()
	var sim_list: Array[int] = linked_list.duplicate()

	for i in range(total):
		var available: Array[CommandType] = []

		if sim_list.size() < max_list_size:
			available.append(CommandType.INSERT_HEAD)
			available.append(CommandType.INSERT_TAIL)
		if sim_list.size() > 0:
			available.append(CommandType.DELETE_VALUE)
			available.append(CommandType.FIND_VALUE)
		if sim_list.size() > 1:
			available.append(CommandType.TRAVERSE)

		if available.is_empty():
			break

		var chosen: CommandType = available[randi() % available.size()]
		var cmd = {}

		match chosen:
			CommandType.INSERT_HEAD:
				var val = randi_range(1, 99)
				cmd = { "type": CommandType.INSERT_HEAD, "value": val }
				sim_list.push_front(val)
			CommandType.INSERT_TAIL:
				var val = randi_range(1, 99)
				cmd = { "type": CommandType.INSERT_TAIL, "value": val }
				sim_list.push_back(val)
			CommandType.DELETE_VALUE:
				var idx = randi() % sim_list.size()
				cmd = { "type": CommandType.DELETE_VALUE, "value": sim_list[idx] }
				sim_list.remove_at(idx)
			CommandType.FIND_VALUE:
				var idx = randi() % sim_list.size()
				cmd = { "type": CommandType.FIND_VALUE, "value": sim_list[idx] }
			CommandType.TRAVERSE:
				var idx = randi_range(1, sim_list.size() - 1)
				cmd = { "type": CommandType.TRAVERSE, "value": sim_list[idx], "target_index": idx }

		command_queue.append(cmd)

# ==============================================
#   LIST VISUALS & ARROW DRAWING
# ==============================================

func _rebuild_list_visuals() -> void:
	for child in array_container.get_children():
		child.queue_free()
	node_blocks.clear()
	await get_tree().process_frame

	var current_x = START_POSITION.x
	for i in range(linked_list.size()):
		var val = linked_list[i]
		var block = BLOCK_SCENE.instantiate()
		block.value = val
		block.draggable = true
		block.position = Vector2(current_x, START_POSITION.y)
		array_container.add_child(block)
		node_blocks.append(block)
		await get_tree().process_frame
		block.original_position = block.global_position
		block.block_dropped.connect(_on_node_block_dropped)
		block.block_pressed.connect(_on_node_block_pressed)
		block.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(block, "modulate:a", 1.0, 0.25)
		current_x += NODE_SPACING

	_update_head_tail_labels()
	_redraw_arrows()


func _redraw_arrows() -> void:
	if arrow_layer:
		arrow_layer.queue_redraw()


func _on_arrow_layer_draw() -> void:
	if node_blocks.size() < 2:
		return

	for i in range(node_blocks.size() - 1):
		var from_block = node_blocks[i]
		var to_block = node_blocks[i + 1]
		if not is_instance_valid(from_block) or not is_instance_valid(to_block):
			continue

		var from_global = from_block.global_position + Vector2(80, 32)
		var to_global = to_block.global_position + Vector2(0, 32)
		
		var from_pos = from_global - arrow_layer.global_position
		var to_pos = to_global - arrow_layer.global_position

		var color = arrow_color_lit if i in lit_arrow_indices else arrow_color

		arrow_layer.draw_line(from_pos, to_pos, color, ARROW_WIDTH)

		var dir = (to_pos - from_pos).normalized()
		var perp = Vector2(-dir.y, dir.x)
		var tip = to_pos
		var base1 = tip - dir * ARROWHEAD_SIZE + perp * (ARROWHEAD_SIZE * 0.5)
		var base2 = tip - dir * ARROWHEAD_SIZE - perp * (ARROWHEAD_SIZE * 0.5)
		arrow_layer.draw_colored_polygon(PackedVector2Array([tip, base1, base2]), color)


func _update_head_tail_labels() -> void:
	if node_blocks.is_empty():
		if head_label: head_label.hide()
		if tail_label: tail_label.hide()
		return

	var first = node_blocks[0]
	var last = node_blocks[node_blocks.size() - 1]

	if head_label and is_instance_valid(first):
		head_label.show()
		head_label.global_position = first.global_position + Vector2(8, -30)

	if tail_label and is_instance_valid(last):
		tail_label.show()
		tail_label.global_position = last.global_position + Vector2(8, -30)


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
		if cmd["type"] == CommandType.INSERT_HEAD or cmd["type"] == CommandType.INSERT_TAIL:
			insert_cmds.append(cmd)

	if insert_cmds.is_empty():
		return

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


func _refresh_spawn_stack_visuals() -> void:
	var total = spawn_stack.size()
	for i in range(total):
		var block = spawn_stack[i]
		if not is_instance_valid(block): continue
		if i == 0:
			block.visible = true
			block.modulate = Color(1, 1, 1, 1.0)
			block.z_index = total + 10
		elif i == 1:
			block.visible = true
			block.modulate = Color(1, 1, 1, 0.6)
			block.z_index = total - 1
		elif i == 2:
			block.visible = true
			block.modulate = Color(1, 1, 1, 0.35)
			block.z_index = total - 2
		else:
			block.visible = false
			block.z_index = 0


func _rebuild_spawn_stack_to_command() -> void:
	for child in spawn_slot.get_children():
		child.queue_free()
	spawn_stack.clear()
	await get_tree().process_frame

	var insert_cmds: Array = []
	for i in range(current_command_index, command_queue.size()):
		var cmd = command_queue[i]
		if cmd["type"] == CommandType.INSERT_HEAD or cmd["type"] == CommandType.INSERT_TAIL:
			insert_cmds.append(cmd)

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


func _get_current_spawn_block() -> Control:
	if spawn_stack.is_empty(): return null
	return spawn_stack[0]


# ==============================================
#   COMMAND DISPLAY
# ==============================================

func _show_current_command() -> void:
	if current_command_index >= command_queue.size():
		_end_assessment("completed")
		return

	var cmd = command_queue[current_command_index]

	if target_label:
		match cmd["type"]:
			CommandType.INSERT_HEAD:
				target_label.text = "Insert %d at Head" % cmd["value"]
			CommandType.INSERT_TAIL:
				target_label.text = "Insert %d at Tail" % cmd["value"]
			CommandType.DELETE_VALUE:
				target_label.text = "Delete node with value %d" % cmd["value"]
			CommandType.FIND_VALUE:
				target_label.text = "Find node with value %d" % cmd["value"]
			CommandType.TRAVERSE:
				target_label.text = "Traverse to value %d" % cmd["value"]

	if cmd["type"] == CommandType.TRAVERSE:
		traverse_current_step = 0
		traverse_target_index = cmd.get("target_index", 0)
		traverse_visited.clear()
		lit_arrow_indices.clear()
		_redraw_arrows()

	_clear_all_node_visuals()


func _clear_all_node_visuals() -> void:
	for block in node_blocks:
		if is_instance_valid(block):
			block.hide_outline()
			block.set_highlight(false)


func _update_progress_label() -> void:
	if command_progress_label:
		command_progress_label.text = "Command: %d/%d" % [current_command_index + 1, commands_total]


func _update_correct_moves_label() -> void:
	if correct_moves_label:
		correct_moves_label.text = "Correct Moves: %d" % correct_moves


# ==============================================
#   NODE BLOCK PRESSED (FIND & TRAVERSE)
# ==============================================

func _on_node_block_pressed(block: Control) -> void:
	if has_completed:
		show_feedback("Simulation already ended!", Color.ORANGE, block.global_position)
		return
	if is_animating: return
	if current_command_index >= command_queue.size(): return

	var cmd = command_queue[current_command_index]
	var pressed_index = node_blocks.find(block)
	if pressed_index == -1: return

	match cmd["type"]:
		CommandType.FIND_VALUE:
			_handle_find(block, pressed_index, cmd)
		CommandType.TRAVERSE:
			_handle_traverse(block, pressed_index, cmd)


func _handle_find(block: Control, pressed_index: int, cmd: Dictionary) -> void:
	if linked_list[pressed_index] == cmd["value"]:
		_save_undo_state(true)
		correct_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=green]✓ Found value %d correctly[/color]" % cmd["value"])
		_add_code_line("FIND", pressed_index, cmd["value"])
		show_feedback("Found %d!" % cmd["value"], Color.GREEN, block.global_position)
		block.set_highlight(true)
		await get_tree().create_timer(0.5).timeout
		if is_instance_valid(block): block.set_highlight(false)
		_advance_command()
	else:
		_save_undo_state(false)
		bad_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=red]✗ Wrong find: tapped value %d, looking for %d[/color]" % [linked_list[pressed_index], cmd["value"]])
		show_feedback("Not %d! Keep scanning." % cmd["value"], Color.RED, block.global_position)

	_update_undo_redo_buttons()
	_update_timeline_display()


func _handle_traverse(block: Control, pressed_index: int, cmd: Dictionary) -> void:
	if pressed_index == traverse_current_step:
		_save_undo_state(true)
		correct_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=green]✓ Traversed to node %d (value %d)[/color]" % [pressed_index, linked_list[pressed_index]])

		block.set_sorted_visual(true)
		traverse_visited.append(pressed_index)

		if pressed_index < traverse_target_index:
			lit_arrow_indices.append(pressed_index)
			_redraw_arrows()

		traverse_current_step += 1

		if pressed_index == traverse_target_index:
			_add_code_line("TRAVERSE", traverse_target_index, cmd["value"])
			show_feedback("Reached %d!" % cmd["value"], Color.GREEN, block.global_position)
			await get_tree().create_timer(0.6).timeout
			for idx in traverse_visited:
				if idx < node_blocks.size() and is_instance_valid(node_blocks[idx]):
					node_blocks[idx].set_sorted_visual(false)
			lit_arrow_indices.clear()
			_redraw_arrows()
			_advance_command()
		else:
			show_feedback("✓ Node %d" % pressed_index, Color.GREEN, block.global_position)
	else:
		_save_undo_state(false)
		bad_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=red]✗ Wrong traverse order: tapped index %d, expected index %d[/color]" % [pressed_index, traverse_current_step])
		show_feedback("Wrong order! Tap from HEAD" , Color.RED, block.global_position)

	_update_undo_redo_buttons()
	_update_timeline_display()


# ==============================================
#   SPAWN BLOCK DROPPED (INSERT HEAD / TAIL)
# ==============================================

func _on_spawn_block_dropped(block: Control) -> void:
	if has_completed:
		show_feedback("Simulation already ended!", Color.ORANGE, block.global_position)
		block.snap_back()
		return
	if is_animating:
		block.snap_back()
		return
	if current_command_index >= command_queue.size():
		block.snap_back()
		return

	var cmd = command_queue[current_command_index]
	var is_insert = (cmd["type"] == CommandType.INSERT_HEAD or cmd["type"] == CommandType.INSERT_TAIL)

	if not is_insert:
		_save_undo_state(false)
		bad_moves += 1
		_update_correct_moves_label()
		show_feedback("Wrong! Current command is not INSERT", Color.RED, block.global_position)
		timeline_log.append("[color=red]✗ Bad move: dragged spawn block during non-insert command[/color]")
		block.snap_back()
		_update_undo_redo_buttons()
		_update_timeline_display()
		return

	if _is_over_garbage(block):
		_save_undo_state(false)
		bad_moves += 1
		_update_correct_moves_label()
		show_feedback("Can't trash a spawn block!", Color.RED, block.global_position)
		timeline_log.append("[color=red]✗ Bad move: spawn block dragged to trash[/color]")
		block.snap_back()
		_update_undo_redo_buttons()
		_update_timeline_display()
		return

	var dropped_at_head = _is_over_head_zone(block)
	var dropped_at_tail = _is_over_tail_zone(block)

	if cmd["type"] == CommandType.INSERT_HEAD and dropped_at_head:
		_save_undo_state(true)
		correct_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=green]✓ Inserted %d at Head[/color]" % cmd["value"])
		_add_code_line("INSERT_HEAD", 0, cmd["value"])
		show_feedback("Correct! Inserted %d at Head" % cmd["value"], Color.GREEN, block.global_position)
		spawn_stack.erase(block)
		block.queue_free()
		_refresh_spawn_stack_visuals()
		linked_list.push_front(cmd["value"])
		_advance_command()
		await _rebuild_list_visuals()
	elif cmd["type"] == CommandType.INSERT_TAIL and dropped_at_tail:
		_save_undo_state(true)
		correct_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=green]✓ Inserted %d at Tail[/color]" % cmd["value"])
		_add_code_line("INSERT_TAIL", linked_list.size(), cmd["value"])
		show_feedback("Correct! Inserted %d at Tail" % cmd["value"], Color.GREEN, block.global_position)
		spawn_stack.erase(block)
		block.queue_free()
		_refresh_spawn_stack_visuals()
		linked_list.push_back(cmd["value"])
		_advance_command()
		await _rebuild_list_visuals()
	else:
		_save_undo_state(false)
		bad_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=red]✗ Wrong drop: command is %s[/color]" % _command_type_string(cmd["type"]))
		show_feedback("Wrong position! %s" % _command_type_string(cmd["type"]), Color.RED, block.global_position)
		block.snap_back()

	_update_undo_redo_buttons()
	_update_timeline_display()


# ==============================================
#   NODE BLOCK DROPPED (DELETE)
# ==============================================

func _on_node_block_dropped(block: Control) -> void:
	if has_completed:
		show_feedback("Simulation already ended!", Color.ORANGE, block.global_position)
		block.snap_back()
		return
	if is_animating:
		block.snap_back()
		return
	if current_command_index >= command_queue.size():
		block.snap_back()
		return

	var cmd = command_queue[current_command_index]
	var block_index = node_blocks.find(block)
	if block_index == -1:
		block.snap_back()
		return

	var dropped_on_garbage = _is_over_garbage(block)

	if not dropped_on_garbage:
		block.snap_back()
		return

	if cmd["type"] != CommandType.DELETE_VALUE:
		_save_undo_state(false)
		bad_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=red]✗ Bad move: dragged node to trash during %s command[/color]" % _command_type_string(cmd["type"]))
		show_feedback("Wrong! Current command is not DELETE", Color.RED, block.global_position)
		block.snap_back()
		_update_undo_redo_buttons()
		_update_timeline_display()
		return

	if linked_list[block_index] == cmd["value"]:
		_save_undo_state(true)
		correct_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=green]✓ Deleted node with value %d[/color]" % cmd["value"])
		_add_code_line("DELETE", block_index, cmd["value"])
		show_feedback("Correct! Deleted %d" % cmd["value"], Color.GREEN, block.global_position)
		_animate_block_into_trash(block)
		_animate_trash_eat()
		linked_list.remove_at(block_index)
		node_blocks.remove_at(block_index)
		await get_tree().create_timer(0.4).timeout
		_advance_command()
		await _rebuild_list_visuals()
	else:
		_save_undo_state(false)
		bad_moves += 1
		_update_correct_moves_label()
		timeline_log.append("[color=red]✗ Wrong delete: dragged value %d, looking for value %d[/color]" % [linked_list[block_index], cmd["value"]])
		show_feedback("Wrong node! Looking for %d" % cmd["value"], Color.RED, block.global_position)
		block.snap_back()

	_update_undo_redo_buttons()
	_update_timeline_display()


# ==============================================
#   HEAD / TAIL ZONE DETECTION
# ==============================================

func _is_over_head_zone(block: Control) -> bool:
	if node_blocks.is_empty():
		return true
	var first_block = node_blocks[0]
	var block_center_x = block.global_position.x + 32.0
	var head_x = first_block.global_position.x + 32.0
	return block_center_x < head_x + 40.0


func _is_over_tail_zone(block: Control) -> bool:
	if node_blocks.is_empty():
		return true
	var last_block = node_blocks[node_blocks.size() - 1]
	var block_center_x = block.global_position.x + 32.0
	var tail_x = last_block.global_position.x + 32.0
	return block_center_x > tail_x - 40.0


func _is_over_garbage(block: Control) -> bool:
	var block_rect = Rect2(block.global_position, Vector2(64, 64))
	var garbage_rect = Rect2(
		garbage_area.global_position - Vector2(85, 85),
		Vector2(170, 170)
	)
	return garbage_rect.intersects(block_rect)
	
# ==============================================
#   UNDO / REDO
# ==============================================

func _save_undo_state(was_correct: bool) -> void:
	undo_stack.append({
		"list": linked_list.duplicate(),
		"command_index": current_command_index,
		"correct_moves": correct_moves,
		"bad_moves": bad_moves,
		"timeline": timeline_log.duplicate(),
		"code_lines": code_lines.duplicate(),
		"was_correct_move": was_correct,
		"traverse_step": traverse_current_step,
		"traverse_visited": traverse_visited.duplicate(),
		"lit_arrows": lit_arrow_indices.duplicate()
	})
	redo_stack.clear()


func _on_undo_pressed() -> void:
	if not _can_undo(): return
	btn_sound.play()

	redo_stack.append({
		"list": linked_list.duplicate(),
		"command_index": current_command_index,
		"correct_moves": correct_moves,
		"bad_moves": bad_moves,
		"timeline": timeline_log.duplicate(),
		"code_lines": code_lines.duplicate(),
		"was_correct_move": false,
		"traverse_step": traverse_current_step,
		"traverse_visited": traverse_visited.duplicate(),
		"lit_arrows": lit_arrow_indices.duplicate()
	})

	var state = undo_stack.pop_back()
	await _restore_full_state(state)
	timeline_log.append("[color=gray]↩ Undo[/color]")
	_update_timeline_display()
	_update_undo_redo_buttons()
	_update_correct_moves_label()


func _on_redo_pressed() -> void:
	if not _can_redo(): return
	btn_sound.play()

	undo_stack.append({
		"list": linked_list.duplicate(),
		"command_index": current_command_index,
		"correct_moves": correct_moves,
		"bad_moves": bad_moves,
		"timeline": timeline_log.duplicate(),
		"code_lines": code_lines.duplicate(),
		"was_correct_move": false,
		"traverse_step": traverse_current_step,
		"traverse_visited": traverse_visited.duplicate(),
		"lit_arrows": lit_arrow_indices.duplicate()
	})

	var state = redo_stack.pop_back()
	await _restore_full_state(state)
	timeline_log.append("[color=gray]↪ Redo[/color]")
	_update_timeline_display()
	_update_undo_redo_buttons()
	_update_correct_moves_label()


func _restore_full_state(state: Dictionary) -> void:
	linked_list = state["list"].duplicate()
	current_command_index = state["command_index"]
	correct_moves = state["correct_moves"]
	bad_moves = state["bad_moves"]
	timeline_log = state["timeline"].duplicate()
	code_lines = state["code_lines"].duplicate()
	traverse_current_step = state["traverse_step"]
	traverse_visited = state["traverse_visited"].duplicate()
	lit_arrow_indices = state["lit_arrows"].duplicate()

	await _rebuild_list_visuals()
	await _rebuild_spawn_stack_to_command()
	_show_current_command()
	_update_progress_label()
	_update_undo_redo_buttons()


func _can_undo() -> bool:
	return difficulty != 3 and not undo_stack.is_empty() and not has_completed

func _can_redo() -> bool:
	return difficulty != 3 and not redo_stack.is_empty() and not has_completed

func _update_undo_redo_buttons() -> void:
	undo_btn.disabled = not _can_undo()
	redo_btn.disabled = not _can_redo()


# ==============================================
#   COMMAND ADVANCEMENT
# ==============================================

func _advance_command() -> void:
	current_command_index += 1
	_update_progress_label()
	if current_command_index >= command_queue.size():
		_end_assessment("completed")
		return
	_show_current_command()
	_update_timeline_display()


func _command_type_string(type: CommandType) -> String:
	match type:
		CommandType.INSERT_HEAD: return "INSERT HEAD"
		CommandType.INSERT_TAIL: return "INSERT TAIL"
		CommandType.DELETE_VALUE: return "DELETE"
		CommandType.FIND_VALUE: return "FIND"
		CommandType.TRAVERSE: return "TRAVERSE"
	return "UNKNOWN"


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
#   DRAG HOVER CHECK
# ==============================================

func _check_drag_hover() -> void:
	if has_completed:
		_animate_trash_hover_reset()
		return

	var dragging_spawn = false
	var dragging_node = false
	var dragged_block: Control = null
	var dragged_node_index: int = -1

	for block in spawn_stack:
		if is_instance_valid(block) and block._dragging:
			dragging_spawn = true
			dragged_block = block
			break

	if not dragging_spawn:
		for i in range(node_blocks.size()):
			var block = node_blocks[i]
			if is_instance_valid(block) and block._dragging:
				dragging_node = true
				dragged_block = block
				dragged_node_index = i
				break

	if dragging_spawn and current_command_index < command_queue.size():
		var cmd = command_queue[current_command_index]
		var is_insert = cmd["type"] == CommandType.INSERT_HEAD or cmd["type"] == CommandType.INSERT_TAIL
		if is_insert:
			_update_insert_zone_hint(dragged_block, cmd)

	if dragged_block != null and _is_over_garbage(dragged_block):
		var cmd = command_queue[current_command_index] if current_command_index < command_queue.size() else null
		var correct_hover = (
			cmd != null and
			cmd["type"] == CommandType.DELETE_VALUE and
			dragging_node and
			linked_list[dragged_node_index] == cmd["value"]
		)
		_animate_trash_hover(correct_hover)
	else:
		_animate_trash_hover_reset()


func _update_insert_zone_hint(block: Control, cmd: Dictionary) -> void:
	_clear_all_node_visuals()
	if cmd["type"] == CommandType.INSERT_HEAD and not node_blocks.is_empty():
		if is_instance_valid(node_blocks[0]):
			node_blocks[0].set_outline_color(Color.YELLOW)
	elif cmd["type"] == CommandType.INSERT_TAIL and not node_blocks.is_empty():
		if is_instance_valid(node_blocks[node_blocks.size() - 1]):
			node_blocks[node_blocks.size() - 1].set_outline_color(Color.YELLOW)


# ==============================================
#   TIMER & PROCESS
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
	_update_head_tail_labels()


func _update_timer_display() -> void:
	if not timer_label: return
	var total_seconds = int(time_remaining)
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]


func _on_time_up() -> void:
	show_feedback("Time's Up!", Color.RED, Vector2(400, 300))
	_end_assessment("timeout")
	if time_up_popup:
		time_up_popup.popup_centered()


# ==============================================
#   ASSESSMENT END & GRADING
# ==============================================

func _end_assessment(reason: String) -> void:
	if has_completed: return
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
	else:
		var grade = _compute_grade()
		_show_result_popup("PASS" if grade["passed"] else "FAIL", grade)


func _compute_grade() -> Dictionary:
	var total_moves = correct_moves + bad_moves
	var accuracy = float(correct_moves) / max(total_moves, 1) * 100.0
	var threshold = _get_threshold() * 100.0
	var passed = accuracy >= threshold
	var time_used = assessment_time_limit - time_remaining if assessment_time_limit > 0.0 else 0.0
	var coins = 0
	if passed:
		match difficulty:
			1: coins = 5
			2: coins = 10
			3: coins = 20
	return {
		"passed": passed,
		"accuracy": accuracy,
		"correct_moves": correct_moves,
		"bad_moves": bad_moves,
		"time_used": time_used,
		"coins": coins,
		"threshold": threshold
	}


func _show_result_popup(result: String, grade: Dictionary) -> void:
	if not result_popup: return

	var translate_btn = result_popup.get_node_or_null("TextureRect/VBoxContainer/translate_code_btn")

	if result == "PASS":
		result_title.text = "PASSED!"
		result_title.modulate = Color.GREEN
		if cpp_code_button: cpp_code_button.show()
		if translate_btn: translate_btn.show()
		if try_again_btn_root: try_again_btn_root.hide()
	else:
		result_title.text = "FAILED!"
		result_title.modulate = Color.RED
		if cpp_code_button: cpp_code_button.hide()
		if translate_btn: translate_btn.hide()
		if try_again_btn_root: try_again_btn_root.show()

	if completion_type == "timeout":
		score_summary.text = "Time's Up! Assessment Failed."
		accuracy_label.text = "Accuracy: N/A"
		time_used_label.text = "Time: Expired"
		coins_label.text = "+0"
		if try_again_btn_root: try_again_btn_root.show()
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
	if time_up_popup and time_up_popup.visible: time_up_popup.hide()
	_start_assessment()
	call_deferred("show_introduction")

func _on_try_again_root_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	if time_up_popup and time_up_popup.visible: time_up_popup.hide()
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
#   CODE GENERATION - CLEAN OPERATION MESSAGES
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
	var code = "/* Linked List Assessment - Operations Log */\n"
	code += "#include <iostream>\n#include <list>\n#include <algorithm>\nusing namespace std;\n\n"
	code += "void printList(list<int>& ll) {\n"
	code += "    cout << \"[\";\n"
	code += "    for(auto it = ll.begin(); it != ll.end(); ++it) {\n"
	code += "        cout << *it;\n"
	code += "        auto next = it; ++next;\n"
	code += "        if(next != ll.end()) cout << \", \";\n"
	code += "    }\n"
	code += "    cout << \"]\" << endl;\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    list<int> ll = {%s};\n" % _list_to_string(linked_list)
	code += "    cout << \"Initial list: \";\n"
	code += "    printList(ll);\n\n"
	
	var op_counter = 0
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		op_counter += 1
		match op:
			"INSERT_HEAD":
				code += "    // Insert %d at Head\n" % val
				code += "    ll.push_front(%d);\n" % val
				code += "    cout << \"After insert %d at Head: \";\n" % val
				code += "    printList(ll);\n\n"
			"INSERT_TAIL":
				code += "    // Insert %d at Tail\n" % val
				code += "    ll.push_back(%d);\n" % val
				code += "    cout << \"After insert %d at Tail: \";\n" % val
				code += "    printList(ll);\n\n"
			"DELETE":
				code += "    // Delete node with value %d\n" % val
				code += "    ll.remove(%d);\n" % val
				code += "    cout << \"After delete value %d: \";\n" % val
				code += "    printList(ll);\n\n"
			"FIND":
				code += "    // Find node with value %d\n" % val
				code += "    auto it%d = find(ll.begin(), ll.end(), %d);\n" % [op_counter, val]
				code += "    if(it%d != ll.end()) {\n" % op_counter
				code += "        int idx%d = distance(ll.begin(), it%d);\n" % [op_counter, op_counter]
				code += "        cout << \"Found value \" << *it%d << \" at index \" << idx%d << endl;\n" % [op_counter, op_counter]
				code += "    }\n\n"
			"TRAVERSE":
				code += "    // Traverse to value %d\n" % val
				code += "    for(auto it%d = ll.begin(); it%d != ll.end(); ++it%d) {\n" % [op_counter, op_counter, op_counter]
				code += "        if(*it%d == %d) {\n" % [op_counter, val]
				code += "            cout << \"Reached value \" << *it%d << endl;\n" % op_counter
				code += "            break;\n"
				code += "        }\n"
				code += "    }\n\n"
	code += "    return 0;\n}"
	return code


func _gen_python() -> String:
	var code = "# Linked List Assessment - Operations Log\n\n"
	code += "from collections import deque\n\n"
	code += "def print_list(ll):\n"
	code += "    items = list(ll)\n"
	code += "    print('[' + ', '.join(str(x) for x in items) + ']')\n\n"
	code += "ll = deque([%s])\n" % _list_to_string(linked_list)
	code += "print('Initial list: ', end='')\n"
	code += "print_list(ll)\n\n"
	
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		match op:
			"INSERT_HEAD":
				code += "# Insert %d at Head\n" % val
				code += "ll.appendleft(%d)\n" % val
				code += "print('After insert %d at Head: ', end='')\n" % val
				code += "print_list(ll)\n\n"
			"INSERT_TAIL":
				code += "# Insert %d at Tail\n" % val
				code += "ll.append(%d)\n" % val
				code += "print('After insert %d at Tail: ', end='')\n" % val
				code += "print_list(ll)\n\n"
			"DELETE":
				code += "# Delete node with value %d\n" % val
				code += "if %d in ll:\n" % val
				code += "    ll.remove(%d)\n" % val
				code += "print('After delete value %d: ', end='')\n" % val
				code += "print_list(ll)\n\n"
			"FIND":
				code += "# Find node with value %d\n" % val
				code += "if %d in ll:\n" % val
				code += "    idx = list(ll).index(%d)\n" % val
				code += "    print('Found value %d at index ' + str(idx))\n\n" % val
			"TRAVERSE":
				code += "# Traverse to value %d\n" % val
				code += "for node in ll:\n"
				code += "    if node == %d:\n" % val
				code += "        print('Reached value ' + str(node))\n"
				code += "        break\n\n"
	return code


func _gen_java() -> String:
	var code = "/* Linked List Assessment - Operations Log */\n"
	code += "import java.util.*;\n\n"
	code += "public class Main {\n"
	code += "    public static void printList(LinkedList<Integer> ll) {\n"
	code += "        System.out.print(\"[\");\n"
	code += "        for (int i = 0; i < ll.size(); i++) {\n"
	code += "            System.out.print(ll.get(i));\n"
	code += "            if (i < ll.size() - 1) System.out.print(\", \");\n"
	code += "        }\n"
	code += "        System.out.println(\"]\");\n"
	code += "    }\n\n"
	code += "    public static void main(String[] args) {\n"
	code += "        LinkedList<Integer> ll = new LinkedList<>(Arrays.asList(%s));\n" % _list_to_string(linked_list)
	code += "        System.out.print(\"Initial list: \");\n"
	code += "        printList(ll);\n\n"
	
	var op_counter = 0
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		op_counter += 1
		match op:
			"INSERT_HEAD":
				code += "        // Insert %d at Head\n" % val
				code += "        ll.addFirst(%d);\n" % val
				code += "        System.out.print(\"After insert %d at Head: \");\n" % val
				code += "        printList(ll);\n\n"
			"INSERT_TAIL":
				code += "        // Insert %d at Tail\n" % val
				code += "        ll.addLast(%d);\n" % val
				code += "        System.out.print(\"After insert %d at Tail: \");\n" % val
				code += "        printList(ll);\n\n"
			"DELETE":
				code += "        // Delete node with value %d\n" % val
				code += "        ll.removeFirstOccurrence(%d);\n" % val
				code += "        System.out.print(\"After delete value %d: \");\n" % val
				code += "        printList(ll);\n\n"
			"FIND":
				code += "        // Find node with value %d\n" % val
				code += "        int idx%d = ll.indexOf(%d);\n" % [op_counter, val]
				code += "        if(idx%d >= 0) System.out.println(\"Found value %d at index \" + idx%d);\n\n" % [op_counter, val, op_counter]
			"TRAVERSE":
				code += "        // Traverse to value %d\n" % val
				code += "        for(int node%d : ll) {\n" % op_counter
				code += "            if(node%d == %d) {\n" % [op_counter, val]
				code += "                System.out.println(\"Reached value \" + node%d);\n" % op_counter
				code += "                break;\n"
				code += "            }\n"
				code += "        }\n\n"
	code += "    }\n}"
	return code


func _gen_c() -> String:
	var code = "/* Linked List Assessment - Operations Log */\n"
	code += "#include <stdio.h>\n#include <stdlib.h>\n\n"
	code += "typedef struct Node { int data; struct Node* next; } Node;\n\n"
	code += "void printList(Node* head) {\n"
	code += "    printf(\"[\");\n"
	code += "    Node* cur = head;\n"
	code += "    while(cur) {\n"
	code += "        printf(\"%d\", cur->data);\n"
	code += "        if(cur->next) printf(\", \");\n"
	code += "        cur = cur->next;\n"
	code += "    }\n"
	code += "    printf(\"]\\n\");\n"
	code += "}\n\n"
	
	code += "Node* insertHead(Node* head, int val) {\n"
	code += "    Node* n = malloc(sizeof(Node));\n"
	code += "    n->data = val; n->next = head;\n"
	code += "    return n;\n"
	code += "}\n\n"
	
	code += "Node* insertTail(Node* head, int val) {\n"
	code += "    Node* n = malloc(sizeof(Node));\n"
	code += "    n->data = val; n->next = NULL;\n"
	code += "    if(!head) return n;\n"
	code += "    Node* cur = head;\n"
	code += "    while(cur->next) cur = cur->next;\n"
	code += "    cur->next = n;\n"
	code += "    return head;\n"
	code += "}\n\n"
	
	code += "Node* deleteVal(Node* head, int val) {\n"
	code += "    if(!head) return NULL;\n"
	code += "    if(head->data == val) {\n"
	code += "        Node* tmp = head->next;\n"
	code += "        free(head);\n"
	code += "        return tmp;\n"
	code += "    }\n"
	code += "    Node* cur = head;\n"
	code += "    while(cur->next && cur->next->data != val)\n"
	code += "        cur = cur->next;\n"
	code += "    if(cur->next) {\n"
	code += "        Node* tmp = cur->next;\n"
	code += "        cur->next = tmp->next;\n"
	code += "        free(tmp);\n"
	code += "    }\n"
	code += "    return head;\n"
	code += "}\n\n"
	
	code += "int main() {\n"
	code += "    Node* head = NULL;\n\n"
	
	# Build initial list
	var initial_vals = _list_to_string(linked_list)
	var vals = initial_vals.split(", ")
	for v in vals:
		if v.strip_edges() != "":
			code += "    head = insertTail(head, %s);\n" % v.strip_edges()
	
	code += "    printf(\"Initial list: \");\n"
	code += "    printList(head);\n\n"
	
	var op_counter = 0
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		op_counter += 1
		match op:
			"INSERT_HEAD":
				code += "    // Insert %d at Head\n" % val
				code += "    head = insertHead(head, %d);\n" % val
				code += "    printf(\"After insert %d at Head: \");\n" % val
				code += "    printList(head);\n\n"
			"INSERT_TAIL":
				code += "    // Insert %d at Tail\n" % val
				code += "    head = insertTail(head, %d);\n" % val
				code += "    printf(\"After insert %d at Tail: \");\n" % val
				code += "    printList(head);\n\n"
			"DELETE":
				code += "    // Delete node with value %d\n" % val
				code += "    head = deleteVal(head, %d);\n" % val
				code += "    printf(\"After delete value %d: \");\n" % val
				code += "    printList(head);\n\n"
			"FIND":
				code += "    // Find node with value %d\n" % val
				code += "    Node* cur%d = head;\n" % op_counter
				code += "    int idx%d = 0;\n" % op_counter
				code += "    while(cur%d && cur%d->data != %d) { cur%d = cur%d->next; idx%d++; }\n" % [op_counter, op_counter, val, op_counter, op_counter, op_counter]
				code += "    if(cur%d) printf(\"Found value %d at index %%d\\n\", idx%d);\n\n" % [op_counter, val, op_counter]
			"TRAVERSE":
				code += "    // Traverse to value %d\n" % val
				code += "    Node* cur%d = head;\n" % op_counter
				code += "    while(cur%d && cur%d->data != %d)\n" % [op_counter, op_counter, val]
				code += "        cur%d = cur%d->next;\n" % [op_counter, op_counter]
				code += "    if(cur%d) printf(\"Reached value %d\\n\");\n\n" % [op_counter, val]
	
	code += "    return 0;\n}"
	return code


func _build_walkthrough_steps(lang: String) -> Array:
	var steps = []
	steps.append({
		"lines": [0, 1, 2, 3],
		"explanation": "[b]Setup[/b]\nIncludes and initial linked list declaration."
	})
	var line_offset = 5
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		match op:
			"INSERT_HEAD":
				steps.append({
					"lines": [line_offset, line_offset + 1],
					"explanation": "[b]Insert at Head[/b]\nAdded value [color=green]%d[/color] as the new head node.\nPrevious head becomes second node." % val
				})
				line_offset += 3
			"INSERT_TAIL":
				steps.append({
					"lines": [line_offset, line_offset + 1],
					"explanation": "[b]Insert at Tail[/b]\nAdded value [color=green]%d[/color] as the new tail node.\nPrevious tail's next pointer updated." % val
				})
				line_offset += 3
			"DELETE":
				steps.append({
					"lines": [line_offset, line_offset + 1],
					"explanation": "[b]Delete by Value[/b]\nRemoved node with value [color=red]%d[/color].\nPointers updated to bypass the removed node." % val
				})
				line_offset += 3
			"FIND":
				steps.append({
					"lines": [line_offset, line_offset + 1],
					"explanation": "[b]Find by Value[/b]\nSearched for value [color=cyan]%d[/color].\nLinear scan from head — O(n) operation." % val
				})
				line_offset += 2
			"TRAVERSE":
				steps.append({
					"lines": [line_offset, line_offset + 1, line_offset + 2],
					"explanation": "[b]Traverse[/b]\nWalked from head until value [color=yellow]%d[/color] was reached.\nEach step follows the next pointer." % val
				})
				line_offset += 4
	return steps


# ==============================================
#   CODE POPUP
# ==============================================

func _show_cpp_popup() -> void:
	var code = _generate_code_for_language(current_code_language)
	if cpp_text:
		cpp_text.bbcode_enabled = true
		cpp_text.text = code

	cpp_walkthrough_steps = _build_walkthrough_steps(current_code_language)
	cpp_walkthrough_step = 0

	if cpp_next_btn:
		if cpp_next_btn.pressed.is_connected(_on_cpp_next_pressed):
			cpp_next_btn.pressed.disconnect(_on_cpp_next_pressed)
		cpp_next_btn.pressed.connect(_on_cpp_next_pressed)
		cpp_next_btn.mouse_filter = Control.MOUSE_FILTER_STOP
		cpp_next_btn.disabled = false

	if cpp_tutorial_panel: cpp_tutorial_panel.show()
	cpp_popup.popup_centered()
	_update_cpp_walkthrough()


func _on_cpp_next_pressed() -> void:
	btn_sound.play()
	cpp_walkthrough_step += 1
	if cpp_walkthrough_step >= cpp_walkthrough_steps.size():
		cpp_walkthrough_step = 0
	_update_cpp_walkthrough()


func _update_cpp_walkthrough() -> void:
	if cpp_walkthrough_steps.is_empty():
		if cpp_explanation_lbl:
			cpp_explanation_lbl.bbcode_enabled = true
			cpp_explanation_lbl.text = "No walkthrough available."
		return

	var step = cpp_walkthrough_steps[cpp_walkthrough_step]
	var highlight_lines = step["lines"]

	if cpp_explanation_lbl:
		cpp_explanation_lbl.bbcode_enabled = true
		cpp_explanation_lbl.text = step["explanation"]

	if cpp_text:
		var code = _generate_code_for_language(current_code_language)
		var lines = code.split("\n")
		var result = ""
		for i in range(lines.size()):
			var in_range = false
			for hl in highlight_lines:
				if i == hl:
					in_range = true
					break
			if in_range:
				result += "[bgcolor=#444400][color=yellow]" + lines[i].replace("[", "[lb]") + "[/color][/bgcolor]\n"
			else:
				result += lines[i].replace("[", "[lb]") + "\n"
		cpp_text.bbcode_enabled = true
		cpp_text.text = result
		if highlight_lines.size() > 0:
			await get_tree().process_frame
			cpp_text.scroll_to_line(highlight_lines[0])


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

func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()


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
		timeline_label.text = "[b]TIMELINE:[/b]\n\n" + (
			"\n".join(timeline_log) if not timeline_log.is_empty() else "[center]No actions yet[/center]"
		)
	timeline_popup.popup_centered()
	await get_tree().process_frame
	var scroll = get_node_or_null("TimelinePopup/MainVBox/ScrollContainer")
	if scroll:
		scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value

func _on_timeline_close_pressed() -> void:
	btn_sound.play()
	if timeline_popup: timeline_popup.hide()

func _update_timeline_display() -> void:
	if not timeline_label: return
	timeline_label.bbcode_enabled = true
	timeline_label.text = "[b]TIMELINE:[/b]\n\n" + (
		"\n".join(timeline_log) if not timeline_log.is_empty() else "[center]No actions yet[/center]"
	)


# ==============================================
#   UTILITIES
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


func _list_to_string(arr: Array) -> String:
	var parts: Array[String] = []
	for v in arr:
		parts.append(str(v))
	return ", ".join(parts)


# ==============================================
#   INTRO POPUP
# ==============================================

func show_introduction() -> void:
	if not intro_popup: return
	tutorial_overlay.show()
	if dim_bg: dim_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
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
	if label: label.text = intro_texts[intro_step]
	if prev: prev.visible = (intro_step > 0)
	if next: next.text = "Finish" if intro_step >= intro_texts.size() - 1 else "Next"


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
#   TUTORIAL
# ==============================================

func _on_help_pressed() -> void:
	btn_sound.play()
	_start_tutorial()


func _start_tutorial() -> void:
	if not tutorial_overlay or not tutorial_box: return
	tutorial_in_progress = true
	tutorial_step = 0
	tutorial_nodes = [undo_btn, redo_btn, timeline_btn, spawn_area, garbage_area, target_label]
	tutorial_overlay.show()
	if dim_bg: dim_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
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
		3: tutorial_text.text = "SPAWN AREA\n\nBlocks to insert are stacked here.\nDrag to HEAD or TAIL position."
		4: tutorial_text.text = "TRASH\n\nDrag the correct node here during DELETE commands."
		5: tutorial_text.text = "COMMAND LABEL\n\nShows your current task. Read carefully!"

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
