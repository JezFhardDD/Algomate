extends Control

@onready var sidebar_container: Control = $sidebar_container
@onready var sidebar_button: TextureButton = $sidebar_button
@onready var exit_button: TextureButton = $sidebar_container/container/exit

@onready var profile_pic: TextureButton = %profile_pic
@onready var profile_name: Label = %profile_name

@export var slide_time := 0.3

func _ready() -> void:
	await get_tree().process_frame  # IMPORTANT for Control size

	# Start hidden
	sidebar_container.visible = false
	sidebar_container.position.x = -sidebar_container.size.x
	sidebar_container.modulate.a = 0.0

	sidebar_button.pressed.connect(toggle_sidebar)
	exit_button.pressed.connect(toggle_sidebar)
	
	# Connect to Global signals to update when profile changes
	if Global.has_signal("profile_updated"):
		Global.profile_updated.connect(update_profile_display)
	if Global.has_signal("profile_reset"):
		Global.profile_reset.connect(update_profile_display)
	
	# Update profile display
	update_profile_display()

func update_profile_display():
	if Global.has_profile():
		profile_name.text = Global.get_profile_name()
		
		# Load and set profile picture (if it exists)
		var picture_path = Global.profile_data.get("profile_picture", "")
		if picture_path and FileAccess.file_exists(picture_path):
			var texture = load(picture_path)
			if texture:
				profile_pic.texture_normal = texture
				
				# Make it bigger with pixel art settings
				profile_pic.custom_minimum_size = Vector2(80, 80)  # Adjust this number
				profile_pic.size = Vector2(80, 80)
				profile_pic.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
				profile_pic.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST  # For pixel art
				
			else:
				profile_pic.texture_normal = null
		else:
			profile_pic.texture_normal = null
	else:
		profile_name.text = "No Profile"
		profile_pic.texture_normal = null

func animate_sidebar_open() -> void:
	if sidebar_container.visible:
		return
	sidebar_container.visible = true
	sidebar_container.modulate.a = 0.0
	sidebar_container.position.x = sidebar_container.size.x  # Start from the right

	var tween = create_tween()
	tween.tween_property(sidebar_container, "position:x", 0, slide_time)
	tween.parallel().tween_property(sidebar_container, "modulate:a", 1.0, slide_time)

func animate_sidebar_close() -> void:
	var tween = create_tween()
	tween.tween_property(sidebar_container, "position:x", sidebar_container.size.x, slide_time)
	tween.parallel().tween_property(sidebar_container, "modulate:a", 0.0, slide_time)
	await tween.finished
	sidebar_container.visible = false

func toggle_sidebar() -> void:
	if sidebar_container.visible:
		animate_sidebar_close()
	else:
		animate_sidebar_open()


func _on_settings_pressed() -> void:
	# Close sidebar first, then change scene using SceneManager
	await animate_sidebar_close()
	SceneManager.change_scene("res://scenes/settings.tscn")
