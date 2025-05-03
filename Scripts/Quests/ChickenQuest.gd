class_name ChickenQuest extends QuestManager

# start the quest
func startQuest() -> void:
	# check if quest is available to start
	if (questStatus == QuestStatus.available):
		# start quest
		newQuest()

func questGoalReached() -> void:
	if (questStatus == QuestStatus.started):
		questGoalComplete()

func endQuest() -> void:
	if questStatus == QuestStatus.reachedGoal:
		# remove quest label?
		# maybe log quest somewhere?
		finishQuest()
		
		# TODO: rewards, control what happens after quest is finished
