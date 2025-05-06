extends Area3D

#check if player is inside area
var inside = false
var bodyName
var interactable = true
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

#check if player endered area
func _on_body_entered(body):
	bodyName = body.name
	if bodyName == "Player":
		print(body.name, " entered the area!")
		inside = true

#check if plauer exited bodyu
func _on_body_exited(body):
	print(body.name, " left the area!")
	inside = false

func _process(delta: float) -> void:
	# checks if inside body
	if inside:
		print("inside")
		if Input.is_action_just_pressed("interact"):
			var result = get_tree().change_scene_to_file("res://Scenes/rhythm.tscn")
