extends TextureButton

@export var lesson_id: String = ""
@export var lesson_scene: String = "res://scenes/lesson_view.tscn"

func _pressed() -> void:
	if lesson_id.is_empty():
		push_warning("Lesson ID not assigned")
		return

	var lesson = load(lesson_scene).instantiate()
	lesson.set_meta("lesson_id", lesson_id)

	get_tree().current_scene.add_child(lesson)
	get_tree().current_scene.queue_free()
