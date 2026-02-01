extends Control

# --- 1. NODE REFERENCES ---
@onready var enqueue_btn: Button = $VBoxContainer/Addelement
@onready var dequeue_btn: Button = $VBoxContainer/Searchstep
@onready var waiting_btn: Button = $VBoxContainer/WaitingElements
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
# FIX: Path includes ScrollContainer
@onready var waiting_label: Label = $WaitingPopup/ScrollContainer/VBoxContainer/Label

@onready var timeline_popup: Popup = $TimelinePopup
# FIX: Path includes ScrollContainer
@onready var timeline_label: Label = $TimelinePopup/ScrollContainer/VBoxContainer/Label

@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var process_label: Label = $SimulationCompletePopup/VBoxContainer/ProcessLabel

# C++ Popup
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_text: TextEdit = get_node_or_null("CppPopup/VBoxContainer/TextEdit") as TextEdit

# FIX: Use "close" (lowercase) to match scene
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/close") as Button
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")

# C++ Tutorial Nodes
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_text: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")
@onready var cpp_next_button: Button = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/CppNextButton") 

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
@onready var size_input: SpinBox = $ConfigChoiceModal/SpinBox
@onready var yes_btn: Button = $ConfigChoiceModal/yesButton
@onready var no_btn: Button = $ConfigChoiceModal/NoButton
@onready var config_size_elements_modal: Panel = $ConfigSizeElementsModal
@onready var size_input_detailed: SpinBox = $ConfigSizeElementsModal/SizeSpinBox
@onready var elements_input: TextEdit = $ConfigSizeElementsModal/ElementsTextEdit
@onready var random_elements_btn: Button = $ConfigSizeElementsModal/RandomElementsButton
@onready var confirm_btn: Button = $ConfigSizeElementsModal/ConfirmButton
@onready var cancel_btn: Button = $ConfigSizeElementsModal/CancelButton

# Visual Assets
# 'front' maps to Low, 'rear' maps to High
@onready var low_icon: Node = $TextureRect/front 
@onready var high_icon: Node = $TextureRect/rear    
@onready var probe_arrow: Sprite2D = get_node_or_null("TextureRect/PivotArrow") 

@onready var audio_player = $bgm
@onready var btn_sound = $btn_sound

# --- 2. CONFIGURATION ---
const BLOCK_SCENE := preload("res://InterpolationBlock.tscn")

var MAX_SIZE: int = 6
# We don't rely on START_POSITION anymore for pointers, but used for spawn
var START_POSITION: Vector2 = Vector2(80, 80) 
var BLOCK_SPACING: float = 30.0

# --- 3. STATE VARIABLES ---
var array_data: Array[int] = []          
var waiting_data: Array[int] = []        
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
var cpp_tutorial_index := 0
var cpp_tutorial_steps := []

# --- 4. INITIALIZATION ---
func _ready() -> void:
	print("--- Interpolation Search Visualizer Started ---")
	randomize()
	
	if enqueue_btn: enqueue_btn.text = "ADD ELEMENT"
	if dequeue_btn: dequeue_btn.text = "SEARCH STEP"
	if waiting_btn: waiting_btn.text = "WAITING"
	
	var old_history_btn = get_node_or_null("VBoxContainer/DequeuedElements")
	if old_history_btn: old_history_btn.hide()
	
	if tutorial_text:
		tutorial_text.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	
	_hide_pointers()
	_connect_signals()
	_ready_tutorial_connection()
	
	config_modal.hide()
	if config_size_elements_modal: config_size_elements_modal.hide()
	_show_config_modal()

func _connect_signals() -> void:
	if not enqueue_btn.is_connected("pressed", _on_add_element_pressed): enqueue_btn.pressed.connect(_on_add_element_pressed)
	if not dequeue_btn.is_connected("pressed", _on_search_step_pressed): dequeue_btn.pressed.connect(_on_search_step_pressed)
	
	if not waiting_btn.is_connected("pressed", _on_waiting_pressed): waiting_btn.pressed.connect(_on_waiting_pressed)
	if not timeline_btn.is_connected("pressed", _on_timeline_pressed): timeline_btn.pressed.connect(_on_timeline_pressed)
	if not simulate_new_btn.is_connected("pressed", _on_reset_pressed): simulate_new_btn.pressed.connect(_on_reset_pressed)
	
	if yes_btn: yes_btn.pressed.connect(_on_config_yes)
	if no_btn: no_btn.pressed.connect(_on_config_no)
	if random_elements_btn: random_elements_btn.pressed.connect(_gen_random_config)
	if confirm_btn: confirm_btn.pressed.connect(_on_config_confirm)
	if cancel_btn: cancel_btn.pressed.connect(_on_config_cancel)
	
	if size_input_detailed:
		if not size_input_detailed.is_connected("value_changed", _on_size_spinbox_changed):
			size_input_detailed.value_changed.connect(_on_size_spinbox_changed)
	
	if search_modal:
		if not search_modal.is_connected("confirmed", _on_target_confirmed):
			search_modal.confirmed.connect(_on_target_confirmed)
	
	if complete_ok_btn: complete_ok_btn.pressed.connect(func(): complete_popup.hide())
	if show_cpp_btn: show_cpp_btn.pressed.connect(_show_cpp_code)
	if cpp_code_button: cpp_code_button.pressed.connect(_show_cpp_code)
	
	# FIX: Correctly connect Close button
	if cpp_close_btn: 
		cpp_close_btn.pressed.connect(func(): cpp_popup.hide())
	
	if cpp_next_button:
		if not cpp_next_button.is_connected("pressed", _on_cpp_next_button_pressed):
			cpp_next_button.pressed.connect(_on_cpp_next_button_pressed)

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

func _show_detailed_config():
	size_input_detailed.min_value = 5
	size_input_detailed.max_value = 7
	size_input_detailed.value = 5
	_gen_random_config()
	config_size_elements_modal.show()

func _on_size_spinbox_changed(new_val: float) -> void:
	_gen_random_config()

func _gen_random_config():
	var sz = int(size_input_detailed.value)
	var arr = []
	for i in range(sz): arr.append(str(randi_range(1,99)))
	elements_input.text = ", ".join(arr)

func _on_config_confirm():
	MAX_SIZE = int(size_input_detailed.value)
	var txt = elements_input.text.split(",")
	var arr: Array[int] = []
	for t in txt: 
		if t.strip_edges().is_valid_int(): 
			arr.append(int(t.strip_edges()))
	while arr.size() > 7: arr.pop_back()
	while arr.size() < 5: arr.append(randi_range(1, 99))
	config_size_elements_modal.hide()
	_init_simulation(arr)

func _on_config_cancel(): config_size_elements_modal.hide(); config_modal.show()

func _init_simulation(data: Array[int]):
	if audio_player: audio_player.play()
	waiting_data = data
	_update_ui()
	if cpp_code_button: cpp_code_button.hide()

# --- 6. INTERPOLATION SEARCH LOGIC ---

func _on_add_element_pressed():
	if is_searching: return 
	if array_data.size() >= MAX_SIZE or waiting_data.is_empty(): return
	
	btn_sound.play()
	var val = waiting_data.pop_front()
	array_data.append(val)
	log_history.append("Added %d" % val)
	
	var blk = BLOCK_SCENE.instantiate()
	blk.set("value", val)
	
	# Initial position logic (still uses Start pos, but only for spawning)
	var idx = array_data.size() - 1
	var block_width = 64.0 
	var target_x = START_POSITION.x + idx * (block_width + BLOCK_SPACING)
	var target_pos = Vector2(target_x, START_POSITION.y)

	var base_col = Color(1, 0.6, 0.2)
	if blk.has_method("set_base_color"): blk.set_base_color(base_col)
	else: blk.modulate = base_col
	
	queue_container.add_child(blk)
	blk.position = target_pos + Vector2(200, 0)
	blk.modulate.a = 0
	
	var tw = create_tween().set_parallel(true)
	tw.tween_property(blk, "position", target_pos, 0.5).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(blk, "modulate:a", 1.0, 0.4)
	
	_update_ui()

func _on_search_step_pressed():
	if array_data.size() < 1: return
	
	if not is_searching:
		if search_modal:
			search_modal.popup_centered()
		else:
			target_value = array_data.pick_random()
			_start_search_process()
		return
	
	btn_sound.play()
	_execute_search_step()

func _on_target_confirmed():
	btn_sound.play()
	if target_spinbox:
		target_value = int(target_spinbox.value)
	else:
		target_value = 0
	_start_search_process()

func _start_search_process():
	is_searching = true
	comparison_count = 0
	enqueue_btn.disabled = true
	
	_force_sort_array()
	
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
	# Condition: low <= high AND target is within the range [arr[low], arr[high]]
	if low <= high and target_value >= array_data[low] and target_value <= array_data[high]:
		
		# 1. CALCULATE PROBE POSITION
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
			blk.modulate = Color(0.2, 1, 0.2) # Green
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

func _force_sort_array():
	array_data.sort()
	# Just update values, don't move nodes to keep it simple
	for i in range(queue_container.get_child_count()):
		var blk = queue_container.get_child(i)
		blk.value = array_data[i]
		blk.modulate = Color(1, 0.6, 0.2)
		blk.modulate.a = 1.0

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

# --- POINTER UPDATES USING GLOBAL POSITION ---
func _update_pointers():
	if not is_searching: return
	
	# Update LOW Icon
	if low >= 0 and low < queue_container.get_child_count():
		var block = queue_container.get_child(low)
		var target_pos = block.global_position
		target_pos.x += block.size.x / 2.0 # Center horizontally
		target_pos.y -= 50 # 50px above the block
		
		create_tween().tween_property(low_icon, "global_position", target_pos, 0.2).set_trans(Tween.TRANS_CUBIC)
	
	# Update HIGH Icon
	if high >= 0 and high < queue_container.get_child_count():
		var block = queue_container.get_child(high)
		var target_pos = block.global_position
		target_pos.x += block.size.x / 2.0
		target_pos.y -= 50
		
		create_tween().tween_property(high_icon, "global_position", target_pos, 0.2).set_trans(Tween.TRANS_CUBIC)
		
	# Update PROBE/PIVOT Arrow
	if probe_arrow and pos >= 0 and pos < queue_container.get_child_count():
		var block = queue_container.get_child(pos)
		var target_pos = block.global_position
		target_pos.x += block.size.x / 2.0
		target_pos.y -= 75 # Higher than text
		
		create_tween().tween_property(probe_arrow, "global_position", target_pos, 0.2).set_trans(Tween.TRANS_CUBIC)

func _hide_pointers():
	if low_icon: low_icon.hide()
	if high_icon: high_icon.hide()
	if probe_arrow: probe_arrow.hide()

# --- RESET FUNCTION ---
func _on_reset_pressed():
	btn_sound.play()
	for c in queue_container.get_children(): c.queue_free()
	array_data.clear(); waiting_data.clear(); log_history.clear()
	comparison_count = 0; is_searching = false
	low = 0; high = 0; pos = 0 
	target_value = -1
	current_action_text = ""
	_hide_pointers()
	_on_config_no()

# --- HELPER FUNCTIONS ---
func _on_waiting_pressed():
	waiting_label.text = "Waiting Numbers:\n" + str(waiting_data)
	waiting_popup.popup_centered()

func _on_timeline_pressed():
	timeline_label.text = "Log:\n" + "\n".join(log_history)
	timeline_popup.popup_centered()

func _on_cpp_next_button_pressed() -> void:
	btn_sound.play()
	cpp_tutorial_index += 1
	show_cpp_explanation()

# --- C++ ---
func _show_cpp_code():
	complete_popup.hide()
	var arr_str = ", ".join(array_data.map(func(x): return str(x)))
	
	var code = """#include <iostream>
using namespace std;

int interpolationSearch(int arr[], int n, int x) {
    int low = 0, high = n - 1;

    while (low <= high && x >= arr[low] && x <= arr[high]) {
        if (low == high) {
            if (arr[low] == x) return low;
            return -1;
        }
        
        // The Formula
        int pos = low + (((double)(high - low) / 
            (arr[high] - arr[low])) * (x - arr[low]));

        if (arr[pos] == x) return pos;
        if (arr[pos] < x) low = pos + 1;
        else high = pos - 1;
    }
    return -1;
}

int main() {
    int arr[] = { %s };
    int x = %d;
    int n = sizeof(arr) / sizeof(arr[0]);
    int index = interpolationSearch(arr, n, x);
    
    if (index != -1) cout << "Found at index " << index;
    else cout << "Not found";
    return 0;
}
""" % [arr_str, target_value]
	
	cpp_text.text = code
	
	cpp_tutorial_steps = [
		{ "lines": Vector2i(7, 7), "text": "1. Loop while target is within range [low, high]." },
		{ "lines": Vector2i(13, 14), "text": "2. Calculate Probable Position (pos)." },
		{ "lines": Vector2i(16, 16), "text": "3. If match found, return index." },
		{ "lines": Vector2i(17, 18), "text": "4. Adjust low or high based on comparison." }
	]
	
	cpp_popup.popup_centered()
	start_cpp_code_tutorial()

# --- UI UPDATES ---
func _update_ui():
	enqueue_label.text = "Target: %d" % target_value if is_searching else "Add Elements"
	dequeue_label.text = "Comparisons: %d | %s" % [comparison_count, current_action_text]
	enqueue_btn.disabled = (is_searching or waiting_data.is_empty())

# --- TUTORIAL BOILERPLATE ---
func start_cpp_code_tutorial() -> void:
	if not cpp_tutorial_panel: return
	cpp_tutorial_index = 0
	cpp_tutorial_panel.show()
	highlight_cpp_code()
	show_cpp_explanation()

func highlight_cpp_code() -> void:
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 0.8, 0.15)
	sb.border_color = Color(1, 1, 0.2, 1)
	sb.set_border_width_all(4) 
	cpp_text.add_theme_stylebox_override("normal", sb)

func clear_cpp_highlight() -> void:
	cpp_text.remove_theme_stylebox_override("normal")

func show_cpp_explanation() -> void:
	if cpp_tutorial_index >= cpp_tutorial_steps.size():
		end_cpp_tutorial()
		return
	var step = cpp_tutorial_steps[cpp_tutorial_index]
	if cpp_explanation_text:
		cpp_explanation_text.text = step["text"]
	highlight_cpp_lines(step["lines"].x, step["lines"].y)

func highlight_cpp_lines(start_line: int, end_line: int) -> void:
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 0.8, 0.1)
	sb.border_color = Color(1, 1, 0.2, 1)
	sb.set_border_width_all(2)
	cpp_text.add_theme_stylebox_override("normal", sb)
	cpp_text.select(start_line, 0, end_line, 0)

func end_cpp_tutorial() -> void:
	cpp_tutorial_panel.hide()
	clear_cpp_highlight()

func _ready_tutorial_connection():
	if help_btn and not help_btn.is_connected("pressed", _on_help_button_pressed):
		help_btn.pressed.connect(_on_help_button_pressed)
	if tutorial_next and not tutorial_next.is_connected("pressed", _on_tutorial_next_pressed):
		tutorial_next.pressed.connect(_on_tutorial_next_pressed)

func _on_help_button_pressed() -> void:
	btn_sound.play()
	start_main_tutorial()

func start_main_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	tutorial_overlay.show()
	dim_bg.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{ "node": null, "text": "INTERPOLATION SEARCH:\nAn improvement on Binary Search for uniformly distributed data. It estimates the position of the target value.", "action": "next" },
		{ "node": enqueue_btn, "text": "ADD ELEMENT: Fill the array (will be auto-sorted).", "action": "next" },
		{ "node": dequeue_btn, "text": "SEARCH STEP: Calculate probe position.", "action": "next" },
		{ "node": waiting_btn, "text": "WAITING: See upcoming numbers.", "action": "next" },
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
	tutorial_text.text = step["text"]
	
	if node:
		pointer_sprite.show()
		var ptr_pos = node.get_global_rect().position 
		ptr_pos.x += 200 
		ptr_pos.y += node.size.y / 2
		pointer_sprite.global_position = ptr_pos
		_highlight_node(node)
	else:
		pointer_sprite.hide()
		_clear_highlights()
	
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
	var buttons = [enqueue_btn, dequeue_btn, timeline_btn, simulate_new_btn, waiting_btn]
	for b in buttons:
		if b.has_meta("tutorial_tween"):
			var tw = b.get_meta("tutorial_tween") as Tween
			if tw: tw.kill()
		b.modulate = Color(1, 1, 1)

func _on_tutorial_next_pressed() -> void:
	btn_sound.play()
	tutorial_sequence_index += 1
	show_tutorial_step()

func end_main_tutorial() -> void:
	tutorial_in_progress = false
	tutorial_overlay.hide()
	_clear_highlights()
