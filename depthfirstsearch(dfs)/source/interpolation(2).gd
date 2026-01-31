extends Control

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
@onready var probe_container: HBoxContainer = $probeContainer
@onready var disabled_popup: PopupPanel = $PopupPanel
# Search variables
var array: Array = []
var target_value: int = 0
var low: int = 0
var high: int = 0
var probe: int = 0
var is_sorted: bool = false
var search_active: bool = false
var array_blocks: Array = []
var value_labels: Array = []
var indicator_blocks: Array = []

# Colors
const BLOCK_COLOR = Color.WHITE
const LOW_COLOR = Color.BLUE
const HIGH_COLOR = Color.RED
const PROBE_COLOR = Color.YELLOW
const FOUND_COLOR = Color.GREEN

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
	for child in probe_container.get_children():
		child.queue_free()
	
	array_blocks.clear()
	value_labels.clear()
	indicator_blocks.clear()
	
	# Create array blocks
	for i in range(array.size()):
		# Create container for block and label
		var block_container = VBoxContainer.new()
		block_container.alignment = BoxContainer.ALIGNMENT_CENTER
		
		# Create the colored block
		var block = ColorRect.new()
		block.custom_minimum_size = Vector2(60, 60)
		block.color = BLOCK_COLOR
		
		# Create value label
		var label = Label.new()
		label.text = str(array[i])
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 16)
		
		block_container.add_child(block)
		block_container.add_child(label)
		array_container.add_child(block_container)
		
		array_blocks.append(block)
		value_labels.append(label)
	
	# Create indicator blocks
	for i in range(array.size()):
		var indicator = ColorRect.new()
		indicator.custom_minimum_size = Vector2(60, 20)
		indicator.color = Color.TRANSPARENT
		probe_container.add_child(indicator)
		indicator_blocks.append(indicator)

func sort_array():
	if array.size() > 0:
		array.sort()
		is_sorted = true
		# Update the labels with sorted values
		for i in range(array.size()):
			value_labels[i].text = str(array[i])
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
		var numerator = float(target_value - array[low]) * (high - low)
		var denominator = array[high] - array[low]
		
		if denominator != 0:
			probe = low + int(numerator / denominator)
		else:
			probe = low
	else:
		probe = -1
		search_active = false
	
	# Ensure probe is within bounds
	if probe < low:
		probe = low
	if probe > high:
		probe = high
	
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
			array_blocks[probe].color = FOUND_COLOR
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
	# Reset all blocks to white
	for i in range(array_blocks.size()):
		array_blocks[i].color = BLOCK_COLOR
		indicator_blocks[i].color = Color.TRANSPARENT
	
	# Highlight low, high, and probe if search is active
	if search_active:
		if low < array_blocks.size():
			array_blocks[low].color = LOW_COLOR
			indicator_blocks[low].color = LOW_COLOR
		
		if high < array_blocks.size():
			array_blocks[high].color = HIGH_COLOR
			indicator_blocks[high].color = HIGH_COLOR
		
		if probe >= 0 and probe < array_blocks.size():
			array_blocks[probe].color = PROBE_COLOR
			indicator_blocks[probe].color = PROBE_COLOR

func update_ui():
	# Update button states
	search_button.disabled = not is_sorted
	next_step_button.disabled = not search_active
	
	# Show current state in console
	print("UI Update - Sorted: ", is_sorted, " Search Active: ", search_active)

func _on_sort_button_pressed():
	sort_array()

func _on_search_button_pressed():
	search_input.visible = true
	search_input.grab_focus()
	search_input.text = ""
	print("Search input shown - enter a number and press Enter")
	if not is_sorted:
		disabled_popup.popup()
	else:
		disabled_popup.hide()


func _on_next_button_pressed():
	if search_active:
		print("Next step pressed")
		update_search_state()
		update_ui()

func _on_generate_button_pressed():
	generate_new_array()
	print("New array generated")

func _on_search_input_text_submitted(text):
	print("Search input submitted: ", text)
	if text.is_valid_int():
		var value = int(text)
		start_search(value)
		search_input.visible = false
		search_input.text = ""
	else:
		print("Please enter a valid number")
