class_name QuestManager extends Node3D

# ui stuff
@onready var questContainer: VBoxContainer = GameManager.get_node("UI").get_node("QuestContainer")

# quest specific stuff
@export var questString: String # name of quest
@export var reachedGoalText: String # ui description text after reaching goal
# enable if need to keep a count (like chickens collected
@export var useCounter: bool = false 
@export var requiredCount: int = 0
@export var retryable : bool = true # if false, quest status wont be reset upon failure

@export var usePercentage: bool = false
@export var decimalPoint: int = 1
var currentCount: int = 0

var questLabel: Label

#quest statuses
enum QuestStatus
{
	available,
	started,
	reachedGoal,
	finished, 
	failed
}

@export var questStatus: QuestStatus = QuestStatus.available

#@export_group("Reward Settings")
#@export var reward_amount: int
#@export var xp_amount: int

func newQuest():
	# update quest status to start
	questStatus = QuestStatus.started
	
	questLabel = Label.new()
	questLabel.text = questString
	
	if useCounter:
		questLabel.text = questString + " (0/" + str(requiredCount) + ")"
	elif usePercentage:
		questLabel.text = questString + " (" + "0" + "%)"
	else:
		questLabel.text = questString

	#questLabel.custom_minimum_size = Vector2(200, 30)  # You can tweak this
	questLabel.add_theme_font_size_override("font_size", 10)  # Optional: make text bigger

	questContainer.add_child(questLabel)

func questGoalComplete():
	questLabel.text = reachedGoalText
	questStatus = QuestStatus.reachedGoal

func finishQuest():
	# this just deletes the label
	questLabel.queue_free()

func incrementCounter():
	if not useCounter or questStatus != QuestStatus.started:
		return
	
	currentCount += 1
	
	if (currentCount < requiredCount):
		questLabel.text = questString + " (" + str(currentCount) + "/" + str(requiredCount) + ")"

func updatePercentage(number : int, max : int):
	if not usePercentage or questStatus != QuestStatus.started:
		return
	
	var true_percentage : float = 0.0
	true_percentage = float(number) / float(max)
	true_percentage *= 100
	
	true_percentage = round_to_decimals(true_percentage)
	questLabel.text = questString + " (" + str(true_percentage) + "%)"
	
func round_to_decimals(value: float) -> float:
	var factor = pow(10, decimalPoint)
	return round(value * factor) / factor

func failQuest():
	questStatus = QuestStatus.failed

func restartQuestToAvailable():
	questStatus = QuestStatus.available
	

	
