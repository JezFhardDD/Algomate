extends Control

@onready var music_slider: HSlider = $music/HSlider
@onready var sound_slider: HSlider = $soundfx/HSlider
@onready var back_button: TextureButton = $back_button
@onready var reset_button: Button = $ResetButton
@onready var reset_confirmation: Panel = $resetProfileConfirmation
@onready var yes_button: Button = $resetProfileConfirmation/yes
@onready var no_button: Button = $resetProfileConfirmation/no
@onready var mute_checkbox: CheckBox = $CheckBox

func _ready():
	await get_tree().process_frame

	var current_music = AudioManager.get_music_volume()
	var current_sound = AudioManager.get_sound_volume()

	music_slider.value = current_music
	sound_slider.value = current_sound

	# Set checkbox to reflect current mute state (muted = both music AND sfx muted)
	mute_checkbox.button_pressed = AudioManager.is_music_muted()

	music_slider.value_changed.connect(_on_music_volume_changed)
	sound_slider.value_changed.connect(_on_sound_volume_changed)
	mute_checkbox.toggled.connect(_on_mute_toggled)
	back_button.pressed.connect(_on_back_button_pressed)
	reset_button.pressed.connect(_on_reset_button_pressed)
	yes_button.pressed.connect(_on_yes_pressed)
	no_button.pressed.connect(_on_no_pressed)

	reset_confirmation.visible = false

func _on_music_volume_changed(value: float):
	AudioManager.set_music_volume(value)
	AudioManager.play_click_sound()

func _on_sound_volume_changed(value: float):
	AudioManager.set_sound_volume(value)
	AudioManager.play_click_sound()

func _on_mute_toggled(muted: bool):
	AudioManager.set_music_muted(muted)
	AudioManager.set_sound_muted(muted)

func _on_back_button_pressed():
	AudioManager.play_back_sound()
	SceneManager.go_back()

func _on_reset_button_pressed():
	AudioManager.play_click_sound()
	reset_confirmation.visible = true

func _on_no_pressed():
	AudioManager.play_back_sound()
	reset_confirmation.visible = false

func _on_yes_pressed():
	AudioManager.play_click_sound()
	Global.reset_profile()
	SceneManager.clear_stack()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
