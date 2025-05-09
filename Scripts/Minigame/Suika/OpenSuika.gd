extends Node3D

var interactable = true

func interact():
	print("interacting")
	get_tree().change_scene_to_file("res://Scenes/Minigames/suika.tscn")
