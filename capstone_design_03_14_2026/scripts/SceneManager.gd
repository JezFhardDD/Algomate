extends Node

var scene_stack: Array[String] = []

func change_scene(scene_path: String):
	# Add current scene to stack before changing
	if get_tree().current_scene and get_tree().current_scene.scene_file_path:
		scene_stack.append(get_tree().current_scene.scene_file_path)
		print("Added to stack: ", get_tree().current_scene.scene_file_path)
	
	print("Changing to: ", scene_path)
	print("Current stack: ", scene_stack)
	get_tree().change_scene_to_file(scene_path)

func go_back():
	if scene_stack.size() > 0:
		var previous_scene = scene_stack.pop_back()
		print("Going back to: ", previous_scene)
		print("Stack now: ", scene_stack)
		get_tree().change_scene_to_file(previous_scene)
	else:
		# If stack is empty, go to main menu
		print("Stack empty, going to homepage")
		get_tree().change_scene_to_file("res://scenes/homepage.tscn")

func clear_stack():
	scene_stack.clear()
	print("Stack cleared")
