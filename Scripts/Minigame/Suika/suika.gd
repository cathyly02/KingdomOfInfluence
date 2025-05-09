extends Node2D  # or Control, depending on your root

# Reference the Label node
@onready var score_label = $ScoreLabel

# A variable to track score
var score = 0

func _ready():
	update_label()

func update_label():
	score_label.text = "Score: %d" % score
	
func increase_score(amount: int):
	score += amount
	print("Score is now: %d" % score)
	update_label()
	


func _on_next_scene_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Worlds/Spawn.tscn")
