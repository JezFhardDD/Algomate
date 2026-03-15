extends Panel
class_name DifficultyPopup

signal difficulty_selected(difficulty: String, topic: String)
signal popup_closed

@onready var background = $PopupBackground
@onready var content = $PopupContent
@onready var close_button = $PopupContent/CloseButton
@onready var easy_button = $PopupContent/EasyButton
@onready var medium_button = $PopupContent/MediumButton
@onready var hard_button = $PopupContent/HardButton

var current_topic: String = ""

@export var animation_duration: float = 0.2
@export var popup_start_scale: Vector2 = Vector2(0.8, 0.8)

func _ready():
	connect_buttons()
	set_pixel_filtering()
	hide_instant()
	mouse_filter = Control.MOUSE_FILTER_STOP
	if background:
		background.mouse_filter = Control.MOUSE_FILTER_IGNORE

func connect_buttons():
	if easy_button:
		easy_button.pressed.connect(_on_easy_pressed)
	if medium_button:
		medium_button.pressed.connect(_on_medium_pressed)
	if hard_button:
		hard_button.pressed.connect(_on_hard_pressed)
	if close_button:
		close_button.pressed.connect(_on_close_pressed)

func set_pixel_filtering():
	if background:
		background.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if easy_button:
		easy_button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if medium_button:
		medium_button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if hard_button:
		hard_button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if close_button:
		close_button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

func show_for_topic(topic: String):
	current_topic = topic
	_update_difficulty_buttons(topic)
	show_popup()
func _update_difficulty_buttons(topic: String):
	var medium_unlocked = DB.is_level_unlocked(topic, 2)
	var hard_unlocked = DB.is_level_unlocked(topic, 3)
	
	# Medium button
	if medium_button:
		medium_button.disabled = not medium_unlocked
		if medium_unlocked:
			medium_button.modulate = Color(1, 1, 1, 1)
		else:
			medium_button.modulate = Color(0.4, 0.4, 0.4, 1)
	
	# Hard button
	if hard_button:
		hard_button.disabled = not hard_unlocked
		if hard_unlocked:
			hard_button.modulate = Color(1, 1, 1, 1)
		else:
			hard_button.modulate = Color(0.4, 0.4, 0.4, 1)
	
	# Easy is always unlocked if topic is unlocked
	if easy_button:
		easy_button.disabled = false
		easy_button.modulate = Color(1, 1, 1, 1)
func show_popup():
	show()
	if background:
		background.modulate.a = 0.0
	if content:
		content.scale = popup_start_scale
	
	if background:
		var bg_tween = create_tween()
		bg_tween.tween_property(background, "modulate:a", 1.0, animation_duration)
	
	if content:
		var content_tween = create_tween()
		content_tween.set_trans(Tween.TRANS_BACK)
		content_tween.set_ease(Tween.EASE_OUT)
		content_tween.tween_property(content, "scale", Vector2.ONE, animation_duration)

func hide_popup():
	if background:
		var bg_tween = create_tween()
		bg_tween.tween_property(background, "modulate:a", 0.0, animation_duration)
	
	if content:
		var content_tween = create_tween()
		content_tween.set_trans(Tween.TRANS_BACK)
		content_tween.set_ease(Tween.EASE_IN)
		content_tween.tween_property(content, "scale", popup_start_scale, animation_duration)
		await content_tween.finished
	
	hide()
	if content:
		content.scale = Vector2.ONE
	if background:
		background.modulate.a = 1.0
	
	popup_closed.emit()

func hide_instant():
	hide()
	if content:
		content.scale = Vector2.ONE
	if background:
		background.modulate.a = 1.0

func _on_easy_pressed():
	select_difficulty("easy")

func _on_medium_pressed():
	select_difficulty("medium")

func _on_hard_pressed():
	select_difficulty("hard")

func _on_close_pressed():
	AudioManager.play_back_sound()
	await hide_popup()

func select_difficulty(difficulty: String):
	AudioManager.play_confirm_sound()
	difficulty_selected.emit(difficulty, current_topic)
	await hide_popup()

# =========================
# CLICK OUTSIDE POPUP (FOR MOBILE)
# =========================
#func _gui_input(event):
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		var mouse_pos = get_local_mouse_position()
#		
#		# If click is inside content area, let the buttons handle it
#		if content and content.get_rect().has_point(mouse_pos):
#			return
#		
#		# Click is outside content - close popup
#		_on_close_pressed()
