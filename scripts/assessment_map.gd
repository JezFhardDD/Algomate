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

# Drag scrolling variables
var dragging: bool = false
var drag_start_position: Vector2
var panel_initial_position: Vector2
var drag_threshold: float = 10.0  # Minimum drag distance to activate
var drag_inertia: Vector2 = Vector2.ZERO
var last_drag_position: Vector2
var drag_velocity: Vector2 = Vector2.ZERO
var velocity_smoothing: float = 0.1  # Lower = smoother
var bounds_margin: float = 200.0  # How far you can drag beyond content
var return_speed: float = 10.0  # Speed to return to bounds

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
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.mouse_default_cursor_shape = Control.CURSOR_DRAG
	
	# Enable touch/mouse tracking
	set_process_input(true)
	set_process(true)

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
	# Handle popup blocking first
	if popup_active:
		# Ignore ALL input for 300ms after popup opens
		var time_since_open = Time.get_ticks_msec() - popup_open_time
		if time_since_open < 300:
			get_viewport().set_input_as_handled()
			return
		
		# Check for clicks outside popup
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
				return
	
	# Handle drag scrolling
	if not popup_active:
		# Mouse/Touch press
		if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT) or event is InputEventScreenTouch:
			if event.pressed:
				# Start potential drag
				dragging = true
				if event is InputEventMouseButton:
					drag_start_position = get_global_mouse_position()
				else:  # Screen touch
					drag_start_position = event.position
				panel_initial_position = panel.position
				last_drag_position = drag_start_position
				drag_velocity = Vector2.ZERO
				drag_inertia = Vector2.ZERO
				# Don't set as handled yet - let buttons get the press event
			else:
				# Release - check if this was a drag or a click
				if dragging:
					var release_pos: Vector2
					if event is InputEventMouseButton:
						release_pos = get_global_mouse_position()
					else:
						release_pos = event.position
					
					var drag_distance = (release_pos - drag_start_position).length()
					
					# If it was a short drag, treat as click (let buttons handle)
					if drag_distance < drag_threshold:
						# This was a click/tap, not a drag
						dragging = false
						# Don't handle the event - let it pass to buttons
						return
					else:
						# This was a drag - apply inertia
						# In the release section, update the inertia code:
						if drag_inertia.length() > 5.0:
							var tween = create_tween()
							tween.set_trans(Tween.TRANS_CUBIC)
							tween.set_ease(Tween.EASE_OUT)
							
							var target_pos = panel.position + drag_inertia * 2.0
							target_pos = _clamp_panel_position(target_pos)  # Changed from _apply_rubber_band
							tween.tween_property(panel, "position", target_pos, 0.5)
		
		# Mouse/Touch drag motion
		elif dragging and (event is InputEventMouseMotion or event is InputEventScreenDrag):
			var current_pos: Vector2
			if event is InputEventMouseMotion:
				current_pos = get_global_mouse_position()
			else:  # Screen drag
				current_pos = event.position
			
			# Check if we've moved enough to consider this a drag
			var drag_distance = (current_pos - drag_start_position).length()
			
# Find this section in the drag motion handler and update it:
			if drag_distance > drag_threshold:
				# We're definitely dragging now - handle the event
				var drag_delta = current_pos - last_drag_position
				
				# Calculate new position
				var new_pos = panel.position + drag_delta
				# Use strict clamp instead of rubber band
				new_pos = _clamp_panel_position(new_pos)  # Changed from _apply_rubber_band
				
				# Only update position if it actually changed (prevents micro-movements at edges)
				if new_pos != panel.position:
					panel.position = new_pos
					
					# Calculate velocity for inertia (only when moving)
					drag_velocity = drag_delta
					drag_inertia = drag_inertia.lerp(drag_delta * 10.0, velocity_smoothing)
				
				last_drag_position = current_pos
				get_viewport().set_input_as_handled()
			else:
				# Not yet dragging - let buttons receive the event
				pass

func _process(delta):
	# Smoothly return to bounds when not dragging
	if not dragging and not popup_active:
		var clamped_pos = _clamp_panel_position(panel.position)
		if panel.position != clamped_pos:
			# Smooth return to bounds
			panel.position = panel.position.lerp(clamped_pos, return_speed * delta)
			
			# Snap if very close
			if panel.position.distance_to(clamped_pos) < 1.0:
				panel.position = clamped_pos

func _clamp_panel_position(pos: Vector2) -> Vector2:
	# Calculate bounds based on your map size (1889x2000)
	var content_size = Vector2(1889, 2000)
	var viewport_size = get_viewport().get_visible_rect().size
	
	# Top offset to account for navigation bar (adjust this value as needed)
	var top_offset = 150  # Pixels reserved for top bar/navigation
	
	# Calculate min and max positions with top offset
	var min_x = viewport_size.x - content_size.x
	var max_x = 0
	
	var min_y = viewport_size.y - content_size.y - top_offset  # Add top offset here
	var max_y = top_offset  # This ensures top content starts below navigation
	
	return Vector2(
		clamp(pos.x, min_x, max_x),
		clamp(pos.y, min_y, max_y)
	)

func _apply_rubber_band(pos: Vector2) -> Vector2:
	# Small amount of overscroll resistance before stopping
	var clamped = _clamp_panel_position(pos)
	var resistance = 0.15  # Lower = harder to pull (0.0 = no pull, 1.0 = full pull)
	var max_overscroll = 50.0  # Maximum pixels you can pull beyond bounds
	
	if pos.x < clamped.x:
		var overscroll = (clamped.x - pos.x) * resistance
		overscroll = min(overscroll, max_overscroll)
		pos.x = clamped.x - overscroll
	elif pos.x > clamped.x:
		var overscroll = (pos.x - clamped.x) * resistance
		overscroll = min(overscroll, max_overscroll)
		pos.x = clamped.x + overscroll
		
	if pos.y < clamped.y:
		var overscroll = (clamped.y - pos.y) * resistance
		overscroll = min(overscroll, max_overscroll)
		pos.y = clamped.y - overscroll
	elif pos.y > clamped.y:
		var overscroll = (pos.y - clamped.y) * resistance
		overscroll = min(overscroll, max_overscroll)
		pos.y = clamped.y + overscroll
	
	return pos
	
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
		SceneManager.scene_stack.append("res://scenes/assessment_map.tscn")
		GlobalLoading.load_scene(scene_path)
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

func _touch_dragged(relative: Vector2) -> void:
	if not dragging or popup_active:
		return
	
	# Move panel with touch
	var new_pos = panel.position + relative
	new_pos = _apply_rubber_band(new_pos)
	panel.position = new_pos
	
	# Update velocity for inertia
	drag_velocity = relative
	drag_inertia = drag_inertia.lerp(relative * 30.0, velocity_smoothing)
	
