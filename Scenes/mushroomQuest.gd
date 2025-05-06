class_name mushroomQuest extends QuestManager


var questLevel: int = 1
# start the quest
func startQuest() -> void:
	# check if quest is available to start
	if (questStatus == QuestStatus.available):
		# start quest
		newQuest()
		

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
