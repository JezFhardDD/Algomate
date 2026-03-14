extends Control

# =========================
# REFERENCES
# =========================
@onready var grid_container = $GridContainer
@onready var back_button = $BackButton

# =========================
# READY
# =========================
func _ready():
	print("=== SHOP READY ===")
	
	# Connect to Global signals
	if Global.has_signal("purchases_updated"):
		Global.purchases_updated.connect(refresh_shop)
		print("Connected to purchases_updated")
	if Global.has_signal("coins_updated"):
		# Just connect to the signal to refresh shop when coins change
		Global.coins_updated.connect(_on_coins_updated)
		print("Connected to coins_updated")
	
	# Connect back button
	if back_button:
		back_button.pressed.connect(_on_back_button_pressed)
	
	# Set up all shop items
	setup_shop_items()
	
	# Pixel art settings
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

# Called when coins are updated (sidebar will handle display)
func _on_coins_updated(amount: int):
	print("Coins updated in shop: ", amount)
	# No need to update display here - sidebar handles it
	# But we might want to refresh shop buttons if needed
	refresh_shop()

func setup_shop_items():
	print("Setting up shop items...")
	# Loop through all children of GridContainer (your panels)
	for panel in grid_container.get_children():
		if panel is Panel:
			setup_panel(panel)

func setup_panel(panel: Panel):
	# Find nodes inside your panel
	var picture = find_child_by_type(panel, TextureRect)
	var name_label = find_child_by_type(panel, Label)
	var price_label = find_child_by_type(panel, Label, "PriceLabel")
	var action_button = find_child_by_type(panel, TextureButton)
	
	if not picture or not name_label or not action_button:
		print("Panel missing required nodes!")
		return
	
	# Get picture data
	var picture_path = picture.texture.resource_path if picture.texture else ""
	var picture_name = name_label.text
	
	# Extract price from price label
	var price = 0
	if price_label:
		var price_text = price_label.text.strip_edges()
		print("Raw price text: '", price_text, "' for ", picture_name)
		
		var number_str = ""
		for char in price_text:
			if char.is_valid_int():
				number_str += char
		
		if number_str != "":
			price = int(number_str)
			print("Extracted price: ", price, " for ", picture_name)
	
	# Store data in the button
	action_button.set_meta("picture_path", picture_path)
	action_button.set_meta("picture_name", picture_name)
	action_button.set_meta("price", price)
	action_button.set_meta("panel", panel)
	action_button.set_meta("price_label", price_label)
	
	print("Stored price for ", picture_name, ": ", price)
	
	# Connect button
	action_button.pressed.connect(_on_action_button_pressed.bind(action_button))
	
	# Update button based on purchase status
	update_button_for_panel(panel, picture_path, action_button, price_label, price)

func find_child_by_type(parent: Node, type, name_hint: String = "") -> Node:
	for child in parent.get_children():
		if is_instance_of(child, type):
			if name_hint == "" or child.name == name_hint or child.name.to_lower().find("price") >= 0:
				return child
	return null

func update_button_for_panel(panel: Panel, picture_path: String, button: TextureButton, price_label: Label, price: int):
	# Remove any existing status labels
	for child in panel.get_children():
		if child is Label and child.name == "StatusLabel":
			child.queue_free()
	
	var is_purchased = Global.is_picture_purchased(picture_path) if picture_path else false
	var is_equipped = (Global.equipped_picture == picture_path)
	
	print("Updating panel - ", picture_path, " Purchased: ", is_purchased, " Equipped: ", is_equipped)
	
	if not is_purchased:
		# Not purchased - show BUY button
		button.texture_normal = preload("res://assets/ui/buy_button.png")
		button.visible = true
		if price_label:
			price_label.visible = true
			price_label.add_theme_color_override("font_color", Color.YELLOW)
		
	elif is_purchased and not is_equipped:
		# Purchased but not equipped - show SELECT button
		button.texture_normal = preload("res://assets/ui/select_button.png")
		button.visible = true
		if price_label:
			price_label.text = "OWNED"
			price_label.add_theme_color_override("font_color", Color.GREEN)
		
	elif is_equipped:
		# Currently equipped - hide button, show EQUIPPED label
		button.visible = false
		if price_label:
			price_label.text = "EQUIPPED"
			price_label.add_theme_color_override("font_color", Color.GREEN)
		
		var equipped_label = Label.new()
		equipped_label.name = "StatusLabel"
		equipped_label.text = "EQUIPPED"
		equipped_label.add_theme_color_override("font_color", Color.GREEN)
		equipped_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		equipped_label.position = button.position
		equipped_label.size = button.size
		panel.add_child(equipped_label)

func _on_action_button_pressed(button: TextureButton):
	# Get all metadata
	var picture_path = button.get_meta("picture_path")
	var picture_name = button.get_meta("picture_name")
	var price = button.get_meta("price")
	var panel = button.get_meta("panel")
	
	print("=== BUTTON PRESSED ===")
	print("Picture: ", picture_name)
	print("Price from metadata: ", price)
	print("Current coins: ", Global.get_coins())
	
	AudioManager.play_click_sound()
	
	var is_purchased = Global.is_picture_purchased(picture_path)
	print("Is purchased? ", is_purchased)
	
	if not is_purchased:
		# Try to buy with coins
		print("Attempting to buy for ", price, " coins")
		if price <= 0:
			print("WARNING: Price is 0 or invalid!")
			show_message("Invalid price!", Color.RED)
			return
			
		if Global.spend_coins(price):
			print("Purchase successful!")
			Global.purchase_picture(picture_path)
			show_message("Purchased: " + picture_name, Color.GREEN)
			# No need to update coin display - sidebar handles it via signal
		else:
			print("Not enough coins!")
			show_message("Not enough coins!", Color.RED)
	else:
		# Select the picture
		print("Equipping picture")
		Global.equip_picture(picture_path)
		show_message("Equipped: " + picture_name, Color.YELLOW)

func show_message(text: String, color: Color = Color.WHITE):
	var message = Label.new()
	message.text = text
	message.add_theme_color_override("font_color", color)
	message.add_theme_font_size_override("font_size", 20)
	message.position = Vector2(200, 400)
	message.size = Vector2(400, 50)
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(message)
	
	await get_tree().create_timer(1.5).timeout
	message.queue_free()

func refresh_shop():
	print("Refreshing shop...")
	setup_shop_items()

func _on_back_button_pressed():
	AudioManager.play_back_sound()
	SceneManager.go_back()
