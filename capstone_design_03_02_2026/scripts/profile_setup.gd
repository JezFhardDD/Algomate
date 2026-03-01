extends Window
signal profile_created

# References to UI elements
@onready var name_input: LineEdit = $VBoxContainer/name_input
@onready var picture_display: TextureRect = $VBoxContainer/picture_display
@onready var pick_button: Button = $VBoxContainer/pick_button
@onready var done_button: Button = $VBoxContainer/done_button

var chosen_picture: String = ""  # Stores the path to the selected picture

func _ready():
	# Connect button signals
	pick_button.pressed.connect(pick_picture)
	done_button.pressed.connect(all_done)
	done_button.disabled = true  # Disabled by default
	
	# Connect LineEdit's text_changed signal
	name_input.text_changed.connect(check_if_ready)
	
	# Connect to Global signals (optional, to handle reset while window is open)
	if Global.has_signal("profile_reset"):
		Global.profile_reset.connect(_on_global_profile_reset)

func pick_picture():
	# Open a file dialog to choose a picture
	var file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.filters = ["*.png, *.jpg, *.jpeg ; Picture Files"]
	file_dialog.file_selected.connect(got_picture)
	add_child(file_dialog)
	file_dialog.popup_centered()

func got_picture(path: String):
	chosen_picture = path  # Store the selected picture path
	
	# Load and display the picture
	if FileAccess.file_exists(path):
		var image = Image.new()
		var texture = ImageTexture.new()
		
		# For Godot 4, we need to load differently
		var loaded_texture = load(path)
		if loaded_texture is Texture2D:
			picture_display.texture = loaded_texture
		else:
			# Try to load as image
			var loaded_image = Image.load_from_file(path)
			if loaded_image:
				picture_display.texture = ImageTexture.create_from_image(loaded_image)
	
	# Check if both name and picture are set
	check_if_ready()

func check_if_ready(_new_text: String = ""):
	# Use current text from name_input
	var current_text = name_input.text.strip_edges()
	
	# Enable "Done" button only if:
	# - Name is not empty
	# - A picture is selected
	done_button.disabled = (current_text.is_empty() or chosen_picture.is_empty())

func all_done():
	# Get the profile name
	var profile_name = name_input.text.strip_edges()
	
	if profile_name.is_empty():
		show_error("Please enter a profile name")
		return
	
	if chosen_picture.is_empty():
		show_error("Please select a profile picture")
		return
	
	# Save using Global methods
	Global.set_profile_name(profile_name)
	Global.set_profile_picture(chosen_picture)
	
	# Emit signal and close the window
	profile_created.emit()
	queue_free()

func _on_global_profile_reset():
	# If profile was reset while this window is open, close it
	queue_free()

func show_error(message: String):
	# Create a simple error popup
	var error_dialog = AcceptDialog.new()
	error_dialog.dialog_text = message
	error_dialog.title = "Error"
	add_child(error_dialog)
	error_dialog.popup_centered()
