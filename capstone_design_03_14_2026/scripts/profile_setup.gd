extends Window
signal profile_created

@onready var name_input: LineEdit = $Panel/VBoxContainer/name_input
@onready var done_button: Button = $Panel/VBoxContainer/HBoxContainer/done_button
@onready var cancel_button: Button = $Panel/VBoxContainer/HBoxContainer/cancel_button
@onready var profile_pic_container: GridContainer = $Panel/VBoxContainer/profile_pic_container
@onready var click_sfx: AudioStreamPlayer = $ClickSFX

# The new selection border node
@onready var selection_border: ReferenceRect = $Panel/SelectionBorder

var pic_buttons: Array[TextureButton] = []
var selected_pic_path: String = ""
var selected_pic_index: int = -1

var profile_pictures = [
	preload("res://assets/profile_pics/boyCCT2.jpg"),
	preload("res://assets/profile_pics/girlCCT2.jpeg")
]

func _ready():
	popup_window = true
	exclusive = true 
	
	done_button.pressed.connect(_on_done_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	done_button.disabled = true
	name_input.text_changed.connect(_on_name_changed)
	
	create_profile_pic_buttons()

func play_sfx():
	if click_sfx:
		click_sfx.play()

func create_profile_pic_buttons():
	for button in pic_buttons:
		button.queue_free()
	pic_buttons.clear()
	
	for i in range(profile_pictures.size()):
		var button = TextureButton.new()
		button.texture_normal = profile_pictures[i]
		button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		button.ignore_texture_size = true
		button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_COVERED
		
		# Set size and pivot to center (fixes the "lower right" shifting)
		button.custom_minimum_size = Vector2(100, 100)
		button.pivot_offset = Vector2(50, 50) 
		
		button.set_meta("pic_index", i)
		button.set_meta("pic_path", profile_pictures[i].resource_path)
		button.pressed.connect(_on_pic_selected.bind(button))
		
		profile_pic_container.add_child(button)
		pic_buttons.append(button)

func _on_pic_selected(button: TextureButton):
	play_sfx()
	selected_pic_index = button.get_meta("pic_index")
	selected_pic_path = button.get_meta("pic_path")
	
	# Show and move the border
	selection_border.visible = true
	selection_border.size = button.size
	
	# Create a smooth transition for all effects
	var tween = create_tween().set_parallel(true)
	
	# Move the border to the button's global position (adjusted for panel space)
	tween.tween_property(selection_border, "global_position", button.global_position, 0.15)\
		.set_trans(Tween.TRANS_SINE)
	
	# Reset other buttons
	for btn in pic_buttons:
		if btn != button:
			tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.2)
			tween.tween_property(btn, "modulate", Color(0.7, 0.7, 0.7), 0.2) # Dim unselected
	
	# Highlight selected button
	tween.tween_property(button, "scale", Vector2(1.1, 1.1), 0.2)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "modulate", Color.WHITE, 0.2)
	
	check_form_complete()

func _on_name_changed(_new_text: String):
	check_form_complete()

func check_form_complete():
	var name_filled = not name_input.text.strip_edges().is_empty()
	var pic_selected = selected_pic_index >= 0
	done_button.disabled = not (name_filled and pic_selected)

func _on_done_pressed():
	play_sfx()
	Global.set_profile_name(name_input.text.strip_edges())
	Global.set_profile_picture(selected_pic_path)
	profile_created.emit()
	queue_free()

func _on_cancel_pressed():
	play_sfx()
	queue_free()

func _on_close_requested():
	queue_free()
