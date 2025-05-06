extends Node3D

@onready var audio = get_node("/root/rhythm/Music Player/ADSR/Linked")
var timer = 0.0
var duration = 15
var played = false
func _process(delta: float) -> void:
	if timer > 0.0:
		timer -= delta
		if timer <= 0.0:
			delete_model()
			get_tree().change_scene_to_file("res://Scenes/TheKingdom.tscn")

func _ready():
	timer = duration

func delete_model():
	# Check if spawned_model exists before trying to free it
	
	var guitar = $/root/rhythm/RandomStuff/NoScriptPlayer/GuitarA
	if guitar:
		# remove instance of wheat
		
		guitar.queue_free()  # Delete it safely
