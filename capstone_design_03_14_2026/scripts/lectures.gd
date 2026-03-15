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
	# Load the saved page index from Global
	current_index = Global.lectures_page_index
	print("LOADING: Current index = ", current_index)  # DEBUG
	
	for i in pages.size():
		pages[i].visible = (i == current_index)
		pages[i].position = Vector2.ZERO


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
		
		# SAVE the new index to Global
		Global.lectures_page_index = current_index
		print("SAVING: Current index = ", current_index)  # DEBUG
		
		is_animating = false
	)


# =========================
# BUTTON BOUNCE - FIXED to await animation
# =========================
func play_button_bounce(button: Control, callback: Callable = Callable()) -> void:
	if not button:
		print("Button is null!")
		return

	# Play click sound
	AudioManager.play_click_sound()

	var original_scale := button.scale
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	# Scale down to press_scale
	tween.tween_property(button, "scale", press_scale, bounce_time / 2)
	# Scale back to the original scale
	tween.tween_property(button, "scale", original_scale, bounce_time / 2)

	# Wait for animation to complete
	await tween.finished
	
	# Then execute callback if provided
	if callback:
		callback.call()


# =========================
# BUTTON BOUNCE FOR DATA STRUCTURES
# =========================
func _on_array_pressed(): play_button_bounce(array)
func _on_linked_list_pressed(): play_button_bounce(linked_list)
func _on_stack_pressed(): play_button_bounce(stack)
func _on_queue_pressed(): play_button_bounce(queue)
func _on_tree_pressed(): play_button_bounce(tree)
func _on_binary_tree_pressed(): play_button_bounce(binary_tree)
func _on_binary_search_tree_pressed(): play_button_bounce(binary_search_tree)
func _on_graph_pressed(): play_button_bounce(graph)

# =========================
# BUTTON BOUNCE FOR SORTING ALGORITHMS
# =========================
func _on_bubble_sort_pressed(): play_button_bounce(bubble_sort)
func _on_selection_sort_pressed(): play_button_bounce(selection_sort)
func _on_insertion_sort_pressed(): play_button_bounce(insertion_sort)
func _on_merge_sort_pressed(): play_button_bounce(merge_sort)
func _on_quick_sort_pressed(): play_button_bounce(quick_sort)
func _on_shell_sort_pressed(): play_button_bounce(shell_sort)

# =========================
# BUTTON BOUNCE FOR SEARCHING ALGORITHMS
# =========================
func _on_linear_search_pressed(): play_button_bounce(linear_search)
func _on_binary_search_pressed(): play_button_bounce(binary_search)
func _on_depth_first_search_pressed(): play_button_bounce(depth_first_search)
func _on_breadth_first_search_pressed(): play_button_bounce(breadth_first_search)
func _on_interpolation_search_pressed(): play_button_bounce(interpolation_search)
func _on_graph_tree_search_pressed(): play_button_bounce(graph_tree_search)


func _change_scene_after_animation(scene_path: String) -> void:
	print("Changing scene to:", scene_path)
	get_tree().change_scene_to_file(scene_path)


func _on_back_button_pressed() -> void:
	# Play bounce animation first, then change scene
	await play_button_bounce(back_button)
	_change_scene_after_animation("res://scenes/homepage.tscn")
