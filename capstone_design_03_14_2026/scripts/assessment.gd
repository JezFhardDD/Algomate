extends Control

func _on_back_button_pressed():
	AudioManager.play_back_sound()
	SceneManager.go_back()
