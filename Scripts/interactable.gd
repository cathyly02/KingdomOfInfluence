extends Area3D

# InteractableItem.gd
@export var useInteractFunction: bool
@export var interfaceFunc: Node
@export var interactString: String

var player_in_area := false
#static var interacted_this_frame := false

@onready var interact_label = $LabelPivot
@onready var camera = get_viewport().get_camera_3d()
func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	interact_label.get_child(0).text = interactString

func _process(delta):
	if camera and interact_label:
		interact_label.look_at(camera.global_transform.origin, Vector3.UP)
	if interact_label.visible and useInteractFunction \
		and Input.is_action_just_pressed("interact"):
		#and not interacted_this_frame:
			interfaceFunc.interact()
			interact_label.visible = false;
			#interacted_this_frame = true

func _on_body_entered(body):
	var parentNode = get_parent()
	if parentNode.interactable == true:
		if body.name == "Player":
			#print("I Am Here")
			interact_label.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		interact_label.visible = false
