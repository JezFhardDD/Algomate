extends Control

# =======================================================
#  QUICK SORT SIMULATION - FINAL (With Scroll & All Functions)
# =======================================================

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
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label

# --- TIMELINE POPUP ---
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

# --- SCENE RESOURCES (Using QuickBlock.tscn as per your tree) ---
const BLOCK_SCENE := preload("res://QuickBlock.tscn")
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

# --- QUICK SORT VARIABLES (REPLACED MERGE) ---
var main_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []

# Iterative Quick Sort State
var quick_stack: Array = []  # Stores [low, high] ranges
var current_low: int = 0
var current_high: int = 0
var partition_index: int = 0 # 'i' in algorithm
var scan_index: int = 0      # 'j' in algorithm
var pivot_idx: int = 0
var is_partitioning: bool = false # Are we inside the partition loop?

var comparison_counter: int = 0
var swap_counter: int = 0
var sorting_complete: bool = false
var is_sorting: bool = false
var is_auto_playing: bool = false

var BLOCK_WIDTH: float = 64.0 
var BLOCK_SPACING: float = 15.0
var START_POSITION: Vector2 = Vector2(50, 80)
var ANIM_SPEED: float = 1.2 # Standard speed for Quick Sort

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

# Intro Text (UPDATED FOR QUICK SORT)
var intro_step: int = 0
var intro_texts = [
	"Welcome to Quick Sort!\n\nThis is a 'Divide and Conquer' algorithm. It's much faster than Insertion Sort for large lists.",
	"The Pivot:\n\nWe pick an element (usually the last one) to be the 'Pivot'.",
	"Partitioning:\n\nWe rearrange the array so that everything smaller than the Pivot goes to the left, and everything larger goes to the right.",
	"Complexity:\n\nTime: O(n log n) on average.\nSpace: O(log n) for stack space."
]

# Code Tutorial Data (UPDATED FOR QUICK SORT)
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var cpp_tutorial_data = [
	{ "lines": [4, 5, 6, 7, 8], "text": "[b]Complexity Analysis:[/b]\n• [b]Time:[/b] [color=green]O(n log n)[/color] (Avg), [color=red]O(n²)[/color] (Worst).\n• [b]Space:[/b] [color=orange]O(log n)[/color] due to recursion stack." },
	{ "lines": [10, 11, 12], "text": "1. Partition Function:\nTakes the last element as the 'pivot'. The goal is to place the pivot in its correct sorted position." },
	{ "lines": [13, 14, 15], "text": "2. Pointers:\n'i' tracks the boundary of smaller elements. 'j' scans the array." },
	{ "lines": [16, 17, 18, 19], "text": "3. The Swap:\nIf arr[j] is smaller than pivot, we swap it with arr[i] to move it to the 'small' side." },
	{ "lines": [23, 24, 25], "text": "4. Place Pivot:\nFinally, swap the pivot into the slot after 'i'. It is now sorted." },
	{ "lines": [28, 29, 30, 31], "text": "5. Recursive Calls:\nSort the sub-array to the left of the pivot, and then the sub-array to the right." }
]

func _ready() -> void:
	print(" Program started — initializing Quick Sort visualizer...")
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
	
	# Show Intro - Uses deferred call to ensure UI is ready
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
	
	# Initialize Quick Sort Vars
	quick_stack = []
	quick_stack.append([0, main_array.size() - 1])
	is_partitioning = false
	
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
		var target_pos = Vector2(x, START_POSITION.y)
		create_tween().tween_property(node, "position", target_pos, ANIM_SPEED)
		x += node.size.x + BLOCK_SPACING

# ==============================================
#  QUICK SORT LOGIC (ITERATIVE)
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
	
	# -- PHASE 1: PICK NEXT RANGE FROM STACK --
	if not is_partitioning:
		if quick_stack.is_empty():
			# SORTING COMPLETE
			for node in block_nodes:
				if node.has_method("set_sorted_visual"): node.set_sorted_visual()
			_finish_simulation()
			is_sorting = false
			return
		
		# Pop the next range
		var range_indices = quick_stack.pop_back()
		current_low = range_indices[0]
		current_high = range_indices[1]
		
		if current_low >= current_high:
			# Single element, already sorted
			is_sorting = false
			return
		
		# Set up for partitioning
		pivot_idx = current_high
		partition_index = current_low - 1 # 'i'
		scan_index = current_low          # 'j'
		is_partitioning = true
		
		status_label.text = "Pivot picked: %d" % main_array[pivot_idx]
		timeline_log.append("Partitioning range [%d, %d] with Pivot: %d" % [current_low, current_high, main_array[pivot_idx]])
		
		# Highlight Pivot
		if block_nodes[pivot_idx].has_method("set_highlight"):
			block_nodes[pivot_idx].set_highlight(true)
			
		is_sorting = false
		return 

	# -- PHASE 2: PARTITION LOOP --
	if is_partitioning:
		if scan_index < current_high:
			# Update Pointers
			_update_pointers(partition_index + 1, scan_index)
			
			# Compare arr[j] with Pivot
			comparison_counter += 1
			var val_j = main_array[scan_index]
			var val_pivot = main_array[pivot_idx]
			
			status_label.text = "Comparing %d vs Pivot %d" % [val_j, val_pivot]
			
			if block_nodes[scan_index].has_method("set_highlight"):
				block_nodes[scan_index].set_highlight(true)
			
			await get_tree().create_timer(ANIM_SPEED * 0.5).timeout
			
			if val_j < val_pivot:
				partition_index += 1
				# Swap if needed
				if partition_index != scan_index:
					swap_counter += 1
					status_label.text = "%d < %d. Swapping." % [val_j, val_pivot]
					
					var temp = main_array[partition_index]
					main_array[partition_index] = main_array[scan_index]
					main_array[scan_index] = temp
					
					var node_p = block_nodes[partition_index]
					var node_s = block_nodes[scan_index]
					block_nodes[partition_index] = node_s
					block_nodes[scan_index] = node_p
					
					await _animate_swap(node_p, node_s)
			else:
				status_label.text = "%d >= %d. No swap." % [val_j, val_pivot]
			
			if block_nodes[scan_index].has_method("set_highlight"):
				block_nodes[scan_index].set_highlight(false)
				
			scan_index += 1
			
		else:
			# -- PHASE 3: PLACE PIVOT --
			# Swap arr[i + 1] and arr[high] (the pivot)
			var final_pivot_pos = partition_index + 1
			
			if final_pivot_pos != current_high:
				swap_counter += 1
				var temp = main_array[final_pivot_pos]
				main_array[final_pivot_pos] = main_array[current_high]
				main_array[current_high] = temp
				
				var node_a = block_nodes[final_pivot_pos]
				var node_b = block_nodes[current_high]
				block_nodes[final_pivot_pos] = node_b
				block_nodes[current_high] = node_a
				
				status_label.text = "Placing pivot in correct spot."
				await _animate_swap(node_a, node_b)
			
			# Pivot is now at final_pivot_pos
			if block_nodes[final_pivot_pos].has_method("set_highlight"):
				block_nodes[final_pivot_pos].set_highlight(false)
			
			# Push new ranges to stack
			# Push Right side first (so Left is processed next)
			if final_pivot_pos + 1 < current_high:
				quick_stack.append([final_pivot_pos + 1, current_high])
			if current_low < final_pivot_pos - 1:
				quick_stack.append([current_low, final_pivot_pos - 1])
				
			is_partitioning = false
			
			if ptr_left: ptr_left.hide()
			if ptr_right: ptr_right.hide()
	
	_update_ui_labels()
	is_sorting = false

func _animate_swap(node_a: Control, node_b: Control):
	var pos_a = node_a.position
	var pos_b = node_b.position
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(node_a, "position", pos_b, ANIM_SPEED)
	tween.tween_property(node_b, "position", pos_a, ANIM_SPEED)
	await tween.finished
	node_a.position = pos_b
	node_b.position = pos_a

func _update_pointers(left_idx: int, right_idx: int):
	if block_nodes.is_empty(): return
	if ptr_left: ptr_left.show()
	if ptr_right: ptr_right.show()
	
	if left_idx < block_nodes.size() and left_idx >= 0:
		var node = block_nodes[left_idx]
		if ptr_left:
			ptr_left.global_position = node.global_position + Vector2(16, node.size.y + 10) 
	
	if right_idx < block_nodes.size() and right_idx >= 0:
		var node = block_nodes[right_idx]
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
	compare_label.text = "Comparisons: %d | Swaps: %d" % [comparison_counter, swap_counter]

func _show_complete_popup() -> void:
	if complete_popup:
		var txt = "Sorting Finished!\n\nTotal Comparisons: %d\nTotal Swaps: %d" % [comparison_counter, swap_counter]
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
#  CODE GENERATION & TUTORIAL (QUICK SORT STRINGS)
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
		"cpp": code = get_cpp_quick_code(arr_str)
		"python": code = get_python_quick_code(arr_str)
		"java": code = get_java_quick_code(arr_str)
		"c": code = get_c_quick_code(arr_str)
	
	# UPDATED: Use RichTextLabel
	if cpp_label:
		cpp_label.text = code
	
	cpp_popup.popup_centered()
	
	if current_code_language == "cpp":
		cpp_tutorial_step = 0
		if cpp_next_btn:
			if not cpp_next_btn.is_connected("pressed", _on_cpp_next_pressed):
				cpp_next_btn.pressed.connect(_on_cpp_next_pressed)
		_update_cpp_tutorial()

func _on_cpp_next_pressed() -> void:
	btn_sound.play()
	cpp_tutorial_step += 1
	if cpp_tutorial_step >= cpp_tutorial_data.size():
		cpp_tutorial_step = 0
	_update_cpp_tutorial()

func _update_cpp_tutorial() -> void:
	if cpp_tutorial_data.is_empty(): return
	var data = cpp_tutorial_data[cpp_tutorial_step]
	cpp_explanation_lbl.bbcode_enabled = true
	cpp_explanation_lbl.text = data["text"]
	
	var code = ""
	var arr_str = ", ".join(main_array.map(func(x): return str(x)))
	match current_code_language:
		"cpp": code = get_cpp_quick_code(arr_str)
		"python": code = get_python_quick_code(arr_str)
		"java": code = get_java_quick_code(arr_str)
		"c": code = get_c_quick_code(arr_str)
	
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
	if cpp_scroll and indices.size() > 0:
		cpp_scroll.scroll_vertical = indices[0] * 20

# --- QUICK SORT CODE STRINGS ---

func get_cpp_quick_code(arr: String) -> String:
	return """#include <iostream>
using namespace std;

/*
 * COMPLEXITY:
 * Time: O(n log n) (Avg), O(n^2) (Worst)
 * Space: O(log n) (Stack)
 */
void swap(int* a, int* b) {
	int t = *a; *a = *b; *b = t;
}

int partition(int arr[], int low, int high) {
	int pivot = arr[high];
	int i = (low - 1);
	for (int j = low; j <= high - 1; j++) {
		if (arr[j] < pivot) {
			i++;
			swap(&arr[i], &arr[j]);
		}
	}
	swap(&arr[i + 1], &arr[high]);
	return (i + 1);
}

void quickSort(int arr[], int low, int high) {
	if (low < high) {
		int pi = partition(arr, low, high);
		quickSort(arr, low, pi - 1);
		quickSort(arr, pi + 1, high);
	}
}

int main() {
	int arr[] = { %s };
	int n = sizeof(arr) / sizeof(arr[0]);
	quickSort(arr, 0, n - 1);
	return 0;
}""" % arr

func get_python_quick_code(arr: String) -> String:
	return """# Time: O(n log n) | Space: O(log n)
def partition(arr, low, high):
	pivot = arr[high]
	i = low - 1
	for j in range(low, high):
		if arr[j] < pivot:
			i += 1
			arr[i], arr[j] = arr[j], arr[i]
	arr[i + 1], arr[high] = arr[high], arr[i + 1]
	return i + 1

def quick_sort(arr, low, high):
	if low < high:
		pi = partition(arr, low, high)
		quick_sort(arr, low, pi - 1)
		quick_sort(arr, pi + 1, high)

arr = [%s]
quick_sort(arr, 0, len(arr) - 1)""" % arr

func get_java_quick_code(arr: String) -> String:
	return """// Time: O(n log n) | Space: O(log n)
class QuickSort {
	int partition(int arr[], int low, int high) {
		int pivot = arr[high];
		int i = (low-1);
		for (int j=low; j<high; j++) {
			if (arr[j] < pivot) {
				i++;
				int temp = arr[i];
				arr[i] = arr[j];
				arr[j] = temp;
			}
		}
		int temp = arr[i+1];
		arr[i+1] = arr[high];
		arr[high] = temp;
		return i+1;
	}
	void sort(int arr[], int low, int high) {
		if (low < high) {
			int pi = partition(arr, low, high);
			sort(arr, low, pi-1);
			sort(arr, pi+1, high);
		}
	}
	public static void main(String args[]) {
		int arr[] = {%s};
		new QuickSort().sort(arr, 0, arr.length-1);
	}
}""" % arr

func get_c_quick_code(arr: String) -> String:
	return """#include <stdio.h>
// Time: O(n log n) | Space: O(log n)
void swap(int* a, int* b) {
	int t = *a; *a = *b; *b = t;
}
int partition(int arr[], int low, int high) {
	int pivot = arr[high];
	int i = (low - 1);
	for (int j = low; j <= high - 1; j++) {
		if (arr[j] < pivot) {
			i++;
			swap(&arr[i], &arr[j]);
		}
	}
	swap(&arr[i + 1], &arr[high]);
	return (i + 1);
}
void quickSort(int arr[], int low, int high) {
	if (low < high) {
		int pi = partition(arr, low, high);
		quickSort(arr, low, pi - 1);
		quickSort(arr, pi + 1, high);
	}
}
int main() {
	int arr[] = {%s};
	int n = sizeof(arr)/sizeof(arr[0]);
	quickSort(arr, 0, n - 1);
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
	grid.add_theme_constant_override("h_separation", 35)
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
			"text": "Executes one comparison or pivot selection.",
			"action": "highlight"
		},
		{
			"node": auto_btn,
			"title": "AUTO SORT",
			"text": "Starts/Pauses the automatic quick sort.",
			"action": "highlight"
		},
		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View a scrollable history of pivots and swaps.",
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
