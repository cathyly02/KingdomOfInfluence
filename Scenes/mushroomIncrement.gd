extends Node3D

@onready var count = get_node("/root/world/Farmer/CharacterBody3D/Farmer/Quest")
@onready var parent = get_parent()


var was_active = false

func _process(delta: float) -> void:
	var is_active = !parent.interactable
	if is_active and !was_active:
		print("Changed from false to true!")
		# Do something ONCE when the change happens
		count.updateQuest()
	was_active = is_active  # Update previous value at end
