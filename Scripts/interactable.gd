extends Area3D

# InteractableItem.gd
@onready var interact_label = $LabelPivot
@onready var camera = get_viewport().get_camera_3d()

func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _process(delta):
	if camera and interact_label:
		interact_label.look_at(camera.global_transform.origin, Vector3.UP)

func _on_body_entered(body):
	print("SHOW E")
	if body.name == "Player":
		interact_label.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		interact_label.visible = false
