extends Control

# 🎛️ UI Nodes
@onready var generate_button = $ButtonContainer/GenerateButton
@onready var search_button = $ButtonContainer/SearchButton
@onready var show_code_button = $ButtonContainer/ShowCodeButton
@onready var timeline_button = $ButtonContainer/TimelineButton
@onready var reset_button = $ButtonContainer/ResetButton

@onready var array_container = $ArrayContainer
@onready var message_label = $MessageLabel

@onready var code_popup = $CodePopup
@onready var code_text = $CodePopup/VBoxContainer/CodeText
@onready var close_code_button = $CodePopup/VBoxContainer/CloseCodeButton

@onready var timeline_popup = $TimelinePopup
@onready var timeline_text = $TimelinePopup/VBoxContainer/TimelineText
@onready var close_timeline_button = $TimelinePopup/VBoxContainer/CloseTimelineButton

@onready var search_popup = $SearchPopup
@onready var search_input = $SearchPopup/VBoxContainer/SearchInput
@onready var confirm_button = $SearchPopup/VBoxContainer/ConfirmButton
@onready var cancel_button = $SearchPopup/VBoxContainer/CancelButton

# 🧱 Packed Scene
@export var block_scene: PackedScene

# 📊 Variables
var array_data: Array = []
var timeline_log: Array = []
var searching: bool = false


func _ready() -> void:
	message_label.text = "🔍 Welcome to Binary Search Simulation!"

	generate_button.pressed.connect(_on_generate_pressed)
	search_button.pressed.connect(_on_search_pressed)
	show_code_button.pressed.connect(_on_show_code_pressed)
	timeline_button.pressed.connect(_on_timeline_pressed)
	reset_button.pressed.connect(_on_reset_pressed)

	confirm_button.pressed.connect(_on_confirm_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	close_code_button.pressed.connect(_on_close_code_pressed)
	close_timeline_button.pressed.connect(_on_close_timeline_pressed)

	search_popup.hide()
	show_code_button.disabled = true


# 🧱 Generate sorted numbers
func _on_generate_pressed() -> void:
	_clear_array()
	array_data.clear()

	randomize()
	var values = []
	for i in range(7):
		values.append(randi() % 50 + 1)
	values.sort()

	for v in values:
		var block = block_scene.instantiate()
		block.set_value(v)
		array_container.add_child(block)
		array_data.append(block)

	message_label.text = "✅ Generated sorted numbers: " + str(values)
	timeline_log.append("Generated sorted array: " + str(values))
	show_code_button.disabled = true


# 🔍 Open search popup
func _on_search_pressed() -> void:
	if array_data.is_empty():
		message_label.text = "⚠️ Generate numbers first!"
		return
	search_popup.popup_centered_ratio(0.3)


# ✅ Confirm search
func _on_confirm_pressed() -> void:
	var target = int(search_input.text)
	search_popup.hide()
	message_label.text = "🔎 Searching for: %d" % target
	timeline_log.append("Searching for value %d" % target)

	searching = true
	show_code_button.disabled = true
	_start_search(target)


func _on_cancel_pressed() -> void:
	search_popup.hide()
	message_label.text = "❌ Search canceled."


# 🔍 Binary Search Algorithm
func _start_search(target: int) -> void:
	var left = 0
	var right = array_data.size() - 1

	while left <= right:
		var mid = int((left + right) / 2)
		var mid_block = array_data[mid]

		mid_block.highlight(Color(1, 1, 0)) # Yellow for checking
		timeline_log.append("Checking index %d (value: %d)" % [mid, mid_block.value])
		await get_tree().create_timer(0.8).timeout

		if mid_block.value == target:
			mid_block.highlight(Color(0, 1, 0)) # Green if found
			message_label.text = "🎯 Found value %d at index %d!" % [target, mid]
			timeline_log.append("✅ Found value %d at index %d!" % [target, mid])
			searching = false
			show_code_button.disabled = false
			return

		elif mid_block.value < target:
			mid_block.highlight(Color(0.7, 0.7, 0.7))
			left = mid + 1
		else:
			mid_block.highlight(Color(0.7, 0.7, 0.7))
			right = mid - 1

		await get_tree().create_timer(0.6).timeout

	message_label.text = "❌ Value not found!"
	timeline_log.append("❌ Value %d not found in array." % target)
	searching = false
	show_code_button.disabled = false


# 🔁 Reset
func _on_reset_pressed() -> void:
	_clear_array()
	array_data.clear()
	timeline_log.append("🔄 Reset simulation.")
	message_label.text = "🔄 Simulation reset."
	show_code_button.disabled = true


func _clear_array() -> void:
	for child in array_container.get_children():
		child.queue_free()


# 💬 Show code
func _on_show_code_pressed() -> void:
	code_text.text = get_cpp_code()
	code_popup.popup_centered_ratio(0.7)
	message_label.text = "💡 Showing C++ equivalent code."


func get_cpp_code() -> String:
	# 🧩 Collect array numbers from the generated blocks
	var values = []
	for b in array_data:
		values.append(b.value)
	
	# Get the last searched target value if available
	var target_value = 0
	if search_input.text != "":
		target_value = int(search_input.text)

	var array_string = ", ".join(values.map(func(v): return str(v)))

	return """// Binary Search Implementation
#include <iostream>
using namespace std;

int binarySearch(int arr[], int n, int key) {
    int left = 0, right = n - 1;
    while (left <= right) {
        int mid = (left + right) / 2;
        if (arr[mid] == key)
            return mid;
        else if (arr[mid] < key)
            left = mid + 1;
        else
            right = mid - 1;
    }
    return -1;
}

int main() {
    int arr[] = { %s };
    int key = %d;
    int n = sizeof(arr) / sizeof(arr[0]);
    int result = binarySearch(arr, n, key);
    if (result != -1)
        cout << "Found at index " << result << endl;
    else
        cout << "Not found!" << endl;
}
""" % [array_string, target_value]


# 🕒 Timeline
func _on_timeline_pressed() -> void:
	var log_text = ""
	for line in timeline_log:
		log_text += "• " + line + "\n"
	timeline_text.text = log_text
	timeline_popup.popup_centered_ratio(0.7)
	message_label.text = "🧭 Viewing simulation timeline."


# ❌ Close popups
func _on_close_code_pressed() -> void:
	code_popup.hide()

func _on_close_timeline_pressed() -> void:
	timeline_popup.hide()
