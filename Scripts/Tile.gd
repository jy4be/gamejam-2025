extends Node2D
class_name Tile

var bus = SignalBus

@onready var sprite: Sprite2D = $Sprite2D


func getSize() -> Vector2i:
	return Vector2i(sprite.get_rect().size)


func _on_area_2d_mouse_entered() -> void:
	bus.MouseHover.emit($".")


func _on_area_2d_mouse_exited() -> void:
	pass
