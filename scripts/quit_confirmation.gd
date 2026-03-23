extends Panel

func _on_yes_btn_pressed() -> void:
	AudioManager.play_click_sound()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()

func _on_no_btn_pressed() -> void:
	AudioManager.play_click_sound() # Optional: add the click sound here too!
	hide() # This makes the panel invisible but keeps it in memory
