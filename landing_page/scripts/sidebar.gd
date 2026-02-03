extends Control

@onready var sidebar_container: Control = $sidebar_container
@onready var sidebar_button: TextureButton = $sidebar_button
@onready var exit_button: TextureButton = $sidebar_container/container/exit

@export var slide_time := 0.3

func _ready() -> void:
	await get_tree().process_frame  # IMPORTANT for Control size

	# Start hidden
	sidebar_container.visible = false
	sidebar_container.position.x = -sidebar_container.size.x
	sidebar_container.modulate.a = 0.0

	sidebar_button.pressed.connect(toggle_sidebar)
	exit_button.pressed.connect(toggle_sidebar)

func animate_sidebar_open() -> void:
	if sidebar_container.visible:
		return
	sidebar_container.visible = true
	sidebar_container.modulate.a = 0.0
	sidebar_container.position.x = sidebar_container.size.x

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
