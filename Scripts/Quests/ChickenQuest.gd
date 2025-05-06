class_name ChickenQuest extends QuestManager

@export var chicken: PackedScene
@export var world_size := Vector3(40, 0, 40) # Width (x), Height (ignored here), Depth (z)
@export var spawn_height := 1 # Y position where objects spawn (e.g., ground level)
var questLevel: int = 1

# start the quest
func startQuest() -> void:
	# check if quest is available to start
	if (questStatus == QuestStatus.available):
		# start quest
		newQuest()
		for i in requiredCount:
			print("chicken spawned")
			var instance = chicken.instantiate()
			add_child(instance)
			var x = randf_range(-world_size.x / 2, world_size.x / 2)
			var z = randf_range(-world_size.z / 2, world_size.z / 2)
			instance.global_position = Vector3(x, spawn_height, z)

func updateQuest() -> void:
	incrementCounter()
	if (currentCount >= requiredCount):
		questGoalReached()

func questGoalReached() -> void:
	if (questStatus == QuestStatus.started):
		questGoalComplete()
		questLevel += 1

func endQuest() -> void:
	if questStatus == QuestStatus.reachedGoal:
		# remove quest label?
		# maybe log quest somewhere?
		finishQuest()
		# TODO: rewards, control what happens after quest is finished
		# for chicken quest we go to kingdom scene
		call_deferred("go_to_kingdom")

func go_to_kingdom():
	get_tree().change_scene_to_file("res://Scenes/TheKingdom.tscn")
