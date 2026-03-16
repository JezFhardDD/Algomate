extends Control

@onready var fade_rect = $FadeRect
@onready var start_button = $Start
@onready var quit_button = $Quit
@onready var reset_button = $ResetButton
@onready var confirmation_dialog = $ConfirmationDialog

# --- Settings ---
@export var press_scale := Vector2(0.9, 0.9)
@export var normal_scale := Vector2(1, 1)
@export var bounce_time := 0.2
@export var fade_time := 0.5

# Profile system
var profile_setup_scene = preload("res://scenes/profile_setup.tscn")

# Texture paths for the button
@export var start_texture: Texture2D
@export var create_profile_texture: Texture2D

# Custom dialog variables
var custom_dialog = null
var custom_font = null

func _ready():
	AudioManager.play_music("res://assets/MUSIC/8bit bg music.mp3")
	Global.lectures_page_index = 0
	
	# Load custom font
	custom_font = load("res://assets/font/Planes_ValMore.ttf")

	if Global.has_signal("profile_reset"):
		Global.profile_reset.connect(_on_profile_reset)
	if Global.has_signal("profile_updated"):
		Global.profile_updated.connect(_on_profile_updated)

	# Wait for Global to finish syncing from DB before checking profile
	await get_tree().process_frame
	await get_tree().process_frame

	update_button_textures()
	position_reset_button_for_screen()

	if reset_button:
		if not reset_button.pressed.is_connected(_on_reset_pressed):
			reset_button.pressed.connect(_on_reset_pressed)
	
	if quit_button:
		if not quit_button.pressed.is_connected(_on_quit_pressed):
			quit_button.pressed.connect(_on_quit_pressed)

	# Hide the default confirmation dialog and create our custom one
	if confirmation_dialog:
		confirmation_dialog.visible = false
		confirmation_dialog.queue_free()
	
	create_custom_dialog()
	
	# Connect to screen size changes (for orientation changes)
	get_viewport().size_changed.connect(position_reset_button_for_screen)

# Replace the create_custom_dialog() function with this updated version:

func create_custom_dialog():
	# Create a custom Window dialog
	custom_dialog = Window.new()
	custom_dialog.name = "CustomConfirmationDialog"
	custom_dialog.title = "Reset Profile?"
	custom_dialog.size = Vector2(600, 300)  # 2x bigger
	custom_dialog.min_size = Vector2(400, 250)
	custom_dialog.always_on_top = true
	custom_dialog.exclusive = true
	custom_dialog.unresizable = false
	custom_dialog.borderless = false
	custom_dialog.wrap_controls = true
	
	# Create main container
	var main_container = Panel.new()
	main_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# Load and set background texture
	var bg_texture = load("res://assets/CONTAINER.png")
	if bg_texture:
		var bg_style = StyleBoxTexture.new()
		bg_style.texture = bg_texture
		# Make the texture stretch to fill the entire panel
		bg_style.expand_margin_left = 0
		bg_style.expand_margin_top = 0
		bg_style.expand_margin_right = 0
		bg_style.expand_margin_bottom = 0
		# Set texture scale mode to stretch
		bg_style.texture = bg_texture
		main_container.add_theme_stylebox_override("panel", bg_style)
	
	custom_dialog.add_child(main_container)
	
	# Create vertical layout for content
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 30)  # Space between elements
	# Add some padding inside the container
	vbox.add_theme_constant_override("margin_left", 30)
	vbox.add_theme_constant_override("margin_right", 30)
	vbox.add_theme_constant_override("margin_top", 30)
	vbox.add_theme_constant_override("margin_bottom", 30)
	main_container.add_child(vbox)
	
	# Add spacer at top (flexible)
	var top_spacer = Control.new()
	top_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(top_spacer)
	
	# Create message label
	var message_label = Label.new()
	message_label.text = "Are you sure you want to reset your profile?\nAll data will be lost."
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	message_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	message_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	# Apply font to message
	if custom_font:
		message_label.add_theme_font_override("font", custom_font)
		message_label.add_theme_font_size_override("font_size", 28)  # Bigger font for larger popup
	
	vbox.add_child(message_label)
	
	# Create button container
	var button_container = HBoxContainer.new()
	button_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button_container.size_flags_vertical = Control.SIZE_SHRINK_END
	button_container.add_theme_constant_override("separation", 40)  # Space between buttons
	vbox.add_child(button_container)
	
	# Add spacer at bottom (flexible)
	var bottom_spacer = Control.new()
	bottom_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(bottom_spacer)
	
	# Load button textures
	var button_normal = load("res://assets/BUTTON.png")
	var button_pressed = load("res://assets/BUTTON_PRESSED.png") if ResourceLoader.exists("res://assets/BUTTON_PRESSED.png") else button_normal
	var button_hovered = load("res://assets/BUTTON_HOVERED.png") if ResourceLoader.exists("res://assets/BUTTON_HOVERED.png") else button_normal
	
	# Create YES button
	var yes_button = TextureButton.new()
	yes_button.texture_normal = button_normal
	if button_pressed:
		yes_button.texture_pressed = button_pressed
	if button_hovered:
		yes_button.texture_hover = button_hovered
	
	# Set button size (make buttons bigger too)
	yes_button.custom_minimum_size = Vector2(150, 80)
	yes_button.stretch_mode = TextureButton.STRETCH_SCALE
	
	# Create a container for button label
	var yes_container = CenterContainer.new()
	yes_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	yes_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	yes_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	yes_button.add_child(yes_container)
	
	var yes_label = Label.new()
	yes_label.text = "YES"
	if custom_font:
		yes_label.add_theme_font_override("font", custom_font)
		yes_label.add_theme_font_size_override("font_size", 32)
	yes_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	yes_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	yes_container.add_child(yes_label)
	
	yes_button.pressed.connect(_on_custom_yes_pressed)
	button_container.add_child(yes_button)
	
	# Create NO button
	var no_button = TextureButton.new()
	no_button.texture_normal = button_normal
	if button_pressed:
		no_button.texture_pressed = button_pressed
	if button_hovered:
		no_button.texture_hover = button_hovered
	
	no_button.custom_minimum_size = Vector2(150, 80)
	no_button.stretch_mode = TextureButton.STRETCH_SCALE
	
	# Create a container for button label
	var no_container = CenterContainer.new()
	no_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	no_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	no_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	no_button.add_child(no_container)
	
	var no_label = Label.new()
	no_label.text = "NO"
	if custom_font:
		no_label.add_theme_font_override("font", custom_font)
		no_label.add_theme_font_size_override("font_size", 32)
	no_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	no_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	no_container.add_child(no_label)
	
	no_button.pressed.connect(_on_custom_no_pressed)
	button_container.add_child(no_button)
	
	# Add to scene first
	add_child(custom_dialog)
	
	# Position in center AFTER adding to scene
	custom_dialog.position = Vector2(
		30,
		(get_viewport().size.y - custom_dialog.size.y) / 2
	)
	
	custom_dialog.visible = false

func _on_custom_yes_pressed():
	AudioManager.play_confirm_sound()
	custom_dialog.visible = false
	reset_profile()

func _on_custom_no_pressed():
	AudioManager.play_back_sound()  # or play a different sound
	custom_dialog.visible = false

func position_reset_button_for_screen():
	# Position the reset button dynamically based on screen size
	if not reset_button:
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	
	# Calculate button size (or use a fixed size)
	var button_width = reset_button.size.x
	var button_height = reset_button.size.y
	
	# Position at bottom center with some margin
	var margin = 50
	var x_pos = (viewport_size.x - button_width) / 2
	var y_pos = viewport_size.y - button_height - margin
	
	# For mobile, add extra margin from the bottom if needed
	if OS.has_feature("mobile") or OS.has_feature("android") or OS.has_feature("ios"):
		y_pos = viewport_size.y - button_height - margin * 2  # Extra margin for mobile
	
	reset_button.position = Vector2(x_pos, y_pos)
	
	print("Repositioned reset button to: ", reset_button.position, " Screen size: ", viewport_size)

func update_button_textures():
	if not Global.has_profile():
		start_button.texture_normal = create_profile_texture
		var tween = create_tween()
		tween.tween_property(reset_button, "modulate:a", 0.0, 0.3)
		await tween.finished
		reset_button.visible = false
		# Change this from .disabled to .visible
		if reset_button:
			reset_button.visible = false 
		print("No profile - button: CREATE PROFILE, reset invisible")
	else:
		start_button.texture_normal = start_texture
		# Show it when a profile exists
		if reset_button:
			reset_button.visible = true
			reset_button.disabled = false
			# Reposition when showing
			position_reset_button_for_screen()
		print("Has profile - button: START, reset visible")

func _on_profile_reset():
	print("Profile reset signal received")
	update_button_textures()

func _on_profile_updated():
	print("Profile updated signal received")
	update_button_textures()

func _on_start_pressed() -> void:
	AudioManager.play_click_sound()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(start_button, "scale", press_scale, bounce_time / 2)
	tween.tween_property(start_button, "scale", normal_scale, bounce_time / 2)
	tween.tween_property(fade_rect, "modulate:a", 1.0, fade_time)

	await tween.finished

	if Global.has_profile():
		print("Going to homepage")
		SceneManager.change_scene("res://scenes/homepage.tscn")
	else:
		print("Showing profile setup")
		var profile_setup = profile_setup_scene.instantiate()
		print("Does profile_setup have profile_created signal? ", profile_setup.has_signal("profile_created"))
		profile_setup.profile_created.connect(_on_profile_created)
		add_child(profile_setup)
		profile_setup.popup_centered()
		fade_rect.modulate.a = 0.0

func _on_quit_pressed():
	AudioManager.play_click_sound()
	
	# Animate button press
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(quit_button, "scale", press_scale, bounce_time / 2)
	tween.tween_property(quit_button, "scale", normal_scale, bounce_time / 2)
	
	# Fade out
	tween.tween_property(fade_rect, "modulate:a", 1.0, fade_time)
	
	await tween.finished
	
	# Quit the application
	get_tree().quit()

# Replace the position update section in _on_reset_pressed():
func _on_reset_pressed():
	print("Reset button pressed!")
	AudioManager.play_click_sound()
	if custom_dialog:
		# Update dialog position to center before showing
		custom_dialog.position = Vector2(
			30,
			(get_viewport().size.y - custom_dialog.size.y) / 2
		)
		custom_dialog.visible = true
		custom_dialog.show()

func reset_profile():
	print("Resetting profile...")
	
	# Animate button press
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(reset_button, "scale", press_scale, bounce_time / 2)
	tween.tween_property(reset_button, "scale", normal_scale, bounce_time / 2)
	
	# Reset profile through Global
	Global.reset_profile()
	update_button_textures() # Add this to hide the button immediately
	
	print("Profile reset complete. Has profile: ", Global.has_profile())

func _on_profile_created():
	print("Profile created")
	update_button_textures()
	
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, fade_time)
	await tween.finished
	
	SceneManager.change_scene("res://scenes/homepage.tscn")

# Keep ESC for testing
func _input(event):
	if event.is_action_pressed("ui_cancel") and OS.is_debug_build():
		print("ESC pressed - resetting profile")
		Global.reset_profile()
