extends Node

@onready var fade_transition = $FadeTransition
@onready var loading_screen = $Cutscene
@onready var cutscene_animation_player = get_node("Cutscene/camRig/AnimationPlayer")
var menu_scene = preload("res://Scenes/UI Scenes/Menu.tscn")
@onready var menu_Screen = $Menu

func _ready():
	# Hide loading screen initially
	loading_screen.visible = false
	menu_Screen.visible = false
	
	# Show loading screen
	loading_screen.visible = true
	
	# Play cutscene animation
	print("Starting cutscene animation")
	cutscene_animation_player.play("camera")
	print("Waiting for animation to finish")
	await cutscene_animation_player.animation_finished
	print("Animation finished - starting fade out")
	
	# Start with fade from black
	fade_transition.fade_in()
	await fade_transition.fade_completed
	
	# Hide loading screen after the fade-in is done
	loading_screen.visible = false
	menu_Screen.visible = true
	
	# Fade out to black
	fade_transition.fade_out()
	await fade_transition.fade_completed
	
	# Now change the scene after the fade-out
	get_tree().change_scene_to_packed(menu_scene)
