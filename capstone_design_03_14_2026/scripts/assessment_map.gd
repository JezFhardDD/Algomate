extends Control

@onready var panel = $Panel
@onready var bg = $Panel/BG_assessment
@onready var back_button = $back_button
@onready var difficulty_popup = $DifficultyPopup

var topic_buttons: Array[TextureButton] = []
var selected_topic: String = ""
var selected_button: TextureButton = null
var popup_active: bool = false
var popup_just_opened: bool = false
var popup_open_time: float = 0.0

func _ready():
	print("=== SETUP ===")
	print("Popup found: ", difficulty_popup != null)
	find_topic_buttons()
	connect_topic_buttons()
	if back_button:
		back_button.pressed.connect(_on_back_button_pressed)
	if difficulty_popup:
		difficulty_popup.difficulty_selected.connect(_on_difficulty_selected)
		difficulty_popup.popup_closed.connect(_on_popup_closed)

func find_topic_buttons():
	for child in bg.get_children():
		if child is TextureButton:
			topic_buttons.append(child)
			print("Found button: ", child.name)

func connect_topic_buttons():
	for button in topic_buttons:
		var topic_name = button.name.to_lower()
		var db_topic = _button_name_to_db_topic(topic_name)

		var lock_sprite = null
		for child in button.get_children():
			if child is TextureRect and child.name == "LockSprite":
				lock_sprite = child
				break

		var unavailable = ["tree", "binary_tree", "binary_search_tree", "graph", "graph_tree_search"]

		if db_topic in unavailable:
			# Always visible and tappable, but marked differently
			button.disabled = false
			button.modulate = Color(0.7, 0.7, 1.0, 1.0)  # Slight blue tint = future content
			if lock_sprite:
				lock_sprite.visible = false
			button.pressed.connect(_on_topic_pressed.bind(db_topic, button))
			print("Future content: ", topic_name)
		else:
			var is_unlocked = DB.is_level_unlocked(db_topic, 1)
			if not is_unlocked:
				button.disabled = true
				button.modulate = Color(0.5, 0.5, 0.5, 0.8)
				if lock_sprite:
					lock_sprite.visible = true
				print("Locked: ", topic_name)
			else:
				button.disabled = false
				button.modulate = Color(1, 1, 1, 1)
				if lock_sprite:
					lock_sprite.visible = false
				button.pressed.connect(_on_topic_pressed.bind(db_topic, button))
				print("Unlocked: ", topic_name)

func _button_name_to_db_topic(button_name: String) -> String:
	var map = {
		"array":               "array",
		"linkedlist":          "linked_list",
		"stack":               "stack",
		"queue":               "queue",
		"tree":                "tree",
		"binarytree":          "binary_tree",
		"binarysearchtree":    "binary_search_tree",
		"graph":               "graph",
		"bubblesort":          "bubble_sort",
		"selectionsort":       "selection_sort",
		"insertionsort":       "insertion_sort",
		"mergesort":           "merge_sort",
		"quicksort":           "quick_sort",
		"shellsort":           "shell_sort",
		"linearsearch":        "linear_search",
		"binarysearch":        "binary_search",
		"interpolationsearch": "interpolation_search",
		"graphtreesearch":     "graph_tree_search",
		"depthfirstsearch":    "depth_first_search",
		"breadthfirstsearch":  "breadth_first_search"
	}
	return map.get(button_name, button_name)

func _on_topic_pressed(topic: String, button: TextureButton):
	print("Topic selected: ", topic)
	selected_button = button
	selected_topic = topic
	popup_active = true
	popup_open_time = Time.get_ticks_msec()  # Record when popup opened
	
	AudioManager.play_click_sound()
	animate_button_press(button)
	
	if difficulty_popup:
		position_popup_above_button(button)
		difficulty_popup.show_for_topic(topic)

func position_popup_above_button(button: TextureButton):
	var button_global_pos = button.global_position
	var button_size = button.size
	var popup_size = difficulty_popup.size
	var target_x = button_global_pos.x + (button_size.x / 2) - (popup_size.x / 2)
	var target_y = button_global_pos.y - popup_size.y - 20
	var viewport_size = get_viewport().get_visible_rect().size
	target_x = clamp(target_x, 10, viewport_size.x - popup_size.x - 10)
	if target_y < 10:
		target_y = button_global_pos.y + button_size.y + 20
	difficulty_popup.global_position = Vector2(target_x, target_y)
	print("Popup at: ", difficulty_popup.global_position)

func animate_button_press(button: TextureButton):
	var original_scale = button.scale
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", original_scale * 0.8, 0.1)
	tween.tween_property(button, "scale", original_scale, 0.1)

func _input(event):
	if not popup_active:
		return
	
	# Ignore ALL input for 300ms after popup opens
	var time_since_open = Time.get_ticks_msec() - popup_open_time
	if time_since_open < 300:
		get_viewport().set_input_as_handled()
		return
	
	if event is InputEventMouseMotion and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		get_viewport().set_input_as_handled()
		return
	if event is InputEventScreenDrag:
		get_viewport().set_input_as_handled()
		return
	
	var click_pos = Vector2.ZERO
	var is_click = false
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		click_pos = get_global_mouse_position()
		is_click = true
	elif event is InputEventScreenTouch and event.pressed:
		click_pos = event.position
		is_click = true
	
	if is_click:
		var popup_rect = Rect2(difficulty_popup.global_position, difficulty_popup.size)
		if not popup_rect.has_point(click_pos):
			difficulty_popup.hide_popup()
			get_viewport().set_input_as_handled()

func _on_difficulty_selected(difficulty: String, topic: String):
	print("Selected: ", difficulty, " for ", topic)
	popup_active = false

	var diff_int = 1
	match difficulty:
		"easy":   diff_int = 1
		"medium": diff_int = 2
		"hard":   diff_int = 3

	Global.current_topic = topic
	Global.current_difficulty = diff_int

	# Topics under development — show feedback, don't navigate
	var unavailable = ["tree", "binary_tree", "binary_search_tree", "graph", "graph_tree_search"]
	if topic in unavailable:
		_show_under_development()
		return

	var scene_path = _get_simulation_scene(topic)
	if scene_path != "":
		SceneManager.change_scene(scene_path)
	else:
		_show_under_development()

func _show_under_development():
	var feedback_scene = preload("res://scene/FeedbackLabel.tscn")
	var label = feedback_scene.instantiate()
	label.text = "Coming in a future update!"
	label.modulate = Color.CYAN
	label.global_position = get_viewport().get_visible_rect().size / 2 - Vector2(100, 20)
	add_child(label)
	var anim = label.get_node("AnimationPlayer")
	anim.play("notification_pop")
	anim.animation_finished.connect(func(_a): label.queue_free())

func _get_simulation_scene(topic: String) -> String:
	var scene_map = {
		"array":                "res://scene/ArrayA.tscn",
		"linked_list":          "res://scene/LLA.tscn",
		"stack":                "res://scene/StackA.tscn",
		"queue":                "res://scene/QueueA.tscn",
		"tree":                 "res://scene/TreeSimulation.tscn",
		"binary_tree":          "res://scene/BinaryTreeSimulation.tscn",
		"binary_search_tree":   "res://scene/BinarySearchTreeSimulation.tscn",
		"graph":                "res://scene/GraphSimulation.tscn",
		"bubble_sort":          "res://scene/BBSA.tscn",
		"selection_sort":       "res://scene/SLA.tscn",
		"insertion_sort":       "res://scene/ISA.tscn",
		"merge_sort":           "res://scene/MSA.tscn",
		"quick_sort":           "res://scene/QSA.tscn",
		"shell_sort":           "res://scene/SSA.tscn",
		"linear_search":        "res://scene/LSA.tscn",
		"binary_search":        "res://scene/BNYSA.tscn",
		"interpolation_search": "res://scene/IPSA.tscn",
		"graph_tree_search":    "res://scene/GraphTreeSearchSimulation.tscn",
		"depth_first_search":   "res://scene/TreeDFSA.tscn",
		"breadth_first_search": "res://scene/TreeBFSa.tscn"
	}
	return scene_map.get(topic, "")

func _show_coming_soon(topic: String, difficulty: String):
	var dialog = AcceptDialog.new()
	dialog.title = "Coming Soon"
	dialog.dialog_text = topic.replace("_", " ").capitalize() + " simulation not available yet."
	dialog.ok_button_text = "OK"
	add_child(dialog)
	dialog.popup_centered()
	dialog.close_requested.connect(dialog.queue_free)

func _on_popup_closed():
	print("Popup closed")
	popup_active = false
	selected_button = null
	selected_topic = ""

func _on_back_button_pressed():
	if popup_active:
		popup_active = false
	AudioManager.play_back_sound()
	SceneManager.go_back()
