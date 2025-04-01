extends Node3D


# variable fore player
@export var player: CharacterBody3D
# camera variables
@export var follow_speed = 5.0
@export var sensitivity = 5
var rotation_x = 0.0

func _ready():
	# Set up camera properties relatve to 
	$SpringArm3D/Camera3D.current = true
	$SpringArm3D.spring_length = 5.0
	$SpringArm3D.rotation_degrees = Vector3(-45, 0, 0)
	
func _process(delta):
	if player:
		# Follow the player smoothly 
		global_position = lerp(global_position, player.global_position, follow_speed * delta)
