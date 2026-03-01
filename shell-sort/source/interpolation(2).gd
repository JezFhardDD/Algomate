extends Control

# --- ADD YOUR SCENE PATH HERE ---
const BLOCK_SCENE = preload("res://ArrayBlock.tscn") 

@onready var sort_button: Button = $ButtonsContainer/SortButton
@onready var search_button: Button = $ButtonsContainer/SearchButton
@onready var next_step_button: Button = $ButtonsContainer/NextButton
@onready var generate_button: Button = $ButtonsContainer/GenerateButton
@onready var search_input: LineEdit = $SearchInput

@onready var low_label: Label = $VBoxContainer/LowLabel
@onready var high_label: Label = $VBoxContainer/HighLabel
@onready var probe_label: Label = $VBoxContainer/ProbeLabel
@onready var array_value_label: Label = $VBoxContainer/ArrayValueLabel
@onready var comparison_label: Label = $VBoxContainer/ComparissonLabel
@onready var action_label: Label = $VBoxContainer/ActionLabel

@onready var array_container: HBoxContainer = $ArrayContainer
@onready var disabled_popup: PopupPanel = $PopupPanel

# Search variables
var array: Array = []
var target_value: int = 0
var low: int = 0
var high: int = 0
var probe: int = 0
var is_sorted: bool = false
var search_active: bool = false

# Array to hold the instantiated block scenes
var array_blocks: Array = []

func _ready():
	generate_new_array()
	update_ui()
	search_input.visible = false
	disabled_popup.hide()

func generate_new_array():
	array.clear()
	var size = 10
	for i in range(size):
		array.append(randi() % 100 + 1)
	
	is_sorted = false
	search_active = false
	low = 0
	high = array.size() - 1
	probe = 0
	
	create_array_blocks()
	update_ui()

func create_array_blocks():
	# Clear existing blocks properly
	for child in array_container.get_children():
		child.queue_free()
	
	array_blocks.clear()
	
	# Instantiate custom block scenes
	for i in range(array.size()):
		var block_instance = BLOCK_SCENE.instantiate()
		block_instance.value = array[i]
		
		array_container.add_child(block_instance)
		array_blocks.append(block_instance)

func sort_array():
	if array.size() > 0:
		array.sort()
		is_sorted = true
		
		# Sync the visual blocks with the sorted array data
		for i in range(array.size()):
			array_blocks[i].value = array[i]
			
		update_visual_indicators()
		update_ui()
		print("Array sorted! You can now search.")

func start_search(value: int):
	if not is_sorted:
		print("Array must be sorted first! Click 'Sort Array'.")
		return
	
	if value < 1 or value > 100:
		print("Please enter a number between 1-100")
		return
	
	target_value = value
	low = 0
	high = array.size() - 1
	search_active = true
	
	print("Searching for: ", target_value)
	update_search_state()
	update_ui()

func update_search_state():
	if not search_active:
		return
	
	# Calculate probe position using interpolation formula
	if low <= high and target_value >= array[low] and target_value <= array[high]:
		var range_diff = array[high] - array[low]
		if range_diff != 0:
			var numerator = float(target_value - array[low]) * (high - low)
			probe = low + int(numerator / range_diff)
		else:
			probe = low
	else:
		probe = -1
		search_active = false
	
	# Ensure probe is within bounds
	if probe < low: probe = low
	if probe > high: probe = high
	
	# Update visual indicators
	update_visual_indicators()
	
	# Update labels and perform comparison
	if probe >= 0 and probe < array.size():
		probe_label.text = "Probe: %d (Index: %d)" % [array[probe], probe]
		array_value_label.text = "arr[probe] = %d" % array[probe]
		low_label.text = "Low: %d (Index: %d)" % [array[low], low]
		high_label.text = "High: %d (Index: %d)" % [array[high], high]
		
		if array[probe] == target_value:
			comparison_label.text = "Comparison: Found!"
			action_label.text = "Action: Terminate"
			array_blocks[probe].set_status("found")
			search_active = false
			print("Found target value at index ", probe)
		elif array[probe] < target_value:
			comparison_label.text = "Comparison: arr[probe] < x"
			action_label.text = "Action: Move Low Up"
			low = probe + 1
			print("Moving low to ", low)
		else:
			comparison_label.text = "Comparison: arr[probe] > x"
			action_label.text = "Action: Move High Down"
			high = probe - 1
			print("Moving high to ", high)
	else:
		comparison_label.text = "Comparison: Not Found"
		action_label.text = "Action: Terminate"
		search_active = false
		print("Target value not found")

func update_visual_indicators():
	# Reset all blocks and apply states
	for i in range(array_blocks.size()):
		var block = array_blocks[i]
		
		if search_active:
			# Dim blocks outside the current searchable bounds
			if i < low or i > high:
				block.set_status("inactive")
			else:
				block.set_status("default")
				
			# Highlight pointers
			if i == low: block.set_status("low")
			if i == high: block.set_status("high")
			if i == probe: block.set_status("probe")
		else:
			# If search is off, make sure everything looks normal (unless found)
			if block.modulate != Color.GREEN:
				block.set_status("default")

func update_ui():
	search_button.disabled = not is_sorted
	next_step_button.disabled = not search_active

func _on_sort_button_pressed(): sort_array()

func _on_search_button_pressed():
	search_input.visible = true
	search_input.grab_focus()
	search_input.text = ""
	if not is_sorted: disabled_popup.popup()
	else: disabled_popup.hide()

func _on_next_button_pressed():
	if search_active:
		update_search_state()
		update_ui()

func _on_generate_button_pressed(): generate_new_array()

func _on_search_input_text_submitted(text):
	if text.is_valid_int():
		start_search(int(text))
		search_input.visible = false
		search_input.text = ""
