extends Control

# --- 1. NODE REFERENCES ---
@onready var enqueue_btn: Button = $VBoxContainer/Addelement
@onready var dequeue_btn: Button = $VBoxContainer/Searchstep
@onready var waiting_btn: Button = $VBoxContainer/WaitingElements
@onready var timeline_btn: Button = $VBoxContainer/TimelineButton
@onready var simulate_new_btn: Button = $VBoxContainer/SimulateNew

@onready var enqueue_label: Label = $HBoxContainer/Label
@onready var dequeue_label: Label = $HBoxContainer2/Label
@onready var queue_container: Control = $QueueContainer

# --- INPUT POPUP NODES ---
@onready var search_modal: ConfirmationDialog = get_node_or_null("SearchInputModal")
@onready var target_spinbox: SpinBox = get_node_or_null("SearchInputModal/TargetSpinBox")

# Popups
@onready var waiting_popup: Popup = $WaitingPopup
# FIX: Path includes ScrollContainer
@onready var waiting_label: Label = $WaitingPopup/VBoxContainer/Label

@onready var timeline_popup: Popup = $TimelinePopup
# FIX: Path includes ScrollContainer
@onready var timeline_label: Label = $TimelinePopup/ScrollContainer/VBoxContainer/Label

@onready var complete_popup: PopupPanel = get_node_or_null("SimulationCompletePopup") as PopupPanel
@onready var complete_ok_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/CloseButton") as Button
@onready var process_label: Label = $SimulationCompletePopup/VBoxContainer/ProcessLabel

# C++ Popup references
@onready var show_cpp_btn: Button = get_node_or_null("SimulationCompletePopup/VBoxContainer/ShowCppButton") as Button
@onready var cpp_popup: PopupPanel = get_node_or_null("CppPopup") as PopupPanel
@onready var cpp_text: TextEdit = get_node_or_null("CppPopup/VBoxContainer/TextEdit") as TextEdit

# FIX: Use "close" (lowercase) to match scene
@onready var cpp_close_btn: Button = get_node_or_null("CppPopup/VBoxContainer/close") as Button
@onready var cpp_code_button: Button = get_node_or_null("CppCodeButton")

# C++ Tutorial Nodes
@onready var cpp_tutorial_panel: Panel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel")
@onready var cpp_explanation_text: RichTextLabel = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/ExplanationText")
@onready var cpp_next_button: Button = get_node_or_null("CppPopup/VBoxContainer/TutorialPanel/CppNextButton") 

# Main Tutorial Nodes
@onready var tutorial_overlay: CanvasLayer = $TutorialOverlay
@onready var dim_bg: ColorRect = $TutorialOverlay/DimBackground
@onready var tutorial_box: Panel = $TutorialOverlay/TutorialBox
@onready var tutorial_text: Label = $TutorialOverlay/TutorialBox/TutorialText
@onready var tutorial_next: Button = $TutorialOverlay/TutorialBox/NextButton 
@onready var pointer_sprite: Sprite2D = $TutorialOverlay/PointerSprite
@onready var help_btn: Button = get_node_or_null("HelpButton")

# Config Modals
@onready var config_modal: Panel = $ConfigChoiceModal
@onready var size_input: SpinBox = $ConfigChoiceModal/SpinBox
@onready var yes_btn: Button = $ConfigChoiceModal/yesButton
@onready var no_btn: Button = $ConfigChoiceModal/NoButton
@onready var config_size_elements_modal: Panel = $ConfigSizeElementsModal
@onready var size_input_detailed: SpinBox = $ConfigSizeElementsModal/SizeSpinBox
@onready var elements_input: TextEdit = $ConfigSizeElementsModal/ElementsTextEdit
@onready var random_elements_btn: Button = $ConfigSizeElementsModal/RandomElementsButton
@onready var confirm_btn: Button = $ConfigSizeElementsModal/ConfirmButton
@onready var cancel_btn: Button = $ConfigSizeElementsModal/CancelButton

# Visual Assets
@onready var current_icon: Node = $TextureRect/front 
@onready var unused_icon: Node = $TextureRect/rear
@onready var audio_player = $bgm
@onready var btn_sound = $btn_sound

# --- 2. CONFIGURATION ---
const BLOCK_SCENE := preload("res://LinearBlock.tscn")

var MAX_SIZE: int = 6
var BLOCK_SPACING: float = 30.0 
var START_POSITION: Vector2 = Vector2(80, 80)

# --- 3. STATE VARIABLES ---
var array_data: Array[int] = []          
var waiting_data: Array[int] = []        
var log_history: Array[String] = []      
var comparison_count: int = 0

# Linear Search Variables
var current_index: int = 0
var target_value: int = -1
var is_searching: bool = false
var current_action_text: String = ""

# Tutorial & Code View
var tutorial_sequence = []
var tutorial_sequence_index = 0
var tutorial_in_progress = false
var cpp_tutorial_index := 0
var cpp_tutorial_steps := []
var current_language: String = "C++" 

# --- 4. INITIALIZATION ---
func _ready() -> void:
	print("--- Linear Search Visualizer Started ---")
	randomize()
	
	if enqueue_btn: enqueue_btn.text = "ADD ELEMENT"
	if dequeue_btn: dequeue_btn.text = "SEARCH STEP" 
	if waiting_btn: waiting_btn.text = "WAITING"
	
	var old_history_btn = get_node_or_null("VBoxContainer/DequeuedElements")
	if old_history_btn: old_history_btn.hide()
	
	_hide_pointers()
	_connect_signals()
	_ready_tutorial_connection()
	
	call_deferred("_setup_language_buttons")
	
	config_modal.hide()
	if config_size_elements_modal: config_size_elements_modal.hide()
	_show_config_modal()

func _connect_signals() -> void:
	if not enqueue_btn.is_connected("pressed", _on_add_element_pressed): enqueue_btn.pressed.connect(_on_add_element_pressed)
	if not dequeue_btn.is_connected("pressed", _on_search_step_pressed): dequeue_btn.pressed.connect(_on_search_step_pressed)
	
	if not waiting_btn.is_connected("pressed", _on_waiting_pressed): waiting_btn.pressed.connect(_on_waiting_pressed)
	if not timeline_btn.is_connected("pressed", _on_timeline_pressed): timeline_btn.pressed.connect(_on_timeline_pressed)
	if not simulate_new_btn.is_connected("pressed", _on_reset_pressed): simulate_new_btn.pressed.connect(_on_reset_pressed)
	
	if yes_btn: yes_btn.pressed.connect(_on_config_yes)
	if no_btn: no_btn.pressed.connect(_on_config_no)
	if random_elements_btn: random_elements_btn.pressed.connect(_gen_random_config)
	if confirm_btn: confirm_btn.pressed.connect(_on_config_confirm)
	if cancel_btn: cancel_btn.pressed.connect(_on_config_cancel)
	
	if size_input_detailed:
		if not size_input_detailed.is_connected("value_changed", _on_size_spinbox_changed):
			size_input_detailed.value_changed.connect(_on_size_spinbox_changed)
	
	if search_modal:
		if not search_modal.is_connected("confirmed", _on_target_confirmed):
			search_modal.confirmed.connect(_on_target_confirmed)
	
	if complete_ok_btn: complete_ok_btn.pressed.connect(func(): complete_popup.hide())
	if show_cpp_btn: show_cpp_btn.pressed.connect(_show_code_popup)
	if cpp_code_button: cpp_code_button.pressed.connect(_show_code_popup)
	
	# FIX: Connect the Code Popup Close Button
	if cpp_close_btn: 
		if not cpp_close_btn.is_connected("pressed", _on_close_code_popup):
			cpp_close_btn.pressed.connect(_on_close_code_popup)
	else:
		print("ERROR: Code Popup Close button not found. Check node name!")
	
	if cpp_next_button:
		if not cpp_next_button.is_connected("pressed", _on_cpp_next_button_pressed):
			cpp_next_button.pressed.connect(_on_cpp_next_button_pressed)

func _on_close_code_popup():
	cpp_popup.hide()

# --- 5. SETUP LANGUAGE BUTTONS ---
func _setup_language_buttons():
	if not cpp_popup: return
	
	var vbox = cpp_popup.get_node_or_null("VBoxContainer")
	if not vbox: return
	
	if vbox.has_node("LanguageContainer"): return
	
	var lang_hbox = HBoxContainer.new()
	lang_hbox.name = "LanguageContainer"
	lang_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	
	var languages = ["C++", "Python", "Java", "C"]
	for lang in languages:
		var btn = Button.new()
		btn.text = lang
		btn.custom_minimum_size = Vector2(80, 30)
		btn.pressed.connect(func(): _switch_language(lang))
		lang_hbox.add_child(btn)
	
	vbox.add_child(lang_hbox)
	vbox.move_child(lang_hbox, 0) 

func _switch_language(lang: String):
	btn_sound.play()
	current_language = lang
	_update_code_text()
	
	# FIX: Reset tutorial state completely when switching languages
	cpp_tutorial_index = 0
	if cpp_tutorial_panel: 
		cpp_tutorial_panel.show()
	show_cpp_explanation()

# --- 6. CONFIGURATION ---
func _show_config_modal(): config_modal.show()
func _on_config_yes(): config_modal.hide(); _show_detailed_config()

func _on_config_no(): 
	MAX_SIZE = randi_range(5, 7) 
	var rnd: Array[int] = [] 
	for i in range(MAX_SIZE): 
		rnd.append(randi_range(1, 99))
	config_modal.hide()
	_init_simulation(rnd)

func _show_detailed_config():
	size_input_detailed.min_value = 5
	size_input_detailed.max_value = 7
	size_input_detailed.value = 5
	_gen_random_config()
	config_size_elements_modal.show()

func _on_size_spinbox_changed(new_val: float) -> void:
	_gen_random_config()

func _gen_random_config():
	var sz = int(size_input_detailed.value)
	var arr = []
	for i in range(sz): arr.append(str(randi_range(1,99)))
	elements_input.text = ", ".join(arr)

func _on_config_confirm():
	MAX_SIZE = int(size_input_detailed.value)
	var txt = elements_input.text.split(",")
	var arr: Array[int] = []
	for t in txt: 
		if t.strip_edges().is_valid_int(): 
			arr.append(int(t.strip_edges()))
	while arr.size() > 7: arr.pop_back()
	while arr.size() < 5: arr.append(randi_range(1, 99))
	config_size_elements_modal.hide()
	_init_simulation(arr)

func _on_config_cancel(): config_size_elements_modal.hide(); config_modal.show()

func _init_simulation(data: Array[int]):
	if audio_player: audio_player.play()
	waiting_data = data
	_update_ui()
	if cpp_code_button: cpp_code_button.hide()

# --- 7. LINEAR SEARCH LOGIC ---

func _on_add_element_pressed():
	if is_searching: return 
	if array_data.size() >= MAX_SIZE or waiting_data.is_empty(): return
	
	btn_sound.play()
	var val = waiting_data.pop_front()
	array_data.append(val)
	log_history.append("Added %d" % val)
	
	var blk = BLOCK_SCENE.instantiate()
	blk.set("value", val)
	
	var base_col = Color(1, 0.6, 0.2)
	if blk.has_method("set_base_color"): blk.set_base_color(base_col)
	else: blk.modulate = base_col
	
	queue_container.add_child(blk)
	
	var idx = array_data.size() - 1
	var block_width = 64.0 
	var target_x = START_POSITION.x + idx * (block_width + BLOCK_SPACING)
	var target_pos = Vector2(target_x, START_POSITION.y)
	
	blk.position = target_pos + Vector2(200, 0)
	blk.modulate.a = 0
	
	var tw = create_tween().set_parallel(true)
	tw.tween_property(blk, "position", target_pos, 0.5).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(blk, "modulate:a", 1.0, 0.4)
	
	_update_ui()

func _on_search_step_pressed():
	if array_data.size() < 1: return
	
	if not is_searching:
		if search_modal:
			search_modal.popup_centered()
		else:
			target_value = array_data.pick_random()
			_start_search_process()
		return
	
	btn_sound.play()
	_execute_search_step()

func _on_target_confirmed():
	btn_sound.play()
	if target_spinbox:
		target_value = int(target_spinbox.value)
	else:
		target_value = 0
	_start_search_process()

func _start_search_process():
	is_searching = true
	current_index = 0
	comparison_count = 0
	enqueue_btn.disabled = true
	
	log_history.append("--- Linear Search Started ---")
	log_history.append("Looking for: %d" % target_value)
	current_action_text = "Target: %d" % target_value
	
	if current_icon: current_icon.show()
	if unused_icon: unused_icon.hide()
	
	_update_pointers()
	_update_ui()

func _execute_search_step():
	if current_index >= array_data.size():
		current_action_text = "End of list. Not Found!"
		_finish_simulation(false)
		return

	var blk = queue_container.get_child(current_index)
	var val = array_data[current_index]
	
	comparison_count += 1
	_update_pointers()
	
	if current_index > 0:
		var prev = queue_container.get_child(current_index - 1)
		prev.modulate = Color(1, 0.3, 0.3) 
	
	var tw = create_tween()
	tw.tween_property(blk, "scale", Vector2(1.2, 1.2), 0.1)
	tw.tween_property(blk, "scale", Vector2(1.0, 1.0), 0.1)
	
	if val == target_value:
		blk.modulate = Color(0.2, 1, 0.2) 
		current_action_text = "Found %d at index %d!" % [val, current_index]
		log_history.append(current_action_text)
		_update_ui()
		_finish_simulation(true)
	else:
		blk.modulate = Color(0.2, 0.8, 1) 
		current_action_text = "Checking %d... No match." % val
		log_history.append("Checked %d != %d" % [val, target_value])
		current_index += 1
		_update_ui()

func _finish_simulation(found: bool):
	var msg = ""
	if found:
		msg = "Target %d Found!\nComparisons: %d" % [target_value, comparison_count]
	else:
		msg = "Target %d Not Found.\nComparisons: %d" % [target_value, comparison_count]
	process_label.text = msg
	complete_popup.popup_centered()
	if cpp_code_button: cpp_code_button.show()
	
	if not found and current_index > 0:
		var last = queue_container.get_child(current_index - 1)
		if last: last.modulate = Color(1, 0.3, 0.3)

func _update_pointers():
	if not is_searching: return
	
	if current_index < queue_container.get_child_count():
		var block = queue_container.get_child(current_index)
		var target_pos = block.global_position
		target_pos.x += block.size.x / 2.0
		target_pos.y -= 50
		
		current_icon.get_parent().position = Vector2.ZERO
		var tw = create_tween().set_trans(Tween.TRANS_CUBIC)
		tw.tween_property(current_icon, "global_position", target_pos, 0.2)

func _hide_pointers():
	if current_icon: current_icon.hide()
	if unused_icon: unused_icon.hide()

func _on_reset_pressed():
	btn_sound.play()
	for c in queue_container.get_children(): c.queue_free()
	array_data.clear(); waiting_data.clear(); log_history.clear()
	comparison_count = 0; is_searching = false
	current_index = 0
	target_value = -1
	current_action_text = ""
	_hide_pointers()
	_on_config_no()

# --- HELPER FUNCTIONS ---
func _update_ui():
	enqueue_label.text = "Target: %d" % target_value if is_searching else "Add Elements"
	dequeue_label.text = "Comparisons: %d | %s" % [comparison_count, current_action_text]
	enqueue_btn.disabled = (is_searching or waiting_data.is_empty())

func _on_waiting_pressed():
	waiting_label.text = "Waiting Numbers:\n" + str(waiting_data)
	waiting_popup.popup_centered()

func _on_timeline_pressed():
	timeline_label.text = "Log:\n" + "\n".join(log_history)
	timeline_popup.popup_centered()

func _on_cpp_next_button_pressed() -> void:
	btn_sound.play()
	cpp_tutorial_index += 1
	show_cpp_explanation()

# --- 8. MULTI-LANGUAGE CODE GENERATION ---
func _show_code_popup():
	complete_popup.hide()
	current_language = "C++" # Default reset
	_update_code_text()
	cpp_popup.popup_centered()
	# Reset tutorial
	cpp_tutorial_index = 0
	if cpp_tutorial_panel: cpp_tutorial_panel.show()
	show_cpp_explanation()

func _update_code_text():
	var arr_str = ", ".join(array_data.map(func(x): return str(x)))
	var code = ""
	
	match current_language:
		"C++":
			code = """#include <iostream>
using namespace std;

int linearSearch(int arr[], int n, int target) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == target) {
            return i; // Found at index i
        }
    }
    return -1; // Not found
}

int main() {
    int arr[] = { %s };
    int target = %d;
    int n = sizeof(arr) / sizeof(arr[0]);
    
    int result = linearSearch(arr, n, target);
    
    if(result != -1) cout << "Found at index " << result;
    else cout << "Not found";
    
    return 0;
}""" % [arr_str, target_value]
			
			cpp_tutorial_steps = [
				{ "lines": Vector2i(3, 3), "text": "1. Function takes array and target." },
				{ "lines": Vector2i(4, 4), "text": "2. Loop through every element." },
				{ "lines": Vector2i(5, 7), "text": "3. Check equality. Return index if found." },
				{ "lines": Vector2i(9, 9), "text": "4. Return -1 if loop finishes without success." }
			]

		"Python":
			code = """def linear_search(arr, target):
    for i in range(len(arr)):
        if arr[i] == target:
            return i
    return -1

arr = [%s]
target = %d

result = linear_search(arr, target)

if result != -1:
    print(f"Found at index {result}")
else:
    print("Not found")
""" % [arr_str, target_value]

			cpp_tutorial_steps = [
				{ "lines": Vector2i(0, 0), "text": "1. Define function with array and target." },
				{ "lines": Vector2i(1, 1), "text": "2. Iterate through list indices." },
				{ "lines": Vector2i(2, 3), "text": "3. If match found, return current index." },
				{ "lines": Vector2i(4, 4), "text": "4. Return -1 if not found." }
			]

		"Java":
			code = """public class Main {
    public static int linearSearch(int[] arr, int target) {
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] == target) {
                return i;
            }
        }
        return -1;
    }

    public static void main(String[] args) {
        int[] arr = { %s };
        int target = %d;
        
        int result = linearSearch(arr, target);
        
        if (result != -1) 
            System.out.println("Found at index " + result);
        else 
            System.out.println("Not found");
    }
}""" % [arr_str, target_value]

			cpp_tutorial_steps = [
				{ "lines": Vector2i(1, 1), "text": "1. Define static method." },
				{ "lines": Vector2i(2, 2), "text": "2. Loop from 0 to array length." },
				{ "lines": Vector2i(3, 5), "text": "3. Check if element matches target." },
				{ "lines": Vector2i(7, 7), "text": "4. Return -1 if element is not in array." }
			]

		"C":
			code = """#include <stdio.h>

int linearSearch(int arr[], int n, int target) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == target) {
            return i;
        }
    }
    return -1;
}

int main() {
    int arr[] = { %s };
    int target = %d;
    int n = sizeof(arr) / sizeof(arr[0]);
    
    int result = linearSearch(arr, n, target);
    
    if(result != -1) printf("Found at index %d", result);
    else printf("Not found");
    
    return 0;
}""" % [arr_str, target_value]

			cpp_tutorial_steps = [
				{ "lines": Vector2i(2, 2), "text": "1. Define function taking array pointer." },
				{ "lines": Vector2i(3, 3), "text": "2. Loop through n elements." },
				{ "lines": Vector2i(4, 6), "text": "3. If match found, return index." },
				{ "lines": Vector2i(8, 8), "text": "4. Return -1 if loop ends." }
			]

	cpp_text.text = code
	
	# Restart tutorial from step 0 when switching language
	cpp_tutorial_index = 0
	show_cpp_explanation()

# --- TUTORIAL BOILERPLATE ---
func start_cpp_code_tutorial() -> void:
	if not cpp_tutorial_panel: return
	cpp_tutorial_index = 0
	cpp_tutorial_panel.show()
	highlight_cpp_code()
	show_cpp_explanation()

func highlight_cpp_code() -> void:
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 0.8, 0.15)
	sb.border_color = Color(1, 1, 0.2, 1)
	sb.set_border_width_all(4) 
	cpp_text.add_theme_stylebox_override("normal", sb)

func clear_cpp_highlight() -> void:
	cpp_text.remove_theme_stylebox_override("normal")

func show_cpp_explanation() -> void:
	if cpp_tutorial_index >= cpp_tutorial_steps.size():
		end_cpp_tutorial()
		return
	var step = cpp_tutorial_steps[cpp_tutorial_index]
	if cpp_explanation_text:
		cpp_explanation_text.text = step["text"]
	
	# FIX: Correctly read lines from step data
	var lines = step["lines"]
	highlight_cpp_lines(lines.x, lines.y)

func highlight_cpp_lines(start_line: int, end_line: int) -> void:
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 0.8, 0.1)
	sb.border_color = Color(1, 1, 0.2, 1)
	sb.set_border_width_all(2)
	cpp_text.add_theme_stylebox_override("normal", sb)
	cpp_text.select(start_line, 0, end_line, 0)

func end_cpp_tutorial() -> void:
	cpp_tutorial_panel.hide()
	clear_cpp_highlight()

func _ready_tutorial_connection():
	if help_btn and not help_btn.is_connected("pressed", _on_help_button_pressed):
		help_btn.pressed.connect(_on_help_button_pressed)
	if tutorial_next and not tutorial_next.is_connected("pressed", _on_tutorial_next_pressed):
		tutorial_next.pressed.connect(_on_tutorial_next_pressed)

func _on_help_button_pressed() -> void:
	btn_sound.play()
	start_main_tutorial()

func start_main_tutorial() -> void:
	tutorial_in_progress = true
	tutorial_sequence_index = 0
	tutorial_overlay.show()
	dim_bg.show()
	tutorial_box.show()
	
	tutorial_sequence = [
		{ "node": null, "text": "LINEAR SEARCH:\nChecks each element sequentially.", "action": "next" },
		{ "node": enqueue_btn, "text": "ADD ELEMENT: Fill the array.", "action": "next" },
		{ "node": dequeue_btn, "text": "SEARCH STEP: Check next element.", "action": "next" },
		{ "node": waiting_btn, "text": "WAITING: Upcoming numbers.", "action": "next" },
		{ "node": timeline_btn, "text": "TIMELINE: History log.", "action": "next" },
		{ "node": simulate_new_btn, "text": "SIMULATE NEW: Reset.", "action": "end" }
	]
	show_tutorial_step()

func show_tutorial_step() -> void:
	if tutorial_sequence_index >= tutorial_sequence.size():
		end_main_tutorial()
		return
	var step = tutorial_sequence[tutorial_sequence_index]
	var node = step["node"]
	tutorial_text.text = step["text"]
	
	if node:
		pointer_sprite.show()
		var ptr_pos = node.get_global_rect().position 
		ptr_pos.x += 200 
		ptr_pos.y += node.size.y / 2
		pointer_sprite.global_position = ptr_pos
		_highlight_node(node)
	else:
		pointer_sprite.hide()
		_clear_highlights()
	
	if step["action"] == "next":
		tutorial_next.show(); tutorial_next.text = "Next"
	elif step["action"] == "end":
		tutorial_next.show(); tutorial_next.text = "Finish"

func _highlight_node(node: Control):
	_clear_highlights()
	if node:
		var tw = create_tween().set_loops()
		tw.tween_property(node, "modulate", Color(1.5, 1.5, 1.5), 0.5)
		tw.tween_property(node, "modulate", Color(1, 1, 1), 0.5)
		node.set_meta("tutorial_tween", tw)

func _clear_highlights():
	var buttons = [enqueue_btn, dequeue_btn, timeline_btn, simulate_new_btn, waiting_btn]
	for b in buttons:
		if b.has_meta("tutorial_tween"):
			var tw = b.get_meta("tutorial_tween") as Tween
			if tw: tw.kill()
		b.modulate = Color(1, 1, 1)

func _on_tutorial_next_pressed() -> void:
	btn_sound.play()
	tutorial_sequence_index += 1
	show_tutorial_step()

func end_main_tutorial() -> void:
	tutorial_in_progress = false
	tutorial_overlay.hide()
	_clear_highlights()
