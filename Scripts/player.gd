extends CharacterBody3D

# camera origin
@export var camera_origin: Node3D  

# variables for player details
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
# gravity woahhh
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#skin mesh testures
@export var skins: Array[Texture2D]


func _ready():
	# set mesh
	var mesh = $Skeleton3D/characterMedium
	# get player data
	var data = PlayerData.get_customization()
	# set skin from player data NOTE: I want to change this later
	var skin = data["skin"]
	var material = StandardMaterial3D.new()
	material.albedo_texture = skins[skin]

	# Apply the new material to the mesh
	mesh.material_override = material
	
	
func _physics_process(delta):
	# check if not on floor
	if not is_on_floor():
		# falling gravity
		velocity.y -= gravity * delta

	# input for jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input direction
	var input_dir = Input.get_vector("left", "right", "up", "down")

	# Get camera basis for movement
	if camera_origin:
		# transform details of camera
		var camera_basis = camera_origin.global_transform.basis
		# direction addition ew
		var direction = (camera_basis.z * input_dir.y + camera_basis.x * input_dir.x)
		direction.y = 0  # Keep movement on the horizontal plane
		direction = direction.normalized()

		if direction:
			# movement
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED

			# Rotate character to face movement direction
			var target_rotation = atan2(direction.x, direction.z)
			rotation.y = lerp_angle(rotation.y, target_rotation, 10 * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
 
		# fix camera
		camera_origin.global_position = global_position
		camera_origin.rotation = Vector3.ZERO
