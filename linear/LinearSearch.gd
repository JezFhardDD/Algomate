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

# 🆕 Search Popup
@onready var search_popup = $SearchPopup
@onready var search_input = $SearchPopup/VBoxContainer/SearchInput
@onready var confirm_button = $SearchPopup/VBoxContainer/ConfirmButton
@onready var cancel_button = $SearchPopup/VBoxContainer/CancelButton
@onready var search_label = $SearchPopup/VBoxContainer/Label

# 🎲 Packed Scene
@export var block_scene: PackedScene

# 🧱 Variables
var array_data: Array = []
var timeline_log: Array = []
var searching: bool = false


func _ready() -> void:
	message_label.text = "🔍 Welcome to Linear Search Simulation!"
	
	generate_button.pressed.connect(_on_generate_pressed)
	search_button.pressed.connect(_on_search_pressed)
	show_code_button.pressed.connect(_on_show_code_pressed)
	timeline_button.pressed.connect(_on_timeline_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	close_code_button.pressed.connect(_on_close_code_pressed)
	close_timeline_button.pressed.connect(_on_close_timeline_pressed)
	confirm_button.pressed.connect(_on_confirm_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	
	search_popup.hide()  # hide at start


# 🧱 Generate random numbers
func _on_generate_pressed() -> void:
	_clear_array()
	array_data.clear()
	
	randomize()
	for i in range(7):
		var block = block_scene.instantiate()
		var value = randi() % 50 + 1
		block.set_value(value)
		array_container.add_child(block)
		array_data.append(block)
	
	message_label.text = "✅ Generated 7 random numbers."
	timeline_log.append("Generated new array with random numbers.")
	show_code_button.disabled = true  # restrict show code until done


# 🔍 Search button pressed
func _on_search_pressed() -> void:
	if array_data.is_empty():
		message_label.text = "⚠️ Generate numbers first!"
		return

	if searching:
		message_label.text = "⏳ Search already in progress..."
		return

	# show popup and display array values
	var nums = []
	for block in array_data:
		nums.append(str(block.value))
	search_label.text = "Array: [" + ", ".join(nums) + "]"
	search_input.text = ""
	search_popup.popup_centered_ratio(0.5)


# ☑ Confirm search
func _on_confirm_pressed() -> void:
	var input_text = search_input.text.strip_edges()
	if input_text == "" or not input_text.is_valid_int():
		message_label.text = "⚠️ Please enter a valid number!"
		return
	
	var target = int(input_text)
	search_popup.hide()
	message_label.text = "🔎 Searching for: %d" % target
	timeline_log.append("Searching for value %d" % target)
	
	searching = true
	show_code_button.disabled = true  # disable while searching
	_start_search(target)


# ❌ Cancel search popup
func _on_cancel_pressed() -> void:
	search_popup.hide()
	message_label.text = "❌ Search canceled."


# 🔍 Linear search logic
func _start_search(target: int) -> void:
	await get_tree().create_timer(0.5).timeout
	for i in range(array_data.size()):
		var block = array_data[i]
		block.highlight(Color(1, 1, 0)) # Yellow for checking
		timeline_log.append("Checking index %d (value: %d)" % [i, block.value])
		await get_tree().create_timer(0.6).timeout
		
		if block.value == target:
			block.highlight(Color(0, 1, 0)) # Green if found
			message_label.text = "🎯 Found value %d at index %d!" % [target, i]
			timeline_log.append("✅ Found value %d at index %d!" % [target, i])
			searching = false
			show_code_button.disabled = false  # re-enable after finished
			return
		else:
			block.highlight(Color(1, 0.4, 0.4)) # Red if not match
			await get_tree().create_timer(0.3).timeout
			block.reset_color()

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


# 💬 Show C++ code
func _on_show_code_pressed() -> void:
	code_text.text = get_cpp_code()
	code_popup.popup_centered_ratio(0.7)
	message_label.text = "💡 Showing C++ equivalent code."


func get_cpp_code() -> String:
	return """// Linear Search Implementation
#include <iostream>
using namespace std;

int linearSearch(int arr[], int n, int key) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == key) {
            cout << "Found at index " << i << endl;
            return i;
        }
    }
    cout << "Not found!" << endl;
    return -1;
}

int main() {
    int arr[] = {10, 25, 30, 15, 40, 22, 18};
    int key = 30;
    linearSearch(arr, 7, key);
    return 0;
}
"""


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
