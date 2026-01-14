extends Control

# --- CONFIGURATION ---
@export var bar_scene: PackedScene 
@export var array_size: int = 7
@export var animation_speed: float = 0.5 

# --- NODES ---
@onready var node_container = $NodeContainer
@onready var message_label = $MessageLabel
@onready var generate_btn = $ButtonContainer/GenerateButton
@onready var sort_btn = $ButtonContainer/SortButton
@onready var reset_btn = $ButtonContainer/ResetButton
@onready var manual_check = $ButtonContainer/ManualCheckBox
@onready var step_btn = $ButtonContainer/StepButton
@onready var timeline_btn = $ButtonContainer/TimelineButton

# Timeline Nodes
@onready var timeline_popup = $TimelinePopup
@onready var timeline_text = $TimelinePopup/VBoxContainer/TimelineText
@onready var close_timeline_btn = $TimelinePopup/VBoxContainer/CloseTimelineButton

# --- DATA ---
var values: Array[int] = []
var bar_instances: Array[Control] = []
var history_log: String = "" 

# --- STATE ---
var is_manual: bool = false
signal step_triggered      
signal correct_swap_done   

var required_swap_target: Array = [] 

# --- COLORS ---
const COLOR_DEFAULT = Color("#ffffff") 
const COLOR_MINIMUM = Color("#ff0000") # Red (The smallest one found so far)
const COLOR_CURRENT = Color("#00ff00") # Green (The slot we are trying to fill)
const COLOR_SCAN    = Color("#ffff00") # Yellow (Scanning/Searching)
const COLOR_SORTED  = Color("#3498db") # Blue

func _ready():
	generate_btn.pressed.connect(_on_generate_pressed)
	sort_btn.pressed.connect(_on_sort_pressed)
	reset_btn.pressed.connect(_on_reset_pressed)
	manual_check.toggled.connect(_on_manual_toggled)
	step_btn.pressed.connect(_on_step_pressed)
	
	if timeline_btn: timeline_btn.pressed.connect(_on_timeline_btn_pressed)
	if close_timeline_btn: close_timeline_btn.pressed.connect(_on_close_timeline_pressed)
	
	if timeline_popup: timeline_popup.visible = false
	step_btn.visible = false 
	
	if bar_scene == null:
		message_label.text = "Error: Please assign Bar.tscn!"
		return
		
	clear_bars()
	log_event("Welcome to Selection Sort! Click 'Generate'.")
	sort_btn.disabled = true
	reset_btn.disabled = true
	manual_check.disabled = true 

# --- DRAG & DROP HANDLER ---

func _on_bar_dropped(source_idx: int, target_idx: int):
	if required_swap_target.is_empty(): return 
		
	var is_correct = false
	# Allow drag in either direction (Min -> Slot OR Slot -> Min)
	if source_idx == required_swap_target[0] and target_idx == required_swap_target[1]:
		is_correct = true
	elif source_idx == required_swap_target[1] and target_idx == required_swap_target[0]:
		is_correct = true
		
	if is_correct:
		swap(source_idx, target_idx)
		log_event("Correct! Min value moved to sorted position.")
		
		# Reset colors
		update_bar_color(source_idx, COLOR_DEFAULT)
		update_bar_color(target_idx, COLOR_DEFAULT)
		
		required_swap_target = []
		correct_swap_done.emit()
	else:
		log_event("Wrong! Drag the RED block (Min) to the GREEN block (Current).")

# --- TIMELINE & LOGGING ---

func log_event(text: String):
	message_label.text = text
	history_log += text + "\n"
	if timeline_text: timeline_text.text = history_log

func _on_timeline_btn_pressed(): if timeline_popup: timeline_popup.visible = true
func _on_close_timeline_pressed(): if timeline_popup: timeline_popup.visible = false

# --- BUTTON SIGNALS ---

func _on_generate_pressed():
	create_bars()
	history_log = "" 
	log_event("New array generated.")
	sort_btn.disabled = false
	reset_btn.disabled = false
	manual_check.disabled = false

func _on_reset_pressed():
	create_bars()
	history_log = ""
	log_event("Reset.")

func _on_manual_toggled(toggled_on: bool):
	is_manual = toggled_on
	step_btn.visible = toggled_on
	if toggled_on:
		log_event("Manual Mode ON. You will perform the swaps!")
	else:
		log_event("Auto Mode. Resuming.")
		step_triggered.emit()

func _on_step_pressed(): step_triggered.emit()

func _on_sort_pressed():
	if values.is_empty(): return
	generate_btn.disabled = true
	sort_btn.disabled = true
	reset_btn.disabled = true
	manual_check.disabled = true 
	
	log_event("Starting Selection Sort...")
	await get_tree().create_timer(0.5).timeout
	await selection_sort_algorithm()
	
	log_event("Sort Complete!")
	highlight_all(COLOR_SORTED)
	generate_btn.disabled = false
	reset_btn.disabled = false
	manual_check.disabled = false

# --- WAIT LOGIC ---

func wait_step():
	if is_manual: await step_triggered
	else: await get_tree().create_timer(animation_speed).timeout

func wait_for_user_interaction(idx1: int, idx2: int):
	if is_manual:
		required_swap_target = [idx1, idx2]
		log_event("ACTION: Drag Red Block (" + str(values[idx2]) + ") to Green Block!")
		await correct_swap_done
	else:
		swap(idx1, idx2)
		await get_tree().create_timer(animation_speed).timeout

# --- SELECTION SORT ALGORITHM ---

func selection_sort_algorithm():
	var n = values.size()
	
	for i in range(n):
		# 1. Assume the current index 'i' is the minimum
		var min_idx = i
		
		log_event("Looking for smallest number starting from index " + str(i))
		update_bar_color(i, COLOR_CURRENT) # Green (Target Slot)
		await wait_step()
		
		# 2. Scan the rest of the array to find the REAL minimum
		for j in range(i + 1, n):
			update_bar_color(j, COLOR_SCAN) # Yellow (Scanning)
			
			# log_event("Checking " + str(values[j]) + "...")
			await get_tree().create_timer(animation_speed / 2).timeout # Fast scan
			
			if values[j] < values[min_idx]:
				# Found a new minimum!
				# Reset old min color if it wasn't the starting one
				if min_idx != i: update_bar_color(min_idx, COLOR_DEFAULT)
				
				min_idx = j
				update_bar_color(min_idx, COLOR_MINIMUM) # Red (New Min)
				log_event("Found new minimum: " + str(values[min_idx]))
				await wait_step()
			else:
				update_bar_color(j, COLOR_DEFAULT)
		
		# 3. Swap if needed
		if min_idx != i:
			log_event("Smallest is " + str(values[min_idx]) + ". Move to front.")
			if is_manual:
				await wait_for_user_interaction(i, min_idx)
			else:
				swap(i, min_idx)
				await wait_step()
			
			# Visual cleanup
			update_bar_color(min_idx, COLOR_DEFAULT)
		else:
			log_event("It's already in the correct spot.")
			
		# Mark this spot as officially sorted
		update_bar_color(i, COLOR_SORTED)

# --- VISUAL HELPERS ---

func clear_bars():
	for child in node_container.get_children(): child.queue_free()
	values.clear()
	bar_instances.clear()

func create_bars():
	clear_bars()
	for i in range(array_size):
		var val = randi_range(10, 99)
		values.append(val)
		var bar = bar_scene.instantiate()
		node_container.add_child(bar)
		
		bar.setup(val, 100.0) 
		bar.set_index(i) 
		bar.bar_dropped_on_me.connect(_on_bar_dropped)
		bar_instances.append(bar)

func update_bar_color(index: int, color: Color):
	if index >= 0 and index < bar_instances.size():
		bar_instances[index].set_color(color)

func swap(idx1: int, idx2: int):
	var temp_val = values[idx1]
	values[idx1] = values[idx2]
	values[idx2] = temp_val
	bar_instances[idx1].setup(values[idx1], 100.0)
	bar_instances[idx2].setup(values[idx2], 100.0)

func highlight_all(color: Color):
	for bar in bar_instances: bar.set_color(color)
