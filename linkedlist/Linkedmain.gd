extends Control

# =======================================================
#    LINKED LIST SIMULATION - FINAL (Custom UI Nodes)
# =======================================================

# --- MAIN BUTTONS ---
@onready var sort_btn: Button = $VBoxContainer/SortButton          
@onready var auto_btn: Button = $VBoxContainer/LinearStep          
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew
@onready var auto_search_btn: Button = get_node_or_null("VBoxContainer/AutoSearchButton")
@onready var help_btn: Button = get_node_or_null("HelpButton")

# --- CUSTOM MENU BUTTONS (Created in Editor) ---
@onready var insert_menu: MenuButton = $VBoxContainer/InsertMenu
@onready var delete_menu: MenuButton = $VBoxContainer/DeleteMenu

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var compare_label: Label = $HBoxContainer2/Label
@onready var array_container: Control = $QueueContainer
@onready var dequeued_container: Control = $DequeuedContainer 

# --- POPUPS ---
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: Label = $TimelinePopup/MainVBox/ScrollContainer/VBoxContainer/Label
@onready var timeline_close_btn: Button = get_node_or_null("TimelinePopup/MainVBox/CloseButton")
@onready var Queue_full: Panel = get_node_or_null("Queue_full")
@onready var anim_sprite: AnimatedSprite2D = get_node_or_null("Queue_full/AnimatedSprite2D")
@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var process_label: Label = get_node_or_null("SimulationCompletePopup/VBoxContainer/ProcessLabel")

# --- C++ POPUP NODES ---
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_scroll: ScrollContainer = get_node_or_null("CppPopup/VBoxContainer/CodeScroll")
@onready var cpp_label: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/CodeScroll/CodeLabel")
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/close") as Button
@onready var cpp_next_btn: Button = get_node_or_null("CppPopup/VBoxContainer/HBoxContainer2/CppNextButton")
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_lbl: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")
@onready var code_anim: AnimatedSprite2D = get_node_or_null("CppCodeButton/code_anim")

# --- SCENE RESOURCES ---
const BLOCK_SCENE := preload("res://LinkedBlock.tscn")
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

# --- LINKED LIST & SEARCH VARIABLES ---
var main_array: Array[int] = []
var initial_elements: Array[int] = []      
var action_history: Array[Dictionary] = [] 
var block_nodes: Array[Control] = []
var timeline_log: Array[String] = []
var visual_links: Array[Line2D] = []

var search_target: int = 0
var current_idx: int = 0
var search_found: bool = false
var comparison_counter: int = 0
var swap_counter: int = 0 
var sorting_complete: bool = false
var is_sorting: bool = false
var is_auto_playing: bool = false

var BLOCK_WIDTH: float = 64.0 
var BLOCK_SPACING: float = 40.0 
var START_POSITION: Vector2 = Vector2(50, 100)
var ANIM_SPEED: float = 1.5 

# --- INPUT DIALOG ELEMENTS ---
var target_input_dialog: ConfirmationDialog
var target_spinbox: SpinBox
var pos_input_dialog: ConfirmationDialog
var pos_spinbox: SpinBox
var val_spinbox: SpinBox
var val_label: Label 
var current_op_type: int = 0 

# --- TUTORIAL VARIABLES ---
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false
var intro_step: int = 0
var intro_texts = [
	"Welcome to Linked List Simulation!\nA Linked List is a linear data structure where elements are not stored in contiguous memory locations. Instead, elements are linked using pointers.",
	"The Pointers:\n\n• HEAD: Points to the first node.\n• TAIL: Points to the last node.\n• NEXT: Arrows linking one node to the next.",
	"Complexity:\n\nTime: [color=yellow]O(N)[/color] for Search, [color=green]O(1)[/color] for Insertion/Deletion at known pointers.\nSpace: [color=yellow]O(N)[/color] for storing N nodes.",
	"Operations available:\n\n• INSERT: Add at Beginning, End, or a specific Position.\n• DELETE: Remove from Beginning, End, or a specific Position.\n• SEARCH: Traverse the list to find a value."
]

var current_code_language: String = "cpp"
var element_inputs: Array[LineEdit] = []
var cpp_tutorial_step: int = 0

# --- TUTORIAL HIGHLIGHTING DATA (RE-MAPPED TO MATCH FULL CODE STRINGS) ---
var tutorial_data_map = {
	"cpp": [
		{ "lines": [0], "text": "1. Complexity: [color=yellow]Time O(N)[/color], [color=yellow]Space O(N)[/color]" },
		{ "lines": [4, 5, 6, 7], "text": "2. Structure:\nA Node contains data and a pointer to the next node." },
		{ "lines": [91, 92, 93], "text": "3. Traversal Loop:\nStart at the head. Loop continues as long as current is not NULL." },
		{ "lines": [94, 95, 96, 97], "text": "4. Checking Value:\nIf current node's data matches target 'value', print result." },
		{ "lines": [98, 99], "text": "5. Moving Forward:\nIf not a match, move current pointer to the NEXT node." }
	],
	"python": [
		{ "lines": [0], "text": "1. Complexity: [color=yellow]Time O(N)[/color], [color=yellow]Space O(N)[/color]" },
		{ "lines": [1, 2, 3, 4], "text": "2. Structure:\nA Node contains data and a reference to the next node." },
		{ "lines": [60, 61, 62], "text": "3. Traversal Loop:\nStart at the head. Loop continues as long as current is not None." },
		{ "lines": [63, 64, 65], "text": "4. Checking Value:\nIf current node's data matches target 'value', print found." },
		{ "lines": [66, 67], "text": "5. Moving Forward:\nIf not a match, move current pointer to the NEXT node." }
	],
	"java": [
		{ "lines": [0], "text": "1. Complexity: [color=yellow]Time O(N)[/color], [color=yellow]Space O(N)[/color]" },
		{ "lines": [1, 2, 3, 4], "text": "2. Structure:\nA Node contains data and a reference to the next node." },
		{ "lines": [85, 86, 87], "text": "3. Traversal Loop:\nStart at the head. Loop continues as long as current is not null." },
		{ "lines": [88, 89, 90, 91], "text": "4. Checking Value:\nIf current node's data matches target 'value', print result." },
		{ "lines": [92, 93], "text": "5. Moving Forward:\nIf not a match, move current pointer to the NEXT node." }
	],
	"c": [
		{ "lines": [0], "text": "1. Complexity: [color=yellow]Time O(N)[/color], [color=yellow]Space O(N)[/color]" },
		{ "lines": [4, 5, 6, 7], "text": "2. Structure:\nA Node contains data and a pointer to the next node." },
		{ "lines": [87, 88, 89], "text": "3. Traversal Loop:\nStart at the head. Loop continues as long as current is not NULL." },
		{ "lines": [90, 91, 92, 93], "text": "4. Checking Value:\nIf current node's data matches target 'value', print result." },
		{ "lines": [94, 95], "text": "5. Moving Forward:\nIf not a match, move current pointer to the NEXT node." }
	]
}

func _ready() -> void:
	print(" Program started — initializing Linked List visualizer...")
	randomize()
	
	_setup_menu_buttons()
	_create_input_dialogs()
	
	if unused_ptr1: unused_ptr1.queue_free()
	if unused_ptr2: unused_ptr2.queue_free()
	
	if size_input:
		size_input.min_value = 1
		size_input.max_value = 6
		size_input.value = clamp(size_input.value, 1, 6)
	
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	
	if cpp_code_button: cpp_code_button.hide()
	
	if sort_btn: sort_btn.text = "Find Element"
	if auto_btn: auto_btn.text = "Search Step"
	if auto_search_btn: auto_search_btn.text = "Auto Search"
	
	_ensure_connected(sort_btn, "pressed", _on_search_pressed)
	_ensure_connected(auto_btn, "pressed", _on_step_pressed)
	if auto_search_btn: _ensure_connected(auto_search_btn, "pressed", _on_auto_search_pressed)
	
	if help_btn: _ensure_connected(help_btn, "pressed", _on_help_button_pressed)
	if tutorial_next: _ensure_connected(tutorial_next, "pressed", _on_next_button_pressed)
	if cpp_next_btn: _ensure_connected(cpp_next_btn, "pressed", _on_cpp_next_pressed)
	
	_connect_configuration_buttons()
	_show_config_modal() 
	
	call_deferred("show_introduction")
	
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")
	_connect_language_buttons()

func _setup_menu_buttons():
	if insert_menu:
		var in_popup = insert_menu.get_popup()
		in_popup.clear()
		in_popup.add_item("Insert at Beginning", 0)
		in_popup.add_item("Insert at End", 1)
		in_popup.add_item("Insert at Position", 2)
		in_popup.id_pressed.connect(_on_insert_selected)
		
	if delete_menu:
		var del_popup = delete_menu.get_popup()
		del_popup.clear()
		del_popup.add_item("Delete at Beginning", 0)
		del_popup.add_item("Delete at End", 1)
		del_popup.add_item("Delete at Position", 2)
		del_popup.id_pressed.connect(_on_delete_selected)

func _create_input_dialogs():
	target_input_dialog = ConfirmationDialog.new()
	var vbox = VBoxContainer.new()
	target_input_dialog.add_child(vbox)
	var lbl = Label.new()
	lbl.text = "Enter value:"
	vbox.add_child(lbl)
	target_spinbox = SpinBox.new()
	target_spinbox.min_value = 0
	target_spinbox.max_value = 999
	vbox.add_child(target_spinbox)
	add_child(target_input_dialog)
	
	pos_input_dialog = ConfirmationDialog.new()
	var pvbox = VBoxContainer.new()
	pos_input_dialog.add_child(pvbox)
	
	var plbl = Label.new()
	plbl.text = "Enter Index (0 is Head):"
	pvbox.add_child(plbl)
	pos_spinbox = SpinBox.new()
	pos_spinbox.min_value = 0
	pos_spinbox.max_value = 999
	pvbox.add_child(pos_spinbox)
	
	val_label = Label.new()
	val_label.text = "Enter Value to Insert:"
	pvbox.add_child(val_label)
	
	val_spinbox = SpinBox.new()
	val_spinbox.min_value = 0
	val_spinbox.max_value = 999
	pvbox.add_child(val_spinbox)
	
	add_child(pos_input_dialog)
	pos_input_dialog.confirmed.connect(_on_pos_dialog_confirmed)

# ==============================================
#   LINKED LIST OPERATIONS
# ==============================================

func _on_insert_selected(id: int):
	btn_sound.play()
	if is_sorting: return
	
	if main_array.size() >= 6:
		status_label.text = "Max size of 6 reached! Cannot insert more."
		if Queue_full:
			Queue_full.show()
			if anim_sprite: anim_sprite.play("default")
			await get_tree().create_timer(2.0).timeout
			Queue_full.hide()
		return
		
	target_input_dialog.title = "Insert Value"
	
	if id == 0: 
		_disconnect_target_signals()
		target_input_dialog.confirmed.connect(_insert_beginning)
		target_input_dialog.popup_centered()
	elif id == 1: 
		_disconnect_target_signals()
		target_input_dialog.confirmed.connect(_insert_end)
		target_input_dialog.popup_centered()
	elif id == 2: 
		current_op_type = 0 
		val_label.show() 
		val_spinbox.show() 
		pos_spinbox.max_value = main_array.size()
		pos_input_dialog.popup_centered()

func _on_delete_selected(id: int):
	btn_sound.play()
	if is_sorting: return
	
	if main_array.is_empty():
		status_label.text = "List is already empty!"
		return
		
	if id == 0: _delete_at(0)
	elif id == 1: _delete_at(main_array.size() - 1)
	elif id == 2: 
		current_op_type = 1 
		val_label.hide() 
		val_spinbox.hide() 
		pos_spinbox.max_value = main_array.size() - 1
		pos_input_dialog.popup_centered()

func _disconnect_target_signals():
	if target_input_dialog.confirmed.is_connected(_on_search_confirmed): target_input_dialog.confirmed.disconnect(_on_search_confirmed)
	if target_input_dialog.confirmed.is_connected(_insert_beginning): target_input_dialog.confirmed.disconnect(_insert_beginning)
	if target_input_dialog.confirmed.is_connected(_insert_end): target_input_dialog.confirmed.disconnect(_insert_end)

func _on_pos_dialog_confirmed():
	var pos = int(pos_spinbox.value)
	if current_op_type == 0:
		var val = int(val_spinbox.value)
		_insert_at(pos, val)
	else:
		_delete_at(pos)

func _insert_beginning(): _insert_at(0, int(target_spinbox.value))
func _insert_end(): _insert_at(main_array.size(), int(target_spinbox.value))

func _insert_at(index: int, val: int):
	if main_array.size() >= 6: return 
	if index < 0 or index > main_array.size(): return
	
	action_history.append({
		"type": "insert",
		"index": index,
		"value": val
	})
	
	main_array.insert(index, val)
	var new_block = BLOCK_SCENE.instantiate()
	new_block.value = val
	new_block.modulate.a = 0.0 
	array_container.add_child(new_block)
	block_nodes.insert(index, new_block)
	
	timeline_log.append("Inserted %d at index %d" % [val, index])
	status_label.text = "Inserted %d into Linked List." % val
	_resnap_blocks()

func _delete_at(index: int):
	if index < 0 or index >= main_array.size(): return
	
	action_history.append({
		"type": "delete",
		"index": index
	})
	
	var val = main_array.pop_at(index)
	var block = block_nodes.pop_at(index)
	
	block.reparent(dequeued_container)
	var tw = create_tween()
	tw.tween_property(block, "modulate:a", 0.0, ANIM_SPEED)
	tw.tween_callback(block.queue_free)
	
	timeline_log.append("Deleted %d from index %d" % [val, index])
	status_label.text = "Deleted %d from Linked List." % val
	_resnap_blocks()

# ==============================================
#   VISUAL UPDATES (POINTERS & LINKS)
# ==============================================

func _resnap_blocks() -> void:
	is_sorting = true
	var x = START_POSITION.x
	
	for i in range(block_nodes.size()):
		var node = block_nodes[i]
		var target_pos = Vector2(x, START_POSITION.y)
		var tw = create_tween()
		tw.tween_property(node, "position", target_pos, ANIM_SPEED)
		if node.modulate.a < 1.0:
			tw.parallel().tween_property(node, "modulate:a", 1.0, ANIM_SPEED)
		
		x += (node.size.x * node.scale.x) + BLOCK_SPACING
	
	await get_tree().create_timer(ANIM_SPEED + 0.1).timeout
	_draw_pointers_and_links()
	is_sorting = false

func _draw_pointers_and_links():
	for line in visual_links: line.queue_free()
	visual_links.clear()
	
	if block_nodes.is_empty():
		if ptr_left: ptr_left.hide()
		if ptr_right: ptr_right.hide()
		return
		
	if ptr_left:
		ptr_left.show()
		ptr_left.global_position = block_nodes[0].global_position + Vector2(16, -40)
		
	if ptr_right:
		ptr_right.show()
		var tail_node = block_nodes[block_nodes.size() - 1]
		ptr_right.global_position = tail_node.global_position + Vector2(16, (tail_node.size.y * tail_node.scale.y) + 10)
	
	for i in range(block_nodes.size() - 1):
		var n1 = block_nodes[i]
		var n2 = block_nodes[i+1]
		var start = n1.global_position + Vector2(n1.size.x * n1.scale.x, (n1.size.y * n1.scale.y) / 2.0)
		var end = n2.global_position + Vector2(0, (n2.size.y * n2.scale.y) / 2.0)
		
		var line = Line2D.new()
		line.width = 4
		line.default_color = Color(0.8, 0.8, 0.2)
		line.add_point(start)
		line.add_point(end)
		add_child(line)
		visual_links.append(line)

# ==============================================
#   INITIALIZATION
# ==============================================

func _initialize_with_elements(elements: Array[int]) -> void:
	print(" Initializing Linked List with:", elements)
	audio_player.play()
	
	main_array = elements.duplicate()
	initial_elements = elements.duplicate() 
	action_history.clear()                 
	
	block_nodes.clear()
	timeline_log.clear()
	
	for child in array_container.get_children(): child.queue_free()
	
	var current_x = START_POSITION.x
	for val in main_array:
		var new_block = BLOCK_SCENE.instantiate()
		new_block.value = val
		new_block.position = Vector2(current_x, START_POSITION.y)
		array_container.add_child(new_block)
		block_nodes.append(new_block)
		current_x += (new_block.size.x * new_block.scale.x) + BLOCK_SPACING
		
	_draw_pointers_and_links()
	
	search_target = 0
	status_label.text = "Linked List Ready. Use Insert, Delete, or Search."
	
	current_idx = 0
	search_found = false
	comparison_counter = 0
	sorting_complete = false
	is_auto_playing = false
	
	_ensure_connected(timeline_btn, "pressed", _on_timeline_pressed)
	_ensure_connected(simulate_new_btn, "pressed", _on_simulate_new_pressed)
	_ensure_connected(complete_ok_btn, "pressed", _on_complete_ok_pressed)
	_ensure_connected(show_cpp_btn, "pressed", _on_show_cpp_pressed)
	_ensure_connected(cpp_code_button, "pressed", _on_cpp_code_button_pressed)
	_ensure_connected(cpp_close_btn, "pressed", _on_cpp_close_pressed)
	if timeline_close_btn: _ensure_connected(timeline_close_btn, "pressed", _on_timeline_close_pressed)
	
	_update_ui_labels()

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

# ==============================================
#   SEARCH TRAVERSAL LOGIC
# ==============================================

func _on_search_pressed() -> void:
	btn_sound.play()
	target_input_dialog.title = "Search Linked List"
	_disconnect_target_signals()
	target_input_dialog.confirmed.connect(_on_search_confirmed)
	target_input_dialog.popup_centered()

func _on_search_confirmed():
	btn_sound.play()
	search_target = int(target_spinbox.value)
	status_label.text = "Searching list for: %d" % search_target
	timeline_log.append("Started Traversal for: %d" % search_target)
	
	action_history.append({
		"type": "search",
		"value": search_target
	})
	
	current_idx = 0
	search_found = false
	comparison_counter = 0
	sorting_complete = false
	is_auto_playing = false
	
	if auto_btn: auto_btn.disabled = false
	if auto_search_btn: 
		auto_search_btn.disabled = false
		auto_search_btn.text = "Auto Search"
	
	for block in block_nodes:
		if block.has_method("set_highlight"): block.set_highlight(false)
		if block.has_method("reset_visuals"): block.reset_visuals()
		block.modulate = Color(1, 1, 1, 1)

func _on_auto_search_pressed() -> void:
	if sorting_complete or main_array.is_empty(): return
	btn_sound.play()
	is_auto_playing = !is_auto_playing
	if auto_search_btn: auto_search_btn.text = "Pause" if is_auto_playing else "Auto Search"
	if auto_btn: auto_btn.disabled = is_auto_playing
	if is_auto_playing: _run_auto_sort()

func _on_step_pressed() -> void:
	if is_sorting or sorting_complete: return
	btn_sound.play()
	_perform_sort_step()

func _run_auto_sort() -> void:
	while is_auto_playing and not sorting_complete:
		if is_sorting: await get_tree().process_frame 
		else:
			await _perform_sort_step()
			await get_tree().create_timer(ANIM_SPEED).timeout

func _perform_sort_step():
	is_sorting = true
	var n = main_array.size()
	
	if current_idx >= n:
		status_label.text = "Finished. Value NOT found in Linked List."
		timeline_log.append("Reached TAIL. %d not found." % search_target)
		_finish_simulation()
		is_sorting = false
		return
	
	if ptr_left: 
		ptr_left.show()
		ptr_left.global_position = block_nodes[current_idx].global_position + Vector2(16, -40)
	
	if block_nodes[current_idx].has_method("set_highlight"):
		block_nodes[current_idx].set_highlight(true)
	
	comparison_counter += 1
	var val = main_array[current_idx]
	status_label.text = "Traversing node %d: %d == %d?" % [current_idx, val, search_target]
	timeline_log.append("Traversing node %d: Value %d" % [current_idx, val])
	
	await get_tree().create_timer(ANIM_SPEED * 0.8).timeout
	
	if val == search_target:
		search_found = true
		status_label.text = "FOUND %d at node index %d!" % [val, current_idx]
		timeline_log.append(" -> FOUND MATCH!")
		if block_nodes[current_idx].has_method("set_sorted_visual"):
			block_nodes[current_idx].set_sorted_visual()
		_finish_simulation()
	else:
		status_label.text = "Not a match. Moving to NEXT pointer."
		if block_nodes[current_idx].has_method("set_highlight"):
			block_nodes[current_idx].set_highlight(false)
		current_idx += 1
	
	_update_ui_labels()
	is_sorting = false

func _finish_simulation():
	sorting_complete = true
	is_auto_playing = false
	
	if auto_btn: auto_btn.disabled = true
	if auto_search_btn: 
		auto_search_btn.text = "Auto Search"
		auto_search_btn.disabled = true
	
	_draw_pointers_and_links() 
	timeline_log.append("--- TRAVERSAL COMPLETE ---")
	_show_complete_popup()

# ==============================================
#   UI & POPUPS
# ==============================================

func _update_ui_labels():
	compare_label.text = "Nodes Checked: %d" % [comparison_counter]

func _show_complete_popup() -> void:
	if complete_popup:
		var result_text = "Found" if search_found else "Not Found"
		var txt = "Traversal Finished!\n\nTarget: %d\nResult: %s\nNodes Checked: %d" % [search_target, result_text, comparison_counter]
		if process_label: process_label.text = txt
		complete_popup.popup_centered()
		cpp_code_button.show()

func _on_timeline_pressed() -> void:
	btn_sound.play()
	if timeline_popup.visible: timeline_popup.hide()
	else:
		timeline_label.text = "Timeline:\n" + "\n".join(timeline_log)
		timeline_popup.popup_centered()

func _on_timeline_close_pressed() -> void:
	btn_sound.play()
	if timeline_popup: timeline_popup.hide()

# ==============================================
#   DYNAMIC CODE GENERATION & WALKTHROUGH
# ==============================================

func _build_action_code(lang: String) -> String:
	var code = ""
	match lang:
		"cpp":
			code += "int main() {\n"
			code += "    LinkedList list;\n"
			code += "    // Initial elements\n"
			for val in initial_elements:
				code += "    list.insertEnd(%d);\n" % val
			
			code += "\n    cout << \"Initial list = \";\n"
			code += "    list.printList();\n\n"
			
			var sim_size = initial_elements.size()
			var step = 1
			
			for action in action_history:
				if action["type"] == "insert":
					if action["index"] == 0:
						code += "    // %d. Insert at beginning = %d\n" % [step, action["value"]]
						code += "    list.insertBeginning(%d);\n" % action["value"]
						code += "    cout << \"After insert %d at beginning = \";\n" % action["value"]
					elif action["index"] == sim_size:
						code += "    // %d. Insert at end = %d\n" % [step, action["value"]]
						code += "    list.insertEnd(%d);\n" % action["value"]
						code += "    cout << \"After insert %d at end = \";\n" % action["value"]
					else:
						code += "    // %d. Insert at index[%d] = %d\n" % [step, action["index"], action["value"]]
						code += "    list.insertAtIndex(%d, %d);\n" % [action["index"], action["value"]]
						code += "    cout << \"After insert %d at index[%d] = \";\n" % [action["value"], action["index"]]
					code += "    list.printList();\n\n"
					sim_size += 1
					step += 1
				elif action["type"] == "delete":
					if action["index"] == 0:
						code += "    // %d. Delete at beginning\n" % step
						code += "    list.deleteBeginning();\n"
						code += "    cout << \"After delete at beginning = \";\n"
					elif action["index"] == sim_size - 1:
						code += "    // %d. Delete at end\n" % step
						code += "    list.deleteEnd();\n"
						code += "    cout << \"After delete at end = \";\n"
					else:
						code += "    // %d. Delete at index[%d]\n" % [step, action["index"]]
						code += "    list.deleteAtIndex(%d);\n" % action["index"]
						code += "    cout << \"After delete at index[%d] = \";\n" % action["index"]
					code += "    list.printList();\n\n"
					sim_size -= 1
					step += 1
				elif action["type"] == "search":
					code += "    // %d. Search element %d\n" % [step, action["value"]]
					code += "    list.linearSearch(%d);\n\n" % action["value"]
					step += 1
			code += "    return 0;\n}"
			
		"c":
			code += "\nint main() {\n"
			code += "    struct Node* head = NULL;\n"
			code += "    // 1. Initial Elements\n"
			for val in initial_elements:
				code += "    insertEnd(&head, %d);\n" % val
			code += "    printf(\"Initial list = \"); printList(head);\n\n"
			var sim_size = initial_elements.size()
			var step = 1
			for action in action_history:
				if action["type"] == "insert":
					if action["index"] == 0:
						code += "    // %d. Insert at beginning\n" % step
						code += "    insertBeginning(&head, %d);\n" % action["value"]
						code += "    printf(\"After insert at beginning = \"); printList(head);\n\n"
					elif action["index"] == sim_size:
						code += "    // %d. Insert at end\n" % step
						code += "    insertEnd(&head, %d);\n" % action["value"]
						code += "    printf(\"After insert at end = \"); printList(head);\n\n"
					else:
						code += "    // %d. Insert at index\n" % step
						code += "    insertAtIndex(&head, %d, %d);\n" % [action["index"], action["value"]]
						code += "    printf(\"After insert at index = \"); printList(head);\n\n"
					sim_size += 1
					step += 1
				elif action["type"] == "delete":
					if action["index"] == 0:
						code += "    // %d. Delete at beginning\n" % step
						code += "    deleteBeginning(&head);\n"
						code += "    printf(\"After delete beginning = \"); printList(head);\n\n"
					elif action["index"] == sim_size - 1:
						code += "    // %d. Delete at end\n" % step
						code += "    deleteEnd(&head);\n"
						code += "    printf(\"After delete end = \"); printList(head);\n\n"
					else:
						code += "    // %d. Delete at index\n" % step
						code += "    deleteAtIndex(&head, %d);\n" % action["index"]
						code += "    printf(\"After delete index = \"); printList(head);\n\n"
					sim_size -= 1
					step += 1
				elif action["type"] == "search":
					code += "    // %d. Search element\n" % step
					code += "    linearSearch(head, %d);\n\n" % action["value"]
					step += 1
			code += "    return 0;\n}"
			
		"python":
			code += "\nif __name__ == '__main__':\n"
			code += "    llist = LinkedList()\n"
			code += "    # 1. Initial Elements\n"
			for val in initial_elements:
				code += "    llist.insert_end(%d)\n" % val
			code += "    print(\"Initial list = \", end=\"\"); llist.print_list()\n\n"
			
			var sim_size = initial_elements.size()
			var step = 1
			for action in action_history:
				if action["type"] == "insert":
					if action["index"] == 0:
						code += "    # %d. Insert at beginning\n" % step
						code += "    llist.insert_beginning(%d)\n" % action["value"]
					elif action["index"] == sim_size:
						code += "    # %d. Insert at end\n" % step
						code += "    llist.insert_end(%d)\n" % action["value"]
					else:
						code += "    # %d. Insert at index\n" % step
						code += "    llist.insert_at_index(%d, %d)\n" % [action["index"], action["value"]]
					code += "    print(\"After insert = \", end=\"\"); llist.print_list()\n\n"
					sim_size += 1
					step += 1
				elif action["type"] == "delete":
					if action["index"] == 0:
						code += "    # %d. Delete at beginning\n" % step
						code += "    llist.delete_beginning()\n"
					elif action["index"] == sim_size - 1:
						code += "    # %d. Delete at end\n" % step
						code += "    llist.delete_end()\n"
					else:
						code += "    # %d. Delete at index\n" % step
						code += "    llist.delete_at_index(%d)\n" % action["index"]
					code += "    print(\"After delete = \", end=\"\"); llist.print_list()\n\n"
					sim_size -= 1
					step += 1
				elif action["type"] == "search":
					code += "    # %d. Search element\n" % step
					code += "    llist.linear_search(%d)\n\n" % action["value"]
					step += 1
					
		"java":
			code += "\n    public static void main(String[] args) {\n"
			code += "        LinkedList list = new LinkedList();\n"
			code += "        // 1. Initial Elements\n"
			for val in initial_elements:
				code += "        list.insertEnd(%d);\n" % val
			code += "        System.out.print(\"Initial list = \"); list.printList();\n\n"
			
			var sim_size = initial_elements.size()
			var step = 1
			for action in action_history:
				if action["type"] == "insert":
					if action["index"] == 0:
						code += "        // %d. Insert at beginning\n" % step
						code += "        list.insertBeginning(%d);\n" % action["value"]
					elif action["index"] == sim_size:
						code += "        // %d. Insert at end\n" % step
						code += "        list.insertEnd(%d);\n" % action["value"]
					else:
						code += "        // %d. Insert at index\n" % step
						code += "        list.insertAtIndex(%d, %d);\n" % [action["index"], action["value"]]
					code += "        System.out.print(\"After insert = \"); list.printList();\n\n"
					sim_size += 1
					step += 1
				elif action["type"] == "delete":
					if action["index"] == 0:
						code += "        // %d. Delete at beginning\n" % step
						code += "        list.deleteBeginning();\n"
					elif action["index"] == sim_size - 1:
						code += "        // %d. Delete at end\n" % step
						code += "        list.deleteEnd();\n"
					else:
						code += "        // %d. Delete at index\n" % step
						code += "        list.deleteAtIndex(%d);\n" % action["index"]
					code += "        System.out.print(\"After delete = \"); list.printList();\n\n"
					sim_size -= 1
					step += 1
				elif action["type"] == "search":
					code += "        // %d. Search element\n" % step
					code += "        list.linearSearch(%d);\n\n" % action["value"]
					step += 1
			code += "    }\n}" 
	return code

func _on_show_cpp_pressed() -> void:
	btn_sound.play()
	if complete_popup: complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

func _show_cpp_popup() -> void:
	cpp_popup.popup_centered()
	cpp_tutorial_step = 0
	
	if cpp_next_btn: cpp_next_btn.show()
	if cpp_tutorial_panel: cpp_tutorial_panel.show()
	
	_update_cpp_tutorial()

func _on_cpp_next_pressed() -> void:
	btn_sound.play()
	cpp_tutorial_step += 1
	var active_tutorial_data = tutorial_data_map[current_code_language]
	if cpp_tutorial_step >= active_tutorial_data.size(): cpp_tutorial_step = 0
	_update_cpp_tutorial()

func _update_cpp_tutorial() -> void:
	var active_tutorial_data = tutorial_data_map[current_code_language]
	if active_tutorial_data.is_empty(): return
	
	var data = active_tutorial_data[cpp_tutorial_step]
	if cpp_explanation_lbl: 
		cpp_explanation_lbl.bbcode_enabled = true
		cpp_explanation_lbl.text = data["text"]
	
	if cpp_label:
		var code = ""
		match current_code_language:
			"cpp": code = get_cpp_code()
			"python": code = get_python_code()
			"java": code = get_java_code()
			"c": code = get_c_code()
			
		var lines = code.split("\n")
		var highlighted_code = ""
		var indices = data["lines"]
		
		for i in range(lines.size()):
			if i in indices: highlighted_code += "[color=yellow]" + lines[i] + "[/color]\n"
			else: highlighted_code += lines[i] + "\n"
		
		cpp_label.bbcode_enabled = true
		cpp_label.text = highlighted_code
		
		if indices.size() > 0: call_deferred("_scroll_to_highlight", indices[0])

func _scroll_to_highlight(line_index: int) -> void:
	var target_scroll = line_index * 26
	if cpp_scroll:
		var tween = create_tween()
		tween.tween_property(cpp_scroll, "scroll_vertical", target_scroll, 0.2).set_trans(Tween.TRANS_SINE)
	elif cpp_label:
		var scrollbar = cpp_label.get_v_scroll_bar()
		if scrollbar:
			var tween = create_tween()
			tween.tween_property(scrollbar, "value", target_scroll, 0.2).set_trans(Tween.TRANS_SINE)

func get_cpp_code() -> String:
	var base_code = """// Complexity: Time O(N), Space O(N)
#include <iostream>
using namespace std;

struct Node {
	int data;
	Node* next;
};

class LinkedList {
private:
	Node* head;

public:
	LinkedList() { head = NULL; }

	void insertEnd(int value) {
		Node* newNode = new Node();
		newNode->data = value;
		newNode->next = NULL;
		if (head == NULL) { head = newNode; return; }
		Node* temp = head;
		while (temp->next != NULL) temp = temp->next;
		temp->next = newNode;
	}

	void insertBeginning(int value) {
		Node* newNode = new Node();
		newNode->data = value;
		newNode->next = head;
		head = newNode;
	}

	void insertAtIndex(int index, int value) {
		if (index == 0) { insertBeginning(value); return; }
		Node* newNode = new Node();
		newNode->data = value;
		Node* temp = head;
		for (int i = 0; i < index - 1; i++) {
			if(temp == NULL) return;
			temp = temp->next;
		}
		newNode->next = temp->next;
		temp->next = newNode;
	}

	void deleteBeginning() {
		if (head == NULL) return;
		Node* temp = head;
		head = head->next;
		delete temp;
	}

	void deleteEnd() {
		if (head == NULL) return;
		if (head->next == NULL) { delete head; head = NULL; return; }
		Node* temp = head;
		while (temp->next->next != NULL) temp = temp->next;
		delete temp->next;
		temp->next = NULL;
	}

	void deleteAtIndex(int index) {
		if (index == 0) { deleteBeginning(); return; }
		Node* temp = head;
		for (int i = 0; i < index - 1; i++) {
			if(temp == NULL) return;
			temp = temp->next;
		}
		if(temp == NULL || temp->next == NULL) return;
		Node* deleteNode = temp->next;
		temp->next = deleteNode->next;
		delete deleteNode;
	}

	void printList() {
		Node* temp = head;
		while (temp != NULL) {
			cout << temp->data;
			if (temp->next != NULL) cout << ",";
			temp = temp->next;
		}
		cout << endl;
	}

	void linearSearch(int value) {
		Node* temp = head;
		int index = 0;
		while (temp != NULL) {
			if (temp->data == value) {
				cout << "Result = found at index " << index << endl;
				return;
			}
			temp = temp->next;
			index++;
		}
		cout << "Result = not found" << endl;
	}
};"""
	return base_code + "\n\n" + _build_action_code("cpp")

func get_python_code() -> String:
	var base_code = """# Complexity: Time O(N), Space O(N)
class Node:
	def __init__(self, data):
		self.data = data
		self.next = None

class LinkedList:
	def __init__(self):
		self.head = None

	def insert_end(self, value):
		new_node = Node(value)
		if self.head is None:
			self.head = new_node
			return
		temp = self.head
		while temp.next is not None:
			temp = temp.next
		temp.next = new_node

	def insert_beginning(self, value):
		new_node = Node(value)
		new_node.next = self.head
		self.head = new_node

	def insert_at_index(self, index, value):
		if index == 0:
			self.insert_beginning(value)
			return
		new_node = Node(value)
		temp = self.head
		for _ in range(index - 1):
			if temp is None: return
			temp = temp.next
		if temp is None: return
		new_node.next = temp.next
		temp.next = new_node

	def delete_beginning(self):
		if self.head is None: return
		self.head = self.head.next

	def delete_end(self):
		if self.head is None: return
		if self.head.next is None:
			self.head = None
			return
		temp = self.head
		while temp.next.next is not None:
			temp = temp.next
		temp.next = None

	def delete_at_index(self, index):
		if index == 0:
			self.delete_beginning()
			return
		temp = self.head
		for _ in range(index - 1):
			if temp is None: return
			temp = temp.next
		if temp is None or temp.next is None: return
		temp.next = temp.next.next

	def print_list(self):
		temp = self.head
		elems = []
		while temp is not None:
			elems.append(str(temp.data))
			temp = temp.next
		print(",".join(elems))

	def linear_search(self, value):
		current = self.head
		index = 0
		while current is not None:
			if current.data == value:
				print(f"Result = found at index {index}")
				return True
			current = current.next
			index += 1
		print("Result = not found")
		return False"""
	return base_code + _build_action_code("python")

func get_java_code() -> String:
	var base_code = """// Complexity: Time O(N), Space O(N)
class Node {
	int data;
	Node next;
}

class LinkedList {
	Node head;

	public void insertEnd(int value) {
		Node newNode = new Node();
		newNode.data = value;
		newNode.next = null;
		if (head == null) { head = newNode; return; }
		Node temp = head;
		while (temp.next != null) temp = temp.next;
		temp.next = newNode;
	}

	public void insertBeginning(int value) {
		Node newNode = new Node();
		newNode.data = value;
		newNode.next = head;
		head = newNode;
	}

	public void insertAtIndex(int index, int value) {
		if (index == 0) { insertBeginning(value); return; }
		Node newNode = new Node();
		newNode.data = value;
		Node temp = head;
		for (int i = 0; i < index - 1; i++) {
			if (temp == null) return;
			temp = temp.next;
		}
		newNode.next = temp.next;
		temp.next = newNode;
	}

	public void deleteBeginning() {
		if (head == null) return;
		head = head.next;
	}

	public void deleteEnd() {
		if (head == null) return;
		if (head.next == null) { head = null; return; }
		Node temp = head;
		while (temp.next.next != null) temp = temp.next;
		temp.next = null;
	}

	public void deleteAtIndex(int index) {
		if (index == 0) { deleteBeginning(); return; }
		Node temp = head;
		for (int i = 0; i < index - 1; i++) {
			if (temp == null) return;
			temp = temp.next;
		}
		if (temp == null || temp.next == null) return;
		temp.next = temp.next.next;
	}

	public void printList() {
		Node temp = head;
		while (temp != null) {
			System.out.print(temp.data);
			if (temp.next != null) System.out.print(",");
			temp = temp.next;
		}
		System.out.println();
	}

	public boolean linearSearch(int value) {
		Node current = head;
		int index = 0;
		while (current != null) {
			if (current.data == value) {
				System.out.println("Result = found at index " + index);
				return true;
			}
			current = current.next;
			index++;
		}
		System.out.println("Result = not found");
		return false;
	}"""
	return base_code + _build_action_code("java")

func get_c_code() -> String:
	var base_code = """// Complexity: Time O(N), Space O(N)
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

struct Node {
	int data;
	struct Node* next;
};

void insertEnd(struct Node** head, int value) {
	struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
	newNode->data = value;
	newNode->next = NULL;
	if (*head == NULL) { *head = newNode; return; }
	struct Node* temp = *head;
	while (temp->next != NULL) temp = temp->next;
	temp->next = newNode;
}

void insertBeginning(struct Node** head, int value) {
	struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
	newNode->data = value;
	newNode->next = *head;
	*head = newNode;
}

void insertAtIndex(struct Node** head, int index, int value) {
	if (index == 0) { insertBeginning(head, value); return; }
	struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
	newNode->data = value;
	struct Node* temp = *head;
	for (int i = 0; i < index - 1; i++) {
		if (temp == NULL) return;
		temp = temp->next;
	}
	newNode->next = temp->next;
	temp->next = newNode;
}

void deleteBeginning(struct Node** head) {
	if (*head == NULL) return;
	struct Node* temp = *head;
	*head = (*head)->next;
	free(temp);
}

void deleteEnd(struct Node** head) {
	if (*head == NULL) return;
	if ((*head)->next == NULL) {
		free(*head);
		*head = NULL;
		return;
	}
	struct Node* temp = *head;
	while (temp->next->next != NULL) temp = temp->next;
	free(temp->next);
	temp->next = NULL;
}

void deleteAtIndex(struct Node** head, int index) {
	if (index == 0) { deleteBeginning(head); return; }
	struct Node* temp = *head;
	for (int i = 0; i < index - 1; i++) {
		if (temp == NULL) return;
		temp = temp->next;
	}
	if (temp == NULL || temp->next == NULL) return;
	struct Node* deleteNode = temp->next;
	temp->next = deleteNode->next;
	free(deleteNode);
}

void printList(struct Node* head) {
	struct Node* temp = head;
	while (temp != NULL) {
		printf("%d", temp->data);
		if (temp->next != NULL) printf(",");
		temp = temp->next;
	}
	printf("\\n");
}

bool linearSearch(struct Node* head, int value) {
	struct Node* current = head;
	int index = 0;
	while (current != NULL) {
		if (current->data == value) {
			printf("Result = found at index %d\\n", index);
			return true;
		}
		current = current->next;
		index++;
	}
	printf("Result = not found\\n");
	return false;
}"""
	return base_code + _build_action_code("c")

# ==============================================
#   CONFIG HANDLERS
# ==============================================

func _connect_configuration_buttons() -> void:
	_ensure_connected(yes_btn, "pressed", _on_config_yes_pressed)
	_ensure_connected(no_btn, "pressed", _on_config_no_pressed)
	_ensure_connected(size_back_btn, "pressed", _on_size_back_pressed)
	_ensure_connected(size_next_btn, "pressed", _on_size_next_pressed)
	_ensure_connected(elements_back_btn, "pressed", _on_elements_back_pressed)
	_ensure_connected(elements_done_btn, "pressed", _on_elements_done_pressed)

func _show_config_modal() -> void: config_modal.show()
func _on_config_yes_pressed() -> void: btn_sound.play(); config_modal.hide(); _show_config_size_modal()
func _show_config_size_modal() -> void: config_size_modal.show()

func _on_size_next_pressed() -> void:
	btn_sound.play()
	var size = int(size_input.value)
	if size > 6 or size < 1: 
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
	grid.columns = 3 
	grid.add_theme_constant_override("h_separation", 20)
	grid.add_theme_constant_override("v_separation", 20)
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	elements_container.add_child(grid)
	
	var count = int(size_input.value)
	for i in range(count):
		var le = LineEdit.new()
		le.placeholder_text = str(randi_range(1, 99))
		
		le.custom_minimum_size = Vector2(80, 50) 
		le.alignment = HORIZONTAL_ALIGNMENT_CENTER 
		le.max_length = 3 
		
		le.text_changed.connect(_on_element_input_changed.bind(le))
		
		element_inputs.append(le)
		grid.add_child(le)
		
	config_elements_modal.show()

func _on_element_input_changed(new_text: String, le: LineEdit) -> void:
	var filtered_text = ""
	
	for i in range(new_text.length()):
		var char = new_text[i]
		if (char >= "0" and char <= "9") or (i == 0 and char == "-"):
			filtered_text += char
			
	if filtered_text != new_text:
		le.text = filtered_text
		le.caret_column = filtered_text.length()

func _on_elements_done_pressed() -> void:
	btn_sound.play()
	var arr: Array[int] = []
	for le in element_inputs:
		var val = int(le.text) if le.text.is_valid_int() else int(le.placeholder_text)
		arr.append(val)
	config_elements_modal.hide()
	_initialize_with_elements(arr)

func _on_config_no_pressed() -> void:
	btn_sound.play()
	config_modal.hide()
	var count = randi_range(1, 6)
	var arr: Array[int] = []
	for i in count: arr.append(randi_range(1, 99))
	_initialize_with_elements(arr)

func _on_size_back_pressed(): config_size_modal.hide(); config_modal.show()
func _on_elements_back_pressed(): config_elements_modal.hide(); config_size_modal.show()

# ==============================================
#   INTRO & TUTORIAL SEQUENCE
# ==============================================

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
	if intro_prev_btn: intro_prev_btn.visible = (intro_step > 0)
	if intro_next_btn: intro_next_btn.text = "Finish" if intro_step >= intro_texts.size() - 1 else "Next"

func _on_intro_next_pressed():
	btn_sound.play()
	if intro_step < intro_texts.size() - 1:
		intro_step += 1
		_update_intro_text()
	else:
		intro_popup.hide()
		if tutorial_overlay: tutorial_overlay.hide()

func _on_intro_prev_pressed():
	btn_sound.play()
	if intro_step > 0:
		intro_step -= 1
		_update_intro_text()

func _on_intro_skip_pressed():
	btn_sound.play()
	intro_popup.hide()
	if tutorial_overlay: tutorial_overlay.hide()

func _on_help_button_pressed():
	btn_sound.play()
	start_tutorial()

func start_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	if tutorial_overlay: tutorial_overlay.show()
	if tutorial_box: tutorial_box.show()
	
	tutorial_sequence = [
		{ "node": insert_menu, "title": "INSERT OPTIONS", "text": "Add new nodes to the Beginning, End, or a Specific Position." },
		{ "node": delete_menu, "title": "DELETE OPTIONS", "text": "Remove nodes from the Beginning, End, or a Specific Position." },
		{ "node": sort_btn, "title": "SEARCH LIST", "text": "Opens a popup to set the Target value you want to search for in the Linked List." },
		{ "node": auto_search_btn, "title": "AUTO SEARCH", "text": "Starts/Pauses automatic searching step-by-step." },
		{ "node": auto_btn, "title": "SEARCH STEP", "text": "Executes one comparison step manually." },
		{ "node": timeline_btn, "title": "TIMELINE", "text": "View a history of all operations and comparisons." },
		{ "node": simulate_new_btn, "title": "SIMULATE NEW", "text": "Resets the simulation entirely to enter new numbers." }
	]
	show_tutorial_step()

func show_tutorial_step() -> void:
	if tutorial_sequence_index >= tutorial_sequence.size():
		end_tutorial()
		return
		
	var step = tutorial_sequence[tutorial_sequence_index]
	if tutorial_text: tutorial_text.text = step["title"] + "\n\n" + step["text"]
	
	var node = step["node"]
	
	if node and pointer_sprite:
		pointer_sprite.texture = POINTER_TEX
		pointer_sprite.show()
		
		var pos_x = node.global_position.x + node.size.x + 30 
		var pos_y = node.global_position.y + (node.size.y / 2)
		pointer_sprite.global_position = Vector2(pos_x, pos_y)
		pointer_sprite.z_index = 100 
		
		if pointer_sprite.has_meta("tween"): pointer_sprite.get_meta("tween").kill()
		var tween = create_tween().set_loops()
		pointer_sprite.set_meta("tween", tween)
		pointer_sprite.offset = Vector2.ZERO
		tween.tween_property(pointer_sprite, "offset:x", -10.0, 0.5).set_trans(Tween.TRANS_SINE)
		tween.tween_property(pointer_sprite, "offset:x", 0.0, 0.5).set_trans(Tween.TRANS_SINE)
	else:
		if pointer_sprite: pointer_sprite.hide()

func _on_next_button_pressed():
	btn_sound.play()
	tutorial_sequence_index += 1
	show_tutorial_step()

func end_tutorial():
	tutorial_in_progress = false
	if tutorial_overlay: tutorial_overlay.hide()
	if pointer_sprite:
		pointer_sprite.hide()
		if pointer_sprite.has_meta("tween"): pointer_sprite.get_meta("tween").kill()

# ==============================================
#   HELPER / UTILS
# ==============================================

func _on_cpp_close_pressed(): btn_sound.play(); cpp_popup.hide()
func _on_cpp_code_button_pressed(): btn_sound.play(); _show_cpp_popup()
func _on_complete_ok_pressed(): btn_sound.play(); complete_popup.hide()

func _on_simulate_new_pressed(): sim_confirmation.show()
func _on_no_pressed(): 
	sim_confirmation.hide()
	cpp_code_button.hide()
func _on_yes_pressed():
	sim_confirmation.hide()
	sim_success.show()
	await get_tree().create_timer(1.0).timeout
	sim_success.hide()
	cpp_code_button.hide()
	_show_config_modal()

func _connect_language_buttons():
	if cpp_lang_btn: cpp_lang_btn.pressed.connect(_set_lang_and_show.bind("cpp"))
	if python_lang_btn: python_lang_btn.pressed.connect(_set_lang_and_show.bind("python"))
	if java_lang_btn: java_lang_btn.pressed.connect(_set_lang_and_show.bind("java"))
	if c_lang_btn: c_lang_btn.pressed.connect(_set_lang_and_show.bind("c"))

func _set_lang_and_show(lang: String):
	current_code_language = lang
	_show_cpp_popup()
