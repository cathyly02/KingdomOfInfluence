extends CharacterBody3D

@export var move_speed : float = 1.0
@export var random_move_interval : float = 3.0
@export var rotation_speed = 3.0
@export var min_move_interval : float = 5.0
@export var max_move_interval : float = 10.0
@export var stationary: bool
@export var interactable: bool
@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var navigation_agent = $NavigationAgent3D
@onready var animator = $AnimationPlayer
@onready var player = get_node_or_null("/root/world/PlayerMovement/Player")

var target_position : Vector3
var random_target_position : Vector3
var is_random_move : bool = false
var random_timer : float = 0.0
var is_stopped : bool = false
var quest_movement : bool = false
var quest_delta = 0

func _ready():
	set_random_target_position()
	random_timer = random_move_interval
	animator.play("playerAnimPack/idle")

func _process(delta):
	#skips all animations if player is interacting with npc
	if is_stopped:
		if not player_is_in_front():
			is_stopped = false
		#otherwise player is still there
		return
	
	if (!stationary):
		if is_random_move:
			move_randomly(delta)
			animator.play("playerAnimPack2/walk")
		else:
			follow_path(delta)

		random_timer -= delta
		if random_timer <= 0:
			switch_movement_mode()
	elif (quest_movement):
		quest_delta = delta
		
#checks if player is in front of npc
func player_is_in_front()-> bool:
	var to_player = (player.global_position - global_position).normalized()
	var forward = -transform.basis.z.normalized()

	var angle = forward.angle_to(to_player)
	var max_angle = deg_to_rad(55)  

	var distance = global_position.distance_to(player.global_position)

	return angle < max_angle and distance < 4.0 


#makes npc stop when interacting with player
func _input(event):
	if event.is_action_pressed("interact") and player_is_in_front():
		is_stopped = true
		animator.play("playerAnimPack/idle")
	elif event.is_action_pressed("End Dialog") and player_is_in_front():
		is_stopped = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0  # Reset vertical speed when on the floor
func follow_path(delta):
	if navigation_agent.is_navigation_finished():
		if target_position == Vector3.ZERO:
			set_random_target_position()
			navigation_agent.target_position = target_position
		rotate_towards(target_position, delta)
	else:
		var direction = (navigation_agent.get_next_path_position() - global_position).normalized()
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		# DO NOT touch velocity.y here; let gravity handle it
		rotate_towards(direction, delta)
		move_and_slide()

func move_randomly(delta):
	var direction = (random_target_position - global_position).normalized()
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed
	# DO NOT touch velocity.y
	rotate_towards(direction, delta)
	move_and_slide()

	if global_position.distance_to(random_target_position) < 1.0:
		set_random_target_position()

func set_random_target_position():
	random_target_position = global_position + Vector3(randf_range(-5, 5), 0, randf_range(-5, 5))

func switch_movement_mode():
	is_random_move = !is_random_move
	if is_random_move:
		random_timer = randf_range(min_move_interval, max_move_interval)
	else:
		set_random_target_position()
		navigation_agent.target_position = random_target_position
		
func rotate_towards(direction: Vector3, delta: float) -> void:
	# Only rotate if there is movement
	if direction.length() > 0:
		# Calculate the target rotation using atan2
		var target_rotation = atan2(-direction.x, -direction.z)

		# Smoothly rotate using lerp_angle to avoid snapping
		rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)
