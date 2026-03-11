extends Control

# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton
@onready var auto_btn: Button = $VBoxContainer/WaitingElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var compare_label: Label = $MarginContainer/HBoxContainer2/TextureRect/Label
@onready var array_container: Control = $QueueContainer
@onready var dequeued_container: Control = $DequeuedContainer

# NEW: Add a Label node named "CommandLabel" in your main scene for this to work
@onready var command_label: Label = get_node_or_null("CommandLabel")

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
const BLOCK_SCENE := preload("res://Queueblock.tscn")
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

# --- QUEUE SIMULATION VARIABLES ---
var queue_array: Array[int] = []
var queue_nodes: Array[Control] = []
var dequeued_nodes: Array[Control] = []
var spawned_nodes: Array[Control] = []

var timeline_log: Array[String] = []

var max_queue_size: int = 7
var current_command_type: String = ""
var target_action_count: int = 0
var current_action_progress: int = 0
var total_commands_required: int = 0
var commands_completed: int = 0

var mistake_counter: int = 0
var correct_moves: int = 0
var assessment_complete: bool = false
var is_auto_playing: bool = false

var BLOCK_WIDTH: float = 64.0
var BLOCK_SPACING: float = 15.0

# ---------------------------------------------------------
# FIXED GLOBAL POSITIONS BASED ON USER DRAWING:
# ---------------------------------------------------------
var TRASH_POSITION: Vector2 = Vector2(250, 150)  
var SPAWN_POSITION: Vector2 = Vector2(800, 150)  
var START_POSITION: Vector2 = Vector2(350, 420)  
var ANIM_SPEED: float = 1.0

# Add tween tracking for cleanup
var current_tween: Tween = null

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

# Intro Text
var intro_step: int = 0
var intro_texts = [
	"Welcome to Queue Simulation!\nA Queue follows the First-In-First-Out (FIFO) principle. The first element added is the first one removed.",
	"The Rules:\n\n1. Enqueue: Add elements to the BACK of the queue.\n2. Dequeue: Remove elements from the FRONT of the queue.\n3. Watch out for Overflow (full queue) and Underflow (empty queue)!",
	"Instructions:\n\n• Drag spawned blocks DOWN to the queue to Enqueue.\n• Drag front blocks UP to the trash to Dequeue.\n• Follow the command shown on screen to succeed.",
	"Buttons to use:\n\n• Undo – revert last move\n• Redo – reapply move\n• Timeline – view move history",
	"Difficulty Levels:\n\n1. Easy: 5 commands, infinite time\n2. Medium: 8 commands, 60 seconds\n3. Hard: 12 commands, 60 seconds, no undos/redos"
]

# --- CODE TUTORIAL DATA ---
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

# 1. C++ DATA
var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Implementation:\nUsing standard arrays for Queue." },
	{ "lines": [5, 6, 7], "text": "2. Setup Variables:\nFront and Rear pointers initialized to -1." },
	{ "lines": [9, 10, 11, 12, 13, 14, 15, 16], "text": "3. Enqueue Operation:\nCheck for overflow, then increment rear." },
	{ "lines": [18, 19, 20, 21, 22, 23], "text": "4. Dequeue Operation:\nCheck for underflow, then increment front." }
]

# 2. PYTHON DATA
var python_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Implementation:\nPython uses lists to easily act as queues." },
	{ "lines": [4], "text": "2. State:\nThe current queue state." },
	{ "lines": [6, 7], "text": "3. Enqueue Operation:\nAppend adds to the end (rear) of the queue." },
	{ "lines": [9, 10, 11], "text": "4. Dequeue Operation:\nPop(0) removes from the front." }
]

# 3. JAVA DATA
var java_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Structure:\nClass wrapper for Queue." },
	{ "lines": [2, 3, 4], "text": "2. Setup Variables:\nFront, Rear, and the Array." },
	{ "lines": [6, 7, 8, 9, 10, 11, 12], "text": "3. Enqueue Operation:\nAdd element to the rear pointer." },
	{ "lines": [14, 15, 16, 17, 18], "text": "4. Dequeue Operation:\nMove front pointer forward." }
]

# 4. C DATA
var c_tutorial_data = [
	{ "lines": [0], "text": "1. Setup:\nInclude standard I/O." },
	{ "lines": [2, 3, 4], "text": "2. Setup Variables:\nArray with Front and Rear pointers." },
	{ "lines": [6, 7, 8, 9, 10, 11, 12], "text": "3. Enqueue:\nIncrement rear and assign value." },
	{ "lines": [14, 15, 16, 17, 18], "text": "4. Dequeue:\nIncrement front to remove element." }
]

enum SimMode { LECTURE, ASSESSMENT }
var sim_mode: SimMode = SimMode.ASSESSMENT
var difficulty := 2

var time_remaining: float = 0.0
var timer_running: bool = false
var assessment_time_limit: float = 0.0

var undo_stack: Array = []
var redo_stack: Array = []

# Grade tracking
var has_completed_assessment: bool = false
var time_when_completed: float = 0.0
var coins_earned: int = 0
var completion_type: String = ""

func _get_total_commands() -> int:
	match difficulty:
		1: return 5
		2: return 8
		3: return 12
	return 8

func _get_time_limit() -> float:
	match difficulty:
		1: return 100000.0 # Easy
		2: return 60.0    # Medium
		3: return 60.0     # Hard
	return 60.0

func _ready() -> void:
	tiktak_sound = AudioStreamPlayer.new()
	tiktak_sound.stream = TIKTAK_SFX
	add_child(tiktak_sound)
	try_again_button.visible = false
	
	print("Program started — initializing Queue visualizer...")
	randomize()
	
	_setup_visual_zones() 
	
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
	
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if unused_ptr1: unused_ptr1.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	if cpp_code_button: cpp_code_button.hide()
	
	if sort_btn: sort_btn.text = "UNDO"
	if auto_btn: auto_btn.text = "REDO"
	
	if command_label == null:
		print("WARNING: Add a Label node named 'CommandLabel' for queue commands to show!")

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


func _setup_visual_zones() -> void:
	if not array_container: return
	
	var container_height = BLOCK_WIDTH + 40
	var extended_queue_width = 700 # MANUALLY STRETCHED WIDTH
	
	# Drawing zones with Absolute Coordinates, ignoring the QueueContainer offset
	_create_zone("Dequeue", Vector2(TRASH_POSITION.x - 20, TRASH_POSITION.y - 20), Vector2(250, container_height), Color(0.8, 0.2, 0.2, 0.3))
	_create_zone("Spawning dito", Vector2(SPAWN_POSITION.x - 20, SPAWN_POSITION.y - 20), Vector2(250, container_height), Color(0.2, 0.8, 0.2, 0.3))
	
	# Drawing the manually stretched queue box
	_create_zone("Dito queue area (Max 7)", Vector2(START_POSITION.x - 20, START_POSITION.y - 20), Vector2(extended_queue_width, container_height), Color(0.2, 0.4, 0.8, 0.3))

func _create_zone(title: String, pos: Vector2, size: Vector2, color: Color) -> void:
	var rect = ColorRect.new()
	rect.color = color
	rect.size = size
	rect.z_index = -1 # Keep behind the blocks
	
	var border = ReferenceRect.new()
	border.editor_only = false
	border.border_color = color.lightened(0.4)
	border.border_width = 3.0
	border.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	rect.add_child(border)
	
	var lbl = Label.new()
	lbl.text = title
	lbl.position = Vector2(10, -28)
	lbl.add_theme_color_override("font_color", Color.WHITE)
	lbl.add_theme_color_override("font_outline_color", Color.BLACK)
	lbl.add_theme_constant_override("outline_size", 4)
	
	rect.add_child(lbl)
	array_container.add_child(rect)
	# FORCES absolute positioning no matter where the container is
	rect.global_position = pos

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
	
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	clock.visible = false
	clock.modulate = Color(1, 1, 1, 1)
	clock.stop()

	mistake_counter = 0
	correct_moves = 0
	commands_completed = 0
	total_commands_required = _get_total_commands()
	assessment_complete = false
	has_completed_assessment = false
	completion_type = ""
	coins_earned = 0
	
	undo_stack.clear()
	redo_stack.clear()
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
	
	var initial_size = randi_range(2, 5)
	var arr: Array[int] = []
	for i in range(initial_size):
		arr.append(randi_range(1, 99))
	
	_initialize_queue(arr)
	_generate_next_command()
	_update_undo_redo_buttons()

func _process(delta: float) -> void:
	if sim_mode != SimMode.ASSESSMENT or not timer_running or assessment_complete:
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
	_end_assessment("timeout")

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
#   QUEUE INITIALIZATION & COMMANDS
# ==============================================

func _initialize_queue(elements: Array[int]) -> void:
	print("Initializing Queue Array with:", elements)
	audio_player.play()
	
	queue_array = elements.duplicate()
	
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	for n in queue_nodes:
		if is_instance_valid(n): n.queue_free()
	for n in dequeued_nodes:
		if is_instance_valid(n): n.queue_free()
	for n in spawned_nodes:
		if is_instance_valid(n): n.queue_free()
	
	queue_nodes.clear()
	dequeued_nodes.clear()
	spawned_nodes.clear()
	timeline_log.clear()
	
	await get_tree().process_frame
	
	var current_x = START_POSITION.x
	for val in queue_array:
		var new_block = BLOCK_SCENE.instantiate()
		new_block.value = val
		new_block.draggable = true
		new_block.connect("block_dropped", _on_block_dropped)
		
		new_block.modulate.a = 0.0
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(new_block, "modulate:a", 1.0, 0.5)
		
		array_container.add_child(new_block)
		# USE GLOBAL POSITION TO BYPASS OFFSET
		new_block.global_position = Vector2(current_x, START_POSITION.y)
		queue_nodes.append(new_block)
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

func _generate_next_command():
	if commands_completed >= total_commands_required:
		_end_assessment("completed")
		return

	var can_enqueue = queue_array.size() < max_queue_size
	var can_dequeue = queue_array.size() > 0

	if can_enqueue and can_dequeue:
		current_command_type = "enqueue" if randi() % 2 == 0 else "dequeue"
	elif can_enqueue:
		current_command_type = "enqueue"
	else:
		current_command_type = "dequeue"

	target_action_count = 1
	current_action_progress = 0

	if current_command_type == "enqueue":
		target_action_count = randi_range(1, max_queue_size - queue_array.size())
		_spawn_elements_for_enqueue(target_action_count)
		if command_label: command_label.text = "Command: Enqueue %d block(s)" % target_action_count
	else:
		target_action_count = randi_range(1, queue_array.size())
		if command_label: command_label.text = "Command: Dequeue %d block(s)" % target_action_count

func _spawn_elements_for_enqueue(count: int):
	for n in spawned_nodes:
		if is_instance_valid(n): n.queue_free()
	spawned_nodes.clear()
	
	var current_x = SPAWN_POSITION.x
	for i in range(count):
		var new_block = BLOCK_SCENE.instantiate()
		new_block.value = randi_range(1, 99)
		new_block.draggable = true
		new_block.connect("block_dropped", _on_block_dropped)
		
		new_block.modulate.a = 0.0
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(new_block, "modulate:a", 1.0, 0.5)
		
		array_container.add_child(new_block)
		# USE GLOBAL POSITION TO BYPASS OFFSET
		new_block.global_position = Vector2(current_x, SPAWN_POSITION.y)
		spawned_nodes.append(new_block)
		current_x += new_block.size.x + BLOCK_SPACING

func _safe_connect(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

func show_feedback(text: String, color: Color, position: Vector2) -> void:
	var feedback_scene = preload("res://scene/FeedbackLabel.tscn")
	var label = feedback_scene.instantiate()

	label.text = text
	label.modulate = color
	
	var adjusted_position = position + Vector2(0, -50)
	label.global_position = adjusted_position
	
	add_child(label)

	var anim_player: AnimationPlayer = label.get_node("AnimationPlayer")
	anim_player.play("notification_pop")

	anim_player.animation_finished.connect(
		func(_anim_name):
			label.queue_free()
	)

# ==============================================
#   CORE QUEUE LOGIC & VALIDATION
# ==============================================

func _on_block_dropped(dropped_block: Control) -> void:
	if assessment_complete:
		show_feedback("Simulation finished!", Color.ORANGE, dropped_block.global_position)
		_resnap_blocks()
		return
	
	_save_state()
	redo_stack.clear()
	
	var drop_x = dropped_block.global_position.x
	var drop_y = dropped_block.global_position.y
	
	# Uses the drawing map logic:
	# Trash is top left (Y < 320 and X < 600)
	# Queue is bottom (Y >= 320)
	var is_in_trash = drop_y < 320 and drop_x < 600
	var is_in_queue = drop_y >= 320
	
	var is_from_queue = queue_nodes.find(dropped_block) != -1
	var is_from_spawn = spawned_nodes.find(dropped_block) != -1
	
	if current_command_type == "dequeue":
		if is_in_trash and is_from_queue:
			if queue_array.size() == 0:
				_handle_bad_move("Queue Underflow!", dropped_block)
			elif queue_nodes.find(dropped_block) == 0:
				_execute_dequeue(dropped_block)
			else:
				_handle_bad_move("Not FIFO! Dequeue the Front element.", dropped_block)
		else:
			_handle_bad_move("Bad Move! Drag Front block UP to Trash.", dropped_block)
			
	elif current_command_type == "enqueue":
		if is_in_queue and is_from_spawn:
			# FIX: Validates against new size 7
			if queue_array.size() >= max_queue_size:
				_handle_bad_move("Queue Overflow!", dropped_block)
			else:
				var back_x = START_POSITION.x + (queue_array.size() * (BLOCK_WIDTH + BLOCK_SPACING))
				if abs(drop_x - back_x) < 80: # Close to back tolerance
					_execute_enqueue(dropped_block)
				else:
					_handle_bad_move("Enqueue to the Back of the queue!", dropped_block)
		else:
			_handle_bad_move("Bad Move! Drag Spawn block DOWN to Queue.", dropped_block)
			
	_resnap_blocks()
	_update_undo_redo_buttons()

func _execute_dequeue(block: Control):
	correct_moves += 1
	var val = queue_array.pop_front()
	queue_nodes.erase(block)
	
	block.draggable = false
	dequeued_nodes.append(block)
	
	timeline_log.append("[color=green]Success: Dequeued %d[/color]" % val)
	show_feedback("Good Move!", Color.GREEN, block.global_position)
	
	current_action_progress += 1
	_check_command_progress()

func _execute_enqueue(block: Control):
	correct_moves += 1
	spawned_nodes.erase(block)
	queue_array.append(block.value)
	queue_nodes.append(block)
	
	timeline_log.append("[color=green]Success: Enqueued %d[/color]" % block.value)
	show_feedback("Good Move!", Color.GREEN, block.global_position)
	
	current_action_progress += 1
	_check_command_progress()

func _handle_bad_move(reason: String, block: Control):
	mistake_counter += 1
	timeline_log.append("[color=red]Bad Move: %s[/color]" % reason)
	show_feedback(reason, Color.RED, block.global_position)
	_update_ui_labels()

func _check_command_progress():
	if current_action_progress >= target_action_count:
		commands_completed += 1
		timeline_log.append("[color=yellow]--- Command Completed ---[/color]")
		_generate_next_command()
	_update_ui_labels()
	_update_timeline_display()

func _resnap_blocks() -> void:
	var qx = START_POSITION.x
	for child in queue_nodes:
		var tween = create_tween()
		# USE GLOBAL POSITION
		tween.tween_property(child, "global_position", Vector2(qx, START_POSITION.y), 0.2)
		qx += child.size.x + BLOCK_SPACING
		
	var tx = TRASH_POSITION.x
	for child in dequeued_nodes:
		var tween = create_tween()
		tween.tween_property(child, "global_position", Vector2(tx, TRASH_POSITION.y), 0.2)
		tx += 10 
		
	var sx = SPAWN_POSITION.x
	for child in spawned_nodes:
		var tween = create_tween()
		tween.tween_property(child, "global_position", Vector2(sx, SPAWN_POSITION.y), 0.2)
		sx += child.size.x + BLOCK_SPACING

# ==============================================
#   UI & POPUPS
# ==============================================

func _update_ui_labels():
	if sim_mode == SimMode.ASSESSMENT:
		compare_label.text = "Good: %d | Bad: %d" % [correct_moves, mistake_counter]
		if status_label:
			status_label.text = "Commands: %d/%d" % [commands_completed, total_commands_required]

func _show_complete_popup() -> void:
	if complete_popup:
		var txt = "Simulation Finished!\n\nGood Moves: %d\nBad Moves: %d" % [correct_moves, mistake_counter]
		if process_label: process_label.text = txt
		complete_popup.popup_centered()

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
		if scroll_container: scroll_container.scroll_vertical = 0

func _on_timeline_close_pressed() -> void:
	btn_sound.play()
	if timeline_popup:
		timeline_popup.hide()

func _update_timeline_display() -> void:
	if not timeline_label: return
	timeline_label.bbcode_enabled = true
	timeline_label.bbcode_text = "[b]Timeline:[/b]\n" + "\n".join(timeline_log)

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	if complete_popup: complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

# ==============================================
#   CODE VISUALIZER
# ==============================================

func _show_cpp_popup() -> void:
	var code = ""
	var arr_str = ", ".join(queue_array.map(func(x): return str(x)))
	
	match current_code_language:
		"cpp":
			code = get_cpp_bubble_code(arr_str)
			current_tutorial_data = cpp_tutorial_data
		"python":
			code = get_python_bubble_code(arr_str)
			current_tutorial_data = python_tutorial_data
		"java":
			code = get_java_bubble_code(arr_str)
			current_tutorial_data = java_tutorial_data
		"c":
			code = get_c_bubble_code(arr_str)
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
	if cpp_explanation_lbl: cpp_explanation_lbl.text = data["text"]
	
	if cpp_text:
		var base_code = ""
		var arr_str = ", ".join(queue_array.map(func(x): return str(x)))
		
		match current_code_language:
			"cpp": base_code = get_cpp_bubble_code(arr_str)
			"python": base_code = get_python_bubble_code(arr_str)
			"java": base_code = get_java_bubble_code(arr_str)
			"c": base_code = get_c_bubble_code(arr_str)

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

func get_cpp_bubble_code(arr: String) -> String:
	return """/* Array Implementation of Queue */
#include <iostream>
using namespace std;

int queue_arr[100];
int front = -1;
int rear = -1;

void enqueue(int x) {
    if (rear == 99) {
        cout << "Queue Overflow";
        return;
    }
    if (front == -1) front = 0;
    queue_arr[++rear] = x;
}

void dequeue() {
    if (front == -1 || front > rear) {
        cout << "Queue Underflow";
        return;
    }
    front++;
}

int main() {
    // Current Queue Array:
    int elements[] = { %s };
    int n = sizeof(elements) / sizeof(elements[0]);
    for(int i = 0; i < n; i++) enqueue(elements[i]);
    return 0;
}""" % arr

func get_python_bubble_code(arr: String) -> String:
	return """# List Implementation of Queue

queue = []

# Current Queue State:
elements = [%s]

def enqueue(val):
    queue.append(val)

def dequeue():
    if len(queue) > 0:
        return queue.pop(0)
    return "Queue Underflow"

for e in elements:
	enqueue(e)""" % arr

func get_java_bubble_code(arr: String) -> String:
	return """/* Array Implementation of Queue */
class Queue {
    int queue[] = new int[100];
    int front = -1;
    int rear = -1;

    void enqueue(int x) {
        if (rear == 99) return;
        if (front == -1) front = 0;
        queue[++rear] = x;
    }

    void dequeue() {
        if (front == -1 || front > rear) return;
        front++;
    }

    public static void main(String[] args) {
        Queue q = new Queue();
        int elements[] = { %s };
        for(int x : elements) q.enqueue(x);
    }
}""" % arr

func get_c_bubble_code(arr: String) -> String:
	return """/* Array Implementation of Queue */
#include <stdio.h>
int queue[100];
int front = -1, rear = -1;

void enqueue(int val) {
    if (rear == 99) return;
    if (front == -1) front = 0;
    queue[++rear] = val;
}

void dequeue() {
    if (front == -1 || front > rear) return;
    front++;
}

int main() {
    int elements[] = { %s };
    int n = sizeof(elements)/sizeof(elements[0]);
    for(int i=0; i<n; i++) enqueue(elements[i]);
    return 0;
}""" % arr

# ==============================================
#   APP TUTORIAL
# ==============================================

func start_tutorial() -> void:
	print("=== STARTING TUTORIAL ===")
	if not tutorial_overlay or not tutorial_box or not tutorial_text or not tutorial_next:
		return
	
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	_set_main_ui_enabled(false)
	tutorial_overlay.show()
	dim_bg.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{
			"node": sort_btn,
			"title": "UNDO",
			"text": "Allows the user to reverse one or more of their previous actions, returning the game state to a previous point",
			"action": "highlight"
		},
		{
			"node": auto_btn,
			"title": "REDO",
			"text": "Reverses the effect of an Undo command, allowing the user to reapply an action that was previously undone",
			"action": "highlight"
		},
		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View a scrollable history of moves.",
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
#   CONFIG & INTRO
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
	_initialize_queue(arr)
	_generate_next_command()

func _on_config_no_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	var count = randi_range(5, 7)
	var arr: Array[int] = []
	for i in count: arr.append(randi_range(1, 99))
	_set_main_ui_enabled(true)
	help_btn.show()
	_initialize_queue(arr)
	_generate_next_command()

func _on_size_back_pressed(): config_size_modal.hide(); config_modal.show()
func _on_elements_back_pressed(): config_elements_modal.hide(); config_size_modal.show()

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
	btn_sound.play()
	start_tutorial()

# ==============================================
#   UNDO/REDO FUNCTIONS
# ==============================================

func _save_state() -> void:
	var q_vals = []
	for n in queue_nodes: q_vals.append(n.value)
	
	var s_vals = []
	for n in spawned_nodes: s_vals.append(n.value)
	
	var d_vals = []
	for n in dequeued_nodes: d_vals.append(n.value)
	
	undo_stack.append({
		"queue": q_vals,
		"spawn": s_vals,
		"dequeued": d_vals,
		"mistakes": mistake_counter,
		"correct": correct_moves,
		"progress": current_action_progress,
		"commands_comp": commands_completed,
		"cmd_type": current_command_type,
		"target_count": target_action_count
	})

func _on_sort_button_pressed() -> void: # UNDO is sort_btn
	if not _can_undo() or undo_stack.is_empty(): return
	btn_sound.play()
	
	var current_q = []
	for n in queue_nodes: current_q.append(n.value)
	var current_s = []
	for n in spawned_nodes: current_s.append(n.value)
	var current_d = []
	for n in dequeued_nodes: current_d.append(n.value)
	
	redo_stack.append({
		"queue": current_q,
		"spawn": current_s,
		"dequeued": current_d,
		"mistakes": mistake_counter,
		"correct": correct_moves,
		"progress": current_action_progress,
		"commands_comp": commands_completed,
		"cmd_type": current_command_type,
		"target_count": target_action_count
	})
	
	var state = undo_stack.pop_back()
	_restore_state(state)
	
	timeline_log.append("[color=gray]Undo applied[/color]")
	_update_timeline_display()
	_update_undo_redo_buttons()

func _on_waiting_pressed() -> void: # REDO is auto_btn
	if not _can_redo() or redo_stack.is_empty(): return
	btn_sound.play()
	_save_state()
	
	var state = redo_stack.pop_back()
	_restore_state(state)
	
	timeline_log.append("[color=gray]Redo applied[/color]")
	_update_timeline_display()
	_update_undo_redo_buttons()

func _restore_state(state: Dictionary) -> void:
	mistake_counter = state["mistakes"]
	correct_moves = state["correct"]
	current_action_progress = state["progress"]
	commands_completed = state["commands_comp"]
	current_command_type = state["cmd_type"]
	target_action_count = state["target_count"]
	
	if command_label:
		command_label.text = "Command: %s %d block(s)" % [current_command_type.capitalize(), target_action_count]
	
	queue_array = state["queue"].duplicate()
	
	for n in queue_nodes:
		if is_instance_valid(n): n.queue_free()
	for n in spawned_nodes:
		if is_instance_valid(n): n.queue_free()
	for n in dequeued_nodes:
		if is_instance_valid(n): n.queue_free()
		
	queue_nodes.clear()
	spawned_nodes.clear()
	dequeued_nodes.clear()
	
	var current_x = START_POSITION.x
	for val in state["queue"]:
		var b = BLOCK_SCENE.instantiate()
		b.value = val
		b.draggable = true
		b.connect("block_dropped", _on_block_dropped)
		array_container.add_child(b)
		# USE GLOBAL POSITION TO BYPASS OFFSET
		b.global_position = Vector2(current_x, START_POSITION.y)
		queue_nodes.append(b)
		current_x += b.size.x + BLOCK_SPACING
		
	var sx = SPAWN_POSITION.x
	for val in state["spawn"]:
		var b = BLOCK_SCENE.instantiate()
		b.value = val
		b.draggable = true
		b.connect("block_dropped", _on_block_dropped)
		array_container.add_child(b)
		# USE GLOBAL POSITION TO BYPASS OFFSET
		b.global_position = Vector2(sx, SPAWN_POSITION.y)
		spawned_nodes.append(b)
		sx += b.size.x + BLOCK_SPACING
		
	var dx = TRASH_POSITION.x
	for val in state["dequeued"]:
		var b = BLOCK_SCENE.instantiate()
		b.value = val
		b.draggable = false
		array_container.add_child(b)
		# USE GLOBAL POSITION TO BYPASS OFFSET
		b.global_position = Vector2(dx, TRASH_POSITION.y)
		dequeued_nodes.append(b)
		dx += 10
		
	_update_ui_labels()

func _on_try_again_button_pressed() -> void:
	btn_sound.play()
	time_up_popup.hide()
	result_popup.hide()
	_start_assessment_mode()
	await get_tree().process_frame
	_update_undo_redo_buttons()

func _on_back_button_pressed() -> void:
	time_up_popup.hide()

func _update_difficulty_label():
	if not difficulty_label: return
	match difficulty:
		1: difficulty_label.text = "Difficulty: Easy"
		2: difficulty_label.text = "Difficulty: Medium"
		3: difficulty_label.text = "Difficulty: Hard"

func _can_undo() -> bool:
	if assessment_complete or not timer_running: return false
	if difficulty == 3: return false
	return true

func _can_redo() -> bool:
	if assessment_complete or not timer_running: return false
	if difficulty == 3: return false
	return true

func _update_undo_redo_buttons():
	if not sort_btn or not auto_btn: return
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

func _compute_grade() -> Dictionary:
	var total_moves = correct_moves + mistake_counter
	var accuracy = float(correct_moves) / max(total_moves, 1) * 100
	var required_threshold = 60.0 if difficulty == 1 else 75.0
	var passed = accuracy >= required_threshold
	
	var time_used = assessment_time_limit - time_remaining
	
	var coins = 0
	match difficulty:
		1: coins = 5 if not has_completed_assessment else 1
		2: coins = 10 if not has_completed_assessment else 3
		3: coins = 20 if not has_completed_assessment else 5
	
	coins_earned = coins if passed else 0
	
	return {
		"passed": passed,
		"accuracy": accuracy,
		"correct_moves": correct_moves,
		"mistake_counter": mistake_counter,
		"time_used": time_used,
		"coins": coins_earned,
		"required": required_threshold
	}

func _end_assessment(reason: String) -> void:
	if has_completed_assessment: return
	
	has_completed_assessment = true
	assessment_complete = true
	completion_type = reason
	
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	timer_running = false
	tiktak_sound.stop()
	
	if sort_btn: sort_btn.disabled = true
	if auto_btn: auto_btn.disabled = true
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	
	if reason == "timeout":
		_show_result_popup("FAIL")
	else:
		var grade = _compute_grade()
		var result = "PASS" if grade["passed"] else "FAIL"
		_show_result_popup(result, grade)

func _show_result_popup(result: String, grade_data: Dictionary = {}) -> void:
	if not result_popup: return
	if complete_popup and complete_popup.visible: complete_popup.hide()
	
	if result == "PASS":
		result_title.text = "PASSED!"
		result_title.modulate = Color(0, 1, 0)
		if translate_code_btn: translate_code_btn.show()
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
		
		score_summary.text = "Correct: %d | Mistakes: %d" % [grade_data.get("correct_moves", 0), grade_data.get("mistake_counter", 0)]
		accuracy_label.text = "Accuracy: %.1f%% (Need %.0f%%)" % [grade_data.get("accuracy", 0), grade_data.get("required", 0)]
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
