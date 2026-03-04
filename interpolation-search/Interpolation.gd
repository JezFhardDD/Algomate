extends Control

# --- 1. NODE REFERENCES ---

@onready var dequeue_btn: Button = $VBoxContainer/Searchstep
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew

@onready var enqueue_label: Label = $HBoxContainer/Label
@onready var dequeue_label: Label = $HBoxContainer2/Label
@onready var queue_container: Control = $QueueContainer

# --- INPUT POPUP NODES ---
@onready var search_modal: ConfirmationDialog = get_node_or_null("SearchInputModal")
@onready var target_spinbox: SpinBox = get_node_or_null("SearchInputModal/TargetSpinBox")

# Popups
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label

@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: Label = $TimelinePopup/ScrollContainer/VBoxContainer/Label

@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var process_label: Label = $SimulationCompletePopup/VBoxContainer/ProcessLabel

# C++ Popup (UPDATED TO USE RICHTEXTLABEL FOR BBCODE)
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_label: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/CodeScroll/CodeLabel") as RichTextLabel
@onready var cpp_scroll: ScrollContainer = get_node_or_null("CppPopup/VBoxContainer/CodeScroll")
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/close") as Button
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")

# C++ Tutorial Nodes
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_lbl: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")
@onready var cpp_next_btn: Button = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/CppNextButton")

# Main Tutorial Nodes
@onready var tutorial_overlay: CanvasLayer = $TutorialOverlay
@onready var dim_bg: ColorRect = $TutorialOverlay/DimBackground
@onready var tutorial_box: Panel = $TutorialOverlay/TutorialBox
@onready var tutorial_text: Label = $TutorialOverlay/TutorialBox/TutorialText
@onready var tutorial_next: Button = $TutorialOverlay/TutorialBox/NextButton
@onready var pointer_sprite: Sprite2D = $TutorialOverlay/PointerSprite
@onready var help_btn: Button = get_node_or_null("HelpButton")

# Config Modals
@onready var config_modal: Panel = $ConfigChoiceModal
@onready var yes_btn: Button = $ConfigChoiceModal/yesButton
@onready var no_btn: Button = $ConfigChoiceModal/NoButton

@onready var config_size_modal: Panel = $ConfigSizeModal
@onready var size_input: SpinBox = $ConfigSizeModal/SizeSpinBox
@onready var size_back_btn: Button = $ConfigSizeModal/BackButton
@onready var size_next_btn: Button = $ConfigSizeModal/NextButton
@onready var elements_input: LineEdit = get_node_or_null("ConfigSizeModal/ElementsInput")
@onready var random_elements_btn: Button = get_node_or_null("ConfigSizeModal/RandomButton")

@onready var Queue_full: Panel = get_node_or_null("Queue_full")
@onready var anim_sprite: AnimatedSprite2D = get_node_or_null("Queue_full/AnimatedSprite2D")

@onready var config_elements_modal: Panel = $ConfigElementsModal
@onready var elements_container: VBoxContainer = $ConfigElementsModal/ScrollContainer/VBoxContainer
@onready var elements_back_btn: Button = $ConfigElementsModal/BackButton
@onready var elements_done_btn: Button = $ConfigElementsModal/DoneButton

# Visual Assets
# 'front' maps to Low, 'rear' maps to High
@onready var low_icon: Node = $TextureRect/front
@onready var high_icon: Node = $TextureRect/rear
@onready var probe_arrow: Sprite2D = get_node_or_null("TextureRect/PivotArrow")

@onready var audio_player = $bgm
@onready var btn_sound = $btn_sound

@onready var intro_popup: Panel = $TutorialOverlay/Intro_popup
@onready var intro_label: Label = $TutorialOverlay/Intro_popup/Label
@onready var intro_next_btn: Button = $TutorialOverlay/Intro_popup/next
@onready var intro_skip_btn: Button = $TutorialOverlay/Intro_popup/skip
@onready var intro_prev_btn: Button = $TutorialOverlay/Intro_popup/prev

#simulate new confirmation
@onready var sim_new_confirmation: Panel = $SimNewConfirmation
@onready var sim_yes: Button = $SimNewConfirmation/YesBtn
@onready var sim_no: Button = $SimNewConfirmation/NoBtn

# --- LANGUAGE BUTTONS ---
@onready var cpp_lang_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/Cpp_btn")
@onready var python_lang_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/Py_btn")
@onready var java_lang_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/Java_btn")
@onready var c_lang_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer/C_btn")

# --- 2. CONFIGURATION ---
const BLOCK_SCENE := preload("res://InterpolationBlock.tscn")

var MAX_SIZE: int = 6
var START_POSITION: Vector2 = Vector2(80, 80)
var BLOCK_SPACING: float = 30.0

# --- 3. STATE VARIABLES ---
var array_data: Array[int] = []
var log_history: Array[String] = []
var comparison_count: int = 0

# Interpolation Search Variables
var low: int = 0
var high: int = 0
var pos: int = 0
var target_value: int = -1
var is_searching: bool = false
var current_action_text: String = ""

# Tutorial
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

var intro_step: int = 0
var element_inputs: Array[LineEdit] = []

var intro_texts = [
	"Welcome to the Interpolation Search Simulation!\nInterpolation Search is an algorithm for sorted data. Instead of always checking the middle like Binary Search, it estimates the target's position based on its value.",
	"The Algorithm:\n\n1. Ensure the data is sorted.\n2. Calculate a 'Probe' position using the target's value relative to the Low and High bounds.\n3. If it matches, STOP (Found).\n4. Adjust bounds based on value.",
	"Complexity Analysis:\n\nTime: [color=yellow]O(log(log n))[/color] average case, [color=red]O(n)[/color] worst case (if data is highly clustered).\nSpace: [color=green]O(1)[/color] - Uses constant extra memory.",
	"Visual Elements:\n\n• The 'LOW' and 'HIGH' pointers show the current active search range.\n• The 'PROBE' arrow points to the calculated guess position.",
	"How to Use:\n\n1. Configure the array size and elements.\n2. Click 'SEARCH STEP' to set a target and execute the search step-by-step.\n3. Check 'TIMELINE' to review history."
]

var current_code_language: String = "cpp"
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = [] 

var cpp_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Imports & Setup: Standard headers for input/output." },
	{ "lines": [3], "text": "2. Complexity: [color=yellow]O(log(log n))[/color] Average Time and [color=green]O(1)[/color] Space." },
	{ "lines": [5], "text": "3. Initialization: Start with 'low' at 0 and 'high' at the last index." },
	{ "lines": [6], "text": "4. Loop Condition: Continue while target 'x' is within the bounds." },
	{ "lines": [7, 8, 9, 10], "text": "5. Edge Case: If low equals high, check value to prevent division by zero." },
	{ "lines": [11], "text": "6. The Probe Formula: Estimates position based on value." },
	{ "lines": [12, 13, 14], "text": "7. Evaluate: Return if found. Else, shrink range (low/high)." }
]

var python_tutorial_data = [
	{ "lines": [0], "text": "1. Complexity: [color=yellow]O(log(log n))[/color] Avg Time, [color=green]O(1)[/color] Space." },
	{ "lines": [1, 2], "text": "2. Setup: Define function and initialize low/high bounds." },
	{ "lines": [3], "text": "3. Condition: Loop while target 'x' is logically within bounds." },
	{ "lines": [4, 5, 6], "text": "4. Zero-Division Guard: If bounds are equal, check value and return." },
	{ "lines": [7], "text": "5. Probe Formula: Calculate the estimated index 'pos'." },
	{ "lines": [8, 9, 10], "text": "6. Adjust: Return if found, or update bounds." }
]

var java_tutorial_data = [
	{ "lines": [0], "text": "1. Complexity: [color=yellow]O(log(log n))[/color] Avg Time, [color=green]O(1)[/color] Space." },
	{ "lines": [1, 2, 3], "text": "2. Initialization: Method setup and defining low/high." },
	{ "lines": [4], "text": "3. Loop: Check if target 'x' is within current bounds." },
	{ "lines": [5, 6, 7, 8], "text": "4. Edge Case Guard: Prevent divide by zero error." },
	{ "lines": [9], "text": "5. Probe Formula: Standard interpolation math formula." },
	{ "lines": [10, 11, 12], "text": "6. Result: Check match or narrow search range." }
]

var c_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Setup & Complexity: Includes and [color=yellow]O(log(log n))[/color] Avg Time." },
	{ "lines": [2, 3], "text": "2. Setup: Standard array bounds initialization." },
	{ "lines": [4, 5, 6, 7, 8], "text": "3. Condition & Edge Case: Ensure valid range and guard against zero division." },
	{ "lines": [9], "text": "4. Formula: Compute estimated position." },
	{ "lines": [10, 11, 12], "text": "5. Adjust: Shrink range or return match." }
]

# --- 4. INITIALIZATION ---
func _ready() -> void:
	print("--- Interpolation Search Visualizer Started ---")
	randomize()
	
	if dequeue_btn: dequeue_btn.text = "SEARCH STEP"
	
	var old_history_btn = get_node_or_null("VBoxContainer/DequeuedElements")
	if old_history_btn: old_history_btn.hide()
	
	if tutorial_text:
		tutorial_text.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	
	_hide_pointers()
	_connect_signals()
	_ready_tutorial_connection()
	
	config_modal.hide()
	if config_size_modal: config_size_modal.hide()
	if config_elements_modal: config_elements_modal.hide()
	
	_show_config_modal()
	call_deferred("show_introduction")

func _connect_signals() -> void:
	if not dequeue_btn.is_connected("pressed", _on_search_step_pressed): dequeue_btn.pressed.connect(_on_search_step_pressed)
	if not timeline_btn.is_connected("pressed", _on_timeline_pressed): timeline_btn.pressed.connect(_on_timeline_pressed)
	if not simulate_new_btn.is_connected("pressed", _on_reset_pressed): simulate_new_btn.pressed.connect(_on_reset_pressed)
	
	if yes_btn: yes_btn.pressed.connect(_on_config_yes)
	if no_btn: no_btn.pressed.connect(_on_config_no)
	if random_elements_btn: random_elements_btn.pressed.connect(_gen_random_config)
	if size_next_btn: size_next_btn.pressed.connect(_on_size_next_pressed)
	if size_back_btn: size_back_btn.pressed.connect(_on_config_cancel)
	
	if elements_done_btn: elements_done_btn.pressed.connect(_on_elements_done_pressed)
	if elements_back_btn: elements_back_btn.pressed.connect(_on_elements_back_pressed)
	
	if size_input:
		if not size_input.is_connected("value_changed", _on_size_spinbox_changed):
			size_input.value_changed.connect(_on_size_spinbox_changed)
	
	if search_modal:
		if not search_modal.is_connected("confirmed", _on_target_confirmed):
			search_modal.confirmed.connect(_on_target_confirmed)
	
	if complete_ok_btn: complete_ok_btn.pressed.connect(func(): complete_popup.hide())
	if show_cpp_btn: show_cpp_btn.pressed.connect(_show_cpp_popup)
	if cpp_code_button: cpp_code_button.pressed.connect(_show_cpp_popup)
	
	if cpp_close_btn: cpp_close_btn.pressed.connect(func(): cpp_popup.hide())
	
	if cpp_next_btn:
		if not cpp_next_btn.is_connected("pressed", _on_cpp_next_button_pressed):
			cpp_next_btn.pressed.connect(_on_cpp_next_button_pressed)

	if cpp_lang_btn: cpp_lang_btn.pressed.connect(func(): _set_language("cpp"))
	if python_lang_btn: python_lang_btn.pressed.connect(func(): _set_language("python"))
	if java_lang_btn: java_lang_btn.pressed.connect(func(): _set_language("java"))
	if c_lang_btn: c_lang_btn.pressed.connect(func(): _set_language("c"))

func _set_language(lang: String):
	if btn_sound: btn_sound.play()
	current_code_language = lang
	_show_cpp_popup()

# --- 5. CONFIGURATION ---
func _show_config_modal(): config_modal.show()
func _on_config_yes(): config_modal.hide(); _show_detailed_config()

func _on_config_no():
	MAX_SIZE = randi_range(5, 7)
	var rnd: Array[int] = []
	for i in range(MAX_SIZE):
		rnd.append(randi_range(1, 99))
	config_modal.hide()
	_init_simulation(rnd)

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
	if intro_prev_btn:
		intro_prev_btn.visible = (intro_step > 0)
	if intro_next_btn:
		intro_next_btn.text = "Finish" if intro_step >= intro_texts.size() - 1 else "Next"

func _on_intro_next_pressed():
	if btn_sound: btn_sound.play()
	if intro_step < intro_texts.size() - 1:
		intro_step += 1
		_update_intro_text()
	else:
		intro_popup.hide()

func _on_intro_prev_pressed():
	if btn_sound: btn_sound.play()
	if intro_step > 0:
		intro_step -= 1
		_update_intro_text()

func _on_intro_skip_pressed():
	if btn_sound: btn_sound.play()
	intro_popup.hide()

func _on_size_next_pressed() -> void:
	if btn_sound: btn_sound.play()
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
	if btn_sound: btn_sound.play()
	MAX_SIZE = int(size_input.value)
	var arr: Array[int] = []
	
	for line_edit in element_inputs:
		var txt = line_edit.text.strip_edges()
		if txt.is_valid_int():
			arr.append(int(txt))
		else:
			arr.append(randi_range(1, 99))
			
	config_elements_modal.hide()
	_init_simulation(arr)

func _on_elements_back_pressed() -> void:
	if btn_sound: btn_sound.play()
	config_elements_modal.hide()
	config_size_modal.show()

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

func _show_detailed_config():
	size_input.min_value = 5
	size_input.max_value = 7
	size_input.value = 5
	_gen_random_config()
	config_size_modal.show()

func _on_size_spinbox_changed(new_val: float) -> void:
	_gen_random_config()

func _gen_random_config():
	var sz = int(size_input.value)
	var arr = []
	for i in range(sz): arr.append(str(randi_range(1,99)))
	if elements_input: elements_input.text = ", ".join(arr)

func _on_config_confirm():
	MAX_SIZE = int(size_input.value)
	var arr: Array[int] = []
	
	if elements_input:
		var txt = elements_input.text.split(",")
		for t in txt:
			if t.strip_edges().is_valid_int():
				arr.append(int(t.strip_edges()))
				
	while arr.size() > 7: arr.pop_back()
	while arr.size() < 5: arr.append(randi_range(1, 99))
	
	config_size_modal.hide()
	_init_simulation(arr)

func _on_config_cancel():
	config_size_modal.hide()
	config_modal.show()

func _init_simulation(data: Array[int]):
	if audio_player: audio_player.play()
	
	# Sort data immediately and push to array_data
	data.sort()
	array_data = data.duplicate()
	log_history.append("Array generated and sorted.")
	
	_spawn_all_blocks()
	
	_update_ui()
	if cpp_code_button: cpp_code_button.hide()

func _spawn_all_blocks():
	for i in range(array_data.size()):
		var val = array_data[i]
		
		var blk = BLOCK_SCENE.instantiate()
		blk.set("value", val)
		
		var block_width = 64.0
		var target_x = START_POSITION.x + i * (block_width + BLOCK_SPACING)
		var target_pos = Vector2(target_x, START_POSITION.y)

		var base_col = Color(1, 0.6, 0.2)
		if blk.has_method("set_base_color"): blk.set_base_color(base_col)
		else: blk.modulate = base_col
		
		queue_container.add_child(blk)
		
		# Animate them appearing all at once with a slight drop effect
		blk.position = target_pos + Vector2(0, -30)
		blk.modulate.a = 0
		
		var tw = create_tween().set_parallel(true)
		tw.tween_property(blk, "position", target_pos, 0.4).set_trans(Tween.TRANS_CUBIC).set_delay(i * 0.05)
		tw.tween_property(blk, "modulate:a", 1.0, 0.3).set_delay(i * 0.05)

# --- 6. INTERPOLATION SEARCH LOGIC ---

func _on_search_step_pressed():
	if array_data.size() < 1: return
	
	if not is_searching:
		if search_modal:
			search_modal.popup_centered()
		else:
			target_value = array_data.pick_random()
			_start_search_process()
		return
	
	if btn_sound: btn_sound.play()
	_execute_search_step()

func _on_target_confirmed():
	if btn_sound: btn_sound.play()
	if target_spinbox:
		target_value = int(target_spinbox.value)
	else:
		target_value = 0
	_start_search_process()

func _start_search_process():
	is_searching = true
	comparison_count = 0
	
	low = 0
	high = array_data.size() - 1
	
	log_history.append("--- Interpolation Search Started ---")
	log_history.append("Sorted array. Looking for: %d" % target_value)
	current_action_text = "Range: [%d, %d]" % [low, high]
	
	if low_icon: low_icon.show()
	if high_icon: high_icon.show()
	if probe_arrow: probe_arrow.hide()
	
	_update_pointers()
	_update_ui()

func _execute_search_step():
	if low <= high and target_value >= array_data[low] and target_value <= array_data[high]:
		
		var numerator = float(target_value - array_data[low]) * float(high - low)
		var denominator = float(array_data[high] - array_data[low])
		
		if denominator == 0:
			pos = low
		else:
			pos = low + int(numerator / denominator)
		
		comparison_count += 1
		var pos_val = array_data[pos]
		
		if probe_arrow: probe_arrow.show()
		_update_pointers()
		
		current_action_text = "Probing index %d (Val: %d)" % [pos, pos_val]
		
		var blk = queue_container.get_child(pos)
		var tw = create_tween()
		tw.tween_property(blk, "scale", Vector2(1.2, 1.2), 0.1)
		tw.tween_property(blk, "scale", Vector2(1.0, 1.0), 0.1)
		
		if pos_val == target_value:
			blk.modulate = Color(0.2, 1, 0.2)
			log_history.append("Found %d at index %d!" % [pos_val, pos])
			_update_ui()
			_finish_simulation(true)
			return
			
		elif pos_val < target_value:
			current_action_text += " -> Too small. Go Right."
			log_history.append(current_action_text)
			_dim_range(low, pos)
			low = pos + 1
			
		else:
			current_action_text += " -> Too big. Go Left."
			log_history.append(current_action_text)
			_dim_range(pos, high)
			high = pos - 1
			
		_update_ui()
		
	else:
		current_action_text = "Target not in range. Not Found!"
		_finish_simulation(false)

func _dim_range(from_idx: int, to_idx: int):
	for i in range(from_idx, to_idx + 1):
		if i >= 0 and i < queue_container.get_child_count():
			var blk = queue_container.get_child(i)
			create_tween().tween_property(blk, "modulate", Color(0.2, 0.2, 0.2, 0.5), 0.3)

func _finish_simulation(found: bool):
	var msg = ""
	if found:
		msg = "Target %d Found!\nComparisons: %d" % [target_value, comparison_count]
	else:
		msg = "Target %d Not Found.\nComparisons: %d" % [target_value, comparison_count]
	process_label.text = msg
	complete_popup.popup_centered()
	if cpp_code_button: cpp_code_button.show()

# --- POINTER UPDATES ---
func _update_pointers():
	if not is_searching: return
	
	if low >= 0 and low < queue_container.get_child_count():
		var block = queue_container.get_child(low)
		var target_pos = block.global_position
		target_pos.x += block.size.x / 2.0
		target_pos.y -= 50
		create_tween().tween_property(low_icon, "global_position", target_pos, 0.2).set_trans(Tween.TRANS_CUBIC)
	
	if high >= 0 and high < queue_container.get_child_count():
		var block = queue_container.get_child(high)
		var target_pos = block.global_position
		target_pos.x += block.size.x / 2.0
		target_pos.y -= 50
		create_tween().tween_property(high_icon, "global_position", target_pos, 0.2).set_trans(Tween.TRANS_CUBIC)
		
	if probe_arrow and pos >= 0 and pos < queue_container.get_child_count():
		var block = queue_container.get_child(pos)
		var target_pos = block.global_position
		target_pos.x += block.size.x / 2.0
		target_pos.y -= 75
		create_tween().tween_property(probe_arrow, "global_position", target_pos, 0.2).set_trans(Tween.TRANS_CUBIC)

func _hide_pointers():
	if low_icon: low_icon.hide()
	if high_icon: high_icon.hide()
	if probe_arrow: probe_arrow.hide()

# --- RESET FUNCTION ---
func _on_reset_pressed():
	if btn_sound: btn_sound.play()
	sim_new_confirmation.show()

# --- HELPER FUNCTIONS ---
func _on_timeline_pressed():
	timeline_label.text = "Log:\n" + "\n".join(log_history)
	timeline_popup.popup_centered()

# --- CODE GENERATION & TUTORIAL (MULTI-LANGUAGE) ---

func _show_cpp_popup() -> void:
	if complete_popup: complete_popup.hide()
	var arr_str = ", ".join(array_data.map(func(x): return str(x)))
	
	match current_code_language:
		"cpp": current_tutorial_data = cpp_tutorial_data
		"python": current_tutorial_data = python_tutorial_data
		"java": current_tutorial_data = java_tutorial_data
		"c": current_tutorial_data = c_tutorial_data
		
	var code = generate_code_in_language(current_code_language, arr_str)
	
	if cpp_label:
		cpp_label.bbcode_enabled = true
		cpp_label.text = code
	
	cpp_popup.popup_centered()
	cpp_tutorial_step = 0
	
	if cpp_tutorial_panel: cpp_tutorial_panel.show()
	_update_cpp_tutorial()

func _on_cpp_next_button_pressed() -> void:
	if btn_sound: btn_sound.play()
	cpp_tutorial_step += 1
	if cpp_tutorial_step >= current_tutorial_data.size():
		cpp_tutorial_step = 0
	_update_cpp_tutorial()

func _update_cpp_tutorial() -> void:
	if current_tutorial_data.is_empty(): return
	var data = current_tutorial_data[cpp_tutorial_step]
	
	if cpp_explanation_lbl:
		cpp_explanation_lbl.bbcode_enabled = true
		cpp_explanation_lbl.text = data["text"]
	
	if cpp_label:
		# Use array_data (or main_array, depending on your specific script)
		var arr_str = ", ".join(array_data.map(func(x): return str(x)))
		
		# This automatically calls the right function for Interpolation/DFS/BFS
		var code = generate_code_in_language(current_code_language, arr_str)
		
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
		
		# Call the scroll animation safely
		if indices.size() > 0:
			call_deferred("_scroll_to_highlight", indices[0])

# --- ADD THIS HELPER FUNCTION RIGHT BELOW IT ---
func _scroll_to_highlight(line_index: int) -> void:
	var target_scroll = line_index * 26 # Adjust 26 based on your font size height
	
	if cpp_scroll:
		var tween = create_tween()
		tween.tween_property(cpp_scroll, "scroll_vertical", target_scroll, 0.2).set_trans(Tween.TRANS_SINE)
	elif cpp_label:
		var scrollbar = cpp_label.get_v_scroll_bar()
		if scrollbar:
			var tween = create_tween()
			tween.tween_property(scrollbar, "value", target_scroll, 0.2).set_trans(Tween.TRANS_SINE)

# --- INTERPOLATION SEARCH CODE STRINGS ---

func generate_code_in_language(lang: String, arr_str: String) -> String:
	match lang:
		"python": return get_python_interp_code(arr_str)
		"java": return get_java_interp_code(arr_str)
		"c": return get_c_interp_code(arr_str)
		_: return get_cpp_interp_code(arr_str)

func get_cpp_interp_code(arr: String) -> String:
	return """#include <iostream>
using namespace std;

/* Time: O(log(log n)) avg, O(n) worst | Space: O(1) */
int interpolationSearch(int arr[], int n, int x) {
	int low = 0, high = n - 1;
	while (low <= high && x >= arr[low] && x <= arr[high]) {
		if (low == high) {
			if (arr[low] == x) return low;
			return -1;
		}
		int pos = low + (((double)(high - low) / (arr[high] - arr[low])) * (x - arr[low]));
		if (arr[pos] == x) return pos;
		if (arr[pos] < x) low = pos + 1;
		else high = pos - 1;
	}
	return -1;
}

int main() {
	int arr[] = { %s };
	int n = sizeof(arr) / sizeof(arr[0]);
	int res = interpolationSearch(arr, n, %d);
	
	if (res != -1) cout << "Found at index " << res << endl;
	else cout << "Not found" << endl;
	return 0;
}""" % [arr, target_value]

func get_python_interp_code(arr: String) -> String:
	return """# Time: O(log(log n)) avg, O(n) worst | Space: O(1)
def interpolation_search(arr, x):
	low, high = 0, len(arr) - 1
	while low <= high and x >= arr[low] and x <= arr[high]:
		if low == high:
			if arr[low] == x: return low
			return -1
		pos = low + int(((float(high - low) / (arr[high] - arr[low])) * (x - arr[low])))
		if arr[pos] == x: return pos
		if arr[pos] < x: low = pos + 1
		else: high = pos - 1
	return -1

arr = [%s]
res = interpolation_search(arr, %d)

if res != -1:
	print(f"Found at index {res}")
else:
	print("Not found")""" % [arr, target_value]

func get_java_interp_code(arr: String) -> String:
	return """/* Time: O(log(log n)) avg, O(n) worst | Space: O(1) */
class InterpolationSearch {
	public static int search(int[] arr, int x) {
		int low = 0, high = arr.length - 1;
		while (low <= high && x >= arr[low] && x <= arr[high]) {
			if (low == high) {
				if (arr[low] == x) return low;
				return -1;
			}
			int pos = low + (((high - low) / (arr[high] - arr[low])) * (x - arr[low]));
			if (arr[pos] == x) return pos;
			if (arr[pos] < x) low = pos + 1;
			else high = pos - 1;
		}
		return -1;
	}
	
	public static void main(String[] args) {
		int[] arr = {%s};
		int res = search(arr, %d);
		
		if (res != -1) System.out.println("Found at index " + res);
		else System.out.println("Not found");
	}
}""" % [arr, target_value]

func get_c_interp_code(arr: String) -> String:
	return """#include <stdio.h>
/* Time: O(log(log n)) avg, O(n) worst | Space: O(1) */
int interpolationSearch(int arr[], int n, int x) {
	int low = 0, high = n - 1;
	while (low <= high && x >= arr[low] && x <= arr[high]) {
		if (low == high) {
			if (arr[low] == x) return low;
			return -1;
		}
		int pos = low + (((double)(high - low) / (arr[high] - arr[low])) * (x - arr[low]));
		if (arr[pos] == x) return pos;
		if (arr[pos] < x) low = pos + 1;
		else high = pos - 1;
	}
	return -1;
}

int main() {
	int arr[] = {%s};
	int n = sizeof(arr) / sizeof(arr[0]);
	int res = interpolationSearch(arr, n, %d);
	
	if (res != -1) printf("Found at index %d\\n", res);
	else printf("Not found\\n");
	return 0;
}""" % [arr, target_value]

# --- UI UPDATES ---
func _update_ui():
	if enqueue_label: enqueue_label.text = "Target: %d" % target_value if is_searching else "Ready to Search"
	if dequeue_label: dequeue_label.text = "Comparisons: %d | %s" % [comparison_count, current_action_text]
	if dequeue_btn: dequeue_btn.disabled = array_data.is_empty()

# --- TUTORIAL BOILERPLATE ---

func _ready_tutorial_connection():
	if help_btn and not help_btn.is_connected("pressed", _on_help_button_pressed):
		help_btn.pressed.connect(_on_help_button_pressed)
	if tutorial_next and not tutorial_next.is_connected("pressed", _on_tutorial_next_pressed):
		tutorial_next.pressed.connect(_on_tutorial_next_pressed)

func _on_help_button_pressed() -> void:
	if btn_sound: btn_sound.play()
	start_main_tutorial()

func start_main_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	if tutorial_overlay: tutorial_overlay.show()
	if dim_bg: dim_bg.show()
	if tutorial_box: tutorial_box.show()
	
	tutorial_sequence = [
		{ "node": null, "text": "INTERPOLATION SEARCH:\nAn improvement on Binary Search for uniformly distributed data. It estimates the position of the target value.", "action": "next" },
		{ "node": dequeue_btn, "text": "SEARCH STEP: Set a target and calculate probe position.", "action": "next" },
		{ "node": timeline_btn, "text": "TIMELINE: Review history.", "action": "next" },
		{ "node": simulate_new_btn, "text": "SIMULATE NEW: Reset and restart.", "action": "end" }
	]
	show_tutorial_step()

func show_tutorial_step() -> void:
	if tutorial_sequence_index >= tutorial_sequence.size():
		end_main_tutorial()
		return
	var step = tutorial_sequence[tutorial_sequence_index]
	var node = step["node"]
	if tutorial_text: tutorial_text.text = step["text"]
	
	if node:
		if pointer_sprite:
			pointer_sprite.show()
			var ptr_pos = node.get_global_rect().position
			ptr_pos.x += 200
			ptr_pos.y += node.size.y / 2
			pointer_sprite.global_position = ptr_pos
		_highlight_node(node)
	else:
		if pointer_sprite: pointer_sprite.hide()
		_clear_highlights()
	
	if tutorial_next:
		if step["action"] == "next":
			tutorial_next.show(); tutorial_next.text = "Next"
		elif step["action"] == "end":
			tutorial_next.show(); tutorial_next.text = "Finish"

func _highlight_node(node: Control):
	_clear_highlights()
	if node:
		var tw = create_tween().set_loops()
		tw.tween_property(node, "modulate", Color(1.5, 1.5, 1.5), 0.5)
		tw.tween_property(node, "modulate", Color(1, 1, 1), 0.5)
		node.set_meta("tutorial_tween", tw)

func _clear_highlights():
	var buttons = [dequeue_btn, timeline_btn, simulate_new_btn]
	for b in buttons:
		if b and b.has_meta("tutorial_tween"):
			var tw = b.get_meta("tutorial_tween") as Tween
			if tw: tw.kill()
		if b: b.modulate = Color(1, 1, 1)

func _on_tutorial_next_pressed() -> void:
	if btn_sound: btn_sound.play()
	tutorial_sequence_index += 1
	show_tutorial_step()

func end_main_tutorial() -> void:
	tutorial_in_progress = false
	if tutorial_overlay: tutorial_overlay.hide()
	_clear_highlights()

func _on_yes_btn_pressed() -> void:
	btn_sound.play()
	for c in queue_container.get_children(): c.queue_free()
	array_data.clear(); log_history.clear()
	comparison_count = 0; is_searching = false
	low = 0; high = 0; pos = 0
	target_value = -1
	current_action_text = ""
	_hide_pointers()
	_on_config_no()
	sim_new_confirmation.hide()

func _on_no_btn_pressed() -> void:
	btn_sound.play()
	sim_new_confirmation.hide()



func _on_close_pressed() -> void:
	cpp_popup.hide()
