extends TextureButton

@export var lesson_id: String
@export var lesson_scene: PackedScene

func _pressed() -> void:
	if lesson_id.is_empty():
		push_warning("Lesson ID not assigned")
		return

	if lesson_scene == null:
		push_warning("Lesson scene not assigned")
		return

	var lesson_view: Control = lesson_scene.instantiate()
	lesson_view.set_lesson(lesson_id)

	get_tree().current_scene.queue_free()
	get_tree().root.add_child(lesson_view)
	get_tree().current_scene = lesson_view  
