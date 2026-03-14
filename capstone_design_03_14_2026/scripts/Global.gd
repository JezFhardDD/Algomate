# Global.gd
extends Node

# Use a dictionary to store all profile data
var profile_data = {}
var lectures_page_index: int = 0

# =========================
# SHOP VARIABLES
# =========================
var purchased_pictures: Array = []  # Store paths of purchased profile pictures
var equipped_picture: String = ""  # Currently equipped profile picture

# =========================
# CURRENCY VARIABLES
# =========================
var scs_coins: int = 500  # Starting coins

# Signal to notify when profile changes
signal profile_updated
signal profile_reset

# Signal for shop updates
signal purchases_updated

# Signal for coin updates
signal coins_updated(amount)

# File path for saving profile
const SAVE_PATH = "user://profile_data.save"
const SHOP_SAVE_PATH = "user://shop_data.save"
const COINS_SAVE_PATH = "user://coins_data.save"

func _ready():
	print("=== GLOBAL READY ===")
	load_profile()
	load_shop_data()
	load_coins_data()
	print("Final coins value: ", scs_coins)

# =========================
# PROFILE FUNCTIONS
# =========================
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

func set_profile_name(profile_name: String):
	profile_data["profile_name"] = profile_name
	save_profile()
	profile_updated.emit()

func reset_profile():
	# Clear profile data
	profile_data = {}
	# Delete the save file
	remove_save_file()
	
	# Reset shop data
	reset_shop_data()
	
	# Reset coins to starting amount
	reset_coins()
	
	# Save empty state
	save_profile()
	print("Profile reset - data cleared")
	profile_reset.emit()

func reset_shop_data():
	# Clear purchased pictures
	purchased_pictures = []
	# Reset equipped picture to default
	equipped_picture = ""
	# Delete shop save file
	if FileAccess.file_exists(SHOP_SAVE_PATH):
		DirAccess.remove_absolute(SHOP_SAVE_PATH)
		print("Shop data reset - file removed")
	# Save empty shop data
	save_shop_data()
	# Emit signal to refresh shop if open
	purchases_updated.emit()

func reset_coins():
	scs_coins = 500  # Reset to starting amount
	# Delete coins save file
	if FileAccess.file_exists(COINS_SAVE_PATH):
		DirAccess.remove_absolute(COINS_SAVE_PATH)
		print("Coins data reset - file removed")
	# Save new coins data
	save_coins_data()
	# Emit signal to update UI
	coins_updated.emit(scs_coins)

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

func set_profile_pic_index(index: int):
	profile_data["profile_pic_index"] = index
	save_profile()
	profile_updated.emit()

func get_profile_pic_index() -> int:
	return profile_data.get("profile_pic_index", 0)

# =========================
# SHOP FUNCTIONS
# =========================
func purchase_picture(picture_path: String):
	if not purchased_pictures.has(picture_path):
		purchased_pictures.append(picture_path)
		purchases_updated.emit()
		save_shop_data()
		print("Picture purchased: ", picture_path)

func equip_picture(picture_path: String):
	equipped_picture = picture_path
	# Also update profile_data for backward compatibility
	profile_data["profile_picture"] = picture_path
	save_profile()
	purchases_updated.emit()
	print("Picture equipped: ", picture_path)

func is_picture_purchased(picture_path: String) -> bool:
	return purchased_pictures.has(picture_path)

# Save/Load shop data
func save_shop_data():
	var file = FileAccess.open(SHOP_SAVE_PATH, FileAccess.WRITE)
	var data = {
		"purchased": purchased_pictures,
		"equipped": equipped_picture
	}
	file.store_var(data)
	file.close()
	print("Shop data saved: ", data)

func load_shop_data():
	if FileAccess.file_exists(SHOP_SAVE_PATH):
		var file = FileAccess.open(SHOP_SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		purchased_pictures = data.get("purchased", [])
		equipped_picture = data.get("equipped", "")
		print("Shop data loaded: ", data)
	else:
		purchased_pictures = []
		equipped_picture = ""
		print("No shop data found, starting fresh")

# =========================
# CURRENCY FUNCTIONS
# =========================
func get_coins() -> int:
	return scs_coins

func add_coins(amount: int):
	scs_coins += amount
	print("Coins added: +", amount, " New total: ", scs_coins)
	coins_updated.emit(scs_coins)
	save_coins_data()

func spend_coins(amount: int) -> bool:
	print("Attempting to spend ", amount, " coins. Current: ", scs_coins)
	if scs_coins >= amount:
		scs_coins -= amount
		print("Coins spent: -", amount, " New total: ", scs_coins)
		coins_updated.emit(scs_coins)
		save_coins_data()
		return true
	else:
		print("Not enough coins! Needed: ", amount, " Have: ", scs_coins)
		return false

func has_enough_coins(amount: int) -> bool:
	return scs_coins >= amount

# Save/Load coins data
func save_coins_data():
	var file = FileAccess.open(COINS_SAVE_PATH, FileAccess.WRITE)
	file.store_var(scs_coins)
	file.close()
	print("Coins data saved: ", scs_coins)

func load_coins_data():
	if FileAccess.file_exists(COINS_SAVE_PATH):
		var file = FileAccess.open(COINS_SAVE_PATH, FileAccess.READ)
		scs_coins = file.get_var()
		file.close()
		print("Coins data loaded: ", scs_coins)
	else:
		scs_coins = 500
		print("No coins data found, starting with: ", scs_coins)
