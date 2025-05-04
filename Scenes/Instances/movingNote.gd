extends Sprite3D

@export var speed: float = 36.0
var target
var aabb1
var aabb2
var interacted = false
@onready var label =get_node("/root/rhythm/RandomStuff/Label3D2")
func _ready() -> void:
	if position.y == -8:
		target = get_node("/root/rhythm/down/Sprite3D")
	if position.y == -4:
		target = get_node("/root/rhythm/right/Sprite3D")
	if position.y == 0:
		target = get_node("/root/rhythm/left/Sprite3D")
	if position.y == 4:
		target = get_node("/root/rhythm/up/Sprite3D")
	

func _process(delta):
	translate(Vector3(0,-speed *delta,0))
	var self_pos = global_transform.origin
	var target_pos = target.global_transform.origin

	var size = Vector3(0.5, 0.5, 0.1)  # Adjust this to fit your sprite's visual bounds
	var self_aabb = AABB(self_pos - size * 0.5, size)
	var target_aabb = AABB(target_pos - size * 0.5, size)
	'''var greatSize = size *2
	var goodSize = size * 7
	var perSize = size * 0.05
	var self_aabb = AABB(self_pos - size * 0.5, size)
	var good_aabb = AABB(target_pos - goodSize * 0.5, goodSize)
	var great_aabb = AABB(target_pos - greatSize *0.5, greatSize)
	var perfect_aabb = AABB(target_pos - perSize *0.5, perSize)'''

	if !interacted and target.isPressed:
		'''if self_aabb.intersects(perfect_aabb):
			print("+3")
			interacted = true
			queue_free()
		elif self_aabb.intersects(great_aabb):
			print("+2")
			interacted = true
			queue_free()
		elif self_aabb.intersects(good_aabb):
			print("+1")
			interacted = true
			queue_free()'''
		if self_aabb.intersects(target_aabb):
			label.score += 1
			print(label.score)
			interacted = true
			queue_free()

	if global_transform.origin.x >= 10:
		texture = null
	if global_transform.origin.x >= 10.1:
		queue_free()
