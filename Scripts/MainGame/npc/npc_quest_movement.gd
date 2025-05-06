extends CharacterBody3D

@export var move_speed : float = 0.5
@export var rotation_speed = 3.0
@export var target_pos_forgiveness : float = 0.2
@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var animator = $AnimationPlayer
@onready var player = get_node_or_null("/root/world/PlayerMovement/Player")

var target_position : Vector3
#var is_stopped : bool = false
var quest_delta : float = 0.0
var currently_moving : bool = false
var ready_for_next_direction : bool = true


func _ready():
	animator.play("playerAnimPack/idle")
	rotation.y = 45

func _process(delta):
	quest_delta = delta
	if currently_moving:
		animator.play("playerAnimPack2/walk")
		rotate_towards(target_position, delta)
		move_and_slide()
		if global_position.distance_to(target_position) < target_pos_forgiveness:
			currently_moving = false
			ready_for_next_direction = true
			set_velocity(Vector3.ZERO)
	else:
		animator.play("playerAnimPack/idle")
		set_velocity(Vector3.ZERO)
		
#checks if player is in front of npc
func player_is_in_front()-> bool:
	var to_player = (player.global_position - global_position).normalized()
	var forward = -transform.basis.z.normalized()
	var angle = forward.angle_to(to_player)
	var max_angle = deg_to_rad(55)  
	var distance = global_position.distance_to(player.global_position)
	return angle < max_angle and distance < 4.0 

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0  # Reset vertical speed when on the floor

func rotate_towards(direction: Vector3, delta: float) -> void:
	# Only rotate if there is movement
	if direction.length() > 0:
		# Calculate the target rotation using atan2
		var target_rotation = atan2(-direction.x, -direction.z)

		# Smoothly rotate using lerp_angle to avoid snapping
		rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)

func move_to_position(destination: Vector3) -> void:
	ready_for_next_direction = false
	var direction = (destination - global_position).normalized()
	
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed
	
	# start moving
	target_position = destination
	currently_moving = true
	
	
