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
	
	# Connect LineEdit's text_changed signal (passes the new text)
	name_input.text_changed.connect(check_if_ready)

func pick_picture():
	# Open a file dialog to choose a picture
	var file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.filters = ["*.png, *.jpg, *.jpeg ; Picture Files"]
	file_dialog.file_selected.connect(got_picture)  # When a file is selected, call got_picture(path)
	add_child(file_dialog)
	file_dialog.popup_centered()

func got_picture(path: String):
	chosen_picture = path  # Store the selected picture path
	picture_display.texture = load(path)  # Display the picture
	
	# Check if both name and picture are set
	check_if_ready(name_input.text)  # Pass current text manually

func check_if_ready(new_text: String = "") -> void:
	# Enable "Done" button only if:
	# - Name is not empty
	# - A picture is selected
	done_button.disabled = (
		new_text.strip_edges().is_empty() or  # Check name
		chosen_picture.is_empty()             # Check picture
	)

func all_done():
	# Save profile data to Global
	Global.profile_name = name_input.text
	Global.profile_picture = chosen_picture
	Global.save_profile()
	
	# Emit signal and close the window
	profile_created.emit()
	queue_free()
