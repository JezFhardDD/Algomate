# Global.gd
extends Node

# Use a dictionary to store all profile data
var profile_data = {}

# Signal to notify when profile changes
signal profile_updated
signal profile_reset

# File path for saving profile
const SAVE_PATH = "user://profile_data.save"

func _ready():
	load_profile()
	
func set_profile_picture(picture_path: String):
	profile_data["profile_picture"] = picture_path
	save_profile()
	profile_updated.emit()

func get_profile_picture() -> String:
	return profile_data.get("profile_picture", "")
	
func has_profile() -> bool:
	return profile_data.size() > 0

func get_profile_name() -> String:
	return profile_data.get("profile_name", "")

# Changed parameter name from "name" to "profile_name" to avoid shadowing
func set_profile_name(profile_name: String):
	profile_data["profile_name"] = profile_name
	save_profile()
	profile_updated.emit()

func reset_profile():
	# Clear profile data
	profile_data = {}
	# Delete the save file
	remove_save_file()
	# Save empty state
	save_profile()
	print("Profile reset - data cleared")
	profile_reset.emit()

func remove_save_file():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		print("Save file removed")

func save_profile():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(profile_data)
	file.close()
	print("Profile saved: ", profile_data)

func load_profile():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		profile_data = file.get_var()
		file.close()
		print("Profile loaded: ", profile_data)
	else:
		profile_data = {}
		print("No save file found, starting fresh")

# Add to Global.gd

func set_profile_pic_index(index: int):
	profile_data["profile_pic_index"] = index
	save_profile()
	profile_updated.emit()

func get_profile_pic_index() -> int:
	return profile_data.get("profile_pic_index", 0)
