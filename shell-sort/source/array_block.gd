extends Control

@onready var bg = $Bg
@onready var label = $NumberLabel

# Make sure these paths actually point to your images!
const TEXTURE_POOL = [
	preload("res://assets/BLOCK_ORANGE.png"),
	preload("res://assets/BLOCK_GREEN.png"),
	preload("res://assets/BLOCK_PURPLE.png"),
	preload("res://assets/BLOCK_RED.png")
]

@export var value: int = 0:
	set(v):
		value = v
		if is_node_ready():
			label.text = str(value)

func _ready() -> void:
	# Set a minimum size so the HBoxContainer knows how much space to give it
	custom_minimum_size = Vector2(60, 60) 
	
	if TEXTURE_POOL.size() > 0 and TEXTURE_POOL[0] != null:
		bg.texture = TEXTURE_POOL.pick_random()
		
	label.text = str(value)

func set_status(status: String) -> void:
	# Reset to default state first
	modulate = Color.WHITE
	scale = Vector2(1.0, 1.0)
	z_index = 0
	
	match status:
		"default":
			pass # Keeps the white modulation
		"low":
			modulate = Color.CORNFLOWER_BLUE 
			scale = Vector2(1.1, 1.1)
		"high":
			modulate = Color.INDIAN_RED 
			scale = Vector2(1.1, 1.1)
		"probe":
			modulate = Color.GOLD 
			scale = Vector2(1.2, 1.2)
			z_index = 5
		"found":
			modulate = Color.GREEN 
			scale = Vector2(1.2, 1.2)
			z_index = 5
		"inactive":
			modulate = Color(0.4, 0.4, 0.4, 1.0) # Dims out-of-bounds blocks
