extends Control
#   MERGE SORT SIMULATION


# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton
@onready var auto_btn: Button = $VBoxContainer/WaitingElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var compare_label: Label = $HBoxContainer2/Label
@onready var array_container: Control = $QueueContainer
@onready var dequeued_container: Control = $DequeuedContainer 

# --- POPUPS ---
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: Label = $TimelinePopup/MainVBox/ScrollContainer/VBoxContainer/Label
@onready var timeline_close_btn: Button = get_node_or_null("TimelinePopup/MainVBox/CloseButton")

# Queue Full Warning
@onready var Queue_full: Panel = get_node_or_null("Queue_full")
@onready var anim_sprite: AnimatedSprite2D = get_node_or_null("Queue_full/AnimatedSprite2D")

# Simulation Complete popup
@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var process_label: Label = get_node_or_null("SimulationCompletePopup/VBoxContainer/ProcessLabel")

# --- C++ POPUP NODES (SCROLLABLE SETUP) ---
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
# References for ScrollContainer + RichTextLabel
@onready var cpp_scroll: ScrollContainer = get_node_or_null("CppPopup/VBoxContainer/CodeScroll")
@onready var cpp_label: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/CodeScroll/CodeLabel")
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/close") as Button

# Code Walkthrough Nodes
@onready var cpp_next_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CppNextButton")
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_lbl: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")

# Top Right Button
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")
@onready var code_anim: AnimatedSprite2D = get_node_or_null("CppCodeButton/code_anim")

# --- SCENE RESOURCES ---
const BLOCK_SCENE := preload("res://MergeBlock.tscn")
const POINTER_TEX := preload("res://assets/point_left.png")

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
@onready var q_mark_sprite: AnimatedSprite2D = $HelpButton/Q_mark_anim_sprites

# --- LANGUAGE BUTTONS ---
@onready var cpp_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Cpp_btn
@onready var python_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Py_btn
@onready var java_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Java_btn
@onready var c_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/C_btn

# --- MERGE SORT VARIABLES ---
var main_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []

# Merge Sort State
var curr_width: int = 1
var left_start: int = 0
var m_i: int = 0
var m_j: int = 0
var m_mid: int = 0
var m_right_end: int = 0
var is_merging_step: bool = false 

var comparison_counter: int = 0
var swap_counter: int = 0
var sorting_complete: bool = false
var is_sorting: bool = false
var is_auto_playing: bool = false

var BLOCK_WIDTH: float = 64.0 
var BLOCK_SPACING: float = 15.0
var START_POSITION: Vector2 = Vector2(50, 80)
var ANIM_SPEED: float = 1.2
var FLOATING_OFFSET: float = -60.0

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

# Intro Text (CORRECTED FOR MERGE SORT)
var intro_step: int = 0
var intro_texts = [
	"Welcome to Merge Sort Simulation!\nMerge Sort is a 'Divide and Conquer' algorithm. It divides the list into smaller sub-lists, sorts them, and then merges them back together.",
	"The Algorithm (Iterative):\n\n1. Start with sub-arrays of size 1.\n2. Merge adjacent sub-arrays to form sorted lists of size 2.\n3. Repeat for size 4, 8, etc., until the whole list is merged.",
	"Complexity Analysis:\n\nTime: O(n log n) - Very efficient, even for large datasets.\nSpace: O(n) - Requires extra memory for the temporary merge array.",
	"Visual Elements:\n\n• Active groups will FLOAT UP while being merged.\n• 'FRONT' pointer: Left sub-array item.\n• 'REAR' pointer: Right sub-array item."
]

# --- CODE TUTORIAL DATA (RE-MAPPED TO FIT NEW PRINTS) ---
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

var cpp_tutorial_data = [
	{ "lines": [0], "text": "1. Complexity Analysis:\nTime is [color=green]O(N log N)[/color] but Space is [color=orange]O(N)[/color] due to array copies." },
	{ "lines": [1, 2], "text": "2. Imports & Setup:\nStandard Input/Output libraries." },
	{ "lines": [4, 5], "text": "3. Print Array Helper:\nA function to print array elements at each step." },
	{ "lines": [11, 12, 13, 14], "text": "4. Merge Function:\nTakes two sorted sub-arrays and merges them. We use an in-place shift here to save memory." },
	{ "lines": [29, 30, 31, 32], "text": "5. Iterative Structure:\nLoops control the width (1, 2, 4...) and the starting positions, printing after each merge." },
	{ "lines": [38, 39], "text": "6. Main Function:\nInitializes the array and calls our sort." }
]

var python_tutorial_data = [
	{ "lines": [0], "text": "1. Complexity Analysis:\nTime is [color=green]O(N log N)[/color] but Space is [color=orange]O(N)[/color] due to array copies." },
	{ "lines": [1, 2, 3], "text": "2. Merge Function:\nCreate temporary copies of Left (L) and Right (R) sub-arrays." },
	{ "lines": [6, 7, 8, 9, 10], "text": "3. Comparison Loop:\nPick the smaller element from L or R and put it back into the main array." },
	{ "lines": [12, 13], "text": "4. Cleanup:\nCopy any remaining elements from L or R." },
	{ "lines": [15, 16], "text": "5. Merge Sort Driver:\nIteratively increase width (1, 2, 4...) and call merge on segments." },
	{ "lines": [23], "text": "6. Execution:\nPrint array at each size level for debugging." }
]

var java_tutorial_data = [
	{ "lines": [0], "text": "1. Complexity Analysis:\nTime is [color=green]O(N log N)[/color] but Space is [color=orange]O(N)[/color] due to array copies." },
	{ "lines": [2, 3, 4], "text": "2. Merge Function:\nCreates temp arrays L[] and R[] to hold the data we are sorting." },
	{ "lines": [8, 9, 10, 11], "text": "3. Comparison Logic:\nWhile both temp arrays have data, pick smaller and increment the index." },
	{ "lines": [17, 18, 19], "text": "4. Sort Function:\nIterative approach using loops for width and start index." },
	{ "lines": [23, 24, 25], "text": "5. Print Logic:\nPrints the array state at the end of each width grouping." },
	{ "lines": [30, 31, 32], "text": "6. Main:\nInitializes array and calls sort." }
]

var c_tutorial_data = [
	{ "lines": [0], "text": "1. Complexity Analysis:\nTime is [color=green]O(N log N)[/color] but Space is [color=orange]O(N)[/color] due to array copies." },
	{ "lines": [4, 5, 6, 7, 8, 9], "text": "2. Merge Function:\nCreate temp arrays L and R and copy data into them." },
	{ "lines": [11, 12, 13, 14], "text": "3. Comparison Loop:\nStandard merge logic: compare L[i] and R[j], place smaller in arr[k]." },
	{ "lines": [20, 21, 22, 23], "text": "4. Iterative Structure:\nLoops for `curr_size` and `left_start` replace recursion." },
	{ "lines": [29, 30, 31], "text": "5. Print Logic:\nPrints the array after merging chunks of curr_size." },
	{ "lines": [35, 36, 37], "text": "6. Main Function:\nInitializes array and runs sort." }
]

func _ready() -> void:
	print(" Program started — initializing Merge Sort visualizer...")
	randomize()
	
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if unused_ptr1: unused_ptr1.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	if cpp_code_button: cpp_code_button.hide()
	
	if sort_btn: sort_btn.text = "Next Step"
	if auto_btn: auto_btn.text = "Auto Sort"
	
	_connect_configuration_buttons()
	_show_config_modal() 
	
	# Intro Logic
	call_deferred("show_introduction")
	
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")
	
	_connect_language_buttons()

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
#  INITIALIZATION
# ==============================================

func _initialize_with_elements(elements: Array[int]) -> void:
	print(" Initializing Array with:", elements)
	audio_player.play()
	
	main_array = elements.duplicate()
	block_nodes.clear()
	timeline_log.clear()
	
	# Initialize Merge Sort Vars
	curr_width = 1
	left_start = 0
	is_merging_step = false
	
	comparison_counter = 0
	swap_counter = 0
	sorting_complete = false
	is_auto_playing = false
	
	for child in array_container.get_children():
		child.queue_free()
	
	var current_x = START_POSITION.x
	for val in main_array:
		var new_block = BLOCK_SCENE.instantiate()
		new_block.value = val
		new_block.position = Vector2(current_x, START_POSITION.y)
		
		if new_block.has_signal("block_dropped"):
			new_block.connect("block_dropped", _on_block_dropped)
		
		new_block.modulate.a = 0.0 
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(new_block, "modulate:a", 1.0, 0.5)
		
		array_container.add_child(new_block)
		block_nodes.append(new_block)
		current_x += new_block.size.x + BLOCK_SPACING
	
	_ensure_connected(sort_btn, "pressed", _on_step_pressed)
	_ensure_connected(auto_btn, "pressed", _on_auto_pressed)
	_ensure_connected(timeline_btn, "pressed", _on_timeline_pressed)
	_ensure_connected(simulate_new_btn, "pressed", _on_simulate_new_pressed)
	_ensure_connected(complete_ok_btn, "pressed", _on_complete_ok_pressed)
	_ensure_connected(show_cpp_btn, "pressed", _on_show_cpp_pressed)
	_ensure_connected(cpp_code_button, "pressed", _on_cpp_code_button_pressed)
	_ensure_connected(cpp_close_btn, "pressed", _on_cpp_close_pressed)
	
	if timeline_close_btn:
		if not timeline_close_btn.is_connected("pressed", _on_timeline_close_pressed):
			timeline_close_btn.pressed.connect(_on_timeline_close_pressed)

	_update_ui_labels()
	if cpp_code_button: cpp_code_button.hide()

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

# ==============================================
#  DRAG AND DROP LOGIC
# ==============================================

func _on_block_dropped(dropped_block: Control) -> void:
	if is_sorting or comparison_counter > 0:
		print(" Cannot drag blocks while sorting!")
		_resnap_blocks()
		return
		
	var children: Array = array_container.get_children()
	var old_index: int = block_nodes.find(dropped_block)
	var center_x: float = dropped_block.position.x + dropped_block.size.x * 0.5
	var insert_index: int = 0
	
	for c in block_nodes:
		if c == dropped_block: continue
		var c_center: float = c.position.x + c.size.x * 0.5
		if center_x > c_center:
			insert_index += 1
	
	if old_index != insert_index:
		var val = main_array.pop_at(old_index)
		main_array.insert(insert_index, val)
		block_nodes.remove_at(old_index)
		block_nodes.insert(insert_index, dropped_block)
		timeline_log.append("User moved %d from index %d to %d" % [val, old_index, insert_index])
	
	_resnap_blocks()

func _resnap_blocks() -> void:
	var x = START_POSITION.x
	for i in range(block_nodes.size()):
		var node = block_nodes[i]
		
		# Determine Target Y (Floating Logic)
		var target_y = START_POSITION.y
		if is_merging_step:
			if i >= left_start and i <= m_right_end:
				target_y = START_POSITION.y + FLOATING_OFFSET
		
		var target_pos = Vector2(x, target_y)
		create_tween().tween_property(node, "position", target_pos, ANIM_SPEED)
		x += node.size.x + BLOCK_SPACING

# ==============================================
#  MERGE SORT LOGIC
# ==============================================

func _on_step_pressed() -> void:
	if is_sorting or sorting_complete: return
	if tutorial_in_progress: _handle_tutorial_step()
	btn_sound.play()
	_perform_sort_step()

func _on_auto_pressed() -> void:
	if sorting_complete: return
	btn_sound.play()
	is_auto_playing = !is_auto_playing
	auto_btn.text = "Pause" if is_auto_playing else "Auto Sort"
	if is_auto_playing: _run_auto_sort()

func _run_auto_sort() -> void:
	while is_auto_playing and not sorting_complete:
		if is_sorting: await get_tree().process_frame 
		else:
			await _perform_sort_step()
			await get_tree().create_timer(ANIM_SPEED).timeout

func _perform_sort_step():
	is_sorting = true
	var n_size = main_array.size()
	
	if not is_merging_step:
		if curr_width >= n_size:
			for node in block_nodes:
				create_tween().tween_property(node, "position:y", START_POSITION.y, 0.5)
				if node.has_method("set_sorted_visual"): node.set_sorted_visual()
			_finish_simulation()
			is_sorting = false
			return
		
		if left_start >= n_size - 1:
			curr_width *= 2
			left_start = 0
			if curr_width >= n_size:
				is_sorting = false
				return
		
		m_mid = min(left_start + curr_width - 1, n_size - 1)
		m_right_end = min(left_start + 2 * curr_width - 1, n_size - 1)
		
		if m_mid >= m_right_end:
			left_start += 2 * curr_width
			is_sorting = false
			return
			
		m_i = left_start
		m_j = m_mid + 1
		is_merging_step = true
		
		status_label.text = "Merging range [%d-%d] and [%d-%d]" % [left_start, m_mid, m_mid+1, m_right_end]
		timeline_log.append("Start merging sub-arrays of width %d" % curr_width)
		
		_resnap_blocks() 
		
		is_sorting = false
		return 

	if is_merging_step:
		if m_i <= m_mid and m_j <= m_right_end:
			_update_pointers(m_i, m_j)
			
			if block_nodes[m_i].has_method("set_highlight"): block_nodes[m_i].set_highlight(true)
			if block_nodes[m_j].has_method("set_highlight"): block_nodes[m_j].set_highlight(true)
			
			comparison_counter += 1
			var val_left = main_array[m_i]
			var val_right = main_array[m_j]
			
			status_label.text = "Comparing: %d vs %d" % [val_left, val_right]
			
			await get_tree().create_timer(ANIM_SPEED * 0.5).timeout
			
			if val_left <= val_right:
				status_label.text = "%d <= %d. Correct order." % [val_left, val_right]
				if block_nodes[m_i].has_method("set_highlight"): block_nodes[m_i].set_highlight(false)
				if block_nodes[m_j].has_method("set_highlight"): block_nodes[m_j].set_highlight(false)
				m_i += 1
			else:
				status_label.text = "%d > %d. Moving %d." % [val_left, val_right, val_right]
				timeline_log.append("Moving %d to index %d" % [val_right, m_i])
				swap_counter += 1
				
				var moving_val = main_array[m_j]
				var moving_node = block_nodes[m_j]
				
				main_array.remove_at(m_j)
				main_array.insert(m_i, moving_val)
				block_nodes.remove_at(m_j)
				block_nodes.insert(m_i, moving_node)
				
				_resnap_blocks() 
				await get_tree().create_timer(ANIM_SPEED).timeout
				
				m_i += 1
				m_mid += 1
				m_j += 1
				if moving_node.has_method("set_highlight"): moving_node.set_highlight(false)
				
		else:
			is_merging_step = false
			left_start += 2 * curr_width
			if ptr_left: ptr_left.hide()
			if ptr_right: ptr_right.hide()
			for node in block_nodes: 
				if node.has_method("set_highlight"): node.set_highlight(false)
			
			status_label.text = "Sub-array merged. Dropping down."
			_resnap_blocks()
	
	_update_ui_labels()
	is_sorting = false

func _update_pointers(idx_a: int, idx_b: int):
	if block_nodes.is_empty(): return
	if ptr_left: ptr_left.show()
	if ptr_right: ptr_right.show()
	
	if idx_a < block_nodes.size():
		var node = block_nodes[idx_a]
		if ptr_left:
			ptr_left.global_position = node.global_position + Vector2(16, node.size.y + 10) 
	
	if idx_b < block_nodes.size():
		var node = block_nodes[idx_b]
		if ptr_right:
			ptr_right.global_position = node.global_position + Vector2(16, node.size.y + 10)

func _finish_simulation():
	sorting_complete = true
	is_auto_playing = false
	status_label.text = "Sorted!"
	auto_btn.text = "Auto Sort"
	auto_btn.disabled = true
	sort_btn.disabled = true
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	
	timeline_log.append("--- SORTING COMPLETE ---")
	_show_complete_popup()
	
	if cpp_code_button:
		cpp_code_button.show()
		if code_anim: code_anim.play("default")

# ==============================================
#  UI & POPUPS
# ==============================================

func _update_ui_labels():
	compare_label.text = "Comparisons: %d | Moves: %d" % [comparison_counter, swap_counter]

func _show_complete_popup() -> void:
	if complete_popup:
		var txt = "Sorting Finished!\n\nTotal Comparisons: %d\nTotal Moves: %d" % [comparison_counter, swap_counter]
		if process_label: process_label.text = txt
		complete_popup.popup_centered()

func _on_timeline_pressed() -> void:
	btn_sound.play()
	if timeline_popup.visible:
		timeline_popup.hide()
	else:
		timeline_label.text = "Timeline:\n" + "\n".join(timeline_log)
		timeline_popup.popup_centered()

func _on_timeline_close_pressed() -> void:
	btn_sound.play()
	if timeline_popup:
		timeline_popup.hide()

# ==============================================
#  CODE GENERATION & TUTORIAL
# ==============================================

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	if complete_popup: complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

func _show_cpp_popup() -> void:
	var code = ""
	var arr_str = ", ".join(main_array.map(func(x): return str(x)))
	
	match current_code_language:
		"cpp":
			code = get_cpp_merge_code(arr_str)
			current_tutorial_data = cpp_tutorial_data
		"python":
			code = get_python_merge_code(arr_str)
			current_tutorial_data = python_tutorial_data
		"java":
			code = get_java_merge_code(arr_str)
			current_tutorial_data = java_tutorial_data
		"c":
			code = get_c_merge_code(arr_str)
			current_tutorial_data = c_tutorial_data
	
	if cpp_label:
		cpp_label.text = code
	
	cpp_popup.popup_centered()
	
	cpp_tutorial_step = 0
	if cpp_next_btn:
		if not cpp_next_btn.is_connected("pressed", _on_cpp_next_pressed):
			cpp_next_btn.pressed.connect(_on_cpp_next_pressed)
	_update_cpp_tutorial()

func _on_cpp_next_pressed() -> void:
	btn_sound.play()
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
		var code = ""
		var arr_str = ", ".join(main_array.map(func(x): return str(x)))
		match current_code_language:
			"cpp": code = get_cpp_merge_code(arr_str)
			"python": code = get_python_merge_code(arr_str)
			"java": code = get_java_merge_code(arr_str)
			"c": code = get_c_merge_code(arr_str)
		
		var lines = code.split("\n")
		var highlighted_code = ""
		var highlight_indices = data["lines"]
		
		for i in range(lines.size()):
			if i in highlight_indices:
				highlighted_code += "[color=yellow]" + lines[i] + "[/color]\n"
			else:
				highlighted_code += lines[i] + "\n"
		
		cpp_label.bbcode_enabled = true
		cpp_label.text = highlighted_code
		
		# --- AUTO SCROLL FIX ---
		if cpp_scroll and highlight_indices.size() > 0:
			var target_scroll = highlight_indices[0] * 20
			var tween = create_tween()
			tween.tween_property(cpp_scroll, "scroll_vertical", target_scroll, 0.2).set_trans(Tween.TRANS_SINE)

# --- MERGE SORT CODE STRINGS WITH PRINTS ---

func get_cpp_merge_code(arr: String) -> String:
	return """// Time Complexity: O(n log n) | Space Complexity: O(n)
#include <iostream>
using namespace std;

void printArray(int arr[], int n) {
	for (int i = 0; i < n; i++) cout << arr[i] << " ";
	cout << endl;
}

void merge(int arr[], int start, int mid, int end) {
	int start2 = mid + 1;
	if (arr[mid] <= arr[start2]) return;
	while (start <= mid && start2 <= end) {
		if (arr[start] <= arr[start2]) {
			start++;
		} else {
			int value = arr[start2];
			int index = start2;
			while (index != start) {
				arr[index] = arr[index - 1];
				index--;
			}
			arr[start] = value;
			start++; mid++; start2++;
		}
	}
}

void mergeSort(int arr[], int n) {
	for (int width = 1; width < n; width *= 2) {
		for (int i = 0; i < n - 1; i += 2 * width) {
			int mid = min(i + width - 1, n - 1);
			int right_end = min(i + 2 * width - 1, n - 1);
			merge(arr, i, mid, right_end);
		}
		cout << "After merging width " << width << ": ";
		printArray(arr, n);
	}
}

int main() {
	int arr[] = { %s };
	int n = sizeof(arr) / sizeof(arr[0]);
	cout << "Initial array: "; printArray(arr, n); cout << endl;
	mergeSort(arr, n);
	return 0;
}""" % arr

func get_python_merge_code(arr: String) -> String:
	return """# Time Complexity: O(n log n) | Space Complexity: O(n)
def merge(arr, l, m, r):
	n1, n2 = m - l + 1, r - m
	L = arr[l:m+1]; R = arr[m+1:r+1]
	i = j = 0; k = l
	
	while i < n1 and j < n2:
		if L[i] <= R[j]:
			arr[k] = L[i]; i += 1
		else:
			arr[k] = R[j]; j += 1
		k += 1
	while i < n1: arr[k] = L[i]; i += 1; k += 1
	while j < n2: arr[k] = R[j]; j += 1; k += 1

def merge_sort(arr):
	width = 1; n = len(arr)
	while width < n:
		l = 0
		while l < n:
			r = min(l + (width * 2 - 1), n - 1)
			m = min(l + width - 1, n - 1)
			if m < r: merge(arr, l, m, r)
			l += width * 2
		print(f"After merging width {width}: {arr}")
		width *= 2

arr = [%s]
print(f"Initial array: {arr}\\n")
merge_sort(arr)""" % arr

func get_java_merge_code(arr: String) -> String:
	return """// Time Complexity: O(n log n) | Space Complexity: O(n)
class MergeSort {
	void merge(int arr[], int l, int m, int r) {
		int n1 = m - l + 1, n2 = r - m;
		int L[] = new int[n1], R[] = new int[n2];
		for (int i=0; i<n1; ++i) L[i] = arr[l + i];
		for (int j=0; j<n2; ++j) R[j] = arr[m + 1 + j];
		
		int i=0, j=0, k=l;
		while (i<n1 && j<n2) {
			if (L[i] <= R[j]) arr[k++] = L[i++];
			else arr[k++] = R[j++];
		}
		while (i<n1) arr[k++] = L[i++];
		while (j<n2) arr[k++] = R[j++];
	}
	void sort(int arr[]) {
		int n = arr.length;
		for (int curr_size = 1; curr_size <= n-1; curr_size = 2*curr_size) {
			for (int left_start = 0; left_start < n-1; left_start += 2*curr_size) {
				int mid = Math.min(left_start + curr_size - 1, n-1);
				int right_end = Math.min(left_start + 2*curr_size - 1, n-1);
				merge(arr, left_start, mid, right_end);
			}
			System.out.print("After merging width " + curr_size + ": ");
			for (int x : arr) System.out.print(x + " ");
			System.out.println();
		}
	}
	public static void main(String args[]) {
		int arr[] = {%s};
		System.out.print("Initial array: ");
		for (int x : arr) System.out.print(x + " ");
		System.out.println("\\n");
		new MergeSort().sort(arr);
	}
}""" % arr

func get_c_merge_code(arr: String) -> String:
	return """// Time Complexity: O(n log n) | Space Complexity: O(n)
#include <stdio.h>
#include <stdlib.h>

void merge(int arr[], int l, int m, int r) {
	int i, j, k;
	int n1 = m - l + 1, n2 = r - m;
	int L[n1], R[n2];
	for (i = 0; i < n1; i++) L[i] = arr[l + i];
	for (j = 0; j < n2; j++) R[j] = arr[m + 1 + j];
	
	i = 0; j = 0; k = l;
	while (i < n1 && j < n2) {
		if (L[i] <= R[j]) arr[k++] = L[i++];
		else arr[k++] = R[j++];
	}
	while (i < n1) arr[k++] = L[i++];
	while (j < n2) arr[k++] = R[j++];
}

void mergeSort(int arr[], int n) {
	int curr_size, left_start;
	for (curr_size = 1; curr_size <= n-1; curr_size = 2*curr_size) {
		for (left_start = 0; left_start < n-1; left_start += 2*curr_size) {
			int mid = (left_start + curr_size - 1) < (n-1) ? (left_start + curr_size - 1) : (n-1);
			int right_end = (left_start + 2*curr_size - 1) < (n-1) ? (left_start + 2*curr_size - 1) : (n-1);
			merge(arr, left_start, mid, right_end);
		}
		printf("After merging width %d: ", curr_size);
		for (int i = 0; i < n; i++) printf("%d ", arr[i]);
		printf("\\n");
	}
}

int main() {
	int arr[] = {%s};
	int n = sizeof(arr)/sizeof(arr[0]);
	printf("Initial array: ");
	for (int i = 0; i < n; i++) printf("%d ", arr[i]);
	printf("\\n\\n");
	mergeSort(arr, n);
	return 0;
}""" % arr

# ==============================================
#  CONFIG HANDLERS
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
		
		# Create label
		var label = Label.new()
		label.text = "Value %d" % (i + 1)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		# Create input
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
		var val = int(le.text) if le.text.is_valid_int() else int(le.placeholder_text)
		arr.append(val)
	config_elements_modal.hide()
	_set_main_ui_enabled(true)
	_initialize_with_elements(arr)

func _on_config_no_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	var count = randi_range(5, 7)
	var arr: Array[int] = []
	for i in count: arr.append(randi_range(1, 99))
	_set_main_ui_enabled(true)
	_initialize_with_elements(arr)

func _on_size_back_pressed(): config_size_modal.hide(); config_modal.show()
func _on_elements_back_pressed(): config_elements_modal.hide(); config_size_modal.show()

# ==============================================
#  INTRO LOGIC & TUTORIAL (CRITICAL)
# ==============================================

func show_introduction():
	if tutorial_overlay: tutorial_overlay.show()
	if not intro_popup: return
	intro_popup.show()
	_set_main_ui_enabled(false)
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

func _on_intro_prev_pressed():
	btn_sound.play()
	if intro_step > 0:
		intro_step -= 1
		_update_intro_text()

func _on_intro_skip_pressed():
	btn_sound.play()
	intro_popup.hide()
	_set_main_ui_enabled(true)

# --- TUTORIAL MAIN ---

func start_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	tutorial_overlay.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{
			"node": sort_btn,
			"title": "NEXT STEP",
			"text": "Executes one merge step. Compares elements from left/right sub-arrays.",
			"action": "highlight"
		},
		{
			"node": auto_btn,
			"title": "AUTO SORT",
			"text": "Starts/Pauses the automatic merge sort.",
			"action": "highlight"
		},
		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View a scrollable history of comparisons and merges.",
			"action": "highlight"
		},
		{
			"node": simulate_new_btn,
			"title": "SIMULATE NEW",
			"text": "Resets the simulation.",
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

func _handle_tutorial_step():
	var step = tutorial_sequence[tutorial_sequence_index]
	if step["node"] == sort_btn:
		tutorial_sequence_index += 1
		show_tutorial_step()

func _on_next_button_pressed():
	tutorial_sequence_index += 1
	show_tutorial_step()

func end_tutorial():
	tutorial_in_progress = false
	tutorial_overlay.hide()
	if pointer_sprite:
		pointer_sprite.hide()
		if pointer_sprite.has_meta("tween"):
			pointer_sprite.get_meta("tween").kill()

# ==============================================
#  HELPER / UTILS
# ==============================================

func _set_main_ui_enabled(enabled: bool) -> void:
	if sort_btn: sort_btn.disabled = not enabled
	if auto_btn: auto_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled
	if simulate_new_btn: simulate_new_btn.disabled = not enabled

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
	start_tutorial()
