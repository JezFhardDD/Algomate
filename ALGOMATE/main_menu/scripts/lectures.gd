extends Control

@onready var array: TextureButton = $contents/array
@onready var linked_list: TextureButton = $contents/linked_list
@onready var stack: TextureButton = $contents/stack
@onready var queue: TextureButton = $contents/queue

@export var press_scale := Vector2(0.9, 0.9)
@export var normal_scale := Vector2(1, 1)
@export var bounce_time := 0.2      # Total bounce duration
@export var fade_time := 0.5

func _on_array_pressed() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	# Button bounce: push down and pop
	tween.tween_property(array, "scale", press_scale, bounce_time / 2)
	tween.tween_property(array, "scale", normal_scale, bounce_time / 2)
	
	await tween.finished


func _on_linked_list_pressed() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	# Button bounce: push down and pop
	tween.tween_property(linked_list, "scale", press_scale, bounce_time / 2)
	tween.tween_property(linked_list, "scale", normal_scale, bounce_time / 2)
	
	await tween.finished


func _on_stack_pressed() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	# Button bounce: push down and pop
	tween.tween_property(stack, "scale", press_scale, bounce_time / 2)
	tween.tween_property(stack, "scale", normal_scale, bounce_time / 2)
	
	await tween.finished


func _on_queue_pressed() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	# Button bounce: push down and pop
	tween.tween_property(queue, "scale", press_scale, bounce_time / 2)
	tween.tween_property(queue, "scale", normal_scale, bounce_time / 2)
	
	await tween.finished


func _on_back_button_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/homepage.tscn")
