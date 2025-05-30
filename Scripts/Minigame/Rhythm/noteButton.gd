extends Sprite3D

@export var input: String  # fixed typo: "Stirng" → "String"
var isPressed = false

func _process(delta):
	change_sprite()

func change_sprite():
	var purple = load("res://Assets/UI/PNGs/purple.png")
	var blue = load("res://Assets/UI/PNGs/blue.png")

	if Input.is_action_pressed(input):  # use the value of the exported 'input' string
		texture = purple
		isPressed = true

	else:
		texture = blue
		isPressed = false
		
