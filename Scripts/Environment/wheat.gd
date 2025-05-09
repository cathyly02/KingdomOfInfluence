extends MeshInstance3D

@export var stageA: Texture2D
@export var stageB: Texture2D


func _ready():
	if mesh:  # Check if the mesh exists
		var new_material = StandardMaterial3D.new()
		new_material.albedo_color = Color.RED  # Example: Set material color
		mesh.surface_set_material(0, new_material)  # Assign to first surface
	else:
		print("No mesh assigned to this MeshInstance3D!")

func clear_mesh():
	mesh = null 
	
func addMesh():
	var material = StandardMaterial3D.new()
	material.albedo_texture = stageA
	mesh.material = material
