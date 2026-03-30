extends Control
@onready var time_up_back_btn: Button = get_node_or_null("TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/BackButton")
@onready var correct_moves_label: Label = get_node_or_null("MarginContainer/HBoxContainer2/TextureRect/Label")
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
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CompileButton")
var tiktak_sound: AudioStreamPlayer

# --- DIFFICULTY & TIMER ---
var difficulty: int = 3
var time_remaining: float = 0.0
var timer_running: bool = false
var assessment_time_limit: float = 0.0

# --- ARRAY STATE ---
var main_array: Array[int] = []
var block_nodes: Array[Control] = []
var max_array_size: int = 7
var BLOCK_SPACING: float = 30.0
var START_POSITION: Vector2 = Vector2(60, 80)

enum CommandType { INSERT, DELETE, ACCESS }

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

# Each undo entry: {
#   "array": Array[int],
#   "block_values": Array[int],
#   "command_index": int,
#   "correct_moves": int,
#   "bad_moves": int,
#   "was_correct_move": bool   # whether this state change was a correct move
# }

# --- TIMELINE ---
var timeline_log: Array[String] = []

# --- ANIMATION ---
var is_animating: bool = false
var ANIM_SPEED: float = 0.3

# --- INTRO ---
var intro_step: int = 0
var intro_texts: Array = [
	"WELCOME TO STACK ASSESSMENT!\n\nPut your stack knowledge to the test. The system will give you commands one at a time.",
	"COMMANDS:\n\n• Insert # at index # — drag the block from the spawn area to the correct slot\n• Delete block at index # — drag the correct block to the trash\n• Access index # — tap the correct block",
	"SPAWN AREA (upper left):\n\nBlocks waiting to be inserted are stacked here. The top block is always the current one to drag.",
	"TRASH (upper right):\n\nDrag unwanted blocks here during DELETE commands. Wrong blocks snap back!",
	"SCORING:\n\n✓ Correct action = Good move\n✗ Wrong action = Bad move\n\nAccuracy = Good moves / Total moves\n\nUndo/Redo available on Easy & Medium!"
]

# --- TUTORIAL ---
var tutorial_step: int = 0
var tutorial_nodes: Array = []
var tutorial_in_progress: bool = false

var current_code_language: String = "cpp"
var cpp_walkthrough_steps: Array = []
var cpp_walkthrough_step: int = 0
var code_lines: Array[String] = []
const API_KEYS = {
	"cpp": {
		"clientId": "29cb443cb807bccf8958679fa40067dc",
		"clientSecret": "ac4b99a6102b8b472e8da670798941ddbbd47148e97a554eccce100246ccb1ad"
	},
	"c": {
		"clientId": "29cb443cb807bccf8958679fa40067dc",
		"clientSecret": "ac4b99a6102b8b472e8da670798941ddbbd47148e97a554eccce100246ccb1ad"
	},
	"java": {
		"clientId": "29cb443cb807bccf8958679fa40067dc",
		"clientSecret": "ac4b99a6102b8b472e8da670798941ddbbd47148e97a554eccce100246ccb1ad"
	},
	"python": {
		"clientId": "29cb443cb807bccf8958679fa40067dc",
		"clientSecret": "ac4b99a6102b8b472e8da670798941ddbbd47148e97a554eccce100246ccb1ad"
	}
}

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

	# Hide unused buttons
	insert_end_btn.hide()
	access_btn.hide()
	end_sim_btn.hide()
	simulate_new_btn.hide()

	# Repurpose buttons
	undo_btn.text = "UNDO"
	redo_btn.text = "REDO"

	# Show timer elements
	timer_label.show()
	clock.show()
	difficulty_label.show()
	var try_again_btn_root = get_node_or_null("TryAgainButton")
	if try_again_btn_root:
		try_again_btn_root.pressed.connect(_on_try_again_root_pressed)
		try_again_btn_root.hide()
	# Connect buttons
	undo_btn.pressed.connect(_on_undo_pressed)
	redo_btn.pressed.connect(_on_redo_pressed)
	timeline_btn.pressed.connect(_on_timeline_pressed)
	if timeline_close_btn:
		timeline_close_btn.pressed.connect(_on_timeline_close_pressed)

	# Connect tutorial
	if tutorial_next:
		tutorial_next.pressed.connect(_on_tutorial_next_pressed)
	var help_btn = get_node_or_null("HelpButton")
	if help_btn:
		help_btn.pressed.connect(_on_help_pressed)
	# ADD THESE:
	var time_up_try_again_btn = get_node_or_null("TimeUpPopup/PanelContainer/VBoxContainer/HBoxContainer/TryAgainButton")
	if time_up_try_again_btn:
		time_up_try_again_btn.pressed.connect(_on_time_up_try_again_pressed)
	if time_up_back_btn:
		time_up_back_btn.pressed.connect(_on_time_up_back_pressed)

	var cpp_code_button = get_node_or_null("CppCodeButton")
	if cpp_code_button:
		cpp_code_button.hide()

	var translate_btn = result_popup.get_node_or_null("TextureRect/VBoxContainer/translate_code_btn")
	if translate_btn:
		translate_btn.pressed.connect(_on_translate_code_pressed)
		translate_btn.hide()

	_update_correct_moves_label()
	# Connect intro buttons
	_ensure_connected(intro_next_btn, "pressed", _on_intro_next_pressed)
	_ensure_connected(intro_prev_btn, "pressed", _on_intro_prev_pressed)
	_ensure_connected(intro_skip_btn, "pressed", _on_intro_skip_pressed)

	var cpp_code_btn = get_node_or_null("CppCodeButton")
	if cpp_code_btn:
		cpp_code_btn.pressed.connect(_on_cpp_code_button_pressed)
		cpp_code_btn.hide()

	var cpp_close = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/close")
	if cpp_close:
		cpp_close.pressed.connect(_on_cpp_close_pressed)

	var cpp_next = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CppNextButton")
	if cpp_next and not cpp_next.is_connected("pressed", _on_cpp_next_pressed):
		cpp_next.pressed.connect(_on_cpp_next_pressed)

	var cpp_lang = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/Cpp_btn")
	var py_lang = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/Py_btn")
	var java_lang = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/Java_btn")
	var c_lang = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/C_btn")
	if cpp_lang: cpp_lang.pressed.connect(func(): _set_language("cpp"))
	if py_lang: py_lang.pressed.connect(func(): _set_language("python"))
	if java_lang: java_lang.pressed.connect(func(): _set_language("java"))
	if c_lang: c_lang.pressed.connect(func(): _set_language("c"))

	_setup_compiler()
	# Start
	_update_difficulty_label()
	_start_assessment()
	call_deferred("show_introduction")


func _on_try_again_root_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	var time_up_node = get_node_or_null("TimeUpPopup")
	if time_up_node and time_up_node.visible:
		time_up_node.hide()
	_start_assessment()
	call_deferred("show_introduction")
	
	
func _enter_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	await get_tree().process_frame
	await get_tree().process_frame
	var current_size = get_viewport().get_visible_rect().size
	if current_size.y > current_size.x:
		get_tree().root.content_scale_size = Vector2i(int(current_size.y), int(current_size.x))

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


func _update_difficulty_label() -> void:
	if not difficulty_label: return
	match difficulty:
		1: difficulty_label.text = "Difficulty: Easy"
		2: difficulty_label.text = "Difficulty: Medium"
		3: difficulty_label.text = "Difficulty: Hard"


# ==============================================
#   ASSESSMENT START
# ==============================================

func _start_assessment() -> void:
	reset_cache_for_scene()
	# Null check
	if not spawn_slot:
		push_error("spawn_slot is null! Check node path.")
		for child in get_children():
			print(child.name, " (", child.get_class(), ")")
		return

	# Stop timer immediately
	timer_running = false
	time_remaining = 0.0

	# Reset state
	main_array.clear()
	block_nodes.clear()
	timeline_log.clear()
	undo_stack.clear()
	redo_stack.clear()
	command_queue.clear()
	spawn_stack.clear()
	correct_moves = 0
	bad_moves = 0
	has_completed = false
	completion_type = ""
	current_command_index = 0
	is_animating = false

	# Clear containers
	for child in array_container.get_children():
		child.queue_free()
	for child in spawn_slot.get_children():
		child.queue_free()

	# Set actual time AFTER reset
	assessment_time_limit = _get_time_limit()
	time_remaining = assessment_time_limit

	# Timer and clock setup
	if difficulty == 1:
		timer_label.hide()
		clock.hide()
		clock.stop()
	else:
		timer_label.show()
		clock.show()
		clock.stop()  # Don't play yet — wait for intro to finish
		_update_timer_display()  # Show correct time immediately

	# Pre-fill array with 3-4 random values
	var initial_size = randi_range(3, 4)
	for i in range(initial_size):
		main_array.append(randi_range(1, 99))

	# Generate command queue
	_generate_commands()
	commands_total = command_queue.size()

	# Build initial blocks
	_rebuild_blocks_from_array()

	# Build spawn stack for all INSERT commands
	_build_spawn_stack()

	# Show first command
	_show_current_command()
	_update_progress_label()
	_update_undo_redo_buttons()

	timeline_log.append("[color=cyan]--- Assessment Started ---[/color]")
	timeline_log.append("[color=cyan]Initial array: [%s][/color]" % _array_to_string(main_array))
	_update_timeline_display()

# ==============================================
#   COMMAND GENERATION (UPDATED FOR STACK)
# ==============================================

func _generate_commands() -> void:
	command_queue.clear()
	var total = _get_command_count()
	var simulated_array: Array[int] = main_array.duplicate()

	for i in range(total):
		var available: Array[CommandType] = []

		if simulated_array.size() < max_array_size:
			available.append(CommandType.INSERT)
		if simulated_array.size() > 0:
			available.append(CommandType.DELETE)
			available.append(CommandType.ACCESS)

		if available.is_empty():
			break

		var chosen_type: CommandType = available[randi() % available.size()]
		var cmd = {}

		match chosen_type:
			CommandType.INSERT:
				var val = randi_range(1, 99)
				cmd = { "type": CommandType.INSERT, "index": 0, "value": val }
				simulated_array.insert(0, val)
			CommandType.DELETE:
				cmd = { "type": CommandType.DELETE, "index": 0, "value": simulated_array[0] }
				simulated_array.remove_at(0)
			CommandType.ACCESS:
				cmd = { "type": CommandType.ACCESS, "index": 0, "value": simulated_array[0] }

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
		if cmd["type"] == CommandType.INSERT:
			insert_cmds.append(cmd)

	if insert_cmds.is_empty():
		return

	# Build reversed so push_front makes index 0 = first command = top
	for i in range(insert_cmds.size() - 1, -1, -1):
		var cmd = insert_cmds[i]
		var block = BLOCK_SCENE.instantiate()
		block.value = cmd["value"]
		block.draggable = true

		var depth = insert_cmds.size() - 1 - i
		# Negative Y offset so deeper blocks appear BELOW the top block
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
			block.z_as_relative = false  # ADD THIS — renders above ALL other nodes
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
		CommandType.INSERT:
			target_label.text = "Push %d onto the stack" % cmd["value"]
		CommandType.DELETE:
			target_label.text = "Pop the top element"
		CommandType.ACCESS:
			target_label.text = "Peek at the top element"

	_clear_all_highlights()
	if cmd["type"] == CommandType.DELETE or cmd["type"] == CommandType.ACCESS:
		if block_nodes.size() > 0 and is_instance_valid(block_nodes[0]):
			block_nodes[0].set_outline_color(
				Color.ORANGE if cmd["type"] == CommandType.DELETE else Color.CYAN
			)

	var spawn_block = _get_current_spawn_block()
	if spawn_block:
		spawn_block.modulate.a = 1.0 if cmd["type"] == CommandType.INSERT else 0.6


func _update_progress_label() -> void:
	command_progress_label.text = "Command: %d/%d" % [current_command_index + 1, commands_total]


func _clear_all_highlights() -> void:
	for block in block_nodes:
		if is_instance_valid(block):
			block.hide_outline()


# ==============================================
#   BLOCK PRESS HANDLER (ACCESS command)
# ==============================================

func _on_block_pressed(block: Control) -> void:
	if has_completed or is_animating:
		return

	if current_command_index >= command_queue.size():
		return

	var cmd = command_queue[current_command_index]
	if cmd["type"] != CommandType.ACCESS:
		return

	var pressed_index = block_nodes.find(block)
	if pressed_index == -1:
		return

	if pressed_index == cmd["index"]:
		correct_moves += 1
		_add_code_line("PUSH", 0, cmd["value"])
		_update_correct_moves_label()
		timeline_log.append("[color=green]✓ Peeked at top element (%d)[/color]" % main_array[0])
		show_feedback("Correct! Accessed index %d" % pressed_index, Color.GREEN, block.global_position)

		block.set_highlight(true)
		await get_tree().create_timer(0.5).timeout
		if is_instance_valid(block):
			block.set_highlight(false)

		_save_state(true)
		_advance_command()
	else:
		bad_moves += 1
		timeline_log.append("[color=red]✗ Wrong block during Peek command[/color]")
		show_feedback("Wrong! Need index %d" % cmd["index"], Color.RED, block.global_position)
		_save_state(false)
	_update_undo_redo_buttons()
	_update_timeline_display()


# ==============================================
#   SPAWN BLOCK DRAG & DROP
# ==============================================

func _on_spawn_block_dropped(block: Control) -> void:
	if has_completed or is_animating:
		block.snap_back()
		return

	if current_command_index >= command_queue.size():
		block.snap_back()
		return

	var cmd = command_queue[current_command_index]

	# If command is not INSERT — bad move, snap back
	if cmd["type"] != CommandType.INSERT:
		bad_moves += 1
		timeline_log.append("[color=red]✗ Bad move: dragged spawn block during %s command[/color]" % _command_type_string(cmd["type"]))
		show_feedback("Wrong! Current command is not INSERT", Color.RED, block.global_position)
		block.snap_back()
		_update_undo_redo_buttons()
		_update_timeline_display()
		return

	# Check if dropped on garbage — snap back, bad move
	if _is_over_garbage(block):
		bad_moves += 1
		timeline_log.append("[color=red]✗ Bad move: dragged spawn block into trash[/color]")
		show_feedback("Can't trash a spawn block!", Color.RED, block.global_position)
		block.snap_back()
		_update_undo_redo_buttons()
		_update_timeline_display()
		return

	# Determine drop index relative to array
	var drop_index = _get_drop_index(block)

	_save_state(false)

	if drop_index == cmd["index"]:
		# Correct insert
		correct_moves += 1
		_add_code_line("PUSH", 0, cmd["value"])
		_update_correct_moves_label()
		timeline_log.append("[color=green]✓ Pushed %d onto stack[/color]" % cmd["value"])
		show_feedback("Correct! Inserted %d at index %d" % [cmd["value"], cmd["index"]], Color.GREEN, block.global_position)

		# Remove from spawn stack
		spawn_stack.erase(block)
		block.queue_free()
		_refresh_spawn_stack_visuals()

		# Insert into array
		main_array.insert(cmd["index"], cmd["value"])

		_save_state(true)
		_advance_command()
		_rebuild_blocks_from_array()
	else:
		bad_moves += 1
		timeline_log.append("[color=red]✗ Wrong drop during Push command[/color]")
		show_feedback("Wrong index! Need index %d" % cmd["index"], Color.RED, block.global_position)
		block.snap_back()

	_update_undo_redo_buttons()
	_update_timeline_display()


func _get_drop_index(dropped_block: Control) -> int:
	var drop_y = dropped_block.global_position.y + 32.0  # Check Y center of dropped block

	if block_nodes.is_empty():
		return 0

	# Build list of block center y positions
	var centers: Array[float] = []
	for b in block_nodes:
		if is_instance_valid(b):
			centers.append(b.global_position.y + 32.0)

	# Before first block (dropped above the top block)
	if drop_y <= centers[0]:
		return 0

	# After last block (dropped below the bottom block)
	if drop_y >= centers[centers.size() - 1]:
		return centers.size()

	# Between blocks — find which gap
	for i in range(centers.size() - 1):
		var top = centers[i]
		var bottom = centers[i + 1]
		if drop_y > top and drop_y < bottom:
			return i + 1

	return block_nodes.size()


# ==============================================
#   ARRAY BLOCK DRAG & DROP (DELETE command)
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

	# Dropped on garbage
	if cmd["type"] != CommandType.DELETE:
		bad_moves += 1
		timeline_log.append("[color=red]✗ Bad move: dragged array block to trash during %s command[/color]" % _command_type_string(cmd["type"]))
		show_feedback("Wrong! Current command is not DELETE", Color.RED, block.global_position)
		block.snap_back()
		_update_undo_redo_buttons()
		_update_timeline_display()
		return

	_save_state(false)

	if block_index == cmd["index"]:
		# Correct delete
		correct_moves += 1
		_add_code_line("PUSH", 0, cmd["value"])
		_update_correct_moves_label()
		timeline_log.append("[color=green]✓ Popped top element (%d)[/color]" % main_array[0])
		show_feedback("Correct! Deleted index %d" % block_index, Color.GREEN, block.global_position)

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
		timeline_log.append("[color=red]✗ Wrong block during Pop command[/color]")
		show_feedback("Wrong block! Need index %d" % cmd["index"], Color.RED, block.global_position)
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
	var original_scale = garbage_sprite.scale  # Store original first
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(garbage_sprite, "scale", original_scale * 1.3, 0.15)
	tween.tween_property(garbage_sprite, "scale", original_scale, 0.25)


func _animate_trash_hover(correct: bool) -> void:
	garbage_sprite.modulate = Color.GREEN if correct else Color.RED


func _animate_trash_hover_reset() -> void:
	garbage_sprite.modulate = Color.WHITE


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
		CommandType.INSERT: return "INSERT"
		CommandType.DELETE: return "DELETE"
		CommandType.ACCESS: return "ACCESS"
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
		"timeline": timeline_log.duplicate()
	}
	undo_stack.append(state)


func _on_undo_pressed() -> void:
	if not _can_undo():
		return
	btn_sound.play()

	if undo_stack.is_empty():
		return

	# Save current to redo
	redo_stack.append({
		"array": main_array.duplicate(),
		"command_index": current_command_index,
		"correct_moves": correct_moves,
		"bad_moves": bad_moves,
		"was_correct_move": false,
		"timeline": timeline_log.duplicate()
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
		"timeline": timeline_log.duplicate()
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

	_rebuild_blocks_from_array()
	_rebuild_spawn_stack_to_command()
	_show_current_command()
	_update_progress_label()


func _rebuild_spawn_stack_to_command() -> void:
	for child in spawn_slot.get_children():
		child.queue_free()
	spawn_stack.clear()

	var insert_cmds: Array = []
	for i in range(current_command_index, command_queue.size()):
		if command_queue[i]["type"] == CommandType.INSERT:
			insert_cmds.append(command_queue[i])

	for i in range(insert_cmds.size() - 1, -1, -1):
		var cmd = insert_cmds[i]
		var block = BLOCK_SCENE.instantiate()
		block.value = cmd["value"]
		block.draggable = true
		spawn_slot.add_child(block)

		var depth = insert_cmds.size() - 1 - i
		block.position = Vector2(depth * SPAWN_STACK_OFFSET.x, depth * SPAWN_STACK_OFFSET.y)
		block.z_index = insert_cmds.size() - depth
		block.connect("block_dropped", _on_spawn_block_dropped.bind(block))
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
#   ARRAY REBUILD
# ==============================================

func _rebuild_blocks_from_array() -> void:
	for child in array_container.get_children():
		child.queue_free()
	block_nodes.clear()

	await get_tree().process_frame

	var current_y = START_POSITION.y # Changed from current_x
	for i in range(main_array.size()):
		var val = main_array[i]
		var block = BLOCK_SCENE.instantiate()
		block.value = val
		block.draggable = true
		
		# Set X to a fixed position, and increment Y
		block.position = Vector2(START_POSITION.x, current_y) 

		# Add to scene FIRST
		array_container.add_child(block)
		block_nodes.append(block)

		# Set original_position AFTER adding to scene so global_position is valid
		await get_tree().process_frame
		block.original_position = block.global_position

		block.block_dropped.connect(_on_array_block_dropped)
		block.block_pressed.connect(_on_block_pressed)

		# Fade in
		block.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(block, "modulate:a", 1.0, 0.25)

		# Add to the Y offset for the next block
		current_y += 64.0 + BLOCK_SPACING 

	if current_command_index < command_queue.size():
		_show_current_command()


# ==============================================
#   GARBAGE HOVER DETECTION (via _process)
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

	_check_garbage_hover()

func _check_garbage_hover() -> void:
	if has_completed:
		return

	var any_hovering = false
	var correct_hovering = false

	# Check spawn blocks
	for block in spawn_stack:
		if not is_instance_valid(block):
			continue
		if block._dragging and _is_over_garbage(block):
			any_hovering = true
			# Spawn block over trash is always wrong
			correct_hovering = false
			break

	# Check array blocks
	if not any_hovering:
		var cmd = command_queue[current_command_index] if current_command_index < command_queue.size() else null
		for i in range(block_nodes.size()):
			var block = block_nodes[i]
			if not is_instance_valid(block):
				continue
			if block._dragging and _is_over_garbage(block):
				any_hovering = true
				correct_hovering = (cmd != null and cmd["type"] == CommandType.DELETE and i == cmd["index"])
				break

	if any_hovering:
		_animate_trash_hover(correct_hovering)
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


func _get_threshold() -> float:
	match difficulty:
		1: return 0.6
		2: return 0.75
		3: return 0.8
	return 0.7


func _show_result_popup(result: String, grade: Dictionary) -> void:
	if not result_popup:
		return

	var translate_btn = result_popup.get_node_or_null("TextureRect/VBoxContainer/translate_code_btn")
	var cpp_code_button = get_node_or_null("CppCodeButton")
	var try_again_btn_root = get_node_or_null("TryAgainButton")

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

func _on_time_up_try_again_pressed() -> void:
	btn_sound.play()
	var time_up_popup_node = get_node_or_null("TimeUpPopup")
	if time_up_popup_node: time_up_popup_node.hide()
	result_popup.hide()
	_start_assessment()
	call_deferred("show_introduction")

func _on_time_up_back_pressed() -> void:
	btn_sound.play()
	var time_up_popup_node = get_node_or_null("TimeUpPopup")
	if time_up_popup_node: time_up_popup_node.hide()
func _on_try_again_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	if time_up_popup and time_up_popup.visible:
		time_up_popup.hide()
	_start_assessment()
	call_deferred("show_introduction")


func _on_back_pressed() -> void:
	btn_sound.play()
	result_popup.hide()


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
			clock.play()  # NOW start the clock animation
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
		clock.play()  # NOW start the clock animation
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
		3: tutorial_text.text = "SPAWN AREA\n\nBlocks to insert are stacked here.\nDrag the top block to the correct array slot."
		4: tutorial_text.text = "TRASH\n\nDrag the correct block here during DELETE commands."
		5: tutorial_text.text = "COMMAND LABEL\n\nShows your current task.\nRead carefully before acting!"

	# Special case: Area2D has no size property, handle separately
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
		return  # Skip the generic pointer code below

	# Generic pointer code for all other steps
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
func _update_correct_moves_label() -> void:
	if correct_moves_label:
		correct_moves_label.text = "Correct Moves: %d" % correct_moves
func _add_code_line(op: String, index: int, value: int) -> void:
	code_lines.append("%s|%d|%d" % [op, index, value])

func _generate_code_for_language(lang: String) -> String:
	match lang:
		"python": return _gen_python()
		"java":   return _gen_java()
		"c":      return _gen_c()
		_:        return _gen_cpp()

func _gen_cpp() -> String:
	var code = "/* Stack Assessment - Operations Log */\n"
	code += "#include <iostream>\n#include <stack>\nusing namespace std;\n\n"
	code += "void printStack(stack<int> s) {\n"
	code += "    cout << \"[TOP] \";\n"
	code += "    while (!s.empty()) { cout << s.top(); s.pop(); if (!s.empty()) cout << \", \"; }\n"
	code += "    cout << \" [BOTTOM]\" << endl;\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    stack<int> s;\n"
	for v in main_array:
		code += "    s.push(%d);\n" % v
	code += "    cout << \"Initial stack: \";\n"
	code += "    printStack(s);\n\n"
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		match op:
			"PUSH":
				code += "    // Push %d\n" % val
				code += "    s.push(%d);\n" % val
				code += "    cout << \"After push %d: \";\n" % val
				code += "    printStack(s);\n\n"
			"POP":
				code += "    // Pop top element\n"
				code += "    cout << \"Popping: \" << s.top() << endl;\n"
				code += "    s.pop();\n"
				code += "    cout << \"After pop: \";\n"
				code += "    printStack(s);\n\n"
			"PEEK":
				code += "    // Peek top element\n"
				code += "    cout << \"Peek: \" << s.top() << endl;\n\n"
	code += "    return 0;\n}"
	return code

func _gen_python() -> String:
	var code = "# Stack Assessment - Operations Log\n\n"
	code += "stack = []\n"
	for v in main_array:
		code += "stack.append(%d)\n" % v
	code += "print('Initial stack (top first):', list(reversed(stack)))\n\n"
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		match op:
			"PUSH":
				code += "# Push %d\n" % val
				code += "stack.append(%d)\n" % val
				code += "print('After push %d:', list(reversed(stack)))\n\n" % val
			"POP":
				code += "# Pop top element\n"
				code += "popped = stack.pop()\n"
				code += "print('Popped:', popped)\n"
				code += "print('After pop:', list(reversed(stack)))\n\n"
			"PEEK":
				code += "# Peek top element\n"
				code += "print('Peek:', stack[-1])\n\n"
	return code

func _gen_java() -> String:
	var code = "/* Stack Assessment - Operations Log */\n"
	code += "import java.util.*;\n\n"
	code += "public class Main {\n"
	code += "    public static void printStack(Stack<Integer> s) {\n"
	code += "        Stack<Integer> temp = new Stack<>();\n"
	code += "        System.out.print(\"[TOP] \");\n"
	code += "        while (!s.isEmpty()) {\n"
	code += "            int v = s.pop();\n"
	code += "            temp.push(v);\n"
	code += "            System.out.print(v);\n"
	code += "            if (!s.isEmpty()) System.out.print(\", \");\n"
	code += "        }\n"
	code += "        while (!temp.isEmpty()) s.push(temp.pop());\n"
	code += "        System.out.println(\" [BOTTOM]\");\n"
	code += "    }\n\n"
	code += "    public static void main(String[] args) {\n"
	code += "        Stack<Integer> s = new Stack<>();\n"
	for v in main_array:
		code += "        s.push(%d);\n" % v
	code += "        System.out.print(\"Initial stack: \");\n"
	code += "        printStack(s);\n\n"
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		match op:
			"PUSH":
				code += "        // Push %d\n" % val
				code += "        s.push(%d);\n" % val
				code += "        System.out.print(\"After push %d: \");\n" % val
				code += "        printStack(s);\n\n"
			"POP":
				code += "        // Pop top element\n"
				code += "        System.out.println(\"Popping: \" + s.peek());\n"
				code += "        s.pop();\n"
				code += "        System.out.print(\"After pop: \");\n"
				code += "        printStack(s);\n\n"
			"PEEK":
				code += "        // Peek top element\n"
				code += "        System.out.println(\"Peek: \" + s.peek());\n\n"
	code += "    }\n}"
	return code

func _gen_c() -> String:
	var code = "/* Stack Assessment - Operations Log */\n"
	code += "#include <stdio.h>\n#include <stdlib.h>\n\n"
	code += "#define MAX 100\n"
	code += "int stack[MAX];\n"
	code += "int top = -1;\n\n"
	code += "void push(int val) { stack[++top] = val; }\n"
	code += "int pop() { return stack[top--]; }\n"
	code += "int peek() { return stack[top]; }\n"
	code += "void printStack() {\n"
	code += "    printf(\"[TOP] \");\n"
	code += "    for (int i = top; i >= 0; i--) {\n"
	code += "        printf(\"%d\", stack[i]);\n"
	code += "        if (i > 0) printf(\", \");\n"
	code += "    }\n"
	code += "    printf(\" [BOTTOM]\\n\");\n"
	code += "}\n\n"
	code += "int main() {\n"
	for v in main_array:
		code += "    push(%d);\n" % v
	code += "    printf(\"Initial stack: \");\n"
	code += "    printStack();\n\n"
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		match op:
			"PUSH":
				code += "    /* Push %d */\n" % val
				code += "    push(%d);\n" % val
				code += "    printf(\"After push %d: \");\n" % val
				code += "    printStack();\n\n"
			"POP":
				code += "    /* Pop top element */\n"
				code += "    printf(\"Popping: %d\\n\", peek());\n"
				code += "    pop();\n"
				code += "    printf(\"After pop: \");\n"
				code += "    printStack();\n\n"
			"PEEK":
				code += "    /* Peek top element */\n"
				code += "    printf(\"Peek: %d\\n\", peek());\n\n"
	code += "    return 0;\n}"
	return code
func _setup_compiler() -> void:
	var compile_btn = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CompileButton")
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
		compiler_output_popup.show_output(current_code_language, {"output": cached.output, "error": cached.error, "memory": cached.memory, "cpu": cached.cpu}, self, false)
	else:
		_compile_code(code)

func _compile_code(code: String) -> void:
	show_feedback("Compiling...", Color.YELLOW, Vector2(200, 200))
	var keys = API_KEYS[current_code_language]
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_compile_completed.bind(http_request, current_code_language))
	var api_language = current_code_language
	if current_code_language == "python": api_language = "python3"
	var body = JSON.new().stringify({
		"clientId": keys["clientId"],
		"clientSecret": keys["clientSecret"],
		"script": code,
		"language": api_language,
		"versionIndex": _get_version_index(current_code_language)
	})
	var error = http_request.request("https://api.jdoodle.com/v1/execute", ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
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
	if json.parse(body.get_string_from_utf8()) != OK:
		show_feedback("Parse error!", Color.RED, Vector2(200, 200))
		return
	if compiler_output_popup:
		compiler_output_popup.show_output(language, json.data, self, false)

func _on_recompile_requested(language: String) -> void:
	_compile_code(_generate_code_for_language(language))

func _on_compiler_output_closed() -> void:
	print("Compiler output closed")

func reset_cache_for_scene() -> void:
	if compiler_output_popup:
		compiler_output_popup.reset_cache_for_scene()

func _on_cpp_code_button_pressed() -> void:
	btn_sound.play()
	_show_cpp_popup()

func _on_cpp_close_pressed() -> void:
	btn_sound.play()
	var cpp_popup = get_node_or_null("CppPopup")
	if cpp_popup: cpp_popup.hide()

func _on_translate_code_pressed() -> void:
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()

func _set_language(lang: String) -> void:
	btn_sound.play()
	current_code_language = lang
	_show_cpp_popup()

func _on_cpp_next_pressed() -> void:
	btn_sound.play()
	cpp_walkthrough_step += 1
	if cpp_walkthrough_step >= cpp_walkthrough_steps.size():
		cpp_walkthrough_step = 0
	_update_cpp_walkthrough()

func _show_cpp_popup() -> void:
	var cpp_popup = get_node_or_null("CppPopup")
	var cpp_text = get_node_or_null("CppPopup/VBoxContainer/ScrollContainer/RichTextLabel")
	var cpp_tutorial_panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
	var cpp_next = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CppNextButton")
	if not cpp_popup: return
	var code = _generate_code_for_language(current_code_language)
	if cpp_text:
		cpp_text.bbcode_enabled = true
		cpp_text.text = code
	cpp_walkthrough_steps = _build_walkthrough_steps()
	cpp_walkthrough_step = 0
	if cpp_next:
		if cpp_next.pressed.is_connected(_on_cpp_next_pressed):
			cpp_next.pressed.disconnect(_on_cpp_next_pressed)
		cpp_next.pressed.connect(_on_cpp_next_pressed)
		cpp_next.disabled = false
	if cpp_tutorial_panel: cpp_tutorial_panel.show()
	cpp_popup.popup_centered()
	_update_cpp_walkthrough()

func _update_cpp_walkthrough() -> void:
	var cpp_explanation_lbl = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")
	var cpp_text = get_node_or_null("CppPopup/VBoxContainer/ScrollContainer/RichTextLabel")
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
		"explanation": "[b]Setup[/b]\nStack initialized with starting values.\nTop of stack is the last pushed element."
	})
	var line_offset = 8
	for line in code_lines:
		var parts = line.split("|")
		var op = parts[0]
		var val = int(parts[2])
		if op == "INITIAL": continue
		match op:
			"PUSH":
				steps.append({
					"lines": [line_offset, line_offset + 1],
					"explanation": "[b]Push[/b]\nPushed value [color=green]%d[/color] onto the top of the stack." % val
				})
				line_offset += 4
			"POP":
				steps.append({
					"lines": [line_offset, line_offset + 1, line_offset + 2],
					"explanation": "[b]Pop[/b]\nRemoved the top element [color=red]%d[/color] from the stack.\nNext element becomes the new top." % val
				})
				line_offset += 5
			"PEEK":
				steps.append({
					"lines": [line_offset],
					"explanation": "[b]Peek[/b]\nViewed top element [color=cyan]%d[/color] without removing it." % val
				})
				line_offset += 2
	return steps
	
func _exit_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_PORTRAIT)
	 
