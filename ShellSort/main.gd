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
signal step_triggered      # For button clicks
signal correct_swap_done   # New: For drag & drop completion

# We store the required swap indices here to validate the user's move
var required_swap_target: Array = [] 

# --- COLORS ---
const COLOR_DEFAULT = Color("#ffffff") 
const COLOR_COMPARE = Color("#ff0000") 
const COLOR_ACTIVE = Color("#00ff00") 
const COLOR_SORTED = Color("#3498db")

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
	log_event("Welcome! Turn on Manual Mode to Drag & Drop.")
	sort_btn.disabled = true
	reset_btn.disabled = true
	manual_check.disabled = true 

# --- DRAG & DROP HANDLER ---

func _on_bar_dropped(source_idx: int, target_idx: int):
	# This function runs when you drop one block on another
	
	if required_swap_target.is_empty():
		return # Not waiting for a swap right now
		
	# Check if the user dragged the correct blocks
	var is_correct = false
	if source_idx == required_swap_target[0] and target_idx == required_swap_target[1]:
		is_correct = true
	elif source_idx == required_swap_target[1] and target_idx == required_swap_target[0]:
		is_correct = true
		
	if is_correct:
		# Perform the swap logic
		swap(source_idx, target_idx)
		log_event("Great job! Swap successful.")
		
		# Reset colors
		update_bar_color(source_idx, COLOR_DEFAULT)
		update_bar_color(target_idx, COLOR_DEFAULT)
		
		# Clear requirement and notify the loop to continue
		required_swap_target = []
		correct_swap_done.emit()
	else:
		log_event("Wrong move! You must swap the Green and Red blocks.")

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
		log_event("Interactive Mode ON. You will perform the swaps!")
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
	
	log_event("Starting Shell Sort...")
	await get_tree().create_timer(0.5).timeout
	await shell_sort_algorithm()
	
	log_event("Sort Complete!")
	highlight_all(COLOR_SORTED)
	generate_btn.disabled = false
	reset_btn.disabled = false
	manual_check.disabled = false

# --- WAIT LOGIC ---

func wait_step():
	if is_manual:
		# Wait for "Next Step" button
		await step_triggered
	else:
		await get_tree().create_timer(animation_speed).timeout

func wait_for_user_interaction(idx1: int, idx2: int):
	# This replaces the standard wait IF a swap is needed in manual mode
	if is_manual:
		required_swap_target = [idx1, idx2]
		log_event("ACTION REQUIRED: Drag Green block to Red block!")
		# Wait until the Drag & Drop handler emits this signal
		await correct_swap_done
	else:
		# In auto mode, just do it automatically
		swap(idx1, idx2)
		await get_tree().create_timer(animation_speed).timeout

# --- SHELL SORT ALGORITHM ---

func shell_sort_algorithm():
	var n = values.size()
	var gap = n / 2
	
	while gap > 0:
		log_event("--- PHASE: Gap " + str(gap) + " ---")
		await wait_step()
		
		for i in range(gap, n):
			var temp = values[i]
			var j = i
			
			update_bar_color(j, COLOR_ACTIVE)
			
			while j >= gap:
				update_bar_color(j - gap, COLOR_COMPARE)
				
				log_event("Checking: " + str(values[j]) + " vs " + str(values[j-gap]))
				await wait_step()
				
				if values[j - gap] > values[j]:
					# --- INTERACTION POINT ---
					# Instead of just swapping, we call our new wait function
					log_event("Swap Needed! " + str(values[j]) + " is smaller.")
					
					if is_manual:
						# Wait for USER to drag
						await wait_for_user_interaction(j, j - gap)
					else:
						# Auto swap
						swap(j, j - gap)
						await get_tree().create_timer(animation_speed).timeout
					# -------------------------
					
					# Visual Cleanup after swap
					update_bar_color(j, COLOR_DEFAULT)
					j -= gap 
					update_bar_color(j, COLOR_ACTIVE)
				else:
					log_event("No swap needed.")
					update_bar_color(j - gap, COLOR_DEFAULT)
					break
			
			update_bar_color(j, COLOR_DEFAULT)
		gap /= 2

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
		
		# Setup the bar
		bar.setup(val, 100.0) 
		bar.set_index(i) # Important: Tell the bar its own index!
		
		# Connect the drop signal from the bar to the Main script
		bar.bar_dropped_on_me.connect(_on_bar_dropped)
		
		bar_instances.append(bar)

func update_bar_color(index: int, color: Color):
	if index >= 0 and index < bar_instances.size():
		bar_instances[index].set_color(color)

func swap(idx1: int, idx2: int):
	# Swap Data
	var temp_val = values[idx1]
	values[idx1] = values[idx2]
	values[idx2] = temp_val
	
	# Swap Visuals (Update text)
	bar_instances[idx1].setup(values[idx1], 100.0)
	bar_instances[idx2].setup(values[idx2], 100.0)

func highlight_all(color: Color):
	for bar in bar_instances:
		bar.set_color(color)
