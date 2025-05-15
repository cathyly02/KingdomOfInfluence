extends Control

func _on_start_button_pressed() -> void:
	print("Button pressed, attempting to change scene")
	var result = get_tree().change_scene_to_file("res://Scenes/UI Scenes/ChangeSkin.tscn")
	if result != OK:
		print("Error changing scene: " + str(result))
	else:
		print("Scene change successful")


func _on_settings_button_pressed() -> void:
	#TODO: implement settings stuff
	print("settings button pressed")


func _on_quit_button_pressed() -> void:
	# ends the game
	get_tree().quit()
