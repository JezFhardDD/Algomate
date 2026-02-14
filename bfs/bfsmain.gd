extends Control

# =======================================================
#   BFS SIMULATION - FINAL (Restored Initial Inputs + Click Edit)
# =======================================================

# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton
@onready var auto_btn: Button = $VBoxContainer/WaitingElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var compare_label: Label = $HBoxContainer2/Label

# --- CONTAINER FIX ---
@onready var array_container: Control = $TreeContainer
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

# --- C++ POPUP NODES ---
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
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
const BLOCK_SCENE := preload("res://TreeNode.tscn")
const POINTER_TEX := preload("res://assets/point_left.png")

# --- POINTERS (Hidden for Tree) ---
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

# --- BFS VARIABLES ---
var main_array: Array[int] = []
var tree_nodes: Array = [] # Stores Node Instances (or null)
var timeline_log: Array[String] = []
var node_positions: Array = []

# BFS State
var bfs_queue: Array[int] = [] # Queue of INDICES
var visited: Array[int] = []
var target_value: int = -1
var search_found: bool = false
var is_searching: bool = false

var comparison_counter: int = 0
var sorting_complete: bool = false
var is_sorting: bool = false
var is_auto_playing: bool = false
var ANIM_SPEED: float = 1.0 

# --- INPUT DIALOGS ---
var target_input_dialog: ConfirmationDialog
var target_spinbox: SpinBox

# New: Dialog for editing nodes
var node_input_dialog: ConfirmationDialog
var node_spinbox: SpinBox
var current_editing_index: int = -1

# Tutorial Vars
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

# --- INTRO TEXT ---
var intro_step: int = 0
var intro_texts = [
	"Welcome to BFS Tree Search!\nBreadth-First Search (BFS) explores a tree layer by layer.",
	"INSTRUCTIONS:\n\n1. SETUP: Enter the Tree Size.\n2. INPUT: Type initial numbers or leave blank.\n3. EDIT: Click on any node to change it later.",
	"The Algorithm:\n\n1. Start at the Root.\n2. Check if it matches the Target.\n3. Add its children to a Queue.\n4. Dequeue and repeat.",
	"Visual Elements:\n\n• The QUEUE stores nodes waiting to be checked.\n• Orange nodes are being processed.\n• Green node means TARGET FOUND."
]

# Code Tutorial Data (BFS)
var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0
var cpp_tutorial_data = [
	{ "lines": [0, 1, 2, 3], "text": "1. Imports & Setup:\nIncludes standard Queue library." },
	{ "lines": [5, 6, 7], "text": "2. Initialization:\nCreate a Queue and push the starting node (root)." },
	{ "lines": [9, 10, 11], "text": "3. The Loop:\nWhile the queue is not empty, get the front element and pop it." },
	{ "lines": [13, 14, 15], "text": "4. Check Target:\nIf the current node's value matches the target, return TRUE." },
	{ "lines": [17, 18, 19], "text": "5. Enqueue Children:\nAdd the Left and Right children to the back of the queue for later processing." }
]

func _ready() -> void:
	print(" Program started — initializing BFS visualizer...")
	randomize()
	
	_define_tree_positions()
	
	# --- FIX: FORCE CONTAINERS TO IGNORE MOUSE ---
	if dequeued_container: dequeued_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if array_container: array_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tex_rect = get_node_or_null("TextureRect")
	if tex_rect: tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if unused_ptr1: unused_ptr1.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	if cpp_code_button: cpp_code_button.hide()
	
	if sort_btn: sort_btn.text = "Find Element"
	if auto_btn: auto_btn.text = "BFS STEP"
	
	_create_target_input_dialog() 
	_create_node_input_dialog() 
	
	_connect_configuration_buttons()
	_show_config_modal() 
	
	if size_input:
		size_input.min_value = 5
		size_input.max_value = 7
		size_input.value = 5 
	
	call_deferred("show_introduction")
	
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")
	
	_connect_language_buttons()

# --- CREATE DIALOGS ---
func _create_target_input_dialog():
	target_input_dialog = ConfirmationDialog.new()
	target_input_dialog.title = "Find Element"
	target_input_dialog.min_size = Vector2(300, 150)
	var vbox = VBoxContainer.new()
	target_input_dialog.add_child(vbox)
	var lbl = Label.new()
	lbl.text = "Enter value to search:"
	vbox.add_child(lbl)
	target_spinbox = SpinBox.new()
	target_spinbox.min_value = 0
	target_spinbox.max_value = 100
	target_spinbox.value = 0
	target_spinbox.custom_minimum_size = Vector2(0, 40)
	vbox.add_child(target_spinbox)
	add_child(target_input_dialog)
	target_input_dialog.confirmed.connect(_on_target_confirmed)

func _create_node_input_dialog():
	node_input_dialog = ConfirmationDialog.new()
	node_input_dialog.title = "Edit Node Value"
	node_input_dialog.min_size = Vector2(300, 150)
	var vbox = VBoxContainer.new()
	node_input_dialog.add_child(vbox)
	var lbl = Label.new()
	lbl.text = "Enter value for this node (0 = Empty):"
	vbox.add_child(lbl)
	node_spinbox = SpinBox.new()
	node_spinbox.min_value = 0
	node_spinbox.max_value = 999
	node_spinbox.value = 0
	node_spinbox.custom_minimum_size = Vector2(0, 40)
	vbox.add_child(node_spinbox)
	add_child(node_input_dialog)
	node_input_dialog.confirmed.connect(_on_node_value_confirmed)

func _on_target_confirmed():
	btn_sound.play()
	var new_target = int(target_spinbox.value)
	_reset_search_for_new_target(new_target)

func _on_node_value_confirmed():
	btn_sound.play()
	if current_editing_index != -1 and current_editing_index < main_array.size():
		var val = int(node_spinbox.value)
		main_array[current_editing_index] = val
		
		# Update Visuals
		var node = tree_nodes[current_editing_index]
		if node:
			if val != 0:
				node.set_value(val)
				node.modulate = Color(1, 1, 1, 1) 
			else:
				node.set_value(0)
				node.modulate = Color(0.5, 0.5, 0.5, 0.5)
		
		if current_editing_index == 0 and val != 0:
			if node.has_method("mark_processing"):
				node.mark_processing()
				
		status_label.text = "Node %d set to %d." % [current_editing_index, val]

# --- RESET LOGIC ---
func _reset_search_for_new_target(new_val: int):
	target_value = new_val
	status_label.text = "Target: %d" % target_value
	compare_label.text = "Queue: [Root]"
	
	bfs_queue.clear()
	bfs_queue.append(0)
	visited.clear()
	timeline_log.clear()
	timeline_log.append("New Search Started. Target: " + str(target_value))
	
	sorting_complete = false
	is_sorting = false
	is_auto_playing = false
	auto_btn.disabled = false
	auto_btn.text = "BFS STEP"
	sort_btn.disabled = false
	
	for i in range(tree_nodes.size()):
		if tree_nodes[i] != null:
			tree_nodes[i].reset_color()
			tree_nodes[i].scale = Vector2(1, 1)
			
	if tree_nodes[0] != null and main_array[0] != 0:
		tree_nodes[0].mark_processing()

func _connect_language_buttons():
	if cpp_lang_btn: cpp_lang_btn.pressed.connect(func(): _set_language("cpp"))
	if python_lang_btn: python_lang_btn.pressed.connect(func(): _set_language("python"))
	if java_lang_btn: java_lang_btn.pressed.connect(func(): _set_language("java"))
	if c_lang_btn: c_lang_btn.pressed.connect(func(): _set_language("c"))

func _set_language(lang: String):
	btn_sound.play()
	current_code_language = lang
	_show_cpp_popup()

# --- TREE LAYOUT LOGIC ---
func _define_tree_positions():
	node_positions.clear()
	var screen_width = 1152.0
	var ui_offset = 280.0
	var available_width = screen_width - ui_offset
	var start_y = 60       
	var layer_height = 140 
	
	for i in range(7):
		var layer = floor(log(i + 1) / log(2))
		var nodes_in_this_layer = pow(2, layer)
		var index_in_layer = (i + 1) - nodes_in_this_layer
		var slice_width = available_width / (nodes_in_this_layer + 1)
		var pos_x = ui_offset + (slice_width * (index_in_layer + 1))
		pos_x -= 32 
		var pos_y = start_y + (layer * layer_height)
		node_positions.append(Vector2(pos_x, pos_y))

# ==============================================
#   INITIALIZATION
# ==============================================

func _initialize_with_elements(elements: Array[int]) -> void:
	print(" Initializing Tree with:", elements)
	audio_player.play()
	
	main_array = elements.duplicate()
	if main_array.size() > 7: main_array.resize(7)
	
	tree_nodes.clear()
	tree_nodes.resize(7)
	tree_nodes.fill(null)
	
	timeline_log.clear()
	
	bfs_queue.clear()
	visited.clear()
	is_searching = false
	search_found = false
	comparison_counter = 0
	sorting_complete = false
	
	target_value = 0 
	status_label.text = "Click Nodes to Add Numbers!"
	compare_label.text = "Queue: [Root]"
	
	for child in array_container.get_children():
		child.queue_free()
	
	for i in range(7):
		if i < elements.size():
			var node = BLOCK_SCENE.instantiate()
			array_container.add_child(node)
			node.position = node_positions[i]
			
			# --- INVISIBLE BUTTON OVERLAY ---
			var click_btn = Button.new()
			click_btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			click_btn.modulate.a = 0.0 # Invisible
			click_btn.mouse_filter = Control.MOUSE_FILTER_STOP
			click_btn.pressed.connect(_handle_node_click.bind(i))
			node.add_child(click_btn)
			
			node.custom_minimum_size = Vector2(64, 64)
			node.size = Vector2(64, 64)
			
			if node.has_method("set_value"):
				if main_array[i] != 0:
					node.set_value(main_array[i])
					node.modulate = Color(1, 1, 1, 1)
				else:
					node.set_value(0) 
					node.modulate = Color(0.5, 0.5, 0.5, 0.5) 
			
			tree_nodes[i] = node
		else:
			tree_nodes[i] = null
			
	queue_redraw()
	
	bfs_queue.append(0)
	if tree_nodes[0] != null and main_array[0] != 0:
		if tree_nodes[0].has_method("mark_processing"):
			tree_nodes[0].mark_processing()
	
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

	if cpp_code_button: cpp_code_button.hide()

# --- HANDLE NODE CLICKS ---
func _handle_node_click(index: int):
	if is_sorting or sorting_complete:
		status_label.text = "Reset Simulation to edit nodes!"
		return

	# Validation
	if index > 0:
		var parent_idx = (index - 1) / 2
		var parent_val = main_array[parent_idx]
		if parent_val == 0:
			status_label.text = "⚠ Parent is empty! Fill parent node first."
			return
	
	current_editing_index = index
	node_spinbox.value = main_array[index]
	node_input_dialog.popup_centered()

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

func _draw():
	if tree_nodes.is_empty(): return
	var center_offset = Vector2(32, 32)
	var my_global_pos = get_global_position()
	
	for i in range(tree_nodes.size()):
		var current_node = tree_nodes[i]
		if current_node == null: continue
		var start_pos = (current_node.global_position + center_offset) - my_global_pos
		var left = 2*i + 1
		var right = 2*i + 2
		
		if left < 7 and tree_nodes[left] != null:
			var left_node = tree_nodes[left]
			var end_pos = (left_node.global_position + center_offset) - my_global_pos
			draw_line(start_pos, end_pos, Color.WHITE, 4.0)
			
		if right < 7 and tree_nodes[right] != null:
			var right_node = tree_nodes[right]
			var end_pos = (right_node.global_position + center_offset) - my_global_pos
			draw_line(start_pos, end_pos, Color.WHITE, 4.0)

# ==============================================
#   BFS LOGIC
# ==============================================

func _on_step_pressed() -> void:
	btn_sound.play()
	target_input_dialog.popup_centered()

func _on_auto_pressed() -> void:
	if sorting_complete: return
	btn_sound.play()
	_perform_bfs_step()

func _perform_bfs_step():
	is_sorting = true
	
	if bfs_queue.is_empty():
		status_label.text = "Queue Empty. Not Found."
		_finish_simulation(false)
		is_sorting = false
		return

	var curr_idx = bfs_queue.pop_front()
	
	if tree_nodes[curr_idx] == null or main_array[curr_idx] == 0:
		is_sorting = false
		_perform_bfs_step() 
		return

	var node = tree_nodes[curr_idx]
	var val = main_array[curr_idx]
	
	var tw = create_tween()
	tw.tween_property(node, "scale", Vector2(1.2, 1.2), 0.1)
	tw.tween_property(node, "scale", Vector2(1.0, 1.0), 0.1)
	
	status_label.text = "Checking Node %d (Val: %d)" % [curr_idx, val]
	timeline_log.append("Dequeued %d (Val: %d)" % [curr_idx, val])
	
	await get_tree().create_timer(ANIM_SPEED * 0.5).timeout
	
	if val == target_value:
		if node.has_method("mark_found"): node.mark_found()
		status_label.text = "TARGET FOUND!"
		timeline_log.append("-> FOUND MATCH!")
		_finish_simulation(true)
	else:
		if node.has_method("mark_visited"): node.mark_visited()
		
		var left = 2*curr_idx + 1
		var right = 2*curr_idx + 2
		var added = ""
		
		if left < 7 and tree_nodes[left] != null and main_array[left] != 0:
			bfs_queue.append(left)
			if tree_nodes[left].has_method("mark_processing"): tree_nodes[left].mark_processing()
			added += "L "
			
		if right < 7 and tree_nodes[right] != null and main_array[right] != 0:
			bfs_queue.append(right)
			if tree_nodes[right].has_method("mark_processing"): tree_nodes[right].mark_processing()
			added += "R "
			
		if added != "": timeline_log.append("Enqueued: " + added)
	
	var q_str = ""
	for i in bfs_queue: q_str += str(main_array[i]) + " "
	compare_label.text = "Queue: [ " + q_str + "]"
	
	is_sorting = false

func _finish_simulation(found: bool):
	sorting_complete = true
	is_auto_playing = false
	auto_btn.text = "BFS STEP"
	auto_btn.disabled = true
	sort_btn.disabled = false
	
	var txt = "Target Found!" if found else "Target Not Found."
	process_label.text = txt
	complete_popup.popup_centered()
	if cpp_code_button: cpp_code_button.show()
	if code_anim: code_anim.play("default")

# ==============================================
#   UI & POPUPS
# ==============================================

func _show_complete_popup() -> void:
	complete_popup.popup_centered()

func _on_timeline_pressed() -> void:
	btn_sound.play()
	if timeline_popup.visible:
		timeline_popup.hide()
	else:
		timeline_label.text = "Log:\n" + "\n".join(timeline_log)
		timeline_popup.popup_centered()

func _on_timeline_close_pressed() -> void:
	btn_sound.play()
	timeline_popup.hide()

# ==============================================
#   CODE GENERATION & TUTORIAL (BFS)
# ==============================================

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

func _show_cpp_popup() -> void:
	var code = ""
	var arr_str = ""
	for i in range(7):
		if tree_nodes.size() > i and tree_nodes[i] != null:
			arr_str += str(main_array[i]) + ","
		else:
			arr_str += "-1,"
	
	var current_size = main_array.size()

	match current_code_language:
		"cpp": code = get_cpp_bfs_code(arr_str, current_size, target_value)
		"python": code = get_python_bfs_code(arr_str, target_value)
		"java": code = get_java_bfs_code(arr_str, current_size, target_value)
		"c": code = get_c_bfs_code(arr_str, current_size, target_value)
	
	if cpp_label: cpp_label.text = code
	cpp_popup.popup_centered()
	
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
	
	if cpp_label:
		var arr_str = ""
		for i in range(7):
			if tree_nodes.size() > i and tree_nodes[i] != null:
				arr_str += str(main_array[i]) + ","
			else:
				arr_str += "-1,"
		
		var current_size = main_array.size()
		var code = ""
		match current_code_language:
			"cpp": code = get_cpp_bfs_code(arr_str, current_size, target_value)
			"python": code = get_python_bfs_code(arr_str, target_value)
			"java": code = get_java_bfs_code(arr_str, current_size, target_value)
			"c": code = get_c_bfs_code(arr_str, current_size, target_value)
			
		var lines = code.split("\n")
		var highlighted = ""
		var indices = data["lines"]
		for i in range(lines.size()):
			if i in indices:
				highlighted += "[color=yellow]" + lines[i] + "[/color]\n"
			else:
				highlighted += lines[i] + "\n"
		
		cpp_label.text = highlighted
		if cpp_scroll and indices.size() > 0:
			cpp_scroll.scroll_vertical = indices[0] * 25

# --- BFS CODE STRINGS ---

func get_cpp_bfs_code(arr: String, size: int, target: int) -> String:
	return """#include <iostream>
#include <queue>
using namespace std;

bool BFS(int tree[], int size, int target) {
	queue<int> q;
	q.push(0); // Start at root
	
	while(!q.empty()) {
		int curr = q.front();
		q.pop();
		
		if(curr >= size || tree[curr] == -1) continue;
		
		if(tree[curr] == target) return true;
		
		// Enqueue Left then Right
		q.push(2 * curr + 1);
		q.push(2 * curr + 2);
	}
	return false;
}

int main() {
	int tree[] = { %s };
	int target = %d;
	if (BFS(tree, %d, target)) cout << "Found";
	return 0;
}""" % [arr, target, size]

func get_python_bfs_code(arr: String, target: int) -> String:
	return """from collections import deque

def bfs(tree, target):
	q = deque([0]) # Index 0
	
	while q:
		curr = q.popleft()
		
		if curr >= len(tree) or tree[curr] == -1:
			continue
			
		if tree[curr] == target:
			return True
		
		q.append(2 * curr + 1)
		q.append(2 * curr + 2)
	return False

tree = [%s]
target = %d
print(bfs(tree, target))""" % [arr, target]

func get_java_bfs_code(arr: String, size: int, target: int) -> String:
	return """import java.util.LinkedList;
import java.util.Queue;

class BFS {
	static boolean bfs(int[] tree, int target) {
		Queue<Integer> q = new LinkedList<>();
		q.add(0);
		
		while(!q.isEmpty()) {
			int curr = q.poll();
			
			if(curr >= tree.length || tree[curr] == -1) continue;
			if(tree[curr] == target) return true;
			
			q.add(2 * curr + 1);
			q.add(2 * curr + 2);
		}
		return false;
	}
	public static void main(String[] args) {
		int[] tree = {%s};
		int target = %d;
		System.out.println(bfs(tree, target));
	}
}""" % [arr, target]

func get_c_bfs_code(arr: String, size: int, target: int) -> String:
	return """#include <stdio.h>
int queue[100];
int front=0, rear=0;
void enqueue(int v) { queue[rear++] = v; }
int dequeue() { return queue[front++]; }

int bfs(int tree[], int size, int target) {
	enqueue(0);
	while(front < rear) {
		int curr = dequeue();
		if(curr >= size || tree[curr] == -1) continue;
		if(tree[curr] == target) return 1;
		enqueue(2*curr+1);
		enqueue(2*curr+2);
	}
	return 0;
}
int main() {
	int tree[] = {%s};
	int target = %d;
	printf(bfs(tree, %d, target) ? "Found" : "Not Found");
}""" % [arr, target, size]

# ==============================================
#   CONFIG HANDLERS & INTRO
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

# --- RESTORED: Show Input Menu after Size ---
func _on_size_next_pressed() -> void:
	btn_sound.play()
	config_size_modal.hide()
	_show_config_elements_modal()

# --- RESTORED: Input Menu Logic ---
func _show_config_elements_modal() -> void:
	element_inputs.clear()
	for child in elements_container.get_children(): child.queue_free()
	var grid = GridContainer.new()
	grid.columns = 5
	elements_container.add_child(grid)
	
	var count = int(size_input.value) 
	
	for i in range(count):
		var le = LineEdit.new()
		le.placeholder_text = "0"
		# Default empty so users can choose
		le.text = "" 
		element_inputs.append(le)
		grid.add_child(le)
		
		# Validation for the initial menu inputs too
		le.text_changed.connect(_validate_tree_inputs)
	
	_validate_tree_inputs("")
	config_elements_modal.show()

# --- RESTORED: Validation for Input Menu ---
func _validate_tree_inputs(_ignored_text: String):
	for i in range(element_inputs.size()):
		if i == 0: 
			element_inputs[i].editable = true
			continue
			
		var parent_idx = (i - 1) / 2
		if parent_idx >= 0 and parent_idx < element_inputs.size():
			var parent_le = element_inputs[parent_idx]
			if parent_le.text.strip_edges().is_empty() or parent_le.text == "0":
				element_inputs[i].editable = false
				element_inputs[i].text = ""
				element_inputs[i].placeholder_text = "Locked"
			else:
				element_inputs[i].editable = true
				element_inputs[i].placeholder_text = "0"

# --- RESTORED: Gather Inputs ---
func _on_elements_done_pressed() -> void:
	btn_sound.play()
	var arr: Array[int] = []
	for le in element_inputs:
		if le.text.strip_edges().is_empty():
			arr.append(0)
		elif le.text.is_valid_int():
			arr.append(int(le.text))
		else:
			arr.append(0)
			
	config_elements_modal.hide()
	_set_main_ui_enabled(true)
	_initialize_with_elements(arr)

func _on_config_no_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	var count = 7
	var arr: Array[int] = []
	for i in count: arr.append(randi_range(1, 99))
	_set_main_ui_enabled(true)
	_initialize_with_elements(arr)

func _on_size_back_pressed(): config_size_modal.hide(); config_modal.show()
func _on_elements_back_pressed(): config_elements_modal.hide(); config_size_modal.show()

# ==============================================
#   INTRO LOGIC & TUTORIAL
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
			"node": array_container, # Points to tree area
			"title": "TREE EDITOR",
			"text": "Click on any node to change its number.\nREMEMBER: You must set the parent node first!",
			"action": "highlight"
		},
		{
			"node": sort_btn,
			"title": "FIND ELEMENT",
			"text": "Opens a popup to choose which number to search for.",
			"action": "highlight"
		},
		{
			"node": auto_btn,
			"title": "BFS STEP",
			"text": "Executes exactly one step of the Breadth-First Search.",
			"action": "highlight"
		},
		{
			"node": timeline_btn,
			"title": "TIMELINE",
			"text": "View search logs.",
			"action": "highlight"
		},
		{
			"node": simulate_new_btn,
			"title": "SIMULATE NEW",
			"text": "Generates a new Random Tree.",
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
		if node is Button: node.disabled = false
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

# --- HELPER UTILS ---

func _set_main_ui_enabled(enabled: bool) -> void:
	if sort_btn: sort_btn.disabled = not enabled
	if auto_btn: auto_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled
	if simulate_new_btn: simulate_new_btn.disabled = not enabled

func _on_cpp_close_pressed(): btn_sound.play(); cpp_popup.hide()
func _on_cpp_code_button_pressed(): btn_sound.play(); _show_cpp_popup()
func _on_complete_ok_pressed(): btn_sound.play(); complete_popup.hide()
func _on_simulate_new_pressed(): sim_confirmation.show()
func _on_yes_pressed():
	sim_confirmation.hide()
	sim_success.show()
	await get_tree().create_timer(1.0).timeout
	sim_success.hide()
	_show_config_modal()
func _on_no_pressed(): sim_confirmation.hide()
func _on_help_button_pressed(): start_tutorial()
