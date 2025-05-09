extends Node3D

@export var object_scenes: Array[PackedScene] = [] # Correct array declaration
@export var npcSkins: Array[Texture2D] = []
@export var number_of_objects := 50
@export var world_size := Vector3(40, 0, 40) # Width (x), Height (ignored here), Depth (z)
@export var spawn_height := 1 # Y position where objects spawn (e.g., ground level)

func _ready():
	randomize()
	
	# initialize variables here to save time and memory
	var scene_index
	var packed_scene
	var instance
	var x
	var z
	var mesh
	var material

	if object_scenes.is_empty():
		push_error("No object scenes assigned!")
		return

	for i in number_of_objects:
		scene_index = randi() % object_scenes.size()
		packed_scene = object_scenes[scene_index]
		
		instance = packed_scene.instantiate()
		add_child(instance)  # ✔Now it's inside the scene tree
		
		#print(scene_index, instance.name)
		# check if instance is npc
		if ("Node3D" in instance.name):
			mesh = instance.get_node("CharacterBody3D/GeneralSkeleton/characterMedium")
			
			material = mesh.get_active_material(0).duplicate()
			mesh.set_surface_override_material(0, material)
			
			material.albedo_texture = npcSkins[randi() % npcSkins.size()]
		
		# Make a new one every time
		x = randf_range(-world_size.x / 2, world_size.x / 2)
		z = randf_range(-world_size.z / 2, world_size.z / 2)
		instance.global_position = global_position + Vector3(x, spawn_height, z)
