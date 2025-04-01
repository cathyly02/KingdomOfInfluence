extends Control

func _on_start_button_pressed() -> void:
	print("Button pressed, attempting to change scene")
	var result = get_tree().change_scene_to_file("res://Scenes/ChangeSkin.tscn")
	if result != OK:
		print("Error changing scene: " + str(result))
	else:
		print("Scene change successful")
