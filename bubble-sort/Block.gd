extends ColorRect

@onready var label: Label = $Label

var value: int = 0
var original_position: Vector2
var is_dragging: bool = false
var base_color: Color

func _ready() -> void:
	size = Vector2(80, 80)
	mouse_filter = Control.MOUSE_FILTER_PASS

	# 🎨 Assign a random pastel color
	_set_random_color()

	# ✅ Ensure label exists and display value
	if label:
		label.text = str(value)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.autowrap_mode = TextServer.AUTOWRAP_OFF
	else:
		push_warning("⚠️ Label not found in Block.tscn")


func set_value(v: int) -> void:
	value = v
	if label:
		label.text = str(v)
	else:
		push_warning("⚠️ Label not found in Block.tscn")

	# Update block color when value changes
	_set_random_color()


# 🎨 Assign a random pastel color
func _set_random_color() -> void:
	randomize()
	var hue = randf()
	base_color = Color.from_hsv(hue, 0.4, 0.9)
	color = base_color


# ✨ Highlight when selected or swapped
func highlight(col: Color) -> void:
	color = col


# 🔄 Reset to the block’s original color
func reset_color() -> void:
	color = base_color
