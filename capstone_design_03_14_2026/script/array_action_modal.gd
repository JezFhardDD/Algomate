# array_action_modal.gd
extends Panel

enum ActionType { ACCESS, INSERT_AT_END, INSERT_AT_INDEX, DELETE }

var current_action: ActionType
var confirm_callback: Callable

# Fix the paths to match your scene structure
@onready var modal_title: Label = $ModalContent/Label  # Changed from ModalTitle to Label
@onready var single_input_row: HBoxContainer = $ModalContent/InputContainer/SingleInputRow
@onready var double_input_container: VBoxContainer = $ModalContent/InputContainer/DoubleInputContainer
@onready var confirm_btn: Button = $ModalContent/ActionButtons/ConfirmButton
@onready var cancel_btn: Button = $ModalContent/ActionButtons/CancelButton

# Fix spin box paths - they have specific names now
@onready var index_spin: SpinBox = $ModalContent/InputContainer/SingleInputRow/IndexSpinBox
@onready var value_spin: SpinBox = $ModalContent/InputContainer/DoubleInputContainer/HBoxContainer/ValueSpinBox
@onready var insert_index_spin: SpinBox = $ModalContent/InputContainer/DoubleInputContainer/HBoxContainer2/InsertIndexSpinBox

func _ready():
	if cancel_btn:
		cancel_btn.pressed.connect(_on_cancel_pressed)
	if confirm_btn:
		confirm_btn.pressed.connect(_on_confirm_pressed)
	
	# Initialize spin boxes with default values
	_setup_spin_boxes()
	
	hide()

func _setup_spin_boxes():
	if index_spin:
		index_spin.min_value = 0
		index_spin.max_value = 0
		index_spin.step = 1
		index_spin.rounded = true
		index_spin.value = 0
	else:
		print("Warning: index_spin not found in modal")
	
	if value_spin:
		value_spin.min_value = 1
		value_spin.max_value = 99
		value_spin.step = 1
		value_spin.rounded = true
		value_spin.value = 1
	else:
		print("Warning: value_spin not found in modal")
	
	if insert_index_spin:
		insert_index_spin.min_value = 0
		insert_index_spin.max_value = 0
		insert_index_spin.step = 1
		insert_index_spin.rounded = true
		insert_index_spin.value = 0
	else:
		print("Warning: insert_index_spin not found in modal")

func show_for_action(action: ActionType, max_index: int, callback: Callable):
	current_action = action
	confirm_callback = callback
	
	# Ensure spin boxes are set up
	_setup_spin_boxes()
	
	match action:
		ActionType.ACCESS:
			if modal_title:
				modal_title.text = "ACCESS ELEMENT"
			single_input_row.show()
			double_input_container.hide()
			if index_spin:
				index_spin.max_value = max_index
				index_spin.value = 0
			if confirm_btn:
				confirm_btn.text = "ACCESS"
			
		ActionType.INSERT_AT_END:
			if modal_title:
				modal_title.text = "INSERT AT END"
			single_input_row.hide()
			double_input_container.show()
			
			# Show value row, hide index row
			if double_input_container.get_child_count() >= 2:
				double_input_container.get_child(0).show()  # Value row (HBoxContainer)
				double_input_container.get_child(1).hide()  # Index row (HBoxContainer2)
			
			if value_spin:
				value_spin.max_value = 99
				value_spin.min_value = 1
				value_spin.value = 1
			if confirm_btn:
				confirm_btn.text = "INSERT"
			
		ActionType.INSERT_AT_INDEX:
			if modal_title:
				modal_title.text = "INSERT AT INDEX"
			single_input_row.hide()
			double_input_container.show()
			
			# Show both rows
			if double_input_container.get_child_count() >= 2:
				double_input_container.get_child(0).show()  # Value row
				double_input_container.get_child(1).show()  # Index row
			
			if value_spin:
				value_spin.max_value = 99
				value_spin.min_value = 1
				value_spin.value = 1
			if insert_index_spin:
				insert_index_spin.max_value = max_index
				insert_index_spin.value = 0
			if confirm_btn:
				confirm_btn.text = "INSERT"
			
		ActionType.DELETE:
			if modal_title:
				modal_title.text = "DELETE AT INDEX"
			single_input_row.show()
			double_input_container.hide()
			if index_spin:
				index_spin.max_value = max_index
				index_spin.value = 0
			if confirm_btn:
				confirm_btn.text = "DELETE"
	
	show()

func _on_confirm_pressed():
	if not confirm_callback:
		return
	
	match current_action:
		ActionType.ACCESS:
			if index_spin:
				confirm_callback.call(index_spin.value)
		ActionType.INSERT_AT_END:
			if value_spin:
				confirm_callback.call(value_spin.value)
		ActionType.INSERT_AT_INDEX:
			if value_spin and insert_index_spin:
				confirm_callback.call(value_spin.value, insert_index_spin.value)
		ActionType.DELETE:
			if index_spin:
				confirm_callback.call(index_spin.value)
	
	hide()

func _on_cancel_pressed():
	hide()
