extends Area3D

@onready var player = get_node_or_null("/root/world/PlayerMovement/Player")

var player_in_cylinder = false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if (body == player):
		player_in_cylinder = true
		print("player in cylninder")
		
func _on_body_exited(body):
	if (body == player):
		player_in_cylinder = false
		print("player left")
