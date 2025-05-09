extends Button

# variable for UI Screen
var currentUI
var nextUI

# switch to Kingdom Scene NOTE: will be changed to Kingdom UI
func kingdomUI():
	# get player in custom scene
	var player = get_tree().current_scene.get_node("Node3D/Player")
	# set mesh data
	player.apply_customization()

	# change scenes
	var result = get_tree().change_scene_to_file("res://Scenes/Worlds/Spawn.tscn")
	if result != OK:
		print("Error changing scene: " + str(result))
	else:
		print("Scene change successful")
