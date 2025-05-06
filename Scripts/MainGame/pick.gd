extends Area3D

@export var stageA: Texture2D
@export var stageB: Texture2D
@onready var parent_node = get_child(0)
@onready var animator = get_node("/root/world/PlayerMovement/Player/AnimationPlayer")
@onready var player = get_node("/root/world/PlayerMovement/Player")
var interactable = true


func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

#check if player is inside area
var inside = false
var bodyName

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
		if Input.is_action_just_pressed("interact"):
			print("interacted")
			player.action = true
			# if wheat is grown, remove wheatr
			var first_child = parent_node.get_child(0)
			
			if first_child != null and animator.current_animation != "playerAnimPack2/pickingFruit":
				remove(first_child)


func remove(first_child):
		interactable = false
		
		animator.play("playerAnimPack2/pickingFruit")
		await get_tree().create_timer(5).timeout
		var childNode = $Interactable
		childNode.interact_label.visible = false
		player.action = false
		# remove instance of wheat
		if first_child != null:
			first_child.queue_free()  # Delete it safely
