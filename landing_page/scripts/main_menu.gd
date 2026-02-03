extends Control

@onready var fade_rect = $FadeRect
@onready var start_button = $Start

# --- Settings ---
@export var press_scale := Vector2(0.9, 0.9)
@export var normal_scale := Vector2(1, 1)
@export var bounce_time := 0.2      # Total bounce duration
@export var fade_time := 0.5        # Fade duration

#func _ready():
	#start_button.pressed.connect(_on_start_pressed)

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

	# Change scene
	get_tree().change_scene_to_file("res://scenes/homepage.tscn")
