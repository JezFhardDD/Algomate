extends Node

var scene_stack: Array[String] = []

func change_scene(scene_path: String):
	if get_tree().current_scene and get_tree().current_scene.scene_file_path:
		scene_stack.append(get_tree().current_scene.scene_file_path)
		print("Added to stack: ", get_tree().current_scene.scene_file_path)
	
	print("Changing to: ", scene_path)
	print("Current stack: ", scene_stack)
	get_tree().change_scene_to_file(scene_path)

func go_back() -> void:
	if scene_stack.size() > 0:
		var previous_scene = scene_stack.pop_back()
		print("Going back to: ", previous_scene)
		get_tree().change_scene_to_file(previous_scene)
	else:
		# Nothing left in stack — send app to background on Android
		if OS.get_name() == "Android":
			OS.shell_open("package:com.android.launcher")
		else:
			get_tree().quit()

func clear_stack():
	scene_stack.clear()
	print("Stack cleared")

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		go_back()
