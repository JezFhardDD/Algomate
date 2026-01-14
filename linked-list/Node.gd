extends Control

@onready var front_panel: Panel = $FrontPanel
@onready var back_panel: Panel = $BackPanel
@onready var front_label: Label = $FrontPanel/ValueLabel
@onready var back_label: Label = $BackPanel/BackLabel

var value: int = 0
var flipped: bool = false
var flip_speed := 0.3
var can_flip: bool = false

var names = [
	"Aiden", "Bianca", "Carlos", "Diana", "Ethan",
	"Faith", "Gabriel", "Hannah", "Ivan", "Jasmine",
	"Kevin", "Lara", "Mason", "Nina", "Owen",
	"Paula", "Quinn", "Rico", "Sofia", "Tyler",
	"Uma", "Vince", "Wendy", "Xander", "Yana", "Zack"
]

var random_name: String = ""

func _ready() -> void:
	randomize() # ✅ ensures names are actually random each run
	back_panel.visible = false

	front_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	back_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	front_panel.gui_input.connect(_on_panel_input)
	back_panel.gui_input.connect(_on_panel_input)

	random_name = names[randi() % names.size()]
	_update_text()

func _on_panel_input(event: InputEvent) -> void:
	if not can_flip:
		print("⛔ Node cannot be flipped yet (not traversed).")
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("🖱️ Panel clicked — flipping card")
		flip_card()

func set_value(v: int) -> void:
	value = v
	_update_text()

func _update_text() -> void:
	if front_label:
		front_label.text = "Node %d" % value
	if back_label:
		back_label.text = random_name

func flip_card() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale:x", 0.0, flip_speed / 2)
	tween.tween_callback(func ():
		front_panel.visible = flipped
		back_panel.visible = !flipped)
	tween.tween_property(self, "scale:x", 1.0, flip_speed / 2)
	flipped = !flipped

func highlight():
	var tween = create_tween()
	tween.tween_property(front_panel, "modulate", Color(0.6, 0.9, 1.0), 0.2)

func unhighlight():
	var tween = create_tween()
	tween.tween_property(front_panel, "modulate", Color(1, 1, 1), 0.2)
