extends Control

@onready var music_slider: HSlider = $music/HSlider
@onready var sound_slider: HSlider = $soundfx/HSlider
@onready var back_button: TextureButton = $back_button

func _ready():
	# Small delay to ensure AudioManager is ready
	await get_tree().process_frame
	
	# Get current volumes
	var current_music = AudioManager.get_music_volume()
	var current_sound = AudioManager.get_sound_volume()
	
	print("Settings opened - Music: ", current_music, " Sound: ", current_sound)  # DEBUG
	
	# Set slider values
	music_slider.value = current_music
	sound_slider.value = current_sound
	
	# Connect slider signals
	music_slider.value_changed.connect(_on_music_volume_changed)
	sound_slider.value_changed.connect(_on_sound_volume_changed)
	
	# Connect back button
	back_button.pressed.connect(_on_back_button_pressed)

func _on_music_volume_changed(value: float):
	print("Music slider changed to: ", value)  # DEBUG
	AudioManager.set_music_volume(value)
	AudioManager.play_click_sound()

func _on_sound_volume_changed(value: float):
	print("Sound slider changed to: ", value)  # DEBUG
	AudioManager.set_sound_volume(value)
	AudioManager.play_click_sound()

func _on_back_button_pressed():
	AudioManager.play_back_sound()
	SceneManager.go_back()
