extends Node3D

@onready var currentNPC = Global.current_npc

func interact() -> void:
	currentNPC.get_node("Quest").updateQuest()
	self.get_parent().queue_free()
