# Global.gd
extends Node
var last_lesson_id: String = ""
var profile_data = {}
var lectures_page_index: int = 0
var current_topic: String = ""
var current_difficulty: int = 0

# These stay for in-memory access / signals
var purchased_pictures: Array = []
var equipped_picture: String = ""
var scs_coins: int = 5000

signal profile_updated
signal profile_reset
signal purchases_updated
signal coins_updated(amount)

func _ready() -> void:
	print("=== GLOBAL READY ===")
	await _sync_from_db()
	if has_profile():
		print("Profile found: ", get_profile_name())
	else:
		print("No profile yet — main_menu will handle setup")

func _sync_from_db():
	# Wait one frame to ensure DB autoload is fully ready
	await get_tree().process_frame
	var profile = DB.load_profile()
	if profile.size() > 0:
		profile_data["profile_name"] = profile.get("name", "")
		profile_data["profile_picture"] = profile.get("profile_picture", "")
		scs_coins = profile.get("scs_coins", 5000)
		print("Profile loaded from DB: ", profile_data)
	else:
		profile_data = {}
		scs_coins = 5000
		print("No profile in DB yet.")

	var shop_items = DB.get_shop_items()
	purchased_pictures = []
	equipped_picture = ""
	for item in shop_items:
		if item["is_purchased"] == 1:
			purchased_pictures.append(item["picture_path"])
		if item["is_equipped"] == 1:
			equipped_picture = item["picture_path"]

	print("Final coins value: ", scs_coins)
	coins_updated.emit(scs_coins)

# =========================
# PROFILE FUNCTIONS
# =========================
func has_profile() -> bool:
	return profile_data.size() > 0 and profile_data.get("profile_name", "") != ""

func get_profile_name() -> String:
	return profile_data.get("profile_name", "")

func get_profile_picture() -> String:
	return profile_data.get("profile_picture", "")

func set_profile_name(name: String):
	profile_data["profile_name"] = name
	_save_profile_to_db()
	profile_updated.emit()

func set_profile_picture(picture_path: String):
	profile_data["profile_picture"] = picture_path
	_save_profile_to_db()
	profile_updated.emit()

func set_profile_pic_index(index: int):
	profile_data["profile_pic_index"] = index

func get_profile_pic_index() -> int:
	return profile_data.get("profile_pic_index", 0)

func _save_profile_to_db():
	DB.save_profile(
		profile_data.get("profile_name", ""),
		profile_data.get("profile_picture", ""),
		scs_coins
	)

func reset_profile():
	profile_data = {}
	purchased_pictures = []
	equipped_picture = ""
	scs_coins = 5000
	DB.reset_all()
	profile_reset.emit()
	coins_updated.emit(scs_coins)
	print("Profile reset complete.")

# =========================
# COIN FUNCTIONS
# =========================
func get_coins() -> int:
	return scs_coins

func add_coins(amount: int):
	scs_coins += amount
	DB.update_coins(scs_coins)
	coins_updated.emit(scs_coins)
	print("Coins added: +", amount, " New total: ", scs_coins)

func spend_coins(amount: int) -> bool:
	if scs_coins >= amount:
		scs_coins -= amount
		DB.update_coins(scs_coins)
		coins_updated.emit(scs_coins)
		return true
	print("Not enough coins!")
	return false

func has_enough_coins(amount: int) -> bool:
	return scs_coins >= amount

# =========================
# SHOP FUNCTIONS
# =========================
func purchase_picture(picture_path: String):
	if not purchased_pictures.has(picture_path):
		purchased_pictures.append(picture_path)
		DB.purchase_item(picture_path)
		purchases_updated.emit()

func equip_picture(picture_path: String):
	equipped_picture = picture_path
	profile_data["profile_picture"] = picture_path
	DB.equip_item(picture_path)
	purchases_updated.emit()

func is_picture_purchased(picture_path: String) -> bool:
	return purchased_pictures.has(picture_path)
