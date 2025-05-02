extends Node3D

# cam details
var sens = 0.005
var twist = 0.0
var pitch = 0.0
var inputDir

# get cam nodes
@onready var twistPivot = $Horizontal
@onready var pitchPivot = $Horizontal/Vertical
@onready var springArm = $Horizontal/Vertical/SpringArm3D
@onready var cam = $Horizontal/Vertical/SpringArm3D/Camera3D

func _ready():
	cam.make_current()

func _physics_process(delta: float) -> void:
	# rotate each based on rotationa nd pivot
	twistPivot.rotate_y(twist)
	pitchPivot.rotate_x(pitch)
	
	#make sure cam doesnt flip
	pitchPivot.rotation.x = clamp(
		pitchPivot.rotation.x,
		deg_to_rad(-90),
		deg_to_rad(45)
	)

	# makes sure the cam stops moving once mouse stops
	twist = 0.0
	pitch = 0.0
	
	# zoom in and out
	if Input.is_action_just_pressed("wheelUp"):
		if (springArm.spring_length > 0):
			springArm.spring_length -= 1
		
	if Input.is_action_just_pressed("wheelDown"):
		if (springArm.spring_length< 10):
			springArm.spring_length += 1

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist = -event.relative.x * sens
			pitch = -event.relative.y * sens
			
			
