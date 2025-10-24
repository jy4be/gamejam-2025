extends Node2D
class_name Tile

@onready var sprite: Sprite2D = $Sprite2D


func getSize() -> Vector2i:
	return Vector2i(sprite.get_rect().size)


func _on_area_2d_mouse_entered() -> void:
	SignalBus.MouseTileHover.emit($".")


func _on_area_2d_mouse_exited() -> void:
	SignalBus.MouseTileExit.emit($".")
