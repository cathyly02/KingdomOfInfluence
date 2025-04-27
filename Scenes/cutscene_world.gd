extends Node3D

# Use a different approach to get the AnimationPlayer
var animation_player

func _ready():
	# First find the AnimationPlayer before trying to use it
	animation_player = find_animation_player()
	
	if animation_player:
		# Start the animation as soon as the scene loads
		animation_player.play("camera")  # Make sure this matches your animation name
		
		# Connect to the animation_finished signal
		animation_player.animation_finished.connect(_on_animation_finished)
		print("Animation started successfully")
	else:
		print("ERROR: AnimationPlayer not found!")
	
	# ENVIRONMENT SETUP
	# Create environment resource
	var env = Environment.new()
	
	# Sky setup for clear spring day
	var sky = Sky.new()
	var sky_material = PhysicalSkyMaterial.new()
	
	# Bright blue sky
	sky_material.rayleigh_coefficient = 1.0  # Lower for more blue, less haziness
	sky_material.mie_coefficient = 0.001     # Very low for crisp, clear day
	sky_material.rayleigh_color = Color(0.3, 0.5, 1.0)  # Blue sky color
	sky_material.sun_disk_scale = 5.0        # Smaller, crisper sun
	
	sky.sky_material = sky_material
	env.sky = sky
	env.background_mode = Environment.BG_SKY
	
	# Minimal fog for crystal clear air
	env.fog_enabled = true
	env.fog_light_color = Color(0.8, 0.9, 1.0)  # Slight blue tint
	env.fog_density = 0.002                      # Very minimal fog
	env.fog_aerial_perspective = 0.5             # Distant mountains slightly blue
	
	# Bright, clear lighting
	env.ambient_light_color = Color(0.6, 0.65, 0.7)  # Slight blue ambient
	env.ambient_light_energy = 0.5                    # Moderate ambient light
	
	# Sharp shadows and details
	env.ssao_enabled = true
	env.ssao_radius = 1.0
	env.ssao_intensity = 1.0
	
	# Subtle bloom for spring flowers and dewdrops
	env.glow_enabled = true
	env.glow_intensity = 0.3
	env.glow_bloom = 0.2
	env.glow_blend_mode = Environment.GLOW_BLEND_MODE_SOFTLIGHT
	
	# Fresh spring colors
	env.adjustment_enabled = true
	env.adjustment_saturation = 1.05        # Slightly more vibrant
	env.adjustment_contrast = 1.05          # Slightly more contrast
	env.adjustment_brightness = 1.05        # Slightly brighter
	
	# Apply environment to cameras
	apply_environment_to_cameras(env)
	
	# Add pollen particles throughout the map
	add_pollen_throughout_map()
	
	# Add a proper sun light
	add_sun_light()

# Helper function to find the AnimationPlayer anywhere in the scene
func find_animation_player():
	# First check if it's a direct child
	if has_node("AnimationPlayer"):
		return get_node("AnimationPlayer")
	
	# If not, search recursively through all children
	var animation_players = find_nodes_of_type("AnimationPlayer")
	if animation_players.size() > 0:
		return animation_players[0]
	
	return null

# Helper function to find nodes of a specific type
func find_nodes_of_type(type_name):
	var result = []
	var nodes = get_children()
	var index = 0
	
	while index < nodes.size():
		var node = nodes[index]
		
		if node.get_class() == type_name:
			result.push_back(node)
		
		# Add this node's children to the list to process
		var children = node.get_children()
		for child in children:
			nodes.push_back(child)
		
		index += 1
	
	return result

func apply_environment_to_cameras(env):
	# Apply to viewport camera
	var viewport_camera = get_viewport().get_camera_3d()
	if viewport_camera:
		viewport_camera.environment = env
	
	# Find all cameras in the scene and apply environment
	var cameras = find_nodes_of_type("Camera3D")
	for camera in cameras:
		camera.environment = env
	
	print("Environment applied to cameras")

func _on_animation_finished(anim_name):
	print("Animation finished: " + anim_name)
	# Transition to menu scene
	# Uncomment this when you're ready:
	# get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func add_pollen_throughout_map():
	# Create pollen particle system
	var pollen = GPUParticles3D.new()
	add_child(pollen)
	
	# Create particle material
	var particle_material = ParticleProcessMaterial.new()
	
	# Set emission shape to a large box covering the map
	particle_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	particle_material.emission_box_extents = Vector3(50, 10, 50)  # Adjust to your map size
	
	# Set particle behavior for gentle floating pollen
	particle_material.direction = Vector3(0, -0.05, 0)  # Very slight downward drift
	particle_material.spread = 180.0                    # All directions
	particle_material.gravity = Vector3(0, -0.01, 0)    # Almost no gravity
	
	# Random gentle movement
	particle_material.initial_velocity_min = 0.05
	particle_material.initial_velocity_max = 0.15
	particle_material.linear_accel_min = -0.02
	particle_material.linear_accel_max = 0.02
	particle_material.radial_accel_min = -0.02
	particle_material.radial_accel_max = 0.02
	
	# Slow rotation
	particle_material.angular_velocity_min = 0.1
	particle_material.angular_velocity_max = 0.5
	particle_material.angle_min = 0
	particle_material.angle_max = 360
	
	# Small varying sizes for pollen
	particle_material.scale_min = 0.01
	particle_material.scale_max = 0.03
	
	# Color for pollen (pale yellow/white)
	var gradient = GradientTexture1D.new()
	var color_gradient = Gradient.new()
	color_gradient.add_point(0.0, Color(1.0, 1.0, 0.9, 0.3))   # Yellowish white
	color_gradient.add_point(0.5, Color(1.0, 0.98, 0.8, 0.4))  # Pale yellow
	color_gradient.add_point(1.0, Color(0.95, 0.95, 0.8, 0.2)) # Transparent pale yellow
	gradient.gradient = color_gradient
	particle_material.color_ramp = gradient
	
	# Set material to particles
	pollen.process_material = particle_material
	
	# Create mesh for pollen (small spheres)
	var pollen_mesh = SphereMesh.new()
	pollen_mesh.radius = 0.02
	pollen_mesh.height = 0.04
	
	# Create material for pollen
	var pollen_material = StandardMaterial3D.new()
	pollen_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	pollen_material.albedo_color = Color(1.0, 1.0, 0.9, 0.5)
	pollen_material.emission_enabled = true
	pollen_material.emission = Color(1.0, 1.0, 0.8, 0.3)
	pollen_material.emission_energy = 0.2
	pollen_mesh.material = pollen_material
	
	pollen.draw_pass_1 = pollen_mesh
	
	# Configure particle system for widespread, long-lasting pollen
	pollen.amount = 1000          # Lots of particles
	pollen.lifetime = 20.0        # Long lifetime
	pollen.randomness = 1.0
	pollen.visibility_aabb = AABB(Vector3(-60, -15, -60), Vector3(120, 40, 120))  # Large visibility area
	pollen.emitting = true
	
	# Position the emitter to cover the whole map
	# This will be centered on the origin, adjust if needed
	pollen.global_position = Vector3(0, 10, 0)  # Height above the ground
	
	print("Pollen particles added throughout the map!")

func add_sun_light():
	var sun = DirectionalLight3D.new()
	add_child(sun)
	
	# Position for mid-morning/afternoon sun
	sun.rotation_degrees = Vector3(-45, -30, 0)
	
	# Clean, bright sunlight (pure white, not yellow)
	sun.light_color = Color(1.0, 0.99, 0.97)
	sun.light_energy = 1.2
	
	# Enable shadows for depth
	sun.shadow_enabled = true
	sun.shadow_bias = 0.04        # Reduce shadow acne
	sun.shadow_normal_bias = 1.0  # Improve shadow quality
	
	print("Sun light added!")
