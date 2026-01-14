extends Control

# --- CONFIGURATION ---
# IMPORTANT: Drag 'bar.tscn' into this slot in the Inspector!
@export var bar_scene: PackedScene 
@export var array_size: int = 7
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

# Logic variables to track what move the user MUST make next
var required_source_idx: int = -1
var required_target_idx: int = -1

# --- COLORS ---
const COLOR_DEFAULT = Color("#ffffff") 
const COLOR_LEFT    = Color("#ff0000") # Red (The Left side candidate)
const COLOR_RIGHT   = Color("#00ff00") # Green (The Right side candidate)
const COLOR_DIVIDE  = Color("#ffff00") # Yellow (Showing the 'Divide' range)
const COLOR_MERGE   = Color("#ffa500") # Orange (Showing the range being Merged)
const COLOR_SORTED  = Color("#3498db") # Blue

func _ready():
	# 1. Connect Signals
	generate_btn.pressed.connect(_on_generate_pressed)
	sort_btn.pressed.connect(_on_sort_pressed)
	reset_btn.pressed.connect(_on_reset_pressed)
	manual_check.toggled.connect(_on_manual_toggled)
	step_btn.pressed.connect(_on_step_pressed)
	
	# Safety checks for Timeline buttons
	if timeline_btn: timeline_btn.pressed.connect(_on_timeline_btn_pressed)
	if close_timeline_btn: close_timeline_btn.pressed.connect(_on_close_timeline_pressed)
	
	# 2. Initial UI Setup
	if timeline_popup: timeline_popup.visible = false
	step_btn.visible = false 
	
	if bar_scene == null:
		message_label.text = "Error: Please assign Bar.tscn in Inspector!"
		return
		
	clear_bars()
	log_event("Welcome to Merge Sort! Click 'Generate' to start.")
	
	# Lock sort until data is generated
	sort_btn.disabled = true
	reset_btn.disabled = true
	manual_check.disabled = true 

# --- DRAG & DROP HANDLER ---

func _on_bar_dropped(source_idx: int, target_idx: int):
	# If we are not waiting for a move, ignore drops
	if required_source_idx == -1: return 
		
	# Validation: Did user drag the Right Candidate (Green) to the Left Candidate (Red)?
	if source_idx == required_source_idx and target_idx == required_target_idx:
		log_event("Correct! Moving " + str(values[source_idx]) + " to position " + str(target_idx))
		
		# Reset requirements
		required_source_idx = -1
		required_target_idx = -1
		
		# Unpause the sort loop
		correct_swap_done.emit()
	else:
		log_event("Wrong! Drag the Green Block (" + str(values[required_source_idx]) + ") to the Red Block's spot!")

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
		log_event("Manual Mode ON.")
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
	
	log_event("Starting Merge Sort...")
	await get_tree().create_timer(0.5).timeout
	
	await merge_sort_recursive(0, values.size() - 1)
	
	log_event("Merge Sort Complete!")
	highlight_all(COLOR_SORTED)
	generate_btn.disabled = false
	reset_btn.disabled = false
	manual_check.disabled = false

# --- WAIT LOGIC ---

func wait_step():
	if is_manual: await step_triggered
	else: await get_tree().create_timer(animation_speed).timeout

func wait_for_shift_interaction(from_idx: int, to_idx: int):
	# Waits for the user to physically drag the block
	if is_manual:
		required_source_idx = from_idx
		required_target_idx = to_idx
		log_event("ACTION: Drag Green Block " + str(values[from_idx]) + " to Red Block " + str(values[to_idx]) + "!")
		await correct_swap_done
	else:
		await get_tree().create_timer(animation_speed).timeout

# --- MERGE SORT ALGORITHM (In-Place) ---

func merge_sort_recursive(left: int, right: int):
	if left < right:
		# 1. DIVIDE VISUALIZATION
		log_event("DIVIDE: Splitting range [" + str(left) + "-" + str(right) + "]")
		highlight_range(left, right, COLOR_DIVIDE) # Yellow flash
		await wait_step()
		
		var mid = left + (right - left) / 2
		
		# 2. RECURSIVE CALLS
		await merge_sort_recursive(left, mid)
		await merge_sort_recursive(mid + 1, right)
		
		# 3. MERGE VISUALIZATION
		log_event("CONQUER: Merging ranges [" + str(left) + "-" + str(mid) + "] and [" + str(mid+1) + "-" + str(right) + "]")
		highlight_range(left, right, COLOR_MERGE) # Orange highlight
		await wait_step()
		
		# 4. PERFORM MERGE
		await merge(left, mid, right)
		
		# Optional: Mark this chunk as temporarily sorted (Blue)
		highlight_range(left, right, COLOR_SORTED)

func merge(start: int, mid: int, end: int):
	var start2 = mid + 1
	
	# Optimization: If the largest left is <= smallest right, it's already sorted
	if values[mid] <= values[start2]:
		return 

	while start <= mid and start2 <= end:
		# Visual: Highlight candidates
		update_bar_color(start, COLOR_LEFT)   # Red
		update_bar_color(start2, COLOR_RIGHT) # Green
		log_event("Comparing: Left (" + str(values[start]) + ") vs Right (" + str(values[start2]) + ")")
		
		await wait_step()
		
		if values[start] <= values[start2]:
			# Correct spot. Move pointer.
			log_event("Left is smaller/equal. It stays.")
			update_bar_color(start, COLOR_DEFAULT) 
			start += 1
		else:
			# Right is smaller. Need to move it!
			var value = values[start2]
			var index = start2
			
			log_event("Right is smaller! Moving " + str(value) + " to index " + str(start))
			
			# --- USER INTERACTION ---
			await wait_for_shift_interaction(start2, start)
			
			# Shift Data Logic (Insertion)
			while index != start:
				values[index] = values[index - 1]
				index -= 1
			values[start] = value
			
			# Refresh Visuals (since indices shifted)
			refresh_all_bars()
			
			# Update Pointers
			start += 1
			mid += 1
			start2 += 1
			
			# Brief pause to let user see the result
			if not is_manual: await get_tree().create_timer(0.1).timeout

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
		# Connect drop signal for drag-and-drop
		bar.bar_dropped_on_me.connect(_on_bar_dropped)
		bar_instances.append(bar)

func refresh_all_bars():
	# Re-apply values to bars after a shift operation
	for i in range(values.size()):
		bar_instances[i].setup(values[i], 100.0)
		# We usually reset color to default, unless we want to keep highlights
		bar_instances[i].set_color(COLOR_DEFAULT)

func update_bar_color(index: int, color: Color):
	if index >= 0 and index < bar_instances.size():
		bar_instances[index].set_color(color)

func highlight_range(start_idx: int, end_idx: int, color: Color):
	for i in range(start_idx, end_idx + 1):
		# Don't overwrite if it's already sorted blue (optional style choice)
		update_bar_color(i, color)

func highlight_all(color: Color):
	for bar in bar_instances: bar.set_color(color)
