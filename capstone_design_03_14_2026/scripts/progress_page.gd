extends Control



func _on_back_button_pressed() -> void:
	AudioManager.play_back_sound()
	SceneManager.go_back()
