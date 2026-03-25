extends Control

@onready var spinner = $Sprite2D
@onready var progress_bar = $ProgressBar
@onready var blocks = $Blocks.get_children()
@onready var color_rect = $ColorRect

var original_positions = {}
var target_scene_path: String = ""
var progress = []
var min_load_time: float = 2.0
var time_elapsed: float = 0.0
var loading_started: bool = false
var new_scene_ready: PackedScene = null
var stay_portrait: bool = false

signal loading_complete

func _ready():
	z_index = 1000
	visible = false
	for block in blocks:
		original_positions[block] = block.position

func start_beating_animation():
	var tween = create_tween().set_loops()
	tween.tween_property(spinner, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(spinner, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(0.4)

func start_loading(scene_path: String):
	target_scene_path = scene_path
	visible = true
	z_index = 1000

	# Show solid background IMMEDIATELY so simulation elements are hidden
	# before the block animation even starts
	color_rect.visible = true

	for block in blocks:
		original_positions[block] = block.position

	await play_close()

	if not stay_portrait:
		DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
		await get_tree().process_frame
		await get_tree().process_frame
		var current_size = get_viewport().get_visible_rect().size
		if current_size.y > current_size.x:
			get_tree().root.content_scale_size = Vector2i(int(current_size.y), int(current_size.x))
	
	# Only reposition logo in portrait mode
	if stay_portrait:
		var vp_size = get_viewport().get_visible_rect().size
		spinner.position.x = vp_size.x / 2.0

	spinner.visible = true
	progress_bar.visible = true
	start_beating_animation()

	ResourceLoader.load_threaded_request(target_scene_path)
	loading_started = true
	set_process(true)

func _process(delta):
	if not loading_started or target_scene_path == "":
		return

	time_elapsed += delta

	var load_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)

	if progress.size() > 0:
		var real_progress = progress[0] * 100.0
		var fake_timer_progress = (time_elapsed / min_load_time) * 100.0
		progress_bar.value = clamp(real_progress, 0, fake_timer_progress)

	match load_status:
		ResourceLoader.THREAD_LOAD_LOADED:
			if time_elapsed >= min_load_time:
				loading_started = false
				set_process(false)
				new_scene_ready = ResourceLoader.load_threaded_get(target_scene_path)
				get_tree().change_scene_to_packed(new_scene_ready)
				await play_open()
				loading_complete.emit()
				queue_free()

		ResourceLoader.THREAD_LOAD_FAILED:
			print("❌ ERROR: Failed to load scene: ", target_scene_path)
			loading_started = false
			set_process(false)

		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			print("⚠️ ERROR: Invalid resource: ", target_scene_path)
			loading_started = false
			set_process(false)

func play_close():
	var tween = create_tween()
	tween.set_parallel(true)
	var screen_width = get_viewport_rect().size.x
	for block in blocks:
		var final_pos = original_positions[block]
		if final_pos.x < screen_width / 2:
			block.position.x = -200
		else:
			block.position.x = screen_width + 200
		tween.tween_property(block, "position", final_pos, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func play_open():
	var tween = create_tween()
	tween.set_parallel(true)
	var screen_width = get_viewport_rect().size.x
	for block in blocks:
		var final_pos = original_positions[block]
		var target_pos = final_pos
		if final_pos.x < screen_width / 2:
			target_pos.x = -block.size.x
		else:
			target_pos.x = screen_width + block.size.x
		tween.tween_property(block, "position", target_pos, 0.5).set_delay(randf() * 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
