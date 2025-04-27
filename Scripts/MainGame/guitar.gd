extends Node3D

@onready var animator = get_node("/root/world/PlayerMovement/Player/AnimationPlayer")
@export var Am: Array[AudioStream] 
@export var C: Array[AudioStream]
@export var G: Array[AudioStream]

func _process(delta):
	var sound = $AudioStreamPlayer
	var note: Array[AudioStream] = []

	# Check which chord is pressed
	if Input.is_action_pressed("Am"):
		note = Am
		print("A is pressed")
	elif Input.is_action_pressed("C"):
		note = C
		print("C is pressed")
	elif Input.is_action_pressed("G"):
		note = G
		print("G is pressed")

	# Check for strumming action
	if note.size() > 0 and Input.is_action_just_pressed("DownStrum"):
		print("Down strum is pressed")
		sound.stream = note[0]
		animator.play("playerAnimPack2/guitar")
		sound.play()

	elif note.size() > 1 and Input.is_action_just_pressed("UpStrum"):
		print("Up strum is pressed")
		sound.stream = note[1]
		animator.play("playerAnimPack2/guitar")
		sound.play()
