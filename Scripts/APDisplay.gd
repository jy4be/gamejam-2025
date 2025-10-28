extends Node2D

class_name  APDisplay

var apIcons: Array[Sprite2D]

func _ready() -> void:
	apIcons.assign(get_children())
	
func setAPAmount(amount: int) -> void:
	for i in range(len(apIcons)):
		apIcons[i].visible = i < amount
