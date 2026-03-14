extends Control

# =========================
# REFERENCES
# =========================
@onready var panel = $Panel
@onready var bg = $Panel/BG_assessment
@onready var back_button = $back_button
@onready var difficulty_popup = $DifficultyPopup

# =========================
# LOCKED TOPICS (NEW)
# =========================
var locked_topics = [
	"linkedlist",
	"stack", 
	"queue",
	"tree",
	"binarytree",
	"binarysearchtree",
	"graph",
	"bubblesort",
	"selectionsort",
	"insertionsort",
	"mergesort",
	"quicksort",
	"shellsort",
	"linearsearch",
	"binarysearch",
	"inerpolationsearch",
	"graphtreesearch",
	"depthfirstsearch",
	"breadthfirstsearch"
]  # Only "array" is accessible, all others locked
# =========================
# TOPIC BUTTONS
# =========================
var topic_buttons: Array[TextureButton] = []
var selected_topic: String = ""
var selected_button: TextureButton = null
var popup_active: bool = false

# =========================
# READY
# =========================
func _ready():
	print("=== SETUP ===")
	print("Popup found: ", difficulty_popup != null)
	
	find_topic_buttons()
	connect_topic_buttons()
	apply_locked_visuals()
	
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
		
		# Find lock sprite if it exists
		var lock_sprite = null
		for child in button.get_children():
			if child is TextureRect and child.name == "LockSprite":
				lock_sprite = child
				break
		
		# Check if this topic is locked
		if topic_name in locked_topics:
			# This is a locked topic
			button.disabled = true
			if lock_sprite:
				lock_sprite.visible = true  # Show lock
			print("Locked: ", topic_name)
		else:
			# This is an unlocked topic
			button.disabled = false
			if lock_sprite:
				lock_sprite.visible = false  # Hide lock if it exists
			button.pressed.connect(_on_topic_pressed.bind(topic_name, button))
			print("Unlocked: ", topic_name)
			
# Optional: Make locked buttons look dimmer
func apply_locked_visuals():
	for button in topic_buttons:
		var topic_name = button.name.to_lower()
		if topic_name in locked_topics:
			button.modulate = Color(0.5, 0.5, 0.5, 0.8)  # Gray out
# =========================
# TOPIC BUTTON HANDLER
# =========================
func _on_topic_pressed(topic: String, button: TextureButton):
	print("Topic selected: ", topic)
	
	selected_button = button
	selected_topic = topic
	popup_active = true
	
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

# =========================
# IMPROVED INPUT BLOCKING - Only blocks map movement, not UI clicks
# =========================
func _input(event):
	# Only block input if popup is active
	if popup_active:
		# Check if the event is a panning/map movement event
		# We want to block these so the map doesn't move
		
		# Mouse drag for panning
		if event is InputEventMouseMotion and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			get_viewport().set_input_as_handled()
			return
		
		# Touch drag for mobile panning
		if event is InputEventScreenDrag:
			get_viewport().set_input_as_handled()
			return
		
		# Left mouse button down for starting a drag
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			# Check if the click is on the popup
			var mouse_pos = get_global_mouse_position()
			var popup_rect = Rect2(difficulty_popup.global_position, difficulty_popup.size)
			
			if not popup_rect.has_point(mouse_pos):
				# Clicked outside popup - close it
				difficulty_popup.hide_popup()
				get_viewport().set_input_as_handled()
				return
			# If click is inside popup, let it pass through to the popup buttons

# =========================
# POPUP SIGNAL HANDLERS
# =========================
func _on_difficulty_selected(difficulty: String, topic: String):
	print("Selected: ", difficulty)
	popup_active = false
	
	Global.current_topic = topic
	Global.current_difficulty = difficulty
	
	show_test_placeholder(topic, difficulty)

func _on_popup_closed():
	print("Popup closed")
	popup_active = false
	selected_button = null
	selected_topic = ""

func show_test_placeholder(topic: String, difficulty: String):
	var dialog = AcceptDialog.new()
	dialog.title = topic.replace("_", " ").capitalize()
	dialog.dialog_text = "Starting " + difficulty.capitalize() + " assessment for " + topic.replace("_", " ") + "!"
	dialog.ok_button_text = "OK"
	add_child(dialog)
	dialog.popup_centered()
	dialog.close_requested.connect(dialog.queue_free)

# =========================
# BACK BUTTON
# =========================
func _on_back_button_pressed():
	if popup_active:
		popup_active = false
	AudioManager.play_back_sound()
	SceneManager.go_back()
