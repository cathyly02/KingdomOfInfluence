extends CanvasLayer
signal fade_completed

@onready var anim_player = $AnimationPlayer
@onready var color_rect = $ColorRect

func _ready():
	# Make sure our color_rect is invisible at start
	if color_rect:
		color_rect.modulate.a = 0
	
	# Debug to check if AnimationPlayer exists
	print("Children of this node:")
	for child in get_children():
		print("- ", child.name, " (", child.get_class(), ")")
	
	print("AnimationPlayer exists: ", anim_player != null)
	

func fade_in():
	if anim_player != null:
		anim_player.play("fade_in")    
		await anim_player.animation_finished
		emit_signal("fade_completed")
	else:
		print("AnimationPlayer not found!")
		
func fade_out():
	if anim_player != null:
		anim_player.play("fade_out")
		await anim_player.animation_finished
		emit_signal("fade_completed")
	else:
		print("AnimationPlayer not found!")
