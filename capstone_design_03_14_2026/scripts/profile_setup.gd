extends Window
signal profile_created

# References to UI elements
@onready var name_input: LineEdit = $Panel/VBoxContainer/name_input
@onready var done_button: Button = $Panel/VBoxContainer/HBoxContainer/done_button
@onready var cancel_button: Button = $Panel/VBoxContainer/HBoxContainer/cancel_button
@onready var profile_pic_container: GridContainer = $Panel/VBoxContainer/profile_pic_container


# Array to store all profile picture buttons
var pic_buttons: Array[TextureButton] = []
var selected_pic_path: String = ""
var selected_pic_index: int = -1

# Preload your profile pictures (or load them dynamically)
var profile_pictures = [
	preload("res://assets/profile_pics/boyCCT2.jpg"),
	preload("res://assets/profile_pics/girlCCT2.jpeg")
]

# If you want to load dynamically (better for adding more pictures later)
# var profile_picture_paths = [
#     "res://assets/profile_pics/pic1.png",
#     "res://assets/profile_pics/pic2.png",
#     "res://assets/profile_pics/pic3.png",
#     "res://assets/profile_pics/pic4.png"
# ]

func _ready():
	# Set up the popup window
	popup_window = true
	exclusive = true  # Makes it modal - can't click behind it[citation:1]
	
	# Connect button signals
	done_button.pressed.connect(_on_done_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	
	# Disable done button initially
	done_button.disabled = true
	
	# Connect name input signal
	name_input.text_changed.connect(_on_name_changed)
	
	# Create profile picture buttons
	create_profile_pic_buttons()
	
	# Connect to Global signals
	if Global.has_signal("profile_reset"):
		Global.profile_reset.connect(_on_global_profile_reset)

func create_profile_pic_buttons():
	# Clear existing buttons (if any)
	for button in pic_buttons:
		button.queue_free()
	pic_buttons.clear()
	
	# Create a button for each profile picture
	for i in range(profile_pictures.size()):
		var button = TextureButton.new()
		button.texture_normal = profile_pictures[i]
		
		# ADD THIS LINE for pixel art sharpness
		button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		
		# FIX: Replace 'expand' with these properties
		button.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_SHRINK_CENTER
		button.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_SHRINK_CENTER
		button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		
		# Set custom minimum size
		button.custom_minimum_size = Vector2(100, 100)
		
		# Store metadata
		button.set_meta("pic_index", i)
		button.set_meta("pic_path", profile_pictures[i].resource_path)
		
		# Connect signal
		button.pressed.connect(_on_pic_selected.bind(button))
		
		# Add to container and array
		profile_pic_container.add_child(button)
		pic_buttons.append(button)
	
	# Alternative: Load dynamically from folder
	# var dir = DirAccess.open("res://assets/profile_pics/")
	# if dir:
	#     dir.list_dir_begin()
	#     var file_name = dir.get_next()
	#     while file_name != "":
	#         if file_name.ends_with(".png") or file_name.ends_with(".jpg"):
	#             var path = "res://assets/profile_pics/" + file_name
	#             var texture = load(path)
	#             if texture:
	#                 # Create button (same as above)
	#                 # ...
	#         file_name = dir.get_next()

func _on_pic_selected(button: TextureButton):
	AudioManager.play_click_sound()
	var index = button.get_meta("pic_index")
	var path = button.get_meta("pic_path")
	
	# Deselect all
	for i in range(pic_buttons.size()):
		var btn = pic_buttons[i]
		# Remove selection effect
		btn.modulate = Color.WHITE
		btn.scale = Vector2(1.0, 1.0)
	
	# Select this one with visual feedback
	button.modulate = Color(1.0, 1.0, 0.8)  # Slight highlight
	button.scale = Vector2(1.1, 1.1)  # Slightly larger
	
	# Store selection
	selected_pic_index = index
	selected_pic_path = path
	
	# Check if form is complete
	check_form_complete()

func _on_name_changed(new_text: String):
	check_form_complete()

func check_form_complete():
	var name_filled = not name_input.text.strip_edges().is_empty()
	var pic_selected = selected_pic_index >= 0
	done_button.disabled = not (name_filled and pic_selected)

func _on_done_pressed():
	AudioManager.play_confirm_sound()
	var profile_name = name_input.text.strip_edges()
	
	if profile_name.is_empty() or selected_pic_index < 0:
		return
	
	# Save to Global using your methods
	Global.set_profile_name(profile_name)
	Global.set_profile_picture(selected_pic_path)
	
	# Optional: Also save the index if needed
	# Global.set_profile_pic_index(selected_pic_index)
	
	# Emit signal and close
	profile_created.emit()
	queue_free()

func _on_cancel_pressed():
	AudioManager.play_click_sound()
	queue_free()  # Just close without saving

func _on_global_profile_reset():
	# Close if profile was reset elsewhere
	queue_free()

# Override close_requested to handle window close button
func _on_close_requested():
	queue_free()
