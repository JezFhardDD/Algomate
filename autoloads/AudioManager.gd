extends Node

var music_player: AudioStreamPlayer
var current_music: String = ""

# Volume settings
var music_volume: float = 0.5  # 0.0 to 1.0
var sound_volume: float = 0.5  # For sound effects

# Track mute states
var music_muted: bool = false
var sound_muted: bool = false

# For managing multiple sound effects
var sound_players: Array = []

func _ready():
	# Create the music player
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = "Music"  # Create a Music bus in Audio settings
	add_child(music_player)
	
	# Load saved volume settings
	load_audio_settings()

func play_music(music_path: String):
	# Don't restart if same music is already playing
	if current_music == music_path and music_player.playing:
		return
	
	# Load the music file
	var stream = load(music_path)
	if stream:
		# Enable looping for music
		if stream is AudioStreamMP3:
			stream.loop = true
		elif stream is AudioStreamOggVorbis:
			stream.loop = true
		elif stream is AudioStreamWAV:
			stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		
		current_music = music_path
		music_player.stream = stream
		music_player.volume_db = linear_to_db(music_volume if not music_muted else 0)
		music_player.play()
		print("Playing music: ", music_path)

func stop_music():
	music_player.stop()
	current_music = ""

# SOUND EFFECT FUNCTIONS

func play_sound(sound_path: String, volume_scale: float = 1.0):
	"""Play a sound effect once"""
	if sound_muted:
		return
	
	var stream = load(sound_path)
	if not stream:
		print("Sound file not found: ", sound_path)
		return
	
	# Create a new player for this sound
	var player = AudioStreamPlayer2D.new()  # Use AudioStreamPlayer for 2D, AudioStreamPlayer3D for 3D
	player.stream = stream
	player.volume_db = linear_to_db(sound_volume * volume_scale)
	player.bus = "SFX"  # Create an SFX bus in Audio settings
	
	# Add to scene and play
	add_child(player)
	player.play()
	sound_players.append(player)
	
	# Remove when done
	await player.finished
	player.queue_free()
	sound_players.erase(player)

func play_click_sound():
	"""Convenience function for click sounds"""
	play_sound("res://assets/sounds/tap.mp3")

func play_hover_sound():
	"""Convenience function for hover sounds"""
	play_sound("res://assets/sounds/hover.wav")

func play_back_sound():
	"""Convenience function for back button sounds"""
	play_sound("res://assets/sounds/game_start.mp3")

func play_confirm_sound():
	"""Convenience function for confirm sounds"""
	play_sound("res://assets/sounds/game_start.mp3")

# VOLUME CONTROL FUNCTIONS

func set_music_volume(volume: float):
	music_volume = clamp(volume, 0.0, 1.0)
	if not music_muted:
		music_player.volume_db = linear_to_db(music_volume)
	save_audio_settings()

func set_sound_volume(volume: float):
	sound_volume = clamp(volume, 0.0, 1.0)
	save_audio_settings()

func get_music_volume() -> float:
	return music_volume

func get_sound_volume() -> float:
	return sound_volume

# MUTE FUNCTIONS

func set_music_muted(muted: bool):
	music_muted = muted
	if muted:
		music_player.volume_db = -80.0  # Mute
	else:
		music_player.volume_db = linear_to_db(music_volume)
	save_audio_settings()

func set_sound_muted(muted: bool):
	sound_muted = muted
	save_audio_settings()

func is_music_muted() -> bool:
	return music_muted

func is_sound_muted() -> bool:
	return sound_muted

# HELPER FUNCTIONS

func linear_to_db(linear: float) -> float:
	if linear <= 0.0:
		return -80.0
	return 20.0 * log(linear) / log(10)

# SAVE/LOAD SETTINGS

func save_audio_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sound_volume", sound_volume)
	config.set_value("audio", "music_muted", music_muted)
	config.set_value("audio", "sound_muted", sound_muted)
	config.save("user://audio_settings.cfg")

# In your AudioManager.gd, update the load_audio_settings function:

func load_audio_settings():
	var config = ConfigFile.new()
	if config.load("user://audio_settings.cfg") == OK:
		music_volume = config.get_value("audio", "music_volume", 0.5)
		sound_volume = config.get_value("audio", "sound_volume", 0.5)
		music_muted = config.get_value("audio", "music_muted", false)
		sound_muted = config.get_value("audio", "sound_muted", false)
		
		print("Loaded settings - Music: ", music_volume, " Sound: ", sound_volume)  # DEBUG
		print("Muted - Music: ", music_muted, " Sound: ", sound_muted)  # DEBUG
		
		# Apply settings
		if music_player:
			if music_muted:
				music_player.volume_db = -80.0
			else:
				music_player.volume_db = linear_to_db(music_volume)
	else:
		# First time running - set defaults
		print("No settings file found, using defaults")  # DEBUG
		music_volume = 0.5
		sound_volume = 0.5
		music_muted = false
		sound_muted = false
		save_audio_settings()  # Save defaults immediately
