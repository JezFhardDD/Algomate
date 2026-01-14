extends Control

# 🎛️ UI Nodes
@onready var generate_button = $ButtonContainer/GenerateButton
@onready var reset_button = $ButtonContainer/ResetButton
@onready var show_code_button = $ButtonContainer/ShowCodeButton
@onready var timeline_button = $ButtonContainer/TimelineButton
@onready var auto_sort_button = $ButtonContainer/AutoSortButton
@onready var message_label = $MessageLabel
@onready var array_container = $ArrayContainer

# 💬 Popups
@onready var code_popup = $CodePopup
@onready var code_text = $CodePopup/VBoxContainer/CodeText
@onready var close_code_button = $CodePopup/VBoxContainer/CloseCodeButton

@onready var timeline_popup = $TimelinePopup
@onready var timeline_text = $TimelinePopup/VBoxContainer/TimelineText
@onready var close_timeline_button = $TimelinePopup/VBoxContainer/CloseTimelineButton

# 🧱 Packed Scene
@export var block_scene: PackedScene

# 📊 Variables
var blocks: Array = []
var dragging_block: ColorRect = null
var start_index: int = -1
var is_sorted: bool = false
var sorting: bool = false
var timeline_log: Array = []


func _ready() -> void:
	message_label.text = "🔹 Welcome to Bubble Sort Simulation!"
	
	generate_button.text = "🎲 Generate"
	reset_button.text = "🔁 Reset"
	show_code_button.text = "💻 Show Code"
	timeline_button.text = "🕒 Timeline"
	auto_sort_button.text = "⚙️ Auto Sort"

	generate_button.pressed.connect(_on_generate_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	show_code_button.pressed.connect(_on_show_code_pressed)
	timeline_button.pressed.connect(_on_timeline_pressed)
	auto_sort_button.pressed.connect(_on_auto_sort_pressed)
	close_code_button.pressed.connect(_on_close_code_pressed)
	close_timeline_button.pressed.connect(_on_close_timeline_pressed)


# 🧱 Generate blocks
func _on_generate_pressed() -> void:
	_clear_array()
	blocks.clear()
	timeline_log.clear()

	randomize()
	var values = []
	for i in range(6):
		values.append(randi() % 50 + 1)
	
	for v in values:
		var block = block_scene.instantiate()
		block.set_value(v)
		block.gui_input.connect(_on_block_input.bind(block))
		array_container.add_child(block)
		blocks.append(block)
	
	_position_blocks()
	message_label.text = "✅ Generated numbers: " + str(values)
	timeline_log.append("Generated array: " + str(values))
	is_sorted = false


# ♻️ Reset
func _on_reset_pressed() -> void:
	_clear_array()
	blocks.clear()
	timeline_log.append("Reset simulation.")
	message_label.text = "🔁 Simulation reset."
	is_sorted = false


# 🔧 Clear all children
func _clear_array() -> void:
	for c in array_container.get_children():
		c.queue_free()


# 📦 Position blocks in a row
func _position_blocks() -> void:
	var x = 0
	for block in blocks:
		block.position = Vector2(x, 0)
		block.original_position = block.position
		block.reset_color()
		x += block.size.x + 15


# 🖱️ Handle dragging and smooth neighbor movement
func _on_block_input(event: InputEvent, block: ColorRect) -> void:
	if is_sorted or sorting:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging_block = block
			start_index = blocks.find(block)
			block.original_position = block.position
			block.scale = Vector2(1.1, 1.1)
		else:
			if dragging_block:
				block.scale = Vector2(1, 1)
				await _check_swap(dragging_block)
			dragging_block = null

	elif event is InputEventMouseMotion and dragging_block == block:
		block.position.x += event.relative.x

		var i = blocks.find(block)
		if i > 0:
			var left_block = blocks[i - 1]
			if block.position.x < left_block.position.x + left_block.size.x * 0.6:
				var tween = create_tween()
				tween.tween_property(left_block, "position", left_block.original_position - Vector2(15, 0), 0.15)
			else:
				var tween = create_tween()
				tween.tween_property(left_block, "position", left_block.original_position, 0.15)

		if i < blocks.size() - 1:
			var right_block = blocks[i + 1]
			if block.position.x + block.size.x > right_block.position.x + right_block.size.x * 0.4:
				var tween = create_tween()
				tween.tween_property(right_block, "position", right_block.original_position + Vector2(15, 0), 0.15)
			else:
				var tween = create_tween()
				tween.tween_property(right_block, "position", right_block.original_position, 0.15)


# 🔍 Check and swap only adjacent blocks
func _check_swap(block: ColorRect) -> void:
	var i = blocks.find(block)
	if i < 0:
		return

	var nearest_index = -1
	var nearest_dist = INF
	for j in range(blocks.size()):
		if i == j:
			continue
		var dist = abs(blocks[j].position.x - block.position.x)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_index = j

	if nearest_index == -1:
		await _return_to_position(block)
		return

	if abs(i - nearest_index) == 1:
		if blocks[i].value > blocks[nearest_index].value:
			await _swap_blocks(i, nearest_index)
			message_label.text = "🔄 Swapped %d ↔ %d" % [blocks[i].value, blocks[nearest_index].value]
			timeline_log.append("Swapped %d and %d manually." % [blocks[i].value, blocks[nearest_index].value])
		else:
			message_label.text = "❌ Invalid move! Left must be greater than right."
			block.highlight(Color(1, 0.4, 0.4))
			await get_tree().create_timer(0.4).timeout
			block.reset_color()
			await _return_to_position(block)
	else:
		message_label.text = "⚠️ You can only swap adjacent blocks."
		await _return_to_position(block)


# 🔁 Swap helper
func _swap_blocks(i: int, j: int) -> void:
	var temp = blocks[i]
	blocks[i] = blocks[j]
	blocks[j] = temp

	var a = blocks[i]
	var b = blocks[j]

	var tween = create_tween()
	tween.tween_property(a, "position", Vector2(b.original_position.x, a.position.y), 0.3)
	tween.parallel().tween_property(b, "position", Vector2(a.original_position.x, b.position.y), 0.3)

	await tween.finished

	_position_blocks()
	a.reset_color()
	b.reset_color()

	if _is_sorted():
		message_label.text = "🎉 Array is fully sorted!"
		timeline_log.append("Array sorted successfully!")
		is_sorted = true


# 🔙 Snap back to original position
func _return_to_position(block: ColorRect) -> void:
	var tween = create_tween()
	tween.tween_property(block, "position", block.original_position, 0.25)
	await tween.finished


# ✅ Check if sorted
func _is_sorted() -> bool:
	for i in range(blocks.size() - 1):
		if blocks[i].value > blocks[i + 1].value:
			return false
	return true


# ⚙️ Auto Sort (Animated Bubble Sort)
func _on_auto_sort_pressed() -> void:
	if sorting or is_sorted:
		return
	sorting = true
	message_label.text = "⚙️ Auto sorting..."
	timeline_log.append("Started auto sort.")
	await _auto_bubble_sort()
	sorting = false


# 🧮 Animated Bubble Sort
func _auto_bubble_sort() -> void:
	var n = blocks.size()
	for i in range(n - 1):
		for j in range(n - i - 1):
			var a = blocks[j]
			var b = blocks[j + 1]
			a.highlight(Color(1, 1, 0.5))
			b.highlight(Color(1, 1, 0.5))
			await get_tree().create_timer(0.3).timeout

			if a.value > b.value:
				await _swap_blocks(j, j + 1)
				message_label.text = "🔄 Swapped %d ↔ %d" % [a.value, b.value]
				timeline_log.append("Auto swapped %d and %d." % [a.value, b.value])

			a.reset_color()
			b.reset_color()

	if _is_sorted():
		message_label.text = "🎉 Auto sort complete!"
		timeline_log.append("Auto sort finished successfully!")
		is_sorted = true


# ==============================
# 💬 POPUP HANDLERS BELOW
# ==============================

func _on_show_code_pressed() -> void:
	code_text.text = get_cpp_code()
	code_popup.popup_centered_ratio(0.7)
	message_label.text = "💡 Showing C++ equivalent code."
	timeline_log.append("Opened C++ code popup.")


func get_cpp_code() -> String:
	return """// Bubble Sort in C++
#include <iostream>
using namespace std;

void bubbleSort(int arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                swap(arr[j], arr[j + 1]);
            }
        }
    }
}

int main() {
    int arr[] = {21, 49, 23, 9, 22, 15};
    int n = sizeof(arr)/sizeof(arr[0]);
    bubbleSort(arr, n);
    cout << "Sorted array: ";
    for (int i = 0; i < n; i++)
        cout << arr[i] << " ";
}
"""


# 🕒 Show Timeline
func _on_timeline_pressed() -> void:
	var log_text = ""
	for line in timeline_log:
		log_text += "• " + line + "\n"
	timeline_text.text = log_text
	timeline_popup.popup_centered_ratio(0.7)
	message_label.text = "🧭 Viewing simulation timeline."


# ❌ Close Popups
func _on_close_code_pressed() -> void:
	code_popup.hide()

func _on_close_timeline_pressed() -> void:
	timeline_popup.hide()
