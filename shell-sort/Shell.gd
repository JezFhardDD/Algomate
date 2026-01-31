extends Control

# --- 1. NODE REFERENCES ---
@onready var enqueue_btn: Button = $VBoxContainer/Addelement
@onready var dequeue_btn: Button = $VBoxContainer/Sortelement
@onready var waiting_btn: Button = $VBoxContainer/WaitingElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew

@onready var enqueue_label: Label = $HBoxContainer/Label
@onready var dequeue_label: Label = $HBoxContainer2/Label
@onready var queue_container: Control = $QueueContainer

# Popups
@onready var waiting_popup: Popup = $WaitingPopup
# FIX: Path now includes ScrollContainer
@onready var waiting_label: Label = $WaitingPopup/ScrollContainer/VBoxContainer/Label

@onready var timeline_popup: Popup = $TimelinePopup
# FIX: Path now includes ScrollContainer
@onready var timeline_label: Label = $TimelinePopup/ScrollContainer/VBoxContainer/Label

@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var process_label: Label = $SimulationCompletePopup/VBoxContainer/ProcessLabel

# C++ Popup references
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_text: TextEdit = get_node_or_null("CppPopup/VBoxContainer/TextEdit") as TextEdit

# FIX: Changed "Button" to "close" to match your Scene Tree name
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
@onready var rear_icon: Node = $TextureRect/rear
@onready var front_icon: Node = $TextureRect/front
# Reuse PivotArrow if it exists, otherwise ignore
@onready var pivot_arrow: Sprite2D = get_node_or_null("TextureRect/PivotArrow") 

@onready var audio_player = $bgm
@onready var btn_sound = $btn_sound

# --- 2. CONFIGURATION ---
const BLOCK_SCENE := preload("res://ShellBlock.tscn")

var MAX_SIZE: int = 6
var BLOCK_SPACING: float = 30.0 
var START_POSITION: Vector2 = Vector2(80, 80)

# --- 3. SORTING STATE VARIABLES ---
var array_data: Array[int] = []          
var waiting_data: Array[int] = []        
var log_history: Array[String] = []      
var comparison_count: int = 0
var swap_count: int = 0

# Shell Sort Specific Variables
var gap: int = 0
var sort_i: int = 0
var sort_j: int = 0
var is_sorting: bool = false
var current_action_text: String = ""

# Tutorial State
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false
var cpp_tutorial_index := 0
var cpp_tutorial_steps := []

# State Machine for Shell Sort
enum SortState { INIT_GAP, START_PASS, COMPARE, ACTION, NEXT_I, REDUCE_GAP }
var current_state = SortState.INIT_GAP

# --- COLOR PALETTE ---
var SAFE_COLORS: Array[Color] = [
	Color(1, 0.3, 0.3),   # Red
	Color(0.2, 0.6, 1),   # Blue
	Color(1, 0.6, 0.2),   # Orange
	Color(0.6, 0.2, 0.8), # Purple
	Color(1, 0.2, 0.6),   # Deep Pink
	Color(0.2, 0.8, 0.9), # Cyan
	Color(0.5, 0.5, 0.5)  # Grey
]

var HIGHLIGHT_COLOR: Color = Color(0.2, 1, 0.2) # Green for compare

# --- 4. INITIALIZATION ---
func _ready() -> void:
	print("--- Shell Sort Visualizer Started ---")
	randomize()
	
	if enqueue_btn: enqueue_btn.text = "ADD ELEMENT"
	if dequeue_btn: dequeue_btn.text = "SORT STEP"
	if waiting_btn: waiting_btn.text = "WAITING"
	
	var old_history_btn = get_node_or_null("VBoxContainer/DequeuedElements")
	if old_history_btn: old_history_btn.hide()
	
	if tutorial_text:
		tutorial_text.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	
	# --- HIDE ALL POINTERS INITIALLY ---
	if pivot_arrow: pivot_arrow.hide()
	if front_icon: front_icon.hide()
	if rear_icon: rear_icon.hide()
	
	_connect_signals()
	_ready_tutorial_connection()
	
	config_modal.hide()
	if config_size_elements_modal: config_size_elements_modal.hide()
	_show_config_modal()

func _connect_signals() -> void:
	if not enqueue_btn.is_connected("pressed", _on_add_element_pressed): enqueue_btn.pressed.connect(_on_add_element_pressed)
	if not dequeue_btn.is_connected("pressed", _on_sort_step_pressed): dequeue_btn.pressed.connect(_on_sort_step_pressed)
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
	
	if complete_ok_btn: complete_ok_btn.pressed.connect(func(): complete_popup.hide())
	if show_cpp_btn: show_cpp_btn.pressed.connect(_show_cpp_code)
	if cpp_code_button: cpp_code_button.pressed.connect(_show_cpp_code)
	
	# FIX: Connect the corrected close button
	if cpp_close_btn: 
		cpp_close_btn.pressed.connect(func(): cpp_popup.hide())
	
	if cpp_next_button:
		if not cpp_next_button.is_connected("pressed", _on_cpp_next_button_pressed):
			cpp_next_button.pressed.connect(_on_cpp_next_button_pressed)

# --- 5. CONFIGURATION LOGIC ---
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

# --- 6. MAIN SIMULATION LOGIC ---

func _on_add_element_pressed():
	if is_sorting: return 
	if array_data.size() >= MAX_SIZE or waiting_data.is_empty(): return
	
	btn_sound.play()
	var val = waiting_data.pop_front()
	array_data.append(val)
	log_history.append("Added %d" % val)
	
	var blk = BLOCK_SCENE.instantiate()
	blk.set("value", val)
	
	# ASSIGN UNIQUE COLOR
	var col_idx = (queue_container.get_child_count()) % SAFE_COLORS.size()
	var unique_col = SAFE_COLORS[col_idx]
	
	if blk.has_method("set_base_color"):
		blk.set_base_color(unique_col)
	else:
		blk.modulate = unique_col
	
	if not blk.is_connected("block_dropped", _on_block_dropped):
		blk.block_dropped.connect(_on_block_dropped)
		
	queue_container.add_child(blk)
	
	var idx = array_data.size() - 1
	var target_pos = _get_block_pos(idx)
	blk.position = target_pos + Vector2(200, 0)
	blk.modulate.a = 0
	
	var tw = create_tween().set_parallel(true)
	tw.tween_property(blk, "position", target_pos, 0.5).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(blk, "modulate:a", 1.0, 0.4)
	
	_update_ui()

func _on_sort_step_pressed():
	if array_data.size() < 2: return
	
	if not is_sorting:
		is_sorting = true
		current_state = SortState.INIT_GAP
		enqueue_btn.disabled = true
		log_history.append("--- Shell Sort Started ---")
		current_action_text = "Starting..."
		_update_ui() 
	
	btn_sound.play()
	_execute_sort_logic()

func _execute_sort_logic():
	match current_state:
		# 1. Initialize Gap
		SortState.INIT_GAP:
			gap = array_data.size() / 2
			if gap > 0:
				current_action_text = "Initial Gap: %d" % gap
				log_history.append(current_action_text)
				current_state = SortState.START_PASS
				sort_i = gap
				_execute_sort_logic() # Auto start pass
			else:
				_finish_simulation()

		# 2. Start a Pass for current 'i'
		SortState.START_PASS:
			if sort_i < array_data.size():
				sort_j = sort_i
				current_state = SortState.COMPARE
				# Proceed to compare immediately or wait? Let's proceed to highlight.
				_execute_sort_logic()
			else:
				current_state = SortState.REDUCE_GAP
				_execute_sort_logic()

		# 3. Compare arr[j] and arr[j-gap]
		SortState.COMPARE:
			_reset_block_visuals()
			
			if sort_j >= gap:
				comparison_count += 1
				var idx1 = sort_j
				var idx2 = sort_j - gap
				
				# Highlight both (GREEN)
				var b1 = queue_container.get_child(idx1)
				var b2 = queue_container.get_child(idx2)
				b1.modulate = HIGHLIGHT_COLOR
				b2.modulate = HIGHLIGHT_COLOR
				
				current_action_text = "Gap %d: Comparing %d & %d" % [gap, array_data[idx2], array_data[idx1]]
				log_history.append(current_action_text)
				_update_ui()
				
				current_state = SortState.ACTION
			else:
				# Cannot go back further, move to next element
				current_state = SortState.NEXT_I
				_execute_sort_logic()

		# 4. Swap or Break
		SortState.ACTION:
			var idx1 = sort_j
			var idx2 = sort_j - gap
			
			if array_data[idx2] > array_data[idx1]:
				swap_count += 1
				current_action_text = "%d > %d -> Swapping!" % [array_data[idx2], array_data[idx1]]
				log_history.append(current_action_text)
				
				_perform_swap(idx2, idx1)
				
				sort_j -= gap # Move scanner back
				current_state = SortState.COMPARE
				_update_ui()
			else:
				current_action_text = "Order correct. Stopping chain."
				log_history.append(current_action_text)
				current_state = SortState.NEXT_I
				_update_ui()

		# 5. Move i forward
		SortState.NEXT_I:
			sort_i += 1
			current_state = SortState.START_PASS
			# Stop to let user click again? Or auto flow?
			# Shell sort has many steps. Let's auto-flow into next compare setup.
			# But for "Step" button, we stop.
			# _execute_sort_logic() -> NO, wait for click.

		# 6. Reduce Gap
		SortState.REDUCE_GAP:
			gap /= 2
			if gap > 0:
				current_action_text = "Reducing Gap to %d" % gap
				log_history.append(current_action_text)
				sort_i = gap
				current_state = SortState.START_PASS
				_update_ui()
			else:
				_finish_simulation()

func _perform_swap(idx1: int, idx2: int):
	var temp = array_data[idx1]
	array_data[idx1] = array_data[idx2]
	array_data[idx2] = temp
	
	var b1 = queue_container.get_child(idx1)
	var b2 = queue_container.get_child(idx2)
	
	queue_container.move_child(b2, idx1)
	queue_container.move_child(b1, idx2)
	
	var tw = create_tween().set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(b1, "position", _get_block_pos(idx2), 0.3)
	tw.parallel().tween_property(b2, "position", _get_block_pos(idx1), 0.3)
	
	b1.modulate = HIGHLIGHT_COLOR
	b2.modulate = HIGHLIGHT_COLOR

func _reset_block_visuals():
	for child in queue_container.get_children():
		if child.has_method("reset_color"):
			child.reset_color()
		else:
			child.modulate = Color(1, 1, 1)

# --- 7. MANUAL INTERACTION ---
func _on_block_dropped(dropped_block: Control) -> void:
	var children: Array = queue_container.get_children()
	children.sort_custom(func(a, b): return a.position.x < b.position.x)
	
	var temp_array: Array[int] = []
	for child in children:
		if "value" in child:
			temp_array.append(child.value)
	
	for i in range(children.size()):
		queue_container.move_child(children[i], i)
	
	array_data = temp_array.duplicate()
	_resnap_blocks()
	
	is_sorting = false 
	current_state = SortState.INIT_GAP
	
	current_action_text = "User Moved Block"
	log_history.append("User adjusted blocks manually.")
	_update_ui()
	_reset_block_visuals()

func _flash_red(block: Control):
	var tw = create_tween()
	tw.tween_property(block, "modulate", Color(1, 0.2, 0.2), 0.2) 
	tw.tween_property(block, "modulate", block.base_color, 0.2)

func _resnap_blocks() -> void:
	for i in range(queue_container.get_child_count()):
		var child = queue_container.get_child(i)
		var target_pos = _get_block_pos(i)
		var tw = create_tween().set_trans(Tween.TRANS_SINE)
		tw.tween_property(child, "position", target_pos, 0.2)

func _get_block_pos(index: int) -> Vector2:
	var block_width = 64.0 
	var x = START_POSITION.x + index * (block_width + BLOCK_SPACING)
	return Vector2(x, START_POSITION.y)

func _finish_simulation():
	var msg = "Shell Sort Complete!\nComparisons: %d\nSwaps: %d" % [comparison_count, swap_count]
	process_label.text = msg
	current_action_text = "Done!"
	_update_ui()
	_reset_block_visuals()
	complete_popup.popup_centered()
	if cpp_code_button: cpp_code_button.show()
	
	for i in range(queue_container.get_child_count()):
		var b = queue_container.get_child(i)
		var tw = create_tween().set_trans(Tween.TRANS_SINE)
		tw.tween_property(b, "modulate", HIGHLIGHT_COLOR, 0.1).set_delay(i * 0.05)
		if b.has_method("reset_color"):
			tw.tween_callback(b.reset_color).set_delay((i * 0.05) + 0.2)

# --- 8. HELPER FUNCTIONS ---
func _update_ui():
	enqueue_label.text = "Comparisons: %d" % comparison_count
	dequeue_label.text = "Swaps: %d | %s" % [swap_count, current_action_text]
	
	enqueue_btn.disabled = (is_sorting or waiting_data.is_empty())
	
	# UPDATED VISIBILITY LOGIC
	if is_sorting:
		front_icon.show()
		rear_icon.show()
	else:
		front_icon.hide()
		rear_icon.hide()
	
	# Keep Pivot Arrow hidden for Shell Sort (unless you want it)
	if pivot_arrow: pivot_arrow.hide()

func _update_pointers():
	pass # Static pointers

func _on_reset_pressed():
	btn_sound.play()
	for c in queue_container.get_children(): c.queue_free()
	array_data.clear(); waiting_data.clear(); log_history.clear()
	comparison_count = 0; swap_count = 0; is_sorting = false
	current_state = SortState.INIT_GAP
	current_action_text = ""
	_on_config_no()

# --- 9. POPUPS & HISTORY ---
func _on_waiting_pressed():
	waiting_label.text = "Waiting Numbers:\n" + str(waiting_data)
	waiting_popup.popup_centered()

func _on_timeline_pressed():
	timeline_label.text = "Log:\n" + "\n".join(log_history)
	timeline_popup.popup_centered()

# --- 10. C++ GENERATION (SHELL SORT) ---
func _show_cpp_code():
	complete_popup.hide()
	var arr_str = ", ".join(array_data.map(func(x): return str(x)))
	
	var code = """#include <iostream>
using namespace std;

void shellSort(int arr[], int n) {
    // Start with a big gap, then reduce the gap
    for (int gap = n/2; gap > 0; gap /= 2) {
        // Do a gapped insertion sort for this gap size.
        for (int i = gap; i < n; i += 1) {
            int temp = arr[i];
            int j;
            for (j = i; j >= gap && arr[j - gap] > temp; j -= gap)
                arr[j] = arr[j - gap];
            arr[j] = temp;
        }
    }
}

int main() {
    int arr[] = { %s };
    int n = sizeof(arr) / sizeof(arr[0]);
    cout << "Sorted Array: ";
    shellSort(arr, n);
    for(int i=0; i<n; i++) cout << arr[i] << " ";
    return 0;
}
""" % [arr_str]
	
	cpp_text.text = code
	
	cpp_tutorial_steps = [
		{ "lines": Vector2i(0, 2), "text": "1. Standard C++ Setup." },
		{ "lines": Vector2i(5, 6), "text": "2. Outer Loop: Reduces the gap size (n/2, n/4...)." },
		{ "lines": Vector2i(7, 12), "text": "3. Inner Loops: Performs Insertion Sort on gapped elements." },
		{ "lines": Vector2i(10, 11), "text": "4. Swap/Shift: Moves smaller elements to the correct gapped position." }
	]
	
	cpp_popup.popup_centered()
	start_cpp_code_tutorial()

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

func _on_cpp_next_button_pressed() -> void:
	btn_sound.play()
	cpp_tutorial_index += 1
	show_cpp_explanation()

func end_cpp_tutorial() -> void:
	cpp_tutorial_panel.hide()
	clear_cpp_highlight()

# --- 11. MAIN HELP TUTORIAL ---
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
		{ "node": null, "text": "SHELL SORT:\nA generalization of Insertion Sort. It compares elements far apart (Gap) and gradually reduces the gap to 1.", "action": "next" },
		{ "node": enqueue_btn, "text": "ADD ELEMENT: Fill the array first.", "action": "next" },
		{ "node": dequeue_btn, "text": "SORT STEP: Compare and Shift using Gaps.", "action": "next" },
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
