extends CharacterBody3D


# variables for player details
@onready var npc = get_node("/root/world/TheDrunk/DrunkardNPC") # path to the node

var SPEED = 0
const JUMP_VELOCITY = 4.5
@export var turn = 10
@export var jumpImpulse = 10
@onready var camH= $"../CameraOrigin/Horizontal"
@onready var camV= $"../CameraOrigin/Horizontal/Vertical"
@onready var springArm= $"../CameraOrigin/Horizontal/Vertical/SpringArm3D"
@onready var camOrigin = $"../CameraOrigin"
var running := true
var jumping := true
var mouse_captured := true
# gravity woahhh
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var action = false

#skin mesh testures
@export var skins: Array[Texture2D]

func _ready():
	# set mesh
	var mesh = $GeneralSkeleton/characterMedium
	# get player data
	var data = PlayerData.get_customization()
	# set skin from player data NOTE: I want to change this later
	var skin = data["skin"]
	var material = StandardMaterial3D.new()
	material.albedo_texture = skins[skin]

	# Apply the new material to the mesh
	mesh.material_override = material
	capture_mouse()
	
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
func capture_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func release_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _process(delta):
	# Sync the parent Node3D to the character's global position
	camOrigin.global_position = Vector3(global_position.x,global_position.y + 1.5, global_position.z)
	
	# Declare the variable FIRST before any conditional blocks
	'''var rotationOverride = false
	
	# Then check conditions and modify it if needed
	if npc and npc.has_method("get") and npc.get("rotationOverride") != null:
		rotationOverride = npc.rotationOverride
	
	# Now use the variable in the next conditional
	if springArm.spring_length <= 0 and not rotationOverride:
		var camera_yaw = camH.rotation.y
		rotation.y = (135 + camera_yaw)
		'''

	
func _physics_process(delta):
	var sound = get_node("/root/world/Guitar/AudioStreamPlayer")
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction
	var input_dir
	if !action:
		input_dir = Input.get_vector("left", "right", "up", "down")
		direction = (camH.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		$AnimationPlayer.play("playerAnimPack/jump")
	else:	
		if input_dir:
			# check for sprint
			if Input.is_action_just_pressed("sprint") || SPEED == 7:
				SPEED = 7
				$AnimationPlayer.play("playerAnimPack/run")
			else:
				$AnimationPlayer.play("playerAnimPack2/walk")
		elif !sound.playing and $AnimationPlayer.current_animation != "playerAnimPack2/pickingFruit":
			$AnimationPlayer.play("playerAnimPack/idle")
			SPEED = 3

	if direction:
		velocity.x = direction.x * SPEED 
		velocity.z = direction.z * SPEED 
		
		# body follows wasd in 3rd pov
		if (springArm.spring_length > 0):
			rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), turn * delta)

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("mouseToggle"):
		if mouse_captured:
			release_mouse()
		else:
			capture_mouse()
		mouse_captured = !mouse_captured  # Flip the state

	move_and_slide()
	var v = Vector3(0, 0, 0)
