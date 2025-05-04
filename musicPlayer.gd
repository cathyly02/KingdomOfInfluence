extends Node3D


func _ready() -> void:
	randomize()

func _on_midi_player_midi_event(channel: Variant, event: Variant) -> void:
	if channel.number == 1:
		if event.type == 144:
			var noteNode = preload("res://Scenes/Instances/note.tscn")
			var note = noteNode.instantiate()
			var randNum = randi_range(-2,1)
			note.position = Vector3(-15, randNum * 4, 0)
			add_child(note)
			print("note")
			
				

		#print(event.type)
