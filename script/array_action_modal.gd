extends Panel

enum ActionType { ACCESS, INSERT_AT_END, INSERT_AT_INDEX, DELETE, REPLACE }  # NEW: Added REPLACE

var current_action: ActionType
var confirm_callback: Callable

@onready var modal_title: Label = $ModalContent/Label
@onready var single_input_row: HBoxContainer = $ModalContent/InputContainer/SingleInputRow
@onready var double_input_container: VBoxContainer = $ModalContent/InputContainer/DoubleInputContainer
@onready var confirm_btn: Button = $ModalContent/ActionButtons/ConfirmButton
@onready var cancel_btn: Button = $ModalContent/ActionButtons/CancelButton

@onready var index_spin: SpinBox = $ModalContent/InputContainer/SingleInputRow/IndexSpinBox
@onready var value_spin: SpinBox = $ModalContent/InputContainer/DoubleInputContainer/HBoxContainer/ValueSpinBox
@onready var insert_index_spin: SpinBox = $ModalContent/InputContainer/DoubleInputContainer/HBoxContainer2/InsertIndexSpinBox

var main_scene: Control
var max_valid_index: int = 0

func _ready():
	if cancel_btn:
		cancel_btn.pressed.connect(_on_cancel_pressed)
	if confirm_btn:
		confirm_btn.pressed.connect(_on_confirm_pressed)
	
	# REMOVED: auto-correction on value_changed
	# We want to allow any number to be typed
	
	_setup_spin_boxes()
	hide()

func set_main_scene(scene: Control):
	main_scene = scene

func _setup_spin_boxes():
	if index_spin:
		index_spin.min_value = -9999  # Allow very low numbers
		index_spin.max_value = 9999   # Allow very high numbers
		index_spin.step = 1
		index_spin.rounded = true
		index_spin.value = 0
		# Make sure the line edit inside accepts any text
		var line_edit = index_spin.get_line_edit()
		if line_edit:
			line_edit.text = "0"
	
	if value_spin:
		value_spin.min_value = 1
		value_spin.max_value = 99
		value_spin.step = 1
		value_spin.rounded = true
		value_spin.value = 1
	
	if insert_index_spin:
		insert_index_spin.min_value = -9999
		insert_index_spin.max_value = 9999
		insert_index_spin.step = 1
		insert_index_spin.rounded = true
		insert_index_spin.value = 0
		var line_edit = insert_index_spin.get_line_edit()
		if line_edit:
			line_edit.text = "0"

func _show_feedback(text: String):
	if main_scene and main_scene.has_method("show_feedback"):
		main_scene.show_feedback(text, Color.YELLOW, Vector2(400, 400))

func show_for_action(action: ActionType, max_index: int, callback: Callable):
	current_action = action
	confirm_callback = callback
	max_valid_index = max_index
	
	_setup_spin_boxes()
	
	match action:
		ActionType.ACCESS:
			if modal_title:
				modal_title.text = "ACCESS ELEMENT"
			single_input_row.show()
			double_input_container.hide()
			if index_spin:
				# Just store the max, don't enforce it yet
				index_spin.value = 0
				var line_edit = index_spin.get_line_edit()
				if line_edit:
					line_edit.placeholder_text = "0-%d" % max_index
			if confirm_btn:
				confirm_btn.text = "ACCESS"
			
		ActionType.INSERT_AT_END:
			if modal_title:
				modal_title.text = "INSERT AT END"
			single_input_row.hide()
			double_input_container.show()
			
			if double_input_container.get_child_count() >= 2:
				double_input_container.get_child(0).show()
				double_input_container.get_child(1).hide()
			
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
			
			if double_input_container.get_child_count() >= 2:
				double_input_container.get_child(0).show()
				double_input_container.get_child(1).show()
			
			if value_spin:
				value_spin.max_value = 99
				value_spin.min_value = 1
				value_spin.value = 1
			if insert_index_spin:
				insert_index_spin.value = 0
				var line_edit = insert_index_spin.get_line_edit()
				if line_edit:
					line_edit.placeholder_text = "0-%d" % max_index
			if confirm_btn:
				confirm_btn.text = "INSERT"
			
		ActionType.DELETE:
			if modal_title:
				modal_title.text = "DELETE AT INDEX"
			single_input_row.show()
			double_input_container.hide()
			if index_spin:
				index_spin.value = 0
				var line_edit = index_spin.get_line_edit()
				if line_edit:
					line_edit.placeholder_text = "0-%d" % max_index
			if confirm_btn:
				confirm_btn.text = "DELETE"
		
		ActionType.REPLACE:  # NEW: Replace action
			if modal_title:
				modal_title.text = "REPLACE ELEMENT"
			single_input_row.hide()
			double_input_container.show()
			
			# Show both value and index inputs for replace
			if double_input_container.get_child_count() >= 2:
				double_input_container.get_child(0).show()  # Value input row
				double_input_container.get_child(1).show()  # Index input row
			
			if value_spin:
				value_spin.max_value = 99
				value_spin.min_value = 1
				value_spin.value = 1
			if insert_index_spin:  # Reusing insert_index_spin for replace index
				insert_index_spin.value = 0
				var line_edit = insert_index_spin.get_line_edit()
				if line_edit:
					line_edit.placeholder_text = "0-%d" % max_index
			if confirm_btn:
				confirm_btn.text = "REPLACE"
	
	show()

func _on_confirm_pressed():
	if not confirm_callback:
		return
	
	# Validate at confirmation time
	match current_action:
		ActionType.ACCESS, ActionType.DELETE:
			if index_spin:
				var idx = int(index_spin.value)
				if idx < 0 or idx > max_valid_index:
					var feedback = "Index %d is out of bounds! Valid range: 0-%d" % [idx, max_valid_index]
					_show_feedback(feedback)
					return
				confirm_callback.call(idx)
				
		ActionType.INSERT_AT_END:
			if value_spin:
				var val = int(value_spin.value)
				if val < 1 or val > 99:
					_show_feedback("Value must be between 1 and 99")
					return
				confirm_callback.call(val)
				
		ActionType.INSERT_AT_INDEX:
			if value_spin and insert_index_spin:
				var idx = int(insert_index_spin.value)
				if idx < 0 or idx > max_valid_index:
					var feedback = "Index %d is out of bounds! Valid range: 0-%d" % [idx, max_valid_index]
					_show_feedback(feedback)
					return
				var val = int(value_spin.value)
				if val < 1 or val > 99:
					_show_feedback("Value must be between 1 and 99")
					return
				confirm_callback.call(val, idx)
		
		ActionType.REPLACE:  # NEW: Replace validation
			if value_spin and insert_index_spin:
				var idx = int(insert_index_spin.value)
				if idx < 0 or idx > max_valid_index:
					var feedback = "Index %d is out of bounds! Valid range: 0-%d" % [idx, max_valid_index]
					_show_feedback(feedback)
					return
				var val = int(value_spin.value)
				if val < 1 or val > 99:
					_show_feedback("Value must be between 1 and 99")
					return
				confirm_callback.call(val, idx)
	
	hide()

func _on_cancel_pressed():
	hide()
