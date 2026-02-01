extends Control

@onready var array_container: Control = $HBoxContainer3/ArrayContainer
@onready var target_input: LineEdit = $VBoxContainer/HBoxContainer2/TargetInput
@onready var result_popup: PopupPanel = $ResultPopup
@onready var result_label: Label = $ResultPopup/ResultLabel
@onready var explanation_popup: PopupPanel = $ExplanationPopup
@onready var explanation_text: RichTextLabel = $ExplanationPopup/ExplanationText
@onready var complexity_label: Label = $ComplexityLabel

const BLOCK_SCENE := preload("res://ArrayBlock.tscn")

var arr: Array[int] = []
var low := 0
var high := 0
var pos := 0
var target := 0
var step_index := 0
var found := false

# layout parameters
var START_POSITION := Vector2(50, 80)
var BLOCK_SPACING := 70.0

func _ready() -> void:
	randomize()
	complexity_label.text = "⏱ Best: O(1) | Avg: O(log log n) | Worst: O(n)\n💾 Space: O(1)"
	_reset_array_display()

# ✅ Generate sorted array horizontally
func _on_generate_array_buttton_pressed() -> void:
	if not array_container:
		push_error("ArrayContainer not found — check node path.")
		return

	# Clear previous blocks
	for child in array_container.get_children():
		child.queue_free()

	arr.clear()
	for i in range(10):
		arr.append(randi_range(1, 99))
	arr.sort()

	# Ensure ArrayContainer is a plain Control (not an HBoxContainer)
	var x_pos = START_POSITION.x
	for num in arr:
		var block = BLOCK_SCENE.instantiate()
		block.get_node("Label").text = str(num)
		array_container.add_child(block)
		block.position = Vector2(x_pos, START_POSITION.y)
		x_pos += block.size.x + BLOCK_SPACING

	explanation_text.text = "✅ Generated sorted array:\n" + str(arr)
	explanation_popup.popup_centered()
	found = false

# ✅ Begin search
func _on_search_pressed() -> void:
	if target_input.text.strip_edges() == "":
		explanation_text.text = "⚠️ Please enter a target value first."
		explanation_popup.popup_centered()
		return

	target = int(target_input.text)
	low = 0
	high = arr.size() - 1
	step_index = 0
	found = false
	explanation_text.text = "🔍 Starting Interpolation Search for %d..." % target
	explanation_popup.popup_centered()

# ✅ Step-by-step search
func _on_next_button_pressed() -> void:
	if found or arr.is_empty():
		return
	perform_step()

func perform_step() -> void:
	if low <= high and target >= arr[low] and target <= arr[high]:
		pos = low + int(((target - arr[low]) * (high - low)) / float(arr[high] - arr[low]))
		pos = clamp(pos, low, high)

		highlight_block(pos, Color.YELLOW)
		explanation_text.text = "📍 Checking index %d (value: %d)" % [pos, arr[pos]]

		if arr[pos] == target:
			highlight_block(pos, Color.GREEN)
			explanation_text.text = "🎯 Target %d found at index %d!" % [target, pos]
			show_result("✅ Target found at index %d!" % pos)
			found = true
			return
		elif arr[pos] < target:
			explanation_text.text = "➡️ Target is greater than %d, moving right..." % arr[pos]
			low = pos + 1
		else:
			explanation_text.text = "⬅️ Target is smaller than %d, moving left..." % arr[pos]
			high = pos - 1
	else:
		explanation_text.text = "❌ Target not found."
		show_result("❌ Target not found.")
		found = true

# ✅ Highlight current block
func highlight_block(index: int, color: Color) -> void:
	for i in range(array_container.get_child_count()):
		array_container.get_child(i).modulate = Color(1, 1, 1)
	if index >= 0 and index < array_container.get_child_count():
		array_container.get_child(index).modulate = color

# ✅ Show result popup
func show_result(msg: String) -> void:
	result_label.text = msg
	result_popup.popup_centered()

# ✅ Reset display
func _reset_array_display() -> void:
	if not array_container:
		return
	for child in array_container.get_children():
		child.queue_free()
	arr.clear()
