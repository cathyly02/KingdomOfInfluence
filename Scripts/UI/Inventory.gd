extends Node

@onready var ui = get_node("UI")
var inventory_open = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	print(get_tree().current_scene.name)
	if (get_tree().current_scene.name != "Menu"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Inventory")\
	&& get_tree().current_scene.name != "Menu"\
	&& get_tree().current_scene.name != "ChangeSkin":
		inventory_open = !inventory_open
		ui.visible = inventory_open
		await pauseGame()

func pauseGame() -> void:
	get_tree().paused = inventory_open

	if inventory_open:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		await get_tree().process_frame
		await get_tree().create_timer(0.01).timeout
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
