extends Control

@onready var fade_rect = $FadeRect
@onready var start_button = $Start
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

func _ready():
	AudioManager.play_music("res://assets/MUSIC/8bit bg music.mp3")
	Global.lectures_page_index = 0
	# Connect to Global signals
	if Global.has_signal("profile_reset"):
		Global.profile_reset.connect(_on_profile_reset)
	if Global.has_signal("profile_updated"):
		Global.profile_updated.connect(_on_profile_updated)
	
	# Initial button setup
	update_button_textures()
	
	# Connect reset button
	if reset_button:
		# Make sure it's not already connected to avoid duplicate connections
		if not reset_button.pressed.is_connected(_on_reset_pressed):
			reset_button.pressed.connect(_on_reset_pressed)
	
	# Setup confirmation dialog
	if not confirmation_dialog:
		add_confirmation_dialog()
	else:
		# Make sure the confirmation dialog signal is connected
		if not confirmation_dialog.confirmed.is_connected(_on_confirmation_confirmed):
			confirmation_dialog.confirmed.connect(_on_confirmation_confirmed)

func update_button_textures():
	if not Global.has_profile():
		start_button.texture_normal = create_profile_texture
		reset_button.disabled = true
		print("No profile - button: CREATE PROFILE, reset disabled")
	else:
		start_button.texture_normal = start_texture
		reset_button.disabled = false
		print("Has profile - button: START, reset enabled")

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

func _on_reset_pressed():
	print("Reset button pressed!")
	AudioManager.play_click_sound()
	if confirmation_dialog:
		confirmation_dialog.popup_centered()
	else:
		reset_profile()

func _on_confirmation_confirmed():
	print("Confirmation confirmed")
	AudioManager.play_confirm_sound()
	reset_profile()

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
	
	print("Profile reset complete. Has profile: ", Global.has_profile())

func add_confirmation_dialog():
	print("Adding confirmation dialog")
	var dialog = ConfirmationDialog.new()
	dialog.name = "ConfirmationDialog"
	dialog.title = "Reset Profile"
	dialog.dialog_text = "Are you sure you want to reset your profile? All data will be lost."
	dialog.ok_button_text = "Reset"
	dialog.cancel_button_text = "Cancel"
	add_child(dialog)
	confirmation_dialog = dialog
	dialog.confirmed.connect(_on_confirmation_confirmed)

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
