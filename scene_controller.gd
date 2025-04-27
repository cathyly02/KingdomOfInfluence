extends Node
@onready var fade_transition = $FadeTransition
@onready var loading_screen = $LoadingScreen
var menu_scene = preload("res://Scenes/Menu.tscn")

func _ready():
	# Hide loading screen initially
	loading_screen.visible = false
	
	# Start with fade from black
	fade_transition.fade_in()
	await fade_transition.fade_completed
	
	# Show loading screen
	loading_screen.visible = true
	
	# Simulate loading time (replace with actual loading later)
	await get_tree().create_timer(2.0).timeout
	
	# Prepare to transition to menu
	fade_transition.fade_out()
	await fade_transition.fade_completed
	
	# Hide loading screen
	loading_screen.visible = false
	
	# Instance the menu 
	var menu_instance = menu_scene.instantiate()
	add_child(menu_instance)
