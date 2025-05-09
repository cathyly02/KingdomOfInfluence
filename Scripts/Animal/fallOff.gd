extends Area3D
# In Godot, on Area3D body_entered signal
@export var spawnPoint: Vector3
func _ready():
	self.body_entered.connect(_on_body_entered)
func _on_body_entered(body):
	body.global_position = spawnPoint
