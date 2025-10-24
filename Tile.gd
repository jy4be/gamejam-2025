extends Node
class_name Tile

@onready var sprite: Sprite2D = $Sprite2D


func getSize() -> Vector2i:
	return Vector2i(sprite.get_rect().size)
