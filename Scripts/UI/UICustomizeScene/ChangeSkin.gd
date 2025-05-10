# extends out of the player (type CharacterBody3d)
extends CharacterBody3D

# array of skins (created when game starts)
@export var skins: Array[Texture2D]
# current skin
var current_skin = 0
# check if user is dragging mouse
var draggable = false
var isDragging = false
var last_mouse_position = Vector2()
var rotation_speed = 0.01  # Adjust rotation sensitivity
# definable later via signals
var first_slider_value = 0.0
var second_slider_value = 0.0
var third_slider_value = 0.0
var fourth_slider_value = 0.0

# finds mech on player
@onready var mesh = $GeneralSkeleton/characterMedium

# creates skinn aray - function starts on ready 
func _ready():
	#play idle animation
	var anim = $AnimationPlayer.get_animation("playerAnimPack/idle")
	anim.loop = true  # Correct way to set looping
	$AnimationPlayer.play("playerAnimPack/idle")

	# Apply the default skin (optional)
	if skins.size() > 0:
		change_skin(1)
	


# running while game is playing
func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("Left Mouse Button") and not isDragging:
			# Start dragging when the button is pressed
			isDragging = true
			print("Started dragging")
			last_mouse_position = get_viewport().get_mouse_position()  # Store offset from mouse position

		elif Input.is_action_pressed("Left Mouse Button") and isDragging:
			var current_mouse_position = get_viewport().get_mouse_position()
			var mouse_delta = current_mouse_position - last_mouse_position  # Calculate mouse movement
			last_mouse_position = current_mouse_position  # Update last position
			print("Dragging")
			
			# Rotate character based on horizontal mouse movement (yaw rotation)
			rotate_y(mouse_delta.x * rotation_speed)

		elif Input.is_action_just_released("Left Mouse Button") and isDragging:
			# Stop dragging when the button is released
			isDragging = false
			print("Stopped dragging")

# change skin (amount = left/right)
func change_skin(amount):
	if skins.is_empty():
		print("No skins assigned!")
		return

	# Cycle through the skins (left = backwords; right = forwards)
	current_skin = (current_skin + amount) % skins.size()

	# Create a new material and assign the texture
	var material = StandardMaterial3D.new()
	material.albedo_texture = skins[current_skin]

	# Apply the new material to the mesh
	mesh.material_override = material

# button press for left
func leftChoice():
	print("Left Button pressed")
	change_skin(-1)

# button press for right
func rightChoice():
	print("Right Button pressed")
	change_skin(1)

# area that user can drag to rotate char
func mouseEntered():
	if not isDragging:
		draggable = true
		print("Is draggable")

# checking if user exited dragging area
func mouseExited():
	if not isDragging:
		draggable = false
		print("Is not draggable")

# toggle visibility of char (changing ui)
func toggleVisibilityChar():
	visible = !visible
	print("Char visibility")
	
func apply_customization():
	var data = PlayerData.get_customization()
	var name
	# check if name is there
	if (data["name"] != ""):
		# set text to data 
		name = data["name"]
		PlayerData.save_customization(current_skin, name, first_slider_value, second_slider_value, third_slider_value, fourth_slider_value)
	else:
		PlayerData.save_customization(current_skin, "", first_slider_value, second_slider_value, third_slider_value, fourth_slider_value)


func _on_h_slider_change_first_slider(value):
	first_slider_value = value

func _on_h_slider_change_second_slider(value):
	second_slider_value = value

func _on_h_slider_change_third_slider(value):
	third_slider_value = value

func _on_h_slider_change_fourth_slider(value):
	fourth_slider_value = value
