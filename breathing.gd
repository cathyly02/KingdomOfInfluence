extends Area3D

@export var stageA: Texture2D
@export var stageB: Texture2D

@onready var parent_node = get_child(0)
@onready var animator = get_node("/root/world/PlayerMovement/Player/AnimationPlayer")
@onready var player = get_node("/root/world/PlayerMovement/Player")

var interactable = true
var inside = false
var isBreathingGameActive = false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		print("Player entered the breathing area!")
		inside = true

func _on_body_exited(body):
	if body.name == "Player":
		print("Player exited the breathing area!")
		inside = false
		isBreathingGameActive = false

func _process(delta: float) -> void:
	if inside and Input.is_action_just_pressed("interact") and not isBreathingGameActive:
		print("Starting breathing game...")
		isBreathingGameActive = true
		
		#animator.play("res://testing/sitting_idle.tscn")
	
	if isBreathingGameActive:
		
		handle_breathing_input()

func handle_breathing_input():
	var space = Input.is_action_pressed("ui_accept")  # Space bar
	var alt = Input.is_key_pressed(KEY_ALT)

	if space and not alt:
		print("Inhaling...")
	elif space and alt:
		print("Holding breath...")
	elif not space and alt:
		print("Exhaling...")
