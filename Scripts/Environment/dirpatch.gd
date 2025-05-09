extends Area3D

@export var stageA: Texture2D
@export var stageB: Texture2D




func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

# check if player is inside area
var inside = false
var bodyName

# check if player endered area
func _on_body_entered(body):
	bodyName = body.name
	print(body.name, " entered the area!")
	if (bodyName == "PlayerBody"):
		inside = true

# check if plauer exited bodyu
func _on_body_exited(body):
	print(body.name, " left the area!")
	if (bodyName == "PlayerBody"):
		inside = false
	
func _process(delta: float) -> void:
	# checks if inside body
	if inside:
		if Input.is_action_just_pressed("interact"):
			print("interacted")
			# if wheat is grown, remove wheatr
			if $wheat/stageB:
				removeCrop()
			else:
				# if no wheat, plant
				
				plantWheat()
			
func removeCrop():
	var wheat = $wheat/stageB  # Reference the node
	if wheat:
		# remove instance of wheat
		wheat.queue_free()  # Delete it safely



func plantWheat():
	var seed = preload("res://Assets/Models/Nature Kit/crops_wheatStageA.glb")  # Load the scene
	var wheat = seed.instantiate()  # Create an instance
	wheat.position = Vector3(0, 0, 0)  # Set position
	add_child(wheat)  # Add it to the scene tree
