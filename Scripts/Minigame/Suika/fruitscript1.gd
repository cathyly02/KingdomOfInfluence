extends RigidBody2D

@export var fruit_type: int = 1
@export var fruit_scenes: Array[PackedScene] 
var main = null

func _ready():
	#print("Ready Fruit lv", fruit_type, "Name:", name)
	contact_monitor = true
	max_contacts_reported = 10
	main = get_node("/root/Main")
	
	if fruit_scenes.is_empty():
		#print("Fruit scenes empty, loading manually")
		fruit_scenes = [
			preload("res://Scenes/Packed Scenes/fruit1.tscn"),
			preload("res://Scenes/Packed Scenes/fruit2.tscn"),
			preload("res://Scenes/Packed Scenes/fruit3.tscn"),
			preload("res://Scenes/Packed Scenes/fruit4.tscn"),
			preload("res://Scenes/Packed Scenes/fruit5.tscn")
		]
	#print("Fruit scenes loaded:", fruit_scenes.size())

func set_fruit_type(value: int) -> void:
	#print("Setting fruit type from", fruit_type, "to", value)
	fruit_type = value

func _integrate_forces(state: PhysicsDirectBodyState2D):
	# Check if we are getting contacts
	#print("Integrating forces for:", name, "with", state.get_contact_count(), "contacts")
	
	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)
		if collider != self:
			#print("Contact with:", collider)
			
			if collider is RigidBody2D:
				if global_position.y > 0:
					#print("Our Y position > 0:", global_position.y)
					if collider.has_method("get_fruit_type"):
						var other_type = collider.get_fruit_type()
						#print("Collider fruit type:", other_type)
						
						if other_type == fruit_type:
							#print("Same fruit type detected:", fruit_type)
							if self.get_instance_id() < collider.get_instance_id():
								#print("Handling combination. Our ID:", self.get_instance_id(), "Other ID:", collider.get_instance_id())
								_combine_with(collider)
								main.increase_score(10)
							else:
								print("Letting other handle the combination")

func _combine_with(other: RigidBody2D):
	#print("Combining", name, "with", other.name)
	
	if fruit_type >= 5:
		#print("Max fruit level reached. No further upgrade.")
		return
		
	var next_type = fruit_type + 1
	#print("Creating next fruit type:", next_type)
	
	var next_fruit_scene = fruit_scenes[next_type - 1]
	
	if next_fruit_scene:
		var new_fruit = next_fruit_scene.instantiate()
		new_fruit.global_position = (global_position + other.global_position)/2
		#print("Spawning new fruit at:", new_fruit.global_position)
		get_parent().add_child(new_fruit)
		
		queue_free()
		other.queue_free()
	else:
		print("Missing scene for next fruit type:", next_type)

func get_fruit_type() -> int:
	return fruit_type
