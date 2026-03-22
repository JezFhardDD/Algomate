extends TextureRect

# --- Adjustable parameters ---
@export var float_speed: float = 1.0
@export var float_height: float = 8.0
@export var float_rotation: float = 5.0

# --- Internal state ---
var seed: float
var start_pos: Vector2
var time_accum: float = 0.0

func _ready():
	start_pos = position
	seed = randf() * 2.0 * PI
	_update_overall_progress()

func _process(delta):
	time_accum += delta
	position.y = start_pos.y + sin(time_accum * float_speed + seed) * float_height
	rotation_degrees = sin(time_accum * float_speed * 0.7 + seed) * float_rotation

func _update_overall_progress():
	var progress_bar = get_node_or_null("ProgressBar")
	if not progress_bar:
		return

	var all_progress: Array = DB.get_all_progress()
	if all_progress.is_empty():
		return

	# Count total completable levels (exclude skipped topics)
	var skipped = ["tree", "binary_tree", "binary_search_tree", "graph", "graph_tree_search"]
	var total = 0
	var completed = 0

	for row in all_progress:
		if row["topic"] in skipped:
			continue
		total += 1
		if row["has_completed"] == 1:
			completed += 1

	if total > 0:
		var pct = float(completed) / float(total)
		progress_bar.max_value = 1.0
		progress_bar.value = pct
		print("[Overall] %d/%d completed (%.0f%%)" % [completed, total, pct * 100])

	# Also update the OVERALL label if it exists
	var label = get_node_or_null("OVERALL")
	if label:
		var skipped_topics = skipped
		var total_l = 0
		var completed_l = 0
		for row in all_progress:
			if row["topic"] in skipped_topics:
				continue
			total_l += 1
			if row["has_completed"] == 1:
				completed_l += 1
		label.text = "OVERALL: %d/%d COMPLETED" % [completed_l, total_l]
