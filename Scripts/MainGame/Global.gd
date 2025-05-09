extends Node

# Global.gd
var current_npc: Node = null

func startNPCQuest() -> void:
	# start quest
	current_npc.get_node("Quest").startQuest()

func endNPCQuest() -> void:
	# end npc quest
	current_npc.get_node("Quest").endQuest()
	
func restartNPCQuest() -> void:
	# restart npc quest after failure
	current_npc.get_node("Quest").restartQuest()
