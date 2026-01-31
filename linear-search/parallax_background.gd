extends ParallaxBackground

@export var scroll_speed := Vector2(50, 0)  # move speed (x = horizontal)

func _process(delta):
	scroll_offset += scroll_speed * delta
