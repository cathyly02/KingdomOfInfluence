extends CharacterBody3D

@export var wander_speed = 2.0
@export var flee_speed = 5.0
@export var detect_radius = 10.0
@export var wander_time = 2.0
@export var gravity = 9.8
@export var rotation_speed = 3.0  # Adjust the rotation speed

@onready var player = get_node("/root/world/PlayerMovement/Player")  # Adjust path if needed

var wander_direction = Vector3.ZERO
var wander_timer = 0.0

func _physics_process(delta):
	var to_player = player.global_position - global_position
	var distance_to_player = to_player.length()

	# Apply gravity first
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0  # Reset vertical speed when on the floor

	if distance_to_player < detect_radius and player.SPEED == 7:
		# Flee from player
		var flee_direction = -to_player.normalized()
		velocity.x = flee_direction.x * flee_speed
		velocity.z = flee_direction.z * flee_speed
		# Rotate towards flee direction
		rotate_towards(flee_direction, delta)
	else:
		# Wander randomly
		wander_timer -= delta
		if wander_timer <= 0:
			if randi() % 6 + 1 == 1:
				wander_timer = wander_time
				wander_direction = Vector3(
					randf() * 2 - 1,
					0,
					randf() * 2 - 1
				).normalized()

		velocity.x = wander_direction.x * wander_speed
		velocity.z = wander_direction.z * wander_speed
		# Rotate towards wander direction
		rotate_towards(wander_direction, delta)

	# Move the animal
	move_and_slide()

		

# Function to rotate the animal smoothly towards a given direction using atan2
func rotate_towards(direction: Vector3, delta: float) -> void:
	# Only rotate if there is movement
	if direction.length() > 0:
		# Calculate the target rotation using atan2
		var target_rotation = atan2(direction.x, direction.z)

		# Smoothly rotate using lerp_angle to avoid snapping
		rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)
