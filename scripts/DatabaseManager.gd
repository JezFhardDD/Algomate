# res://scripts/DatabaseManager.gd
extends Node

var db: SQLite = null
const DB_PATH = "user://algomate.db"
const ITEM_PRICES = {
	"res://assets/profile_pics/boyCCT2.jpg": 0,
	"res://assets/profile_pics/girlCCT2.jpeg": 0,
	"res://assets/profile_pics/bread1.png": 300,
	"res://assets/profile_pics/fishpfp1.png": 500,
	"res://assets/profile_pics/cat1.jpg": 900,
	"res://assets/profile_pics/wildboar1.png": 1000,
	"res://assets/profile_pics/robot1.png": 1000,
}

# Topic order for unlock chain
const TOPIC_ORDER = [
	"array", "linked_list", "stack", "queue", "tree",
	"binary_tree", "binary_search_tree", "graph",
	"bubble_sort", "selection_sort", "insertion_sort",
	"merge_sort", "quick_sort", "shell_sort",
	"linear_search", "binary_search", "interpolation_search",
	"graph_tree_search", "depth_first_search", "breadth_first_search"
]

const COIN_REWARDS = {
	"first": {1: 50, 2: 100, 3: 150},   # easy/medium/hard first time
	"repeat": {1: 10, 2: 20, 3: 30}     # repeat completion
}

func _ready():
	db = SQLite.new()
	db.path = DB_PATH
	var success = db.open_db()
	if success:
		print("[DB] Opened successfully at: ", DB_PATH)
		_create_tables()
		_seed_initial_data()
		load_profile()  # Load profile immediately so Global can read it
		print("[DB] Profile preloaded.")
	else:
		push_error("[DB] Failed to open database!")

# =============================================
# TABLE CREATION
# =============================================
func _create_tables():
	# Profile table
	db.create_table("profile", {
		"id":              {"data_type": "int",  "primary_key": true, "not_null": true, "auto_increment": true},
		"name":            {"data_type": "text", "not_null": true},
		"profile_picture": {"data_type": "text", "not_null": true},
		"scs_coins":       {"data_type": "int",  "default": 0}
	})

	# Level progress table
	db.create_table("level_progress", {
		"id":            {"data_type": "int",  "primary_key": true, "not_null": true, "auto_increment": true},
		"topic":         {"data_type": "text", "not_null": true},
		"difficulty":    {"data_type": "int",  "not_null": true},
		"is_unlocked":   {"data_type": "int",  "default": 0},
		"has_completed": {"data_type": "int",  "default": 0},
		"attempts":      {"data_type": "int",  "default": 0}
	})

	# Shop items table
	db.create_table("shop_items", {
		"id":           {"data_type": "int",  "primary_key": true, "not_null": true, "auto_increment": true},
		"picture_path": {"data_type": "text", "not_null": true},
		"is_purchased": {"data_type": "int",  "default": 0},
		"is_equipped":  {"data_type": "int",  "default": 0}
	})

	print("[DB] Tables ready.")

# =============================================
# SEED: only runs if level_progress is empty
# =============================================
func _seed_initial_data():
	var defaults = [
		"res://assets/profile_pics/boyCCT2.jpg",
	    "res://assets/profile_pics/girlCCT2.jpeg"
	]
	for path in defaults:
		db.query("SELECT COUNT(*) as count FROM shop_items WHERE picture_path = '" + path + "';")
		var r = db.query_result
		if r.size() == 0 or r[0]["count"] == 0:
			db.insert_row("shop_items", {
				"picture_path": path,
				"is_purchased": 1,
				"is_equipped": 0
			})
	db.query("SELECT COUNT(*) as count FROM level_progress;")
	var count = db.query_result
	if count.size() > 0 and count[0]["count"] > 0:
		print("[DB] Already seeded, skipping.")
		return
	for topic in TOPIC_ORDER:
		for diff in [1, 2, 3]:
			var unlocked = 1 if (topic == "array" and diff == 1) else 0
			db.insert_row("level_progress", {
				"topic": topic,
				"difficulty": diff,
				"is_unlocked": unlocked,
				"has_completed": 0,
				"attempts": 0
			})
	print("[DB] Seed complete.")

# =============================================
# PROFILE
# =============================================
func save_profile(name: String, picture_path: String, coins: int = 500):
	db.query("SELECT COUNT(*) as count FROM profile;")
	var result = db.query_result
	if result.size() > 0 and result[0]["count"] > 0:
		db.query("SELECT MAX(id) as max_id FROM profile;")
		var id_result = db.query_result
		var profile_id = id_result[0]["max_id"] if id_result.size() > 0 else 1
		db.update_rows("profile", "id = " + str(profile_id), {
			"name": name,
			"profile_picture": picture_path,
			"scs_coins": coins
		})
	else:
		db.insert_row("profile", {
			"name": name,
			"profile_picture": picture_path,
			"scs_coins": coins
		})
	print("[DB] Profile saved.")

func load_profile() -> Dictionary:
	db.query("SELECT * FROM profile ORDER BY id DESC LIMIT 1;")
	var result = db.query_result
	if result.size() > 0:
		return result[0]
	return {}

func update_coins(new_total: int):
	db.query("SELECT COUNT(*) as count FROM profile;")
	var result = db.query_result
	if result.size() > 0 and result[0]["count"] > 0:
		db.query("UPDATE profile SET scs_coins = " + str(new_total) + " WHERE id = (SELECT MAX(id) FROM profile);")
		print("[DB] Coins saved to DB: ", new_total)
	else:
		print("[DB] WARNING: No profile row exists, coins not saved!")

func get_coins() -> int:
	# Gets the most recent profile instead of assuming the ID is 1
	db.query("SELECT scs_coins FROM profile ORDER BY id DESC LIMIT 1;")
	var result = db.query_result
	if result.size() > 0:
		return result[0]["scs_coins"]
	return 0

# =============================================
# LEVEL PROGRESS
# =============================================
func is_level_unlocked(topic: String, difficulty: int) -> bool:
	db.query("SELECT is_unlocked FROM level_progress WHERE topic = '" + topic + "' AND difficulty = " + str(difficulty) + ";")
	var result = db.query_result
	if result.size() > 0:
		return result[0]["is_unlocked"] == 1
	return false

func get_level_data(topic: String, difficulty: int) -> Dictionary:
	db.query("SELECT * FROM level_progress WHERE topic = '" + topic + "' AND difficulty = " + str(difficulty) + ";")
	var result = db.query_result
	if result.size() > 0:
		return result[0]
	return {}

func get_all_progress() -> Array:
	db.query("SELECT * FROM level_progress ORDER BY id;")
	return db.query_result

func record_attempt(topic: String, difficulty: int):
	db.query("UPDATE level_progress SET attempts = attempts + 1 WHERE topic = '" + topic + "' AND difficulty = " + str(difficulty) + ";")

func complete_level(topic: String, difficulty: int) -> int:
	var level_data = get_level_data(topic, difficulty)
	if level_data.is_empty():
		return 0

	var is_first_time = level_data["has_completed"] == 0
	var coins_earned = 0

	if is_first_time:
		coins_earned = COIN_REWARDS["first"][difficulty]
	else:
		coins_earned = COIN_REWARDS["repeat"][difficulty]

	db.query("UPDATE level_progress SET has_completed = 1, attempts = attempts + 1 WHERE topic = '" + topic + "' AND difficulty = " + str(difficulty) + ";")
	_unlock_next(topic, difficulty)

	var current_coins = get_coins()
	var new_total = current_coins + coins_earned
	update_coins(new_total)
	Global.scs_coins = new_total
	Global.coins_updated.emit(Global.scs_coins)

	print("[DB] Level complete! Topic: ", topic, " Diff: ", difficulty, " Coins earned: +", coins_earned, " New total: ", new_total)
	return coins_earned

func _unlock_next(topic: String, difficulty: int):
	# Standard progression within same topic
	if difficulty == 1:
		_unlock(topic, 2)

	elif difficulty == 2:
		_unlock(topic, 3)
		# Custom cross-topic unlocks on medium completion
		_unlock_cross_topic(topic)

	elif difficulty == 3:
		# Hard completion also tries default next topic easy
		var next = _get_next_topic(topic)
		if next != "" and not _is_skipped_topic(next):
			_unlock(next, 1)

func _unlock_cross_topic(topic: String):
	match topic:
		"queue":
			# Queue medium → unlock bubble_sort easy
			_unlock("bubble_sort", 1)
			print("[DB] Queue medium cleared → bubble_sort easy unlocked")
		"interpolation_search":
			# Interpolation search medium → unlock depth_first_search easy
			_unlock("depth_first_search", 1)
			print("[DB] Interpolation search medium cleared → depth_first_search easy unlocked")
		_:
			# Default: unlock easy of next topic in chain
			var next = _get_next_topic(topic)
			if next != "" and not _is_skipped_topic(next):
				_unlock(next, 1)

func _is_skipped_topic(topic: String) -> bool:
	# These topics have no simulation, skip them in the unlock chain
	var skipped = ["tree", "binary_tree", "binary_search_tree", "graph", "graph_tree_search"]
	return topic in skipped


func _unlock(topic: String, difficulty: int):
	db.query("UPDATE level_progress SET is_unlocked = 1 WHERE topic = '" + topic + "' AND difficulty = " + str(difficulty) + ";")
	print("[DB] Unlocked: ", topic, " diff ", difficulty)

func _get_next_topic(topic: String) -> String:
	var idx = TOPIC_ORDER.find(topic)
	if idx < 0:
		return ""
	# Find next non-skipped topic
	for i in range(idx + 1, TOPIC_ORDER.size()):
		if not _is_skipped_topic(TOPIC_ORDER[i]):
			return TOPIC_ORDER[i]
	return ""

# =============================================
# SHOP
# =============================================
func init_shop_items(picture_paths: Array):
	# Call this once with all available shop picture paths
	for path in picture_paths:
		db.query("SELECT COUNT(*) as count FROM shop_items WHERE picture_path = '" + path + "';")
		var result = db.query_result
		if result.size() == 0 or result[0]["count"] == 0:
			db.insert_row("shop_items", {
				"picture_path": path,
				"is_purchased": 0,
				"is_equipped":  0
			})

func get_shop_items() -> Array:
	db.query("SELECT * FROM shop_items;")
	return db.query_result

func purchase_item(picture_path: String) -> bool:
	# Insert row if it doesn't exist, then mark as purchased
	db.query("SELECT COUNT(*) as count FROM shop_items WHERE picture_path = '" + picture_path + "';")
	var result = db.query_result
	if result.size() > 0 and result[0]["count"] == 0:
		db.insert_row("shop_items", {
			"picture_path": picture_path,
			"is_purchased": 1,
			"is_equipped": 0
		})
	else:
		db.query("UPDATE shop_items SET is_purchased = 1 WHERE picture_path = '" + picture_path + "';")
	print("[DB] Purchased: ", picture_path)
	return true

func equip_item(picture_path: String):
	db.query("UPDATE shop_items SET is_equipped = 0;")  # unequip all
	db.query("UPDATE shop_items SET is_equipped = 1 WHERE picture_path = '" + picture_path + "';")
	# Updates the max/latest ID instead of assuming the ID is 1
	db.query("UPDATE profile SET profile_picture = '" + picture_path + "' WHERE id = (SELECT MAX(id) FROM profile);")
	Global.equipped_picture = picture_path
	Global.profile_data["profile_picture"] = picture_path
	print("[DB] Equipped: ", picture_path)

func is_item_purchased(picture_path: String) -> bool:
	db.query("SELECT is_purchased FROM shop_items WHERE picture_path = '" + picture_path + "';")
	var result = db.query_result
	if result.size() > 0:
		return result[0]["is_purchased"] == 1
	return false

func _get_item_price(picture_path: String) -> int:
	return ITEM_PRICES.get(picture_path, 0)

# =============================================
# RESET
# =============================================
func reset_all():
	db.query("DELETE FROM profile;")
	db.query("DELETE FROM level_progress;")
	db.query("DELETE FROM shop_items;")
	_seed_initial_data()
	print("[DB] Full reset done.")
