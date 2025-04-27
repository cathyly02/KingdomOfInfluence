extends Node3D

# Preload your menu scene
var menu_scene = preload("res://Scenes/Menu.tscn")

func _ready():
	# Start your cutscene sequence
	$AnimationPlayer.play("intro_sequence")
	
func _process(delta):
	# Allow skipping with input
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_accept"):
		_skip_cutscene()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "intro_sequence":
		# When animation finishes, transition to menu
		get_tree().change_scene_to_packed(menu_scene)
		
func _skip_cutscene():
	# Handle skipping the cutscene
	$AnimationPlayer.stop()
	get_tree().change_scene_to_packed(menu_scene)
