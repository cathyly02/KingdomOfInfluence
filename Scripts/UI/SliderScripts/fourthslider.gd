extends HSlider

signal changeFourthSlider(value)

func _ready() -> void:
	value_changed.connect(_on_slider_value_changed)
	
func _on_slider_value_changed(value: float) -> void:
	emit_signal("changeFourthSlider", value)
