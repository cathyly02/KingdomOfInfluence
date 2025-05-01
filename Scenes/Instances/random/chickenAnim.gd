extends Node3D

@onready var anim = $AnimationPlayer
var last_position = Vector3.ZERO

func _ready():
	last_position = global_position

func _process(delta):
	var current_xz = Vector2(global_position.x, global_position.z)
	var last_xz = Vector2(last_position.x, last_position.z)

	if current_xz != last_xz:
		anim.play("walking")

	last_position = global_position
