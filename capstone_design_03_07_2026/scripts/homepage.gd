extends Control

# Fade
@onready var fade_rect = $FadeRect
@onready var code_button: Button = %code_button
@onready var assessement_button: Button = %assessement_button
@onready var lecture_button: Button = %lecture_button
@onready var navigation: Control = $navigation


# Tab animation
@export var pop_offset := Vector2(0, -8)
@export var anim_time := 0.15

var current_tab: Button = null
var original_positions := {}

func _ready():
	# Fade in
	fade_rect.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.0)
	
	# Store original positions of all tabs
	for tab in $tab_control.get_children():
		original_positions[tab] = tab.position
	
	if Global.has_profile():
		navigation.update_profile_display()
		
# Call this when a tab button is pressed
func select_tab(tab: Button):
	if current_tab == tab:
		return
	
	# Reset old tab
	if current_tab:
		animate_tab(current_tab, original_positions[current_tab], 0)
	
	# Set new tab
	current_tab = tab
	var new_pos = original_positions[tab] + pop_offset
	animate_tab(current_tab, new_pos, 10)

func animate_tab(tab: Button, target_pos: Vector2, z: int):
	tab.z_index = z
	var tween = create_tween()
	tween.tween_property(tab, "position", target_pos, anim_time)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)



func _on_lecture_tab_pressed() -> void:
	select_tab($tab_control/lecture_tab)
	lecture_button.show()
	assessement_button.hide()
	code_button.hide()
func _on_assessment_tab_pressed() -> void:
	select_tab($tab_control/assessment_tab)
	assessement_button.show()
	lecture_button.hide()
	code_button.hide()
func _on_code_tab_pressed() -> void:
	select_tab($tab_control/code_tab)
	code_button.show()
	lecture_button.hide()
	assessement_button.hide()


func _on_lecture_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/lectures.tscn")


func _on_assessement_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/assessment.tscn")
