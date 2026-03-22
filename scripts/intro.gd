extends Control

@onready var fade_rect = $FadeRect
var fade_time := 2.0
var hold_time := 1.5

func _ready():
	play_intro()

func play_intro():
	# Fade in (black -> visible scene)
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, fade_time)
	tween.finished.connect(func():
		await get_tree().create_timer(hold_time).timeout
		fade_out())

func fade_out():
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, fade_time)
	tween.finished.connect(func():
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
