extends Area3D

@onready var player = get_node_or_null("/root/world/PlayerMovement/Player")
@onready var ring_visual = load("res://Scenes/Packed Scenes/csg_torus_3d_knight.tscn")
@onready var ring_mat = load("res://Assets/Textures/Materials/green_color.tres")
@export var ring_radius : float = 6
@export var ring_width : float = 0.3
@export var ring_height_diff : float = 0.7

var player_in_cylinder = false
var quest_ongoing = false
var ring_array : Array[CSGTorus3D] 

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	get_child(0).shape.set_radius(ring_radius) # sets collision to proper radius
	#print(ring_visual.get_children())
	
	for i in range(0, 3):
		var new_ring = ring_visual.instantiate()
		add_child(new_ring)
		ring_array.append(new_ring)
		new_ring.set_inner_radius(ring_radius - ring_width) # sets inner ring
		new_ring.set_outer_radius(ring_radius) # sets outer ring
		new_ring.set_material(ring_mat)
		ring_mat = ring_mat.duplicate()
		new_ring.material = ring_mat
		new_ring.material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		new_ring.material.albedo_color.a = 1 - (0.3 * i)
		new_ring.position = Vector3(0, -1.8 + (ring_height_diff * i), 0)
	set_to_invisible()
	

func _on_body_entered(body):
	if (body == player && quest_ongoing):
		player_in_cylinder = true
		set_to_green()
		
		
func _on_body_exited(body):
	if (body == player && quest_ongoing):
		player_in_cylinder = false
		set_to_red()
		

func set_to_green():
	for i in range(0, 3):
		var each_torus = ring_array[i]
		each_torus.material.albedo_color = Color(0.0, 1.0, 0.0, (1 - (0.3 * i)))

func set_to_red():
	for i in range(0, 3):
		var each_torus = ring_array[i]
		each_torus.material.albedo_color = Color(1.0, 0.0, 0.0, (1 - (0.3 * i)))
		
func set_to_invisible():
	for i in range(0, 3):
		var each_torus = ring_array[i]
		each_torus.material.albedo_color = Color(0.0, 0.0, 0.0, 0.0)
