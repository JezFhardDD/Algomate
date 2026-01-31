extends Panel

# Allow the label text to be changed easily
func set_value(new_value):
	$Label.text = str(new_value)

func get_value():
	return int($Label.text)

# VISUAL FUNCTIONS FOR DFS
func mark_processing():
	# Turn Orange/Yellow when the algorithm is checking this node
	var style = get_theme_stylebox("panel").duplicate()
	style.bg_color = Color(1, 0.65, 0) # Orange
	add_theme_stylebox_override("panel", style)

func mark_visited():
	# Turn Dark Gray/Blue when we are done with this node
	var style = get_theme_stylebox("panel").duplicate()
	style.bg_color = Color(0.3, 0.3, 0.3) # Dark Gray
	add_theme_stylebox_override("panel", style)

func mark_found():
	# Turn Green when this is the target
	var style = get_theme_stylebox("panel").duplicate()
	style.bg_color = Color(0, 0.8, 0) # Green
	add_theme_stylebox_override("panel", style)

func reset_color():
	# Reset to original color (Red/Brown)
	var style = get_theme_stylebox("panel").duplicate()
	style.bg_color = Color(0.6, 0.2, 0.2) # Original Red
	add_theme_stylebox_override("panel", style)
