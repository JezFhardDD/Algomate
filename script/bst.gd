extends Control

# =======================================================
#   BST LECTURE MODE - Binary Search Tree Simulation
# =======================================================

# --- COMPILER INTEGRATION ---
@onready var compiler_output_popup: PopupPanel = null
@onready var compile_btn: Button = $CppPopup/VBoxContainer/HBoxContainer2/CompileButton

# --- MAIN BUTTONS (Updated for BST) ---
@onready var insert_btn: Button = $VBoxContainer/InsertButton
@onready var delete_btn: Button = $VBoxContainer/DeleteButton
@onready var search_btn: Button = $VBoxContainer/SortButton  # Reused as Search
@onready var traverse_btn: Button = $VBoxContainer/WaitingElements  # Reused as Traverse
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew
@onready var end_sim_btn: Button = $VBoxContainer/EndSimulationButton

# --- LABELS & CONTAINERS ---
@onready var status_label: Label = $HBoxContainer/Label
@onready var compare_label: Label = $HBoxContainer2/Label
@onready var array_container: Control = $TreeContainer
@onready var dequeued_container: Control = $DequeuedContainer

# --- POPUPS ---
@onready var waiting_popup: Popup = $WaitingPopup
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label
@onready var timeline_popup: Popup = $TimelinePopup
@onready var timeline_label: RichTextLabel = $TimelinePopup/MainVBox/ScrollContainer/VBoxContainer/RichTextLabel
@onready var timeline_close_btn: Button = $TimelinePopup/MainVBox/CloseButton

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
const RESULT_POPUP_SCENE := preload("res://scene/ResultPopup.tscn")

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
@onready var clock = $AnimatedSprite2D
@onready var time_up_popup: PopupPanel = $TimeUpPopup

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
# BST VARIABLES
# =======================================================

# Tree data
var main_array: Array[int] = []  # Values at each index (0 = empty)
var tree_nodes: Array = []  # Node instances
var node_positions: Array = []  # Pre-calculated positions
var index_labels: Array[Label] = []

# BST state
var is_simulation_active: bool = true
var timeline_log: Array[String] = []
var code_lines: Array[String] = []
var current_code_language: String = "cpp"

# Animation
var ANIM_SPEED: float = 0.2
var is_animating: bool = false
var traversal_timer: SceneTreeTimer = null
var traversal_queue: Array[int] = []
var is_traversing: bool = false

# UI elements
var INDEX_LABEL_OFFSET_X: float = 100.0
var INDEX_LABEL_OFFSET_Y: float = 25.0

# Input dialogs
var insert_dialog: ConfirmationDialog
var insert_spinbox: SpinBox
var delete_dialog: ConfirmationDialog
var delete_spinbox: SpinBox
var search_dialog: ConfirmationDialog
var search_spinbox: SpinBox
var traverse_dialog: ConfirmationDialog
var end_confirmation: ConfirmationDialog


#state vars
# BST state
var operation_count: int = 0  # NEW: Track number of operations performed

# Tutorial
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false

# Intro Text
var intro_step: int = 0
var intro_texts = [
	"WELCOME TO BST LECTURE MODE! 🌲\n\nBinary Search Tree (BST) is a tree where:\n• Left child < Parent\n• Right child > Parent\n• No duplicates allowed",
	
	"BST OPERATIONS:\n\n• INSERT: Add a value while maintaining BST property\n• DELETE: Remove a value and restructure the tree\n• SEARCH: Find a value by traversing left/right\n• TRAVERSE: Visit nodes in Inorder/Preorder/Postorder",
	
	"BST RULES:\n\n• All values in LEFT subtree are SMALLER than root\n• All values in RIGHT subtree are LARGER than root\n• Each node follows the same rule recursively\n• This makes searching very efficient: O(log n)!",
	
	"VISUAL GUIDE:\n\n• Numbers inside circles = node values\n• Lines connect parent to children\n• Empty nodes (0) are hidden/gray\n• You can insert/delete values anytime!",
	
	"TREE LIMITATIONS:\n\n• Maximum 7 nodes (complete binary tree layout)\n• Can extend to 4th level if nodes exist\n• 4th level nodes have limited space\n• System will warn if tree becomes too deep"
]

# =======================================================
# RESULT POPUP VARIABLES
# =======================================================
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

# =======================================================
# CODE TUTORIAL DATA
# =======================================================
var cpp_tutorial_step: int = 0
var current_tutorial_data: Array = []

var cpp_tutorial_data = [
	{ "lines": [5, 6, 7, 8], "text": "1. Node Structure:\nEach node has a value and left/right pointers." },
	{ "lines": [12, 13, 14, 15, 16, 17], "text": "2. Insert Operation:\nRecursively find correct position based on BST property." },
	{ "lines": [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], "text": "3. Delete Operation:\nHandles 3 cases: leaf, one child, two children (using inorder successor)." },
	{ "lines": [36, 37, 38, 39, 40], "text": "4. Search Operation:\nTraverse left/right based on value comparison." },
	{ "lines": [43, 44, 45, 46, 47], "text": "5. Inorder Traversal:\nLeft → Root → Right gives sorted order." }
]

var python_tutorial_data = [
	{ "lines": [2, 3, 4, 5, 6], "text": "1. Node Class:\nSimple node structure." },
	{ "lines": [12, 13, 14, 15, 16, 17, 18, 19, 20, 21], "text": "2. Insert Operation:\nInsert while maintaining BST property." },
	{ "lines": [26, 27, 28, 29, 30, 31], "text": "3. Inorder Traversal:\nRecursive traversal." }
]

var java_tutorial_data = [
	{ "lines": [3, 4, 5, 6, 7], "text": "1. Node Class:\nInner class for tree nodes." },
	{ "lines": [12, 13, 14, 15, 16, 17, 18, 19], "text": "2. Insert Method:\nRecursive insertion." },
	{ "lines": [21, 22, 23, 24, 25, 26], "text": "3. Inorder Traversal:\nLeft-Root-Right order." }
]

var c_tutorial_data = [
	{ "lines": [4, 5, 6, 7, 8, 9], "text": "1. Node Structure:\nC struct for BST node." },
	{ "lines": [18, 19, 20, 21, 22, 23], "text": "2. Insert Function:\nRecursive insertion." },
	{ "lines": [26, 27, 28, 29, 30], "text": "3. Inorder Traversal:\nPrints sorted values." }
]

# =======================================================
# DIALOG HELPER FUNCTIONS
# =======================================================

func style_dialog(dialog: ConfirmationDialog, title: String, my_font, bg_texture) -> ConfirmationDialog:
	dialog.title = title
	dialog.min_size = Vector2(500, 280)
	dialog.exclusive = true

	if my_font:
		dialog.add_theme_font_override("title_font", my_font)
	dialog.add_theme_font_size_override("title_font_size", 28)

	var panel_style = StyleBoxTexture.new()
	panel_style.texture = bg_texture
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

func style_button(btn: Button, text: String, my_font, btn_texture) -> Button:
	var btn_style = StyleBoxTexture.new()
	btn_style.texture = btn_texture
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
	if my_font:
		btn.add_theme_font_override("font", my_font)
	btn.add_theme_font_size_override("font_size", 24)
	btn.custom_minimum_size = Vector2(130, 55)
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
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

func create_spinbox(min_val: int, max_val: int, default_val: int, my_font) -> SpinBox:
	var spin = SpinBox.new()
	spin.min_value = min_val
	spin.max_value = max_val
	spin.value = default_val
	spin.custom_minimum_size = Vector2(280, 70)
	spin.alignment = HORIZONTAL_ALIGNMENT_CENTER
	spin.add_theme_constant_override("buttons_vertical_separation", 18)
	spin.add_theme_constant_override("buttons_width", 50)

	var spin_style = StyleBoxTexture.new()
	spin_style.texture = load("res://assets/CONTAINER.png")
	spin_style.texture_margin_left = 12
	spin_style.texture_margin_top = 12
	spin_style.texture_margin_right = 12
	spin_style.texture_margin_bottom = 12
	spin.add_theme_stylebox_override("normal", spin_style)

	var up_btn_style = StyleBoxTexture.new()
	up_btn_style.texture = load("res://assets/BUTTON.png")
	up_btn_style.texture_margin_left = 8
	up_btn_style.texture_margin_top = 8
	up_btn_style.texture_margin_right = 8
	up_btn_style.texture_margin_bottom = 8
	spin.add_theme_stylebox_override("up", up_btn_style)
	spin.add_theme_stylebox_override("down", up_btn_style)

	var line_edit = spin.get_line_edit()
	if line_edit:
		if my_font:
			line_edit.add_theme_font_override("font", my_font)
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
# READY & INITIALIZATION
# =======================================================

func _ready() -> void:
	var back_overlay = preload("res://scenes/back_button_overlay.tscn").instantiate()
	add_child(back_overlay)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	print("BST Lecture Mode initialized")
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
	
	_define_tree_positions()
	
	# Setup containers
	if dequeued_container: dequeued_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if array_container: array_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tex_rect = get_node_or_null("TextureRect")
	if tex_rect: tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
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
	if timeline_close_btn:
		timeline_close_btn.pressed.connect(_on_timeline_close_pressed)
	if complete_ok_btn:
		complete_ok_btn.pressed.connect(_on_complete_ok_pressed)
	if cpp_close_btn:
		cpp_close_btn.pressed.connect(_on_cpp_close_pressed)
	if try_again_btn_root:
		try_again_btn_root.pressed.connect(_on_try_again_pressed)
	if yes_btn:
		yes_btn.pressed.connect(_on_yes_pressed)
	if no_btn:
		no_btn.pressed.connect(_on_no_pressed)
	if timeline_label:
		timeline_label.fit_content = true
		timeline_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		timeline_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		timeline_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	# Setup buttons
	_create_input_dialogs()
	_connect_buttons()
	_connect_language_buttons()
	_setup_compiler()
	
	# Initialize empty tree
	_initialize_empty_tree()
	
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
# DIALOG CREATION (Styled)
# =======================================================

func _create_input_dialogs():
	var my_font = load("res://assets/font/Planes_ValMore.ttf")
	var bg_texture = load("res://assets/BUTTON.png")
	var btn_texture = load("res://assets/BUTTON.png")

	# Create INSERT Dialog
	insert_dialog = style_dialog(ConfirmationDialog.new(), "Insert Value", my_font, bg_texture)
	var insert_vbox = add_content(insert_dialog)

	var insert_label = Label.new()
	insert_label.text = "Enter value to insert (1-999)"
	if my_font:
		insert_label.add_theme_font_override("font", my_font)
	insert_label.add_theme_font_size_override("font_size", 28)
	insert_label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
	insert_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	insert_label.add_theme_constant_override("outline_size", 5)
	insert_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	insert_vbox.add_child(insert_label)

	var spin_center = CenterContainer.new()
	spin_center.custom_minimum_size = Vector2(0, 90)
	insert_vbox.add_child(spin_center)
	insert_spinbox = create_spinbox(1, 999, 50, my_font)
	spin_center.add_child(insert_spinbox)

	var insert_btn_hbox = HBoxContainer.new()
	insert_btn_hbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	insert_btn_hbox.add_theme_constant_override("separation", 40)
	insert_vbox.add_child(insert_btn_hbox)

	var insert_ok = insert_dialog.get_ok_button()
	var insert_cancel = insert_dialog.get_cancel_button()
	insert_ok.get_parent().remove_child(insert_ok)
	insert_cancel.get_parent().remove_child(insert_cancel)
	style_button(insert_ok, "INSERT", my_font, btn_texture)
	style_button(insert_cancel, "CANCEL", my_font, btn_texture)
	insert_btn_hbox.add_child(insert_ok)
	insert_btn_hbox.add_child(insert_cancel)

	add_child(insert_dialog)
	insert_dialog.confirmed.connect(_on_insert_confirmed)
	insert_cancel.pressed.connect(_on_insert_cancel)

	# Create DELETE Dialog
	delete_dialog = style_dialog(ConfirmationDialog.new(), "Delete Value", my_font, bg_texture)
	var delete_vbox = add_content(delete_dialog)

	var delete_label = Label.new()
	delete_label.text = "Enter value to delete"
	if my_font:
		delete_label.add_theme_font_override("font", my_font)
	delete_label.add_theme_font_size_override("font_size", 28)
	delete_label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
	delete_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	delete_label.add_theme_constant_override("outline_size", 5)
	delete_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	delete_vbox.add_child(delete_label)

	var delete_spin_center = CenterContainer.new()
	delete_spin_center.custom_minimum_size = Vector2(0, 90)
	delete_vbox.add_child(delete_spin_center)
	delete_spinbox = create_spinbox(1, 999, 50, my_font)
	delete_spin_center.add_child(delete_spinbox)

	var delete_btn_hbox = HBoxContainer.new()
	delete_btn_hbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	delete_btn_hbox.add_theme_constant_override("separation", 40)
	delete_vbox.add_child(delete_btn_hbox)

	var delete_ok = delete_dialog.get_ok_button()
	var delete_cancel = delete_dialog.get_cancel_button()
	delete_ok.get_parent().remove_child(delete_ok)
	delete_cancel.get_parent().remove_child(delete_cancel)
	style_button(delete_ok, "DELETE", my_font, btn_texture)
	style_button(delete_cancel, "CANCEL", my_font, btn_texture)
	delete_btn_hbox.add_child(delete_ok)
	delete_btn_hbox.add_child(delete_cancel)

	add_child(delete_dialog)
	delete_dialog.confirmed.connect(_on_delete_confirmed)
	delete_cancel.pressed.connect(_on_delete_cancel)

	# Create SEARCH Dialog
	search_dialog = style_dialog(ConfirmationDialog.new(), "Search Value", my_font, bg_texture)
	var search_vbox = add_content(search_dialog)

	var search_label = Label.new()
	search_label.text = "Enter value to search"
	if my_font:
		search_label.add_theme_font_override("font", my_font)
	search_label.add_theme_font_size_override("font_size", 28)
	search_label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
	search_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	search_label.add_theme_constant_override("outline_size", 5)
	search_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	search_vbox.add_child(search_label)

	var search_spin_center = CenterContainer.new()
	search_spin_center.custom_minimum_size = Vector2(0, 90)
	search_vbox.add_child(search_spin_center)
	search_spinbox = create_spinbox(1, 999, 50, my_font)
	search_spin_center.add_child(search_spinbox)

	var search_btn_hbox = HBoxContainer.new()
	search_btn_hbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	search_btn_hbox.add_theme_constant_override("separation", 40)
	search_vbox.add_child(search_btn_hbox)

	var search_ok = search_dialog.get_ok_button()
	var search_cancel = search_dialog.get_cancel_button()
	search_ok.get_parent().remove_child(search_ok)
	search_cancel.get_parent().remove_child(search_cancel)
	style_button(search_ok, "SEARCH", my_font, btn_texture)
	style_button(search_cancel, "CANCEL", my_font, btn_texture)
	search_btn_hbox.add_child(search_ok)
	search_btn_hbox.add_child(search_cancel)

	add_child(search_dialog)
	search_dialog.confirmed.connect(_on_search_confirmed)
	search_cancel.pressed.connect(_on_search_cancel)

	# Create TRAVERSE Dialog - HIDE DEFAULT OK/CANCEL BUTTONS
	traverse_dialog = style_dialog(ConfirmationDialog.new(), "Traversal Options", my_font, bg_texture)
	traverse_dialog.min_size = Vector2(500, 350)
	
	# Hide the default OK/Cancel buttons
	var traverse_ok = traverse_dialog.get_ok_button()
	var traverse_cancel_btn = traverse_dialog.get_cancel_button()
	if traverse_ok:
		traverse_ok.hide()
	if traverse_cancel_btn:
		traverse_cancel_btn.hide()
	
	var traverse_vbox = add_content(traverse_dialog)

	var traverse_label = Label.new()
	traverse_label.text = "Select traversal method"
	if my_font:
		traverse_label.add_theme_font_override("font", my_font)
	traverse_label.add_theme_font_size_override("font_size", 28)
	traverse_label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
	traverse_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	traverse_label.add_theme_constant_override("outline_size", 5)
	traverse_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	traverse_vbox.add_child(traverse_label)

	var options_grid = GridContainer.new()
	options_grid.columns = 2
	options_grid.add_theme_constant_override("h_separation", 40)
	options_grid.add_theme_constant_override("v_separation", 20)
	traverse_vbox.add_child(options_grid)

	var inorder_btn = Button.new()
	style_button(inorder_btn, "INORDER", my_font, btn_texture)
	var preorder_btn = Button.new()
	style_button(preorder_btn, "PREORDER", my_font, btn_texture)
	var postorder_btn = Button.new()
	style_button(postorder_btn, "POSTORDER", my_font, btn_texture)
	var cancel_traverse_btn = Button.new()
	style_button(cancel_traverse_btn, "CANCEL", my_font, btn_texture)

	options_grid.add_child(inorder_btn)
	options_grid.add_child(preorder_btn)
	options_grid.add_child(postorder_btn)
	options_grid.add_child(cancel_traverse_btn)

	inorder_btn.pressed.connect(_on_inorder_pressed)
	preorder_btn.pressed.connect(_on_preorder_pressed)
	postorder_btn.pressed.connect(_on_postorder_pressed)
	cancel_traverse_btn.pressed.connect(_on_traverse_cancel)

	add_child(traverse_dialog)

	# Create END Confirmation Dialog
	end_confirmation = style_dialog(ConfirmationDialog.new(), "End Simulation", my_font, bg_texture)
	var end_vbox = add_content(end_confirmation)

	var end_label = Label.new()
	end_label.text = "Do you really want to end the simulation?"
	if my_font:
		end_label.add_theme_font_override("font", my_font)
	end_label.add_theme_font_size_override("font_size", 28)
	end_label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
	end_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	end_label.add_theme_constant_override("outline_size", 5)
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
	style_button(end_yes, "YES", my_font, btn_texture)
	style_button(end_no, "NO", my_font, btn_texture)
	end_btn_hbox.add_child(end_yes)
	end_btn_hbox.add_child(end_no)

	add_child(end_confirmation)
	end_confirmation.confirmed.connect(_end_simulation)
	end_no.pressed.connect(_on_end_cancel)

# =======================================================
# CANCEL BUTTON HANDLERS
# =======================================================

func _on_insert_cancel():
	insert_dialog.hide()

func _on_delete_cancel():
	delete_dialog.hide()

func _on_search_cancel():
	search_dialog.hide()

func _on_traverse_cancel():
	traverse_dialog.hide()

func _on_end_cancel():
	end_confirmation.hide()

# =======================================================
# TRAVERSAL BUTTON HANDLERS
# =======================================================

func _on_inorder_pressed():
	_start_traversal("inorder")
	traverse_dialog.hide()

func _on_preorder_pressed():
	_start_traversal("preorder")
	traverse_dialog.hide()

func _on_postorder_pressed():
	_start_traversal("postorder")
	traverse_dialog.hide()

# =======================================================
# TREE LAYOUT
# =======================================================

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

func _initialize_empty_tree():
	main_array = []
	for i in range(7):
		main_array.append(0)  # 0 means empty
	
	# Clear existing nodes
	for child in array_container.get_children():
		child.queue_free()
	
	tree_nodes.clear()
	for label in index_labels:
		if is_instance_valid(label):
			label.queue_free()
	index_labels.clear()
	
	var my_font = load("res://assets/font/Planes_ValMore.ttf")
	
	for i in range(7):
		var node = BLOCK_SCENE.instantiate()
		array_container.add_child(node)
		node.position = node_positions[i]
		node.set_value("")
		node.modulate = Color(0.3, 0.3, 0.3, 0.5)
		
		# Invisible button overlay for click editing
		var click_btn = Button.new()
		click_btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		click_btn.modulate.a = 0.0
		click_btn.mouse_filter = Control.MOUSE_FILTER_STOP
		click_btn.pressed.connect(_handle_node_click.bind(i))
		node.add_child(click_btn)
		
		tree_nodes.append(node)
		
		# Index label
		var index_label = Label.new()
		index_label.text = str(i)
		index_label.position = node_positions[i] + Vector2(INDEX_LABEL_OFFSET_X, INDEX_LABEL_OFFSET_Y)
		if my_font:
			index_label.add_theme_font_override("font", my_font)
		index_label.add_theme_font_size_override("font_size", 24)
		index_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5, 1))
		index_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		index_label.add_theme_constant_override("outline_size", 4)
		array_container.add_child(index_label)
		index_labels.append(index_label)
	
	queue_redraw()
	timeline_log.clear()
	code_lines.clear()
	_add_code_line("INITIAL", 0, 0)
	_update_timeline_display()  # ADD THIS LINE
	_update_processes_label()
	
	if status_label:
		status_label.text = "BST Ready - Insert values to start"
	if compare_label:
		compare_label.text = "Operations: 0"
	
	_connect_buttons()

func _handle_node_click(index: int):
	if not is_simulation_active:
		show_feedback("Simulation ended! Click Simulate New to restart.", Color.YELLOW, get_global_mouse_position())
		return
	
	if main_array[index] != 0:
		show_feedback("Node already has value " + str(main_array[index]) + "!", Color.YELLOW, tree_nodes[index].global_position)
		return
	
	# Suggest inserting a value here
	show_feedback("Click INSERT button to add a value here!", Color.CYAN, tree_nodes[index].global_position)

func _draw():
	if tree_nodes.is_empty(): return
	var center_offset = Vector2(32, 32)
	var my_global_pos = get_global_position()
	
	for i in range(tree_nodes.size()):
		if tree_nodes[i] == null: continue
		var start_pos = (tree_nodes[i].global_position + center_offset) - my_global_pos
		
		var left = 2*i + 1
		var right = 2*i + 2
		
		if left < 7 and tree_nodes[left] != null and tree_nodes[left].modulate.a > 0.3:
			var left_node = tree_nodes[left]
			var end_pos = (left_node.global_position + center_offset) - my_global_pos
			draw_line(start_pos, end_pos, Color.WHITE, 4.0)
			
		if right < 7 and tree_nodes[right] != null and tree_nodes[right].modulate.a > 0.3:
			var right_node = tree_nodes[right]
			var end_pos = (right_node.global_position + center_offset) - my_global_pos
			draw_line(start_pos, end_pos, Color.WHITE, 4.0)

# =======================================================
# BST OPERATIONS
# =======================================================

func _on_insert_confirmed():
	btn_sound.play()
	var value = int(insert_spinbox.value)
	
	if not is_simulation_active:
		show_feedback("Simulation ended!", Color.YELLOW, get_global_mouse_position())
		return
	
	# Check if value already exists
	if _value_exists(value):
		show_feedback("Value " + str(value) + " already exists in tree!", Color.RED, get_global_mouse_position())
		timeline_log.append("[color=red]Insert failed: %d already exists[/color]" % value)
		return
	
	# Check if tree is full
	if _is_tree_full():
		show_feedback("Cannot insert - tree is full (max 7 nodes)!", Color.RED, get_global_mouse_position())
		timeline_log.append("[color=red]Insert failed: Tree is full[/color]")
		return
	operation_count += 1
	
	# Find position to insert
	var insert_index = _find_insert_position(value)
	
	if insert_index == -1:
		show_feedback("Cannot insert - no valid position!", Color.RED, get_global_mouse_position())
		return
	
	# Check if inserting at index would create 4th level node (index >= 7)
	if insert_index >= 7:
		show_feedback("Value would create 4th level node - not enough space on screen!", Color.RED, get_global_mouse_position())
		timeline_log.append("[color=red]Insert failed: Would create 4th level node[/color]")
		return
	
	# Insert the value
	main_array[insert_index] = value
	_update_node_visual(insert_index, value)
	
	# Animate
	_animate_node(insert_index)
	
	timeline_log.append("[color=green]Inserted %d at node %d[/color]" % [value, insert_index])
	_add_code_line("INSERT", insert_index, value)
	
	if status_label:
		status_label.text = "Inserted " + str(value) + " at node " + str(insert_index)
	
	_update_stats_label()
	_update_timeline_display()
	_update_processes_label()
	insert_dialog.hide()

func _on_delete_confirmed():
	btn_sound.play()
	var value = int(delete_spinbox.value)
	
	if not is_simulation_active:
		show_feedback("Simulation ended!", Color.YELLOW, get_global_mouse_position())
		return
	
	# Find node with the value
	var node_index = _find_node_by_value(value)
	
	if node_index == -1:
		show_feedback("Value " + str(value) + " not found in tree!", Color.RED, get_global_mouse_position())
		timeline_log.append("[color=red]Delete failed: %d not found[/color]" % value)
		delete_dialog.hide()
		return
	operation_count += 1
	
	# Store old value for feedback
	var old_value = main_array[node_index]
	
	# Perform deletion
	_delete_node(node_index)
	
	timeline_log.append("[color=orange]Deleted %d from node %d[/color]" % [old_value, node_index])
	_add_code_line("DELETE", node_index, old_value)
	
	if status_label:
		status_label.text = "Deleted " + str(old_value) + " from node " + str(node_index)
	
	_update_stats_label()
	_update_timeline_display()
	_update_processes_label() 
	delete_dialog.hide()

func _on_search_confirmed():
	btn_sound.play()
	var value = int(search_spinbox.value)
	
	if not is_simulation_active:
		show_feedback("Simulation ended!", Color.YELLOW, get_global_mouse_position())
		return
	operation_count += 1 
	
	# Search for the value
	var path = _search_path(value)
	
	if path.is_empty():
		show_feedback("Value " + str(value) + " not found in tree!", Color.RED, get_global_mouse_position())
		timeline_log.append("[color=red]Search: %d not found[/color]" % value)
		_add_code_line("SEARCH_NOT_FOUND", 0, value)
		_update_timeline_display()  # ADD THIS LINE
		search_dialog.hide()
		return
	
	# Highlight the path
	_highlight_path(path)
	
	timeline_log.append("[color=green]Search: Found %d at node %d[/color]" % [value, path[-1]])
	_add_code_line("SEARCH_FOUND", path[-1], value)
	_update_timeline_display()  # ADD THIS LINE
	
	if status_label:
		status_label.text = "Found " + str(value) + " at node " + str(path[-1])
	_update_processes_label()
	search_dialog.hide()

func _start_traversal(method: String):
	if not is_simulation_active:
		show_feedback("Simulation ended!", Color.YELLOW, get_global_mouse_position())
		return
	
	if is_traversing:
		show_feedback("Traversal already in progress!", Color.YELLOW, get_global_mouse_position())
		return
	operation_count += 1
	# Get root index (first non-empty node)
	var root = 0
	if main_array[0] == 0:
		show_feedback("Tree is empty!", Color.YELLOW, get_global_mouse_position())
		return
	
	# Generate traversal order
	var order: Array[int] = []
	match method:
		"inorder":
			_inorder_traversal(0, order)
		"preorder":
			_preorder_traversal(0, order)
		"postorder":
			_postorder_traversal(0, order)
	
	if order.is_empty():
		return
	
	traversal_queue = order
	is_traversing = true
	
	timeline_log.append("[color=purple]Starting %s traversal[/color]" % method.to_upper())
	_add_code_line("TRAVERSE_START", 0, 0)
	_update_timeline_display()  # ADD THIS LINE
	
	status_label.text = method.to_upper() + " traversal in progress..."
	_next_traversal_step()
	_update_processes_label()

func _next_traversal_step():
	if not is_traversing or traversal_queue.is_empty():
		_finish_traversal()
		return
	
	var node_idx = traversal_queue.pop_front()
	
	if node_idx < tree_nodes.size() and tree_nodes[node_idx] and main_array[node_idx] != 0:
		_highlight_node_temporary(node_idx)
	
	await get_tree().create_timer(1.5).timeout
	_next_traversal_step()

func _finish_traversal():
	is_traversing = false
	traversal_queue.clear()
	timeline_log.append("[color=purple]Traversal complete[/color]")
	_add_code_line("TRAVERSE_END", 0, 0)
	_update_timeline_display()  # Add this
	status_label.text = "Traversal complete!"

func _end_simulation():
	btn_sound.play()
	is_simulation_active = false
	
	# Disable all buttons
	insert_btn.disabled = true
	delete_btn.disabled = true
	search_btn.disabled = true
	traverse_btn.disabled = true
	timeline_btn.disabled = false
	simulate_new_btn.disabled = false
	end_sim_btn.disabled = true
	
	timeline_log.append("[color=red]--- SIMULATION ENDED ---[/color]")
	_add_code_line("SIMULATION_END", 0, 0)
	_update_timeline_display()
	_update_processes_label()  # Add this
	
	if status_label:
		status_label.text = "Simulation ended. Total operations: %d" % operation_count
	
	# Show completion popup
	if complete_popup:
		var node_count = 0
		for val in main_array:
			if val != 0:
				node_count += 1
		process_label.text = "Simulation Complete!\n\nTotal operations: %d\nNodes in tree: %d" % [operation_count, node_count]
		complete_popup.popup_centered()
		
		if cpp_code_button:
			cpp_code_button.show()
			if code_anim: code_anim.play("default")
	
	end_confirmation.hide()

# =======================================================
# BST HELPER FUNCTIONS
# =======================================================

func _value_exists(value: int) -> bool:
	for i in range(7):
		if main_array[i] == value:
			return true
	return false

func _is_tree_full() -> bool:
	for i in range(7):
		if main_array[i] == 0:
			return false
	return true

func _find_insert_position(value: int) -> int:
	var current = 0
	
	while current < 7:
		if main_array[current] == 0:
			return current
		
		if value < main_array[current]:
			var left = 2 * current + 1
			if left >= 7:
				return -1
			if main_array[left] == 0:
				return left
			current = left
		else:
			var right = 2 * current + 2
			if right >= 7:
				return -1
			if main_array[right] == 0:
				return right
			current = right
	
	return -1

func _find_node_by_value(value: int) -> int:
	var current = 0
	
	while current < 7:
		if main_array[current] == 0:
			break
		if main_array[current] == value:
			return current
		if value < main_array[current]:
			current = 2 * current + 1
		else:
			current = 2 * current + 2
	
	return -1

func _delete_node(index: int):
	var value = main_array[index]
	
	# Count children
	var left = 2 * index + 1
	var right = 2 * index + 2
	var has_left = left < 7 and main_array[left] != 0
	var has_right = right < 7 and main_array[right] != 0
	
	if not has_left and not has_right:
		# Leaf node - simply delete
		main_array[index] = 0
		_update_node_visual(index, 0)
	elif has_left and not has_right:
		# Only left child - replace with left subtree
		_move_subtree(left, index)
		_clear_subtree(left)
	elif not has_left and has_right:
		# Only right child - replace with right subtree
		_move_subtree(right, index)
		_clear_subtree(right)
	else:
		# Two children - find inorder successor (smallest in right subtree)
		var successor = _find_inorder_successor(right)
		if successor != -1:
			# Copy successor value to current node
			main_array[index] = main_array[successor]
			_update_node_visual(index, main_array[index])
			
			# Store the successor's children BEFORE deleting it
			var succ_left = 2 * successor + 1
			var succ_right = 2 * successor + 2
			
			# Delete the successor node
			main_array[successor] = 0
			_update_node_visual(successor, 0)
			
			# Move successor's children to its position if they exist
			if succ_left < 7 and main_array[succ_left] != 0:
				_move_subtree(succ_left, successor)
				_clear_subtree(succ_left)
			if succ_right < 7 and main_array[succ_right] != 0:
				# This shouldn't happen for inorder successor, but just in case
				_move_subtree(succ_right, successor)
				_clear_subtree(succ_right)

func _find_inorder_successor(start: int) -> int:
	var current = start
	while current < 7:
		var left = 2 * current + 1
		if left >= 7 or main_array[left] == 0:
			return current
		current = left
	return -1

func _move_subtree(from: int, to: int):
	if from >= 7 or main_array[from] == 0:
		return
	
	main_array[to] = main_array[from]
	_update_node_visual(to, main_array[to])
	
	var left = 2 * from + 1
	var right = 2 * from + 2
	
	if left < 7 and main_array[left] != 0:
		_move_subtree(left, 2 * to + 1)
	if right < 7 and main_array[right] != 0:
		_move_subtree(right, 2 * to + 2)

func _clear_subtree(index: int):
	if index >= 7 or main_array[index] == 0:
		return
	
	main_array[index] = 0
	_update_node_visual(index, 0)
	
	_clear_subtree(2 * index + 1)
	_clear_subtree(2 * index + 2)

func _search_path(value: int) -> Array[int]:
	var path: Array[int] = []
	var current = 0
	
	while current < 7 and main_array[current] != 0:
		path.append(current)
		if main_array[current] == value:
			return path
		if value < main_array[current]:
			current = 2 * current + 1
		else:
			current = 2 * current + 2
	
	return []

func _inorder_traversal(index: int, order: Array[int]):
	if index >= 7 or main_array[index] == 0:
		return
	_inorder_traversal(2 * index + 1, order)
	order.append(index)
	_inorder_traversal(2 * index + 2, order)

func _preorder_traversal(index: int, order: Array[int]):
	if index >= 7 or main_array[index] == 0:
		return
	order.append(index)
	_preorder_traversal(2 * index + 1, order)
	_preorder_traversal(2 * index + 2, order)

func _postorder_traversal(index: int, order: Array[int]):
	if index >= 7 or main_array[index] == 0:
		return
	_postorder_traversal(2 * index + 1, order)
	_postorder_traversal(2 * index + 2, order)
	order.append(index)

# =======================================================
# VISUAL FUNCTIONS
# =======================================================

func _update_node_visual(index: int, value: int):
	if index >= tree_nodes.size() or tree_nodes[index] == null:
		return
	
	var node = tree_nodes[index]
	if value == 0:
		node.set_value("")
		node.modulate = Color(0.3, 0.3, 0.3, 0.5)
	else:
		node.set_value(str(value))
		node.modulate = Color(1, 1, 1, 1)
	
	queue_redraw()

func _animate_node(index: int):
	if index >= tree_nodes.size() or tree_nodes[index] == null:
		return
	
	var node = tree_nodes[index]
	var original_scale = node.scale
	var tween = create_tween()
	tween.tween_property(node, "scale", original_scale * 1.2, 0.15)
	tween.tween_property(node, "scale", original_scale, 0.15)

func _highlight_path(path: Array[int]):
	if path.is_empty():
		return
	
	_highlight_path_sequential(path, 0)

func _highlight_path_sequential(path: Array[int], index: int):
	if index >= path.size():
		return
	
	var node_idx = path[index]
	if node_idx < tree_nodes.size() and tree_nodes[node_idx]:
		var node = tree_nodes[node_idx]
		var original_scale = node.scale
		
		# Pulse animation
		var tween = create_tween()
		tween.tween_property(node, "scale", original_scale * 1.4, 0.2)
		tween.tween_property(node, "scale", original_scale, 0.2)
		
		# If last node (found), also change color
		if index == path.size() - 1:
			var color_tween = create_tween().set_parallel(true)
			color_tween.tween_property(node, "modulate", Color(0, 1, 0, 1), 0.3)
			color_tween.tween_property(node, "scale", original_scale * 1.5, 0.3)
			await get_tree().create_timer(0.5).timeout
			color_tween.tween_property(node, "modulate", Color(1, 1, 1, 1), 0.3)
			color_tween.tween_property(node, "scale", original_scale, 0.3)
	
	# Wait 1 second before next node
	await get_tree().create_timer(1.0).timeout
	_highlight_path_sequential(path, index + 1)
	
func _highlight_node_temporary(index: int):
	if index >= tree_nodes.size() or tree_nodes[index] == null:
		return
	
	var node = tree_nodes[index]
	var original_modulate = node.modulate
	var original_scale = node.scale
	
	var tween = create_tween()
	tween.tween_property(node, "modulate", Color(1, 0.8, 0, 1), 0.2)
	tween.tween_property(node, "scale", original_scale * 1.3, 0.2)
	tween.tween_property(node, "modulate", original_modulate, 0.2)
	tween.tween_property(node, "scale", original_scale, 0.2)

# =======================================================
# UI UPDATE FUNCTIONS
# =======================================================

func _update_stats_label():
	var count = 0
	for val in main_array:
		if val != 0:
			count += 1
	if compare_label:
		compare_label.text = "Nodes: %d" % count

func _connect_buttons():
	# Connect insert button
	if insert_btn:
		insert_btn.pressed.connect(_on_insert_button_pressed)
	
	# Connect delete button
	if delete_btn:
		delete_btn.pressed.connect(_on_delete_button_pressed)
	
	# Connect search button
	if search_btn:
		search_btn.pressed.connect(_on_search_button_pressed)
	
	# Connect traverse button
	if traverse_btn:
		traverse_btn.pressed.connect(_on_traverse_button_pressed)
	
	# Connect timeline button
	if timeline_btn:
		timeline_btn.pressed.connect(_on_timeline_pressed)
	
	# Connect simulate new button
	if simulate_new_btn:
		simulate_new_btn.pressed.connect(_on_simulate_new_pressed)
	
	# Connect end simulation button
	if end_sim_btn:
		end_sim_btn.pressed.connect(_on_end_sim_button_pressed)

func _on_simulate_new_pressed():
	if not is_simulation_active:
		show_feedback("Simulation already ended!", Color.YELLOW, get_global_mouse_position())
		return
	
	# Show confirmation popup
	sim_confirmation.show()

func _on_yes_pressed():
	sim_confirmation.hide()
	sim_success.show()
	await get_tree().create_timer(0.5).timeout
	sim_success.hide()
	
	_initialize_empty_tree()
	is_simulation_active = true
	operation_count = 0  # Reset operation count
	insert_btn.disabled = false
	delete_btn.disabled = false
	search_btn.disabled = false
	traverse_btn.disabled = false
	end_sim_btn.disabled = false
	timeline_btn.disabled = false
	
	timeline_log.clear()
	code_lines.clear()
	_add_code_line("INITIAL", 0, 0)
	_update_stats_label()
	_update_timeline_display()
	_update_processes_label()  # Add this
	
	status_label.text = "BST Ready - Insert values to start"

func _on_no_pressed():
	sim_confirmation.hide()

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
			for entry in timeline_log:
				# Keep BBCode for RichTextLabel
				display_log.append(entry)
		
		if timeline_label:
			# Make sure label is visible
			timeline_label.visible = true
			# Set bbcode text
			timeline_label.bbcode_enabled = true
			timeline_label.bbcode_text = "\n".join(display_log)
			
			# Debug: print what we're trying to show
			print("Timeline entries count: ", display_log.size())
			if display_log.size() > 0:
				print("First entry: ", display_log[0])
		
		# Show popup
		timeline_popup.popup_centered()
		
		# Wait for popup to be visible
		await get_tree().process_frame
		await get_tree().process_frame
		
		# Scroll to bottom - FIXED: use max_value instead of max
		var scroll_container = timeline_popup.get_node_or_null("MainVBox/ScrollContainer")
		if scroll_container:
			var v_scroll = scroll_container.get_v_scroll_bar()
			if v_scroll:
				scroll_container.scroll_vertical = v_scroll.max_value

func _update_timeline_display():
	# Just update the stored timeline, no auto-show
	pass

func _on_timeline_close_pressed():
	btn_sound.play()
	if timeline_popup:
		timeline_popup.hide()

func _on_insert_button_pressed():
	if is_simulation_active:
		insert_dialog.popup_centered()
	else:
		show_feedback("Simulation ended!", Color.YELLOW, get_global_mouse_position())

func _on_delete_button_pressed():
	if is_simulation_active:
		delete_dialog.popup_centered()
	else:
		show_feedback("Simulation ended!", Color.YELLOW, get_global_mouse_position())

func _on_search_button_pressed():
	if is_simulation_active:
		search_dialog.popup_centered()
	else:
		show_feedback("Simulation ended!", Color.YELLOW, get_global_mouse_position())

func _on_traverse_button_pressed():
	if is_simulation_active:
		traverse_dialog.popup_centered()
	else:
		show_feedback("Simulation ended!", Color.YELLOW, get_global_mouse_position())

func _on_end_sim_button_pressed():
	if is_simulation_active:
		end_confirmation.popup_centered()
	else:
		show_feedback("Simulation already ended!", Color.YELLOW, get_global_mouse_position())
		
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
	var code = "/* BST Operations Simulation - Lecture Mode */\n"
	code += "#include <iostream>\nusing namespace std;\n\n"
	code += "struct Node {\n    int data;\n    Node* left;\n    Node* right;\n    Node(int val) : data(val), left(nullptr), right(nullptr) {}\n};\n\n"
	code += "class BST {\nprivate:\n    Node* root;\n\n"
	code += "    Node* insert(Node* node, int val) {\n"
	code += "        if (!node) return new Node(val);\n"
	code += "        if (val < node->data) node->left = insert(node->left, val);\n"
	code += "        else if (val > node->data) node->right = insert(node->right, val);\n"
	code += "        return node;\n"
	code += "    }\n\n"
	code += "    Node* findMin(Node* node) {\n"
	code += "        while (node && node->left) node = node->left;\n"
	code += "        return node;\n"
	code += "    }\n\n"
	code += "    Node* remove(Node* node, int val) {\n"
	code += "        if (!node) return nullptr;\n"
	code += "        if (val < node->data) node->left = remove(node->left, val);\n"
	code += "        else if (val > node->data) node->right = remove(node->right, val);\n"
	code += "        else {\n"
	code += "            if (!node->left) {\n"
	code += "                Node* temp = node->right;\n"
	code += "                delete node;\n"
	code += "                return temp;\n"
	code += "            }\n"
	code += "            else if (!node->right) {\n"
	code += "                Node* temp = node->left;\n"
	code += "                delete node;\n"
	code += "                return temp;\n"
	code += "            }\n"
	code += "            Node* temp = findMin(node->right);\n"
	code += "            node->data = temp->data;\n"
	code += "            node->right = remove(node->right, temp->data);\n"
	code += "        }\n"
	code += "        return node;\n"
	code += "    }\n\n"
	code += "    bool search(Node* node, int val) {\n"
	code += "        if (!node) return false;\n"
	code += "        if (node->data == val) return true;\n"
	code += "        if (val < node->data) return search(node->left, val);\n"
	code += "        return search(node->right, val);\n"
	code += "    }\n\n"
	code += "    void inorder(Node* node) {\n"
	code += "        if (!node) return;\n"
	code += "        inorder(node->left);\n"
	code += "        cout << node->data << \" \";\n"
	code += "        inorder(node->right);\n"
	code += "    }\n\n"
	code += "public:\n"
	code += "    BST() : root(nullptr) {}\n"
	code += "    void insert(int val) { root = insert(root, val); }\n"
	code += "    void remove(int val) { root = remove(root, val); }\n"
	code += "    bool search(int val) { return search(root, val); }\n"
	code += "    void inorder() { inorder(root); cout << endl; }\n"
	code += "};\n\n"
	code += "int main() {\n"
	code += "    BST tree;\n"
	code += "    \n"
	code += "    // BST Operations Simulation\n"
	
	# Add operations from code_lines
	for line in code_lines:
		var parts = line.split("|")
		if parts[0] == "INSERT":
			code += "    tree.insert(" + parts[2] + ");  // Insert at node " + parts[1] + "\n"
		elif parts[0] == "DELETE":
			code += "    tree.remove(" + parts[2] + ");  // Delete value from node " + parts[1] + "\n"
		elif parts[0] == "SEARCH_FOUND":
			code += "    cout << \"Found \" << " + parts[2] + " << \" at node \" << " + parts[1] + " << endl;\n"
		elif parts[0] == "TRAVERSE_START":
			code += "    cout << \"Traversal: \"; tree.inorder();\n"
	
	code += "    \n    return 0;\n}\n"
	code += "/* Complexity: Time O(log n) average, O(n) worst | Space O(log n) */"
	return code

func _gen_python_code() -> String:
	var code = "# BST Operations Simulation - Lecture Mode\n\n"
	code += "class Node:\n"
	code += "    def __init__(self, val):\n"
	code += "        self.data = val\n"
	code += "        self.left = None\n"
	code += "        self.right = None\n\n"
	code += "class BST:\n"
	code += "    def __init__(self):\n"
	code += "        self.root = None\n\n"
	code += "    def insert(self, val):\n"
	code += "        if not self.root:\n"
	code += "            self.root = Node(val)\n"
	code += "        else:\n"
	code += "            self._insert(self.root, val)\n\n"
	code += "    def _insert(self, node, val):\n"
	code += "        if val < node.data:\n"
	code += "            if node.left:\n"
	code += "                self._insert(node.left, val)\n"
	code += "            else:\n"
	code += "                node.left = Node(val)\n"
	code += "        elif val > node.data:\n"
	code += "            if node.right:\n"
	code += "                self._insert(node.right, val)\n"
	code += "            else:\n"
	code += "                node.right = Node(val)\n\n"
	code += "    def inorder(self, node):\n"
	code += "        if not node: return\n"
	code += "        self.inorder(node.left)\n"
	code += "        print(node.data, end=' ')\n"
	code += "        self.inorder(node.right)\n\n"
	code += "tree = BST()\n"
	
	for line in code_lines:
		var parts = line.split("|")
		if parts[0] == "INSERT":
			code += "tree.insert(" + parts[2] + ")  # Insert at node " + parts[1] + "\n"
		elif parts[0] == "DELETE":
			code += "# Delete " + parts[2] + " from node " + parts[1] + "\n"
	
	code += "\nprint(\"Inorder traversal: \", end='')\n"
	code += "tree.inorder(tree.root)\n"
	return code

func _gen_java_code() -> String:
	var code = "/* BST Operations Simulation - Lecture Mode */\n"
	code += "class BST {\n"
	code += "    class Node {\n"
	code += "        int data;\n"
	code += "        Node left, right;\n"
	code += "        Node(int val) { data = val; left = right = null; }\n"
	code += "    }\n\n"
	code += "    Node root;\n\n"
	code += "    void insert(int val) { root = insert(root, val); }\n"
	code += "    Node insert(Node node, int val) {\n"
	code += "        if (node == null) return new Node(val);\n"
	code += "        if (val < node.data) node.left = insert(node.left, val);\n"
	code += "        else if (val > node.data) node.right = insert(node.right, val);\n"
	code += "        return node;\n"
	code += "    }\n\n"
	code += "    void inorder(Node node) {\n"
	code += "        if (node == null) return;\n"
	code += "        inorder(node.left);\n"
	code += "        System.out.print(node.data + \" \");\n"
	code += "        inorder(node.right);\n"
	code += "    }\n\n"
	code += "    public static void main(String[] args) {\n"
	code += "        BST tree = new BST();\n"
	
	for line in code_lines:
		var parts = line.split("|")
		if parts[0] == "INSERT":
			code += "        tree.insert(" + parts[2] + ");  // Insert at node " + parts[1] + "\n"
	
	code += "        System.out.print(\"Inorder traversal: \");\n"
	code += "        tree.inorder(tree.root);\n"
	code += "    }\n"
	code += "}\n"
	return code

func _gen_c_code() -> String:
	var code = "/* BST Operations Simulation - Lecture Mode */\n"
	code += "#include <stdio.h>\n#include <stdlib.h>\n\n"
	code += "typedef struct Node {\n"
	code += "    int data;\n"
	code += "    struct Node* left;\n"
	code += "    struct Node* right;\n"
	code += "} Node;\n\n"
	code += "Node* newNode(int val) {\n"
	code += "    Node* node = (Node*)malloc(sizeof(Node));\n"
	code += "    node->data = val;\n"
	code += "    node->left = node->right = NULL;\n"
	code += "    return node;\n"
	code += "}\n\n"
	code += "Node* insert(Node* node, int val) {\n"
	code += "    if (!node) return newNode(val);\n"
	code += "    if (val < node->data) node->left = insert(node->left, val);\n"
	code += "    else if (val > node->data) node->right = insert(node->right, val);\n"
	code += "    return node;\n"
	code += "}\n\n"
	code += "void inorder(Node* node) {\n"
	code += "    if (!node) return;\n"
	code += "    inorder(node->left);\n"
	code += "    printf(\"%d \", node->data);\n"
	code += "    inorder(node->right);\n"
	code += "}\n\n"
	code += "int main() {\n"
	code += "    Node* root = NULL;\n"
	
	for line in code_lines:
		var parts = line.split("|")
		if parts[0] == "INSERT":
			code += "    root = insert(root, " + parts[2] + ");  // Insert at node " + parts[1] + "\n"
	
	code += "    printf(\"Inorder traversal: \");\n"
	code += "    inorder(root);\n"
	code += "    return 0;\n"
	code += "}\n"
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
	var keys = APIManager.get_keys("KEY_A")
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
	_initialize_empty_tree()
	is_simulation_active = true
	insert_btn.disabled = false
	delete_btn.disabled = false
	search_btn.disabled = false
	traverse_btn.disabled = false
	end_sim_btn.disabled = false

func _on_back_pressed():
	btn_sound.play()
	result_popup.hide()

func _on_translate_code_pressed():
	btn_sound.play()
	result_popup.hide()
	_show_cpp_popup()

func _connect_language_buttons():
	if cpp_lang_btn:
		cpp_lang_btn.pressed.connect(_on_cpp_lang_pressed)
	if python_lang_btn:
		python_lang_btn.pressed.connect(_on_python_lang_pressed)
	if java_lang_btn:
		java_lang_btn.pressed.connect(_on_java_lang_pressed)
	if c_lang_btn:
		c_lang_btn.pressed.connect(_on_c_lang_pressed)
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
		{"node": insert_btn, "title": "INSERT", "text": "Add new values to the BST. Tree maintains BST property automatically.", "action": "highlight"},
		{"node": delete_btn, "title": "DELETE", "text": "Remove values from the tree. Handles all deletion cases.", "action": "highlight"},
		{"node": search_btn, "title": "SEARCH", "text": "Find a value - highlights the path from root to node.", "action": "highlight"},
		{"node": traverse_btn, "title": "TRAVERSE", "text": "Visit nodes in Inorder, Preorder, or Postorder.", "action": "highlight"},
		{"node": timeline_btn, "title": "TIMELINE", "text": "View operation history.", "action": "highlight"},
		{"node": simulate_new_btn, "title": "NEW", "text": "Start a fresh tree.", "action": "highlight"},
		{"node": end_sim_btn, "title": "END", "text": "Finish the simulation.", "action": "highlight"}
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
	if insert_btn: insert_btn.disabled = not enabled
	if delete_btn: delete_btn.disabled = not enabled
	if search_btn: search_btn.disabled = not enabled
	if traverse_btn: traverse_btn.disabled = not enabled
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
func _update_processes_label():
	if status_label:
		status_label.text = "Processes: %d" % operation_count
