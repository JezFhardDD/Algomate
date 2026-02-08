extends Control

# =======================================================
#  BUBBLE SORT SIMULATION - FULL (Slow + Pointer + Intro)
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

# --- TIMELINE POPUP (With Close Button) ---
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

# --- C++ POPUP NODES ---
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_text: TextEdit = get_node_or_null("CppPopup/VBoxContainer/TextEdit") as TextEdit
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/close") as Button

# Code Walkthrough Nodes
@onready var cpp_next_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CppNextButton")
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_lbl: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")

# Top Right Button
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")
@onready var code_anim: AnimatedSprite2D = get_node_or_null("CppCodeButton/code_anim")

# --- SCENE RESOURCES ---
const BLOCK_SCENE := preload("res://BubbleBlock.tscn")
const POINTER_TEX := preload("res://assets/point_left.png")

# --- POINTERS ---
# In Bubble Sort:
# ptr_left -> Points to sort_j
# ptr_right -> Points to sort_j + 1
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

# --- BUBBLE SORT VARIABLES ---
var main_array: Array[int] = []
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []

var sort_i: int = 0
var sort_j: int = 0 
var comparison_counter: int = 0
var swap_counter: int = 0
var sorting_complete: bool = false
var is_sorting: bool = false
var is_auto_playing: bool = false

var BLOCK_WIDTH: float = 64.0 
var BLOCK_SPACING: float = 15.0
var START_POSITION: Vector2 = Vector2(50, 80)
var ANIM_SPEED: float = 1.2 # SLOWER SPEED

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

# Intro Text
var intro_step: int = 0
var intro_texts = [
	"Welcome to Bubble Sort Simulation!\nBubble Sort is a simple algorithm that repeatedly steps through the list, compares adjacent elements, and swaps them if they are in the wrong order.",
	"The Algorithm:\n\n1. Compare the first two elements.\n2. If the left is greater than the right, SWAP them.\n3. Move to the next pair.\n4. Repeat until the largest element 'bubbles' to the end.",
	"Visual Elements:\n\n• The pointers track the two blocks being compared.\n• The blocks will glow when being checked.\n• You can DRAG blocks to rearrange them before sorting!",
	"How to Use:\n\n1. Click 'NEXT STEP' to compare one pair.\n2. Click 'AUTO SORT' to watch the whole process."
]

# Code Tutorial Data (BUBBLE SORT)
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var cpp_tutorial_data = [
	{ "lines": [0, 1, 2, 3], "text": "1. Imports & Setup:\nIncludes libraries for Input/Output." },
	{ "lines": [5, 6, 7], "text": "2. Outer Loop:\nControls the number of passes through the array." },
	{ "lines": [8, 9, 10], "text": "3. Inner Loop:\nCompares adjacent elements. It stops earlier each pass because the largest elements 'bubble' to the end." },
	{ "lines": [11, 12, 13, 14], "text": "4. The Swap:\nIf the left element is larger than the right, they are swapped." },
	{ "lines": [19, 20, 21, 22], "text": "5. Main Function:\nInitializes the array and calls the bubbleSort function." }
]

func _ready() -> void:
	print(" Program started — initializing Bubble Sort visualizer...")
	randomize()
	
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	# Force hide pointers
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if unused_ptr1: unused_ptr1.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	if cpp_code_button: cpp_code_button.hide()
	
	# Rename Buttons
	if sort_btn: sort_btn.text = "Next Step"
	if auto_btn: auto_btn.text = "Auto Sort"
	
	_connect_configuration_buttons()
	_show_config_modal() 
	
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
	
	# Initialize Bubble Sort Vars
	sort_i = 0 
	sort_j = 0 
	
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
		var child = block_nodes[i]
		var target_pos = Vector2(x, START_POSITION.y)
		create_tween().tween_property(child, "position", target_pos, 0.2)
		x += child.size.x + BLOCK_SPACING

# ==============================================
#  BUBBLE SORT LOGIC
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
	var n = main_array.size()
	
	# If fully sorted
	if sort_i >= n - 1:
		if block_nodes.size() > 0 and block_nodes[0].has_method("set_sorted_visual"):
			block_nodes[0].set_sorted_visual()
		_finish_simulation()
		is_sorting = false
		return

	# End of pass check
	if sort_j >= n - 1 - sort_i:
		if block_nodes[n - 1 - sort_i].has_method("set_sorted_visual"):
			block_nodes[n - 1 - sort_i].set_sorted_visual()
		sort_j = 0
		sort_i += 1
		
		# Check if done after incrementing pass
		if sort_i >= n - 1:
			if block_nodes.size() > 0 and block_nodes[0].has_method("set_sorted_visual"):
				block_nodes[0].set_sorted_visual()
			_finish_simulation()
			is_sorting = false
			return

	_update_pointers(sort_j, sort_j + 1)
	
	# Highlight comparison
	if block_nodes[sort_j].has_method("set_highlight"):
		block_nodes[sort_j].set_highlight(true)
	if block_nodes[sort_j + 1].has_method("set_highlight"):
		block_nodes[sort_j + 1].set_highlight(true)
	
	comparison_counter += 1
	var val_a = main_array[sort_j]
	var val_b = main_array[sort_j + 1]
	
	status_label.text = "Comparing: %d vs %d" % [val_a, val_b]
	timeline_log.append("Pass %d: Comparing index [%d] (%d) vs [%d] (%d)" % [sort_i+1, sort_j, val_a, sort_j+1, val_b])
	
	await get_tree().create_timer(ANIM_SPEED * 0.5).timeout
	
	if val_a > val_b:
		# SWAP NEEDED
		swap_counter += 1
		status_label.text = "Swap! %d > %d" % [val_a, val_b]
		timeline_log.append(" -> Swapped %d and %d" % [val_a, val_b])
		
		var temp = main_array[sort_j]
		main_array[sort_j] = main_array[sort_j + 1]
		main_array[sort_j + 1] = temp
		
		var node_a = block_nodes[sort_j]
		var node_b = block_nodes[sort_j + 1]
		
		block_nodes[sort_j] = node_b
		block_nodes[sort_j + 1] = node_a
		
		await _animate_swap(node_a, node_b)
	else:
		status_label.text = "No Swap. %d <= %d" % [val_a, val_b]
		timeline_log.append(" -> In correct order.")
	
	# Unhighlight
	if block_nodes[sort_j].has_method("set_highlight"):
		block_nodes[sort_j].set_highlight(false)
	if block_nodes[sort_j + 1].has_method("set_highlight"):
		block_nodes[sort_j + 1].set_highlight(false)
		
	sort_j += 1 
	
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
	
	if left_idx < block_nodes.size():
		var node = block_nodes[left_idx]
		if ptr_left:
			ptr_left.global_position = node.global_position + Vector2(16, node.size.y + 10) 
	
	if right_idx < block_nodes.size():
		var node_next = block_nodes[right_idx]
		if ptr_right:
			ptr_right.global_position = node_next.global_position + Vector2(16, node_next.size.y + 10)

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
		"cpp": code = get_cpp_bubble_code(arr_str)
		"python": code = get_python_bubble_code(arr_str)
		"java": code = get_java_bubble_code(arr_str)
		"c": code = get_c_bubble_code(arr_str)
	cpp_text.text = code
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
	if cpp_explanation_lbl:
		cpp_explanation_lbl.text = data["text"]
	if cpp_text:
		cpp_text.remove_theme_color_override("font_color")
		cpp_text.add_theme_color_override("font_color", Color.WHITE)
		if data["lines"].size() > 0:
			var start_line = data["lines"][0]
			var end_line = data["lines"][-1]
			cpp_text.select(start_line, 0, end_line + 1, 0)
			cpp_text.scroll_vertical = start_line

# --- BUBBLE SORT CODE STRINGS ---

func get_cpp_bubble_code(arr: String) -> String:
	return """#include <iostream>
using namespace std;

void bubbleSort(int arr[], int n) {
	for (int i = 0; i < n - 1; i++) {
		for (int j = 0; j < n - i - 1; j++) {
			if (arr[j] > arr[j + 1]) {
				int temp = arr[j];
				arr[j] = arr[j + 1];
				arr[j + 1] = temp;
			}
		}
	}
}

int main() {
	int arr[] = { %s };
	int n = sizeof(arr) / sizeof(arr[0]);
	bubbleSort(arr, n);
	return 0;
}""" % arr

func get_python_bubble_code(arr: String) -> String:
	return """def bubble_sort(arr):
	n = len(arr)
	for i in range(n):
		for j in range(0, n - i - 1):
			if arr[j] > arr[j + 1]:
				arr[j], arr[j + 1] = arr[j + 1], arr[j]

arr = [%s]
bubble_sort(arr)
print("Sorted:", arr)""" % arr

func get_java_bubble_code(arr: String) -> String:
	return """class BubbleSort {
	void sort(int arr[]) {
		int n = arr.length;
		for (int i = 0; i < n - 1; i++)
			for (int j = 0; j < n - i - 1; j++)
				if (arr[j] > arr[j + 1]) {
					int temp = arr[j];
					arr[j] = arr[j + 1];
					arr[j + 1] = temp;
				}
	}
	public static void main(String args[]) {
		int arr[] = {%s};
		BubbleSort ob = new BubbleSort();
		ob.sort(arr);
	}
}""" % arr

func get_c_bubble_code(arr: String) -> String:
	return """#include <stdio.h>
void bubbleSort(int arr[], int n) {
	int i, j, temp;
	for (i = 0; i < n - 1; i++)
		for (j = 0; j < n - i - 1; j++)
			if (arr[j] > arr[j + 1]) {
				temp = arr[j];
				arr[j] = arr[j + 1];
				arr[j + 1] = temp;
			}
}
int main() {
	int arr[] = {%s};
	bubbleSort(arr, sizeof(arr)/sizeof(arr[0]));
	return 0;
}""" % arr

# ==============================================
#  TUTORIAL (Main)
# ==============================================

func start_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	tutorial_overlay.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{
			"node": sort_btn,
			"title": "NEXT STEP",
			"text": "Executes one comparison. It checks the two highlighted blocks and swaps them if they are in the wrong order.",
			"action": "highlight"
		},
		{
			"node": auto_btn,
			"title": "AUTO SORT",
			"text": "Starts/Pauses the automatic bubble sort.",
			"action": "highlight"
		},
		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View a scrollable history of comparisons and swaps.",
			"action": "highlight"
		},
		{
			"node": simulate_new_btn,
			"title": "SIMULATE NEW",
			"text": "Resets the simulation to enter new numbers.",
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
	element_inputs.clear()
	for child in elements_container.get_children(): child.queue_free()
	var grid = GridContainer.new()
	grid.columns = 5
	elements_container.add_child(grid)
	var count = int(size_input.value)
	for i in range(count):
		var le = LineEdit.new()
		le.placeholder_text = str(randi_range(1, 99))
		element_inputs.append(le)
		grid.add_child(le)
	config_elements_modal.show()

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
#  INTRO LOGIC
# ==============================================

func show_introduction():
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
