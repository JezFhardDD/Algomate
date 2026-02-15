extends Control

@onready var fade_rect = $FadeRect
@onready var start_button = $Start

# --- Settings ---
@export var press_scale := Vector2(0.9, 0.9)
@export var normal_scale := Vector2(1, 1)
@export var bounce_time := 0.2      # Total bounce duration
@export var fade_time := 0.5        # Fade duration

# Profile system
var profile_setup_scene = preload("res://scenes/profile_setup.tscn")

# Texture paths for the button
@export var start_texture: Texture2D  # Texture for "START"
@export var create_profile_texture: Texture2D  # Texture for "CREATE PROFILE"

func _ready():
	# Change button texture based on profile existence
	if not Global.has_profile():
		start_button.texture_normal = create_profile_texture
	else:
		start_button.texture_normal = start_texture

func _on_start_pressed() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	# Button bounce: push down and pop
	tween.tween_property(start_button, "scale", press_scale, bounce_time / 2)
	tween.tween_property(start_button, "scale", normal_scale, bounce_time / 2)

	# Fade starts immediately, independent of bounce
	tween.tween_property(fade_rect, "modulate:a", 1.0, fade_time)

	# Wait for all tween animations to finish
	await tween.finished

	# Check profile before changing scene
	if Global.has_profile():
		# Existing profile - go to homepage
		get_tree().change_scene_to_file("res://scenes/homepage.tscn")
	else:
		# No profile - show setup
		var profile_setup = profile_setup_scene.instantiate()
		profile_setup.profile_created.connect(_on_profile_created)
		add_child(profile_setup)
		profile_setup.popup_centered()
		# Reset fade after showing popup
		fade_rect.modulate.a = 0.0

func _on_profile_created():
	# When profile is created, update button texture and go to homepage
	start_button.texture_normal = start_texture
	
	# Play fade animation again
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, fade_time)
	await tween.finished
	
	get_tree().change_scene_to_file("res://scenes/homepage.tscn")
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Press ESC to reset
		Global.reset_profile()
		start_button.texture_normal = create_profile_texture  # Reset button
		print("Profile reset!")
