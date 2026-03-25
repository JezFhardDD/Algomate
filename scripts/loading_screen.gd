extends Control

@onready var spinner = $Sprite2D
@onready var progress_bar = $ProgressBar
@onready var blocks = $Blocks.get_children()

var original_positions = {}
var target_scene_path: String = ""
var progress = [] 
var min_load_time: float = 2.0
var time_elapsed: float = 0.0
var loading_started: bool = false
var new_scene_ready: PackedScene = null

func _ready():
	# Make sure loading screen is on top
	z_index = 1000
	
	target_scene_path = Global.next_scene_path
	
	if target_scene_path == "":
		visible = false
		SceneManager.go_back()
		return
	
	for block in blocks:
		original_positions[block] = block.position
		
	await play_close()
	
	# Change to landscape
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	
	# Wait for orientation to actually change
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Double-check orientation is landscape before showing spinner
	var is_landscape = get_viewport_rect().size.x > get_viewport_rect().size.y
	
	# Adjust screen size
	var current_size = get_viewport().get_visible_rect().size
	if current_size.y > current_size.x:
		get_tree().root.content_scale_size = Vector2i(int(current_size.y), int(current_size.x))
	
	# ONLY show spinner if in landscape
	if is_landscape:
		spinner.visible = true
		progress_bar.visible = true
		start_beating_animation()
	else:
		# If still not landscape, wait one more frame
		await get_tree().process_frame
		spinner.visible = true
		progress_bar.visible = true
		start_beating_animation()
	
	# Start loading
	ResourceLoader.load_threaded_request(target_scene_path)
	loading_started = true
	
	set_process(true)

func start_beating_animation():
	var tween = create_tween().set_loops()
	tween.tween_property(spinner, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(spinner, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(0.4)

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
				
				# Store the loaded scene
				new_scene_ready = ResourceLoader.load_threaded_get(target_scene_path)
				
				get_tree().change_scene_to_packed(new_scene_ready)
				# Play open animation first
				await play_open()
				
				queue_free()
				
			
		ResourceLoader.THREAD_LOAD_FAILED:
			print("❌ ERROR: Failed to load scene: ", target_scene_path)
			loading_started = false
			set_process(false)
			
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			print("⚠️ ERROR: Invalid resource: ", target_scene_path)
			loading_started = false
			set_process(false)
			
			
func start_loading(scene_path: String):
	target_scene_path = scene_path
	visible = true
	z_index = 1000
	
	for block in blocks:
		original_positions[block] = block.position
		
	await play_close()
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	await get_tree().process_frame
	await get_tree().process_frame
	var current_size = get_viewport().get_visible_rect().size
	if current_size.y > current_size.x:
		get_tree().root.content_scale_size = Vector2i(int(current_size.y), int(current_size.x))
	
	start_beating_animation()
	
	ResourceLoader.load_threaded_request(target_scene_path)
	loading_started = true
	
	set_process(true)
	
	
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

		tween.tween_property(
			block, "position", final_pos, 0.5
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

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

		tween.tween_property(
			block, "position", target_pos, 0.5
		).set_delay(randf() * 0.1) \
		 .set_trans(Tween.TRANS_CUBIC) \
		 .set_ease(Tween.EASE_IN_OUT)

	await tween.finished
