extends Node

var scene_stack: Array[String] = []
var is_transitioning: bool = false

func _ready():
	if OS.get_name() == "Android":
		get_tree().set_auto_accept_quit(false)
		print("Auto quit disabled")

func change_scene(scene_path: String):
	if get_tree().current_scene and get_tree().current_scene.scene_file_path != "":
		scene_stack.append(get_tree().current_scene.scene_file_path)
		print("Added to stack: ", get_tree().current_scene.scene_file_path)
	print("Changing to: ", scene_path)
	print("Current stack: ", scene_stack)
	get_tree().change_scene_to_file(scene_path)

func go_back() -> void:
	if is_transitioning:
		return
	if scene_stack.size() > 0:
		is_transitioning = true
		var previous_scene = scene_stack.pop_back()
		print("Going back to: ", previous_scene)
		get_tree().change_scene_to_file(previous_scene)
		await get_tree().process_frame
		is_transitioning = false
	else:
		pass


func clear_stack():
	scene_stack.clear()
	print("Stack cleared")

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		print("WM_GO_BACK intercepted by SceneManager, stack: ", scene_stack)
		go_back()
