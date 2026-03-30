extends Control

# =========================
# DATA STRUCTURES TOPICS
# =========================
@onready var array: TextureButton = $data_structures/array
@onready var linked_list: TextureButton = $data_structures/linked_list
@onready var stack: TextureButton = $data_structures/stack
@onready var queue: TextureButton = $data_structures/queue
@onready var tree: TextureButton = $data_structures/tree
@onready var binary_tree: TextureButton = $"data_structures/binary tree"
@onready var binary_search_tree: TextureButton = $"data_structures/binary search tree"
@onready var graph: TextureButton = $data_structures/graph
@onready var back_button: TextureButton = $back_button

# =========================
# SORTING ALGORITHM TOPICS
# =========================
@onready var bubble_sort: TextureButton = $sorting_algorithms/bubble_sort
@onready var selection_sort: TextureButton = $sorting_algorithms/selection_sort
@onready var insertion_sort: TextureButton = $sorting_algorithms/insertion_sort
@onready var merge_sort: TextureButton = $sorting_algorithms/merge_sort
@onready var quick_sort: TextureButton = $sorting_algorithms/quick_sort
@onready var shell_sort: TextureButton = $sorting_algorithms/shell_sort

# =========================
# SEARCHING ALGORITHM TOPICS
# =========================
@onready var linear_search: TextureButton = $searching_algorithms/linear_search
@onready var binary_search: TextureButton = $searching_algorithms/binary_search
@onready var depth_first_search: TextureButton = $searching_algorithms/depth_first_search
@onready var breadth_first_search: TextureButton = $searching_algorithms/breadth_first_search
@onready var graph_tree_search: TextureButton = $searching_algorithms/graph_tree_search
@onready var interpolation_search: TextureButton = $searching_algorithms/interpolation_search

# =========================
# PAGE REFERENCES
# =========================
@onready var pages := [
	$data_structures,
	$sorting_algorithms,
	$searching_algorithms
]

# =========================
# PAGE INDICATOR
# =========================
@onready var indicator_container = $PageIndicator/IndicatorContainer
@onready var page_indicator = $PageIndicator

var indicator_dots: Array[Control] = []

# =========================
# SETTINGS
# =========================
@export var press_scale := Vector2(0.9, 0.9)
@export var normal_scale := Vector2(1, 1)
@export var bounce_time := 0.2
@export var swipe_threshold := 80.0
@export var transition_time := 0.3

# =========================
# STATE
# =========================
var current_index := 0
var drag_start := Vector2.ZERO
var dragging := false
var is_animating := false

# =========================
# READY
# =========================
func _ready():
	current_index = Global.lectures_page_index
	print("LOADING: Current index = ", current_index)

	for i in pages.size():
		pages[i].visible = (i == current_index)
		pages[i].position = Vector2.ZERO

	_create_page_indicators()
	_update_indicators()

func _create_page_indicators():
	for child in indicator_container.get_children():
		child.queue_free()
	indicator_dots.clear()

	for i in range(pages.size()):
		var dot = Panel.new()
		dot.custom_minimum_size = Vector2(12, 12)
		var style = StyleBoxFlat.new()
		style.bg_color = Color(1, 1, 1, 0.5)
		style.corner_radius_top_left = 6
		style.corner_radius_top_right = 6
		style.corner_radius_bottom_left = 6
		style.corner_radius_bottom_right = 6
		dot.add_theme_stylebox_override("panel", style)
		indicator_container.add_child(dot)
		indicator_dots.append(dot)

	page_indicator.show()

func _update_indicators():
	for i in range(indicator_dots.size()):
		var dot = indicator_dots[i]
		var style = dot.get_theme_stylebox("panel").duplicate()
		if i == current_index:
			dot.custom_minimum_size = Vector2(18, 12)
			style.bg_color = Color(1, 1, 1, 1)
		else:
			dot.custom_minimum_size = Vector2(8, 8)
			style.bg_color = Color(1, 1, 1, 0.4)
		dot.add_theme_stylebox_override("panel", style)

# =========================
# INPUT (MOUSE + TOUCH)
# =========================
func _input(event):
	if is_animating:
		return

	if event is InputEventScreenTouch:
		if event.pressed:
			drag_start = event.position
			dragging = true
		else:
			dragging = false

	if event is InputEventScreenDrag and dragging:
		handle_swipe(event.position)

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			drag_start = event.position
			dragging = true
		else:
			dragging = false

	if event is InputEventMouseMotion and dragging:
		handle_swipe(event.position)

# =========================
# SWIPE LOGIC
# =========================
func handle_swipe(current_pos: Vector2):
	var delta := current_pos - drag_start
	if abs(delta.x) > swipe_threshold:
		if delta.x < 0:
			go_next()
		else:
			go_previous()
		dragging = false

func go_next():
	if current_index >= pages.size() - 1:
		return
	animate_page(current_index + 1, -1)

func go_previous():
	if current_index <= 0:
		return
	animate_page(current_index - 1, 1)

# =========================
# PAGE ANIMATION
# =========================
func animate_page(next_index: int, direction: int):
	is_animating = true
	var current: Control = pages[current_index]
	var next: Control = pages[next_index]
	next.visible = true
	next.position.x = -direction * size.x
	var tween := create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(current, "position:x", direction * size.x, transition_time)
	tween.tween_property(next, "position:x", 0, transition_time)
	tween.finished.connect(func():
		current.visible = false
		current.position = Vector2.ZERO
		current_index = next_index
		_update_indicators()
		Global.lectures_page_index = current_index
		print("SAVING: Current index = ", current_index)
		is_animating = false
	)

# =========================
# NAVIGATION HELPER
# =========================
func _go_to_lesson(lesson_id: String, button: Control) -> void:
	await play_button_bounce(button)
	Global.last_lesson_id = lesson_id
	SceneManager.scene_stack.append("res://scenes/lectures.tscn")
	GlobalLoading.load_scene("res://scenes/lesson_view.tscn", true)

# =========================
# BUTTON BOUNCE
# =========================
func play_button_bounce(button: Control, callback: Callable = Callable()) -> void:
	if not button:
		print("Button is null!")
		return

	AudioManager.play_click_sound()
	var original_scale := button.scale
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", press_scale, bounce_time / 2)
	tween.tween_property(button, "scale", original_scale, bounce_time / 2)
	await tween.finished
	if callback:
		callback.call()

# =========================
# BUTTON HANDLERS - DATA STRUCTURES
# =========================
func _on_array_pressed(): _go_to_lesson("array", array)
func _on_linked_list_pressed(): _go_to_lesson("linked_list", linked_list)
func _on_stack_pressed(): _go_to_lesson("stack", stack)
func _on_queue_pressed(): _go_to_lesson("queue", queue)
func _on_tree_pressed(): _go_to_lesson("tree", tree)
func _on_binary_tree_pressed(): _go_to_lesson("bt", binary_tree)
func _on_binary_search_tree_pressed(): _go_to_lesson("bst", binary_search_tree)
func _on_graph_pressed(): _go_to_lesson("graph", graph)

# =========================
# BUTTON HANDLERS - SORTING ALGORITHMS
# =========================
func _on_bubble_sort_pressed(): _go_to_lesson("bubble_sort", bubble_sort)
func _on_selection_sort_pressed(): _go_to_lesson("selection_sort", selection_sort)
func _on_insertion_sort_pressed(): _go_to_lesson("insertion_sort", insertion_sort)
func _on_merge_sort_pressed(): _go_to_lesson("merge_sort", merge_sort)
func _on_quick_sort_pressed(): _go_to_lesson("quick_sort", quick_sort)
func _on_shell_sort_pressed(): _go_to_lesson("shell_sort", shell_sort)

# =========================
# BUTTON HANDLERS - SEARCHING ALGORITHMS
# =========================
func _on_linear_search_pressed(): _go_to_lesson("linear_search", linear_search)
func _on_binary_search_pressed(): _go_to_lesson("binary_search", binary_search)
func _on_interpolation_search_pressed(): _go_to_lesson("interpolation_search", interpolation_search)
func _on_depth_first_search_pressed(): _go_to_lesson("depth_first_search", depth_first_search)
func _on_breadth_first_search_pressed(): _go_to_lesson("breadth_first_search", breadth_first_search)
func _on_graph_tree_search_pressed(): _go_to_lesson("graph_tree_searching", graph_tree_search)

# =========================
# BACK BUTTON
# =========================
func _on_back_button_pressed() -> void:
	await play_button_bounce(back_button)
	SceneManager.go_back()
