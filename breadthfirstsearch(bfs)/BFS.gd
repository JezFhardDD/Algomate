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

# --- CODE POPUP REFERENCES ---
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_text: TextEdit = get_node_or_null("CppPopup/VBoxContainer/TextEdit") as TextEdit

# FIX: Use "close" to match scene
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
@onready var current_icon: Node = $TextureRect/front 
@onready var unused_icon: Node = $TextureRect/rear
@onready var audio_player = $bgm
@onready var btn_sound = $btn_sound

# --- 2. CONFIGURATION ---
const NODE_SCENE := preload("res://TreeNode.tscn")

# TREE LAYOUT SETTINGS
var node_positions = []
var tree_nodes = [] # Now holds 'null' for missing nodes

# --- 3. STATE VARIABLES ---
var tree_data: Array[int] = []          
var log_history: Array[String] = []      

# BFS Variables (Changed from Stack to Queue)
var bfs_queue: Array[int] = []   # Stores Indices (FIFO)
var visited: Array[int] = []     # Stores Indices
var target_value: int = -1
var is_searching: bool = false
var found_target: bool = false
var current_action_text: String = ""

# Tutorial & Code View
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false
var cpp_tutorial_index := 0
var cpp_tutorial_steps := []
var current_language: String = "C++" 

# --- 4. INITIALIZATION ---
func _ready() -> void:
	print("--- BFS Visualizer Started ---")
	
	if queue_container:
		queue_container.position = Vector2(0, 0)
	
	randomize()
	_define_tree_positions()
	
	if enqueue_btn: enqueue_btn.text = "BUILD RANDOM TREE"
	if dequeue_btn: dequeue_btn.text = "BFS STEP" 
	if waiting_btn: waiting_btn.text = "QUEUE" # Changed from Stack
	
	var old_history_btn = get_node_or_null("VBoxContainer/DequeuedElements")
	if old_history_btn: old_history_btn.hide()
	
	_hide_pointers()
	_connect_signals()
	_ready_tutorial_connection()
	
	call_deferred("_setup_language_buttons")
	
	config_modal.hide()
	if config_size_elements_modal: config_size_elements_modal.hide()
	_show_config_modal()

# --- DYNAMIC POSITIONING LOGIC ---
func _define_tree_positions():
	node_positions.clear()
	
	# TREE SETTINGS
	var start_y = 80        
	var layer_height = 140 
	var tree_area_width = 800 
	var offset_x = 350    
	
	# Generate positions for 7 nodes
	for i in range(7):
		var layer = floor(log(i + 1) / log(2))
		var index_in_layer = (i + 1) - pow(2, layer)
		var nodes_in_this_layer = pow(2, layer)
		var slice = tree_area_width / (nodes_in_this_layer + 1)
		
		var pos_x = offset_x + (slice * (index_in_layer + 1)) - 50 
		var pos_y = start_y + (layer * layer_height)
		
		node_positions.append(Vector2(pos_x, pos_y))

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
		size_input_detailed.value_changed.connect(_on_size_spinbox_changed)
	
	if search_modal:
		if not search_modal.is_connected("confirmed", _on_target_confirmed):
			search_modal.confirmed.connect(_on_target_confirmed)
	
	if complete_ok_btn: complete_ok_btn.pressed.connect(func(): complete_popup.hide())
	if show_cpp_btn: show_cpp_btn.pressed.connect(_show_code_popup)
	if cpp_code_button: cpp_code_button.pressed.connect(_show_code_popup)
	
	if cpp_close_btn: 
		if not cpp_close_btn.is_connected("pressed", _on_close_code_popup):
			cpp_close_btn.pressed.connect(_on_close_code_popup)
	
	if cpp_next_button:
		if not cpp_next_button.is_connected("pressed", _on_cpp_next_button_pressed):
			cpp_next_button.pressed.connect(_on_cpp_next_button_pressed)

func _on_close_code_popup():
	cpp_popup.hide()

# --- 5. SETUP LANGUAGE BUTTONS ---
func _setup_language_buttons():
	if not cpp_popup: return
	var vbox = cpp_popup.get_node_or_null("VBoxContainer")
	if not vbox: return
	if vbox.has_node("LanguageContainer"): return
	
	var lang_hbox = HBoxContainer.new()
	lang_hbox.name = "LanguageContainer"
	lang_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	
	var languages = ["C++", "Python", "Java", "C"]
	for lang in languages:
		var btn = Button.new()
		btn.text = lang
		btn.custom_minimum_size = Vector2(80, 30)
		btn.pressed.connect(func(): _switch_language(lang))
		lang_hbox.add_child(btn)
	
	vbox.add_child(lang_hbox)
	vbox.move_child(lang_hbox, 0) 

func _switch_language(lang: String):
	btn_sound.play()
	current_language = lang
	_update_code_text()
	cpp_tutorial_index = 0
	if cpp_tutorial_panel: 
		cpp_tutorial_panel.show()
	show_cpp_explanation()

# --- 6. CONFIGURATION ---
func _show_config_modal(): config_modal.show()
func _on_config_yes(): config_modal.hide(); _show_detailed_config()

func _on_config_no(): 
	var rnd: Array[int] = [] 
	for i in range(7): 
		rnd.append(randi_range(1, 99))
	config_modal.hide()
	_init_simulation(rnd)

func _show_detailed_config():
	size_input_detailed.min_value = 7
	size_input_detailed.max_value = 7
	size_input_detailed.value = 7 
	size_input_detailed.editable = false 
	_gen_random_config()
	config_size_elements_modal.show()

func _on_size_spinbox_changed(new_val: float) -> void:
	_gen_random_config()

func _gen_random_config():
	var arr = []
	for i in range(7): arr.append(str(randi_range(1,99)))
	elements_input.text = ", ".join(arr)

func _on_config_confirm():
	var txt = elements_input.text.split(",")
	var arr: Array[int] = []
	for t in txt: 
		if t.strip_edges().is_valid_int(): 
			arr.append(int(t.strip_edges()))
	
	while arr.size() < 7: arr.append(randi_range(1, 99))
	if arr.size() > 7: arr.resize(7)
	
	config_size_elements_modal.hide()
	_init_simulation(arr)

func _on_config_cancel(): config_size_elements_modal.hide(); config_modal.show()

# --- RANDOM TREE GENERATION LOGIC ---
func _init_simulation(data: Array[int]):
	if audio_player: audio_player.play()
	
	tree_data = data
	tree_nodes.clear()
	# Resize to 7, filling with null initially
	tree_nodes.resize(7)
	tree_nodes.fill(null)
	
	bfs_queue.clear()
	visited.clear()
	found_target = false
	is_searching = false
	current_action_text = "Random Tree Built. Ready to Search."
	
	for child in queue_container.get_children():
		child.queue_free()
	
	# 1. Determine which nodes exist (Random Connectivity)
	# Root (0) always exists
	var active_indices = [0]
	
	# Loop through layers to grow tree
	for i in range(3): # Check indices 0, 1, 2
		if i in active_indices:
			# Coin flip for Left Child (70% chance)
			if randf() > 0.3:
				active_indices.append(2 * i + 1)
			
			# Coin flip for Right Child (70% chance)
			if randf() > 0.3:
				active_indices.append(2 * i + 2)

	# 2. Spawn Visuals only for active indices
	for i in range(7):
		if i in active_indices:
			var node = NODE_SCENE.instantiate()
			queue_container.add_child(node)
			node.position = node_positions[i]
			
			if node.has_method("set_value"):
				node.set_value(tree_data[i])
			
			tree_nodes[i] = node # Place node in specific slot
		else:
			tree_nodes[i] = null # Explicitly null

	queue_redraw()
	
	if cpp_code_button: cpp_code_button.hide()
	_update_ui()
	enqueue_btn.disabled = true

# --- DRAWING LINES ---
func _draw():
	if tree_nodes.is_empty(): return
	
	for i in range(tree_nodes.size()):
		var current_node = tree_nodes[i]
		if current_node == null: continue
		
		var start_pos = current_node.global_position - global_position + (current_node.size / 2.0)
		var left_child_idx = 2 * i + 1
		var right_child_idx = 2 * i + 2
		
		if left_child_idx < tree_nodes.size() and tree_nodes[left_child_idx] != null:
			var left_node = tree_nodes[left_child_idx]
			var end_pos = left_node.global_position - global_position + (left_node.size / 2.0)
			draw_line(start_pos, end_pos, Color.WHITE, 4.0)
		
		if right_child_idx < tree_nodes.size() and tree_nodes[right_child_idx] != null:
			var right_node = tree_nodes[right_child_idx]
			var end_pos = right_node.global_position - global_position + (right_node.size / 2.0)
			draw_line(start_pos, end_pos, Color.WHITE, 4.0)
	
	queue_redraw()

# --- 7. BFS SEARCH LOGIC ---

func _on_add_element_pressed():
	pass

func _on_search_step_pressed():
	if tree_nodes.is_empty() or tree_nodes[0] == null: return
	
	if not is_searching:
		if search_modal:
			search_modal.popup_centered()
		else:
			var valid_values = []
			for i in range(7):
				if tree_nodes[i] != null: valid_values.append(tree_data[i])
			
			if valid_values.is_empty(): target_value = 0
			else: target_value = valid_values.pick_random()
			
			_start_search_process()
		return
	
	btn_sound.play()
	_execute_bfs_step()

func _on_target_confirmed():
	btn_sound.play()
	if target_spinbox:
		target_value = int(target_spinbox.value)
	else:
		target_value = 0
	_start_search_process()

func _start_search_process():
	is_searching = true
	bfs_queue.clear()
	visited.clear()
	found_target = false
	
	# Start at Root (Index 0)
	bfs_queue.append(0)
	
	log_history.append("--- BFS Started ---")
	log_history.append("Looking for: %d" % target_value)
	current_action_text = "Target: %d. Enqueued Root (0)." % target_value
	
	_update_ui()
	
	if tree_nodes[0] != null and tree_nodes[0].has_method("mark_processing"):
		tree_nodes[0].mark_processing()

func _execute_bfs_step():
	if bfs_queue.is_empty():
		current_action_text = "Queue empty. Search finished."
		_finish_simulation(false)
		return

	# DEQUEUE (First In, First Out)
	var current_idx = bfs_queue.pop_front()
	
	if tree_nodes[current_idx] == null:
		_execute_bfs_step() # Skip invalid nodes
		return

	var current_node = tree_nodes[current_idx]
	var val = tree_data[current_idx]
	
	visited.append(current_idx)
	
	# ANIMATION
	var tw = create_tween()
	tw.tween_property(current_node, "scale", Vector2(1.2, 1.2), 0.1)
	tw.tween_property(current_node, "scale", Vector2(1.0, 1.0), 0.1)
	
	# CHECK MATCH
	if val == target_value:
		if current_node.has_method("mark_found"): current_node.mark_found()
		current_action_text = "Dequeued Node %d. Found match %d!" % [current_idx, val]
		log_history.append("Checked %d: MATCH FOUND!" % val)
		found_target = true
		_update_ui()
		_finish_simulation(true)
		return
	else:
		if current_node.has_method("mark_visited"): current_node.mark_visited()
		current_action_text = "Dequeued %d. Not match. Checking neighbors..." % val
		log_history.append("Checked %d. Not match." % val)

	# ADD CHILDREN TO QUEUE
	var left_idx = 2 * current_idx + 1
	var right_idx = 2 * current_idx + 2
	
	var added_str = ""
	
	# Add Left Child
	if left_idx < 7 and tree_nodes[left_idx] != null:
		bfs_queue.append(left_idx)
		if tree_nodes[left_idx].has_method("mark_processing"): tree_nodes[left_idx].mark_processing()
		added_str = "Left Child"
		
	# Add Right Child
	if right_idx < 7 and tree_nodes[right_idx] != null:
		bfs_queue.append(right_idx)
		if tree_nodes[right_idx].has_method("mark_processing"): tree_nodes[right_idx].mark_processing()
		if added_str != "": added_str = "Children"
		else: added_str = "Right Child"
		
	if added_str != "":
		log_history.append("Enqueuing %s." % added_str)
	else:
		log_history.append("No children. Moving to next in queue.")

	_update_ui()
	
	if bfs_queue.is_empty() and not found_target:
		_finish_simulation(false)

func _finish_simulation(found: bool):
	var msg = ""
	if found:
		msg = "Target %d Found!" % target_value
	else:
		msg = "Target %d Not Found (Tree Exhausted)." % target_value
	process_label.text = msg
	complete_popup.popup_centered()
	if cpp_code_button: cpp_code_button.show()

func _update_pointers():
	pass 

func _hide_pointers():
	if current_icon: current_icon.hide()
	if unused_icon: unused_icon.hide()

func _on_reset_pressed():
	btn_sound.play()
	_on_config_no() 

# --- HELPER FUNCTIONS ---
func _update_ui():
	enqueue_label.text = "BFS Visualization"
	dequeue_label.text = "%s" % [current_action_text]
	
	var q_vals = []
	for idx in bfs_queue: 
		if tree_nodes[idx] != null:
			q_vals.append(tree_data[idx])
			
	if q_vals.is_empty():
		waiting_btn.text = "Queue: [Empty]"
	else:
		waiting_btn.text = "Queue: " + str(q_vals)

func _on_waiting_pressed():
	var vals = []
	for x in bfs_queue:
		if tree_nodes[x] != null: vals.append(tree_data[x])
	
	waiting_label.text = "Current Queue (Indices):\n" + str(bfs_queue) + "\n\nQueue (Values):\n" + str(vals)
	waiting_popup.popup_centered()

func _on_timeline_pressed():
	timeline_label.text = "Traversal Log:\n" + "\n".join(log_history)
	timeline_popup.popup_centered()

func _on_cpp_next_button_pressed() -> void:
	btn_sound.play()
	cpp_tutorial_index += 1
	show_cpp_explanation()

# --- 8. MULTI-LANGUAGE CODE GENERATION ---
func _show_code_popup():
	complete_popup.hide()
	current_language = "C++" 
	_update_code_text()
	cpp_popup.popup_centered()
	cpp_tutorial_index = 0
	if cpp_tutorial_panel: cpp_tutorial_panel.show()
	show_cpp_explanation()

func _update_code_text():
	var code = ""
	var valid_data_str = ""
	for i in range(7):
		if tree_nodes[i] != null: valid_data_str += str(tree_data[i]) + ", "
		else: valid_data_str += "-1, "
	
	match current_language:
		"C++":
			code = """#include <iostream>
#include <queue>
using namespace std;

// BFS Function
bool BFS(int start_index, int target, int tree[], int size) {
    queue<int> q;
    q.push(start_index);
    
    while(!q.empty()) {
        int curr = q.front();
        q.pop();
        
        if (curr >= size || tree[curr] == -1) continue;
        
        if (tree[curr] == target) return true;
        
        // Add Children (Left then Right)
        q.push(2 * curr + 1);
        q.push(2 * curr + 2);
    }
    return false;
}

int main() {
    int tree[] = { %s };
    int target = %d;
    
    if (BFS(0, target, tree, 7)) cout << "Found!";
    else cout << "Not Found";
}""" % [valid_data_str, target_value]
			
			cpp_tutorial_steps = [
				{ "lines": Vector2i(7, 8), "text": "1. Initialize Queue: Use a standard queue and push the root node." },
				{ "lines": Vector2i(10, 12), "text": "2. Dequeue: Get the front element and remove it for processing." },
				{ "lines": Vector2i(14, 16), "text": "3. Check: If node exists and matches target, return true." },
				{ "lines": Vector2i(19, 20), "text": "4. Enqueue Neighbors: Push Left and Right children to the back of the queue." }
			]

		"Python":
			code = """from collections import deque

def bfs(tree, target):
    q = deque([0]) # Start at index 0
    
    while q:
        curr = q.popleft() # Dequeue
        
        if curr >= len(tree) or tree[curr] == -1:
            continue
            
        if tree[curr] == target:
            return True
            
        # Enqueue children
        q.append(2 * curr + 1)
        q.append(2 * curr + 2)
    
    return False

tree = [%s]
target = %d
print("Found" if bfs(tree, target) else "Not Found")
""" % [valid_data_str, target_value]

			cpp_tutorial_steps = [
				{ "lines": Vector2i(3, 4), "text": "1. Queue: Python uses 'deque' for efficient queues." },
				{ "lines": Vector2i(7, 7), "text": "2. Dequeue: popleft() removes the first element." },
				{ "lines": Vector2i(12, 13), "text": "3. Check: Is this the target?" },
				{ "lines": Vector2i(16, 17), "text": "4. Enqueue: append() adds children to the end." }
			]

		"Java":
			code = """import java.util.LinkedList;
import java.util.Queue;

public class Main {
    public static boolean bfs(int target, int[] tree) {
        Queue<Integer> q = new LinkedList<>();
        q.add(0); // Add root
        
        while (!q.isEmpty()) {
            int curr = q.poll(); // Dequeue
            
            if (curr >= tree.length || tree[curr] == -1) continue;
            
            if (tree[curr] == target) return true;
            
            // Enqueue children
            q.add(2 * curr + 1);
            q.add(2 * curr + 2);
        }
        return false;
    }

    public static void main(String[] args) {
        int[] tree = { %s };
        int target = %d;
        System.out.println(bfs(target, tree) ? "Found" : "Not Found");
    }
}""" % [valid_data_str, target_value]

			cpp_tutorial_steps = [
				{ "lines": Vector2i(6, 7), "text": "1. Queue: Java uses LinkedList as a Queue." },
				{ "lines": Vector2i(10, 10), "text": "2. Poll: Retrieves and removes the head (front) of the queue." },
				{ "lines": Vector2i(14, 14), "text": "3. Process: Check if current node is target." },
				{ "lines": Vector2i(17, 18), "text": "4. Add: Adds children to the tail (end) of the queue." }
			]

		"C":
			code = """#include <stdio.h>
#include <stdbool.h>

// Simple queue for demo
int queue[100];
int front = 0, rear = 0;

void enqueue(int val) { queue[rear++] = val; }
int dequeue() { return queue[front++]; }
bool isEmpty() { return front == rear; }

bool bfs(int target, int tree[], int size) {
    enqueue(0); // Start at root
    
    while (!isEmpty()) {
        int curr = dequeue();
        
        if (curr >= size || tree[curr] == -1) continue;
        
        if (tree[curr] == target) return true;
        
        enqueue(2 * curr + 1);
        enqueue(2 * curr + 2);
    }
    return false;
}

int main() {
    int tree[] = { %s };
    int target = %d;
    if (bfs(target, tree, 7)) printf("Found");
    else printf("Not Found");
    return 0;
}""" % [valid_data_str, target_value]

			cpp_tutorial_steps = [
				{ "lines": Vector2i(8, 10), "text": "1. Queue Implementation: Using an array with front/rear pointers." },
				{ "lines": Vector2i(13, 13), "text": "2. Enqueue: Add root to rear." },
				{ "lines": Vector2i(16, 16), "text": "3. Dequeue: Take from front." },
				{ "lines": Vector2i(22, 23), "text": "4. Add neighbors to rear of queue." }
			]

	cpp_text.text = code
	cpp_tutorial_index = 0
	show_cpp_explanation()

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
	var lines = step["lines"]
	highlight_cpp_lines(lines.x, lines.y)

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

# --- HIGH DEFINITION TUTORIAL UPDATE ---
func start_main_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	tutorial_overlay.show()
	dim_bg.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{ "node": null, "text": "BFS SIMULATION:\nBreadth-First Search (BFS) explores the tree layer by layer (neighbors first).", "action": "next" },
		{ "node": dequeue_btn, "text": "BFS STEP: 'Dequeues' a node from the front to check it.", "action": "next" },
		{ "node": waiting_btn, "text": "THE QUEUE (FIFO):\nFirst-In, First-Out. Nodes are added to the back and removed from the front.", "action": "next" },
		{ "node": simulate_new_btn, "text": "RESET: Generates a NEW random Tree structure.", "action": "end" }
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
