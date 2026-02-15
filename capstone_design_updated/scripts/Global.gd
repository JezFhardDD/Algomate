extends Node

var profile_name = ""
var profile_picture = ""

func _ready():
	load_profile()

func has_profile():
	return not profile_name.is_empty()

func save_profile():
	var save_data = {
		"name": profile_name,
		"picture": profile_picture
	}
	var save_file = FileAccess.open("user://profile.save", FileAccess.WRITE)
	save_file.store_var(save_data)

func load_profile():
	if FileAccess.file_exists("user://profile.save"):
		var save_file = FileAccess.open("user://profile.save", FileAccess.READ)
		var save_data = save_file.get_var()
		profile_name = save_data["name"]
		profile_picture = save_data["picture"]
		
func reset_profile():
	profile_name = ""
	profile_picture = ""
	# Delete save file (if using one)
	var save_path = "user://profile.save"
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)
