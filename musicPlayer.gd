extends Node3D


func _on_midi_player_midi_event(channel: Variant, event: Variant) -> void:
	if channel.number == 1:
		if event.type == 144:
			print("yeye")
		#print(event.type)
