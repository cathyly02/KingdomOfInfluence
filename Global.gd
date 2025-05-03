extends Node

# Global.gd
var current_npc: Node = null

func startNPCQuest() -> void:
	# start quest
	current_npc.get_node("Quest").startQuest()
