class_name FollowGuard extends QuestManager


@export var ground_height := 1.5 # Y position where objects spawn (e.g., ground level)
@export var closeness_percentage : float = 0.85 # player needs to be next to knight 85% of the time
@export_subgroup("NPC Walk Locations")
@export var walk_locations: Array[Vector3] = [Vector3()]

var startingSpot := Vector3(3, 1.5, 53)
var questLevel: int = 1
var quest_began : bool = false
var near_guard_points : int = 0
var away_guard_points : int = 0
var total_points : float = 0.0
var total_score : float = 0.0
var guard_delta : float = 0.0
func _process(delta):
	guard_delta = delta

func _ready() -> void:
	walk_locations.append(startingSpot)

# start the quest
func startQuest() -> void:
	# check if quest is available to start
	if (questStatus == QuestStatus.available):
		# start quest
		newQuest()
		quest_began = true
		# make npc walk
		var movement_body = get_parent().get_parent()
		var cyl = movement_body.get_child(5)
		var num = 0
		for each_location in walk_locations:
			var corrected_location = Vector3(each_location.x, ground_height, each_location.z)
			movement_body.move_to_position(corrected_location)
			#print(str(corrected_location) + " : Index " + str(num)) DEBUG: prints walking locations
			num += 1
			while !movement_body.ready_for_next_direction:
				await get_tree().create_timer(guard_delta).timeout 
				if !GameManager.inventory_open:
					if cyl.player_in_cylinder:
						near_guard_points += 1
					else:
						away_guard_points += 1
					changePercentage(near_guard_points, away_guard_points)
		total_points = near_guard_points + away_guard_points
		total_score = near_guard_points / total_points
		if total_score > closeness_percentage:
			questGoalReached() 
		else:
			setQuestToFailed()
		print("Points Close: " + str(near_guard_points) + "\n" +
			  "Points Away: " + str(away_guard_points) + "\n" +
			  "Score: " + str(total_score))
		quest_began = false
		movement_body.rotate_to_angle(45)

#func updateQuest() -> void:
	#incrementCounter()
	#if (currentCount >= requiredCount):
		#questGoalReached()

func questGoalReached() -> void:
	if (questStatus == QuestStatus.started):
		questGoalComplete()
		questLevel = 2

func endQuest() -> void:
	if questStatus == QuestStatus.reachedGoal:
		# remove quest label?
		# maybe log quest somewhere?
		finishQuest()
		
		# TODO: rewards, control what happens after quest is finished

func changePercentage(near_points : int, away_points : int) -> void:
	var new_max = near_points + away_points
	updatePercentage(near_points, new_max)

func setQuestToFailed() -> void:
	questLevel = -1
	failQuest()
	
func restartQuest() -> void:
	restartQuestToAvailable()
	questLevel = 1
	near_guard_points = 0
	away_guard_points = 0
	total_points = 0.0
	total_score = 0.0
	
