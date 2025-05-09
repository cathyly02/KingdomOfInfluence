extends Button

# variables for UI screens
var currentUI
var nextUI

# variable for username box
var nameBox
var username


# initialize variables
func _ready():
	# get nodes of ui
	currentUI = get_tree().current_scene.get_node("Node3D/CanvasLayer/UI/CharacterCustomization")
	nextUI = get_tree().current_scene.get_node("Node3D/CanvasLayer/UI/PersonalityCustomization")
	nameBox = get_tree().current_scene.get_node("Node3D/CanvasLayer/UI/CharacterCustomization/MarginContainer/VBoxContainer/LineEdit")
	var data = PlayerData.get_customization()
	# check if data is there
	if (data["name"] != ""):
		# set text to data NOTE: for back button
		nameBox.text = data["name"]
	

# switch to personallity screen
func personalityUI():
	username = nameBox.text
	# save username
	PlayerData.save_customization(0, username, 0.0, 0.0, 0.0, 0.0)
	# turn off visibility of current ui
	currentUI.visible = false
	# get player node
	var player = get_tree().current_scene.get_node("Node3D/Player")
	# toggle player visibility
	player.toggleVisibilityChar()
	# next ui is visible
	nextUI.visible = true
