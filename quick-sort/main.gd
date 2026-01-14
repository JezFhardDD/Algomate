extends Control

# --- CONFIGURATION ---
@export var bar_scene: PackedScene 
@export var array_size: int = 15
@export var animation_speed: float = 0.5 

# --- NODES ---
@onready var node_container = $NodeContainer
@onready var message_label = $MessageLabel

# Main Buttons
@onready var generate_btn = $ButtonContainer/GenerateButton
@onready var sort_btn = $ButtonContainer/SortButton
@onready var reset_btn = $ButtonContainer/ResetButton
@onready var manual_check = $ButtonContainer/ManualCheckBox
@onready var step_btn = $ButtonContainer/StepButton
@onready var timeline_btn = $ButtonContainer/TimelineButton

# Timeline Nodes (Matches your screenshot hierarchy)
@onready var timeline_popup = $TimelinePopup
@onready var timeline_text = $TimelinePopup/VBoxContainer/TimelineText
@onready var close_timeline_btn = $TimelinePopup/VBoxContainer/CloseTimelineButton

# --- DATA ---
var values: Array[int] = []
var bar_instances: Array[Control] = []
var history_log: String = "" # Stores the full text history

# --- STATE ---
var is_manual: bool = false
signal step_triggered

# --- COLORS ---
const COLOR_DEFAULT = Color("#ffffff") 
const COLOR_PIVOT = Color("#ff0000")
const COLOR_ACTIVE = Color("#00ff00")
const COLOR_SORTED = Color("#3498db")

func _ready():
	# 1. Connect Main Signals
	generate_btn.pressed.connect(_on_generate_pressed)
	sort_btn.pressed.connect(_on_sort_pressed)
	reset_btn.pressed.connect(_on_reset_pressed)
	manual_check.toggled.connect(_on_manual_toggled)
	step_btn.pressed.connect(_on_step_pressed)
	
	# 2. Connect Timeline Signals
	timeline_btn.pressed.connect(_on_timeline_btn_pressed)
	close_timeline_btn.pressed.connect(_on_close_timeline_pressed)
	
	# 3. Initial Setup
	timeline_popup.visible = false # Hide popup at start
	step_btn.visible = false
	
	if bar_scene == null:
		message_label.text = "Error: Assign Bar.tscn!"
		return
		
	clear_bars()
	log_event("Welcome! Click 'Generate' to start.")
	
	disable_ui(true)
	generate_btn.disabled = false # Only generate is allowed initially

# --- TIMELINE FUNCTIONS ---

func log_event(text: String):
	# 1. Update the lecture label at the bottom
	message_label.text = text
	
	# 2. Add to the timeline history
	# We add a newline character "\n" so every event is on a new line
	history_log += text + "\n"
	
	# 3. Update the text box inside the popup
	if timeline_text:
		timeline_text.text = history_log
		# Automatically scroll to bottom (works best if TimelineText is RichTextLabel)
		# timeline_text.scroll_to_line(timeline_text.get_line_count() - 1)

func _on_timeline_btn_pressed():
	timeline_popup.visible = true

func _on_close_timeline_pressed():
	timeline_popup.visible = false

# --- BUTTON SIGNALS ---

func _on_generate_pressed():
	create_bars()
	# Clear history when generating new array
	history_log = "" 
	log_event("Generated new random array (" + str(array_size) + " items).")
	
	sort_btn.disabled = false
	reset_btn.disabled = false

func _on_reset_pressed():
	create_bars()
	history_log = ""
	log_event("Simulation Reset.")

func _on_manual_toggled(toggled_on: bool):
	is_manual = toggled_on
	step_btn.visible = toggled_on
	if toggled_on:
		log_event("Manual Mode Enabled. Waiting for 'Next Step'.")
	else:
		log_event("Manual Mode Disabled. Resuming auto-sort.")
		step_triggered.emit() # Resume if we were stuck waiting

func _on_step_pressed():
	step_triggered.emit()

func _on_sort_pressed():
	if values.is_empty(): return
	
	disable_ui(true)
	log_event("Starting Quick Sort Algorithm...")
	await get_tree().create_timer(0.5).timeout
	
	await quick_sort(0, values.size() - 1)
	
	log_event("Sort Complete! Array is sorted.")
	highlight_all(COLOR_SORTED)
	disable_ui(false)

# --- WAIT LOGIC ---

func wait_step():
	if is_manual:
		await step_triggered
	else:
		await get_tree().create_timer(animation_speed).timeout

# --- QUICK SORT ALGORITHM ---

func quick_sort(low: int, high: int):
	if low < high:
		var pi = await partition(low, high)
		await quick_sort(low, pi - 1)
		await quick_sort(pi + 1, high)

func partition(low: int, high: int) -> int:
	var pivot_value = values[high]
	
	log_event("Step 1: Partitioning range [" + str(low) + "-" + str(high) + "]. Pivot is " + str(pivot_value))
	update_bar_color(high, COLOR_PIVOT)
	await wait_step()
	
	var i = low - 1
	
	for j in range(low, high):
		update_bar_color(j, COLOR_ACTIVE)
		
		log_event("Comparing: Is " + str(values[j]) + " < " + str(pivot_value) + "?")
		await wait_step()
		
		if values[j] < pivot_value:
			i += 1
			log_event("Yes: " + str(values[j]) + " is smaller. Swapping it to left.")
			swap(i, j)
			await wait_step()
		else:
			# Optional: Log 'No' cases too, or skip to reduce spam
			# log_event("No: " + str(values[j]) + " is larger.")
			pass
		
		if j != high:
			update_bar_color(j, COLOR_DEFAULT)
			
	log_event("Partition complete. Placing Pivot " + str(pivot_value) + " at correct index " + str(i+1))
	swap(i + 1, high)
	update_bar_color(high, COLOR_DEFAULT)
	await wait_step()
	
	return i + 1

# --- VISUAL HELPERS ---

func clear_bars():
	for child in node_container.get_children():
		child.queue_free()
	values.clear()
	bar_instances.clear()

func create_bars():
	clear_bars()
	for i in range(array_size):
		var val = randi_range(20, 300)
		values.append(val)
		var bar = bar_scene.instantiate()
		node_container.add_child(bar)
		bar.setup(val, 400.0)
		bar_instances.append(bar)

func update_bar_color(index: int, color: Color):
	if index >= 0 and index < bar_instances.size():
		bar_instances[index].set_color(color)

func swap(idx1: int, idx2: int):
	var temp_val = values[idx1]
	values[idx1] = values[idx2]
	values[idx2] = temp_val
	bar_instances[idx1].setup(values[idx1], 400.0)
	bar_instances[idx2].setup(values[idx2], 400.0)

func highlight_all(color: Color):
	for bar in bar_instances:
		bar.set_color(color)

func disable_ui(state: bool):
	generate_btn.disabled = state
	sort_btn.disabled = state
	reset_btn.disabled = state
	manual_check.disabled = state
