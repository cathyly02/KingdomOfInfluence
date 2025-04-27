extends Node3D

func _ready():
	# Create falling leaves particles
	add_falling_leaves()
	
	# Optionally add more particle systems
	add_dust_motes()

func add_falling_leaves():
	# Create GPUParticles3D node
	var leaves = GPUParticles3D.new()
	add_child(leaves)
	
	# Create particle material
	var particle_material = ParticleProcessMaterial.new()
	
	# Set emission shape (box area)
	particle_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	particle_material.emission_box_extents = Vector3(20, 5, 20)  # Adjust to your scene size
	
	# Set particle behavior
	particle_material.direction = Vector3(0, -1, 0)
	particle_material.spread = 15.0
	particle_material.gravity = Vector3(0, -0.5, 0)  # Light gravity
	particle_material.initial_velocity_min = 0.2
	particle_material.initial_velocity_max = 0.5
	particle_material.angular_velocity_min = 1.0
	particle_material.angular_velocity_max = 3.0
	particle_material.linear_accel_min = -0.1
	particle_material.linear_accel_max = 0.1
	
	# Randomize rotation
	particle_material.angle_min = -180
	particle_material.angle_max = 180
	
	# Set particle appearance
	particle_material.scale_min = 0.1
	particle_material.scale_max = 0.2
	
	# Particle color variation (greens and light browns)
	var gradient = GradientTexture1D.new()
	var color_gradient = Gradient.new()
	color_gradient.add_point(0.0, Color(0.2, 0.4, 0.1, 1.0))
	color_gradient.add_point(0.3, Color(0.3, 0.5, 0.2, 1.0))
	color_gradient.add_point(0.7, Color(0.4, 0.6, 0.2, 1.0))
	color_gradient.add_point(1.0, Color(0.5, 0.4, 0.2, 1.0))
	gradient.gradient = color_gradient
	particle_material.color_ramp = gradient
	
	# Set material to particles
	leaves.process_material = particle_material
	
	# Create mesh for particles
	var leaf_mesh = QuadMesh.new()
	leaf_mesh.size = Vector2(0.2, 0.2)
	leaves.draw_pass_1 = leaf_mesh
	
	# Configure particle system
	leaves.amount = 200
	leaves.lifetime = 10.0
	leaves.randomness = 1.0
	leaves.visibility_aabb = AABB(Vector3(-25, -10, -25), Vector3(50, 30, 50))
	leaves.emitting = true

func add_dust_motes():
	# Create GPUParticles3D node
	var dust = GPUParticles3D.new()
	add_child(dust)
	
	# Create particle material
	var particle_material = ParticleProcessMaterial.new()
	
	# Set emission shape (box area)
	particle_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	particle_material.emission_box_extents = Vector3(15, 10, 15)
	
	# Set particle behavior
	particle_material.direction = Vector3(0, 0.01, 0)
	particle_material.spread = 180.0
	particle_material.gravity = Vector3(0, 0.01, 0)  # Almost no gravity
	particle_material.initial_velocity_min = 0.02
	particle_material.initial_velocity_max = 0.05
	
	# Set particle appearance
	particle_material.scale_min = 0.02
	particle_material.scale_max = 0.05
	
	# Particle color (white/transparent)
	particle_material.color = Color(1.0, 1.0, 1.0, 0.2)
	
	# Set material to particles
	dust.process_material = particle_material
	
	# Create mesh for particles
	var dust_mesh = QuadMesh.new()
	dust_mesh.size = Vector2(0.05, 0.05)
	dust.draw_pass_1 = dust_mesh
	
	# Configure particle system
	dust.amount = 500
	dust.lifetime = 30.0
	dust.randomness = 1.0
	dust.emitting = true
