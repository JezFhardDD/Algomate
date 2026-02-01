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
@onready var waiting_label: Label = $WaitingPopup/ScrollContainer/VBoxContainer/Label

@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: Label = $TimelinePopup/ScrollContainer/VBoxContainer/Label

@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var process_label: Label = $SimulationCompletePopup/VBoxContainer/ProcessLabel

# --- CODE POPUP REFERENCES ---
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_text: TextEdit = get_node_or_null("CppPopup/VBoxContainer/TextEdit") as TextEdit
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
const NODE_SCENE := preload("res://GraphNode.tscn") 

# GRAPH LAYOUT SETTINGS
var node_positions = []
var tree_nodes = [] 

# --- 3. STATE VARIABLES ---
var log_history: Array[String] = []      

# DIJKSTRA Variables
var priority_queue: Array = [] 
var visited: Array[int] = [] 
var distances: Dictionary = {} 
var adjacency: Dictionary = {} 

var target_node: int = 6 # Default to Node 6 (G)
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
	print("--- Dijkstra Visualizer Started ---")
	
	if queue_container:
		queue_container.position = Vector2(0, 0)
	
	randomize()
	_init_simulation() # Generates positions AND structure
	
	if enqueue_btn: enqueue_btn.text = "BUILD GRAPH"
	if dequeue_btn: dequeue_btn.text = "DIJKSTRA STEP" 
	if waiting_btn: waiting_btn.text = "PRIORITY QUEUE"
	
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
func _define_random_positions():
	node_positions.clear()
	
	# Center X = 700 is roughly the middle of the empty space on the right
	var center_x = 700
	var start_y = 100
	
	# Define a "Base" layout but add random jitter every time
	# Layer 0 (Top)
	node_positions.append(Vector2(center_x, start_y) + _jitter())
	
	# Layer 1 (Middle)
	node_positions.append(Vector2(center_x - 180, start_y + 150) + _jitter())
	node_positions.append(Vector2(center_x + 180, start_y + 150) + _jitter())
	
	# Layer 2 (Lower Middle)
	node_positions.append(Vector2(center_x - 180, start_y + 300) + _jitter())
	node_positions.append(Vector2(center_x + 180, start_y + 300) + _jitter())
	
	# Layer 3 (Bottom)
	node_positions.append(Vector2(center_x - 90, start_y + 450) + _jitter())
	node_positions.append(Vector2(center_x + 90, start_y + 450) + _jitter())

func _jitter() -> Vector2:
	# Adds randomness to position
	return Vector2(randf_range(-40, 40), randf_range(-20, 20))

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
	config_modal.hide()
	_init_simulation()

func _show_detailed_config():
	size_input_detailed.min_value = 6
	size_input_detailed.max_value = 6
	size_input_detailed.value = 6 
	size_input_detailed.editable = false 
	_gen_random_config()
	config_size_elements_modal.show()

func _on_size_spinbox_changed(new_val: float) -> void:
	_gen_random_config()

func _gen_random_config():
	elements_input.text = "Graph Nodes 0-6"

func _on_config_confirm():
	config_size_elements_modal.hide()
	_init_simulation()

func _on_config_cancel(): config_size_elements_modal.hide(); config_modal.show()

# --- GRAPH GENERATION LOGIC ---
func _init_simulation():
	if audio_player: audio_player.play()
	
	# 1. Randomize Positions First
	_define_random_positions()
	
	tree_nodes.clear()
	priority_queue.clear()
	visited.clear()
	distances.clear()
	adjacency.clear() 
	
	# 2. Build Adjacency (7 Nodes: 0-6)
	for i in range(7): adjacency[i] = {}
	
	# Skeleton (Guarantees Graph is connected)
	_add_edge(0, 1, randi_range(2, 8))
	_add_edge(0, 2, randi_range(2, 8))
	_add_edge(1, 3, randi_range(5, 12))
	_add_edge(2, 4, randi_range(5, 12))
	_add_edge(3, 5, randi_range(2, 8))
	_add_edge(4, 6, randi_range(2, 8))
	_add_edge(5, 6, randi_range(1, 5))
	
	# Random Extra Connections (To make structure variable)
	if randf() > 0.3: _add_edge(1, 2, randi_range(1, 10))
	if randf() > 0.3: _add_edge(3, 4, randi_range(1, 10))
	if randf() > 0.5: _add_edge(1, 4, randi_range(5, 15))
	if randf() > 0.5: _add_edge(2, 3, randi_range(5, 15))
	
	found_target = false
	is_searching = false
	current_action_text = "New Random Graph Generated."
	
	for child in queue_container.get_children():
		child.queue_free()
	
	# 3. Spawn Visuals
	for i in range(node_positions.size()):
		var node = NODE_SCENE.instantiate()
		queue_container.add_child(node)
		
		# Center node using offset relative to its size
		node.position = node_positions[i] - (Vector2(40, 40) / 2) 
		
		# Set Initial Text
		var letter = char(65 + i) # A, B, C...
		if node.has_method("set_value"):
			node.set_value("%s\nINF" % letter)
			
		if node.has_method("reset_color"):
			node.reset_color()
			
		tree_nodes.append(node)
		distances[i] = 9999 # Infinity

	queue_redraw()
	
	if cpp_code_button: cpp_code_button.hide()
	_update_ui()
	enqueue_btn.disabled = true

func _add_edge(u, v, w):
	adjacency[u][v] = w
	adjacency[v][u] = w

func _update_node_visual(idx):
	var dist = distances[idx]
	var letter = char(65 + idx)
	var txt = "INF"
	if dist != 9999: txt = str(dist)
	
	if tree_nodes[idx].has_method("set_value"):
		tree_nodes[idx].set_value("%s\n%s" % [letter, txt])

# --- DRAWING WEIGHTED EDGES ---
func _draw():
	if tree_nodes.is_empty(): return
	
	var drawn_edges = []
	
	for u in adjacency.keys():
		for v in adjacency[u].keys():
			if [min(u,v), max(u,v)] in drawn_edges: continue
			
			if u < tree_nodes.size() and v < tree_nodes.size():
				var node_u = tree_nodes[u]
				var node_v = tree_nodes[v]
				
				# Get centered positions
				var start_pos = node_u.position + (Vector2(40,40)/2)
				var end_pos = node_v.position + (Vector2(40,40)/2)
				var weight = adjacency[u][v]
				
				# Line
				draw_line(start_pos, end_pos, Color.WHITE, 4.0)
				
				# Weight Text
				var mid = (start_pos + end_pos) / 2
				draw_circle(mid, 15, Color(0,0,0))
				draw_string(ThemeDB.fallback_font, mid + Vector2(-5, 5), str(weight), HORIZONTAL_ALIGNMENT_CENTER, -1, 16, Color.YELLOW)
				
				drawn_edges.append([min(u,v), max(u,v)])
	
	queue_redraw()

# --- 7. DIJKSTRA SEARCH LOGIC ---

func _on_add_element_pressed():
	pass

func _on_search_step_pressed():
	if tree_nodes.is_empty(): return
	
	if not is_searching:
		if search_modal:
			search_modal.popup_centered()
		else:
			target_node = 6 # Default to last node
			_start_search_process()
		return
	
	btn_sound.play()
	_execute_dijkstra_step()

func _on_target_confirmed():
	btn_sound.play()
	if target_spinbox:
		target_node = int(target_spinbox.value)
	else:
		target_node = 6
	_start_search_process()

func _start_search_process():
	is_searching = true
	priority_queue.clear()
	visited.clear()
	found_target = false
	
	# Start at Source (0)
	distances[0] = 0
	priority_queue.append([0, 0]) # [Node, Dist]
	
	_update_node_visual(0)
	
	log_history.append("--- Dijkstra Started ---")
	log_history.append("Target: Node %s" % char(65+target_node))
	current_action_text = "Start Node A dist=0."
	
	_update_ui()

func _execute_dijkstra_step():
	if priority_queue.is_empty():
		current_action_text = "PQ empty. Pathfinding finished."
		_finish_simulation(false)
		return

	# Sort PQ
	priority_queue.sort_custom(func(a, b): return a[1] < b[1])
	
	# Pop smallest
	var current_data = priority_queue.pop_front()
	var u = current_data[0]
	var dist_u = current_data[1]
	
	if dist_u > distances[u]:
		_execute_dijkstra_step() 
		return
		
	var u_node = tree_nodes[u]
	visited.append(u)
	if u_node.has_method("mark_visited"): u_node.mark_visited()
	
	current_action_text = "Visiting %s (Dist: %d)" % [char(65+u), dist_u]
	log_history.append("Visit %s" % char(65+u))
	
	if u == target_node:
		if u_node.has_method("mark_found"): u_node.mark_found()
		current_action_text = "Target %s Reached! Min Dist: %d" % [char(65+u), dist_u]
		log_history.append("Target Reached!")
		found_target = true
		_update_ui()
		_finish_simulation(true)
		return

	# Neighbors
	var neighbors = adjacency.get(u, {})
	for v in neighbors.keys():
		var weight = neighbors[v]
		var new_dist = dist_u + weight
		
		if new_dist < distances[v]:
			distances[v] = new_dist
			priority_queue.append([v, new_dist])
			
			_update_node_visual(v)
			if tree_nodes[v].has_method("mark_processing"): tree_nodes[v].mark_processing()
			
			log_history.append("Relax %s: New Dist %d" % [char(65+v), new_dist])

	_update_ui()

func _finish_simulation(found: bool):
	var msg = ""
	if found:
		msg = "Target Reached!\nShortest Distance: %d" % distances[target_node]
	else:
		msg = "Target Unreachable."
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
	enqueue_label.text = "Dijkstra Visualizer"
	dequeue_label.text = "%s" % [current_action_text]
	
	var q_str = ""
	var temp_pq = priority_queue.duplicate()
	temp_pq.sort_custom(func(a, b): return a[1] < b[1])
	
	for item in temp_pq:
		q_str += "[%s:%d] " % [char(65+item[0]), item[1]]
			
	if q_str == "":
		waiting_btn.text = "PQ: [Empty]"
	else:
		waiting_btn.text = "PQ: " + q_str

func _on_waiting_pressed():
	waiting_label.text = "Priority Queue (Node, Dist):\n" + waiting_btn.text
	waiting_popup.popup_centered()

func _on_timeline_pressed():
	timeline_label.text = "Log:\n" + "\n".join(log_history)
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
	match current_language:
		"C++":
			code = """#include <iostream>
#include <vector>
#include <queue>
using namespace std;

#define INF 9999

void dijkstra(int start, int n, vector<vector<pair<int, int>>>& adj) {
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<>> pq;
    vector<int> dist(n, INF);

    pq.push({0, start});
    dist[start] = 0;

    while (!pq.empty()) {
        int u = pq.top().second;
        pq.pop();

        for (auto x : adj[u]) {
            int v = x.first;
            int weight = x.second;

            if (dist[v] > dist[u] + weight) {
                dist[v] = dist[u] + weight;
                pq.push({dist[v], v});
            }
        }
    }
}
"""
			cpp_tutorial_steps = [
				{ "lines": Vector2i(9, 11), "text": "1. Init Priority Queue and Distance array (INF)." },
				{ "lines": Vector2i(15, 17), "text": "2. Loop: Extract minimum distance node." },
				{ "lines": Vector2i(19, 21), "text": "3. Iterate through neighbors." },
				{ "lines": Vector2i(23, 26), "text": "4. Relaxation: If shorter path found, update dist and push to PQ." }
			]

		"Python":
			code = """import heapq

def dijkstra(start, n, adj):
    pq = [(0, start)]
    dist = [float('inf')] * n
    dist[start] = 0

    while pq:
        d, u = heapq.heappop(pq)

        if d > dist[u]: continue

        for v, weight in adj[u]:
            if dist[u] + weight < dist[v]:
                dist[v] = dist[u] + weight
                heapq.heappush(pq, (dist[v], v))
"""
			cpp_tutorial_steps = [
				{ "lines": Vector2i(4, 6), "text": "1. Init Min-Heap and distances." },
				{ "lines": Vector2i(8, 9), "text": "2. Pop node with smallest distance." },
				{ "lines": Vector2i(13, 16), "text": "3. Relaxation: Check neighbors and update distance if shorter." }
			]

		"Java":
			code = """import java.util.*;

class Dijkstra {
    public void shortestPath(int start, int n, List<List<Node>> adj) {
        PriorityQueue<Node> pq = new PriorityQueue<>(n, new Node());
        int dist[] = new int[n];
        Arrays.fill(dist, Integer.MAX_VALUE);

        pq.add(new Node(start, 0));
        dist[start] = 0;

        while (pq.size() > 0) {
            int u = pq.poll().node;

            for (Node neighbor : adj.get(u)) {
                if (dist[u] + neighbor.cost < dist[neighbor.node]) {
                    dist[neighbor.node] = dist[u] + neighbor.cost;
                    pq.add(new Node(neighbor.node, dist[neighbor.node]));
                }
            }
        }
    }
}"""
			cpp_tutorial_steps = [
				{ "lines": Vector2i(5, 7), "text": "1. Setup PriorityQueue and Distance array." },
				{ "lines": Vector2i(12, 13), "text": "2. Poll the node with min distance." },
				{ "lines": Vector2i(16, 19), "text": "3. Relax edges: Update neighbor distances." }
			]

		"C":
			code = """// C implementation requires manual Min-Heap or scanning.
// Simplified logic:

void dijkstra(int start) {
    dist[start] = 0;
    
    for (int count = 0; count < V - 1; count++) {
        int u = minDistance(dist, visited);
        visited[u] = true;

        for (int v = 0; v < V; v++)
            if (!visited[v] && graph[u][v] && 
                dist[u] + graph[u][v] < dist[v]) {
                dist[v] = dist[u] + graph[u][v];
            }
    }
}"""
			cpp_tutorial_steps = [
				{ "lines": Vector2i(7, 8), "text": "1. Find unvisited node with min distance." },
				{ "lines": Vector2i(11, 14), "text": "2. Update dist of neighbors (Relaxation)." }
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
		{ "node": null, "text": "DIJKSTRA'S ALGORITHM:\nFinds the shortest path in a weighted graph.", "action": "next" },
		{ "node": dequeue_btn, "text": "STEP: Process the node with the smallest distance.", "action": "next" },
		{ "node": waiting_btn, "text": "PRIORITY QUEUE:\nStores nodes ordered by current shortest distance.", "action": "next" },
		{ "node": simulate_new_btn, "text": "RESET: Generates a NEW weighted graph with RANDOM weights.", "action": "end" }
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
