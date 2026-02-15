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
	
	# Update profile display
	update_profile_display()

func update_profile_display():
	profile_name.text = Global.profile_name
	
	# Load and set profile picture (if it exists)
	if Global.profile_picture:
		var texture = load(Global.profile_picture)
		if texture:
			profile_pic.texture_normal = texture  # Use texture_normal for TextureButton
		else:
			print("Failed to load profile picture:", Global.profile_picture)
			profile_pic.texture_normal = null  # Reset to default

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
