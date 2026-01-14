extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $ColorRect/Label

var value: int = 0

func _ready() -> void:
	custom_minimum_size = Vector2(60, 60)
	set_value(value)
	reset_color()

func set_value(v: int) -> void:
	value = v
	if label:
		label.text = str(v)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	else:
		print("⚠️ Label node not found in Block scene!")

func highlight(color: Color) -> void:
	if color_rect:
		color_rect.color = color

func reset_color() -> void:
	if color_rect:
		color_rect.color = Color(1, 1, 1)
