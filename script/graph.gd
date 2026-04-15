extends Control

# =======================================================
# MISSING NODE REFERENCES (from BST template)
# =======================================================

# These nodes exist in the scene but weren't defined in the main section
@onready var ptr_left: Node = $TextureRect/front
@onready var ptr_right: Node = $TextureRect/rear
@onready var unused_ptr1: Node = $TextureRect/front2
@onready var unused_ptr2: Node = $TextureRect/rear2
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label
@onready var dequeued_container: Control = $DequeuedContainer
# =======================================================
#   GRAPH LECTURE MODE - Undirected Weighted Graph Simulation
# =======================================================
# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var instruction_label: Label = $HBoxContainer2/Label
@onready var compare_label: Label = $MarginContainer/HBoxContainer2/TextureRect/Label
@onready var graph_container: Control = $TreeContainer
@onready var cycle_indicator: TextureRect = $cycle
@onready var connectivity_indicator: TextureRect = $connectivity
# Queue Full Warning
@onready var Queue_full: Panel = get_node_or_null("Queue_full")
@onready var anim_sprite: AnimatedSprite2D = get_node_or_null("Queue_full/AnimatedSprite2D")
# --- COMPILER INTEGRATION ---
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = $CppPopup/VBoxContainer/HBoxContainer2/CompileButton

# --- MAIN BUTTONS ---
@onready var vertex_btn: Button = $VBoxContainer/InsertButton      # Vertex Options
@onready var edge_btn: Button = $VBoxContainer/DeleteButton        # Edge Options
@onready var traverse_btn: Button = $VBoxContainer/SortButton      # Traverse
@onready var dijkstra_btn: Button = $VBoxContainer/WaitingElements # Dijkstra's SP
@onready var prim_btn: Button = $VBoxContainer/Prim                # Prim's MST
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew
@onready var end_sim_btn: Button = $VBoxContainer/EndSimulationButton


# --- POPUPS ---
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: RichTextLabel = $TimelinePopup/MainVBox/ScrollContainer/VBoxContainer/RichTextLabel
@onready var timeline_close_btn: Button = $TimelinePopup/MainVBox/CloseButton
@onready var complete_popup: PopupPanel = $SimulationCompletePopup
@onready var complete_ok_btn: Button = $SimulationCompletePopup/VBoxContainer/CloseButton
@onready var show_cpp_btn: Button = $SimulationCompletePopup/VBoxContainer/ShowCppButton
@onready var process_label: Label = $SimulationCompletePopup/VBoxContainer/ProcessLabel

# --- C++ POPUP NODES ---
@onready var cpp_popup: PopupPanel = $CppPopup
@onready var cpp_scroll: ScrollContainer = $CppPopup/VBoxContainer/CodeScroll
@onready var cpp_label: RichTextLabel = $CppPopup/VBoxContainer/CodeScroll/CodeLabel
@onready var cpp_close_btn: Button = $CppPopup/VBoxContainer/HBoxContainer2/close
@onready var cpp_next_btn: Button = $CppPopup/VBoxContainer/HBoxContainer2/CppNextButton
@onready var cpp_tutorial_panel: Panel = $CppPopup/VBoxContainer/TutorialPanel
@onready var cpp_explanation_lbl: RichTextLabel = $CppPopup/VBoxContainer/TutorialPanel/ExplanationText
@onready var cpp_code_button: Button = $CppCodeButton
@onready var code_anim: AnimatedSprite2D = $CppCodeButton/code_anim

# --- SCENE RESOURCES ---
const VERTEX_SCENE := preload("res://TreeNode.tscn")
const POINTER_TEX := preload("res://assets/point_left.png")
const RESULT_POPUP_SCENE := preload("res://scene/ResultPopup.tscn")

# --- TUTORIAL OVERLAY ---
@onready var tutorial_overlay: CanvasLayer = $TutorialOverlay
@onready var dim_bg: ColorRect = $TutorialOverlay/DimBackground
@onready var tutorial_box: Panel = $TutorialOverlay/TutorialBox
@onready var tutorial_text: Label = $TutorialOverlay/TutorialBox/VBoxContainer/TutorialText
@onready var tutorial_next: Button = $TutorialOverlay/TutorialBox/VBoxContainer/NextButton
@onready var pointer_sprite: Sprite2D = $TutorialOverlay/PointerSprite
@onready var intro_popup: Panel = $TutorialOverlay/Intro_popup
@onready var intro_label: Label = $TutorialOverlay/Intro_popup/Label
@onready var intro_next_btn: Button = $TutorialOverlay/Intro_popup/next
@onready var intro_skip_btn: Button = $TutorialOverlay/Intro_popup/skip
@onready var intro_prev_btn: Button = $TutorialOverlay/Intro_popup/prev

# --- AUDIO ---
@onready var audio_player = $bgm
@onready var btn_sound = $btn_sound

# --- CONFIGURATION MODALS (Hidden in Lecture) ---
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
@onready var try_again_btn_root: Button = $TryAgainButton
@onready var help_btn: Button = $HelpButton


# --- LANGUAGE BUTTONS ---
@onready var cpp_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Cpp_btn
@onready var python_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Py_btn
@onready var java_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/Java_btn
@onready var c_lang_btn: Button = $CppPopup/VBoxContainer/HBoxContainer/C_btn

# =======================================================
# COMPILER API KEYS
# =======================================================
const API_KEYS = {
	"cpp": {
		"clientId": "3c11a7c85254e2f154ea9c2bbf3d1356",
		"clientSecret": "918e597d99f55dc0972e92971189ed76d47f3a84541678a60f65a978728934cc"
	},
	"c": {
		"clientId": "3c11a7c85254e2f154ea9c2bbf3d1356",
		"clientSecret": "918e597d99f55dc0972e92971189ed76d47f3a84541678a60f65a978728934cc"
	},
	"java": {
		"clientId": "3c11a7c85254e2f154ea9c2bbf3d1356",
		"clientSecret": "918e597d99f55dc0972e92971189ed76d47f3a84541678a60f65a978728934cc"
	},
	"python": {
		"clientId": "3c11a7c85254e2f154ea9c2bbf3d1356",
		"clientSecret": "918e597d99f55dc0972e92971189ed76d47f3a84541678a60f65a978728934cc"
	}
}

# =======================================================
# GRAPH VARIABLES
# =======================================================

# Graph data
var vertices: Array = []           # Vertex values (indices 0 to n-1)
var vertex_nodes: Array = []       # Node instances
var vertex_positions: Array = []   # Circle positions
var edges: Dictionary = {}         # Key: "u,v" sorted, Value: weight
var vertex_count: int = 0
var edge_count: int = 0
var max_vertices: int = 7
var min_vertices: int = 3

# Animation state
var is_animating: bool = false
var animation_timer: SceneTreeTimer = null
var ANIM_SPEED: float = 0.2
var HIGHLIGHT_DURATION: float = 1.0
var FADE_DURATION: float = 2.0

# Graph state
var is_simulation_active: bool = true
var timeline_log: Array[String] = []
var code_lines: Array[String] = []
var current_code_language: String = "cpp"
var operation_count: int = 0

# Temporary state for algorithms
var waiting_for_vertex: bool = false
var waiting_for_target: bool = false
var current_algorithm: String = ""
var source_vertex_index: int = -1
var target_vertex_index: int = -1
var prim_start_index: int = -1

# UI elements
var vertex_menu: PopupMenu
var edge_menu: PopupMenu
var traverse_menu: PopupMenu

# Input dialogs
var add_vertex_dialog: ConfirmationDialog
var add_vertex_spinbox: SpinBox
var remove_vertex_dialog: ConfirmationDialog
var remove_vertex_spinbox: SpinBox
var add_edge_dialog: ConfirmationDialog
var add_edge_buttons: Array = []
var add_edge_weight_spinbox: SpinBox
var remove_edge_dialog: ConfirmationDialog
var remove_edge_list: ItemList
var edit_edge_dialog: ConfirmationDialog
var edit_edge_list: ItemList
var edit_edge_weight_spinbox: SpinBox
var end_confirmation: ConfirmationDialog

# Result Popup
var result_popup: PopupPanel
var result_title: Label
var score_summary: Label
var accuracy_label: Label
var time_used_label: Label
var coins_label: Label
var coins_anim: AnimatedSprite2D
var try_again_result_btn: Button
var back_result_btn: Button
var translate_code_btn: Button

var element_inputs: Array[LineEdit] = []
# Tutorial
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

# Intro Text
var intro_step: int = 0
var intro_texts = [
	"WELCOME TO GRAPH LECTURE MODE! 🕸️\n\nThis is an Undirected Weighted Graph.\n• Vertices are circles with numbers\n• Edges are lines with weights\n• All edges work both ways",
	
	"GRAPH OPERATIONS:\n\n• VERTEX OPTIONS: Add/Remove vertices\n• EDGE OPTIONS: Add/Remove/Edit edges\n• TRAVERSE: BFS or DFS search\n• DIJKSTRA: Find shortest path\n• PRIM'S: Build Minimum Spanning Tree",
	
	"VISUAL INDICATORS:\n\n• 🟢 GREEN cycle icon = Graph has a cycle\n• 🔴 PINK connectivity icon = Graph is fully connected\n• Gray icons = Conditions not met",
	
	"ALGORITHM STEPS:\n\n• Click algorithm button\n• Follow instructions on screen\n• Watch the animation step by step\n• Results fade after 2 seconds",
	
	"TIPS:\n\n• Max 7 vertices (arranged in circle)\n• Edge weights range 1-99\n• No duplicate vertices\n• Graph is undirected (edges work both ways)"
]

# =======================================================
# CODE TUTORIAL DATA
# =======================================================
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

var cpp_tutorial_data = [
	{ "lines": [0, 1, 2], "text": "1. Graph Representation:\nAdjacency list with weights." },
	{ "lines": [5, 6, 7], "text": "2. Add Edge:\nConnects two vertices with weight." },
	{ "lines": [9, 10, 11], "text": "3. BFS Traversal:\nLevel-order exploration." },
	{ "lines": [13, 14, 15], "text": "4. DFS Traversal:\nDepth-first exploration." },
	{ "lines": [17, 18, 19, 20], "text": "5. Dijkstra's Algorithm:\nFinds shortest path using priority queue." },
	{ "lines": [22, 23, 24], "text": "6. Prim's Algorithm:\nBuilds Minimum Spanning Tree." }
]

var python_tutorial_data = [
	{ "lines": [0, 1], "text": "1. Graph Class:\nUsing defaultdict for adjacency." },
	{ "lines": [3, 4], "text": "2. Add Edge:\nAdds both directions." },
	{ "lines": [6, 7, 8], "text": "3. BFS:\nUses collections.deque." },
	{ "lines": [10, 11, 12], "text": "4. Dijkstra:\nUses heapq for priority queue." }
]

var java_tutorial_data = [
	{ "lines": [0, 1, 2], "text": "1. Graph Class:\nArrayList of ArrayList of Edge." },
	{ "lines": [4, 5, 6], "text": "2. Edge Class:\nStores destination and weight." },
	{ "lines": [8, 9, 10], "text": "3. Dijkstra:\nUses PriorityQueue." }
]

var c_tutorial_data = [
	{ "lines": [0, 1, 2], "text": "1. Structure:\nAdjacency matrix representation." },
	{ "lines": [4, 5, 6], "text": "2. Graph Functions:\nInitialize and add edges." },
	{ "lines": [8, 9, 10], "text": "3. BFS/DFS:\nUsing arrays as queues/stacks." }
]

# =======================================================
# READY & INITIALIZATION
# =======================================================

func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	print("Graph Lecture Mode initialized")
	randomize()
	
	# Setup result popup
	result_popup = RESULT_POPUP_SCENE.instantiate()
	add_child(result_popup)
	result_title = result_popup.get_node("TextureRect/VBoxContainer/ResultTitle")
	score_summary = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer3/VBoxContainer/ScoreSummary")
	accuracy_label = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer3/VBoxContainer/AccuracyLabel")
	time_used_label = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer3/VBoxContainer/TimeUsedLabel")
	coins_label = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer3/HBoxContainer/Label")
	coins_anim = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer3/HBoxContainer/Control/AnimatedSprite2D")
	try_again_result_btn = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer2/TryAgainButton")
	back_result_btn = result_popup.get_node("TextureRect/VBoxContainer/HBoxContainer2/BackButton")
	translate_code_btn = result_popup.get_node("TextureRect/VBoxContainer/translate_code_btn")
	
	try_again_result_btn.pressed.connect(_on_try_again_pressed)
	back_result_btn.pressed.connect(_on_back_pressed)
	translate_code_btn.pressed.connect(_on_translate_code_pressed)
	
	# Setup containers
	if graph_container:
		graph_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Hide pointers
	if ptr_left: ptr_left.hide()
	if ptr_right: ptr_right.hide()
	if unused_ptr1: unused_ptr1.hide()
	if unused_ptr2: unused_ptr2.hide()
	
	# Hide modals
	config_modal.hide()
	config_size_modal.hide()
	config_elements_modal.hide()
	if Queue_full: Queue_full.hide()
	
	if cpp_code_button: cpp_code_button.hide()
	
	# Connect close buttons
	if timeline_close_btn:
		timeline_close_btn.pressed.connect(_on_timeline_close_pressed)
	if complete_ok_btn:
		complete_ok_btn.pressed.connect(_on_complete_ok_pressed)
	if cpp_close_btn:
		cpp_close_btn.pressed.connect(_on_cpp_close_pressed)
	if try_again_btn_root:
		try_again_btn_root.pressed.connect(_on_try_again_pressed)
	
	# =======================================================
	# IMPORTANT: Fix the button connections
	# =======================================================
	# ConfigChoiceModal buttons (the initial "Do you want to configure" popup)
	if yes_btn:
		yes_btn.pressed.connect(_on_config_yes_pressed)   # Goes to size modal
	if no_btn:
		no_btn.pressed.connect(_on_config_no_pressed)     # Generates random graph
	
	# Simulate New confirmation popup buttons
	if sim_confirmation:
		var sim_yes = sim_confirmation.get_node_or_null("yes")
		var sim_no = sim_confirmation.get_node_or_null("no")
		if sim_yes:
			sim_yes.pressed.connect(_on_yes_pressed)
		if sim_no:
			sim_no.pressed.connect(_on_no_pressed)
	
	# Setup timeline label
	if timeline_label:
		timeline_label.fit_content = true
		timeline_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		timeline_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		timeline_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	# Create menus
	_create_menus()
	_create_input_dialogs()
	_connect_buttons()
	_connect_language_buttons()
	_setup_compiler()
	
	# Show config modal to set initial vertices
	_show_config_modal()
	
	# Show intro
	call_deferred("show_introduction")
	
	if q_mark_sprite: q_mark_sprite.play("default")
	if code_anim: code_anim.play("default")

func _enter_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	await get_tree().process_frame
	await get_tree().process_frame
	var current_size = get_viewport().get_visible_rect().size
	if current_size.y > current_size.x:
		get_tree().root.content_scale_size = Vector2i(int(current_size.y), int(current_size.x))

func _exit_tree():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_PORTRAIT)

# =======================================================
# MENU CREATION
# =======================================================

func _create_menus():
	vertex_menu = PopupMenu.new()
	vertex_menu.add_item("Add Vertex")
	vertex_menu.add_item("Remove Vertex")
	vertex_menu.add_separator()
	vertex_menu.add_item("Cancel")
	vertex_menu.id_pressed.connect(_on_vertex_menu_pressed)
	add_child(vertex_menu)
	
	edge_menu = PopupMenu.new()
	edge_menu.add_item("Add Edge")
	edge_menu.add_item("Remove Edge")
	edge_menu.add_item("Edit Edge Weight")
	edge_menu.add_separator()
	edge_menu.add_item("Cancel")
	edge_menu.id_pressed.connect(_on_edge_menu_pressed)
	add_child(edge_menu)
	
	traverse_menu = PopupMenu.new()
	traverse_menu.add_item("BFS (Breadth-First Search)")
	traverse_menu.add_item("DFS (Depth-First Search)")
	traverse_menu.add_separator()
	traverse_menu.add_item("Cancel")
	traverse_menu.id_pressed.connect(_on_traverse_menu_pressed)
	add_child(traverse_menu)

func _on_vertex_menu_pressed(id: int):
	match id:
		0: _show_add_vertex_dialog()
		1: _show_remove_vertex_dialog()
		2: return

func _on_edge_menu_pressed(id: int):
	match id:
		0: _show_add_edge_dialog()
		1: _show_remove_edge_dialog()
		2: _show_edit_edge_dialog()
		3: return

func _on_traverse_menu_pressed(id: int):
	match id:
		0: _start_algorithm("bfs")
		1: _start_algorithm("dfs")
		2: return

# =======================================================
# DIALOG HELPER FUNCTIONS (Moved outside _create_input_dialogs)
# =======================================================

var dialog_my_font: Font
var dialog_bg_texture: Texture2D
var dialog_btn_texture: Texture2D

func style_dialog(dialog: ConfirmationDialog, title: String, size: Vector2 = Vector2(500, 350)) -> ConfirmationDialog:
	dialog.title = title
	dialog.min_size = size
	dialog.exclusive = true
	if dialog_my_font:
		dialog.add_theme_font_override("title_font", dialog_my_font)
	dialog.add_theme_font_size_override("title_font_size", 28)
	
	var panel_style = StyleBoxTexture.new()
	panel_style.texture = dialog_bg_texture
	panel_style.texture_margin_left = 25
	panel_style.texture_margin_top = 25
	panel_style.texture_margin_right = 25
	panel_style.texture_margin_bottom = 25
	panel_style.content_margin_bottom = 35
	dialog.add_theme_stylebox_override("panel", panel_style)
	
	var empty_icon = PlaceholderTexture2D.new()
	empty_icon.size = Vector2(0, 0)
	dialog.add_theme_icon_override("close", empty_icon)
	dialog.add_theme_icon_override("close_pressed", empty_icon)
	dialog.add_theme_icon_override("close_hover", empty_icon)
	return dialog

func style_button(btn: Button, text: String) -> Button:
	var btn_style = StyleBoxTexture.new()
	btn_style.texture = dialog_btn_texture
	btn_style.texture_margin_left = 12
	btn_style.texture_margin_right = 12
	btn_style.texture_margin_top = 12
	btn_style.texture_margin_bottom = 12
	btn_style.content_margin_left = 30
	btn_style.content_margin_right = 30
	btn_style.content_margin_top = 12
	btn_style.content_margin_bottom = 12
	
	var btn_hover = btn_style.duplicate()
	btn_hover.modulate_color = Color(0.85, 0.85, 0.85, 1.0)
	var btn_pressed = btn_style.duplicate()
	btn_pressed.modulate_color = Color(0.65, 0.65, 0.65, 1.0)
	
	btn.text = text
	if dialog_my_font:
		btn.add_theme_font_override("font", dialog_my_font)
	btn.add_theme_font_size_override("font_size", 24)
	btn.custom_minimum_size = Vector2(130, 55)
	btn.add_theme_stylebox_override("normal", btn_style)
	btn.add_theme_stylebox_override("hover", btn_hover)
	btn.add_theme_stylebox_override("pressed", btn_pressed)
	return btn

func add_content(dialog: ConfirmationDialog) -> VBoxContainer:
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_top", 30)
	margin.add_theme_constant_override("margin_left", 35)
	margin.add_theme_constant_override("margin_right", 35)
	margin.add_theme_constant_override("margin_bottom", 25)
	dialog.add_child(margin)
	var main_vbox = VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 20)
	main_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	margin.add_child(main_vbox)
	return main_vbox

func create_spinbox(min_val: int, max_val: int, default_val: int) -> SpinBox:
	var spin = SpinBox.new()
	spin.min_value = min_val
	spin.max_value = max_val
	spin.value = default_val
	spin.custom_minimum_size = Vector2(280, 70)
	spin.alignment = HORIZONTAL_ALIGNMENT_CENTER
	spin.add_theme_constant_override("buttons_vertical_separation", 18)
	spin.add_theme_constant_override("buttons_width", 50)
	
	var spin_style = StyleBoxTexture.new()
	spin_style.texture = dialog_bg_texture
	spin_style.texture_margin_left = 12
	spin_style.texture_margin_top = 12
	spin_style.texture_margin_right = 12
	spin_style.texture_margin_bottom = 12
	spin.add_theme_stylebox_override("normal", spin_style)
	
	var up_btn_style = StyleBoxTexture.new()
	up_btn_style.texture = dialog_btn_texture
	up_btn_style.texture_margin_left = 8
	up_btn_style.texture_margin_top = 8
	up_btn_style.texture_margin_right = 8
	up_btn_style.texture_margin_bottom = 8
	spin.add_theme_stylebox_override("up", up_btn_style)
	spin.add_theme_stylebox_override("down", up_btn_style)
	
	var line_edit = spin.get_line_edit()
	if line_edit:
		if dialog_my_font:
			line_edit.add_theme_font_override("font", dialog_my_font)
		line_edit.add_theme_font_size_override("font_size", 32)
		line_edit.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		line_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
		line_edit.custom_minimum_size = Vector2(0, 65)
		var line_edit_style = StyleBoxFlat.new()
		line_edit_style.bg_color = Color(0, 0, 0, 0.5)
		line_edit_style.corner_radius_top_left = 8
		line_edit_style.corner_radius_top_right = 8
		line_edit_style.corner_radius_bottom_right = 8
		line_edit_style.corner_radius_bottom_left = 8
		line_edit.add_theme_stylebox_override("normal", line_edit_style)
	return spin

# =======================================================
# DIALOG CREATION (Now using the helper functions)
# =======================================================

func _create_input_dialogs():
	dialog_my_font = load("res://assets/font/Planes_ValMore.ttf")
	dialog_bg_texture = load("res://assets/CONTAINER.png")
	dialog_btn_texture = load("res://assets/BUTTON.png")
	
	# Add Vertex Dialog
	add_vertex_dialog = style_dialog(ConfirmationDialog.new(), "Add Vertex", Vector2(500, 300))
	var add_vbox = add_content(add_vertex_dialog)
	var add_label = Label.new()
	add_label.text = "Enter vertex value (1-99)"
	if dialog_my_font:
		add_label.add_theme_font_override("font", dialog_my_font)
	add_label.add_theme_font_size_override("font_size", 28)
	add_label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
	add_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_vbox.add_child(add_label)
	var spin_center = CenterContainer.new()
	spin_center.custom_minimum_size = Vector2(0, 90)
	add_vbox.add_child(spin_center)
	add_vertex_spinbox = create_spinbox(1, 99, 50)
	spin_center.add_child(add_vertex_spinbox)
	var add_btn_hbox = HBoxContainer.new()
	add_btn_hbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_btn_hbox.add_theme_constant_override("separation", 40)
	add_vbox.add_child(add_btn_hbox)
	var add_ok = add_vertex_dialog.get_ok_button()
	var add_cancel = add_vertex_dialog.get_cancel_button()
	add_ok.get_parent().remove_child(add_ok)
	add_cancel.get_parent().remove_child(add_cancel)
	style_button(add_ok, "ADD")
	style_button(add_cancel, "CANCEL")
	add_btn_hbox.add_child(add_ok)
	add_btn_hbox.add_child(add_cancel)
	add_child(add_vertex_dialog)
	add_vertex_dialog.confirmed.connect(_on_add_vertex_confirmed)
	add_cancel.pressed.connect(_on_add_vertex_cancel)
	
	# Remove Vertex Dialog
	remove_vertex_dialog = style_dialog(ConfirmationDialog.new(), "Remove Vertex", Vector2(500, 300))
	var remove_vbox = add_content(remove_vertex_dialog)
	var remove_label = Label.new()
	remove_label.text = "Enter vertex value to remove"
	if dialog_my_font:
		remove_label.add_theme_font_override("font", dialog_my_font)
	remove_label.add_theme_font_size_override("font_size", 28)
	remove_label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
	remove_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	remove_vbox.add_child(remove_label)
	var remove_spin_center = CenterContainer.new()
	remove_spin_center.custom_minimum_size = Vector2(0, 90)
	remove_vbox.add_child(remove_spin_center)
	remove_vertex_spinbox = create_spinbox(1, 99, 50)
	remove_spin_center.add_child(remove_vertex_spinbox)
	var remove_btn_hbox = HBoxContainer.new()
	remove_btn_hbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	remove_btn_hbox.add_theme_constant_override("separation", 40)
	remove_vbox.add_child(remove_btn_hbox)
	var remove_ok = remove_vertex_dialog.get_ok_button()
	var remove_cancel = remove_vertex_dialog.get_cancel_button()
	remove_ok.get_parent().remove_child(remove_ok)
	remove_cancel.get_parent().remove_child(remove_cancel)
	style_button(remove_ok, "REMOVE")
	style_button(remove_cancel, "CANCEL")
	remove_btn_hbox.add_child(remove_ok)
	remove_btn_hbox.add_child(remove_cancel)
	add_child(remove_vertex_dialog)
	remove_vertex_dialog.confirmed.connect(_on_remove_vertex_confirmed)
	remove_cancel.pressed.connect(_on_remove_vertex_cancel)
	
	# Add Edge Dialog - FIXED VERSION
	add_edge_dialog = style_dialog(ConfirmationDialog.new(), "Add Edge", Vector2(600, 400))
	var add_edge_margin = MarginContainer.new()
	add_edge_margin.add_theme_constant_override("margin_top", 30)
	add_edge_margin.add_theme_constant_override("margin_left", 35)
	add_edge_margin.add_theme_constant_override("margin_right", 35)
	add_edge_margin.add_theme_constant_override("margin_bottom", 25)
	add_edge_dialog.add_child(add_edge_margin)

	var add_edge_vbox = VBoxContainer.new()
	add_edge_vbox.add_theme_constant_override("separation", 20)
	add_edge_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	add_edge_margin.add_child(add_edge_vbox)

	var add_edge_label = Label.new()
	add_edge_label.text = "Click a button below to select vertices to connect"
	if dialog_my_font:
		add_edge_label.add_theme_font_override("font", dialog_my_font)
	add_edge_label.add_theme_font_size_override("font_size", 24)
	add_edge_label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
	add_edge_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	add_edge_label.add_theme_constant_override("outline_size", 5)
	add_edge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_edge_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	add_edge_vbox.add_child(add_edge_label)

	# Scroll container for edge buttons
	var edge_scroll = ScrollContainer.new()
	edge_scroll.custom_minimum_size = Vector2(400, 200)
	edge_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	edge_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	add_edge_vbox.add_child(edge_scroll)

	var edge_grid = GridContainer.new()
	edge_grid.name = "EdgeGrid"
	edge_grid.columns = 2
	edge_grid.add_theme_constant_override("h_separation", 20)
	edge_grid.add_theme_constant_override("v_separation", 15)
	edge_scroll.add_child(edge_grid)
	add_edge_buttons.clear()

	var weight_label = Label.new()
	weight_label.text = "Edge weight (1-99):"
	if dialog_my_font:
		weight_label.add_theme_font_override("font", dialog_my_font)
	weight_label.add_theme_font_size_override("font_size", 24)
	weight_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	add_edge_vbox.add_child(weight_label)

	add_edge_weight_spinbox = create_spinbox(1, 99, 50)
	add_edge_vbox.add_child(add_edge_weight_spinbox)

	# Hide the default OK/Cancel buttons
	var add_edge_ok = add_edge_dialog.get_ok_button()
	var add_edge_default_cancel = add_edge_dialog.get_cancel_button()
	if add_edge_ok:
		add_edge_ok.hide()
	if add_edge_default_cancel:
		add_edge_default_cancel.hide()

	# Create custom buttons
	var add_edge_btn_hbox = HBoxContainer.new()
	add_edge_btn_hbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_edge_btn_hbox.add_theme_constant_override("separation", 40)
	add_edge_vbox.add_child(add_edge_btn_hbox)

	var add_edge_confirm = Button.new()
	var add_edge_cancel_btn = Button.new()
	style_button(add_edge_confirm, "ADD EDGE")
	style_button(add_edge_cancel_btn, "CANCEL")
	add_edge_btn_hbox.add_child(add_edge_confirm)
	add_edge_btn_hbox.add_child(add_edge_cancel_btn)

	add_child(add_edge_dialog)
	add_edge_confirm.pressed.connect(_on_add_edge_confirm)
	add_edge_cancel_btn.pressed.connect(_on_add_edge_cancel)
	
	# Remove Edge Dialog
	remove_edge_dialog = style_dialog(ConfirmationDialog.new(), "Remove Edge", Vector2(600, 450))
	var remove_edge_ok = remove_edge_dialog.get_ok_button()
	var remove_edge_default_cancel = remove_edge_dialog.get_cancel_button()
	if remove_edge_ok:
		remove_edge_ok.hide()
	if remove_edge_default_cancel:
		remove_edge_default_cancel.hide()
	var remove_edge_vbox = add_content(remove_edge_dialog)
	var remove_edge_label = Label.new()
	remove_edge_label.text = "Select edge to remove"
	if dialog_my_font:
		remove_edge_label.add_theme_font_override("font", dialog_my_font)
	remove_edge_label.add_theme_font_size_override("font_size", 28)
	remove_edge_label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
	remove_edge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	remove_edge_vbox.add_child(remove_edge_label)
	
	remove_edge_list = ItemList.new()
	remove_edge_list.custom_minimum_size = Vector2(400, 200)
	remove_edge_list.add_theme_font_override("font", dialog_my_font)
	remove_edge_list.add_theme_font_size_override("font_size", 24)
	remove_edge_vbox.add_child(remove_edge_list)
	
	var remove_edge_btn_hbox = HBoxContainer.new()
	remove_edge_btn_hbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	remove_edge_btn_hbox.add_theme_constant_override("separation", 40)
	remove_edge_vbox.add_child(remove_edge_btn_hbox)
	var remove_edge_confirm = Button.new()
	var remove_edge_cancel_btn = Button.new()
	style_button(remove_edge_confirm, "REMOVE EDGE")
	style_button(remove_edge_cancel_btn, "CANCEL")
	remove_edge_btn_hbox.add_child(remove_edge_confirm)
	remove_edge_btn_hbox.add_child(remove_edge_cancel_btn)
	add_child(remove_edge_dialog)
	remove_edge_confirm.pressed.connect(_on_remove_edge_confirmed)
	remove_edge_cancel_btn.pressed.connect(_on_remove_edge_cancel)
	
	# Edit Edge Dialog
	edit_edge_dialog = style_dialog(ConfirmationDialog.new(), "Edit Edge Weight", Vector2(600, 450))
	var edit_edge_ok = edit_edge_dialog.get_ok_button()
	var edit_edge_default_cancel = edit_edge_dialog.get_cancel_button()
	if edit_edge_ok:
		edit_edge_ok.hide()
	if edit_edge_default_cancel:
		edit_edge_default_cancel.hide()
	var edit_edge_vbox = add_content(edit_edge_dialog)
	var edit_edge_label = Label.new()
	edit_edge_label.text = "Select edge to edit"
	if dialog_my_font:
		edit_edge_label.add_theme_font_override("font", dialog_my_font)
	edit_edge_label.add_theme_font_size_override("font_size", 28)
	edit_edge_label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
	edit_edge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	edit_edge_vbox.add_child(edit_edge_label)
	
	edit_edge_list = ItemList.new()
	edit_edge_list.custom_minimum_size = Vector2(400, 200)
	edit_edge_list.add_theme_font_override("font", dialog_my_font)
	edit_edge_list.add_theme_font_size_override("font_size", 24)
	edit_edge_vbox.add_child(edit_edge_list)
	
	var edit_weight_label = Label.new()
	edit_weight_label.text = "New weight (1-99):"
	if dialog_my_font:
		edit_weight_label.add_theme_font_override("font", dialog_my_font)
	edit_weight_label.add_theme_font_size_override("font_size", 24)
	edit_weight_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	edit_edge_vbox.add_child(edit_weight_label)
	
	edit_edge_weight_spinbox = create_spinbox(1, 99, 50)
	edit_edge_vbox.add_child(edit_edge_weight_spinbox)
	
	var edit_edge_btn_hbox = HBoxContainer.new()
	edit_edge_btn_hbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	edit_edge_btn_hbox.add_theme_constant_override("separation", 40)
	edit_edge_vbox.add_child(edit_edge_btn_hbox)
	var edit_edge_confirm = Button.new()
	var edit_edge_cancel_btn = Button.new()
	style_button(edit_edge_confirm, "UPDATE")
	style_button(edit_edge_cancel_btn, "CANCEL")
	edit_edge_btn_hbox.add_child(edit_edge_confirm)
	edit_edge_btn_hbox.add_child(edit_edge_cancel_btn)
	add_child(edit_edge_dialog)
	edit_edge_confirm.pressed.connect(_on_edit_edge_confirmed)
	edit_edge_cancel_btn.pressed.connect(_on_edit_edge_cancel)
	
	# End Confirmation Dialog
	end_confirmation = style_dialog(ConfirmationDialog.new(), "End Simulation", Vector2(500, 300))
	var end_vbox = add_content(end_confirmation)
	var end_label = Label.new()
	end_label.text = "Do you really want to end the simulation?"
	if dialog_my_font:
		end_label.add_theme_font_override("font", dialog_my_font)
	end_label.add_theme_font_size_override("font_size", 28)
	end_label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
	end_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_vbox.add_child(end_label)
	var end_btn_hbox = HBoxContainer.new()
	end_btn_hbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_btn_hbox.add_theme_constant_override("separation", 40)
	end_vbox.add_child(end_btn_hbox)
	var end_yes = end_confirmation.get_ok_button()
	var end_no = end_confirmation.get_cancel_button()
	end_yes.get_parent().remove_child(end_yes)
	end_no.get_parent().remove_child(end_no)
	style_button(end_yes, "YES")
	style_button(end_no, "NO")
	end_btn_hbox.add_child(end_yes)
	end_btn_hbox.add_child(end_no)
	add_child(end_confirmation)
	end_confirmation.confirmed.connect(_end_simulation)
	end_no.pressed.connect(_on_end_cancel)

func _on_add_edge_confirm():
	if selected_edge_u != -1 and selected_edge_v != -1:
		_add_edge(selected_edge_u, selected_edge_v, int(add_edge_weight_spinbox.value))
		selected_edge_u = -1
		selected_edge_v = -1
	add_edge_dialog.hide()

func _on_add_vertex_cancel():
	add_vertex_dialog.hide()

func _on_remove_vertex_cancel():
	remove_vertex_dialog.hide()

func _on_add_edge_cancel():
	selected_edge_u = -1
	selected_edge_v = -1
	add_edge_dialog.hide()

func _on_remove_edge_cancel():
	remove_edge_dialog.hide()

func _on_edit_edge_cancel():
	edit_edge_dialog.hide()

func _on_end_cancel():
	end_confirmation.hide()
	
var selected_edge_u: int = -1
var selected_edge_v: int = -1

func _update_edge_buttons():
	print("=== _update_edge_buttons called ===")
	print("vertex_count: ", vertex_count)
	print("vertices: ", vertices)
	
	# Clear existing buttons
	for btn in add_edge_buttons:
		if is_instance_valid(btn):
			btn.queue_free()
	add_edge_buttons.clear()
	
	# Try multiple possible paths to find the grid container
	var edge_grid = null
	var possible_paths = [
		"MarginContainer/VBoxContainer/ScrollContainer/EdgeGrid",
		"MarginContainer/VBoxContainer/ScrollContainer/GridContainer",
		"VBoxContainer/ScrollContainer/EdgeGrid",
		"ScrollContainer/EdgeGrid",
		"EdgeGrid"
	]
	
	for path in possible_paths:
		var node = add_edge_dialog.get_node_or_null(path)
		if node and node is GridContainer:
			edge_grid = node
			print("Found EdgeGrid at path: ", path)
			break
	
	if not edge_grid:
		# Try to search recursively
		print("Searching recursively for GridContainer...")
		edge_grid = _find_grid_container(add_edge_dialog)
	
	if not edge_grid:
		print("ERROR: Could not find EdgeGrid in add_edge_dialog")
		show_feedback("Error: Could not find edge grid container!", Color.RED, get_global_mouse_position())
		return
	
	# Clear existing children
	for child in edge_grid.get_children():
		child.queue_free()
	
	# Add buttons for each possible edge
	var button_count = 0
	for i in range(vertex_count):
		for j in range(i + 1, vertex_count):
			if not _edge_exists(i, j):
				var btn = Button.new()
				btn.text = "%d - %d" % [vertices[i], vertices[j]]
				btn.custom_minimum_size = Vector2(120, 50)
				btn.add_theme_font_size_override("font_size", 20)
				btn.pressed.connect(_on_edge_selected.bind(i, j))
				edge_grid.add_child(btn)
				add_edge_buttons.append(btn)
				button_count += 1
	
	print("Added ", button_count, " edge buttons")
	
	# If no buttons, show a message
	if add_edge_buttons.is_empty():
		var empty_label = Label.new()
		empty_label.text = "No available edges to add (all possible connections already exist)"
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if dialog_my_font:
			empty_label.add_theme_font_override("font", dialog_my_font)
		empty_label.add_theme_font_size_override("font_size", 18)
		empty_label.add_theme_color_override("font_color", Color(1, 0.5, 0.5, 1))
		edge_grid.add_child(empty_label)

func _find_grid_container(node: Node) -> GridContainer:
	for child in node.get_children():
		if child is GridContainer:
			return child
		var found = _find_grid_container(child)
		if found:
			return found
	return null

func _on_edge_selected(u: int, v: int):
	# Clear previous selection highlighting
	for btn in add_edge_buttons:
		if is_instance_valid(btn):
			btn.modulate = Color(1, 1, 1, 1)
	
	# Find and highlight the selected button
	for btn in add_edge_buttons:
		if is_instance_valid(btn) and btn.text == "%d - %d" % [vertices[u], vertices[v]]:
			btn.modulate = Color(0, 1, 0, 1)
			break
	
	selected_edge_u = u
	selected_edge_v = v
	
	# Show feedback
	show_feedback("Selected edge %d - %d" % [vertices[u], vertices[v]], Color.CYAN, get_global_mouse_position())


func _get_selected_edge():
	if selected_edge_u != -1 and selected_edge_v != -1:
		return {"u": selected_edge_u, "v": selected_edge_v}
	return null
	
func _on_edge_button_pressed(u: int, v: int):
	_add_edge(u, v, int(add_edge_weight_spinbox.value))
	add_edge_dialog.hide()
	show_feedback("Edge %d-%d added with weight %d" % [vertices[u], vertices[v], int(add_edge_weight_spinbox.value)], Color.GREEN, get_global_mouse_position())

func _update_remove_edge_list():
	remove_edge_list.clear()
	for key in edges.keys():
		var parts = key.split(",")
		var u = int(parts[0])
		var v = int(parts[1])
		remove_edge_list.add_item("%d-%d (weight %d)" % [vertices[u], vertices[v], edges[key]])

func _update_edit_edge_list():
	edit_edge_list.clear()
	for key in edges.keys():
		var parts = key.split(",")
		var u = int(parts[0])
		var v = int(parts[1])
		edit_edge_list.add_item("%d-%d (weight %d)" % [vertices[u], vertices[v], edges[key]])

# =======================================================
# GRAPH LAYOUT
# =======================================================

func _calculate_circle_positions():
	vertex_positions.clear()
	var center = Vector2(580, 300)
	var radius = 200
	var angle_step = 2 * PI / vertex_count
	
	for i in range(vertex_count):
		var angle = i * angle_step - PI / 2
		var pos = center + Vector2(cos(angle), sin(angle)) * radius
		vertex_positions.append(pos)

func _initialize_graph(values: Array[int]):
	vertices = values.duplicate()
	vertex_count = vertices.size()
	edges.clear()
	edge_count = 0
	
	_calculate_circle_positions()
	
	# Clear existing nodes
	for child in graph_container.get_children():
		child.queue_free()
	vertex_nodes.clear()
	
	var my_font = load("res://assets/font/Planes_ValMore.ttf")
	
	for i in range(vertex_count):
		var node = VERTEX_SCENE.instantiate()
		graph_container.add_child(node)
		node.position = vertex_positions[i]
		node.set_value(vertices[i])
		node.modulate = Color(1, 1, 1, 1)
		
		# Invisible button overlay for click editing
		var click_btn = Button.new()
		click_btn.name = "ClickButton"
		click_btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		click_btn.modulate.a = 0.0
		click_btn.mouse_filter = Control.MOUSE_FILTER_STOP
		click_btn.pressed.connect(_on_vertex_clicked.bind(i))
		node.add_child(click_btn)
		
		vertex_nodes.append(node)
	
	queue_redraw()
	timeline_log.clear()
	code_lines.clear()
	_add_code_line("INITIAL", 0, 0)
	_update_stats_label()
	_update_indicators()
	operation_count = 0
	_update_processes_label()
	
	# Reset algorithm states
	waiting_for_vertex = false
	waiting_for_target = false
	current_algorithm = ""
	source_vertex_index = -1
	target_vertex_index = -1
	prim_start_index = -1
	
	if status_label:
		status_label.text = "Graph Ready"

func _on_vertex_clicked(index: int):
	# Safety check - make sure index is valid
	if index < 0 or index >= vertex_count or index >= vertex_nodes.size():
		show_feedback("Invalid vertex selection!", Color.RED, get_global_mouse_position())
		return
	
	if is_animating:
		show_feedback("Please wait, operation in progress...", Color.YELLOW, get_global_mouse_position())
		return
	
	# Debug print
	print("Vertex clicked: index=", index, " waiting_for_vertex=", waiting_for_vertex, " waiting_for_target=", waiting_for_target, " current_algorithm=", current_algorithm)
	
	if waiting_for_vertex:
		if current_algorithm == "bfs" or current_algorithm == "dfs":
			print("Starting traversal from vertex ", index)
			_start_traversal_from(index)
		elif current_algorithm == "dijkstra" and source_vertex_index == -1:
			print("Setting source vertex to ", index)
			source_vertex_index = index
			waiting_for_vertex = false
			waiting_for_target = true
			instruction_label.text = "Now click the TARGET vertex"
			if index < vertices.size():
				show_feedback("Source vertex %d selected! Now click target vertex" % vertices[index], Color.CYAN, get_global_mouse_position())
			else:
				show_feedback("Source vertex selected! Now click target vertex", Color.CYAN, get_global_mouse_position())
			print("State after source selection: waiting_for_target=", waiting_for_target)
		elif current_algorithm == "prim" and prim_start_index == -1:
			print("Setting Prim start vertex to ", index)
			prim_start_index = index
			waiting_for_vertex = false
			instruction_label.text = "Building Minimum Spanning Tree..."
			_prim_animate(prim_start_index)
	elif waiting_for_target and current_algorithm == "dijkstra":
		# This is the missing case - handle target vertex selection
		print("Setting target vertex to ", index)
		target_vertex_index = index
		waiting_for_target = false
		instruction_label.text = "Computing shortest path..."
		show_feedback("Target vertex %d selected! Computing shortest path..." % vertices[index], Color.CYAN, get_global_mouse_position())
		_dijkstra_animate(source_vertex_index, target_vertex_index)
	else:
		print("No waiting state - ignoring click")

func _draw():
	if vertex_nodes.is_empty():
		return
	
	var center_offset = Vector2(32, 32)
	var my_global_pos = get_global_position()
	
	for key in edges.keys():
		var parts = key.split(",")
		var u = int(parts[0])
		var v = int(parts[1])
		var weight = edges[key]
		
		if u < vertex_nodes.size() and v < vertex_nodes.size() and vertex_nodes[u] and vertex_nodes[v]:
			var start_pos = (vertex_nodes[u].global_position + center_offset) - my_global_pos
			var end_pos = (vertex_nodes[v].global_position + center_offset) - my_global_pos
			draw_line(start_pos, end_pos, Color.WHITE, 4.0)
			
			var mid_pos = (start_pos + end_pos) / 2
			draw_string(load("res://assets/font/Planes_ValMore.ttf"), mid_pos + Vector2(-15, -10), str(weight), HORIZONTAL_ALIGNMENT_CENTER, 30, 24)

# =======================================================
# GRAPH OPERATIONS
# =======================================================

func _show_add_vertex_dialog():
	if vertex_count >= max_vertices:
		show_feedback("Maximum %d vertices reached!" % max_vertices, Color.RED, get_global_mouse_position())
		return
	add_vertex_spinbox.value = 50
	add_vertex_dialog.popup_centered()

func _on_add_vertex_confirmed():
	var value = int(add_vertex_spinbox.value)
	
	if _vertex_value_exists(value):
		show_feedback("Vertex %d already exists!" % value, Color.RED, get_global_mouse_position())
		timeline_log.append("[color=red]Add vertex failed: %d already exists[/color]" % value)
		return
	
	vertices.append(value)
	vertex_count += 1
	operation_count += 1
	
	_calculate_circle_positions()
	
	var my_font = load("res://assets/font/Planes_ValMore.ttf")
	var node = VERTEX_SCENE.instantiate()
	graph_container.add_child(node)
	node.position = vertex_positions[vertex_count - 1]
	node.set_value(value)
	node.modulate = Color(1, 1, 1, 1)
	
	var click_btn = Button.new()
	click_btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	click_btn.modulate.a = 0.0
	click_btn.mouse_filter = Control.MOUSE_FILTER_STOP
	click_btn.pressed.connect(_on_vertex_clicked.bind(vertex_count - 1))
	node.add_child(click_btn)
	
	vertex_nodes.append(node)
	
	_reposition_all_vertices()
	
	timeline_log.append("[color=green]Added vertex %d[/color]" % value)
	_add_code_line("ADD_VERTEX", vertex_count - 1, value)
	_update_stats_label()
	_update_indicators()
	_update_processes_label()
	add_vertex_dialog.hide()
	
	show_feedback("Vertex %d added!" % value, Color.GREEN, get_global_mouse_position())

func _show_remove_vertex_dialog():
	if vertex_count <= min_vertices:
		show_feedback("Minimum %d vertices required!" % min_vertices, Color.RED, get_global_mouse_position())
		return
	remove_vertex_spinbox.value = vertices[0] if vertex_count > 0 else 50
	remove_vertex_dialog.popup_centered()

func _on_remove_vertex_confirmed():
	var value = int(remove_vertex_spinbox.value)
	var index = _find_vertex_index(value)
	
	if index == -1:
		show_feedback("Vertex %d not found!" % value, Color.RED, get_global_mouse_position())
		return
	
	operation_count += 1
	
	# Remove all edges connected to this vertex
	var to_remove = []
	for key in edges.keys():
		var parts = key.split(",")
		var u = int(parts[0])
		var v = int(parts[1])
		if u == index or v == index:
			to_remove.append(key)
	
	for key in to_remove:
		edges.erase(key)
		edge_count -= 1
		timeline_log.append("[color=orange]Removed edge %s[/color]" % key)
	
	# Remove vertex
	vertices.remove_at(index)
	vertex_count -= 1
	
	# Update edges indices
	var new_edges = {}
	for key in edges.keys():
		var parts = key.split(",")
		var u = int(parts[0])
		var v = int(parts[1])
		var weight = edges[key]
		
		if u > index:
			u -= 1
		if v > index:
			v -= 1
		# Only add if both indices are valid
		if u < vertex_count and v < vertex_count:
			new_edges["%d,%d" % [min(u, v), max(u, v)]] = weight
	
	edges = new_edges
	
	# Remove node and rebuild click handlers
	var node = vertex_nodes[index]
	node.queue_free()
	vertex_nodes.remove_at(index)
	
	# Rebuild click handlers for all remaining nodes to update indices
	for i in range(vertex_count):
		if i < vertex_nodes.size() and vertex_nodes[i]:
			# Remove old click button
			var old_click_btn = vertex_nodes[i].get_node_or_null("ClickButton")
			if old_click_btn:
				old_click_btn.queue_free()
			# Add new click button with updated index
			var click_btn = Button.new()
			click_btn.name = "ClickButton"
			click_btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			click_btn.modulate.a = 0.0
			click_btn.mouse_filter = Control.MOUSE_FILTER_STOP
			click_btn.pressed.connect(_on_vertex_clicked.bind(i))
			vertex_nodes[i].add_child(click_btn)
	
	_calculate_circle_positions()
	_reposition_all_vertices()
	
	timeline_log.append("[color=orange]Removed vertex %d[/color]" % value)
	_add_code_line("REMOVE_VERTEX", index, value)
	_update_stats_label()
	_update_indicators()
	_update_processes_label()
	remove_vertex_dialog.hide()
	
	# Reset any waiting algorithm states
	waiting_for_vertex = false
	waiting_for_target = false
	current_algorithm = ""
	source_vertex_index = -1
	target_vertex_index = -1
	prim_start_index = -1
	
	show_feedback("Vertex %d removed!" % value, Color.ORANGE, get_global_mouse_position())

func _reposition_all_vertices():
	for i in range(vertex_count):
		if i < vertex_nodes.size() and vertex_nodes[i]:
			var tween = create_tween()
			tween.tween_property(vertex_nodes[i], "position", vertex_positions[i], ANIM_SPEED)
	queue_redraw()

func _debug_dialog_structure():
	print("=== DEBUG: add_edge_dialog structure ===")
	print("add_edge_dialog: ", add_edge_dialog)
	
	# Try to find nodes at different paths
	var test1 = add_edge_dialog.get_node_or_null("MarginContainer")
	print("MarginContainer: ", test1)
	
	if test1:
		var test2 = test1.get_node_or_null("VBoxContainer")
		print("VBoxContainer: ", test2)
		if test2:
			var test3 = test2.get_node_or_null("ScrollContainer")
			print("ScrollContainer: ", test3)
			if test3:
				var test4 = test3.get_node_or_null("EdgeGrid")
				print("EdgeGrid: ", test4)

func _show_add_edge_dialog():
	if vertex_count < 2:
		show_feedback("Need at least 2 vertices to add an edge!", Color.RED, get_global_mouse_position())
		return
	
	# Debug - print dialog structure
	_debug_dialog_structure()
	
	# Reset selection
	selected_edge_u = -1
	selected_edge_v = -1
	
	# Clear any existing highlight
	for btn in add_edge_buttons:
		if is_instance_valid(btn):
			btn.modulate = Color(1, 1, 1, 1)
	
	# Refresh buttons
	_update_edge_buttons()
	add_edge_weight_spinbox.value = 50
	add_edge_dialog.popup_centered()

func _add_edge(u: int, v: int, weight: int):
	if u == v:
		show_feedback("Cannot connect vertex to itself!", Color.RED, get_global_mouse_position())
		return
	
	if _edge_exists(u, v):
		show_feedback("Edge already exists!", Color.RED, get_global_mouse_position())
		return
	
	var key = "%d,%d" % [min(u, v), max(u, v)]
	edges[key] = weight
	edge_count += 1
	operation_count += 1
	
	timeline_log.append("[color=green]Added edge %d-%d with weight %d[/color]" % [vertices[u], vertices[v], weight])
	_add_code_line("ADD_EDGE", u, vertices[u])
	_add_code_line("ADD_EDGE", v, vertices[v])
	_update_stats_label()
	_update_indicators()
	_update_processes_label()
	queue_redraw()
	
	show_feedback("Edge %d-%d added!" % [vertices[u], vertices[v]], Color.GREEN, get_global_mouse_position())

func _show_remove_edge_dialog():
	if edge_count == 0:
		show_feedback("No edges to remove!", Color.RED, get_global_mouse_position())
		return
	_update_remove_edge_list()
	remove_edge_dialog.popup_centered()

func _on_remove_edge_confirmed():
	var selected = remove_edge_list.get_selected_items()
	if selected.is_empty():
		show_feedback("Please select an edge to remove!", Color.YELLOW, get_global_mouse_position())
		return
	
	var item_text = remove_edge_list.get_item_text(selected[0])
	var parts = item_text.split(" ")
	var edge_parts = parts[0].split("-")
	
	var u_val = int(edge_parts[0])
	var v_val = int(edge_parts[1])
	var u = _find_vertex_index(u_val)
	var v = _find_vertex_index(v_val)
	
	if u != -1 and v != -1:
		var key = "%d,%d" % [min(u, v), max(u, v)]
		if edges.has(key):
			edges.erase(key)
			edge_count -= 1
			operation_count += 1
			timeline_log.append("[color=orange]Removed edge %d-%d[/color]" % [u_val, v_val])
			_add_code_line("REMOVE_EDGE", u, u_val)
			_update_stats_label()
			_update_indicators()
			_update_processes_label()
			queue_redraw()
			show_feedback("Edge %d-%d removed!" % [u_val, v_val], Color.ORANGE, get_global_mouse_position())
	
	remove_edge_dialog.hide()

func _on_edit_edge_confirmed():
	var selected = edit_edge_list.get_selected_items()
	if selected.is_empty():
		show_feedback("Please select an edge to edit!", Color.YELLOW, get_global_mouse_position())
		return
	
	var item_text = edit_edge_list.get_item_text(selected[0])
	var parts = item_text.split(" ")
	var edge_parts = parts[0].split("-")
	
	var u_val = int(edge_parts[0])
	var v_val = int(edge_parts[1])
	var u = _find_vertex_index(u_val)
	var v = _find_vertex_index(v_val)
	
	if u != -1 and v != -1:
		var key = "%d,%d" % [min(u, v), max(u, v)]
		if edges.has(key):
			var old_weight = edges[key]
			var new_weight = int(edit_edge_weight_spinbox.value)
			edges[key] = new_weight
			operation_count += 1
			timeline_log.append("[color=orange]Updated edge %d-%d weight: %d → %d[/color]" % [u_val, v_val, old_weight, new_weight])
			_add_code_line("EDIT_EDGE", u, u_val)
			_update_stats_label()
			queue_redraw()
			show_feedback("Edge weight updated to %d!" % new_weight, Color.GREEN, get_global_mouse_position())
	
	edit_edge_dialog.hide()

func _show_edit_edge_dialog():
	if edge_count == 0:
		show_feedback("No edges to edit!", Color.RED, get_global_mouse_position())
		return
	_update_edit_edge_list()
	edit_edge_weight_spinbox.value = 50
	edit_edge_dialog.popup_centered()


# =======================================================
# ALGORITHMS
# =======================================================

func _start_algorithm(algo: String):
	print("=== _start_algorithm called with algo=", algo, " ===")
	
	if is_animating:
		show_feedback("Please wait, another operation is in progress...", Color.YELLOW, get_global_mouse_position())
		return
	
	if vertex_count == 0:
		show_feedback("Graph is empty! Add vertices first.", Color.RED, get_global_mouse_position())
		return
	
	current_algorithm = algo
	waiting_for_vertex = true
	source_vertex_index = -1
	target_vertex_index = -1
	prim_start_index = -1
	
	print("State after algorithm start: waiting_for_vertex=", waiting_for_vertex, " current_algorithm=", current_algorithm)
	
	if algo == "bfs" or algo == "dfs":
		instruction_label.text = "Click the STARTING vertex for %s" % algo.to_upper()
		show_feedback("Click a vertex to start %s traversal" % algo.to_upper(), Color.CYAN, get_global_mouse_position())
	elif algo == "dijkstra":
		waiting_for_target = false
		instruction_label.text = "Click the SOURCE vertex"
		show_feedback("Click the source vertex", Color.CYAN, get_global_mouse_position())
		print("Dijkstra waiting for source vertex")
	elif algo == "prim":
		instruction_label.text = "Click the STARTING vertex for Prim's algorithm"
		show_feedback("Click a starting vertex for Prim's MST", Color.CYAN, get_global_mouse_position())

func _start_traversal_from(start: int):
	waiting_for_vertex = false
	_disable_buttons(true)
	
	if current_algorithm == "bfs":
		_bfs_animate(start)
	else:
		_dfs_animate(start)

func _bfs_animate(start: int):
	show_feedback("Starting BFS from vertex %d..." % vertices[start], Color.CYAN, vertex_nodes[start].global_position)
	timeline_log.append("[color=purple]BFS traversal starting from vertex %d[/color]" % vertices[start])
	
	var queue = [start]
	var visited = []
	var visited_set = {}
	var order = []
	
	visited_set[start] = true
	
	while queue.size() > 0:
		var current = queue.pop_front()
		order.append(current)
		
		var neighbors = []
		for key in edges.keys():
			var parts = key.split(",")
			var u = int(parts[0])
			var v = int(parts[1])
			if u == current:
				neighbors.append(v)
			elif v == current:
				neighbors.append(u)
		
		neighbors.sort()
		for neighbor in neighbors:
			if not visited_set.has(neighbor):
				visited_set[neighbor] = true
				queue.append(neighbor)
	
	_animate_vertex_sequence(order, "BFS traversal complete!")

func _dfs_animate(start: int):
	show_feedback("Starting DFS from vertex %d..." % vertices[start], Color.CYAN, vertex_nodes[start].global_position)
	timeline_log.append("[color=purple]DFS traversal starting from vertex %d[/color]" % vertices[start])
	
	var stack = [start]
	var visited_set = {}
	var order = []
	
	while stack.size() > 0:
		var current = stack.pop_back()
		if visited_set.has(current):
			continue
		visited_set[current] = true
		order.append(current)
		
		var neighbors = []
		for key in edges.keys():
			var parts = key.split(",")
			var u = int(parts[0])
			var v = int(parts[1])
			if u == current:
				neighbors.append(v)
			elif v == current:
				neighbors.append(u)
		
		neighbors.sort()
		neighbors.reverse()
		for neighbor in neighbors:
			if not visited_set.has(neighbor):
				stack.append(neighbor)
	
	_animate_vertex_sequence(order, "DFS traversal complete!")

func _animate_vertex_sequence(order: Array, completion_message: String):
	if order.is_empty():
		_disable_buttons(false)
		instruction_label.text = completion_message
		await get_tree().create_timer(FADE_DURATION).timeout
		_reset_vertex_colors()
		instruction_label.text = ""
		return
	
	var current = order.pop_front()
	if current < vertex_nodes.size() and vertex_nodes[current]:
		_pulse_vertex(current)
		show_feedback("Visiting vertex %d" % vertices[current], Color.CYAN, vertex_nodes[current].global_position)
		timeline_log.append("[color=cyan]Visited vertex %d[/color]" % vertices[current])
	
	await get_tree().create_timer(HIGHLIGHT_DURATION).timeout
	
	if current < vertex_nodes.size() and vertex_nodes[current]:
		vertex_nodes[current].mark_visited()
	
	_animate_vertex_sequence(order, completion_message)

func _dijkstra_animate(source: int, target: int):
	print("=== _dijkstra_animate called with source=", source, " target=", target, " ===")
	_disable_buttons(true)
	show_feedback("Finding shortest path from %d to %d..." % [vertices[source], vertices[target]], Color.CYAN, vertex_nodes[source].global_position)
	timeline_log.append("[color=purple]Dijkstra: Shortest path from %d to %d[/color]" % [vertices[source], vertices[target]])
	
	# Pulse the source vertex
	_pulse_vertex(source)
	await get_tree().create_timer(0.5).timeout
	
	var dist = {}
	var prev = {}
	var unvisited = []
	
	for i in range(vertex_count):
		dist[i] = INF
		prev[i] = -1
		unvisited.append(i)
	
	dist[source] = 0
	
	while unvisited.size() > 0:
		var current = -1
		var min_dist = INF
		for u in unvisited:
			if dist[u] < min_dist:
				min_dist = dist[u]
				current = u
		
		print("Current selected: ", current, " min_dist: ", min_dist)
		
		if current == -1:
			break
		
		if current == target:
			break
		
		unvisited.erase(current)
		
		# Pulse the vertex being processed
		if current != source:
			_pulse_vertex(current)
			await get_tree().create_timer(0.3).timeout
		
		# Get neighbors using edges dictionary
		var neighbors = []
		for key in edges.keys():
			var parts = key.split(",")
			var u = int(parts[0])
			var v = int(parts[1])
			if u == current:
				neighbors.append(v)
			elif v == current:
				neighbors.append(u)
		
		print("Neighbors of ", current, ": ", neighbors)
		
		for neighbor in neighbors:
			# Make sure neighbor is valid
			if neighbor >= vertex_count:
				continue
			var key = "%d,%d" % [min(current, neighbor), max(current, neighbor)]
			if edges.has(key):
				var weight = edges[key]
				var alt = dist[current] + weight
				print("  neighbor ", neighbor, " weight: ", weight, " alt: ", alt, " current dist: ", dist[neighbor])
				if alt < dist[neighbor]:
					dist[neighbor] = alt
					prev[neighbor] = current
					print("  Updated dist[", neighbor, "] to ", alt)
	
	# Reconstruct path
	var path = []
	var current_node = target
	while current_node != -1:
		path.push_front(current_node)
		current_node = prev.get(current_node, -1)
	
	print("Path found: ", path)
	
	if path.size() <= 1:
		show_feedback("No path found from %d to %d!" % [vertices[source], vertices[target]], Color.RED, get_global_mouse_position())
		timeline_log.append("[color=red]No path from %d to %d[/color]" % [vertices[source], vertices[target]])
		_disable_buttons(false)
		# Reset algorithm states
		current_algorithm = ""
		source_vertex_index = -1
		target_vertex_index = -1
		waiting_for_vertex = false
		waiting_for_target = false
		return
	
	_animate_path(path, "Shortest path distance: %d" % dist[target])

func _prim_animate(start: int):
	_disable_buttons(true)
	show_feedback("Building Minimum Spanning Tree from vertex %d..." % vertices[start], Color.CYAN, vertex_nodes[start].global_position)
	timeline_log.append("[color=purple]Prim's algorithm starting from vertex %d[/color]" % vertices[start])
	
	var in_mst = []
	var edge_weights = {}
	var parent = {}
	var key_value = {}
	
	for i in range(vertex_count):
		in_mst.append(false)
		key_value[i] = INF
		parent[i] = -1
	
	key_value[start] = 0
	
	# Add pulse animation for start vertex
	_pulse_vertex(start)
	
	for _count in range(vertex_count):
		var u = -1
		var min_key = INF
		for i in range(vertex_count):
			if not in_mst[i] and key_value[i] < min_key:
				min_key = key_value[i]
				u = i
		
		if u == -1:
			break
		
		# Pulse the vertex being added to MST
		_pulse_vertex(u)
		await get_tree().create_timer(0.3).timeout
		
		in_mst[u] = true
		
		if parent[u] != -1:
			var key = "%d,%d" % [min(parent[u], u), max(parent[u], u)]
			edge_weights[key] = true
			# Highlight the edge being added
			_highlight_edge_temporary(parent[u], u)
			await get_tree().create_timer(0.5).timeout
		
		var neighbors = []
		for key in edges.keys():
			var parts = key.split(",")
			var u_idx = int(parts[0])
			var v_idx = int(parts[1])
			if u_idx == u:
				neighbors.append(v_idx)
			elif v_idx == u:
				neighbors.append(u_idx)
		
		for v in neighbors:
			var key = "%d,%d" % [min(u, v), max(u, v)]
			var weight = edges[key]
			if not in_mst[v] and weight < key_value[v]:
				key_value[v] = weight
				parent[v] = u
	
	var mst_edges = []
	for key in edge_weights.keys():
		mst_edges.append(key)
	
	_animate_mst_edges(mst_edges, "MST total weight: %d" % _calculate_mst_weight(mst_edges))

func _pulse_vertex(index: int):
	if index < vertex_nodes.size() and vertex_nodes[index]:
		var node = vertex_nodes[index]
		var original_scale = node.scale
		var tween = create_tween()
		tween.tween_property(node, "scale", original_scale * 1.3, 0.2)
		tween.tween_property(node, "scale", original_scale, 0.2)
		# Mark as processing temporarily
		node.mark_processing()
		# Reset color after pulse - ensure scale returns to 1,1
		await get_tree().create_timer(0.4).timeout
		node.reset_color()
		node.scale = Vector2(1, 1)  # FORCE reset scale

func _highlight_edge_temporary(u: int, v: int):
	# Force a redraw to show the edge highlight
	# For now, just pulse the vertices
	_pulse_vertex(u)
	_pulse_vertex(v)

func _animate_path(path: Array, completion_message: String):
	if path.is_empty():
		_disable_buttons(false)
		instruction_label.text = completion_message
		await get_tree().create_timer(FADE_DURATION).timeout
		_reset_vertex_colors()
		instruction_label.text = ""
		return
	
	var current = path.pop_front()
	# Safety check
	if current < 0 or current >= vertex_nodes.size() or vertex_nodes[current] == null:
		_animate_path(path, completion_message)
		return
		
	vertex_nodes[current].mark_found()
	show_feedback("Visiting vertex %d" % vertices[current], Color.GREEN, vertex_nodes[current].global_position)
	
	await get_tree().create_timer(HIGHLIGHT_DURATION).timeout
	_animate_path(path, completion_message)

func _animate_mst_edges(edges_list: Array, completion_message: String):
	if edges_list.is_empty():
		_disable_buttons(false)
		instruction_label.text = completion_message
		await get_tree().create_timer(FADE_DURATION).timeout
		_reset_vertex_colors()
		instruction_label.text = ""
		return
	
	var edge_key = edges_list.pop_front()
	var parts = edge_key.split(",")
	var u = int(parts[0])
	var v = int(parts[1])
	
	# Safety check
	if u >= 0 and u < vertex_nodes.size() and v >= 0 and v < vertex_nodes.size() and vertex_nodes[u] and vertex_nodes[v]:
		vertex_nodes[u].mark_found()
		vertex_nodes[v].mark_found()
		show_feedback("Adding edge %d-%d to MST" % [vertices[u], vertices[v]], Color.GREEN, (vertex_nodes[u].global_position + vertex_nodes[v].global_position) / 2)
		timeline_log.append("[color=green]Added edge %d-%d to MST[/color]" % [vertices[u], vertices[v]])
	
	await get_tree().create_timer(HIGHLIGHT_DURATION).timeout
	_animate_mst_edges(edges_list, completion_message)

func _reset_vertex_colors():
	for i in range(vertex_count):
		if i < vertex_nodes.size() and vertex_nodes[i]:
			vertex_nodes[i].reset_color()
			# Also reset scale to normal
			vertex_nodes[i].scale = Vector2(1, 1)

# =======================================================
# GRAPH UTILITIES
# =======================================================

func _vertex_value_exists(value: int) -> bool:
	for v in vertices:
		if v == value:
			return true
	return false

func _find_vertex_index(value: int) -> int:
	for i in range(vertices.size()):
		if vertices[i] == value:
			return i
	return -1

func _edge_exists(u: int, v: int) -> bool:
	var key = "%d,%d" % [min(u, v), max(u, v)]
	return edges.has(key)

func _has_cycle() -> bool:
	if vertex_count == 0:
		return false
	
	var visited = {}
	var parent = {}
	
	for i in range(vertex_count):
		if not visited.has(i):
			if _dfs_cycle_detect(i, -1, visited, parent):
				return true
	return false

func _dfs_cycle_detect(node: int, par: int, visited: Dictionary, parent: Dictionary) -> bool:
	visited[node] = true
	parent[node] = par
	
	var neighbors = []
	for key in edges.keys():
		var parts = key.split(",")
		var u = int(parts[0])
		var v = int(parts[1])
		if u == node:
			neighbors.append(v)
		elif v == node:
			neighbors.append(u)
	
	for neighbor in neighbors:
		if not visited.has(neighbor):
			if _dfs_cycle_detect(neighbor, node, visited, parent):
				return true
		elif neighbor != par:
			return true
	return false

func _is_connected() -> bool:
	if vertex_count == 0:
		return true
	
	var visited = {}
	var stack = [0]
	
	while stack.size() > 0:
		var current = stack.pop_back()
		if visited.has(current):
			continue
		visited[current] = true
		
		var neighbors = []
		for key in edges.keys():
			var parts = key.split(",")
			var u = int(parts[0])
			var v = int(parts[1])
			if u == current:
				neighbors.append(v)
			elif v == current:
				neighbors.append(u)
		
		for neighbor in neighbors:
			if not visited.has(neighbor):
				stack.append(neighbor)
	
	return visited.size() == vertex_count

func _calculate_mst_weight(edges_list: Array) -> int:
	var total = 0
	for key in edges_list:
		if edges.has(key):
			total += edges[key]
	return total

func _update_indicators():
	var has_cycle = _has_cycle()
	var connected = _is_connected()
	
	if cycle_indicator:
		if has_cycle:
			cycle_indicator.modulate = Color(0, 1, 0, 1)
		else:
			cycle_indicator.modulate = Color(0.3, 0.3, 0.3, 1)
	
	if connectivity_indicator:
		if connected and vertex_count > 0:
			connectivity_indicator.modulate = Color(1, 0.5, 0.8, 1)
		else:
			connectivity_indicator.modulate = Color(0.3, 0.3, 0.3, 1)

func _disable_buttons(disabled: bool):
	is_animating = disabled
	vertex_btn.disabled = disabled
	edge_btn.disabled = disabled
	traverse_btn.disabled = disabled
	dijkstra_btn.disabled = disabled
	prim_btn.disabled = disabled
	simulate_new_btn.disabled = disabled
	end_sim_btn.disabled = disabled
	timeline_btn.disabled = false

# =======================================================
# UI UPDATE FUNCTIONS
# =======================================================

func _update_stats_label():
	if compare_label:
		compare_label.text = "V: %d | E: %d" % [vertex_count, edge_count]

func _update_processes_label():
	if status_label:
		status_label.text = "Operations: %d" % operation_count

func _connect_buttons():
	vertex_btn.pressed.connect(_show_vertex_menu)
	edge_btn.pressed.connect(_show_edge_menu)
	traverse_btn.pressed.connect(_show_traverse_menu)
	dijkstra_btn.pressed.connect(_start_dijkstra)
	prim_btn.pressed.connect(_start_prim)
	timeline_btn.pressed.connect(_on_timeline_pressed)
	simulate_new_btn.pressed.connect(_on_simulate_new_pressed)
	end_sim_btn.pressed.connect(_on_end_sim_button_pressed)

func _show_vertex_menu():
	if is_animating:
		show_feedback("Please wait...", Color.YELLOW, get_global_mouse_position())
		return
	vertex_menu.position = get_global_mouse_position()
	vertex_menu.popup()

func _show_edge_menu():
	if is_animating:
		show_feedback("Please wait...", Color.YELLOW, get_global_mouse_position())
		return
	edge_menu.position = get_global_mouse_position()
	edge_menu.popup()

func _show_traverse_menu():
	if is_animating:
		show_feedback("Please wait...", Color.YELLOW, get_global_mouse_position())
		return
	traverse_menu.position = get_global_mouse_position()
	traverse_menu.popup()

func _start_dijkstra():
	if is_animating:
		show_feedback("Please wait...", Color.YELLOW, get_global_mouse_position())
		return
	_start_algorithm("dijkstra")

func _start_prim():
	if is_animating:
		show_feedback("Please wait...", Color.YELLOW, get_global_mouse_position())
		return
	_start_algorithm("prim")

func _on_simulate_new_pressed():
	if not is_simulation_active:
		show_feedback("Simulation already ended!", Color.YELLOW, get_global_mouse_position())
		return
	sim_confirmation.show()

func _on_yes_pressed():
	sim_confirmation.hide()
	sim_success.show()
	await get_tree().create_timer(0.5).timeout
	sim_success.hide()
	
	_show_config_modal()
	is_simulation_active = true
	operation_count = 0
	_disable_buttons(false)
	timeline_btn.disabled = false
	
	timeline_log.clear()
	code_lines.clear()
	_add_code_line("INITIAL", 0, 0)
	_update_stats_label()
	_update_processes_label()

func _on_no_pressed():
	sim_confirmation.hide()

func _on_end_sim_button_pressed():
	if is_simulation_active:
		end_confirmation.popup_centered()
	else:
		show_feedback("Simulation already ended!", Color.YELLOW, get_global_mouse_position())

func _end_simulation():
	btn_sound.play()
	is_simulation_active = false
	
	_disable_buttons(true)
	end_sim_btn.disabled = true
	
	timeline_log.append("[color=red]--- SIMULATION ENDED ---[/color]")
	_add_code_line("SIMULATION_END", 0, 0)
	_update_processes_label()
	
	if status_label:
		status_label.text = "Simulation ended. Total operations: %d" % operation_count
	
	if complete_popup:
		process_label.text = "Simulation Complete!\n\nTotal operations: %d\nVertices: %d\nEdges: %d" % [operation_count, vertex_count, edge_count]
		complete_popup.popup_centered()
		
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")
	
	end_confirmation.hide()

# =======================================================
# TIMELINE FUNCTIONS
# =======================================================

func _on_timeline_pressed():
	btn_sound.play()
	if timeline_popup.visible:
		timeline_popup.hide()
	else:
		var display_log = []
		if timeline_log.is_empty():
			display_log.append("No operations yet")
		else:
			display_log = timeline_log.duplicate()
		
		if timeline_label:
			timeline_label.bbcode_enabled = true
			timeline_label.bbcode_text = "\n".join(display_log)
		
		timeline_popup.popup_centered()
		
		await get_tree().process_frame
		await get_tree().process_frame
		
		var scroll_container = timeline_popup.get_node_or_null("MainVBox/ScrollContainer")
		if scroll_container:
			var v_scroll = scroll_container.get_v_scroll_bar()
			if v_scroll:
				scroll_container.scroll_vertical = v_scroll.max_value

func _update_timeline_display():
	pass

func _on_timeline_close_pressed():
	btn_sound.play()
	timeline_popup.hide()

# =======================================================
# CONFIGURATION MODAL
# =======================================================

func _show_config_modal():
	config_modal.show()
	_set_main_ui_enabled(false)

func _on_config_yes_pressed():
	btn_sound.play()
	config_modal.hide()
	_show_config_size_modal()

func _show_config_size_modal():
	config_size_modal.show()
	size_input.min_value = min_vertices
	size_input.max_value = max_vertices
	size_input.value = 5
	
	# Ensure buttons are connected
	if size_back_btn and not size_back_btn.is_connected("pressed", _on_size_back_pressed):
		size_back_btn.pressed.connect(_on_size_back_pressed)
	if size_next_btn and not size_next_btn.is_connected("pressed", _on_size_next_pressed):
		size_next_btn.pressed.connect(_on_size_next_pressed)

func _on_size_next_pressed():
	btn_sound.play()
	var size = int(size_input.value)
	if size < min_vertices or size > max_vertices:
		if Queue_full:
			Queue_full.show()
			if anim_sprite: anim_sprite.play("default")
			await get_tree().create_timer(2.0).timeout
			Queue_full.hide()
		return
	config_size_modal.hide()
	_show_config_elements_modal()


func _show_config_elements_modal():
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
		var label = Label.new()
		label.text = "Vertex %d" % (i + 1)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var line_edit = LineEdit.new()
		line_edit.placeholder_text = "1-99"
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
	
	# Ensure buttons are connected
	if elements_back_btn and not elements_back_btn.is_connected("pressed", _on_elements_back_pressed):
		elements_back_btn.pressed.connect(_on_elements_back_pressed)
	if elements_done_btn and not elements_done_btn.is_connected("pressed", _on_elements_done_pressed):
		elements_done_btn.pressed.connect(_on_elements_done_pressed)

func _on_input_text_changed(new_text: String, line_edit: LineEdit):
	if not new_text.is_valid_int() and new_text != "":
		line_edit.text = new_text.trim_suffix(new_text[-1])
		line_edit.set_caret_column(line_edit.text.length())

func _on_elements_done_pressed():
	btn_sound.play()
	var arr: Array[int] = []
	var used = {}
	for le in element_inputs:
		var val = 0
		if le.text.is_valid_int():
			val = int(le.text)
		else:
			val = randi_range(1, 99)
		# Check for duplicates within the input
		while used.has(val):
			val = randi_range(1, 99)
		used[val] = true
		arr.append(val)
	config_elements_modal.hide()
	_set_main_ui_enabled(true)
	help_btn.show()
	_initialize_graph(arr)

func _on_config_no_pressed():
	btn_sound.play()
	config_modal.hide()
	# Generate random graph with 5 vertices
	var count = 5
	var arr: Array[int] = []
	var used = {}
	for i in range(count):
		var val
		while true:
			val = randi_range(1, 99)
			if not used.has(val):
				used[val] = true
				break
		arr.append(val)
	_set_main_ui_enabled(true)
	help_btn.show()
	_initialize_graph(arr)

func _on_size_back_pressed():
	btn_sound.play()
	config_size_modal.hide()
	config_modal.show()


func _on_elements_back_pressed():
	btn_sound.play()
	config_elements_modal.hide()
	config_size_modal.show()

# =======================================================
# CODE GENERATION
# =======================================================

func _add_code_line(op: String, index: int, value: int):
	code_lines.append("%s|%d|%d" % [op, index, value])

func _generate_code_for_language(lang: String) -> String:
	match lang:
		"python": return _gen_python_code()
		"java": return _gen_java_code()
		"c": return _gen_c_code()
		_: return _gen_cpp_code()

func _gen_cpp_code() -> String:
	var code = "/* Graph Operations Simulation - Undirected Weighted Graph */\n"
	code += "#include <iostream>\n#include <vector>\n#include <queue>\n#include <stack>\n#include <climits>\nusing namespace std;\n\n"
	code += "typedef pair<int, int> pii;\n\n"
	code += "void printGraph(vector<vector<pii>>& adj, int V) {\n"
	code += "    cout << \"Current Graph:\" << endl;\n"
	code += "    for(int i = 0; i < V; i++) {\n"
	code += "        cout << \"Vertex \" << i << \" connected to: \";\n"
	code += "        for(auto& edge : adj[i]) {\n"
	code += "            cout << \"(\" << edge.first << \", w:\" << edge.second << \") \";\n"
	code += "        }\n"
	code += "        cout << endl;\n"
	code += "    }\n"
	code += "    cout << endl;\n"
	code += "}\n\n"
	code += "void addEdge(vector<vector<pii>>& adj, int u, int v, int w) {\n"
	code += "    adj[u].push_back({v, w});\n"
	code += "    adj[v].push_back({u, w});\n"
	code += "    cout << \"Added edge \" << u << \"-\" << v << \" with weight \" << w << endl;\n"
	code += "    printGraph(adj, adj.size());\n"
	code += "}\n\n"
	code += "void removeEdge(vector<vector<pii>>& adj, int u, int v) {\n"
	code += "    for(int i = 0; i < adj[u].size(); i++) {\n"
	code += "        if(adj[u][i].first == v) {\n"
	code += "            adj[u].erase(adj[u].begin() + i);\n"
	code += "            break;\n"
	code += "        }\n"
	code += "    }\n"
	code += "    for(int i = 0; i < adj[v].size(); i++) {\n"
	code += "        if(adj[v][i].first == u) {\n"
	code += "            adj[v].erase(adj[v].begin() + i);\n"
	code += "            break;\n"
	code += "        }\n"
	code += "    }\n"
	code += "    cout << \"Removed edge \" << u << \"-\" << v << endl;\n"
	code += "    printGraph(adj, adj.size());\n"
	code += "}\n\n"
	code += "void bfs(vector<vector<pii>>& adj, int start, int V) {\n"
	code += "    vector<bool> visited(V, false);\n"
	code += "    queue<int> q;\n"
	code += "    q.push(start);\n"
	code += "    visited[start] = true;\n"
	code += "    cout << \"BFS Traversal starting from vertex \" << start << \": \";\n"
	code += "    while(!q.empty()) {\n"
	code += "        int u = q.front(); q.pop();\n"
	code += "        cout << u << \" \";\n"
	code += "        for(auto& edge : adj[u]) {\n"
	code += "            int v = edge.first;\n"
	code += "            if(!visited[v]) {\n"
	code += "                visited[v] = true;\n"
	code += "                q.push(v);\n"
	code += "                cout << \"\\n  Enqueued vertex \" << v << endl;\n"
	code += "            }\n"
	code += "        }\n"
	code += "    }\n"
	code += "    cout << endl << endl;\n"
	code += "}\n\n"
	code += "void dfsUtil(vector<vector<pii>>& adj, int u, vector<bool>& visited) {\n"
	code += "    visited[u] = true;\n"
	code += "    cout << u << \" \";\n"
	code += "    for(auto& edge : adj[u]) {\n"
	code += "        int v = edge.first;\n"
	code += "        if(!visited[v]) {\n"
	code += "            cout << \"\\n  Moving to vertex \" << v << endl;\n"
	code += "            dfsUtil(adj, v, visited);\n"
	code += "        }\n"
	code += "    }\n"
	code += "}\n\n"
	code += "void dfs(vector<vector<pii>>& adj, int start, int V) {\n"
	code += "    vector<bool> visited(V, false);\n"
	code += "    cout << \"DFS Traversal starting from vertex \" << start << \": \";\n"
	code += "    dfsUtil(adj, start, visited);\n"
	code += "    cout << endl << endl;\n"
	code += "}\n\n"
	code += "void dijkstra(vector<vector<pii>>& adj, int src, int target, int V) {\n"
	code += "    vector<int> dist(V, INT_MAX);\n"
	code += "    vector<int> prev(V, -1);\n"
	code += "    priority_queue<pii, vector<pii>, greater<pii>> pq;\n"
	code += "    dist[src] = 0;\n"
	code += "    pq.push({0, src});\n"
	code += "    cout << \"Finding shortest path from \" << src << \" to \" << target << endl;\n\n"
	code += "    while(!pq.empty()) {\n"
	code += "        int u = pq.top().second;\n"
	code += "        int d = pq.top().first;\n"
	code += "        pq.pop();\n"
	code += "        if(d > dist[u]) continue;\n"
	code += "        cout << \"  Processing vertex \" << u << \" (distance \" << dist[u] << \")\" << endl;\n"
	code += "        for(auto& edge : adj[u]) {\n"
	code += "            int v = edge.first;\n"
	code += "            int w = edge.second;\n"
	code += "            if(dist[u] + w < dist[v]) {\n"
	code += "                dist[v] = dist[u] + w;\n"
	code += "                prev[v] = u;\n"
	code += "                pq.push({dist[v], v});\n"
	code += "                cout << \"    Updated distance to \" << v << \": \" << dist[v] << endl;\n"
	code += "            }\n"
	code += "        }\n"
	code += "    }\n\n"
	code += "    // Reconstruct path\n"
	code += "    vector<int> path;\n"
	code += "    int curr = target;\n"
	code += "    while(curr != -1) {\n"
	code += "        path.push_back(curr);\n"
	code += "        curr = prev[curr];\n"
	code += "    }\n"
	code += "    reverse(path.begin(), path.end());\n"
	code += "    cout << \"Shortest path: \";\n"
	code += "    for(int i = 0; i < path.size(); i++) {\n"
	code += "        cout << path[i];\n"
	code += "        if(i < path.size()-1) cout << \" -> \";\n"
	code += "    }\n"
	code += "    cout << \" (Total distance: \" << dist[target] << \")\" << endl << endl;\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    int V = %d;\n" % vertex_count
	code += "    vector<vector<pii>> adj(V);\n"
	code += "    cout << \"=== GRAPH SIMULATION ===\" << endl;\n"
	code += "    cout << \"Total vertices: \" << V << endl << endl;\n\n"
	
	# Add operations from code_lines
	for line in code_lines:
		var parts = line.split("|")
		if parts[0] == "ADD_VERTEX":
			code += "    // Vertex %d added\n" % int(parts[2])
		elif parts[0] == "ADD_EDGE":
			code += "    addEdge(adj, %d, %d, %d);\n" % [int(parts[1]), int(parts[2]), 50]
		elif parts[0] == "REMOVE_EDGE":
			code += "    removeEdge(adj, %d, %d);\n" % [int(parts[1]), int(parts[2])]
		elif parts[0] == "TRAVERSE_START":
			code += "    bfs(adj, 0, V);\n"
		elif parts[0] == "SEARCH_FOUND":
			code += "    dijkstra(adj, %d, %d, V);\n" % [source_vertex_index, target_vertex_index]
	
	code += "    return 0;\n}\n"
	return code

func _gen_python_code() -> String:
	var code = "# Graph Operations Simulation - Undirected Weighted Graph\n\n"
	code += "from collections import deque\nimport heapq\n\n"
	code += "def print_graph(adj):\n"
	code += "    print(\"Current Graph:\")\n"
	code += "    for u in adj:\n"
	code += "        print(f\"  Vertex {u}: {adj[u]}\")\n"
	code += "    print()\n\n"
	code += "def add_edge(adj, u, v, w):\n"
	code += "    adj[u].append((v, w))\n"
	code += "    adj[v].append((u, w))\n"
	code += "    print(f\"Added edge {u}-{v} with weight {w}\")\n"
	code += "    print_graph(adj)\n\n"
	code += "def bfs(adj, start):\n"
	code += "    visited = set()\n"
	code += "    q = deque([start])\n"
	code += "    visited.add(start)\n"
	code += "    order = []\n"
	code += "    print(f\"BFS Traversal starting from vertex {start}:\")\n"
	code += "    while q:\n"
	code += "        u = q.popleft()\n"
	code += "        order.append(u)\n"
	code += "        print(f\"  Visiting vertex {u}\")\n"
	code += "        for v, w in adj[u]:\n"
	code += "            if v not in visited:\n"
	code += "                visited.add(v)\n"
	code += "                q.append(v)\n"
	code += "                print(f\"    Enqueued vertex {v}\")\n"
	code += "    print(f\"BFS Order: {order}\\n\")\n\n"
	code += "def dijkstra(adj, src, target):\n"
	code += "    dist = {v: float('inf') for v in adj}\n"
	code += "    prev = {v: None for v in adj}\n"
	code += "    dist[src] = 0\n"
	code += "    pq = [(0, src)]\n"
	code += "    print(f\"Finding shortest path from {src} to {target}\")\n"
	code += "    while pq:\n"
	code += "        d, u = heapq.heappop(pq)\n"
	code += "        if d > dist[u]:\n"
	code += "            continue\n"
	code += "        print(f\"  Processing vertex {u} (distance {dist[u]})\")\n"
	code += "        for v, w in adj[u]:\n"
	code += "            if dist[u] + w < dist[v]:\n"
	code += "                dist[v] = dist[u] + w\n"
	code += "                prev[v] = u\n"
	code += "                heapq.heappush(pq, (dist[v], v))\n"
	code += "                print(f\"    Updated distance to {v}: {dist[v]}\")\n"
	code += "    path = []\n"
	code += "    curr = target\n"
	code += "    while curr is not None:\n"
	code += "        path.append(curr)\n"
	code += "        curr = prev[curr]\n"
	code += "    path.reverse()\n"
	code += "    print(f\"Shortest path: {' -> '.join(map(str, path))} (Total distance: {dist[target]})\\n\")\n\n"
	code += "adj = {}\n"
	for v in vertices:
		code += "adj[%d] = []\n" % v
	
	for key in edges.keys():
		var parts = key.split(",")
		var u = int(parts[0])
		var v = int(parts[1])
		code += "add_edge(adj, %d, %d, %d)\n" % [vertices[u], vertices[v], edges[key]]
	
	code += "\nbfs(adj, 0)\n"
	if source_vertex_index != -1 and target_vertex_index != -1:
		code += "dijkstra(adj, %d, %d)\n" % [vertices[source_vertex_index], vertices[target_vertex_index]]
	
	return code

func _gen_java_code() -> String:
	var code = "/* Graph Operations Simulation - Undirected Weighted Graph */\n"
	code += "import java.util.*;\n\n"
	code += "class Graph {\n"
	code += "    private int V;\n"
	code += "    private List<List<int[]>> adj;\n\n"
	code += "    Graph(int v) {\n"
	code += "        V = v;\n"
	code += "        adj = new ArrayList<>();\n"
	code += "        for(int i = 0; i < V; i++)\n"
	code += "            adj.add(new ArrayList<>());\n"
	code += "    }\n\n"
	code += "    void printGraph() {\n"
	code += "        System.out.println(\"Current Graph:\");\n"
	code += "        for(int i = 0; i < V; i++) {\n"
	code += "            System.out.print(\"Vertex \" + i + \" connected to: \");\n"
	code += "            for(int[] edge : adj.get(i)) {\n"
	code += "                System.out.print(\"(\" + edge[0] + \", w:\" + edge[1] + \") \");\n"
	code += "            }\n"
	code += "            System.out.println();\n"
	code += "        }\n"
	code += "        System.out.println();\n"
	code += "    }\n\n"
	code += "    void addEdge(int u, int v, int w) {\n"
	code += "        adj.get(u).add(new int[]{v, w});\n"
	code += "        adj.get(v).add(new int[]{u, w});\n"
	code += "        System.out.println(\"Added edge \" + u + \"-\" + v + \" with weight \" + w);\n"
	code += "        printGraph();\n"
	code += "    }\n\n"
	code += "    void removeEdge(int u, int v) {\n"
	code += "        for(int i = 0; i < adj.get(u).size(); i++) {\n"
	code += "            if(adj.get(u).get(i)[0] == v) {\n"
	code += "                adj.get(u).remove(i);\n"
	code += "                break;\n"
	code += "            }\n"
	code += "        }\n"
	code += "        for(int i = 0; i < adj.get(v).size(); i++) {\n"
	code += "            if(adj.get(v).get(i)[0] == u) {\n"
	code += "                adj.get(v).remove(i);\n"
	code += "                break;\n"
	code += "            }\n"
	code += "        }\n"
	code += "        System.out.println(\"Removed edge \" + u + \"-\" + v);\n"
	code += "        printGraph();\n"
	code += "    }\n\n"
	code += "    void bfs(int start) {\n"
	code += "        boolean[] visited = new boolean[V];\n"
	code += "        Queue<Integer> q = new LinkedList<>();\n"
	code += "        q.add(start);\n"
	code += "        visited[start] = true;\n"
	code += "        System.out.println(\"BFS Traversal starting from vertex \" + start + \":\");\n"
	code += "        while(!q.isEmpty()) {\n"
	code += "            int u = q.poll();\n"
	code += "            System.out.println(\"  Visiting vertex \" + u);\n"
	code += "            for(int[] edge : adj.get(u)) {\n"
	code += "                int v = edge[0];\n"
	code += "                if(!visited[v]) {\n"
	code += "                    visited[v] = true;\n"
	code += "                    q.add(v);\n"
	code += "                    System.out.println(\"    Enqueued vertex \" + v);\n"
	code += "                }\n"
	code += "            }\n"
	code += "        }\n"
	code += "        System.out.println();\n"
	code += "    }\n\n"
	code += "    void dfsUtil(int u, boolean[] visited) {\n"
	code += "        visited[u] = true;\n"
	code += "        System.out.println(\"  Visiting vertex \" + u);\n"
	code += "        for(int[] edge : adj.get(u)) {\n"
	code += "            int v = edge[0];\n"
	code += "            if(!visited[v]) {\n"
	code += "                System.out.println(\"    Moving to vertex \" + v);\n"
	code += "                dfsUtil(v, visited);\n"
	code += "            }\n"
	code += "        }\n"
	code += "    }\n\n"
	code += "    void dfs(int start) {\n"
	code += "        boolean[] visited = new boolean[V];\n"
	code += "        System.out.println(\"DFS Traversal starting from vertex \" + start + \":\");\n"
	code += "        dfsUtil(start, visited);\n"
	code += "        System.out.println();\n"
	code += "    }\n\n"
	code += "    void dijkstra(int src, int target) {\n"
	code += "        int[] dist = new int[V];\n"
	code += "        int[] prev = new int[V];\n"
	code += "        Arrays.fill(dist, Integer.MAX_VALUE);\n"
	code += "        Arrays.fill(prev, -1);\n"
	code += "        PriorityQueue<int[]> pq = new PriorityQueue<>(Comparator.comparingInt(a -> a[1]));\n"
	code += "        dist[src] = 0;\n"
	code += "        pq.add(new int[]{src, 0});\n"
	code += "        System.out.println(\"Finding shortest path from \" + src + \" to \" + target);\n\n"
	code += "        while(!pq.isEmpty()) {\n"
	code += "            int[] curr = pq.poll();\n"
	code += "            int u = curr[0];\n"
	code += "            int d = curr[1];\n"
	code += "            if(d > dist[u]) continue;\n"
	code += "            System.out.println(\"  Processing vertex \" + u + \" (distance \" + dist[u] + \")\");\n"
	code += "            for(int[] edge : adj.get(u)) {\n"
	code += "                int v = edge[0];\n"
	code += "                int w = edge[1];\n"
	code += "                if(dist[u] + w < dist[v]) {\n"
	code += "                    dist[v] = dist[u] + w;\n"
	code += "                    prev[v] = u;\n"
	code += "                    pq.add(new int[]{v, dist[v]});\n"
	code += "                    System.out.println(\"    Updated distance to \" + v + \": \" + dist[v]);\n"
	code += "                }\n"
	code += "            }\n"
	code += "        }\n\n"
	code += "        List<Integer> path = new ArrayList<>();\n"
	code += "        int curr = target;\n"
	code += "        while(curr != -1) {\n"
	code += "            path.add(curr);\n"
	code += "            curr = prev[curr];\n"
	code += "        }\n"
	code += "        Collections.reverse(path);\n"
	code += "        System.out.print(\"Shortest path: \");\n"
	code += "        for(int i = 0; i < path.size(); i++) {\n"
	code += "            System.out.print(path.get(i));\n"
	code += "            if(i < path.size()-1) System.out.print(\" -> \");\n"
	code += "        }\n"
	code += "        System.out.println(\" (Total distance: \" + dist[target] + \")\\n\");\n"
	code += "    }\n"
	code += "}\n\n"
	code += "public class Main {\n"
	code += "    public static void main(String[] args) {\n"
	code += "        int V = %d;\n" % vertex_count
	code += "        Graph g = new Graph(V);\n"
	code += "        System.out.println(\"=== GRAPH SIMULATION ===\");\n"
	code += "        System.out.println(\"Total vertices: \" + V + \"\\n\");\n\n"
	
	for key in edges.keys():
		var parts = key.split(",")
		var u = int(parts[0])
		var v = int(parts[1])
		code += "        g.addEdge(%d, %d, %d);\n" % [u, v, edges[key]]
	
	if source_vertex_index != -1 and target_vertex_index != -1:
		code += "\n        g.dijkstra(%d, %d);\n" % [source_vertex_index, target_vertex_index]
	
	code += "    }\n}\n"
	return code

func _gen_c_code() -> String:
	var code = "/* Graph Operations Simulation - Undirected Weighted Graph */\n"
	code += "#include <stdio.h>\n#include <stdlib.h>\n#include <limits.h>\n#include <stdbool.h>\n\n"
	code += "#define MAX_V %d\n\n" % max_vertices
	code += "int adj[MAX_V][MAX_V];\n"
	code += "int V;\n\n"
	code += "void initGraph(int v) {\n"
	code += "    V = v;\n"
	code += "    for(int i = 0; i < V; i++)\n"
	code += "        for(int j = 0; j < V; j++)\n"
	code += "            adj[i][j] = 0;\n"
	code += "    printf(\"Graph initialized with %%d vertices\\n\\n\", V);\n"
	code += "}\n\n"
	code += "void printGraph() {\n"
	code += "    printf(\"Current Graph:\\n\");\n"
	code += "    for(int i = 0; i < V; i++) {\n"
	code += "        printf(\"Vertex %%d connected to: \", i);\n"
	code += "        for(int j = 0; j < V; j++) {\n"
	code += "            if(adj[i][j] > 0) {\n"
	code += "                printf(\"(%%d, w:%%d) \", j, adj[i][j]);\n"
	code += "            }\n"
	code += "        }\n"
	code += "        printf(\"\\n\");\n"
	code += "    }\n"
	code += "    printf(\"\\n\");\n"
	code += "}\n\n"
	code += "void addEdge(int u, int v, int w) {\n"
	code += "    adj[u][v] = w;\n"
	code += "    adj[v][u] = w;\n"
	code += "    printf(\"Added edge %%d-%%d with weight %%d\\n\", u, v, w);\n"
	code += "    printGraph();\n"
	code += "}\n\n"
	code += "void removeEdge(int u, int v) {\n"
	code += "    adj[u][v] = 0;\n"
	code += "    adj[v][u] = 0;\n"
	code += "    printf(\"Removed edge %%d-%%d\\n\", u, v);\n"
	code += "    printGraph();\n"
	code += "}\n\n"
	code += "void bfs(int start) {\n"
	code += "    bool visited[MAX_V] = {false};\n"
	code += "    int queue[MAX_V], front = 0, rear = 0;\n"
	code += "    queue[rear++] = start;\n"
	code += "    visited[start] = true;\n"
	code += "    printf(\"BFS Traversal starting from vertex %%d:\\n\", start);\n"
	code += "    while(front < rear) {\n"
	code += "        int u = queue[front++];\n"
	code += "        printf(\"  Visiting vertex %%d\\n\", u);\n"
	code += "        for(int v = 0; v < V; v++) {\n"
	code += "            if(adj[u][v] > 0 && !visited[v]) {\n"
	code += "                visited[v] = true;\n"
	code += "                queue[rear++] = v;\n"
	code += "                printf(\"    Enqueued vertex %%d\\n\", v);\n"
	code += "            }\n"
	code += "        }\n"
	code += "    }\n"
	code += "    printf(\"\\n\");\n"
	code += "}\n\n"
	code += "void dfsUtil(int u, bool visited[]) {\n"
	code += "    visited[u] = true;\n"
	code += "    printf(\"  Visiting vertex %%d\\n\", u);\n"
	code += "    for(int v = 0; v < V; v++) {\n"
	code += "        if(adj[u][v] > 0 && !visited[v]) {\n"
	code += "            printf(\"    Moving to vertex %%d\\n\", v);\n"
	code += "            dfsUtil(v, visited);\n"
	code += "        }\n"
	code += "    }\n"
	code += "}\n\n"
	code += "void dfs(int start) {\n"
	code += "    bool visited[MAX_V] = {false};\n"
	code += "    printf(\"DFS Traversal starting from vertex %%d:\\n\", start);\n"
	code += "    dfsUtil(start, visited);\n"
	code += "    printf(\"\\n\");\n"
	code += "}\n\n"
	code += "void dijkstra(int src, int target) {\n"
	code += "    int dist[MAX_V];\n"
	code += "    int prev[MAX_V];\n"
	code += "    bool visited[MAX_V] = {false};\n"
	code += "    for(int i = 0; i < V; i++) {\n"
	code += "        dist[i] = INT_MAX;\n"
	code += "        prev[i] = -1;\n"
	code += "    }\n"
	code += "    dist[src] = 0;\n"
	code += "    printf(\"Finding shortest path from %%d to %%d\\n\", src, target);\n\n"
	code += "    for(int count = 0; count < V - 1; count++) {\n"
	code += "        int u = -1, minDist = INT_MAX;\n"
	code += "        for(int i = 0; i < V; i++) {\n"
	code += "            if(!visited[i] && dist[i] < minDist) {\n"
	code += "                minDist = dist[i];\n"
	code += "                u = i;\n"
	code += "            }\n"
	code += "        }\n"
	code += "        if(u == -1) break;\n"
	code += "        visited[u] = true;\n"
	code += "        printf(\"  Processing vertex %%d (distance %%d)\\n\", u, dist[u]);\n"
	code += "        for(int v = 0; v < V; v++) {\n"
	code += "            if(adj[u][v] > 0 && !visited[v]) {\n"
	code += "                if(dist[u] + adj[u][v] < dist[v]) {\n"
	code += "                    dist[v] = dist[u] + adj[u][v];\n"
	code += "                    prev[v] = u;\n"
	code += "                    printf(\"    Updated distance to %%d: %%d\\n\", v, dist[v]);\n"
	code += "                }\n"
	code += "            }\n"
	code += "        }\n"
	code += "    }\n\n"
	code += "    int path[MAX_V], pathLen = 0;\n"
	code += "    int curr = target;\n"
	code += "    while(curr != -1) {\n"
	code += "        path[pathLen++] = curr;\n"
	code += "        curr = prev[curr];\n"
	code += "    }\n"
	code += "    printf(\"Shortest path: \");\n"
	code += "    for(int i = pathLen-1; i >= 0; i--) {\n"
	code += "        printf(\"%%d\", path[i]);\n"
	code += "        if(i > 0) printf(\" -> \");\n"
	code += "    }\n"
	code += "    printf(\" (Total distance: %%d)\\n\\n\", dist[target]);\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    initGraph(%d);\n" % vertex_count
	code += "    printf(\"=== GRAPH SIMULATION ===\\n\");\n\n"
	
	for key in edges.keys():
		var parts = key.split(",")
		var u = int(parts[0])
		var v = int(parts[1])
		code += "    addEdge(%d, %d, %d);\n" % [u, v, edges[key]]
	
	if source_vertex_index != -1 and target_vertex_index != -1:
		code += "\n    dijkstra(%d, %d);\n" % [source_vertex_index, target_vertex_index]
	
	code += "    return 0;\n}\n"
	return code

# =======================================================
# COMPILER INTEGRATION
# =======================================================

func _setup_compiler():
	if compile_btn:
		if compile_btn.is_connected("pressed", _on_compile_button_pressed):
			compile_btn.disconnect("pressed", _on_compile_button_pressed)
		compile_btn.pressed.connect(_on_compile_button_pressed)
	
	if compiler_output_popup == null:
		var popup_scene = preload("res://scene/CompilerOutput.tscn")
		compiler_output_popup = popup_scene.instantiate()
		add_child(compiler_output_popup)
		compiler_output_popup.recompile_requested.connect(_on_recompile_requested)
		compiler_output_popup.closed.connect(_on_compiler_output_closed)

func _on_compile_button_pressed():
	btn_sound.play()
	var code = _generate_code_for_language(current_code_language)
	
	if compiler_output_popup and compiler_output_popup.has_cached_result(current_code_language):
		var cached = compiler_output_popup.get_cached_result(current_code_language)
		var fake_response = {
			"output": cached.output,
			"error": cached.error,
			"memory": cached.memory,
			"cpu": cached.cpu
		}
		compiler_output_popup.show_output(current_code_language, fake_response, self, false)
		show_feedback("Using cached result!", Color.YELLOW, Vector2(200, 200))
	else:
		_compile_code(code)

func _compile_code(code: String):
	show_feedback("Compiling...", Color.YELLOW, Vector2(200, 200))
	var keys = API_KEYS[current_code_language]
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_compile_completed.bind(http_request, current_code_language))
	var url = "https://api.jdoodle.com/v1/execute"
	var headers = ["Content-Type: application/json"]
	var api_language = current_code_language
	if current_code_language == "python":
		api_language = "python3"
	var body = JSON.new().stringify({
		"clientId": keys["clientId"],
		"clientSecret": keys["clientSecret"],
		"script": code,
		"language": api_language,
		"versionIndex": _get_version_index(current_code_language)
	})
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		show_feedback("Network error!", Color.RED, Vector2(200, 200))

func _get_version_index(lang: String) -> String:
	match lang:
		"cpp": return "5"
		"c": return "4"
		"java": return "4"
		"python": return "4"
		_: return "0"

func _on_compile_completed(result, response_code, headers, body, http_request, language: String):
	http_request.queue_free()
	if response_code != 200:
		show_feedback("API Error: " + str(response_code), Color.RED, Vector2(200, 200))
		return
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	if parse_result != OK:
		show_feedback("Parse error!", Color.RED, Vector2(200, 200))
		return
	var response = json.data
	if compiler_output_popup:
		compiler_output_popup.show_output(language, response, self, false)

func _on_recompile_requested(language: String):
	var code = _generate_code_for_language(language)
	_compile_code(code)

func _on_compiler_output_closed():
	print("Compiler output closed")

func reset_cache_for_scene():
	if compiler_output_popup:
		compiler_output_popup.reset_cache_for_scene()

# =======================================================
# CODE POPUP FUNCTIONS
# =======================================================

func _on_show_cpp_pressed():
	btn_sound.play()
	if complete_popup: complete_popup.hide()
	await get_tree().process_frame
	_show_cpp_popup()

func _show_cpp_popup():
	match current_code_language:
		"cpp": current_tutorial_data = cpp_tutorial_data
		"python": current_tutorial_data = python_tutorial_data
		"java": current_tutorial_data = java_tutorial_data
		"c": current_tutorial_data = c_tutorial_data
	
	var code = _generate_code_for_language(current_code_language)
	
	if cpp_label:
		cpp_label.bbcode_enabled = true
		cpp_label.text = code
	
	cpp_popup.popup_centered()
	cpp_tutorial_step = 0
	
	if cpp_next_btn and not cpp_next_btn.is_connected("pressed", _on_cpp_next_pressed):
		cpp_next_btn.pressed.connect(_on_cpp_next_pressed)
	
	_update_cpp_tutorial()

func _on_cpp_next_pressed():
	btn_sound.play()
	cpp_tutorial_step += 1
	if cpp_tutorial_step >= current_tutorial_data.size():
		cpp_tutorial_step = 0
	_update_cpp_tutorial()

func _update_cpp_tutorial():
	if current_tutorial_data.is_empty(): return
	var data = current_tutorial_data[cpp_tutorial_step]
	
	if cpp_explanation_lbl:
		cpp_explanation_lbl.bbcode_enabled = true
		cpp_explanation_lbl.text = data["text"]
	
	if cpp_label:
		var code = _generate_code_for_language(current_code_language)
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
			cpp_scroll.scroll_vertical = indices[0] * 20

func _on_cpp_close_pressed():
	btn_sound.play()
	cpp_popup.hide()

func _on_cpp_code_button_pressed():
	btn_sound.play()
	_show_cpp_popup()

func _on_complete_ok_pressed():
	btn_sound.play()
	complete_popup.hide()

func _on_try_again_pressed():
	btn_sound.play()
	result_popup.hide()
	_show_config_modal()
	is_simulation_active = true
	_disable_buttons(false)

func _on_back_pressed():
	btn_sound.play()
	result_popup.hide()

func _on_translate_code_pressed():
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()

func _connect_language_buttons():
	if cpp_lang_btn: cpp_lang_btn.pressed.connect(_on_cpp_lang_pressed)
	if python_lang_btn: python_lang_btn.pressed.connect(_on_python_lang_pressed)
	if java_lang_btn: java_lang_btn.pressed.connect(_on_java_lang_pressed)
	if c_lang_btn: c_lang_btn.pressed.connect(_on_c_lang_pressed)

func _on_cpp_lang_pressed():
	_set_language("cpp")

func _on_python_lang_pressed():
	_set_language("python")

func _on_java_lang_pressed():
	_set_language("java")

func _on_c_lang_pressed():
	_set_language("c")

func _set_language(lang: String):
	btn_sound.play()
	current_code_language = lang
	_show_cpp_popup()

# =======================================================
# INTRO & TUTORIAL FUNCTIONS
# =======================================================

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

func start_tutorial():
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	_set_main_ui_enabled(false)
	tutorial_overlay.show()
	dim_bg.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{"node": vertex_btn, "title": "VERTEX OPTIONS", "text": "Add or remove vertices (max 7, min 3).", "action": "highlight"},
		{"node": edge_btn, "title": "EDGE OPTIONS", "text": "Add, remove, or edit edge weights.", "action": "highlight"},
		{"node": traverse_btn, "title": "TRAVERSE", "text": "BFS or DFS traversal animation.", "action": "highlight"},
		{"node": dijkstra_btn, "title": "DIJKSTRA", "text": "Find shortest path between two vertices.", "action": "highlight"},
		{"node": prim_btn, "title": "PRIM'S MST", "text": "Build Minimum Spanning Tree.", "action": "highlight"},
		{"node": cycle_indicator, "title": "CYCLE INDICATOR", "text": "Lights up green when graph has a cycle.", "action": "highlight"},
		{"node": connectivity_indicator, "title": "CONNECTIVITY", "text": "Lights up pink when graph is fully connected.", "action": "highlight"},
		{"node": timeline_btn, "title": "TIMELINE", "text": "View operation history.", "action": "highlight"}
	]
	show_tutorial_step()

func show_tutorial_step():
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
	tutorial_next.show()

func _on_next_button_pressed():
	tutorial_sequence_index += 1
	show_tutorial_step()

func end_tutorial():
	tutorial_in_progress = false
	tutorial_overlay.hide()
	_set_main_ui_enabled(true)
	if pointer_sprite:
		pointer_sprite.hide()
		if pointer_sprite.has_meta("tween"):
			pointer_sprite.get_meta("tween").kill()

func _on_help_button_pressed():
	btn_sound.play()
	start_tutorial()

func _ensure_connected(node: Node, signal_name: String, method: Callable):
	if node and not node.is_connected(signal_name, method):
		node.connect(signal_name, method)

func _set_main_ui_enabled(enabled: bool):
	if vertex_btn: vertex_btn.disabled = not enabled
	if edge_btn: edge_btn.disabled = not enabled
	if traverse_btn: traverse_btn.disabled = not enabled
	if dijkstra_btn: dijkstra_btn.disabled = not enabled
	if prim_btn: prim_btn.disabled = not enabled
	if timeline_btn: timeline_btn.disabled = not enabled
	if simulate_new_btn: simulate_new_btn.disabled = not enabled
	if end_sim_btn: end_sim_btn.disabled = not enabled

func show_feedback(text: String, color: Color, position: Vector2):
	var feedback_scene = preload("res://scene/FeedbackLabel.tscn")
	var label = feedback_scene.instantiate()
	label.text = text
	label.modulate = color
	label.global_position = position
	add_child(label)
	var anim_player: AnimationPlayer = label.get_node("AnimationPlayer")
	anim_player.play("notification_pop")
	anim_player.animation_finished.connect(_on_feedback_animation_finished.bind(label))

func _on_feedback_animation_finished(_anim_name: String, label: Node):
	label.queue_free()
