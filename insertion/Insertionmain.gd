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
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: Label = $TimelinePopup/VBoxContainer/Label
@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var process_label: Label = $SimulationCompletePopup/VBoxContainer/ProcessLabel

# C++ Popup references
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_text: TextEdit = get_node_or_null("CppPopup/VBoxContainer/TextEdit") as TextEdit

# --- FIX: Changed "Button" to "close" to match your Scene Tree ---
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
@onready var audio_player = $bgm
@onready var btn_sound = $btn_sound

# --- 2. CONFIGURATION ---
const BLOCK_SCENE := preload("res://InsertionBlock.tscn")

var MAX_SIZE: int = 6
var BLOCK_SPACING: float = 30.0 
var START_POSITION: Vector2 = Vector2(80, 80)

# --- 3. SORTING STATE VARIABLES ---
var array_data: Array[int] = []          
var waiting_data: Array[int] = []        
var log_history: Array[String] = []      
var comparison_count: int = 0
var swap_count: int = 0

# Insertion Sort specific
var sort_i: int = 1          
var sort_j: int = 0          
var sort_key_val: int = 0    
var sort_key_block: Control = null
var is_sorting: bool = false

# Tutorial State
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false
var cpp_tutorial_index := 0
var cpp_tutorial_steps := []

# State Machine
enum SortState { PICK_KEY, COMPARE, SHIFT, INSERT }
var current_state = SortState.PICK_KEY

# --- 4. INITIALIZATION ---
func _ready() -> void:
	print("--- Insertion Sort Visualizer Started ---")
	randomize()
	
	# RE-LABEL BUTTONS
	if enqueue_btn: enqueue_btn.text = "ADD ELEMENT"
	if dequeue_btn: dequeue_btn.text = "SORT STEP"
	if waiting_btn: waiting_btn.text = "WAITING"
	
	# HIDE HISTORY BUTTON
	var old_history_btn = get_node_or_null("VBoxContainer/DequeuedElements")
	if old_history_btn: old_history_btn.hide()
	
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
	
	# --- FIX: Connect the corrected close button ---
	if cpp_close_btn: 
		cpp_close_btn.pressed.connect(func(): cpp_popup.hide())
	else:
		print("Error: Close button not found in CppPopup!")
	
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
	
	# Connect the Drag & Drop Signal from QueueBlock
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
		sort_i = 1 
		sort_j = 0
		current_state = SortState.PICK_KEY
		enqueue_btn.disabled = true
		log_history.append("--- Sorting Started ---")
	
	btn_sound.play()
	_execute_sort_logic()

func _execute_sort_logic():
	if sort_i >= array_data.size():
		_finish_simulation()
		return

	match current_state:
		SortState.PICK_KEY:
			sort_key_val = array_data[sort_i]
			sort_key_block = queue_container.get_child(sort_i)
			sort_j = sort_i - 1
			
			log_history.append("Selected Key: %d" % sort_key_val)
			
			var tw = create_tween()
			tw.tween_property(sort_key_block, "position:y", START_POSITION.y - 50, 0.3)
			sort_key_block.modulate = Color(2, 2, 0.5) 
			
			current_state = SortState.COMPARE

		SortState.COMPARE:
			comparison_count += 1
			
			if sort_j >= 0:
				var compare_block = queue_container.get_child(sort_j)
				compare_block.modulate = Color(1, 0.5, 0.5) 
				
				if array_data[sort_j] > sort_key_val:
					log_history.append("%d > %d (Shift Right)" % [array_data[sort_j], sort_key_val])
					dequeue_label.text = "Shift %d >>" % array_data[sort_j]
					current_state = SortState.SHIFT
				else:
					log_history.append("%d <= %d (Place Key)" % [array_data[sort_j], sort_key_val])
					compare_block.modulate = Color(1,1,1)
					current_state = SortState.INSERT
					_execute_sort_logic() 
			else:
				current_state = SortState.INSERT
				_execute_sort_logic()

		SortState.SHIFT:
			swap_count += 1
			array_data[sort_j + 1] = array_data[sort_j]
			
			var block_j = queue_container.get_child(sort_j)
			var target_pos = _get_block_pos(sort_j + 1)
			
			var tw = create_tween()
			tw.tween_property(block_j, "position", target_pos, 0.3)
			
			queue_container.move_child(block_j, sort_j + 1)
			queue_container.move_child(sort_key_block, sort_j)
			
			block_j.modulate = Color(1,1,1)
			sort_j -= 1
			current_state = SortState.COMPARE

		SortState.INSERT:
			array_data[sort_j + 1] = sort_key_val
			log_history.append("Inserted %d at pos %d" % [sort_key_val, sort_j+1])
			
			var tw = create_tween()
			var target_pos = _get_block_pos(sort_j + 1)
			target_pos.y = START_POSITION.y
			
			tw.tween_property(sort_key_block, "position", target_pos, 0.3)
			sort_key_block.modulate = Color(1,1,1)
			
			sort_i += 1
			current_state = SortState.PICK_KEY
			_update_ui()

# --- 7. MANUAL INTERACTION HANDLERS ---
func _on_block_dropped(dropped_block: Control) -> void:
	var children: Array = queue_container.get_children()
	children.sort_custom(func(a, b): return a.position.x < b.position.x)
	
	for i in range(children.size()):
		queue_container.move_child(children[i], i)
	
	array_data.clear()
	for child in children:
		if "value" in child:
			array_data.append(child.value)
			child.modulate = Color(1,1,1)
			
	_resnap_blocks()
	
	log_history.append("User moved block. Resetting state.")
	is_sorting = false 
	current_state = SortState.PICK_KEY
	sort_i = 1
	_update_ui()

func _resnap_blocks() -> void:
	for i in range(queue_container.get_child_count()):
		var child = queue_container.get_child(i)
		var target_pos = _get_block_pos(i)
		var tw = create_tween()
		tw.tween_property(child, "position", target_pos, 0.2).set_trans(Tween.TRANS_SINE)

func _get_block_pos(index: int) -> Vector2:
	var block_width = 64.0 
	var x = START_POSITION.x + index * (block_width + BLOCK_SPACING)
	return Vector2(x, START_POSITION.y)

func _finish_simulation():
	var msg = "Sorting Complete!\nComparisons: %d\nShifts: %d" % [comparison_count, swap_count]
	process_label.text = msg
	complete_popup.popup_centered()
	if cpp_code_button: cpp_code_button.show()
	
	for i in range(queue_container.get_child_count()):
		var b = queue_container.get_child(i)
		var tw = create_tween().set_trans(Tween.TRANS_SINE)
		tw.tween_property(b, "modulate", Color(0.5, 2, 0.5), 0.1).set_delay(i * 0.05)
		tw.tween_property(b, "modulate", Color(1, 1, 1), 0.1).set_delay((i * 0.05) + 0.1)

# --- 8. HELPER FUNCTIONS ---
func _update_ui():
	enqueue_label.text = "Comparisons: %d" % comparison_count
	dequeue_label.text = "Shifts: %d" % swap_count
	enqueue_btn.disabled = (is_sorting or waiting_data.is_empty())
	
	if is_sorting:
		front_icon.show() 
		rear_icon.show()
	else:
		front_icon.hide()
		rear_icon.hide()

func _on_reset_pressed():
	btn_sound.play()
	for c in queue_container.get_children(): c.queue_free()
	array_data.clear(); waiting_data.clear(); log_history.clear()
	comparison_count = 0; swap_count = 0; is_sorting = false
	current_state = SortState.PICK_KEY
	_on_config_no()

# --- 9. POPUPS & HISTORY ---
func _on_waiting_pressed():
	waiting_label.text = "Waiting Numbers:\n" + str(waiting_data)
	waiting_popup.popup_centered()

func _on_timeline_pressed():
	timeline_label.text = "Log:\n" + "\n".join(log_history)
	timeline_popup.popup_centered()

# --- 10. C++ GENERATION ---
func _show_cpp_code():
	complete_popup.hide()
	var arr_str = ", ".join(array_data.map(func(x): return str(x)))
	
	var code = """#include <iostream>
using namespace std;

// Function to perform Insertion Sort
void insertionSort(int arr[], int n) {
    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;

        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j = j - 1;
        }
        arr[j + 1] = key;
    }
}

int main() {
    int arr[] = { %s };
    int n = sizeof(arr) / sizeof(arr[0]);

    cout << "Original Array: ";
    for(int i=0; i<n; i++) cout << arr[i] << " ";
    cout << endl;

    insertionSort(arr, n);

    cout << "\\nSorted Array: ";
    for(int i=0; i<n; i++) cout << arr[i] << " ";
    return 0;
}
""" % [arr_str]
	
	cpp_text.text = code
	
	cpp_tutorial_steps = [
		{ "lines": Vector2i(0, 2), "text": "1. Standard imports. <iostream> is used for input/output." },
		{ "lines": Vector2i(5, 6), "text": "2. Loop from i=1. The left side (0 to i-1) is sorted." },
		{ "lines": Vector2i(7, 8), "text": "3. 'key' is the value to insert. 'j' tracks the sorted side." },
		{ "lines": Vector2i(10, 13), "text": "4. Shift elements right while they are > key." },
		{ "lines": Vector2i(15, 15), "text": "5. Insert the key into the correct spot." },
		{ "lines": Vector2i(19, 21), "text": "6. In main(), we create the array from your data." }
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
	var lines = step["lines"]
	
	if cpp_explanation_text:
		cpp_explanation_text.text = step["text"]
	
	highlight_cpp_lines(lines.x, lines.y)

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
	print("C++ tutorial finished.")

# --- 11. MAIN HELP TUTORIAL ---

func _ready_tutorial_connection():
	if help_btn:
		if not help_btn.is_connected("pressed", _on_help_button_pressed):
			help_btn.pressed.connect(_on_help_button_pressed)
	
	if tutorial_next:
		if not tutorial_next.is_connected("pressed", _on_tutorial_next_pressed):
			tutorial_next.pressed.connect(_on_tutorial_next_pressed)

func _on_help_button_pressed() -> void:
	print("Starting Insertion Sort Tutorial...")
	btn_sound.play()
	start_main_tutorial()

func start_main_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	tutorial_overlay.show()
	dim_bg.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{
			"node": enqueue_btn,
			"text": "This is the ADD ELEMENT button.\nBefore sorting, we need data! Click this to fill the array.",
			"action": "next",
			"pointer_pos": "center"
		},
		{
			"node": dequeue_btn,
			"text": "This is the SORT STEP button.\nThis acts as the 'Outer Loop' (i) and 'Inner Loop' (j). It performs the 'Compare' and 'Shift' operations.",
			"action": "next",
			"pointer_pos": "center"
		},
		{
			"node": waiting_btn,
			"text": "The WAITING button.\nSee the numbers waiting to be added to the array.",
			"action": "next",
			"pointer_pos": "center"
		},
		{
			"node": timeline_btn,
			"text": "The TIMELINE.\nUse this to review the full history of the sorting process step-by-step.",
			"action": "next",
			"pointer_pos": "center"
		},
		{
			"node": simulate_new_btn,
			"text": "SIMULATE NEW.\nDone sorting? Press this to clear the board and generate new random numbers.",
			"action": "end",
			"pointer_pos": "center"
		}
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
	else:
		pointer_sprite.hide()

	if step["action"] == "next":
		tutorial_next.show()
		tutorial_next.text = "Next"
		_highlight_node(node)
	elif step["action"] == "end":
		tutorial_next.show()
		tutorial_next.text = "Finish"
		_highlight_node(node)

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
