extends Node

@onready var ui = get_node("UI")
var inventory_open = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		inventory_open = !inventory_open
		ui.visible = inventory_open
