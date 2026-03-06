extends Control

@onready var music_slider: HSlider = $music/HSlider
@onready var sound_slider: HSlider = $soundfx/HSlider
@onready var back_button: TextureButton = $back_button

func _ready():
	# Set slider values to current volumes
	music_slider.value = AudioManager.get_music_volume()
	sound_slider.value = AudioManager.get_sound_volume()
	
	# Connect slider signals
	music_slider.value_changed.connect(_on_music_volume_changed)
	sound_slider.value_changed.connect(_on_sound_volume_changed)
	
	# Connect back button
	back_button.pressed.connect(_on_back_button_pressed)

func _on_music_volume_changed(value: float):
	AudioManager.set_music_volume(value)

func _on_sound_volume_changed(value: float):
	AudioManager.set_sound_volume(value)

func _on_back_button_pressed():
	SceneManager.go_back()
