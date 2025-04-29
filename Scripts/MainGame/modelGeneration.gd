extends Node3D

@export var object_scenes: Array[PackedScene] = [] # Correct array declaration
@export var number_of_objects := 50
@export var world_size := Vector3(40, 0, 40) # Width (x), Height (ignored here), Depth (z)
@export var spawn_height := 1 # Y position where objects spawn (e.g., ground level)

func _ready():
	randomize()

	if object_scenes.is_empty():
		push_error("No object scenes assigned!")
		return

	for i in number_of_objects:
		var scene_index = randi() % object_scenes.size()
		var packed_scene = object_scenes[scene_index]
		
		var instance = packed_scene.instantiate()
		add_child(instance)  # ✔Now it's inside the scene tree
 # Make a new one every time
		var x = randf_range(-world_size.x / 2, world_size.x / 2)
		var z = randf_range(-world_size.z / 2, world_size.z / 2)
		instance.global_position = Vector3(x, spawn_height, z)
