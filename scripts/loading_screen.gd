extends Control

@onready var spinner = $Sprite2D
@onready var progress_bar = $ProgressBar

var target_scene_path: String = ""
var progress = [] 

var min_load_time: float = 2
var time_elapsed: float = 0.0

func _ready():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	await get_tree().process_frame
	await get_tree().process_frame
	var current_size = get_viewport().get_visible_rect().size
	if current_size.y > current_size.x:
		get_tree().root.content_scale_size = Vector2i(int(current_size.y), int(current_size.x))
	
	start_beating_animation()
	
	target_scene_path = Global.next_scene_path
	if target_scene_path != "":
		ResourceLoader.load_threaded_request(target_scene_path)

func start_beating_animation():
	var tween = create_tween().set_loops()
	tween.tween_property(spinner, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(spinner, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(0.2)

func _process(delta):
	if target_scene_path == "":
		return
		
	time_elapsed += delta
		
	var load_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	
	if progress.size() > 0:
		var real_progress = progress[0] * 100.0
		var fake_timer_progress = (time_elapsed / min_load_time) * 100.0
		progress_bar.value = min(real_progress, fake_timer_progress)
	
	match load_status:
		ResourceLoader.THREAD_LOAD_LOADED:
			if time_elapsed >= min_load_time:
				set_process(false) 
				var new_scene = ResourceLoader.load_threaded_get(target_scene_path)
				get_tree().change_scene_to_packed(new_scene)
			
		ResourceLoader.THREAD_LOAD_FAILED:
			print("❌ ERROR: Failed to load scene! Check this path: ", target_scene_path)
			set_process(false)
			
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			print("⚠️ ERROR: Invalid resource! The path might be misspelled: ", target_scene_path)
			set_process(false)
