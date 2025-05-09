extends Node2D

@export var move_speed := 200.0

# Constant array of the fruit scenes
const FRUIT_SCENES = [
	preload("res://Scenes/Packed Scenes/fruit1.tscn"), # 40%
	preload("res://Scenes/Packed Scenes/fruit2.tscn"), # 30%
	preload("res://Scenes/Packed Scenes/fruit3.tscn"), # 20%
	preload("res://Scenes/Packed Scenes/fruit4.tscn"), # 10%
	preload("res://Scenes/Packed Scenes/fruit5.tscn")  # 5%
]

const FRUIT_CHANCES = [40, 30, 20, 10, 5]

var preview_fruit: RigidBody2D = null
var current_fruit_scene = null

func get_random_fruit_scene():
	var total = 0
	for chance in FRUIT_CHANCES:
		total += chance
	var rand_num = randi() % total
	var cumulative = 0
	for i in range(FRUIT_CHANCES.size()):
		cumulative += FRUIT_CHANCES[i]
		if rand_num < cumulative:
			return FRUIT_SCENES[i]
	return FRUIT_SCENES[0]

func ready_fruit():
	current_fruit_scene = get_random_fruit_scene()
	preview_fruit = current_fruit_scene.instantiate()
	add_child(preview_fruit)
	var sprite := preview_fruit.get_node("Sprite2D")
	var sprite_height = sprite.texture.get_size().y * sprite.scale.y
	preview_fruit.global_position = global_position - Vector2(0, sprite_height / 2)
	preview_fruit.gravity_scale = 0.0

func _ready() -> void:
	ready_fruit()

func _input(event) -> void:
	if event.is_action_pressed("ui_accept") and preview_fruit:
		var drop_pos = global_position
		remove_child(preview_fruit)
		get_tree().root.get_child(0).add_child(preview_fruit)
		preview_fruit.global_position = drop_pos
		preview_fruit.gravity_scale = 1.0
		preview_fruit = null
		ready_fruit()
	if event.is_action_pressed("interact"):
		clear_all_root_children_except_self()
		get_tree().change_scene_to_file("res://Scenes/Worlds/Spawn.tscn")

func _process(delta: float) -> void:
	var dir := 0
	if Input.is_action_pressed("left"):
		dir = -1
	if Input.is_action_pressed("right"):
		dir += 1
	position.x += dir * move_speed * delta

func clear_all_root_children_except_self():
	var root = get_tree().root.get_child(0)
	for child in root.get_children():
		if child != self:
			child.queue_free()
