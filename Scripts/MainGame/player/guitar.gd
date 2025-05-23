extends Node3D

@onready var animator = get_node("/root/world/PlayerMovement/Player/AnimationPlayer")
@onready var player = get_node("/root/world/PlayerMovement/Player")
@export var Am: Array[AudioStream]
@export var C: Array[AudioStream]
@export var G: Array[AudioStream]
@export var model_scene : PackedScene  # Reference to the model's scene
var guitar
var spawned_model : Node3D = null

func _process(delta):
	var sound = $AudioStreamPlayer
	var note: Array[AudioStream] = []

	# Check which chord is pressed
	if Input.is_action_pressed("Am"):
		note = Am

	elif Input.is_action_pressed("C"):
		note = C

	elif Input.is_action_pressed("G"):
		note = G
		print("G is pressed")


		# Check if a model exists and the chord is not pressed anymore, delete the model
	if (Input.is_action_pressed("Am") or Input.is_action_pressed("C") or Input.is_action_pressed("G")) and not spawned_model:
		spawn_model()
	# Check if a model exists and the chord is not pressed anymore, delete the model
	if not (Input.is_action_pressed("Am") or Input.is_action_pressed("C") or Input.is_action_pressed("G")) and spawned_model:
		delete_model()
		

	# Check for strumming action
	if note.size() > 0 and Input.is_action_just_pressed("DownStrum"):
		print("Down strum is pressed")
		sound.stream = note[0]
		sound.play()

	elif note.size() > 1 and Input.is_action_just_pressed("UpStrum"):
		print("Up strum is pressed")
		sound.stream = note[1]
		sound.play()
	if sound.playing and spawned_model:
		animator.play("playerAnimPack2/guitar")
		$/root/world/PlayerMovement/Player/GuitarA/AnimationPlayer.play("Guitar1Action")
	elif spawned_model and !sound.playing and animator.is_playing() and animator.current_animation == "playerAnimPack2/guitar":
		animator.stop("playerAnimPack2/guitar")
		

func spawn_model():
	# Instance the model from the packed scene
	spawned_model = model_scene.instantiate()

	# Add the model to the current scene (e.g., adding it as a child of the current node)
	player.add_child(spawned_model)
	guitar = $/root/world/PlayerMovement/Player/GuitarA
	print(spawned_model.get_path())

func delete_model():
	# Check if spawned_model exists before trying to free it
	

	if guitar:
		# remove instance of wheat
		guitar.queue_free()  # Delete it safely
