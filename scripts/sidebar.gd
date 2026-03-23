extends Control

@onready var sidebar_container: Control = $sidebar_container
@onready var sidebar_button: TextureButton = $sidebar_button
@onready var exit_button: TextureButton = $sidebar_container/container/exit

@onready var profile_pic: TextureButton = %profile_pic
@onready var profile_name: Label = %profile_name

# =========================
# COIN DISPLAY - Let's find it multiple ways
# =========================
@onready var coin_label_direct = $CoinLabel  # Try direct child
@onready var coin_label_container = $CoinDisplay/CoinLabel  # Try inside CoinDisplay
var coin_label: Label = null

# =========================
# SIDEBAR BUTTONS
# =========================
@onready var home_button: TextureButton = $sidebar_container/container/home_button
@onready var lectures_button: TextureButton = $sidebar_container/container/lectures_button
@onready var assessment_button: TextureButton = $sidebar_container/container/assessment_button
@onready var progress_button: TextureButton = $sidebar_container/container/progress_button
@onready var settings_button: TextureButton = $sidebar_container/container/VBoxContainer/settingss
@onready var about_button: TextureButton = $sidebar_container/container/about_button
@onready var help_button: TextureButton = $sidebar_container/container/help_button
@onready var shop_button: TextureButton = $sidebar_container/container/shop_button

@export var slide_time := 0.3

func _ready() -> void:
	print("=== SIDEBAR READY ===")
	
	# Print all children of root to see what's available
	print("Root children:")
	for child in get_children():
		print("  - ", child.name, " (", child.get_class(), ")")
	
	# Try to find the coin label
	find_coin_label()
	
	await get_tree().process_frame

	# Start hidden
	sidebar_container.visible = false
	sidebar_container.position.x = -sidebar_container.size.x
	sidebar_container.modulate.a = 0.0

	sidebar_button.pressed.connect(toggle_sidebar)
	exit_button.pressed.connect(toggle_sidebar)
	
	# Connect sidebar buttons
	if home_button:
		home_button.pressed.connect(_on_home_pressed)
	if lectures_button:
		lectures_button.pressed.connect(_on_lectures_pressed)
	if assessment_button:
		assessment_button.pressed.connect(_on_assessment_pressed)
	if progress_button:
		progress_button.pressed.connect(_on_progress_pressed)
	if settings_button:
		settings_button.pressed.connect(_on_settings_pressed)
	if about_button:
		about_button.pressed.connect(_on_about_pressed)
	if help_button:
		help_button.pressed.connect(_on_help_pressed)
	if shop_button:
		shop_button.pressed.connect(_on_shop_pressed)
	
	# Connect to Global signals
	if Global.has_signal("profile_updated"):
		Global.profile_updated.connect(update_profile_display)
		print("Connected to profile_updated")
	if Global.has_signal("profile_reset"):
		Global.profile_reset.connect(update_profile_display)
		print("Connected to profile_reset")
	if Global.has_signal("coins_updated"):
		Global.coins_updated.connect(update_coin_display)
		print("Connected to coins_updated")
	
	# Set profile picture size
	if profile_pic:
		profile_pic.custom_minimum_size = Vector2(64, 64)
		profile_pic.size = Vector2(64, 64)
		profile_pic.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		profile_pic.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	# Update displays
	update_profile_display()
	update_coin_display()

func find_coin_label():
	print("Looking for coin label...")
	
	# Method 1: Check direct path
	if coin_label_direct and coin_label_direct is Label:
		coin_label = coin_label_direct
		print("Found coin label at $CoinLabel")
		return
	
	# Method 2: Check inside CoinDisplay
	if coin_label_container and coin_label_container is Label:
		coin_label = coin_label_container
		print("Found coin label at $CoinDisplay/CoinLabel")
		return
	
	# Method 3: Search all children for any Label
	for child in get_children_recursive(self):
		if child is Label:
			print("Found Label: ", child.name, " at path: ", child.get_path())
			if child.name == "CoinLabel" or child.name.to_lower().find("coin") >= 0:
				coin_label = child
				print("Selected this as coin label")
				return
	
	print("WARNING: No coin label found!")

func get_children_recursive(node: Node) -> Array:
	var result = []
	for child in node.get_children():
		result.append(child)
		result += get_children_recursive(child)
	return result

# =========================
# COIN DISPLAY FUNCTION
# =========================
func update_coin_display(amount: int = -1):
	if not coin_label:
		print("Coin label not found, cannot update display")
		return
	
	var coin_value = amount if amount >= 0 else Global.get_coins()
	coin_label.text = str(coin_value)
	print("Coin display updated to: ", coin_label.text)

# =========================
# PROFILE DISPLAY FUNCTION
# =========================
func update_profile_display():
	if Global.has_profile():
		profile_name.text = Global.get_profile_name()
		
		# Load and set profile picture
		var picture_path = Global.profile_data.get("profile_picture", "")
		if picture_path and (FileAccess.file_exists(picture_path) or picture_path.begins_with("res://")):
			var texture = load(picture_path)
			if texture:
				profile_pic.texture_normal = texture
				profile_pic.custom_minimum_size = Vector2(64, 64)
				profile_pic.size = Vector2(64, 64)
				profile_pic.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
				profile_pic.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			else:
				profile_pic.texture_normal = null
		else:
			profile_pic.texture_normal = null
	else:
		profile_name.text = "No Profile"
		profile_pic.texture_normal = null

# =========================
# SIDEBAR NAVIGATION FUNCTIONS
# =========================
func _on_home_pressed() -> void:
	AudioManager.play_click_sound()
	await animate_sidebar_close()
	SceneManager.change_scene("res://scenes/homepage.tscn")

func _on_lectures_pressed() -> void:
	AudioManager.play_click_sound()
	await animate_sidebar_close()
	SceneManager.change_scene("res://scenes/lectures.tscn")

func _on_assessment_pressed() -> void:
	AudioManager.play_click_sound()
	await animate_sidebar_close()
	SceneManager.change_scene("res://scenes/assessment_map.tscn")

func _on_progress_pressed() -> void:
	AudioManager.play_click_sound()
	await animate_sidebar_close()
	SceneManager.change_scene("res://scenes/progress_page.tscn")

func _on_settings_pressed() -> void:
	AudioManager.play_click_sound()
	await animate_sidebar_close()
	SceneManager.change_scene("res://scenes/settings.tscn")

func _on_about_pressed() -> void:
	AudioManager.play_click_sound()
	await animate_sidebar_close()
	SceneManager.change_scene("res://scenes/about_page.tscn")

func _on_help_pressed() -> void:
	AudioManager.play_click_sound()
	await animate_sidebar_close()
	SceneManager.change_scene("res://scenes/help.tscn")

func _on_shop_pressed() -> void:
	AudioManager.play_click_sound()
	await animate_sidebar_close()
	SceneManager.change_scene("res://scenes/shop.tscn")

# =========================
# ANIMATION FUNCTIONS
# =========================
func animate_sidebar_open() -> void:
	if sidebar_container.visible:
		return
	sidebar_container.visible = true
	sidebar_container.modulate.a = 0.0
	sidebar_container.position.x = sidebar_container.size.x

	var tween = create_tween()
	tween.tween_property(sidebar_container, "position:x", 0, slide_time)
	tween.parallel().tween_property(sidebar_container, "modulate:a", 1.0, slide_time)

func animate_sidebar_close() -> void:
	var tween = create_tween()
	tween.tween_property(sidebar_container, "position:x", sidebar_container.size.x, slide_time)
	tween.parallel().tween_property(sidebar_container, "modulate:a", 0.0, slide_time)
	await tween.finished
	sidebar_container.visible = false

func toggle_sidebar() -> void:
	AudioManager.play_click_sound()
	if sidebar_container.visible:
		animate_sidebar_close()
	else:
		animate_sidebar_open()


func _on_exit_pressed() -> void:
	AudioManager.play_click_sound()
	await animate_sidebar_close()
	get_node("QuitConfirmation").show()
	#await get_tree().create_timer(0.2).timeout
	# Exit the application
	#get_tree().quit()
