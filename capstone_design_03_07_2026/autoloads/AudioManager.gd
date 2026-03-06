extends Node

var music_player: AudioStreamPlayer
var current_music: String = ""

# Volume settings
var music_volume: float = 0.5  # 0.0 to 1.0
var sound_volume: float = 0.5

func _ready():
	# Create the music player
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = "Music"  # You can create a Music bus in Audio settings
	add_child(music_player)
	
	# Load saved volume settings (optional)
	load_volume_settings()

func play_music(music_path: String, volume: float = 0.5):
	# Don't restart if same music is already playing
	if current_music == music_path and music_player.playing:
		return
	
	# Load the music file
	var stream = load(music_path)
	if stream:
		# Enable looping based on audio type
		if stream is AudioStreamMP3:
			# For MP3 files
			stream.loop = true
			print("MP3 loop enabled")
		elif stream is AudioStreamOggVorbis:  # Changed from AudioStreamOGGVorbis
			# For OGG files
			stream.loop = true
			print("OGG loop enabled")
		elif stream is AudioStreamWAV:
			# For WAV files
			stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
			print("WAV loop enabled")
		else:
			print("Unknown audio format: ", stream.get_class())
		
		current_music = music_path
		music_player.stream = stream
		music_player.volume_db = linear_to_db(music_volume)
		music_player.play()
		print("Playing music: ", music_path)

func stop_music():
	music_player.stop()
	current_music = ""

func set_music_volume(volume: float):
	music_volume = clamp(volume, 0.0, 1.0)
	music_player.volume_db = linear_to_db(music_volume)
	save_volume_settings()

func set_sound_volume(volume: float):
	sound_volume = clamp(volume, 0.0, 1.0)
	save_volume_settings()

func get_music_volume() -> float:
	return music_volume

func get_sound_volume() -> float:
	return sound_volume

# Helper function to convert linear to decibel
func linear_to_db(linear: float) -> float:
	if linear <= 0.0:
		return -80.0
	return 20.0 * log(linear) / log(10)

# Optional: Save volume settings
func save_volume_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sound_volume", sound_volume)
	config.save("user://audio_settings.cfg")

func load_volume_settings():
	var config = ConfigFile.new()
	if config.load("user://audio_settings.cfg") == OK:
		music_volume = config.get_value("audio", "music_volume", 0.5)
		sound_volume = config.get_value("audio", "sound_volume", 0.5)

# Optional: Add sound effects
func play_sound(sound_path: String):
	var player = AudioStreamPlayer2D.new()
	player.stream = load(sound_path)
	player.volume_db = linear_to_db(sound_volume)
	player.bus = "SFX"
	add_child(player)
	player.play()
	
	# Auto-remove when done
	await player.finished
	player.queue_free()
