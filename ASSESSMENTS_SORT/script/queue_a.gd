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
var tiktak_sound: AudioStreamPlayer

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

enum CommandType { INSERT, DELETE, ACCESS }

var command_queue: Array = []
var current_command_index: int = 0
var commands_total: int = 0
var correct_moves: int = 0
var bad_moves: int = 0
var has_completed: bool = false
var completion_type: String = ""

var spawn_stack: Array[Control] = []
const SPAWN_STACK_OFFSET: Vector2 = Vector2(4, 6)

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
# --- INTRO ---
var intro_step: int = 0
var intro_texts: Array = [
	"WELCOME TO QUEUE ASSESSMENT!\n\nPut your queue knowledge to the test. The system will give you commands one at a time.",
	"COMMANDS:\n\n• Insert # at index # — drag the block from the spawn area to the correct slot\n• Delete block at index # — drag the correct block to the trash\n• Access index # — tap the correct block",
	"SPAWN AREA (upper left):\n\nBlocks waiting to be inserted are stacked here. The top block is always the current one to drag.",
	"TRASH (upper right):\n\nDrag unwanted blocks here during DELETE commands. Wrong blocks snap back!",
	"SCORING:\n\n✓ Correct action = Good move\n✗ Wrong action = Bad move\n\nAccuracy = Good moves / Total moves\n\nUndo/Redo available on Easy & Medium!"
]

# --- TUTORIAL ---
var tutorial_step: int = 0
var tutorial_nodes: Array = []
var tutorial_in_progress: bool = false


func _ready() -> void:
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

	# Connect intro buttons
	_ensure_connected(intro_next_btn, "pressed", _on_intro_next_pressed)
	_ensure_connected(intro_prev_btn, "pressed", _on_intro_prev_pressed)
	_ensure_connected(intro_skip_btn, "pressed", _on_intro_skip_pressed)


	# Start
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

# ==============================================
#   COMMAND GENERATION (UPDATED FOR QUEUE)
# ==============================================

func _generate_commands() -> void:
	command_queue.clear()
	var total = _get_command_count()
	var simulated_array: Array[int] = main_array.duplicate()

	# Weight command types based on current simulated state
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
				# QUEUE (Enqueue): Add to the back (End of the array)
				var idx = simulated_array.size() 
				var val = randi_range(1, 99)
				cmd = { "type": CommandType.INSERT, "index": idx, "value": val }
				simulated_array.insert(idx, val)

			CommandType.DELETE:
				# QUEUE (Dequeue): Remove from the front (Index 0)
				var idx = 0 
				cmd = { "type": CommandType.DELETE, "index": idx, "value": simulated_array[idx] }
				simulated_array.remove_at(idx)

			CommandType.ACCESS:
				# QUEUE (Peek): Look at the front (Index 0)
				var idx = 0 
				cmd = { "type": CommandType.ACCESS, "index": idx, "value": simulated_array[idx] }

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
	for i in range(spawn_stack.size()):
		var block = spawn_stack[i]
		if not is_instance_valid(block):
			continue
		if i == 0:
			# Top block — fully visible, no transparency
			block.visible = true
			block.modulate = Color(1, 1, 1, 1.0)
		elif i == 1:
			block.visible = true
			block.modulate = Color(1, 1, 1, 0.6)
		elif i == 2:
			block.visible = true
			block.modulate = Color(1, 1, 1, 0.35)
		else:
			# Hide deeper blocks
			block.visible = false


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
			target_label.text = "Insert %d at index %d" % [cmd["value"], cmd["index"]]
		CommandType.DELETE:
			target_label.text = "Delete block at index %d" % cmd["index"]
		CommandType.ACCESS:
			target_label.text = "Access index %d" % cmd["index"]

	# Highlight target block for DELETE and ACCESS
	_clear_all_highlights()
	if cmd["type"] == CommandType.DELETE or cmd["type"] == CommandType.ACCESS:
		if cmd["index"] < block_nodes.size() and is_instance_valid(block_nodes[cmd["index"]]):
			block_nodes[cmd["index"]].set_outline_color(
				Color.ORANGE if cmd["type"] == CommandType.DELETE else Color.CYAN
			)

	# Show/fade spawn area based on whether current cmd is INSERT
	var current_is_insert = (cmd["type"] == CommandType.INSERT)
	var spawn_block = _get_current_spawn_block()
	if spawn_block:
		spawn_block.modulate.a = 1.0 if current_is_insert else 0.6


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
		timeline_log.append("[color=green]✓ Accessed index %d correctly[/color]" % pressed_index)
		show_feedback("Correct! Accessed index %d" % pressed_index, Color.GREEN, block.global_position)

		block.set_highlight(true)
		await get_tree().create_timer(0.5).timeout
		if is_instance_valid(block):
			block.set_highlight(false)

		_save_state(true)
		_advance_command()
	else:
		bad_moves += 1
		timeline_log.append("[color=red]✗ Wrong access: tapped index %d, needed index %d[/color]" % [pressed_index, cmd["index"]])
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
		timeline_log.append("[color=green]✓ Inserted %d at index %d correctly[/color]" % [cmd["value"], cmd["index"]])
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
		timeline_log.append("[color=red]✗ Wrong insert: dropped at index %d, needed index %d[/color]" % [drop_index, cmd["index"]])
		show_feedback("Wrong index! Need index %d" % cmd["index"], Color.RED, block.global_position)
		block.snap_back()

	_update_undo_redo_buttons()
	_update_timeline_display()

func _get_drop_index(dropped_block: Control) -> int:
	var drop_x = dropped_block.global_position.x + 32.0  # Check X center of dropped block

	if block_nodes.is_empty():
		return 0

	# Build list of block center x positions
	var centers: Array[float] = []
	for b in block_nodes:
		if is_instance_valid(b):
			centers.append(b.global_position.x + 32.0)

	# Before first block (dropped to the left of the first block)
	if drop_x <= centers[0]:
		return 0

	# After last block (dropped to the right of the last block)
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
		timeline_log.append("[color=green]✓ Deleted block at index %d correctly[/color]" % block_index)
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
		timeline_log.append("[color=red]✗ Wrong delete: dragged index %d, needed index %d[/color]" % [block_index, cmd["index"]])
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

	var current_x = START_POSITION.x # Track X instead of Y
	for i in range(main_array.size()):
		var val = main_array[i]
		var block = BLOCK_SCENE.instantiate()
		block.value = val
		block.draggable = true
		
		# Set Y to a fixed position, and increment X
		block.position = Vector2(current_x, START_POSITION.y) 

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

		# Add to the X offset for the next block
		current_x += 64.0 + BLOCK_SPACING 

	if current_command_index < command_queue.size():
		_show_current_command()

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
	if not timer_running and time_remaining <= 0 and assessment_time_limit == 0.0:
		return  # Easy mode, ignore
	show_feedback("Time's Up!", Color.RED, Vector2(400, 300))
	_end_assessment("timeout")



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

	var time_used = assessment_time_limit - time_remaining if assessment_time_limit > 0 else 0.0

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


func _get_threshold() -> float:
	match difficulty:
		1: return 0.6
		2: return 0.75
		3: return 0.8
	return 0.7


func _show_result_popup(result: String, grade: Dictionary) -> void:
	if not result_popup:
		return

	if result == "PASS":
		result_title.text = "PASSED!"
		result_title.modulate = Color.GREEN
	else:
		result_title.text = "FAILED!"
		result_title.modulate = Color.RED

	if completion_type == "timeout":
		score_summary.text = "Time's Up! Assessment Failed."
		accuracy_label.text = "Accuracy: N/A"
		time_used_label.text = "Time: Expired"
		coins_label.text = "+0"
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
