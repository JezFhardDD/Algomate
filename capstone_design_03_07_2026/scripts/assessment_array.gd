extends TextureButton

# --- Adjustable parameters ---
@export var float_speed: float = 1.0      # Speed of bobbing
@export var float_height: float = 8.0     # Vertical movement in pixels
@export var float_rotation: float = 5.0   # Max rotation in degrees

# --- Internal state ---
var seed: float
var start_pos: Vector2
var time_accum: float = 0.0

func _ready():
	# Store initial position
	start_pos = position
	# Randomize phase so multiple buttons float differently
	seed = randf() * 2.0 * PI

func _process(delta):
	# Accumulate time
	time_accum += delta

	# Move up/down
	position.y = start_pos.y + sin(time_accum * float_speed + seed) * float_height
	# Slight rotation
	rotation_degrees = sin(time_accum * float_speed * 0.7 + seed) * float_rotation
