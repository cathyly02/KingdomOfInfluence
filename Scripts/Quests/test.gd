extends Area3D

@export var quest: ChickenQuest

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if (body.name == "Player"):
		quest.startQuest()
		
		# maybe spawn the quest chickens here?
